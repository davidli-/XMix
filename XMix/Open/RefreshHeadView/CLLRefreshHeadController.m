//
//  CLLRefreshHeadController.m
//  RefreshLoadView
//
//  Created by chuliangliang on 14-6-12.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//

#import "CLLRefreshHeadController.h"

@interface CLLRefreshHeadController ()

@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,weak)id<CLLRefreshHeadControllerDelegate>delegate;
@property (nonatomic, readwrite) CGFloat originalTopInset;
@property (nonatomic, assign) CLLRefreshState refreshState;
@property (nonatomic, assign) CLLLoadMoreState loadMoreState;

@property (nonatomic, assign) CLLRefreshViewLayerType refreshViewLayerType;
@property (nonatomic, assign) BOOL showRefreshHeader;
@property (nonatomic, assign) BOOL showRefreshFooter;

@property (nonatomic, assign) BOOL isHeaderRefreshing;
@property (nonatomic, assign) BOOL isFooterRefreshing;

@property (nonatomic) CGFloat originalBottomInset;
@property (nonatomic) BOOL isInFooter;

@end


@implementation CLLRefreshHeadController
#pragma mark - Pull Down Refreshing Method <上拉刷新>
//下拉刷新开始 <调用下拉刷新协议>
- (void)callRefreshHeader {
    if ([self.delegate respondsToSelector:@selector(shouldStartRefreshHeader)]) {
        [self.delegate shouldStartRefreshHeader];
    }
}
//上拉加载更多开始 <调用上拉加载更多协议>
- (void)callRefreshFooter {
    if (_isFooterRefreshing){
        return;
    }
    if ([self.delegate respondsToSelector:@selector(shouldStartLoadFooter)]) {
        [self.delegate shouldStartLoadFooter];
    }
    _isFooterRefreshing = YES;
    self.loadMoreState = CLLLoadMoreStateLoading;
}


//手动开始刷新
- (void)CLstartRefreshHeader {
    if (self.showRefreshHeader) {
        [self lastUpdateTime];
        _isHeaderRefreshing = YES;
        self.refreshState = CLLRefreshStatePulling;
        self.refreshState = CLLRefreshStateLoading;
    }
}


- (void)CLstartRefreshFooter {
    if (self.showRefreshFooter) {
        [self callRefreshFooter];
    }
}

//手动停止下拉刷新
- (void)CLfinishRefreshHeader {
    if (self.showRefreshHeader) {
        [self lastUpdateTime];
        _isHeaderRefreshing = NO;
        self.refreshState = CLLRefreshStateStopped;
        [self resetScrollViewContentInset];
    }
}

//手动停止上拉
- (void)CLfinishRefreshFooter {
    if (!self.showRefreshFooter) {
        [_refreshFooterView removeFromSuperview];
        _refreshFooterView = nil;
    }
    _isFooterRefreshing = NO;
    [self resetScrollViewContentInsetWithDoneLoadMore];
}

//获取最后的更新时间
- (void)lastUpdateTime
{
    NSDate *date = [NSDate date];
    if ([date isKindOfClass:[NSDate class]] || date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        NSString *destDateString = [dateFormatter stringFromDate:date];
        self.refreshHeadView.timeLabel.text = [NSString stringWithFormat:@"上次刷新：%@", destDateString];
    }
}


//刷新动画 <圆圈旋转>
- (void)animationRefreshCircleView {
    if (self.refreshHeadView.circleView.offsetY != CLLDefaultRefreshTotalPixels - CLLRefreshCircleViewHeight) {
        self.refreshHeadView.circleView.offsetY = CLLDefaultRefreshTotalPixels - CLLRefreshCircleViewHeight;
        [self.refreshHeadView.circleView setNeedsDisplay];
    }
    // 先去除所有动画
    [self.refreshHeadView.circleView.layer removeAllAnimations];
    // 添加旋转的动画
    [self.refreshHeadView.circleView.layer addAnimation:[CLLRefreshCircleView repeatRotateAnimation] forKey:@"rotateAnimation"];
    [self callRefreshHeader];
}

