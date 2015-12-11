//
//  TopBannerView.m
//  XMix
//
//  Created by davidli on 15/11/4.
//  Copyright © 2015年 X. All rights reserved.
//

#import "TopBannerView.h"

CGFloat const kScrollInterval = 3;

@interface TopBannerView()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *mDataSource;
@property (weak, nonatomic) IBOutlet UIScrollView  *mScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *mPageControl;

@property (nonatomic, strong) NSTimer *mScrollTimer;
@property (nonatomic) NSInteger mIndex;
@property (nonatomic) CGFloat mPreviouDeltX;
@end

@implementation TopBannerView


-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}


-(void)resetTopBannerWithFrame:(CGRect)frame dataSource:(NSArray*)dataArray
{
    self.frame = frame;
    _mDataSource = [NSMutableArray arrayWithArray:dataArray];

    //设置contentSize
    NSInteger count = _mDataSource.count;
    CGSize size = CGSizeZero;
    if (ONE < count) {
        count += ONE;
    }
    size.width = count * frame.size.width;
    size.height = frame.size.height;

    [_mScrollView setContentSize:size];

    if (ONE == count) {
        UIButton *btn = [UIButton new];
        [btn setTag:NONE];
        [btn setFrame:_mScrollView.frame];
        [btn setBackgroundColor:[UIColor cyanColor]];
        [_mScrollView addSubview:btn];
    }
    else{
        CGRect btnFrame = frame;
        btnFrame.origin.x = - frame.size.width;

        for (NSInteger i = NONE; i < count; i++) {
            UIButton *btn = [UIButton new];
            if (NONE == i) {
                [btn setTag:count - 2];
            }else if ((count - ONE) == i){
                [btn setTag:count - 2];
            }else{
                [btn setTag:(i - ONE)];
            }

            btnFrame.origin.x += frame.size.width;
            [btn setFrame:btnFrame];
            [btn setTitle:[NSString stringWithFormat:@"%ld",(long)btn.tag] forState:UIControlStateNormal];

            [_mScrollView addSubview:btn];

            if (NONE == i) {
                [btn setBackgroundColor:[UIColor magentaColor]];
            }else if (ONE == i){
                [btn setBackgroundColor:[UIColor greenColor]];
            }else if (2 == i){
                [btn setBackgroundColor:[UIColor cyanColor]];
            }else if (3 == i){
                [btn setBackgroundColor:[UIColor magentaColor]];
            }
        }
    }
    _mIndex = NONE;
    [_mScrollView setContentOffset:CGPointMake(frame.size.width,frame.size.height)];

    //设置pageControl
    if (ONE <= count)
    {
        count -= ONE;
        [self setTimerOn:YES];
    }
    [_mPageControl setNumberOfPages:count];
    [_mPageControl setCurrentPage:NONE];
    _mPageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _mPageControl.pageIndicatorTintColor = [UIColor whiteColor];
}


#pragma mark -Scroll Delegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self setTimerOn:NO];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger dataNum = _mDataSource.count;
    if (ONE < dataNum) {
        CGFloat OffsetX = scrollView.contentOffset.x;
        CGFloat width = self.frame.size.width;
        double index = OffsetX / width;

        if (dataNum < index) {
            [scrollView setContentOffset:CGPointMake(NONE, NONE)];
        }else if (NONE > index){
            [scrollView setContentOffset:CGPointMake(dataNum * scrollView.frame.size.width, NONE)];
        }

        OffsetX = scrollView.contentOffset.x;
        width = self.frame.size.width;
        index = OffsetX / width;


        NSInteger indexT = index - ONE;
        if (OffsetX < _mPreviouDeltX) {
            indexT = floor(index) - ONE;
            if (dataNum < index) {
                indexT = NONE;
            }else if (ONE > index){
                indexT = dataNum - ONE;
            }
        }else{
            indexT = ceil(index) - ONE;
            if (dataNum < index) {
                indexT = dataNum - ONE;
            }else if (ONE > index){
                indexT = NONE;
            }
        }

        TraceS(@"+++++当前页: %ld",(long)indexT);
        [_mPageControl setCurrentPage:indexT];

        _mPreviouDeltX = scrollView.contentOffset.x;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger dataNum = _mDataSource.count;
    if (ONE < dataNum) {
        CGFloat OffsetX = scrollView.contentOffset.x;
        CGFloat width = self.frame.size.width;
        double index = OffsetX / width;

        _mIndex = index - ONE;
        if (dataNum == index || NONE == index) {
            _mIndex = dataNum - ONE;
        }
        TraceS(@"+++++结束滑动 当前页: %ld",(long)_mIndex);

        [_mPageControl setCurrentPage:_mIndex];
    }
    [self setTimerOn:YES];
}


#pragma mark -BUSINESS
- (void)onHandleScroll:(NSTimer*)timer
{
    __block NSInteger dataNum = _mDataSource.count;
    CGPoint point = CGPointZero;
    if (ONE < dataNum) {
        if ((dataNum - ONE) == _mIndex) {
            point.x = ONE;
            //先滑到第一个模拟的图片处
            [_mScrollView setContentOffset:point];

            //再使用动画滑到第一个真正的图片处
            point.x = _mScrollView.frame.size.width;
            [UIView animateWithDuration:0.3 animations:^{
                [_mScrollView setContentOffset:point];
            } completion:^(BOOL finished) {
            }];
            _mIndex = NONE;
            [_mPageControl setCurrentPage:_mIndex];
        }else{
            point.x = (_mIndex + 2) *_mScrollView.frame.size.width;
            _mIndex += ONE;
            [UIView animateWithDuration:0.3 animations:^{
                [_mScrollView setContentOffset:point];
                [_mPageControl setCurrentPage:_mIndex];
            } completion:^(BOOL finished) {
            }];
        }
    }
}


- (void)setTimerOn:(BOOL)on
{
    return;
    if (on) {
        if (_mScrollTimer) {
            [_mScrollTimer invalidate];
        }
        _mScrollTimer = [NSTimer scheduledTimerWithTimeInterval:kScrollInterval target:self selector:@selector(onHandleScroll:) userInfo:nil repeats:YES];
    }else{
        [_mScrollTimer invalidate];
        _mScrollTimer = nil;
    }
}


@end
