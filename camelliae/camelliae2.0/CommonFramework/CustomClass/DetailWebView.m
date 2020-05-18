//
//  DetailWebView.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/27.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "DetailWebView.h"
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

#define VideoCVCellLeftMargin                               20
#define VideoCVCellVideoHeiight                             400
#define VideoCVCellBottomMargin                             40
#define VideoCVCellVideoTopMargin                           40


@interface DetailWebView()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) WKWebView *webView;

@property (nonatomic,strong) UIView *videoView;

@property (nonatomic,strong) UIButton *moreMesView;

@property (nonatomic,assign) CGFloat realHeight;

@end

@implementation DetailWebView

- (instancetype)initWith:(BaseResultObj *) obj{

    self = [super init];
    if (self) {
     
        self.obj = obj;
        [self loadViews];
    }
    return self;
}

- (void) loadViews{

    self.webView = [[WKWebView alloc] init];
    
    if ([self.obj.retData.isRelVideo intValue] == 1) {
        
        /**视频*/
        self.videoView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
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
        [self addSubview:self.videoView];
        
        self.webView.frame = CGRectMake(0,
                                        CGRectGetMaxY(self.videoView.frame),
                                        WIDTH,
                                        8000);
    }else{
        self.webView.frame = CGRectMake(0,
                                        0,
                                        WIDTH,
                                        8000);
    }
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.obj.retData.detailUrl]]];
    [self addSubview:self.webView];

}


#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:( WKNavigation *)navigation{
    
    __weak typeof(self) weakSelf = self;
    [self.webView evaluateJavaScript:@"document.body.offsetHeight"completionHandler:^(id result,NSError * _Nullable error) {
        //获取页面高度，并重置webview的frame
       
        
        weakSelf.webView.frame = CGRectMake(webView.frame.origin.x,
                                            webView.frame.origin.y,
                                            WIDTH,
                                            1100*Proportion);
        
        weakSelf.loadWebViewFinish(1180*Proportion);
        
        weakSelf.realHeight = [result doubleValue];
        
        weakSelf.moreMesView = [[UIButton alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                          CGRectGetMaxY(weakSelf.webView.frame) + 20*Proportion,
                                                                          WIDTH - 30*Proportion*2,
                                                                          60*Proportion)];
        weakSelf.moreMesView.backgroundColor = [UIColor CMLBrownColor];
        [weakSelf.moreMesView setTitle:@"查看详情" forState:UIControlStateNormal];
        [weakSelf.moreMesView setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
        [weakSelf.moreMesView setImage:[UIImage imageNamed:ShowDetailMessageImg] forState:UIControlStateNormal];
        CGSize strSize1 = [weakSelf.moreMesView.currentTitle sizeWithFontCompatible:KSystemFontSize13];
        weakSelf.moreMesView.titleLabel.font = KSystemFontSize13;
        [weakSelf.moreMesView setTitleEdgeInsets:UIEdgeInsetsMake(0,
                                                                  - weakSelf.moreMesView.currentImage.size.width - 30*Proportion*2,
                                                                  0,
                                                                  0)];
        [weakSelf.moreMesView setImageEdgeInsets:UIEdgeInsetsMake(0,
                                                                  strSize1.width + weakSelf.moreMesView.currentImage.size.width + 30*Proportion,
                                                                  0,
                                                                  0)];
        [self addSubview:weakSelf.moreMesView];
        [weakSelf.moreMesView addTarget:self action:@selector(showDetailMessage) forControlEvents:UIControlEventTouchUpInside];
        
       
    }];
    
    [webView getImageUrlByJS:webView];
    
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    [webView showBigImage:navigationAction.request];
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

#pragma mark - video

- (void) playVideo{
    
    [self openmovie:self.obj.retData.relVideoLink];
    
    
}


-(void)openmovie:(NSString*) url{
    MPMoviePlayerViewController *movie = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:url]];
    
    [movie.moviePlayer prepareToPlay];
    [[VCManger mainVC] pushVC:movie animate:NO];
    
    [movie.view setFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
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

#pragma mark - showDetailMessage
- (void) showDetailMessage{

    self.webView.frame = CGRectMake(self.webView.frame.origin.x,
                                    self.webView.frame.origin.y,
                                    WIDTH,
                                    self.realHeight);
    self.moreMesView.hidden = YES;
    self.showAllMessage(self.realHeight);
    
}
@end