#pragma mark - Getter Method
- (BOOL)showRefreshHeader {
    if ([self.delegate respondsToSelector:@selector(hasRefreshHeaderView)]) {
        BOOL hasHeaderview = [self.delegate hasRefreshHeaderView];
        return hasHeaderview;
    }
    return NO;
}

- (BOOL)showRefreshFooter {
    if ([self.delegate respondsToSelector:@selector(hasRefreshFooterView)]) {
        BOOL hasFooterView = [self.delegate hasRefreshFooterView];
        return hasFooterView;
    }
    return NO;
}


- (id)initWithScrollView:(UIScrollView *)scrollView topInset:(CGFloat)topInset bottomInset:(CGFloat)bottomInset inFooter:(BOOL)inFooter viewDelegate:(id <CLLRefreshHeadControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.scrollView = scrollView;
        
        self.originalTopInset = topInset;
        self.originalBottomInset = bottomInset;
        self.isInFooter = inFooter;
    }
    return self;
}

- (CLLRefreshViewLayerType)refreshViewLayerType {
    CLLRefreshViewLayerType currentRefreshViewLayerType = CLLRefreshViewLayerTypeOnScrollViews;
    if ([self.delegate respondsToSelector:@selector(refreshViewLayerType)]) {
        currentRefreshViewLayerType = [self.delegate refreshViewLayerType];
    }
    return currentRefreshViewLayerType;
}

- (void)setup
{
    [self configuraObserverWithScrollView:self.scrollView];

    self.refreshHeadView.timeLabel.text = @"刷新时间";
    self.refreshHeadView.statusLabel.text = @"下拉刷新";
    self.refreshState = CLLRefreshStateNormal;
    
    if (self.refreshViewLayerType == CLLRefreshViewLayerTypeOnSuperView) {
        self.scrollView.backgroundColor = [UIColor clearColor];
        UIView *currentSuperView = self.scrollView.superview;
        if (self.showRefreshHeader) {
            [currentSuperView insertSubview:self.refreshHeadView belowSubview:self.scrollView];
        }
    } else if (self.refreshViewLayerType == CLLRefreshViewLayerTypeOnScrollViews) {
        if (self.showRefreshHeader) {
            [self.scrollView addSubview:self.refreshHeadView];
        }
    }
}


#pragma mark - SrollerView 下拉刷新后的 重置
- (void)resetScrollViewContentInset {
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.top = self.originalTopInset;
    contentInset.bottom = self.originalBottomInset;
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.scrollView setContentInset:contentInset];
    } completion:^(BOOL finished) {
        
        self.refreshState = CLLRefreshStateNormal;
        self.refreshHeadView.circleView.offsetY = 0;
        [self.refreshHeadView.circleView setNeedsDisplay];
        
        if (self.refreshHeadView.circleView) {
            [self.refreshHeadView.circleView.layer removeAllAnimations];
        }
    }];
}

#pragma mark - SrollerView 上拉加载更多后的 重置
- (void)resetScrollViewContentInsetWithDoneLoadMore {
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.bottom = 0;
    [UIView animateWithDuration:0.3f animations:^{
        [self.scrollView setContentInset:contentInset];
    } completion:^(BOOL finished) {
        if (_refreshFooterView) {
            self.loadMoreState = CLLLoadMoreStateNormal;
            CGRect tmpFrame = _refreshFooterView.frame;
            tmpFrame.origin.y = self.scrollView.contentSize.height;
            _refreshFooterView.frame = tmpFrame;
        }
    }];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                     }
                     completion:^(BOOL finished) {
                         if (self.refreshState == CLLRefreshStateStopped) {
                             self.refreshState = CLLRefreshStateNormal;
                             
                             if (self.refreshHeadView.circleView) {
                                 [self.refreshHeadView.circleView.layer removeAllAnimations];
                             }
                         }
                     }];
}

- (void)setScrollViewContentInsetForRefresh {
    
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = self.refreshInsetTop;
    currentInsets.bottom = self.originalBottomInset;
    
    [self setScrollViewContentInset:currentInsets];
    [self.scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(self.originalTopInset, 0, self.originalBottomInset, 0)];
}


