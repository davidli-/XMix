//
//  WKWebviewController.m
//  XMix
//
//  Created by davidli on 15/12/11.
//  Copyright © 2015年 X. All rights reserved.
//

#import "WKWebviewController.h"
#import "TLMKWebview.h"

@interface WKWebviewController ()<UIWebViewDelegate,WKScriptMessageHandler>

@property (weak, nonatomic) TLMKWebview *mWKWebView;
@property (weak, nonatomic) UIWebView *mWebView;

@end

@implementation WKWebviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWKWebview];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (void)loadWKWebview
{
    NSString *url = @"https://www.baidu.com";
    TLMKWebview *webview = [[TLMKWebview alloc] initWithFrame:self.view.frame];
    _mWKWebView = webview;
    
    
    //1、动态加载脚本
    NSString *js = @"var count = document.images.length;for (var i = 0; i < count; i++) {var image = document.images[i];image.style.width=320;};window.alert('找到' + count + '张图');";
    
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [[[_mWKWebView configuration] userContentController] addUserScript:userScript];
    
    [_mWKWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [self.view addSubview:_mWKWebView];
    
    
    
    //2、OC执行JS方法
    [_mWKWebView evaluateJavaScript:@"jsssss" completionHandler:^(id xxx, NSError * _Nullable error) {
        TraceS(@"执行js");
    }];
    
    
    
    //3、JS调用O 首先要OC注册供JS调用的方法
    [[_mWKWebView configuration].userContentController addScriptMessageHandler:self name:@"closeMe"];
    //JS调用
    //window.webkit.messageHandlers.closeMe.postMessage(null);
}


-(void)loadWebView
{
    NSString *url = @"https://www.baidu.com";
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.delegate = self;
    _mWebView = webView;
    [_mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL  URLWithString:url]]];
    [self.view addSubview:_mWebView];
}


#pragma mark -Webview Delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(nonnull NSError *)error
{
}



#pragma mark WKWebview Delegate
//OC在JS调用方法做的处理
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    TraceS(@"JS 调用了 %@ 方法，传回参数 %@",message.name,message.body);
}


-(void)dealloc
{
    TraceS(@"dealloced");
}

@end
