//
//  CMLBaseVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLBaseVC.h"
#import "LoginVC.h"
#import "VCManger.h"
#import "SDImageCache.h"

#define ShareViewWidth                                   620
#define ShareViewLineLength                              160
#define ShareViewLeftMargin                              70
#define ShareViewBtnSpace                                80
#define ShareViewBtnAndBtnVSpace                         60
#define ServeDefaultVCShareViewBtnAndBtnHSpace           120
#define ShareViewBtnBottomMargin                         60
#define ShareViewBtnHeight                               52
#define ShareViewBtnWidth                                160
#define ShareViewTitleTopMargin                          60
#define ShareViewTitleBottomMargin                       80
#define ShareViewTitleLineOneTopMargin                   40


@interface CMLBaseVC ()<UINavigationControllerDelegate,NavigationBarProtocol,UIViewControllerTransitioningDelegate>

@property (nonatomic,strong) JQIndicatorView *indicator;

@property (nonatomic,strong) UIView *baseVCShadow;

@property (nonatomic,strong) UIVisualEffectView *effectView;

@property (nonatomic,strong) UIView *shareView;

@property (nonatomic,strong) UIView *loadingbgView;

@property (nonatomic,strong) UIImageView *errorBgView;

@property (nonatomic,strong) UILabel *netErrorLabel;

@property (nonatomic,strong) UIButton *refreshLabel;

@property (nonatomic,strong) UIActivityIndicatorView *systemIndicatorView;

@property (nonatomic,strong) UIView *reloadPromptView;

@end

@implementation CMLBaseVC

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    self.navigationController.delegate = self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    /**设置底层*/
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                WIDTH,
                                                                HEIGHT - SafeAreaBottomHeight)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    
    /**设置导航条*/
    self.navBar = [[CMLNavigationBar alloc] init];
    self.navBar.delegate = self;
    self.navBar.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:self.navBar];
    [self.contentView bringSubviewToFront:self.navBar];
    
    /**loadingiamgeView*/
    self.loadingbgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  80*Proportion,
                                                                  80*Proportion)];
    self.loadingbgView.center = self.contentView.center;
    self.loadingbgView.backgroundColor = [UIColor CMLWhiteColor];
    self.loadingbgView.layer.cornerRadius = 80*Proportion/2.0;
    self.loadingbgView.layer.shadowColor = [UIColor CMLBlackColor].CGColor;
    self.loadingbgView.layer.shadowOpacity = 0.1;
    self.loadingbgView.layer.shadowOffset = CGSizeMake(0, 0);
    [self.view addSubview:self.loadingbgView];
    [self.view bringSubviewToFront:self.loadingbgView];
    NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"1" ofType:@"gif"]];
    UIImageView *LoadingImageView = [[UIImageView alloc] initWithImage:[UIImage sd_imageWithData:gif]];
    
    LoadingImageView.frame = CGRectMake(0,
                                        0,
                                        80*Proportion,
                                        80*Proportion);
    [self.loadingbgView addSubview:LoadingImageView];
    self.loadingbgView.hidden = YES;
    
    
    self.baseVCShadow = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 WIDTH,
                                                                 HEIGHT)];
    self.baseVCShadow.hidden = YES;
