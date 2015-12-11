//
//  MainCollectionViewController.m
//  XMix
//
//  Created by davidli on 15/10/20.
//  Copyright © 2015年 X. All rights reserved.
//

#import "MainCollectionViewController.h"
#import "BackButton.h"
#import "CollectionCell.h"
#import "CHTCollectionViewWaterfallLayout.h"

CGFloat const kPadding = 10;
CGFloat const kColumun = 2;

NSString *const kHeaderIdentifier = @"HeaderIdentifier";


@interface MainCollectionViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
CHTCollectionViewDelegateWaterfallLayout
>

@property (strong, nonatomic) IBOutlet UICollectionView *mCollectionView;

@end

@implementation MainCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUps];
    [self.view setBackgroundColor:[UIColor redColor]];

    //CollectionView设置
    CHTCollectionViewWaterfallLayout *mLayout = (CHTCollectionViewWaterfallLayout*) self.mCollectionView.collectionViewLayout;
    mLayout.headerHeight = mLayout.footerHeight = NONE;
    mLayout.columnCount = kColumun;

    [_mCollectionView registerClass:[CollectionCell class] 
         forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark <UICollectionViewDataSource>


//目前没用 不会被调用
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    UICollectionReusableView * reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                                                          withReuseIdentifier:kHeaderIdentifier
                                                                 forIndexPath:indexPath];
    }
    return reusableView;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 50);
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return ONE;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 60;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionCell *cell = (CollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    cell.name.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    CHTCollectionViewWaterfallLayout *mLayout = (CHTCollectionViewWaterfallLayout*)collectionViewLayout;
    NSInteger count = mLayout.columnCount;

    CGFloat width = (CGRectGetWidth(collectionView.frame) - (count - ONE)*kPadding) / count;
    if (NONE == indexPath.row % 2) {
        return CGSizeMake(width, 50);
    }
    return CGSizeMake(width, 100);
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TraceS(@"++++++++:%ld",(long)indexPath.row);
}


#pragma mark -setUps

-(void)onHandleBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onHandleColumn:(id)sender
{
    CHTCollectionViewWaterfallLayout *mLayout = (CHTCollectionViewWaterfallLayout*) _mCollectionView.collectionViewLayout;
    if (2 == mLayout.columnCount) {
        mLayout.columnCount = 3;
    }else{
        mLayout.columnCount = 2;
    }
}


- (void)setUps{
    [self setTitle:@"Collectionview"];
    UIButton *back = [[BackButton alloc] initWithBackType:BACK_BTN_TYPE_IMAGE images:nil text:@"" target:self selector:@selector(onHandleBack:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];


    UIButton *btn = [UIButton new];
    [btn setTitle:@"更换" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onHandleColumn:) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}


@end
