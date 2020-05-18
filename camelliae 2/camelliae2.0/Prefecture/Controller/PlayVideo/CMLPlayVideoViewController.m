//
//  CMLPlayVideoViewController.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/9/20.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLPlayVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "CMLPlayerView.h"
#import "CMLVoiceAndLight.h"
#import "VCManger.h"

#define OFFSET 5.0 /*快进快退时间进度*/
#define ALPHA 0.7 /*headerView和bottomView透明度*/

static void *playerItemDurationContext = &playerItemDurationContext;/*持续时间*/
static void *playerItemStatusContext   = &playerItemStatusContext;  /*状态*/
static void *playerPlayingContext      = &playerPlayingContext;

@interface CMLPlayVideoViewController ()<NavigationBarProtocol, CMLVoiceAndLightFastForwardDelegate>

@property (nonatomic, strong) UISlider *progressSlider;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, strong) CMLPlayerView *playerView;

@property (nonatomic, assign) BOOL isPlaying;/*是否正在播放*/

@property (nonatomic, assign) BOOL canPlay;/*是否可以播放*/

@property (nonatomic, assign) CMTime duration;/*视频持续时间（总）*/

@property (nonatomic, strong) UIButton *fastBackwardBtn;/*快退*/

@property (nonatomic, strong) UIButton *playButton;/*播放/暂停*/

@property (nonatomic, strong) UIButton *fastForwardBtn;/*快进*/

@property (nonatomic, strong) id timeObserver;

@property (nonatomic, strong) UILabel *currentTimeLabel;/*当前播放时间*/

@property (nonatomic, strong) UILabel *remainTimeLabel;/*剩余时间*/

@property (nonatomic, strong) UILabel *intervalLabel;/*间隔斜杠*/

@property (nonatomic, strong) UISlider *progressView;/*播放进度*/

@property (nonatomic, assign) BOOL isPlayer;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIImageView *bottomView;

@property (nonatomic, strong) NSURL *mediaUrl;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIButton *bigViewButton;

@property (nonatomic, strong) CMLVoiceAndLight *voiceAndLight;

@property (nonatomic, assign) BOOL bigView;

@end

@implementation CMLPlayVideoViewController