//    [self.view addSubview:self.baseVCShadow];
    [[UIApplication sharedApplication].keyWindow addSubview:self.baseVCShadow];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    _effectView.frame = CGRectMake(0,
                                   0,
                                   self.baseVCShadow.frame.size.width,
                                   self.baseVCShadow.frame.size.height);
    _effectView.hidden = YES;
    [self.baseVCShadow addSubview:_effectView];
    
    /*登录过期提示*/
    self.reloadPromptView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     470*Proportion,
                                                                     300*Proportion)];
    self.reloadPromptView.backgroundColor = [UIColor whiteColor];
    self.reloadPromptView.hidden = YES;
    [self.baseVCShadow addSubview:self.reloadPromptView];
    self.reloadPromptView.layer.cornerRadius = 8*Proportion;
    self.reloadPromptView.center = self.view.center;
    
    UILabel *reloadPromptLabel = [[UILabel alloc] init];
    reloadPromptLabel.text = @"您的登录状态已过期，为了不影响您使用，请重新登录，谢谢！";
    reloadPromptLabel.font = KSystemFontSize14;
    reloadPromptLabel.numberOfLines = 0;
    reloadPromptLabel.textAlignment = NSTextAlignmentCenter;
    reloadPromptLabel.textColor = [UIColor CMLUserBlackColor];
    CGRect currentRect = [reloadPromptLabel.text boundingRectWithSize:CGSizeMake(470*Proportion - 20*Proportion*2, 1000)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:KSystemFontSize14}
                                                              context:nil];
    reloadPromptLabel.frame = CGRectMake(20*Proportion,
                                         40*Proportion,
                                         470*Proportion - 20*Proportion*2,
                                         currentRect.size.height);
    [self.reloadPromptView addSubview:reloadPromptLabel];
    
    UIButton *reloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(470*Proportion/2.0 - 200*Proportion/2.0,
                                                                     CGRectGetMaxY(reloadPromptLabel.frame) + 40*Proportion,
                                                                     200*Proportion,
                                                                     60*Proportion)];
    reloadBtn.backgroundColor = [UIColor CMLYellowColor];
    [reloadBtn setTitle:@"重新登录" forState:UIControlStateNormal];
    reloadBtn.titleLabel.font = KSystemFontSize15;
    [self.reloadPromptView addSubview:reloadBtn];
    reloadBtn.layer.cornerRadius = 30*Proportion;
    [reloadBtn addTarget:self action:@selector(enterLoadVC) forControlEvents:UIControlEventTouchUpInside];
    
    
    /**无网络*/
    self.errorBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                  self.navBar.frame.size.height,
                                                                  WIDTH,
                                                                  HEIGHT - self.navBar.frame.size.height)];
    
    self.errorBgView.image = [UIImage imageNamed:NetErrorImg];
    self.errorBgView.hidden = YES;
    self.errorBgView.userInteractionEnabled = YES;
    [self.view addSubview:self.errorBgView];
    
    self.netErrorLabel = [[UILabel alloc] init];
    self.netErrorLabel.text = @"网络好像有问题，请检查一下吧！";
    self.netErrorLabel.font = KSystemFontSize14;
    self.netErrorLabel.textColor = [UIColor CMLtextInputGrayColor];
    [self.netErrorLabel sizeToFit];
    self.netErrorLabel.frame = CGRectMake(0,
                                          0,
                                          self.netErrorLabel.frame.size.width,
                                          self.netErrorLabel.frame.size.height);
    self.netErrorLabel.center = self.errorBgView.center;
    [self.errorBgView addSubview:self.netErrorLabel];
    
    self.refreshLabel = [[UIButton alloc] init];
    [self.refreshLabel setTitle:@"重新加载" forState:UIControlStateNormal];
    [self.refreshLabel setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    self.refreshLabel.titleLabel.font = KSystemFontSize14;
    [self.refreshLabel sizeToFit];
    self.refreshLabel.layer.cornerRadius = self.refreshLabel.frame.size.height/2.0;
    self.refreshLabel.layer.borderWidth = 1;
    self.refreshLabel.layer.borderColor =[UIColor CMLtextInputGrayColor].CGColor;
    self.refreshLabel.frame = CGRectMake(0,
                                         0,
                                         self.refreshLabel.frame.size.width + self.refreshLabel.frame.size.height*2,
                                         self.refreshLabel.frame.size.height);
    self.refreshLabel.center = CGPointMake(self.errorBgView.center.x, CGRectGetMaxY(self.netErrorLabel.frame) + self.refreshLabel.frame.size.height);
    [self.refreshLabel addTarget:self action:@selector(reloadCurrentVC) forControlEvents:UIControlEventTouchUpInside];
    [self.errorBgView addSubview:self.refreshLabel];
    
    
    
    /**添加手势*/
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(reloadCurrentVC)];
    recognizer.numberOfTapsRequired = 1;
    [self.errorBgView addGestureRecognizer:recognizer];
    
    
    
    self.indicator = [[JQIndicatorView alloc] initWithType:JQIndicatorTypeBounceSpot2 tintColor:[UIColor CMLYellowColor]];
    self.indicator.center = self.baseVCShadow.center;
    [self.baseVCShadow addSubview:self.indicator];
    
    
    
}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    
    [self stopLoading];
    [self.indicator stopAnimating];

}

