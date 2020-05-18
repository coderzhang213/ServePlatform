//
//  ActivityDetailMessageVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/7/25.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "ActivityDetailMessageVC.h"
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
#import "CustomTransition.h"
#import "DefaultTransition.h"



#define ServeDefaultVCVideoHeiight                          400
#define ServeDefaultVCVideoTopMargin                        40

#define VideoCVCellLeftMargin                               20
#define VideoCVCellVideoHeiight                             400
#define VideoCVCellBottomMargin                             40
#define VideoCVCellVideoTopMargin                           40



@interface ActivityDetailMessageVC ()<UIScrollViewDelegate,UINavigationControllerDelegate,WKNavigationDelegate,WKUIDelegate,NetWorkProtocol>


@property (nonatomic,strong) WKWebView *webView;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) UIView *videoView;

@property (nonatomic,assign) CGFloat realHeight;

@end

@implementation ActivityDetailMessageVC

- (instancetype)initWithObjId:(BaseResultObj *)obj{

    self = [super init];
    
    if (self) {
        
        self.obj = obj;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.hidden = YES;
    self.contentView.backgroundColor = [UIColor CMLWhiteColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [self loadViews];
    
    [self startLoading];
    
}


- (void) loadViews{
    
    
    
    self.webView = [[WKWebView alloc] init];
    
    if ([self.obj.retData.isRelVideo intValue] == 1) {
        
        /**视频*/
        self.videoView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  StatusBarHeight + NavigationBarHeight + 30*Proportion,
                                                                  WIDTH,
                                                                  (VideoCVCellVideoTopMargin + VideoCVCellVideoHeiight)*Proportion)];
        self.videoView.backgroundColor = [UIColor CMLWhiteColor];
        
        
        UIImageView *videoImage = [[UIImageView alloc] initWithFrame:CGRectMake(VideoCVCellLeftMargin*Proportion,
                                                                                VideoCVCellVideoTopMargin*Proportion,
                                                                                WIDTH - 2*VideoCVCellLeftMargin*Proportion,
                                                                                VideoCVCellVideoHeiight*Proportion)];
        videoImage.backgroundColor = [UIColor CMLPromptGrayColor];
        [NetWorkTask setImageView:videoImage WithURL:self.obj.retData.videoCoverPic placeholderImage:nil];
        videoImage.userInteractionEnabled = YES;
        [self.videoView addSubview:videoImage];
        
        UIButton *playVideoBtn = [[UIButton alloc] initWithFrame:CGRectMake(VideoCVCellLeftMargin*Proportion,
                                                                            VideoCVCellVideoTopMargin*Proportion,
                                                                            WIDTH - 2*VideoCVCellLeftMargin*Proportion,
                                                                            VideoCVCellVideoHeiight*Proportion)];
        [playVideoBtn setImage:[UIImage imageNamed:VideoPlayImg] forState:UIControlStateNormal];
        [playVideoBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
        [self.videoView addSubview:playVideoBtn];
        [self.contentView addSubview:self.videoView];
        
        self.webView.frame = CGRectMake(0,
                                        CGRectGetMaxY(self.videoView.frame),
                                        WIDTH,
                                        HEIGHT - CGRectGetMaxY(self.videoView.frame) - 20*Proportion - SafeAreaBottomHeight);
    }else{
        self.webView.frame = CGRectMake(0,
                                        StatusBarHeight + NavigationBarHeight + 30*Proportion,
                                        WIDTH,
                                        HEIGHT - (StatusBarHeight + NavigationBarHeight + 30*Proportion + 20*Proportion - SafeAreaBottomHeight));
    }
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.obj.retData.detailUrl]]];
    [self.contentView addSubview:self.webView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               WIDTH,
                                                               StatusBarHeight + NavigationBarHeight)];
    topView.backgroundColor = [UIColor CMLWhiteColor];
    topView.layer.shadowColor = [UIColor blackColor].CGColor;
    topView.layer.shadowOpacity = 0.05;
    topView.layer.shadowOffset = CGSizeMake(0, 0);
    [self.contentView addSubview:topView];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                   StatusBarHeight,
                                                                   NavigationBarHeight,
                                                                   NavigationBarHeight)];
    [backBtn setImage:[UIImage imageNamed:NewDetailMessageBlackBackImg] forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor clearColor];
    [topView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(dissCurrentDetailVC) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"活动详情";
    lab.font = KSystemFontSize16;
    [lab sizeToFit];
    lab.frame = CGRectMake(WIDTH/2.0 - lab.frame.size.width/2.0,
                           StatusBarHeight + NavigationBarHeight/2.0 - lab.frame.size.height/2.0,
                           lab.frame.size.width,
                           lab.frame.size.height);
    [topView addSubview:lab];
    
}


#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:( WKNavigation *)navigation{
    
    
    [self stopLoading];
    [webView getImageUrlByJS:webView];
    
    
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    [webView showBigImage:navigationAction.request];
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{

    [self stopLoading];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    if (operation == UINavigationControllerOperationPush) {
        
        return [CustomTransition transitionWith:PushCustomTransition];
        
    }else{
        
        return [DefaultTransition transitionWith:PopDefaultTransition];
        
    }
    
}

#pragma mark - video

- (void) playVideo{
    
    [self openmovie:self.obj.retData.relVideoLink];
    
    
}


-(void)openmovie:(NSString*) url{
    MPMoviePlayerViewController *movie = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:url]];
    
    [movie.moviePlayer prepareToPlay];
    [[VCManger mainVC] pushVC:movie animate:NO];
    
    [movie.view setFrame:CGRectMake(0,
                                    0,
                                    WIDTH,
                                    HEIGHT)];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(movieFinishedCallback:)
                                                name:MPMoviePlayerPlaybackDidFinishNotification
                                              object:movie.moviePlayer];
    
}
-(void)movieFinishedCallback:(NSNotification*)notify{
    
    // 视频播放完或者在presentMoviePlayerViewControllerAnimated下的Done按钮被点击响应的通知。
    
    MPMoviePlayerController* theMovie = [notify object];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerPlaybackDidFinishNotification
                                                 object:theMovie];
    [[VCManger mainVC] dismissCurrentVC];
}

#pragma mark - ActivityHeaderDelegate


- (void) dissCurrentDetailVC{
    
    [[VCManger mainVC] dismissCurrentVC];
    
}


@end
