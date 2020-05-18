//
//  InformationWkView.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/28.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "InformationWkView.h"
#import "BaseResultObj.h"
#import "CommonNumber.h"
#import <WebKit/WebKit.h>
#import "WKWebView+CMLExspand.h"
#import "WebViewLinkVC.h"
#import "VCManger.h"

@interface InformationWkView()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic,copy) NSString *url;

@property (nonatomic,strong) WKWebView *webView;

@property (nonatomic,strong) UIView *videoView;

@end

@implementation InformationWkView

- (instancetype)initWith:(NSString *) url{
    
    self = [super init];
    if (self) {
        
        self.url = url;
        [self loadViews];
    }
    return self;
}

- (void) loadViews{
    
    self.webView = [[WKWebView alloc] init];
    self.webView.frame = CGRectMake(0,
                                    0,
                                    WIDTH,
                                    9);
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.bounces = NO;
//    self.webView.scrollView.alwaysBounceHorizontal = NO;
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    NSLog(@"self.url========================%@", self.url);
    [self addSubview:self.webView];
    
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:( WKNavigation *)navigation{
    
    __weak typeof(self) weakSelf = self;
    [self.webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id result,NSError * _Nullable error) {
        //获取页面高度，并重置webview的frame
        
        weakSelf.webView.frame = CGRectMake(webView.frame.origin.x,
                                            webView.frame.origin.y,
                                            WIDTH,
                                            [result doubleValue]);
        NSLog(@"weakSelf.webView.frame.size.height = %f", weakSelf.webView.frame.size.height);
        weakSelf.loadWebViewFinish(CGRectGetMaxY(weakSelf.webView.frame));
        
    }];
    
    [webView getImageUrlByJS:webView];
    
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
//    decisionHandler(WKNavigationActionPolicyAllow);
    
    //    1.拦截请求
    NSString *urlString = [navigationAction.request.URL absoluteString];
    
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        //跳转别的应用如系统浏览器
        // 对于跨域，需要手动跳转
        
        WebViewLinkVC *vc = [[WebViewLinkVC alloc] init];
        vc.url = urlString;
        [[VCManger mainVC] pushVC:vc animate:YES];
        // 不允许web内跳转
        decisionHandler(WKNavigationActionPolicyCancel);
        
    } else {
        //应用的web内跳转
        
        [webView showBigImage:navigationAction.request];
        
        decisionHandler (WKNavigationActionPolicyAllow);
        
    }
    return ;//不添加会崩溃

    
}


@end
