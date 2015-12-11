//
//  TopBannerView.h
//  XMix
//
//  Created by davidli on 15/11/4.
//  Copyright © 2015年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopBannerView : UIView


#pragma mark -接口
-(void)resetTopBannerWithFrame:(CGRect)frame dataSource:(NSArray*)mDataSource;
- (void)setTimerOn:(BOOL)on;
@end
