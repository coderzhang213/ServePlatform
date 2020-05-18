//
//  DetailMoreMessageWebView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/3/30.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "DetailMoreMessageWebView.h"
#import "BaseResultObj.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "CommonImg.h"
#import <WebKit/WebKit.h>
#import "WKWebView+CMLExspand.h"
#import "UIColor+SDExspand.h"
#import "NSString+CMLExspand.h"
#import "NetWorkTask.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VCManger.h"

#define ServeDefaultVCVideoHeiight                          400
#define ServeDefaultVCVideoTopMargin                        40


@interface DetailMoreMessageWebView()<WKNavigationDelegate,WKUIDelegate,UICollectionViewDelegate,UIWebViewDelegate>

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,assign) CGFloat realHeight;

@property (nonatomic,strong) WKWebView *costInfoWebView;

@property (nonatomic,strong) WKWebView *guidelinesWebView;

@property (nonatomic,strong) UIView *bgView;


@end
@implementation DetailMoreMessageWebView

- (instancetype)initWith:(BaseResultObj *) obj{
    
    self = [super init];
    if (self) {
        
        self.obj = obj;
        self.backgroundColor = [UIColor clearColor];
        [self loadViews];
    }
    return self;
}

- (void) loadViews{
    
    /**主界面*/

    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor CMLWhiteColor];
    self.bgView.frame = CGRectMake(20*Proportion,
                                   0,
                                   WIDTH - 20*Proportion*2,
                                   0);
    [self addSubview:self.bgView];
    
    
    
    if (self.obj.retData.url) {
        
        self.costInfoWebView = [[WKWebView alloc] initWithFrame:CGRectMake(20*Proportion,
                                                                           0,
                                                                           WIDTH - 40*Proportion*2,
                                                                           0)];
        self.costInfoWebView.UIDelegate = self;
        self.costInfoWebView.scrollView.delegate = self;
        self.costInfoWebView.navigationDelegate = self;
        self.costInfoWebView.scrollView.alwaysBounceVertical = NO;
        self.costInfoWebView.scrollView.alwaysBounceHorizontal = NO;
        self.costInfoWebView.scrollView.bounces = NO;
        self.costInfoWebView.scrollView.bouncesZoom = NO;
        self.costInfoWebView.backgroundColor = [UIColor whiteColor];
        [self.costInfoWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.obj.retData.url]]];
        [self.bgView addSubview:self.costInfoWebView];
        
        
        
    }else{

        if (self.obj.retData.guideLinesUrl) {
            
            self.guidelinesWebView = [[WKWebView alloc] initWithFrame:CGRectMake(20*Proportion,
                                                                                 0,
                                                                                 WIDTH - 40*Proportion*2,
                                                                                 HEIGHT)];
            self.guidelinesWebView.UIDelegate = self;
            self.guidelinesWebView.scrollView.delegate = self;
            self.guidelinesWebView.navigationDelegate = self;
            self.guidelinesWebView.scrollView.alwaysBounceVertical = NO;
            self.guidelinesWebView.scrollView.alwaysBounceHorizontal = NO;
            self.guidelinesWebView.scrollView.bounces = NO;
            self.guidelinesWebView.scrollView.bouncesZoom = NO;
            self.guidelinesWebView.scrollView.scrollEnabled = NO;
            self.guidelinesWebView.backgroundColor = [UIColor whiteColor];
            [self.guidelinesWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.obj.retData.guideLinesUrl]]];
            [self.bgView addSubview:self.guidelinesWebView];
            
            
        }else{
        
            
            self.loadWebViewFinish(0);
        }
    }
}


