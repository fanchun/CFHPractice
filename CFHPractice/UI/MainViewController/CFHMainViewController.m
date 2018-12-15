//
//  CFHMainViewController.m
//  CFHPractice
//
//  Created by Arthur Tseng on 2018/12/14.
//  Copyright © 2018 Arthur Tseng. All rights reserved.
//

#import "CFHMainViewController.h"
#import "DTGetPlantDataListRequest.h"
#import "CFHArrayDataSource.h"
#import "CFHMainTableViewCell.h"

#import <SVProgressHUD.h>

static const NSInteger DTGetPlantDataDefaultLimit = 20;

@interface CFHMainViewController () <UITableViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIView *mBottomView;

@property (strong, nonatomic) NSMutableArray *mDataResultsArray;
@property (strong, nonatomic) CFHArrayDataSource *mArrayDataSource;


@property (assign, nonatomic) NSUInteger mTotalPlantDataCount;
@property (assign, nonatomic) NSUInteger mCurrentPlantDataOffset;
@end

@implementation CFHMainViewController

- (void)initParameters {
    _mTotalPlantDataCount = 0;
    _mCurrentPlantDataOffset = 0;
}

- (void)setupTableView {
    
    CFHTableViewCellConfigureBlock configureCell = ^(CFHMainTableViewCell *cell, DTPlantInfo *plantInfo) {
        cell.nameLabel.text = plantInfo.nameCh;
        cell.LocationLabel.text = plantInfo.location;
        cell.featureLabel.text = plantInfo.feature;
    };
    
    self.mArrayDataSource = [[CFHArrayDataSource alloc] initWithItems:self.mDataResultsArray
                                                       cellIdentifier:CFHMainTableViewCellIndentifier
                                                   configureCellBlock:configureCell];
    self.mTableView.dataSource = self.mArrayDataSource;
    self.mTableView.delegate = self;
    [self.mTableView registerNib:[CFHMainTableViewCell nib] forCellReuseIdentifier:CFHMainTableViewCellIndentifier];
    
    self.mTableView.rowHeight = UITableViewAutomaticDimension;
    self.mTableView.estimatedRowHeight = CFHMainTableViewCellSize.height;
}

#pragma mark - Property

- (NSMutableArray *)mDataResultsArray {
    if (!_mDataResultsArray) {
        _mDataResultsArray = [NSMutableArray array];
    }
    return _mDataResultsArray;
}

- (void)setMCurrentPlantDataOffset:(NSUInteger)currentPlantDataOffset {
    if (currentPlantDataOffset > _mCurrentPlantDataOffset) {
        _mCurrentPlantDataOffset = currentPlantDataOffset;
    }
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParameters];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getPlantDataListWithLimit:DTGetPlantDataDefaultLimit];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (velocity.y > 0){
        NSUInteger remainDataCount = (self.mTotalPlantDataCount - self.mCurrentPlantDataOffset);
        if (remainDataCount > 0) {
            NSUInteger limit = (remainDataCount > DTGetPlantDataDefaultLimit) ? DTGetPlantDataDefaultLimit : remainDataCount;
            [self getPlantDataListWithLimit:limit];
        }
    }
}

#pragma mark - WebService API

- (void)getPlantDataListWithLimit:(NSUInteger)limit {
//    [SVProgressHUD show];
    DTGetPlantDataListRequest *request = [[DTGetPlantDataListRequest alloc] initWithLimit:limit offset:self.mCurrentPlantDataOffset];
    [request getWSSuccess:^(DTGetPlantDataListResponse * _Nonnull response) {
        
        //[SVProgressHUD dismiss];
        self.mTotalPlantDataCount = response.count;
        
//        [self.mDataResultsArray addObjectsFromArray:response.plantInfos];
//        [self.mTableView reloadData];
        
        
        NSMutableArray *arIndexPaths = [NSMutableArray arrayWithCapacity:response.count];
        NSUInteger currentDataCount = self.mDataResultsArray.count;
        for (NSInteger iIndex = 0; iIndex < response.plantInfos.count; iIndex ++) {
            [arIndexPaths addObject:[NSIndexPath indexPathForRow:currentDataCount + iIndex inSection:0]];
        }
        [self.mDataResultsArray addObjectsFromArray:response.plantInfos];
        [UIView performWithoutAnimation:^{
            [self.mTableView insertRowsAtIndexPaths:arIndexPaths withRowAnimation:UITableViewRowAnimationNone];
        }];
        
//        NSLog(@"====================");
//        NSLog(@"全部共%lu筆", self.mTotalPlantDataCount);
//        NSLog(@"已顯示%lu筆", self.mDataResultsArray.count);
//        NSLog(@"====================");
        
    } failure:^(NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:error.description];
        
    }];
    self.mCurrentPlantDataOffset += limit;
}

@end