/**加载动画*/
- (void)startLoading{

    self.loadingbgView.hidden = NO;
//    self.view.userInteractionEnabled = NO;

}

- (void)stopLoading{
    
    self.view.userInteractionEnabled = YES;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0
                          delay:1
                        options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        weakSelf.loadingbgView.hidden = YES;
        
    } completion:nil];
    

}

/**HUD*/
- (void)startIndicatorLoading{
    self.baseVCShadow.hidden = NO;
    [self.indicator startAnimating];

}
- (void)stopIndicatorLoading{
    self.baseVCShadow.hidden = YES;
    [self.indicator stopAnimating];
    
}

- (void)startIndicatorLoadingWithShadow{
    _effectView.hidden = NO;
    self.baseVCShadow.hidden = NO;
    [self.indicator startAnimating];
    
}
- (void)stopIndicatorLoadingWithShadow{
    _effectView.hidden = YES;
    self.baseVCShadow.hidden = YES;
    [self.indicator stopAnimating];
    
}

//没有网络的提示
- (void)showNetErrorTipOfNormalVC{

    self.errorBgView.hidden = NO;

}

- (void)hideNetErrorTipOfNormalVC{

    self.errorBgView.hidden = YES;

}

- (void)showNetErrorTipOfMainVC{

    self.errorBgView.frame = CGRectMake(0,
                                        0,
                                        WIDTH,
                                        HEIGHT - UITabBarHeight);
    self.netErrorLabel.center = self.errorBgView.center;
    self.refreshLabel.center = CGPointMake(self.errorBgView.center.x,
                                           CGRectGetMaxY(self.netErrorLabel.frame) + self.refreshLabel.frame.size.height);
    self.errorBgView.hidden = NO;

}
- (void)hideNetErrorTipOfMainVC{

    self.errorBgView.hidden = YES;

}

//没有返回数据的提示
- (void)showNoneDataTip{


}
- (void)hideNoneDataTip{


}


- (void) showAlterViewWithText:(NSString *) text{

    LXAlertView *alterView = [[LXAlertView alloc] initWithTitle:@"提示信息" message:text cancelBtnTitle:@"确定" otherBtnTitle:nil clickIndexBlock:^(NSInteger clickIndex) {
        NSLog(@"确定");
    }];
    
    [alterView showLXAlertView];

}

- (void) showSuccessTemporaryMes:(NSString *) text{

    [SVProgressHUD showSuccessWithStatus:text];
}

- (void) showFailTemporaryMes:(NSString *) text{
    
    [SVProgressHUD showErrorWithStatus:text];
}
/**隐藏导航头*/
- (void) hiddenNavBar{

    self.navBar.hidden = YES;
}
/**出现*/
- (void) showNavBar{

    self.navBar.hidden = NO;
}

