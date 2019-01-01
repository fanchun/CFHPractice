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
//#import "CFHScrollableView.h"

#import <SVProgressHUD.h>
#import <UIImageView+AFNetworking.h>

typedef NS_ENUM(NSInteger, CFHScrollableDirection) {
    CFHScrollableDirectionNone,
    CFHScrollableDirectionUp,
    CFHScrollableDirectionDown
};

typedef NS_ENUM(NSInteger, CFHScrollableState) {
    CFHScrollableStateScrolling,
    CFHScrollableStateOpened,
    CFHScrollableStateClosed,
};

static const NSInteger      kGetPlantDataDefaultLimit = 20;
static const NSTimeInterval kAnimationDuration = 0.2;

@interface CFHMainViewController () <UITableViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mTableViewTopConstraint;

@property (weak, nonatomic) IBOutlet UIView *mBottomView;

@property (weak, nonatomic) IBOutlet UIView *mFrontView;
@property (weak, nonatomic) IBOutlet UILabel *mFrontViewLabel;

@property (strong, nonatomic) NSMutableArray *mDataResultsArray;
@property (strong, nonatomic) CFHArrayDataSource *mArrayDataSource;

@property (assign, nonatomic) NSUInteger mTotalPlantDataCount;
@property (assign, nonatomic) NSUInteger mCurrentPlantDataOffset;

@property (strong, nonatomic) UIPanGestureRecognizer *mPanGesture;
@property (strong, nonatomic) UISwipeGestureRecognizer *mSwipeGesture;

@property (assign, nonatomic) CGFloat mPanOffsetY;
@property (assign, nonatomic) CGFloat mOriginalTopConstraint;

@property (assign, nonatomic) CFHScrollableDirection mDirection;
@property (assign, nonatomic) CFHScrollableState mState;
@end

@implementation CFHMainViewController {
    BOOL mPanGuestureActive;
    CGFloat mTableViewContentOffsetY;
    BOOL mScrollingStart;
}

- (CGFloat)minTopViewHeight {
    return CGRectGetHeight(self.mFrontViewLabel.bounds);
}

- (void)closeTopViewWithAnimated:(BOOL)animated {
    self.mDirection = CFHScrollableDirectionNone;
    
    [self.mTableView layoutIfNeeded];
    NSTimeInterval duration = (animated) ? kAnimationDuration : 0;
    [UIView animateWithDuration:duration animations:^{
        self.mTableViewTopConstraint.constant = [self minTopViewHeight];
        self.mBottomView.alpha = 0;
        self.mFrontView.alpha = 1;
        [self.mTableView layoutIfNeeded];
    }];
}

- (void)openTopViewWithAnimated:(BOOL)animated {
    _mDirection = CFHScrollableDirectionNone;
    
    [self.mTableView layoutIfNeeded];
    NSTimeInterval duration = (animated) ? kAnimationDuration : 0;
    [UIView animateWithDuration:duration animations:^{
        self.mTableViewTopConstraint.constant = self.mOriginalTopConstraint;
        self.mBottomView.alpha = 1;
        self.mFrontView.alpha = 0;
        [self.mTableView layoutIfNeeded];
    }];
}

- (void)initParameters {
    _mTotalPlantDataCount = 0;
    _mCurrentPlantDataOffset = 0;
    
    _mDirection = CFHScrollableDirectionNone;
    _mState = CFHScrollableStateOpened;
}

- (void)setupTableView {
    
    CFHTableViewCellConfigureBlock configureCell = ^(CFHMainTableViewCell *cell, DTPlantInfo *plantInfo) {
        cell.nameLabel.text = plantInfo.nameCh;
        cell.locationLabel.text = plantInfo.location;
        cell.featureLabel.text = plantInfo.feature;
        
        __weak CFHMainTableViewCell *weakCell = cell;
        
        NSURLRequest *imageRequest =[NSURLRequest requestWithURL:[NSURL URLWithString:plantInfo.pictureURL]];
        [cell.imageView setImageWithURLRequest:imageRequest
                              placeholderImage:nil
                                       success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                           
                                           weakCell.pictureImageView.image = image;
                                           
                                       } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                           
                                       }];
    };
    
    self.mArrayDataSource = [[CFHArrayDataSource alloc] initWithItems:self.mDataResultsArray
                                                       cellIdentifier:CFHMainTableViewCellIndentifier
                                                   configureCellBlock:configureCell];
    self.mTableView.dataSource = self.mArrayDataSource;
    self.mTableView.delegate = self;
    [self.mTableView registerNib:[CFHMainTableViewCell nib] forCellReuseIdentifier:CFHMainTableViewCellIndentifier];
    
    self.mTableView.rowHeight = UITableViewAutomaticDimension;
    self.mTableView.estimatedRowHeight = CFHMainTableViewCellSize.height;
    self.mTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.mPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    self.mPanGesture.maximumNumberOfTouches = 1;
    self.mPanGesture.delegate = self;
    self.mPanGesture.cancelsTouchesInView = NO;
    [self.mTableView addGestureRecognizer:self.mPanGesture];
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

