//
//  WebViewLinkVC.m
//  camelliae2.0
//
//  Created by 张越 on 16/6/7.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "WebViewLinkVC.h"
#import "VCManger.h"
#import "AFNetworking.h"
#import "CommonNumber.h"
#import "InformationDefaultVC.h"
#import "ActivityDefaultVC.h"
#import "ServeDefaultVC.h"
#import "CMLAllImagesVC.h"
#import "CMLPhotoViewController.h"/*替换CMLAllImagesVC.h*/
#import "CMLCommodityDetailMessageVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>


@interface WebViewLinkVC ()<NavigationBarProtocol,UIWebViewDelegate,UIGestureRecognizerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation WebViewLinkVC

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"closeShareView" object:nil];
    [MobClick endLogPageView:@"PageTwoOfWebVC"];
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //分享页面关闭
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeCurrentShareView)
                                                 name:@"closeShareView"
                                               object:nil];
    
    [MobClick beginLogPageView:@"PageTwoOfWebVC"];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    self.navBar.titleColor = [UIColor CMLBlackColor];
    if (self.name) {
        self.navBar.titleContent = self.name;
    }
    [self.navBar setBlackCloseBarItem];
    
    if ([self.isShare intValue] == 1) {
        
        [self.navBar setNewShareBarItem];
    }
    
    [self setShareMes];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBar.delegate = self;

    /***************************************************/
    [self startLoading];
    
//    self.url = @"http://m.camelliae.com/builtin/project/603";
    
    if (self.isDetailMes) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,
                                                                   CGRectGetMaxY(self.navBar.frame),
                                                                   WIDTH,
                                                                    self.contentView.frame.size.height - CGRectGetMaxY(self.navBar.frame) - SafeAreaBottomHeight)];
        self.webView.scalesPageToFit = YES;
        self.webView.delegate = self;
        
        self.webView.backgroundColor = [UIColor CMLWhiteColor];
        NSString *skey = [[DataManager lightData] readSkey];
        NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
        NSString *hashToken = [NSString getEncryptStringfrom:@[skey,reqTime]];
        NSURL *newUrl;
        if ([_url hasPrefix:@"http"]) {
            newUrl = [NSURL URLWithString: self.url];
        }else{
            newUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",self.url]];
        }
        NSLog(@"***%@",newUrl);
        
        NSString *body = [NSString stringWithFormat: @"reqTime=%@&skey=%@&clientId=1&hashToken=%@",reqTime,skey,hashToken];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: newUrl];
        [request setHTTPMethod: @"POST"];
        [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
        [self.webView loadRequest: request];
        [self.contentView addSubview:self.webView];
        UILongPressGestureRecognizer * longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
        longPressed.delegate = self;
        [self.webView addGestureRecognizer:longPressed];
        
        
    }else{
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,
                                                                   CGRectGetMaxY(self.navBar.frame),
                                                                   WIDTH,
                                                                   self.contentView.frame.size.height - CGRectGetMaxY(self.navBar.frame) - SafeAreaBottomHeight)];
        self.webView.scalesPageToFit = YES;
        self.webView.delegate = self;
        self.webView.backgroundColor = [UIColor CMLWhiteColor];
        NSURL *newUrl;
        if ([_url hasPrefix:@"http"]) {
            newUrl = [NSURL URLWithString: self.url];
            
        }else{
            newUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",self.url]];
            
        }
        NSLog(@"***%@",newUrl);
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: newUrl];
        [self.webView loadRequest: request];
        
        [self.contentView addSubview:self.webView];
        UILongPressGestureRecognizer * longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
        longPressed.delegate = self;
        [self.webView addGestureRecognizer:longPressed];
    }
    
}

- (void)longPressed:(UITapGestureRecognizer*)recognizer{
    
    //只在长按手势开始的时候才去获取图片的url
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint touchPoint = [recognizer locationInView:self.webView];
    
    NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    NSString *urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:js];
    
    if (urlToSave.length == 0) {
        return;
    }
    
    NSLog(@"获取到图片地址：%@",urlToSave);

        
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        
        if (author ==kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
            
            //无权限 引导去开启
            
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                
                [[UIApplication sharedApplication] openURL:url];
                
            }
        }else{
            
            UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *showAllInfoAction = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlToSave]]], self, nil, nil);
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [actionSheetController addAction:cancelAction];
            [actionSheetController addAction:showAllInfoAction];
            
            [self presentViewController:actionSheetController animated:YES completion:nil];
            
            
        }
        
    
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //判断是否是单击
        
        if (navigationType == UIWebViewNavigationTypeLinkClicked) {
            
            NSString *url=[NSString stringWithFormat:@"%@",request.URL];
            
            NSArray *array =  [url componentsSeparatedByString:@"/"];
            
            NSNumber *objType = array[array.count - 3];
            NSNumber *objId = [array lastObject];

            
            if([objType intValue] == 1){
                
                /**咨询*/
                InformationDefaultVC *vc = [[InformationDefaultVC alloc] initWithObjId:objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
                
                
            }else if([objType intValue] == 2){
                
                /**活动详情*/
                ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
                
            }else if ([objType intValue] == 3){
                
                /**服务详情*/
                ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
                
            }else if ([objType intValue] == 4){
                
                /**相册*/
//                CMLAllImagesVC *vc = [[CMLAllImagesVC alloc] initWithAlbumId:objId ImageName:@""];
//                [[VCManger mainVC] pushVC:vc animate:YES];
                CMLPhotoViewController *vc = [[CMLPhotoViewController alloc] initWithAlbumId:objId ImageName:@""];
                [[VCManger mainVC] pushVC:vc animate:YES];
                
            }else if ([objType intValue] == 7){
            
                CMLCommodityDetailMessageVC *vc = [[CMLCommodityDetailMessageVC alloc] initWithObjId:objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
            }else{
                
                return YES;
            }
            
            return NO;
        }
    
    return YES;
}

- (void) didSelectedLeftBarItem{
    
//    [[VCManger mainVC] dismissCurrentVC];
    
    if ([self.webView canGoBack]) {
        
        [self.webView goBack];
    }else{
        
        [[VCManger mainVC] dismissCurrentVC];
    }
    
    
}



- (void)didSelectedRightBarItem{

    [self showCurrentVCShareView];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{

    [self stopLoading];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    [self stopLoading];
}

#pragma mark - setShareMes
- (void) setShareMes{
    
    
    NSData *imageNata = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]];
    UIImage *image = [UIImage imageWithData:imageNata];
    /********shareblock********/
    
    self.baseShareTitle = self.name;
    self.baseShareContent = self.desc;
    self.baseShareImage = image;
    self.baseShareLink = self.shareUrl;
    self.shareSuccessBlock = ^(){
        
    };
    
    self.sharesErrorBlock = ^(){
        
    };
    
    

}

#pragma mark - closeCurrentShareView
- (void) closeCurrentShareView{
    
    [self hiddenCurrentVCShareView];
}


@end
