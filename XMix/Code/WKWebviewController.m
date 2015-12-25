//
//  WKWebviewController.m
//  XMix
//
//  Created by davidli on 15/12/11.
//  Copyright © 2015年 X. All rights reserved.
//

#import "WKWebviewController.h"
#import "TLMKWebview.h"

@interface WKWebviewController ()<UIWebViewDelegate>

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
    [_mWKWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [self.view addSubview:_mWKWebView];
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


- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
}


-(void)dealloc
{
    TraceS(@"dealloced");
}

@end
