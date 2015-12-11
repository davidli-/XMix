//
//  OthersMainController.m
//  XMix
//
//  Created by davidli on 15/10/20.
//  Copyright © 2015年 X. All rights reserved.
//

#import "OthersMainController.h"
#import "MainCollectionViewController.h"


@interface OthersMainController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *mTopIv;
@property (weak, nonatomic) IBOutlet UIView *mContainerView;
@property (weak, nonatomic) IBOutlet UILabel *mSlider;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mSliderDetX;


@property (nonatomic, strong) UIPageViewController *mPageViewController;
@property (nonatomic, strong) MainCollectionViewController *mViewController1;
@property (nonatomic, strong) MainCollectionViewController *mViewController2;
@property (nonatomic, strong) MainCollectionViewController *mViewController3;

@end

@implementation OthersMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUps];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addChildViewController:_mPageViewController];
    [_mContainerView addSubview:_mPageViewController.view];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark -PageViewController Delegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    MainCollectionViewController *collectVc = (MainCollectionViewController*)viewController;
    NSInteger index = collectVc.index;

    TraceS(@"+++++++当前页:  %ld",(long)index);

    if (2 == index) {
        return _mViewController1;
    }
    else if (3 == index){
        if (!_mViewController2) {
            _mViewController2 = [self.storyboard instantiateViewControllerWithIdentifier:@"MainCollectionViewController"];
            _mViewController2.index = 2;
        }
        return _mViewController2;
    }
    return nil;
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    MainCollectionViewController *collectVc = (MainCollectionViewController*)viewController;
    NSInteger index = collectVc.index;

    TraceS(@"+++++++当前页:  %ld",(long)index);
    if (ONE == index) {
        if (!_mViewController2) {
            _mViewController2 = [self.storyboard instantiateViewControllerWithIdentifier:@"MainCollectionViewController"];
            _mViewController2.index = 2;
        }
        return _mViewController2;
    }else if (2 == index){
        if (!_mViewController3) {
            _mViewController3 = [self.storyboard instantiateViewControllerWithIdentifier:@"MainCollectionViewController"];
            _mViewController3.index = 3;
        }
        return _mViewController3;
    }

    return nil;
}



- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed) {
        return;
    }
    MainCollectionViewController *collectVc = (MainCollectionViewController*)[pageViewController.viewControllers lastObject];
    NSInteger index = collectVc.index;

    if (ONE == index) {
        _mSliderDetX.constant = NONE;
    }else if (2 == index){
        _mSliderDetX.constant = _mSlider.frame.size.width;
    }else if (3 == index){
        _mSliderDetX.constant = _mSlider.frame.size.width * 2;
    }
}


#pragma mark -其他

-(void)setUps
{
    _mPageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                         options:NULL];
    _mPageViewController.dataSource = self;
    _mPageViewController.delegate   = self;
    
    _mViewController1 = [self.storyboard instantiateViewControllerWithIdentifier:@"MainCollectionViewController"];
    _mViewController1.index = ONE;
    [_mPageViewController setViewControllers:@[_mViewController1]
                                   direction:UIPageViewControllerNavigationDirectionForward 
                                    animated:YES completion:NULL];
}
@end