- (void)setScrollViewContentInsetForLoading {
    
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top =  self.originalTopInset;
    if (_isInFooter) {
        currentInsets.bottom = self.refreshInsetBottom;
    }else{
        currentInsets.bottom = self.refreshInsetBottom + CLLRefreshFooterViewHeight;
    }
    [self setScrollViewContentInset:currentInsets];
    [self.scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(self.originalTopInset, 0, self.originalBottomInset, 0)];
}


#pragma mark - Life Cycle
- (void)configuraObserverWithScrollView:(UIScrollView *)scrollView {
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
    [scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)removeObserverWithScrollView:(UIScrollView *)scrollView {
    [scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    [scrollView removeObserver:self forKeyPath:@"contentInset" context:nil];
    [scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
}


- (CLLRefreshHeadView *)createHeaderview
{
    if (!_refreshHeadView) {
        _refreshHeadView = [[CLLRefreshHeadView alloc] initWithFrame:CGRectMake(0, (self.refreshViewLayerType == CLLRefreshViewLayerTypeOnScrollViews? - CLLDefaultRefreshTotalPixels : self.originalTopInset), CGRectGetWidth([[UIScreen mainScreen] bounds]),CLLDefaultRefreshTotalPixels)];
        _refreshHeadView.backgroundColor = [UIColor clearColor];
        _refreshHeadView.circleView.heightBeginToRefresh = CLLDefaultRefreshTotalPixels - CLLRefreshCircleViewHeight;
        _refreshHeadView.circleView.offsetY = 0;
        _refreshHeadView.circleView.isRefreshViewOnTableView = self.refreshViewLayerType;
        _refreshHeadView.backgroundColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:0.5];
        _showRefreshHeader = YES;
        
        [self setup];
    }
    return _refreshHeadView;

}


- (CLLRefreshFooterView *)createFooterview{
    if (!_refreshFooterView) {
        
        CGFloat height = MAX(self.scrollView.contentSize.height, self.scrollView.frame.size.height);
        
        _refreshFooterView = [[CLLRefreshFooterView alloc] initWithFrame:CGRectMake(0, height, CGRectGetWidth([[UIScreen mainScreen] bounds]), CLLRefreshFooterViewHeight)];
        _refreshFooterView.backgroundColor = [UIColor redColor];
        [self.scrollView addSubview:_refreshFooterView];
        self.loadMoreState = CLLLoadMoreStateNormal;
        
        _showRefreshFooter = YES;
    }
    return _refreshFooterView;
}



#pragma mark -上拉
- (void)setLoadMoreState:(CLLLoadMoreState)loadMoreState {
    switch (loadMoreState) {
        case CLLLoadMoreStateStopped:
        case CLLLoadMoreStateNormal:{
            //上拉加载更多
            self.refreshFooterView.statusLabel.text = @"";
            [self.refreshFooterView.indicatorView stopAnimating];
        }
            break;
            
        case CLLLoadMoreStateLoading:{
            //加载中
            self.refreshFooterView.statusLabel.text = @"";
            [self setScrollViewContentInsetForLoading];
            [self.refreshFooterView.indicatorView startAnimating];
            if (_isFooterRefreshing) {
                [self callRefreshFooter];
            }
        }
            break;
        default:
            break;
    }
    if (_refreshFooterView) {
        [_refreshFooterView resetView];
    }
    _loadMoreState = loadMoreState;
}
#pragma mark -下拉
- (void)setRefreshState:(CLLRefreshState)refreshState
{
    switch (refreshState) {
        case CLLRefreshStateStopped:
        case CLLRefreshStateNormal: {
            self.refreshHeadView.statusLabel.text = @"下拉刷新";
            break;
        }
        case CLLRefreshStateLoading: {
            if (_isHeaderRefreshing) {
                self.refreshHeadView.statusLabel.text = @"正在加载";
                [self setScrollViewContentInsetForRefresh];
                if(_refreshState == CLLRefreshStatePulling) {
                    [self animationRefreshCircleView];
                }
            }
            break;
        }
        case CLLRefreshStatePulling:
            self.refreshHeadView.statusLabel.text = @"释放立即刷新";
            break;
        default:
            break;
    }
    _refreshState = refreshState;

}
//是否支持 ios7 这里暂时不支持
- (CGFloat)getAdaptorHeight {
    if ([self.delegate respondsToSelector:@selector(keepiOS7NewApiCharacter)]) {
        return ([self.delegate keepiOS7NewApiCharacter] ? 64 : 0);
    } else {
        return 0;
    }
}
- (CGFloat)refreshTotalPixels {
    return CLLDefaultRefreshTotalPixels + [self getAdaptorHeight];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint contentOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        
        //下滑上滑均已结束的前提下 才继续判断 否则保持现有刷新状态（下滑/上滑加载中）
        if (_isFooterRefreshing || _isHeaderRefreshing) {
            return;
        }
        
        // 下拉刷新的逻辑方法
        if (self.showRefreshHeader) {
                if(self.refreshState != CLLRefreshStateLoading) {
                    // 如果不是加载状态的时候
                    if (ABS(self.scrollView.contentOffset.y + [self getAdaptorHeight]) >= CLLRefreshCircleViewHeight) {
                        self.refreshHeadView.circleView.offsetY = MIN(ABS(self.scrollView.contentOffset.y + [self getAdaptorHeight]), CLLDefaultRefreshTotalPixels) - CLLRefreshCircleViewHeight;
                        [self.refreshHeadView.circleView setNeedsDisplay];
                    }
                    
                    CGFloat scrollOffsetThreshold;
                    scrollOffsetThreshold = -(CLLDefaultRefreshTotalPixels + self.originalTopInset);
                    
                    if(!self.scrollView.isDragging && self.refreshState == CLLRefreshStatePulling) {
                        _isHeaderRefreshing = YES;
                        self.refreshState = CLLRefreshStateLoading;
                    } else if(contentOffset.y < scrollOffsetThreshold && self.scrollView.isDragging && self.refreshState == CLLRefreshStateStopped) {
                        self.refreshState = CLLRefreshStatePulling;
                    } else if(contentOffset.y >= scrollOffsetThreshold && self.refreshState != CLLRefreshStateStopped) {
                        self.refreshState = CLLRefreshStateStopped;
                    }
                } else {
                    CGFloat offset;
                    UIEdgeInsets contentInset;
                    offset = MAX(self.scrollView.contentOffset.y * -1, 0.0f);
                    offset = MIN(offset, self.refreshTotalPixels);
                    contentInset = self.scrollView.contentInset;
                    self.scrollView.contentInset = UIEdgeInsetsMake(offset, contentInset.left, contentInset.bottom, contentInset.right);
                }
            }
        
        // 上滑加载的逻辑方法
        
        if (self.showRefreshFooter) {
            int offsetY = contentOffset.y;
            
            CGSize size = self.scrollView.contentSize;//滚动视图内容区域size
            CGRect frame = self.scrollView.frame;
            CGFloat insetTop = self.scrollView.contentInset.top;
            
            if (size.height>=frame.size.height-insetTop) {
                float y = offsetY + frame.size.height;
                
                //判断是否滚动到底部
                if((y - size.height) > 0  && self.refreshState != CLLRefreshStateLoading && self.showRefreshFooter && !_isFooterRefreshing) {
                    [self CLstartRefreshFooter];
                    if (size.height<frame.size.height) {
                        
                        size.height = frame.size.height;
                        [self.scrollView setContentSize:size];
                    }
                }
            }
            else{
                if (offsetY > -insetTop && self.refreshState != CLLRefreshStateLoading && self.showRefreshFooter && !_isFooterRefreshing) {
                    [self CLstartRefreshFooter];
                    
                    size.height = frame.size.height;
                    [self.scrollView setContentSize:size];
                }
            }
        }
        
        
    } else if ([keyPath isEqualToString:@"contentInset"]) {
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        BOOL hasFooterView = [self showRefreshFooter];
        if (hasFooterView) {
            CGRect tmpFrame = self.refreshFooterView.frame;
            tmpFrame.origin.y = self.scrollView.contentSize.height;
            self.refreshFooterView.frame = tmpFrame;
        }else {
            [self.refreshFooterView removeFromSuperview];
            self.refreshFooterView = nil;
        }
    }
}
- (void)dealloc {
    self.delegate = nil;
    [self removeObserverWithScrollView:self.scrollView];
    self.scrollView = nil;
    self.refreshHeadView = nil;
    self.refreshFooterView = nil;
}

@end
