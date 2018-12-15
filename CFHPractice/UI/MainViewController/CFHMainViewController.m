//
//  CFHMainViewController.m
//  CFHPractice
//
//  Created by Arthur Tseng on 2018/12/14.
//  Copyright © 2018 Arthur Tseng. All rights reserved.
//

#import "CFHMainViewController.h"
#import "DTGetPlantDataListRequest.h"

#import <SVProgressHUD.h>

static const NSInteger DTGetPlantDataDefaultLimit = 20;

@interface CFHMainViewController () <UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIView *mBottomView;

@property (strong, nonatomic) NSMutableArray *mDataResultsArray;


@property (assign, nonatomic) NSUInteger mTotalPlantDataCount;
@property (assign, nonatomic) NSUInteger mCurrentPlantDataOffset;
@end

@implementation CFHMainViewController

- (void)initParameters {
    _mTotalPlantDataCount = 0;
    _mCurrentPlantDataOffset = 0;
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mDataResultsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [self.mTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    DTPlantInfo *plantInfo = self.mDataResultsArray[indexPath.row];
    cell.textLabel.text = plantInfo.nameCh;
    cell.detailTextLabel.text = plantInfo.location;
    
    return cell;
}

#pragma mark - WebService API

- (void)getPlantDataListWithLimit:(NSUInteger)limit {
//    [SVProgressHUD show];
    DTGetPlantDataListRequest *request = [[DTGetPlantDataListRequest alloc] initWithLimit:limit offset:self.mCurrentPlantDataOffset];
    [request getWSSuccess:^(DTGetPlantDataListResponse * _Nonnull response) {
        
        //[SVProgressHUD dismiss];
        self.mTotalPlantDataCount = response.count;
        
        NSMutableArray *arIndexPaths = [NSMutableArray arrayWithCapacity:response.count];
        NSUInteger currentDataCount = self.mDataResultsArray.count;
        for (NSInteger iIndex = 0; iIndex < response.plantInfos.count; iIndex ++) {
            [arIndexPaths addObject:[NSIndexPath indexPathForRow:currentDataCount + iIndex inSection:0]];
        }
        
        [self.mDataResultsArray addObjectsFromArray:response.plantInfos];
        [self.mTableView beginUpdates];
        [self.mTableView insertRowsAtIndexPaths:arIndexPaths withRowAnimation:UITableViewRowAnimationNone];
        [self.mTableView endUpdates];
        
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
