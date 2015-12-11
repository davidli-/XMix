//
//  LocationMainController.m
//  XMix
//
//  Created by davidli on 15/10/20.
//  Copyright © 2015年 X. All rights reserved.
//

#import "LocationMainController.h"
#import "TopBannerView.h"

@interface LocationMainController ()

@property (weak, nonatomic) IBOutlet TopBannerView *mTopBanner;

@end

@implementation LocationMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUps];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)setUps
{
    [self setTitle:@"位置"];
    CGRect frame = _mTopBanner.frame;
    frame.size.width = CGRectGetWidth(self.view.frame);
    [_mTopBanner resetTopBannerWithFrame:frame dataSource:@[@"",@"",@""]];
}

@end