- (instancetype)initWithHTTPMediaURL:(NSURL *)url {
    self = [super init];
    if (self) {
        self.mediaUrl = url;
        [self setHTTPMediaURL];
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.hidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    self.navBar.hidden = YES;

    [self loadMVPlayer];
    [self loadHeaderView];
    [self loadBottomView];
    
    [self.progressView setMinimumTrackImage:[[UIImage imageNamed:@"video_num_front"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    
    [self.progressView setMaximumTrackImage:[[UIImage imageNamed:@"video_num_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    
    [self.progressView setThumbImage:[UIImage imageNamed:@"progressThumb"] forState:UIControlStateNormal];
    
    /*kvo观察isPlaying改变playButton状态*/
    [self addObserver:self forKeyPath:@"isPlaying" options:NSKeyValueObservingOptionNew context:playerPlayingContext];
    
    /*打电话/锁屏时暂停播放*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    /*继续播放*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)appWillResignActive:(NSNotification *)notification {
    [self.player pause];
    self.isPlaying = NO;
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    [self.player play];
    self.isPlaying = YES;
}

- (void)setHTTPMediaURL {
    self.playerItem = [AVPlayerItem playerItemWithURL:self.mediaUrl];
}

- (void)loadMVPlayer {
    /*观察self.playItem.status属性变化，变为AVPlayerItemStatusReadyToPlay时就可以播放了*/
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:playerItemStatusContext];
    /*监听播放到最后*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerView = [[CMLPlayerView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, WIDTH*9/16)];
    
    /*关联*/
    [self.playerView setPlayer:self.player];
    [self.playerView.layer setBackgroundColor:[UIColor blackColor].CGColor];
    
    [self.view addSubview:self.playerView];
    
    /*音量和亮度*/
    self.voiceAndLight = [[CMLVoiceAndLight alloc] initWithFrame:self.playerView.bounds];
    self.voiceAndLight.delegate = self;
    [self.playerView addSubview:self.voiceAndLight];
    
    /*手势*/
    UITapGestureRecognizer *tapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(play:)];
    tapTwo.numberOfTapsRequired = 2;
    [self.playerView addGestureRecognizer:tapTwo];
    
    UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerAndBottomTap)];
    tapOne.numberOfTapsRequired = 1;
    [self.playerView addGestureRecognizer:tapOne];
    
    /*解决手势冲突：滑动时令点击手势失效*/
    [self.voiceAndLight.centerSwipeGestureRecognizerLeft requireGestureRecognizerToFail:tapOne];
    [self.voiceAndLight.centerSwipeGestureRecognizerRight requireGestureRecognizerToFail:tapOne];
    
    [self.player play];
}

#pragma mark - 上状态栏
- (void)loadHeaderView {
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    self.headerView.userInteractionEnabled = YES;
    [self.playerView addSubview:self.headerView];
    
    /*返回按钮*/
    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.backButton.frame = CGRectMake(0, 0, 44, 40);
    [self.backButton setImage:[[UIImage imageNamed:@"detail_backbtn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.backButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 24);
    [self.backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.backButton];
    
    /*全屏*/
    self.bigViewButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.bigViewButton.frame = CGRectMake(self.headerView.size.width - 44, 0, 44, 40);
    [self.bigViewButton setImage:[[UIImage imageNamed:@"detail_big"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.bigViewButton.contentEdgeInsets = UIEdgeInsetsMake(10, 14, 10, 10);
    [self.bigViewButton addTarget:self action:@selector(bigViewButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.bigViewButton];
}

#pragma mark - 下状态栏
- (void)loadBottomView {
    self.bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.playerView.frame.size.height - 50, WIDTH, 50)];
    self.bottomView.alpha = ALPHA;
    self.bottomView.userInteractionEnabled = YES;
    self.bottomView.image = [UIImage imageNamed:@"detail_play_bg"];
    [self.playerView addSubview:self.bottomView];
    
    /*播放/暂停*/
    self.playButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.playButton.frame = CGRectMake(0, 5, 44, 40);
    [self.playButton setImage:[[UIImage imageNamed:@"play_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.playButton];
    
    /*进度*/
    self.progressView = [[UISlider alloc] initWithFrame:CGRectMake(45, 21, WIDTH - 60 - 80, 10)];
    [self.progressView addTarget:self action:@selector(slidingProgress:) forControlEvents:UIControlEventValueChanged];
    [self.progressView addTarget:self action:@selector(slidingEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self.progressView addTarget:self action:@selector(slidingEnded:) forControlEvents:UIControlEventTouchUpOutside];
    [self.bottomView addSubview:self.progressView];
    
    /*手势*/
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapGestureRecognizer:)];
    [self.progressView addGestureRecognizer:tapGestureRecognizer];
    
    self.currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 90, 5, 45, 40)];
    self.currentTimeLabel.text = @"00:00";
    self.currentTimeLabel.font = [UIFont systemFontOfSize:12];
    self.currentTimeLabel.textColor = [UIColor whiteColor];
    self.currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.bottomView addSubview:self.currentTimeLabel];
    
    self.intervalLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 45 - 45/2, 5, 45, 40)];
    self.intervalLabel.text = @"/";
    self.intervalLabel.font = [UIFont systemFontOfSize:12];
    self.intervalLabel.textColor = [UIColor whiteColor];
    self.intervalLabel.textAlignment = NSTextAlignmentCenter;
    [self.bottomView addSubview:self.intervalLabel];
    
    self.remainTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 45, 5, 45, 40)];
    self.remainTimeLabel.text = @"00:00";
    self.remainTimeLabel.font = [UIFont systemFontOfSize:12];
    self.remainTimeLabel.textColor = [UIColor whiteColor];
    self.remainTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.bottomView addSubview:self.remainTimeLabel];
}

- (void)playerItemDidPlayToEnd:(NSNotification *)notification {
    [self.playerItem seekToTime:kCMTimeZero];
    self.isPlaying = NO;
}

#pragma mark - 返回上一页面
- (void)backButtonAction {
    if (self.bigView == YES) {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        self.playerView.frame = CGRectMake(0, StatusBarHeight, WIDTH, WIDTH*9/16);
        self.bigView = NO;
    }else {
        [self.player pause];
        [self dismissPlayViewController];
    }
}

- (void)dismissPlayViewController {
    [[VCManger mainVC] dismissCurrentVC];
}

/*转换全屏*/
- (void)bigViewButtonAction {
    if (self.bigView == NO) {
        self.playerView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
        self.bigView = YES;
    }else {
        self.playerView.frame = CGRectMake(0, StatusBarHeight, WIDTH, WIDTH*9/16);
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        self.bigView = NO;
    }
    
}

/*layoutUI*/
- (void)layoutUI {
    self.headerView.frame = CGRectMake(0, 0, WIDTH, 40);
    self.bottomView.frame = CGRectMake(0, self.playerView.frame.size.height - 50, WIDTH, 50);
    self.bigViewButton.frame = CGRectMake(self.headerView.frame.size.width - 44, 0, 44, 40);
    self.progressView.frame = CGRectMake(45, 21, WIDTH - 60 - 80, 10);
    self.currentTimeLabel.frame = CGRectMake(WIDTH - 90, 5, 45, 40);
    self.intervalLabel.frame = CGRectMake(WIDTH - 45 - 45/2, 5, 45, 40);
    self.remainTimeLabel.frame = CGRectMake(WIDTH - 45, 5, 45, 40);
    self.voiceAndLight.frame = self.playerView.bounds;
}

- (void)headerAndBottomTap {
    if (self.headerView.alpha == 0.0) {
        [self showHeaderViewAndBottomView];
    }else {
        [self hideHeaderViewAndBottomView];
        [self cancelPerformSelector:@selector(hideHeaderViewAndBottomView)];
    }
}

//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//    if (!self.isPlayer) {
//        self.isPlayer = YES;
//        [self.player play];
//    }else {
//        self.isPlayer = NO;
//        [self.player pause];
//    }
//
//}

#pragma mark - 播放/暂停
- (void)play:(UIButton *)sender {
    [self cancelPerformSelector:@selector(hideHeaderViewAndBottomView)];
    if (!self.isPlaying) {
        [self.player play];
        self.isPlaying = YES;
    }else {
        [self.player pause];
        self.isPlaying = NO;
    }
    [self delayHideHeaderViewAndBottomView];
}

#pragma mark - 快进
- (void)fastForward {
    [self cancelPerformSelector:@selector(hideHeaderViewAndBottomView)];
    [self progressAdd:OFFSET];
    [self delayHideHeaderViewAndBottomView];
}

#pragma mark - 快退
- (void)fastBackward {
    [self cancelPerformSelector:@selector(hideHeaderViewAndBottomView)];
    [self progressAdd:-OFFSET];
    [self delayHideHeaderViewAndBottomView];
}

#pragma mark - 快进/快退进度调整
- (void)progressAdd:(CGFloat)step {
    /*如果正在播放则暂停--但不令isPlaying的值为NO：快进或快退后需要根据isPlaying的值判断是否继续播放，快进/快退后进行播放定位*/
    if (self.isPlaying) {
        [self.player pause];
    }
    Float64 currentSecond = CMTimeGetSeconds(self.player.currentTime);/*当前秒数*/
    Float64 totalSeconds = CMTimeGetSeconds(self.duration);/*总时间*/
    
    CMTime purposeTime;/*目标时间*/
    if (currentSecond + step >= totalSeconds) {
        purposeTime = CMTimeSubtract(self.duration, CMTimeMakeWithSeconds(1, self.duration.timescale));
        self.progressView.value = purposeTime.value / self.duration.value;
    }else if(currentSecond + step < 0.0){
        purposeTime = kCMTimeZero;
        self.progressView.value = 0.0;
    }else {
        purposeTime = CMTimeMakeWithSeconds(currentSecond + step, self.player.currentTime.timescale);
        self.progressView.value += step / CMTimeGetSeconds(self.duration);
    }
    
}
/*调整播放点*/
- (void)seekToCMTime:(CMTime)time progress:(CGFloat)progress {
    [self.player seekToTime:time];
}
/*拖动进度条改变播放点*/
- (void)slidingProgress:(UISlider *)slider {
    /*取消调用hideHeaderViewAndBottomView，不隐藏*/
    [self cancelPerformSelector:@selector(hideHeaderViewAndBottomView)];
    Float64 totalSeconds = CMTimeGetSeconds(self.duration);
    CMTime time = CMTimeMakeWithSeconds(totalSeconds * slider.value, self.duration.timescale);
    [self seekToCMTime:time progress:self.progressView.value];
}
/*拖动手势取消后延迟调用hideHeaderViewAndBottomView*/
- (void)slidingEnded:(UISlider *)sender {
    [self delayHideHeaderViewAndBottomView];
}

- (void)sliderTapGestureRecognizer:(UITapGestureRecognizer *)sender {
    [self cancelPerformSelector:@selector(hideHeaderViewAndBottomView)];
    
    CGFloat tapX = [sender locationInView:sender.view].x;
    CGFloat sliderWith = sender.view.bounds.size.width;
    Float64 totalSeconds = CMTimeGetSeconds(self.duration);/*总时间*/
    CMTime purposeTime = CMTimeMakeWithSeconds(totalSeconds * (tapX / sliderWith), self.duration.timescale);
    [self seekToCMTime:purposeTime progress:self.progressView.value];
    [self delayHideHeaderViewAndBottomView];
}

#pragma mark - 取消调用某方法
- (void)cancelPerformSelector:(SEL)selector {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:selector object:nil];
}

#pragma mark - 延迟调用hideHeaderViewAndBottomView方法
- (void)delayHideHeaderViewAndBottomView {
    [self performSelector:@selector(hideHeaderViewAndBottomView) withObject:nil afterDelay:5.0f];
}

#pragma mark - 隐藏和显示HeaderViewAndBottomView
- (void)hideHeaderViewAndBottomView {
    [UIView animateWithDuration:0.5 animations:^{
        [self.headerView setAlpha:0.0];
        [self.bottomView setAlpha:0.0];
    }];
}

- (void)showHeaderViewAndBottomView {
    [UIView animateWithDuration:0.5 animations:^{
        [self.headerView setAlpha:ALPHA];
        [self.bottomView setAlpha:ALPHA];
    }];
}

#pragma mark - 状态栏和屏幕方向
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}
/*允许自动旋转*/
- (BOOL)shouldAutorotate {
    return YES;
}
/*支持的屏幕方向*/
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