/*推荐卡枚连*/
- (UIView *) setCurrentNewShareViewWithNum:(int) num{

    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              HEIGHT,
                                                              0,
                                                              0)];
    self.shareView .backgroundColor = [UIColor whiteColor];
    
    UILabel *promLab = [[UILabel alloc] init];
    promLab.textColor = [UIColor CMLLineGrayColor];
    promLab.font = KSystemFontSize14;
    promLab.text = @"分享至";
    [promLab sizeToFit];
    promLab.frame = CGRectMake(WIDTH/2.0 - promLab.frame.size.width/2.0,
                               40*Proportion,
                               promLab.frame.size.width,
                               promLab.frame.size.height);
    [self.shareView addSubview:promLab];
    
    NSArray *imageArray = @[Wechat_CShareImg,
                            wechat_momentShareImg,
                            SinaShareImg,
                            QQShareImg,
                            DouBanShareImg,
                            EmailShareImg];
    NSArray *shareNameArray = @[@"微信",
                                @"朋友圈",
                                @"微博",
                                @"QQ",
                                @"豆瓣",
                                @"复制链接"];
    
    
    for (int i = 0; i < num; i++) {
        UIButton *button = [[UIButton alloc] init];
        
        [button setBackgroundImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [button sizeToFit];
        
        UILabel *shareName = [[UILabel alloc] init];
        shareName.text = shareNameArray[i];
        shareName.font = KSystemFontSize12;
        shareName.textColor = [UIColor CMLtextInputGrayColor];
        [shareName sizeToFit];
        
        if (i < 4) {
            
            button.frame = CGRectMake(40*Proportion +( (WIDTH - 100*Proportion*4  - 40*2*Proportion)/3 + 100*Proportion)*i,
                                      CGRectGetMaxY(promLab.frame) + ShareViewTitleLineOneTopMargin*Proportion + 20*Proportion,
                                      100*Proportion,
                                      100*Proportion);
        }else{
            button.frame = CGRectMake(40*Proportion +( (WIDTH - 100*Proportion*4  - 40*2*Proportion)/3 + 100*Proportion)*(i - 4) ,
                                      CGRectGetMaxY(promLab.frame) + 20*Proportion*2 + 40*Proportion*2 + 100*Proportion + shareName.frame.size.height,
                                      100*Proportion,
                                      100*Proportion);
        }
        if (num == 1) {
            button.frame = CGRectMake(WIDTH/2 - 100 * Proportion/2,
                                      CGRectGetMaxY(promLab.frame) + ShareViewTitleLineOneTopMargin*Proportion + 20*Proportion,
                                      100*Proportion,
                                      100*Proportion);
        }
        shareName.frame = CGRectMake(button.center.x - shareName.frame.size.width/2.0,
                                     CGRectGetMaxY(button.frame) + 10*Proportion,
                                     shareName.frame.size.width,
                                     shareName.frame.size.height);
        [self.shareView  addSubview:shareName];
        button.tag = i + 1;
        [self.shareView  addSubview:button];
        [button addTarget:self action:@selector(changeShareStyle:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == num - 1) {
            
            UIView *lineTwo = [[UIView alloc] initWithFrame:CGRectMake((WIDTH - 690*Proportion)/2.0,
                                                                       CGRectGetMaxY(shareName.frame) + 40*Proportion,
                                                                       690*Proportion,
                                                                       1)];
            lineTwo.backgroundColor = [UIColor CMLPromptGrayColor];
            [self.shareView  addSubview:lineTwo];
            
            UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(shareName.frame) + 40*Proportion, WIDTH, 100*Proportion)];
            cancelBtn.backgroundColor = [UIColor clearColor];
            cancelBtn.titleLabel.font = KSystemFontSize14;
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            [cancelBtn setTitleColor:[UIColor CMLLineGrayColor] forState:UIControlStateNormal];
            [self.shareView addSubview:cancelBtn];
            [cancelBtn addTarget:self action:@selector(cancelShare) forControlEvents:UIControlEventTouchUpInside];
            
            self.shareView.frame = CGRectMake(0,
                                              HEIGHT,
                                              WIDTH,
                                              CGRectGetMaxY(cancelBtn.frame));
        }
    }
    return self.shareView;

}

- (void) showCurrentVCShareView{
    
    [self.baseVCShadow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.baseVCShadow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.baseVCShadow.hidden = NO;
    [self.baseVCShadow addSubview:[self setCurrentNewShareViewWithNum:6]];
    
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
       
        weakSelf.shareView.frame = CGRectMake(0,
                                              HEIGHT - weakSelf.shareView.frame.size.height - SafeAreaBottomHeight,
                                              WIDTH,
                                              weakSelf.shareView.frame.size.height);
    }];
    
    
}

- (void) showCurrentVCShareViewWith:(int)num {
    
    [self.baseVCShadow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.baseVCShadow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.baseVCShadow.hidden = NO;
    [self.baseVCShadow addSubview:[self setCurrentNewShareViewWithNum:num]];
    
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.shareView.frame = CGRectMake(0,
                                              HEIGHT - weakSelf.shareView.frame.size.height - SafeAreaBottomHeight,
                                              WIDTH,
                                              weakSelf.shareView.frame.size.height);
    }];
    
    
}