- (CFHScrollableState)mState {
    CGFloat currentTopContraint = self.mTableViewTopConstraint.constant;
    if (currentTopContraint == [self minTopViewHeight]) {
        _mState =  CFHScrollableStateClosed;
    }else if (currentTopContraint == self.mOriginalTopConstraint){
        _mState =  CFHScrollableStateOpened;
    }else {
        _mState =  CFHScrollableStateScrolling;
    }
    return _mState;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParameters];
    [self setupTableView];
    
    self.mOriginalTopConstraint = self.mTableViewTopConstraint.constant;
    [self openTopViewWithAnimated:NO];
    
    //self.mFrontView.targetScrollView = self.mTableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getPlantDataListWithLimit:kGetPlantDataDefaultLimit];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollingStopped {
    if (self.mState == CFHScrollableStateScrolling) {
        if (self.mTableViewTopConstraint.constant > self.mOriginalTopConstraint/2) {
            [self openTopViewWithAnimated:YES];
        }else {
            [self closeTopViewWithAnimated:YES];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if (mScrollingStart) {
            mScrollingStart = NO;
            [self scrollingStopped];
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (mScrollingStart) {
        mScrollingStart = NO;
        [self scrollingStopped];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView == self.mTableView) {
        if (velocity.y > 0){
            NSUInteger remainDataCount = (self.mTotalPlantDataCount - self.mCurrentPlantDataOffset);
            if (remainDataCount > 0) {
                NSUInteger limit = (remainDataCount > kGetPlantDataDefaultLimit) ? kGetPlantDataDefaultLimit : remainDataCount;
                [self getPlantDataListWithLimit:limit];
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.mTableView) {
        mScrollingStart = YES;
        mTableViewContentOffsetY = scrollView.contentOffset.y;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.mTableView) {
        mScrollingStart = YES;
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        if (!mPanGuestureActive) {
            CGFloat deltaY = mTableViewContentOffsetY - contentOffsetY;
            if (self.mState != CFHScrollableStateClosed && contentOffsetY > 0 && deltaY <=  0 )
            {
                CGFloat updateTopConstraint = (self.mTableViewTopConstraint.constant + deltaY);
                
                if (updateTopConstraint <= self.mOriginalTopConstraint / 2) {
                    // 閉合
                    [self closeTopViewWithAnimated:YES];
                }else {
                    // 展開
                    [self openTopViewWithAnimated:YES];
                    [self.mTableView setContentOffset:CGPointZero];
                }
            }
            if (self.mState == CFHScrollableStateScrolling) {
                [self.mTableView setContentOffset:CGPointZero];
            }
        }
        
        mTableViewContentOffsetY = scrollView.contentOffset.y;
    }
}

#pragma mark - WebService API

- (void)getPlantDataListWithLimit:(NSUInteger)limit {
    DTGetPlantDataListRequest *request = [[DTGetPlantDataListRequest alloc] initWithLimit:limit offset:self.mCurrentPlantDataOffset];
    [request getWSSuccess:^(DTGetPlantDataListResponse * _Nonnull response) {

        self.mTotalPlantDataCount = response.count;
        
        self.mFrontViewLabel.text = [NSString stringWithFormat:@"總共%lu筆", (unsigned long)self.mTotalPlantDataCount];
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

#pragma mark - Pan Gesture

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    
    mPanGuestureActive = (gesture.state != UIGestureRecognizerStateEnded &&
                         gesture.state != UIGestureRecognizerStateCancelled);
    
    CGPoint transaction = [gesture translationInView:self.mTableView.superview];
    CGFloat transactionY = transaction.y;
    
//    NSLog(@"TransacitonY = %f & state = %ld", transactionY, (long)gesture.state);
//    NSLog(@"ContentOffsetY = %f", self.mTableView.contentOffset.y);
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        _mPanOffsetY = transactionY;
        _mDirection = CFHScrollableDirectionNone;
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        CGFloat deltaY = (transactionY - _mPanOffsetY);
        if (deltaY > 0) {
            _mDirection = CFHScrollableDirectionDown;
        }else {
            _mDirection = CFHScrollableDirectionUp;
        }
        
        if (self.mState == CFHScrollableStateClosed && self.mTableView.contentOffset.y > 0) {
            self.mDirection = CFHScrollableDirectionNone;
            return;
        }
        
        CGFloat updateTopConstraint = (self.mTableViewTopConstraint.constant + deltaY);

        if (updateTopConstraint < [self minTopViewHeight]) {
            // 閉合
            [self closeTopViewWithAnimated:NO];
        }else if (updateTopConstraint > self.mOriginalTopConstraint) {
            // 展開
            [self openTopViewWithAnimated:NO];
        }else {
            // 移動中
            self.mTableViewTopConstraint.constant = updateTopConstraint;
            
            // Animation
            // BottomView
            CGFloat bottomViewAlpha = ((updateTopConstraint - [self minTopViewHeight]) / (self.mOriginalTopConstraint- [self minTopViewHeight]));
            self.mBottomView.alpha = bottomViewAlpha;
            
            // FrontViewAlpha
            CGFloat frontViewAlpha = (self.mOriginalTopConstraint/2 - updateTopConstraint) / (self.mOriginalTopConstraint/2 - [self minTopViewHeight]);
            self.mFrontView.alpha = frontViewAlpha;
        }

        if (self.mState == CFHScrollableStateScrolling) {
            [self.mTableView setContentOffset:CGPointZero];
        }
        
        _mPanOffsetY = transactionY;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