/*优先竖屏*/
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationPortrait:/*home在下*/
            self.playerView.frame = CGRectMake(0, StatusBarHeight, WIDTH, WIDTH*9/16);
            self.bigView = NO;
            break;
        
        case UIInterfaceOrientationPortraitUpsideDown:/*home在上*/
            break;
        
        case UIInterfaceOrientationLandscapeLeft:/*home在左*/
            self.playerView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
            self.bigView = YES;
            break;
            
        case UIInterfaceOrientationLandscapeRight:/*home在右*/
            self.playerView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
            self.bigView = YES;
            break;
            
        default:
            break;
    }
    [self layoutUI];
}

#pragma mark - CMLVoiceAndLightFastForwardDelegate
- (void)fastFront {
    [self fastForward];
}

- (void)fastBack {
    [self fastBackward];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == playerItemStatusContext) {
        if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
            /*准备就绪*/
            dispatch_async(dispatch_get_main_queue(), ^{
                [self readyToPlay];
            });
        }else {
            /*如果资源不能播放--延迟dismiss playController*/
            [self performSelector:@selector(dismissPlayViewController) withObject:nil afterDelay:3.0f];
        }
    }else if (context == playerPlayingContext) {
        [self.playButton setImage:[[UIImage imageNamed:@"pause_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([[change objectForKey:@"new"] intValue] == 1) {
                /*isPlaying为YES时按钮显示暂停图标*/
                [self.playButton setImage:[[UIImage imageNamed:@"pause_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            }else {
                [self.playButton setImage:[[UIImage imageNamed:@"play_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            }
//        });
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark AVPlayerItemStatus ReadyToPlay
- (void)readyToPlay {
    /*视频可播放时自动隐藏*/
    [self delayHideHeaderViewAndBottomView];
    self.canPlay = YES;
    [self.playButton setEnabled:YES];
    [self.fastBackwardBtn setEnabled:YES];
    [self.fastForwardBtn setEnabled:YES];
    [self.progressView setEnabled:YES];
    
    self.duration = self.playerItem.duration;
    /*未播放前剩余时间=视频长度*/
    self.remainTimeLabel.text = [NSString stringWithFormat:@"%@", [self timeStringWithCMTime:self.duration]];
    
    __weak typeof(self) weakSelf = self;
    /**更新当前播放条已播放时间 CMTimeMake(3, 30) == (Float64)3/30 秒*/
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30) queue:nil usingBlock:^(CMTime time) {
        
        /*当前播放时间*/
        weakSelf.currentTimeLabel.text = [weakSelf timeStringWithCMTime:time];
        
        /*剩余时间*/
        NSString *text = [weakSelf timeStringWithCMTime:CMTimeSubtract(weakSelf.duration, time)];
        weakSelf.remainTimeLabel.text = text;
        
        /*更新进度*/
        weakSelf.progressView.value = CMTimeGetSeconds(time)/CMTimeGetSeconds(weakSelf.duration);
    }];
    
    [self.playButton setImage:[[UIImage imageNamed:@"pause_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.isPlaying = YES;
    
}

#pragma mark - 根据CMTime生成时间字符串
- (NSString *)timeStringWithCMTime:(CMTime)time {
    Float64 seconds = time.value / time.timescale;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];/*把seconds作为时间戳获得date*/
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    /*设置时间格式*/
    [formatter setDateFormat:(seconds/3600 >= 1) ? @"h:mm:ss" : @"mm:ss"];
    
    return [formatter stringFromDate:date];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (self.headerView.alpha == 0.0) {
        
    }else {
        [self delayHideHeaderViewAndBottomView];
    }
}

#pragma mark - dealloc
- (void)dealloc {
    
    [self.player pause];
    
    [self.playerItem removeObserver:self forKeyPath:@"status" context:playerItemStatusContext];
    [self removeObserver:self forKeyPath:@"isPlaying" context:playerPlayingContext];
    
    [self.player removeTimeObserver:self.timeObserver];
    self.timeObserver = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
    self.player = nil;
    self.playerItem = nil;
    self.mediaUrl = nil;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