#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:( WKNavigation *)navigation{
    
    __weak typeof(self) weakSelf = self;
    
    if (self.costInfoWebView) {
     
            [self.costInfoWebView evaluateJavaScript:@"document.documentElement.scrollHeight"completionHandler:^(id result,NSError * _Nullable error) {
                //获取页面高度，并重置webview的frame
                
                
                if (weakSelf.obj.retData.guideLinesUrl) {
                    
                    weakSelf.costInfoWebView.frame = CGRectMake(20*Proportion,
                                                                0,
                                                                WIDTH - 40*Proportion*2,
                                                                [result doubleValue]);
                    
                    
                    self.guidelinesWebView = [[WKWebView alloc] initWithFrame:CGRectMake(20*Proportion,
                                                                                         CGRectGetMaxY(weakSelf.costInfoWebView.frame),
                                                                                         WIDTH - 40*Proportion*2,
                                                                                         HEIGHT)];
                    self.guidelinesWebView.UIDelegate = self;
                    self.guidelinesWebView.scrollView.delegate = self;
                    self.guidelinesWebView.navigationDelegate = self;
                    self.guidelinesWebView.scrollView.alwaysBounceVertical = NO;
                    self.guidelinesWebView.scrollView.alwaysBounceHorizontal = NO;
                    self.guidelinesWebView.scrollView.bounces = NO;
                    self.guidelinesWebView.scrollView.bouncesZoom = NO;
                    self.guidelinesWebView.scrollView.scrollEnabled = NO;
                    self.guidelinesWebView.backgroundColor = [UIColor whiteColor];
                    [self.costInfoWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.obj.retData.guideLinesUrl]]];
                    [self.bgView addSubview:self.guidelinesWebView];
                    
                    if (self.bottomHeight) {
                        
                        self.bgView.frame = CGRectMake(20*Proportion,
                                                       0,
                                                       WIDTH - 20*Proportion*2,
                                                       CGRectGetMaxY(self.guidelinesWebView.frame) + self.bottomHeight);
                    }else{
                    
                        self.bgView.frame = CGRectMake(20*Proportion,
                                                       0,
                                                       WIDTH - 20*Proportion*2,
                                                       CGRectGetMaxY(self.guidelinesWebView.frame));
                    }
                    

                    
                }else{
                    
                    weakSelf.costInfoWebView.frame = CGRectMake(20*Proportion,
                                                                0,
                                                                WIDTH - 40*Proportion*2,
                                                                [result doubleValue]);
                    
                    if (self.bottomHeight) {
                        
                        self.bgView.frame = CGRectMake(20*Proportion,
                                                       0,
                                                       WIDTH - 20*Proportion*2,
                                                       CGRectGetMaxY(self.costInfoWebView.frame) + self.bottomHeight);
                    }else{
                        
                        self.bgView.frame = CGRectMake(20*Proportion,
                                                       0,
                                                       WIDTH - 20*Proportion*2,
                                                       CGRectGetMaxY(self.costInfoWebView.frame));
                    }
                    
                    weakSelf.loadWebViewFinish(CGRectGetMaxY(self.bgView.frame));
                    
                }
                
            }];
            
            [webView getImageUrlByJS:webView];
    }
    
    if (self.guidelinesWebView) {
        
        
            [self.guidelinesWebView evaluateJavaScript:@"document.body.offsetHeight"completionHandler:^(id result,NSError * _Nullable error) {
                //获取页面高度，并重置webview的frame
                
                
                if (weakSelf.costInfoWebView) {
                    
                    weakSelf.guidelinesWebView.frame = CGRectMake(20*Proportion,
                                                                  CGRectGetMaxY(weakSelf.costInfoWebView.frame),
                                                                  WIDTH - 40*Proportion*2,
                                                                  [result doubleValue] + 50*Proportion);
                    
                    if (self.bottomHeight) {
                        
                        self.bgView.frame = CGRectMake(20*Proportion,
                                                       0,
                                                       WIDTH - 20*Proportion*2,
                                                       CGRectGetMaxY(self.guidelinesWebView.frame) + self.bottomHeight);
                    }else{
                        
                        self.bgView.frame = CGRectMake(20*Proportion,
                                                       0,
                                                       WIDTH - 20*Proportion*2,
                                                       CGRectGetMaxY(self.guidelinesWebView.frame));
                    }
                    
                    
                     weakSelf.loadWebViewFinish(CGRectGetMaxY(weakSelf.bgView.frame));
                    
                }else{
                    
                    
                    weakSelf.guidelinesWebView.frame = CGRectMake(20*Proportion,
                                                                  0,
                                                                  WIDTH - 40*Proportion*2,
                                                                  [result doubleValue] + 50*Proportion);
                    
                    if (self.bottomHeight) {
                        
                        self.bgView.frame = CGRectMake(20*Proportion,
                                                       0,
                                                       WIDTH - 20*Proportion*2,
                                                       CGRectGetMaxY(self.guidelinesWebView.frame) + self.bottomHeight);
                    }else{
                        
                        self.bgView.frame = CGRectMake(20*Proportion,
                                                       0,
                                                       WIDTH - 20*Proportion*2,
                                                       CGRectGetMaxY(self.guidelinesWebView.frame));
                    }
                    
                    weakSelf.loadWebViewFinish(CGRectGetMaxY(weakSelf.bgView.frame));
                    
                }
                
                
            }];
            
            [webView getImageUrlByJS:webView];
        
    }
    
    if (self.bottomHeight > 0) {
        
        self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.bgView.layer.shadowOpacity = 0.05;
        self.bgView.layer.shadowOffset = CGSizeMake(0, 0);

    }
}


@end
