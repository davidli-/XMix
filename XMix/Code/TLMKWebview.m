//
//  TLMKWebview.m
//  XMix
//
//  Created by davidli on 15/12/11.
//  Copyright © 2015年 X. All rights reserved.
//

#import "TLMKWebview.h"

@interface TLMKWebview()<WKNavigationDelegate>

@end

@implementation TLMKWebview

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.navigationDelegate = self;
    }
    return self;
}


#pragma mark -WKNavigationDelegate
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{//开始加载
}

-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{//内容开始返回
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{//加载完成
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id title, NSError * _Nullable error) {
        TraceS(@"++++%@",title);
    }];
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{//加载失败
}

@end
