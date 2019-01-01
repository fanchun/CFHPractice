//
//  CFHScrollableView.m
//  CFHPractice
//
//  Created by Arthur Tseng on 2018/12/15.
//  Copyright © 2018 Arthur Tseng. All rights reserved.
//

#import "CFHScrollableView.h"

static const NSTimeInterval kAnimationDuration = 0.2;

typedef NS_ENUM(NSInteger, CFHScrollableDirection) {
    CFHScrollableDirectionNone,
    CFHScrollableDirectionUp,
    CFHScrollableDirectionDown
};

typedef NS_ENUM(NSInteger, CFHScrollableViewState) {
    CFHScrollableViewStateScrolling,
    CFHScrollableViewStateOpened,
    CFHScrollableViewStateClosed,
};

@interface CFHScrollableView () <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UIPanGestureRecognizer *mPanGesture;
@property (assign, nonatomic) CFHScrollableViewState mState;

@end

@implementation CFHScrollableView {
    CGFloat mPanOffsetY;
    CFHScrollableDirection mDirection;
    CGRect mOrinalFrame;
}

- (void)resetParameters {
    mPanOffsetY = 0.0f;
    mDirection = CFHScrollableDirectionNone;
    mOrinalFrame = CGRectZero;
}

- (void)updateScrollViewFrameWithAnimated:(BOOL)animated {
    CGRect viewFrame = self.frame;
    CGRect targetScrollViewFrame = self.targetScrollView.frame;
    targetScrollViewFrame.origin.y = CGRectGetMinY(viewFrame) + CGRectGetHeight(viewFrame);
    targetScrollViewFrame.size.height = CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetMinY(targetScrollViewFrame);
    
    if (animated) {
        [UIView animateWithDuration:0.1
                         animations:^{
                             self.targetScrollView.frame = targetScrollViewFrame;
                         }];
    }else {
        self.targetScrollView.frame = targetScrollViewFrame;
    }
}

- (void)updateViewFrameHeight:(CGFloat)height animated:(BOOL)animated {
    CGRect viewFrame = self.frame;
    viewFrame.size.height = height;
    if (animated) {
        [UIView animateWithDuration:kAnimationDuration
                         animations:^{
                             self.frame = viewFrame;
                         }];
    }else {
        self.frame = viewFrame;
    }
    [self updateScrollViewFrameWithAnimated:animated];
}

- (void)closeViewWithAnimated:(BOOL)animated{
    mDirection = CFHScrollableDirectionNone;
    [self updateViewFrameHeight:44.0f animated:animated];
}

- (void)openViewWithAnimated:(BOOL)animated {
    mDirection = CFHScrollableDirectionNone;
    [self updateViewFrameHeight:CGRectGetHeight(mOrinalFrame) animated:animated];
}

#pragma mark - UIView

- (void)drawRect:(CGRect)rect {
    mOrinalFrame = rect;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self resetParameters];
}

#pragma mark - Property

- (UIPanGestureRecognizer *)mPanGuesture {
    if (!_mPanGesture) {
        _mPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        _mPanGesture.maximumNumberOfTouches = 1;
        _mPanGesture.delegate = self;
        _mPanGesture.cancelsTouchesInView = NO;
    }
    return _mPanGesture;
}

- (void)setTargetScrollView:(UIScrollView *)scrollView {
    _targetScrollView = scrollView;
    _targetScrollView.delegate = self;
    [_targetScrollView addGestureRecognizer:self.mPanGuesture];
}

- (CFHScrollableViewState)mState {
    CGFloat height = CGRectGetHeight(self.frame);
    if (height == 44.0f) {
        return CFHScrollableViewStateClosed;
    }else if (height == CGRectGetHeight(mOrinalFrame)){
        return CFHScrollableViewStateOpened;
    }else {
        return CFHScrollableViewStateScrolling;
    }
}

#pragma mark - Pan Gesture

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint transaction = [gesture translationInView:self.targetScrollView.superview];
    CGFloat transactionY = transaction.y;

//    NSLog(@"TransacitonY = %f & state = %ld", transactionY, (long)gesture.state);
//    NSLog(@"ContentOffsetY = %f", self.targetScrollView.contentOffset.y);
    if (gesture.state == UIGestureRecognizerStateBegan) {

        mPanOffsetY = transactionY;
        mDirection = CFHScrollableDirectionNone;
        
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGFloat deltaY = (transactionY - mPanOffsetY);
        if (deltaY > 0.0) {
            mDirection = CFHScrollableDirectionDown;
        }else {
            mDirection = CFHScrollableDirectionUp;
        }
        
        if (self.mState == CFHScrollableViewStateClosed && self.targetScrollView.contentOffset.y > 0) {
            mDirection = CFHScrollableDirectionNone;
            return;
        }

        CGRect viewFrame = self.frame;
        CGFloat updateViewHeight = (CGRectGetHeight(viewFrame) + deltaY);
        
        if (updateViewHeight < 44) {
            // 閉合
            [self closeViewWithAnimated:NO];
        }else if (updateViewHeight > CGRectGetHeight(mOrinalFrame)) {
            // 展開
            [self openViewWithAnimated:NO];
        }else {
            // 移動中
            viewFrame.size.height = updateViewHeight;
            self.frame = viewFrame;
            [self updateScrollViewFrameWithAnimated:NO];
        }
        
        if (!(self.mState == CFHScrollableViewStateClosed || self.mState == CFHScrollableViewStateOpened)) {
            [self.targetScrollView setContentOffset:CGPointZero];
        }
        
        mPanOffsetY = transactionY;
    }else {
        NSLog(@"ContentOffsetY = %f", self.targetScrollView.contentOffset.y);
        if (self.mState != CFHScrollableViewStateClosed && self.targetScrollView.contentOffset.y > 0) {
            [self closeViewWithAnimated:YES];
            return;
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

//#pragma mark - UIScrollViewDelegate
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat offsetY = scrollView.contentOffset.y;
////    if (offsetY > 0 && self.mState != CFHScrollableViewStateClosed) {
////        [self closeViewWithAnimated:YES];
////    }
//}

@end