- (void) cancelShare{
    self.baseVCShadow.backgroundColor = [UIColor clearColor];
    self.baseVCShadow.hidden = YES;
    [self.shareView removeFromSuperview];
    
}

- (void) hiddenCurrentVCShareView{

    self.baseVCShadow.hidden = YES;
    [self.shareView removeFromSuperview];
}

/**邀请函分享*/
- (void) showInvitationShareView{

    self.baseVCShadow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.baseVCShadow.hidden = NO;
    [self.baseVCShadow addSubview:[self setCurrentNewShareViewWithNum:4]];
    
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.shareView.frame = CGRectMake(0,
                                              HEIGHT - weakSelf.shareView.frame.size.height,
                                              WIDTH,
                                              weakSelf.shareView.frame.size.height);
    }];

}

- (void) hiddenInvitationShareView{

    self.baseVCShadow.hidden = YES;
    [self.shareView removeFromSuperview];

}


#pragma mark - changeShareStyle
- (void) changeShareStyle:(UIButton *) button{
    
    [CMLMobClick Share];
    [self hiddenCurrentVCShareView];
    if (button.tag == 1) {
     
        __weak typeof(self) weakSelf = self;
        
        NSLog(@"分享到对话");
        
        UIImage *transitImage = [UIImage scaleToRect:self.baseShareImage];
        UIImage *newImage = [UIImage scaleToSize:transitImage size:CGSizeMake(60, 60)];
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.baseShareTitle descr:self.baseShareContent thumImage:newImage];
        //设置网页地址
        shareObject.webpageUrl = self.baseShareLink;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
    
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                
                [weakSelf showFailTemporaryMes:@"分享失败"];
//                [weakSelf showSuccessTemporaryMes:@"分享失败"]
                
                if (weakSelf.sharesErrorBlock) {
                     weakSelf.sharesErrorBlock();
                }
               
                
            }else{
                
                [weakSelf showSuccessTemporaryMes:@"分享成功"];
                [weakSelf hiddenCurrentVCShareView];
                if (weakSelf.shareSuccessBlock) {
                    weakSelf.shareSuccessBlock();
                }
                
            }
        }];
        
    }else if (button.tag == 2){
        
        __weak typeof(self) weakSelf = self;
        
        NSLog(@"分享到朋友圈");
        
        UIImage *transitImage = [UIImage scaleToRect:self.baseShareImage];
        UIImage *newImage = [UIImage scaleToSize:transitImage size:CGSizeMake(60, 60)];
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.baseShareTitle descr:self.baseShareContent thumImage:newImage];
        //设置网页地址
        shareObject.webpageUrl = self.baseShareLink;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                
                [weakSelf showSuccessTemporaryMes:@"分享失败"];
                
                if (weakSelf.sharesErrorBlock) {
                     weakSelf.sharesErrorBlock();
                }
               
                
            }else{
                
                [weakSelf showSuccessTemporaryMes:@"分享成功"];
                [weakSelf hiddenCurrentVCShareView];
                
                if (weakSelf.shareSuccessBlock) {
                    weakSelf.shareSuccessBlock();
                }
                
                
            }
        }];
    
    }else if (button.tag == 3){
        
        __weak typeof(self) weakSelf = self;
        
        NSLog(@"分享到微博");        

        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:@"" descr:@"" thumImage:self.baseShareImage];
        
        shareObject.shareImage = self.baseShareImage;
        shareObject.thumbImage = self.baseShareImage;
        messageObject.text = [NSString stringWithFormat:@"%@#卡枚连#%@",self.baseShareTitle,self.baseShareLink];
        messageObject.title = [NSString stringWithFormat:@"%@#卡枚连#%@",self.baseShareTitle,self.baseShareLink];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;

        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Sina messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            
            if (error) {
                
                [weakSelf showSuccessTemporaryMes:@"分享失败"];
                if (weakSelf.sharesErrorBlock) {
                    weakSelf.sharesErrorBlock();
                }
                
                
            }else{
                
                [weakSelf showSuccessTemporaryMes:@"分享成功"];
                [weakSelf hiddenCurrentVCShareView];
                if (weakSelf.shareSuccessBlock) {
                    weakSelf.shareSuccessBlock();
                }
                
                
            }
        }];
        
    
    }else if (button.tag == 4){
        
        __weak typeof(self) weakSelf = self;
        
        NSLog(@"分享QQ");
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.baseShareTitle descr:self.baseShareTitle thumImage:self.baseShareImage];
        //设置网页地址
        shareObject.webpageUrl = self.baseShareLink;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                [weakSelf showSuccessTemporaryMes:@"分享失败"];
                if (weakSelf.sharesErrorBlock) {
                    weakSelf.sharesErrorBlock();
                }
                
                
            }else{
                
                [weakSelf showSuccessTemporaryMes:@"分享成功"];
                [weakSelf hiddenCurrentVCShareView];
                if (weakSelf.shareSuccessBlock) {
                    weakSelf.shareSuccessBlock();
                }
                
                
            }
        }];
    
    }else if (button.tag == 5){
        
        __weak typeof(self) weakSelf = self;
        
        NSLog(@"分享到豆瓣");
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"%@,%@",self.baseShareTitle ,self.baseShareLink] descr:[NSString stringWithFormat:@"%@,%@",self.baseShareTitle ,self.baseShareLink] thumImage:self.baseShareImage];
        //设置网页地址
        shareObject.webpageUrl = self.baseShareLink;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Douban messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                [weakSelf showSuccessTemporaryMes:@"分享失败"];
                if (self.sharesErrorBlock) {
                    weakSelf.sharesErrorBlock();
                }
                
                
            }else{
                
                [weakSelf showSuccessTemporaryMes:@"分享成功"];
                [weakSelf hiddenCurrentVCShareView];
                if (weakSelf.shareSuccessBlock) {
                    weakSelf.shareSuccessBlock();
                }
                
                
            }
        }];
    
    }else if (button.tag == 6){
    
        NSLog(@"复制链接");
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.baseShareLink;
        [self showSuccessTemporaryMes:@"已复制到剪贴板上"];
        [self hiddenCurrentVCShareView];
    }
}

