//
//  CMLBaseVC.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import "CMLNavigationBar.h"
#import "CommonNumber.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "CMLLine.h"
#import "CMLShareModel.h"
#import "PushTransition.h"
#import "PopTransition.h"
#import "LXAlertView.h"
#import "HyTransitions.h"
#import "CMLIndicatorView.h"
#import "UIColor+SDExspand.h"
#import "SVProgressHUD.h"
#import "JQIndicatorView.h"
#import "UIImage+MultiFormat.h"
#import "DataManager.h"
#import "AppGroup.h"
#import "NSString+CMLExspand.h"
#import "UIColor+SDExspand.h"
#import "NSDate+CMLExspand.h"
#import "UIImage+CMLExspand.h"
#import "NSNumber+CMLExspand.h"
#import "BaseResultObj.h"
#import "LoginUserObj.h"
#import <UMSocialCore/UMSocialCore.h>
#import "CMLMobClick.h"

typedef void (^ShareSuccessBlock)();

typedef void (^SharesErrorBlock)();

typedef void (^RefreshViewController)(void);

@interface CMLBaseVC : ViewController

/**自定义导航头*/
@property (nonatomic,strong) CMLNavigationBar *navBar;

/**底层*/
@property (nonatomic,strong) UIView *contentView;

/********blcokOfShare********/

@property (nonatomic,copy) NSString *baseShareLink;

@property (nonatomic,copy) NSString *baseShareTitle;

@property (nonatomic,copy) NSString *baseShareContent;

@property (nonatomic,strong) UIImage *baseShareImage;

@property (nonatomic,copy) ShareSuccessBlock shareSuccessBlock;

@property (nonatomic,copy) SharesErrorBlock sharesErrorBlock;

@property (nonatomic,copy) RefreshViewController refreshViewController;

/****************/

/**隐藏导航头*/
- (void) hiddenNavBar;
/**出现*/
- (void) showNavBar;

//加载动画
- (void)startLoading;
- (void)stopLoading;

//提示加载动画
- (void)startIndicatorLoading;
- (void)stopIndicatorLoading;

- (void)startIndicatorLoadingWithShadow;
- (void)stopIndicatorLoadingWithShadow;

//没有网络的提示
- (void)showNetErrorTipOfNormalVC;
- (void)hideNetErrorTipOfNormalVC;

- (void)showNetErrorTipOfMainVC;
- (void)hideNetErrorTipOfMainVC;

//没有返回数据的提示
- (void)showNoneDataTip;
- (void)hideNoneDataTip;

//提示
- (void) showSuccessTemporaryMes:(NSString *) text;
- (void) showFailTemporaryMes:(NSString *) text;

//提示框
- (void) showAlterViewWithText:(NSString *) text;

- (void) showCurrentVCShareView;

- (void) hiddenCurrentVCShareView;

- (void) showCurrentVCShareViewWith:(int)num;

/**邀请函分享*/
- (void) showInvitationShareView;

- (void) hiddenInvitationShareView;

/**展示重新登录的弹框*/
- (void) showReloadView;

- (void) changeShareStyle:(UIButton *) button;

@end
