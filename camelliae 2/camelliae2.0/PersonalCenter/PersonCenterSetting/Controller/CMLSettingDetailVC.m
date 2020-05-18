//
//  CMLSettingDetailVC.m
//  camelliae1.0
//
//  Created by 张越 on 16/4/15.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLSettingDetailVC.h"
#import "VCManger.h"
#import <WebKit/WebKit.h>


@interface CMLSettingDetailVC ()<NavigationBarProtocol,WKNavigationDelegate>

@property (nonatomic,strong) NSString *path;

@property (nonatomic,copy) NSString *currentitle;

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation CMLSettingDetailVC

- (instancetype)initWithTitle:(NSString *) title{

    self = [super init];

    if (self) {
        self.currentitle = title;
    }
    return self;
}

- (void)viewDidLoad{

    [super viewDidLoad];
    self.navBar.titleContent = self.currentitle;
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.delegate = self;
    [self.navBar setLeftBarItem];
    
    [self loadData];
    
    [self loadViews];
    
}

- (void) loadData{

    [self stopIndicatorLoading];
    
    if ([self.currentitle isEqualToString:@"关于我们"]) {
        self.path = [[DataManager lightData] readAboutUsUrl];
    }else if ([self.currentitle isEqualToString:@"服务及隐私条款"]){
        self.path = [[DataManager lightData] readServiceAndPrivacyUrl];
    }else if ([self.currentitle isEqualToString:@"商城规则"]){
        self.path = [[DataManager lightData] readRuleUrl];
    }else if ([self.currentitle isEqualToString:@"关于产权保护说明"]){
        self.path = [[DataManager lightData] readIntellectualPropertyRightsUrl];
    }else if ([self.currentitle isEqualToString:@"用户协议"]) {
        self.path = [[DataManager lightData] readUrlAgreement];
    }

}

- (void) loadViews{

    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,
                                                               CGRectGetMaxY(self.navBar.frame),
                                                               WIDTH,
                                                               HEIGHT - CGRectGetHeight(self.navBar.frame) - SafeAreaBottomHeight)];
    NSURL *url = [NSURL URLWithString:self.path];
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.alwaysBounceHorizontal = NO;
    self.webView.navigationDelegate = self;

    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.contentView addSubview:self.webView];

}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{

    [self stopIndicatorLoading];

}

- (void) didSelectedLeftBarItem{

    if ([self.webView canGoBack]) {
        
        [self.webView goBack];
    }else{
        
         [[VCManger mainVC] dismissCurrentVC];
    }
   
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"PageTwoOfPersonalSetting"];
    
}

- (void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"PageTwoOfPersonalSetting"];
    
}

@end