#pragma mark - 刷新控制器
- (void) reloadCurrentVC{

    if (self.refreshViewController) {
     
        self.refreshViewController();
    }
}

#pragma mark - showReloadView
- (void) showReloadView{
    [self stopIndicatorLoading];
    self.effectView.hidden = NO;
    self.baseVCShadow.hidden = NO;
    self.reloadPromptView.hidden = NO;
    
}

#pragma mark - enterLoadVC
- (void) enterLoadVC{

    self.effectView.hidden = YES;
    self.baseVCShadow.hidden = YES;
    self.reloadPromptView.hidden = YES;
    
    LoginVC *vc = [[LoginVC alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
    [[DataManager lightData] removePhone];
    [[DataManager lightData] removeUserID];
    [[DataManager lightData] removeUserName];
    [[DataManager lightData] removeUserLevel];
    [[DataManager lightData] removeNickName];
    [[DataManager lightData] removeOpenType];
    [[DataManager lightData] removeUserHeadImgUrl];
    [[DataManager lightData] removeUserSex];
    [[DataManager lightData] removeUserBirth];
    [[DataManager lightData] removeSignature];
    [[DataManager lightData] removeRelFansCount];
    [[DataManager lightData] removeRelWatchCount];
    [[DataManager lightData] removeInviteCode];
    [[DataManager lightData] removeDeliveryAddressID];
    [[DataManager lightData] removeDeliveryUser];
    [[DataManager lightData] removeDeliveryPhone];
    [[DataManager lightData] removeDeliveryAddress];
    [[DataManager lightData] removeUserPoints];
    [[DataManager lightData] removeBindStatus];
    
}

- (void)didReceiveMemoryWarning{

    [super didReceiveMemoryWarning];
    
    NSLog(@"!!!!!!!!!!!!!!");
    /**收到内存警告时清除图片缓存*/
    [[SDImageCache sharedImageCache] clearMemory];
    
    YYImageCache *yyCache = [YYWebImageManager sharedManager].cache;
    [yyCache.memoryCache removeAllObjects];
    [yyCache.diskCache removeAllObjects];
    
}


@end
