//
//  OauthViewController.m
//  XMix
//
//  Created by davidli on 15/10/14.
//  Copyright © 2015年 X. All rights reserved.
//

#import "OauthViewController.h"
#import "BackButton.h"

#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKAccessToken.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
#import <FBSDKShareKit/FBSDKShareKit.h>


@interface OauthViewController ()<FBSDKSharingDelegate>

@property (nonatomic, strong)FBSDKLoginManager *fbMana;

@end

@implementation OauthViewController

#pragma mark -属性

-(FBSDKLoginManager *)fbMana{
    if (!_fbMana) {
        _fbMana = [[FBSDKLoginManager alloc] init];
    }
    return _fbMana;
}

#pragma mark -周期
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUps];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark -Facebook DELEGATE

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    TraceS(@"+++++发布结果:%@",results);
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    TraceS(@"+++++++发布出错:%@",[error description]);
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    TraceS(@"++++++取消分享");
}



#pragma mark -其他
- (IBAction)onHandleFacebook:(id)sender {
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"public_profile"]){
        TraceS(@"已有资料权限");
    }else{
        TraceS(@"尚无资料权限");
    }

    //未登录 重新登录
    [self.fbMana logInWithReadPermissions:@[@"public_profile"]
                  fromViewController:self
                             handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             TraceS(@"++++++++++FB登录错误:%@",[error description]);
         } else if (result.isCancelled) {
             TraceS(@"取消Facebook授权登录!");
         } else {

             [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"id,name,gender,age_range,locale,picture"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 TraceS(@"成功授权:%@", result);
             }];
         }
     }];
}


- (IBAction)onHandleLogut:(id)sender {
    [self.fbMana logOut];
    TraceS(@"+++退出Facebook登录");
}


-(IBAction)onHandleFacebookPublish:(id)sender{

    __weak typeof(self)weakself = self;

    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]){
        TraceS(@"已有发布权限");
        [self publishWithDialog:nil];
    }else{
        TraceS(@"尚未权限发布内容 申请权限中..");

        [self.fbMana logInWithPublishPermissions:@[@"publish_actions"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            __strong typeof(weakself)strongself = weakself;
            if (error) {
                TraceS(@"发布权限申请失败");
            }else{
                TraceS(@"发布权限申请成功");
                [strongself publishWithDialog:nil];
            }
        }];
    }
}

- (IBAction)publishWithDialog:(id)sender {

    FBSDKShareLinkContent *content = [FBSDKShareLinkContent new];
    content.contentTitle = @"TEST MESS";
    content.contentDescription = @"THIS IS A MESS TESTING FB SHARE FUNC FROM ANYCAST!";
    content.contentURL = [NSURL URLWithString:@"http://developers.facebook.com"];
    
    [FBSDKShareDialog showFromViewController:self
                                 withContent:content
                                    delegate:self];
}


- (IBAction)publishInBackGround:(id)sender {

    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/feed" parameters:@{ @"message" : @"TEST INFO "} HTTPMethod:@"POST"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        TraceS(@"++++++发布结果%@",result);
    }];
}


- (IBAction)publishImagesInBackGround:(id)sender {

    FBSDKShareLinkContent *contentOfLink = [FBSDKShareLinkContent new];
    contentOfLink.contentTitle = @"TEST MESS";
    contentOfLink.contentDescription = @"THIS IS A MESS TESTING FB SHARE FUNC FROM ANYCAST!";
    contentOfLink.contentURL = [NSURL URLWithString:@"http://www.baidu.com"];

    //只有图片
//    UIImage *someImage = [UIImage imageNamed:@"AppIcon60x60"];
//    FBSDKSharePhotoContent *contentOfImage = [[FBSDKSharePhotoContent alloc] init];
//    contentOfImage.photos = @[[FBSDKSharePhoto photoWithImage:someImage userGenerated:YES] ];

    FBSDKShareAPI *shareApi = [[FBSDKShareAPI alloc] init];
    if ([shareApi canShare]) {
        [FBSDKShareAPI shareWithContent:contentOfLink delegate:self];
    }
}



-(void)onHandleBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setUps{
    [self setTitle:@"OAUTH"];

    UIButton *back = [[BackButton alloc] initWithBackType:BACK_BTN_TYPE_IMAGE images:nil text:@"" target:self selector:@selector(onHandleBack:)];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];

    UIButton *mBtn = [UIButton new];
    [mBtn setTitle:@"登出" forState:UIControlStateNormal];
    [mBtn sizeToFit];
    [mBtn setBackgroundColor:[UIColor clearColor]];
    [mBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mBtn addTarget:self action:@selector(onHandleLogut:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:mBtn];
}

@end
