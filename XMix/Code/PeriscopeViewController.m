//
//  PeriscopeViewController.m
//  XMix
//
//  Created by davidli on 15/12/18.
//  Copyright © 2015年 X. All rights reserved.
//

#import "PeriscopeViewController.h"

@interface PeriscopeViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mTopTableView;
@property (weak, nonatomic) IBOutlet UITableView *mInnerTableView;

@property (nonatomic) CGFloat startOffset;
@property (nonatomic) CGFloat mLastOffset;
@property (nonatomic) CGFloat mTopStartOffset;

@end

@implementation PeriscopeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUps];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_mTopTableView setContentInset:UIEdgeInsetsMake(100, 0, 0, 0)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -TableView
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_mInnerTableView]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InnerCell"];
        return cell;
    }else if ([tableView isEqual:_mTopTableView]){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopCell"];
        return cell;
    }
    return nil;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_mTopTableView]) {
        return 20;
    }else if ([tableView isEqual:_mInnerTableView]){
        return 20;
    }
    return NONE;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectZero;
    frame.size.height = 60;
    frame.size.width = tableView.frame.size.width;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    if ([tableView isEqual:_mTopTableView]) {
        [view setBackgroundColor:RGBACOLOR(255, 0, 0, ONE)];
    }else{
        [view setBackgroundColor:RGBACOLOR(0, 0, 255, ONE)];
    }
    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_mInnerTableView]) {
        _startOffset = scrollView.contentOffset.y;
        _mTopStartOffset = _mTopTableView.contentInset.top;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_mInnerTableView]) {
        CGPoint point = scrollView.contentOffset;
        CGFloat nowOffsetY = point.y;
        CGFloat diffOffY = nowOffsetY - _startOffset;

        TraceS(@"++++++内Table OffY:%f  本次Y:%f",scrollView.contentOffset.y, diffOffY);
        if (nowOffsetY >= -64) {
//            point.y += 64;
//            [_mTopTableView setContentOffset:point];
            CGFloat nowInsetY = _mTopStartOffset;
            nowInsetY -= diffOffY;
            if (nowInsetY >= NONE) {
                if (nowInsetY <= 100) {
                    [_mTopTableView setContentInset:UIEdgeInsetsMake(nowInsetY, NONE, NONE, NONE)];
                }else{
                    [_mTopTableView setContentInset:UIEdgeInsetsMake(100, NONE, NONE, NONE)];
                }
            }else{
                [_mTopTableView setContentInset:UIEdgeInsetsMake(NONE, NONE, NONE, NONE)];
            }
        }
        _mLastOffset = scrollView.contentOffset.y;
    }else if ([scrollView isEqual:_mTopTableView]){
        //TraceS(@"++++外Table OffY:%f",scrollView.contentOffset.y);
    }
}

- (void)setUps
{
}
@end
