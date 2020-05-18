//
//  CMLSettingDetailVC.m
//  camelliae1.0
//
//  Created by 张越 on 16/4/15.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLCamelliaeVIPDetailVC.h"
#import "VCManger.h"
#import <WebKit/WebKit.h>

@interface CMLCamelliaeVIPDetailVC ()<NavigationBarProtocol,WKNavigationDelegate>

@property (nonatomic,strong) NSString *path;

@property (nonatomic,copy) NSString *currentitle;

@end

@implementation CMLCamelliaeVIPDetailVC

- (instancetype)initWithTitle:(NSString *) currentitle{

    self = [super init];
    if (self) {
        self.currentitle = currentitle;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad{

    [super viewDidLoad];
    self.navBar.backgroundColor = [UIColor blackColor];
    self.navBar.titleContent = self.currentitle;
    self.navBar.titleColor = [UIColor CMLYellowColor];
    self.navBar.delegate = self;
    [self.navBar setYellowLeftBarItem];
    
    [self loadData];
    [self loadViews];
    
}


- (void) loadData{

    [self startLoading];
    if ([self.currentitle isEqualToString:@"花伴权利"]) {
//        self.path = [[NSBundle mainBundle] pathForResource:@"right" ofType:@"html"];
        self.path = [[DataManager lightData] readFlowersWithPowerUrl];
    }else if ([self.currentitle isEqualToString:@"快速升级"]){
//        self.path = [[NSBundle mainBundle] pathForResource:@"upgrade" ofType:@"html"];
        self.path = [[DataManager lightData] readFlowersWithUpgradeUrl];
    }else{
//        self.path = [[NSBundle mainBundle] pathForResource:@"grade" ofType:@"html"];
        self.path = [[DataManager lightData] readFlowersWithLevel];
    }
}

- (void) loadViews{

    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,
                                                                     CGRectGetMaxY(self.navBar.frame),
                                                                     WIDTH,
                                                                     HEIGHT - CGRectGetHeight(self.navBar.frame) - SafeAreaBottomHeight)];
    NSURL *url = [NSURL URLWithString:self.path];
    webView.scrollView.bounces = NO;
    webView.navigationDelegate = self;
    webView.scrollView.alwaysBounceHorizontal = NO;
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.contentView addSubview:webView];

}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{

    [self stopLoading];

}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{

    [self stopLoading];
}

- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];

}
@end
