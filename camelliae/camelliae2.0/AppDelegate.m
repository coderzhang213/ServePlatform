//
//  AppDelegate.m
//  camelliae2.0
//
//  Created by 张越 on 16/5/3.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "AppDelegate.h"
#import "VCManger.h"
#import "RegisterVC.h"
#import "DataManager.h"
#import "NetConfig.h"
#import "AppGroup.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "BaseResultObj.h"
#import "NSString+CMLExspand.h"
#import "CMLPseudoLaunchImage.h"
#import "CommonImg.h"
#import <AlipaySDK/AlipaySDK.h>
#import "LoginBannerImageObj.h"
#import "AdPoster.h"
#import "NetworkMessageVC.h"
#import "NavigationInfo.h"
#import "CMLPicObjInfo.h"
#import "ServeDefaultVC.h"

#import "XHLaunchAd.h"
#import "Network.h"
#import "LaunchAdModel.h"
#import "UIViewController+Nav.h"
#import "WebViewController.h"
#import "WebViewLinkVC.h"
#import <SdkSample/SdkSample.h>
//#import "JPUSHService.h"
#import "CMLPersonalCenterVC.h"

#import "ActivityDefaultVC.h"
#import "CMLUserArticleVC.h"
#import "CMLUserPushActivityDetailVC.h"
#import "CMLUserPushGoodsVC.h"
#import "ServeDefaultVC.h"
#import "CMLCommodityDetailMessageVC.h"
#import "CMLNewSpecialDetailTopicVC.h"
#import "WebViewLinkVC.h"
#import "CMLPrefectureVC.h"
#import "CMLMessageObj.h"
#import "CMLMessageViewController.h"
#import "NSObject+CMLKeyValue.h"
#import "UIViewController+CMLVC.h"

#import "CMLMainInterfaceVC.h"
#import "CMLPersonalCenterVC.h"
#import "CMLNewActivityVC.h"
#import "CMLNewVipVC.h"
#import "CMLStoreVC.h"

#import "CMLPersonCenterSettingVC.h"
// iOS10 注册 APNs 所需头文件
#import <UserNotifications/UserNotifications.h>

// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
/*bugly*/


@interface AppDelegate ()<NetWorkProtocol, UIAlertViewDelegate, CMLPseudoLaunchImageDelegate, UNUserNotificationCenterDelegate, WangMaiSplashAdDelegate, LoginVCDelegate>{

    NSCondition           *condition;
    CMLPseudoLaunchImage  *launchimage;
    BOOL  isPlay;
    NSTimer               *currentTimer;
    int                   times;
    BOOL                  successLogin;
    BOOL                  hasRequestResult;
    NSDictionary          *verbDic;

}

@property (nonatomic, strong) WmMobAdSplash *wmAdSplash;

@property (nonatomic, assign) BOOL isSplashlFail;

@property (nonatomic, assign) BOOL isSplashClicked;

@property (nonatomic, assign) BOOL isSplashDisappeared;

@property (nonatomic, strong) UIView *adView;

@property (nonatomic, strong) UIImageView *adBottomView;

@property (nonatomic, strong) NSMutableArray *tagsArray;

@property (nonatomic, strong) CMLMessageObj *messageObj;

@property (nonatomic, assign) int badgeNumber;

@property (nonatomic, assign) BOOL launchOfPush;

@end

@implementation AppDelegate


@synthesize pid=_pid;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"IOS_VERSION === %f", IOS_VERSION);
    /*光标统一颜色*/
    [[UITextField appearance] setTintColor:[UIColor CMLE5C48AColor]];
    [[UITextView appearance] setTintColor:[UIColor CMLE5C48AColor]];
    
    /*bugly*/
//    [Bugly startWithAppId:@"1251989d41"];
    /*生产环境设置为NO*/
    [UMConfigure setLogEnabled:NO];
    [MobClick setScenarioType:E_UM_NORMAL];
//    [UMCommonLogManager setUpUMCommonLogManager];
    [UMConfigure initWithAppkey:@"573ed34ae0f55ae3af001f6c" channel:nil];
    
    /*IM*/
    [self initCMLNIM];
    
    self.pid = @"0";
    
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
    }
    
    /**/
    [self initAPP];
    
    /*推送*/
    if ([[[DataManager lightData] readIsLogin] intValue] != 0) {
//        [self jpushInitWith:launchOptions];
        
        NSLog(@"readPhone %@",[[DataManager lightData] readPhone]);
        NSLog(@"readIsLogin %@",[[DataManager lightData] readIsLogin]);
        /*推送2*/
//        [self registerAPNsAuthorizationWithApplication:application];
    }
    /*UM推送*/
    [self initUMPushWithLaunchOptions:launchOptions];

    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {/*从通知启动*/
        self.launchOfPush = YES;
        [[DataManager lightData] saveIsLaunchOfPush:[NSNumber numberWithInt:1]];
        [[DataManager lightData] saveUserInfoDict:userInfo];
    }

    NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    
    if (url.absoluteString) {
        
        /**有唤醒的情况下的跳转*/
        NSString * acceptUrl = [url.absoluteString componentsSeparatedByString:@"type="].lastObject;
        NSDictionary *dic =[NSDictionary dictionaryWithObject:acceptUrl forKey:@"jumpVc"];
        verbDic = dic;
        
        if ([[[DataManager lightData] readUserID] intValue] != 0) {
         
            [self performSelector:@selector(verbNewVC) withObject:nil afterDelay:0.7];
        }else{
            if (acceptUrl) {
                [[DataManager lightData] saveAbsoluteString:acceptUrl];
            }
        }
    }
    return YES;
}

- (void)initCMLNIM {
    
    
    
}

- (void)initUMPushWithLaunchOptions:(NSDictionary *)launchOptions {

//#pragma mark 集成测试
//    NSString *deviceID = [UMConfigure deviceIDForIntegration];
//    if ([deviceID isKindOfClass:[NSString class]]) {
//        NSLog(@"服务器端成功返回deviceID%@", deviceID);
//    } else {
//        NSLog(@"服务器端还没有返回deviceID");
//    }
//    //NO：关闭U-Push自动清理--YES：APP在前台时通知栏推送消息会自动消失
//    [UMessage setBadgeClear:NO];
//    /*UM推送*/
//    UMessageRegisterEntity *entity = [[UMessageRegisterEntity alloc] init];
//    entity.types = UMessageAuthorizationOptionAlert|UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound;
//    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
//    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        if (!error && granted) {
//            NSLog(@"UMPush注册成功");
//            [self setPushTag];
//        }else {
//            NSLog(@"UMPush注册失败");
//        }
//    }];
    
}

//广告被点击
- (void) splashClicked {
    
    self.isSplashClicked = YES;
    
}
//广告消失
- (void) splashDismissed {
    
    self.isSplashDisappeared = YES;
    
}

- (void) verbNewVC{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpVc" object:@"test" userInfo:verbDic];
    
}

- (void) initAPP{
    
    times = 30;
    /**状态栏设置*/
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    /**设置自定义启动页*/
    [VCManger mainVC];

    /**引导图的判断*/
    if ([[DataManager lightData] readAdPoster] && [[DataManager lightData] readAdPoster].length > 0) {

        NSString *path_sandox = NSHomeDirectory();
        NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/other.png"];
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:imagePath];
        launchimage = [[CMLPseudoLaunchImage alloc] initWithImage:img];

    }else{

        if ((int)[UIScreen mainScreen].bounds.size.width*2 == 640) {
            launchimage = [[CMLPseudoLaunchImage alloc] initWithImage:[UIImage imageNamed:LaunchImg5]];
        }else{
            if ((int)[UIScreen mainScreen].bounds.size.width*2 == 750){
                launchimage = [[CMLPseudoLaunchImage alloc] initWithImage:[UIImage imageNamed:LaunchImg6]];
            }else{
                launchimage = [[CMLPseudoLaunchImage alloc] initWithImage:[UIImage imageNamed:LaunchImg6p]];
            }
        }
    }

    launchimage.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:launchimage];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:launchimage];

    [launchimage showHypotheticalView];

    [self setAppStartMes];
}

- (void)setAppStartMes {

    /**app启动网络请求*/
    [self APPStartupNetWork];
    
    /**微信微博注册*/
    [UMConfigure initWithAppkey:UMAppKey channel:@"App Store"];
    [self configUSharePlatforms];
    /**统计功能*/

    [NSThread sleepForTimeInterval:0.3];
    
}

- (void) countDown{
    
    if (times != 0) {
        times--;
        if (times == 20 || times == 10 || times == 1) {
            
            if (!hasRequestResult) {
                
                [self APPStartupNetWork];
            }
        }
    }else{
        currentTimer = nil;
        [currentTimer invalidate];
        if (!hasRequestResult) {

            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                                message:@"网络连接错误"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];
            [alterView show];
            
        }
    }
    
    
}

- (void) configUSharePlatforms{

    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
                                          appKey:WeiXinAppID
                                       appSecret:WeiXinAppSecret
                                     redirectURL:@"http://www.camelliae.com"];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ
                                          appKey:QQAppID
                                       appSecret:QQAppSecret
                                     redirectURL:@"http://www.camelliae.com"];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina
                                          appKey:SinaAppID
                                       appSecret:SinaAppSecret
                                     redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
}
/**网络请求*/
- (void)APPStartupNetWork{
    
    /**默认城市上海（无用）*/
    [[DataManager lightData] saveCityID:[NSNumber numberWithInt:0]];
    
    /**网络请求*/
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSString *skey = [[DataManager lightData] readSkey];
    
    if (skey.length > 0) {
    
        [paraDic setObject:skey forKey:@"skey"];
        
    }else{
        if ([DataManager readSkey].length > 0) {
            
            [paraDic setObject:[DataManager readSkey] forKey:@"skey"];
        }else{
            
            [paraDic setObject:@"" forKey:@"skey"];
        }
    }

    [paraDic setObject:[AppGroup appType] forKey:@"clientType"];
    [paraDic setObject:[AppGroup deviceUUID] forKey:@"imei"];
    [paraDic setObject:[AppGroup deviceSystem] forKey:@"osInfo"];
    [paraDic setObject:[AppGroup appVersion] forKey:@"curAppVersion"];
    NSString *enString =[NSString getEncryptStringfrom:@[[AppGroup appType],[AppGroup deviceUUID]]];
    [paraDic setObject:enString forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:AppStarting paraDic:paraDic delegate:delegate];
 
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    hasRequestResult = YES;
    
    if (!successLogin) {
        
        successLogin = YES;
        
        BaseResultObj *resObj = [BaseResultObj getBaseObjFrom:responseResult];
        NSLog(@"%@", responseResult);
        [[DataManager lightData] saveSkey:resObj.retData.sKey];
        [DataManager saveSkey:resObj.retData.sKey];
        [[DataManager lightData] saveAddBlockListStatus:resObj.retData.addBlockListStatus];
        [[DataManager lightData] saveMemberIvlUrl:resObj.retData.memberLevelUrl];
        [[DataManager lightData] saveIsLogin:resObj.retData.isLogin];
        [[DataManager lightData] saveTopicZone:resObj.retData.isTopicZone];
        [[DataManager lightData] saveUrlMessage:resObj];
        NSLog(@"readIsLogin %d", [[DataManager lightData].readIsLogin intValue]);
        if ([resObj.retCode intValue] == 0 && resObj) {
            
            if ([resObj.retData.isUpdate intValue] == 1) {
                /*4.2.2之前的更新检测
                [self checkCurrentVersion];
                */
            }
            
            /**存储系统时间并校验*/
            [AppGroup getCurrentTiming:resObj.retData.serverTime];
            
            /**存储头图*/
            if ([resObj.retData.loginBanner.isReplace intValue] == 1) {
                
                [[DataManager lightData] saveLoginBannerUrl:resObj.retData.loginBanner.coverPic];
            }else{
                [[DataManager lightData] saveLoginBannerUrl:@""];
            }
            
            /*开屏广告-旺脉*/
            if ([resObj.retData.isOpenThirdPartyVideo integerValue] == 1) {
                self.adView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 84, WIDTH, 84)];
                self.adView.backgroundColor = [UIColor whiteColor];
                self.adBottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:LogohorizontalImg]];
                self.adBottomView.frame = CGRectMake(self.adView.frame.size.width/2 - self.adBottomView.frame.size.width/2, self.adView.frame.size.height/2 - self.adBottomView.frame.size.height/2, self.adBottomView.frame.size.width, self.adBottomView.frame.size.height);
                [self.adView addSubview:self.adBottomView];
                self.wmAdSplash = [[WmMobAdSplash alloc] initWithAppToken:@"1me6g33phj"
                                                                  andSign:@"fae027bde8ef73da7108eb3771089c53"
                                                              andAdslotId:@"4491030"
                                                               withParent:self.window
                                                           withBottomView:self.adView];
                self.wmAdSplash.delegate = self;
            }
            
            if ([resObj.retData.adPoster.isShow intValue] == 1) {
                
                NSData *imageNata = [NSData dataWithContentsOfURL:[NSURL URLWithString:resObj.retData.adPoster.coverPic]];
                UIImage *image = [UIImage imageWithData:imageNata];
                UIImage *imagesave = image;
                NSString *path_sandox = NSHomeDirectory();
                //设置一个图片的存储路径
                NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/other.png"];
                //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
                [UIImagePNGRepresentation(imagesave) writeToFile:imagePath atomically:YES];
                [[DataManager lightData] saveAdPoster:imagePath];
                
            }else{
                [[DataManager lightData] saveAdPoster:@""];
            }
            
            if (self.isNetError) {
                //[self saveUserInfo:resObj];
                self.isNetError = NO;
            }else {
                
                /*启动页变化退出 CABasicAnimation*/
                [launchimage imageRemoveFromKeyWindow];
                
                if ([resObj.retData.isLogin intValue] == 0) {
                    /**进入登录界面*/
                    [[DataManager lightData] savePhone:resObj.retData.userInfo.mobile];
                    [[VCManger mainVC] pushVC:[VCManger loginVC] animate:NO];
                    [VCManger loginVC].delegate = self;
                    
                }else{
                    
                    /**统计帐号类型*/
                    if ([resObj.retData.userInfo.openIdType intValue] == 0) {
                        
                        [MobClick profileSignInWithPUID:[NSString stringWithFormat:@"%@",resObj.retData.userInfo.uid]];
                        
                    }else{
                        NSString *openType;
                        switch ([resObj.retData.userInfo.openIdType intValue]) {
                            case 1:
                                openType = @"微信";
                                break;
                            case 2:
                                openType = @"微博";
                                break;
                            case 3:
                                openType = @"QQ";
                                break;
                                
                            default:
                                break;
                        }
                        [MobClick profileSignInWithPUID:[NSString stringWithFormat:@"%@",resObj.retData.userInfo.uid] provider:openType];
                    }
                    /***********************************************/
                    
                    [self saveUserInfo:resObj];
                    
                    /**进入主页面*/
                    [[VCManger mainVC] pushVC:[VCManger homeVC] animate:NO];
//                    [self jpushInitWith:[[DataManager lightData] readUserInfoDict]];
                    
                    /*推送2*/
//                    [self registerAPNsAuthorizationWithApplication:[UIApplication sharedApplication]];
                    /*推送2*/
                    [self initUMPushWithLaunchOptions:[[DataManager lightData] readUserInfoDict]];
                    
                    if (self.launchOfPush) {
                        self.launchOfPush = NO;
                        [self pushToViewControllerWith:[[DataManager lightData] readUserInfoDict]];
                    }
                }
            }
        }else{
        }
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    NSLog(@"errorResult = %@",errorResult);
    hasRequestResult = YES;
    self.isNetError = YES;
    /*************/
    [launchimage imageRemoveFromKeyWindow];
    if ([[[DataManager lightData] readIsLogin] intValue] == 0) {
        /**进入登录界面*/
        if (![[VCManger mainVC].topViewController isKindOfClass:[[VCManger loginVC] class]]) {

            if (![[VCManger mainVC].topViewController isKindOfClass:RegisterVC.class]) {
                [[VCManger mainVC] pushVC:[VCManger loginVC] animate:NO];
            }
        }
        
    }else{
        
        [[VCManger mainVC] pushVC:[VCManger homeVC] animate:NO];

    }

    /***********/
    [SVProgressHUD showErrorWithStatus:@"网络好像有问题，请检查一下吧~" duration:2.0];

}

#pragma mark - 信息存储
- (void) saveUserInfo:(BaseResultObj *)obj{
    
    [[DataManager lightData] saveTimePeriod:obj.retData.navigationInfo.timePeriod];
    
    if (![[DataManager lightData] readCurrentTime]) {
     
        [[DataManager lightData] saveCurrentTime:[NSDate dateWithTimeIntervalSinceNow:0]];
    }
    
    [[DataManager lightData] saveParentName:obj.retData.parentName];
    [[DataManager lightData] saveCanPushState:obj.retData.isCanPublish];
    [[DataManager lightData] saveShowAd:obj.retData.navigationInfo.isShow];
    [[DataManager lightData] saveTimePeriod:obj.retData.navigationInfo.timePeriod];
    [[DataManager lightData] saveNavImageUrl:obj.retData.navigationInfo.coverPic];
    [[DataManager lightData] saveNavImageWidth:obj.retData.navigationInfo.picObjInfo.picWidth];
    [[DataManager lightData] saveNavImageHeight:obj.retData.navigationInfo.picObjInfo.picHeight];
    [[DataManager lightData] saveDataType:obj.retData.navigationInfo.dataType];
    [[DataManager lightData] saveObjID:obj.retData.navigationInfo.obj_id];
    [[DataManager lightData] saveObjType:obj.retData.navigationInfo.obj_type];
    [[DataManager lightData] saveEnterWebUrl:obj.retData.navigationInfo.webUrl];
    [[DataManager lightData] saveThirdVideoPlayerStatus:obj.retData.isOpenThirdPartyVideo];
    [[DataManager lightData] saveUserInfo:obj];
    [[DataManager lightData] saveUrlMessage:obj];
//    [[DataManager lightData] saveIsLogin:obj.retData.isLogin];
//    [self setPushTag];
    
}

#pragma mark - 初次登录
- (void) startApp{

    [self setAppStartMes];
}

/**这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来*/
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"跳转支付宝钱包进行支付，处理支付结果result = %@",resultDic);
        }];
        return YES;
    } else{
        BOOL UM = [[UMSocialManager defaultManager] handleOpenURL:url];
        return  UM;
    }
}

/**这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用*/
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
        BOOL UM = [[UMSocialManager defaultManager] handleOpenURL:url];
//        BOOL WX = [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        return  UM;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary*)options{

    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
           
            if ([[resultDic valueForKey:@"resultStatus"] intValue] == 9000) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"successPayOfZFB" object:nil];
            }else {
                
                switch ([[resultDic valueForKey:@"resultStatus"] intValue]) {
                    
                    case 8000:
                        NSLog(@"订单正在处理中");
                        break;
                        
                    case 4000:
                        NSLog(@"订单支付失败");
                        break;
                        
                    case 6001:
                        NSLog(@"支付宝支付取消");
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelPayOfZFB" object:nil];
                        [SVProgressHUD showErrorWithStatus:@"支付宝支付取消中"];
                        break;
                        
                    case 6002:
                        NSLog(@"网络连接出错");
                        break;
                        
                    default:
                        break;
                }
            }
        }];
        
        return YES;
        
    }else if ([url.absoluteString hasPrefix:@"camelliaeverb://"]){
        
        if ([[[DataManager lightData] readUserID] intValue] != 0) {
            NSString * acceptUrl = [url.absoluteString componentsSeparatedByString:@"type="].lastObject;
            
            NSDictionary *dic =[NSDictionary dictionaryWithObject:acceptUrl forKey:@"jumpVc"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpVc" object:@"test" userInfo:dic];
        }else{
            
            NSString * acceptUrl = [url.absoluteString componentsSeparatedByString:@"type="].lastObject;
            [[DataManager lightData] saveAbsoluteString:acceptUrl];
        }
        return YES;
        
    } else{
        
        BOOL UM = [[UMSocialManager defaultManager] handleOpenURL:url];
//        BOOL WX = [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        return UM ;
    }
}

- (BOOL) checkCurrentVersion{

    //签名的字符串、请求URL地址
    NSString *requestString = [NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",AppID];
    //header参数
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:requestString parameters:nil headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([AppGroup appVersion]) {
            
            NSDictionary *rootDic = responseObject;
            NSDictionary *targetDic = [[rootDic valueForKey:@"results"] firstObject];
            
            NSString *appStroreVersion = [targetDic valueForKey:@"version"];
            
            NSMutableString *oldVersion = [NSMutableString stringWithFormat:@"%@",appStroreVersion];
            NSString *newVersion = [oldVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            NSMutableString *currentVersion = [NSMutableString stringWithFormat:@"%@",[AppGroup appVersion]];
            NSString *newCurrentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            /**线上版本*/
            int realVersionNum;
            if (newVersion.length == 1) {
                
                realVersionNum = [newVersion intValue]*100;
            }else if (newVersion.length == 2){
                realVersionNum = [newVersion intValue]*10;
            }else{
                realVersionNum = [newVersion intValue];
            }
            
            /**当前版本*/
            int currentVersionNum;
            if (newCurrentVersion.length == 1) {
                currentVersionNum = [newCurrentVersion intValue]*100;
            }else if (newCurrentVersion.length == 2){
                currentVersionNum = [newCurrentVersion intValue]*10;
            }else{
                currentVersionNum = [newCurrentVersion intValue];
            }
            
            NSLog(@"currentVersionNum %d", currentVersionNum);
            NSLog(@"responseObject %@", responseObject);
            NSLog(@"newCurrentVersion.length %ld", (long)newCurrentVersion.length);
            NSLog(@"newVersion.length %ld", (long)newVersion.length);/*线上*/
            NSLog(@"realVersionNum %d", realVersionNum);
            if (newCurrentVersion.length == 4 && newVersion.length == 3) {
                if (realVersionNum >= 420) {
                    realVersionNum = realVersionNum * 10;
                }
            }

            NSLog(@"getLocalAppVersion%@", [NSString getLocalAppVersion]);
            NSLog(@"%d", realVersionNum);
            NSLog(@"%d", currentVersionNum);
            if (realVersionNum > currentVersionNum) {
                
                [[DataManager lightData] saveIsCanUpdate:[NSNumber numberWithInt:1]];
                
                UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"版本更新提示"
                                                                    message:@"有新版本啦，请更新客户端！"
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles: nil];
                alterView.tag = 1;
                [alterView show];
            }else {
                if ([[DataManager lightData] readIsCanUpdate]) {
                    if ([[[DataManager lightData] readIsCanUpdate] intValue] == 1) {
                        [[DataManager lightData] saveIsCanUpdate:[NSNumber numberWithInt:0]];
                        [[DataManager lightData] removeIsSettingOfPush];
                        [[DataManager lightData] saveIsSettingOfPush:[NSNumber numberWithInt:0]];
                        [[DataManager lightData] removeIsMainOfPush];
                        [[DataManager lightData] saveIsMainOfPush:[NSNumber numberWithInt:1]];
                    }
                }
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    return NO;

}

/*AlertView点击*/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 1) {
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", AppID]];
        [[UIApplication sharedApplication] openURL:url];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    
    /*推送2*/
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *deviceTokenString = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
//#warning 原生推送：保存deviceToken，登录成功后发送给服务器
    [[DataManager lightData] saveDeviceTokenString:deviceTokenString];/*保存deviceToken，登录成功后发送给服务器--*/
    NSLog(@"deviceTokenString %@", deviceTokenString);

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册远程通知失败===error===%@", error.description);
}

/*iOS10.0以下 三种情况:前台、后台、kill*/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    [JPUSHService setBadge:self.badgeNumber + 1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:self.badgeNumber + 1];
    NSLog(@"%ld", (long)[[UIApplication sharedApplication] applicationIconBadgeNumber]);
    NSLog(@"fetch - self.badgeNumber %d", self.badgeNumber);
//    [JPUSHService handleRemoteNotification:userInfo];
    
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收到推送消息"
                                                        message:userInfo[@"aps"][@"alert"]
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        [alert show];
    }else {
        
    }
    
    /*UM推送-收到远程消息推送*/
//    [UMessage setAutoAlert:NO];
//    [UMessage didReceiveRemoteNotification:userInfo];
    
    /*推送2-收到远程消息推送*/
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    //收到推送的请求
    UNNotificationRequest *request = notification.request;
    //收到推送的内容
    UNNotificationContent *content = request.content;
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    //收到推送消息body
    NSString *body = content.body;
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    //推送消息的副标题
    NSString *subtitle = content.subtitle;
    //推送消息的标题
    NSString *title = content.title;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"收到远程通知");
//        [UMessage setAutoAlert:NO];
//        [UMessage didReceiveRemoteNotification:userInfo];
    }else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:nbody:%@，ntitle:%@,nsubtitle:%@,nbadge：%@，nsound：%@，\nnuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
}

/*收到本地通知*/
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
//    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
    
}

/*iOS10.0以上 收到推送--点击*/
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {

//    completionHandler(UIBackgroundFetchResultNewData);
    //收到推送的请求
    UNNotificationRequest *request = response.notification.request;
    //收到推送的内容
    UNNotificationContent *content = request.content;
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    //收到推送消息body
    NSString *body = content.body;
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    //推送消息的副标题
    NSString *subtitle = content.subtitle;
    //推送消息的标题
    NSString *title = content.title;
    NSLog(@"iOS10 收到本地通知:nbody:%@，ntitle:%@,nsubtitle:%@,nbadge：%@，nsound：%@，\nnuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    
//    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [UMessage didReceiveRemoteNotification:userInfo];
//        [self notificationPushToDetailWith:userInfo];
//    }
    completionHandler();
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
//    [JPUSHService setBadge:self.badgeNumber + 1];
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:self.badgeNumber + 1];
//    self.badgeNumber = self.badgeNumber + 1;
//    NSLog(@"%ld", (long)[[UIApplication sharedApplication] applicationIconBadgeNumber]);
//    NSLog(@"self.badgeNumber %d", self.badgeNumber);
//    NSDictionary *userInfo = notification.request.content.userInfo;
//
//    UNNotificationRequest *request = notification.request; // 收到推送的请求
//    UNNotificationContent *content = request.content; // 收到推送的消息内容
//    NSLog(@"request %@", request);
//    NSLog(@"content.badge %@", content.badge);
//    NSLog(@"userInfo %@", userInfo);
//
//    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//        /*收到远程推送进行的操作*/
//        [[DataManager lightData] saveBadgeNumber:content.badge];/*存储收到通知时的角标数量*/
//        NSLog(@"%d", [[[DataManager lightData] readBadgeNumber] intValue]);
//    }
//    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
    
}

/*极光-应用打开时点击推送消息4*/
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
//    NSDictionary *userInfo = response.notification.request.content.userInfo;
//
//    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//        [JPUSHService setBadge:self.badgeNumber - 1];
//        self.badgeNumber = self.badgeNumber - 1;
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:self.badgeNumber - 1];
//        NSLog(@"applicationIconBadgeNumber %ld", (long)[[UIApplication sharedApplication] applicationIconBadgeNumber]);
//        NSLog(@"self.badgeNumber %d", self.badgeNumber - 1);
//        [self notificationPushToDetailWith:userInfo];
//    }
//    completionHandler();
//}

#endif

#ifdef __IPHONE_12_0
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    NSString *title = nil;
    if (notification) {
        title = @"从通知界面直接进入应用";
    }else{
        title = @"从系统设置界面进入应用";
    }
    UIAlertView *test = [[UIAlertView alloc] initWithTitle:title
                                                   message:@"推送设置"
                                                  delegate:self
                                         cancelButtonTitle:@"Yes"
                                         otherButtonTitles:nil, nil];
    [test show];
    
}
#endif

/**********推送*/

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    
}

//App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OffTimer1" object:nil];
    
    [self performSelector:@selector(closeShareView) withObject:nil afterDelay:5];
    
}

//App从后台恢复至前台
- (void)applicationWillEnterForeground:(UIApplication *)application {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"OnTimer1" object:nil];

    /*检查版本更新*/
    [[VCManger homeVC] checkUpdate];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    if (![[[DataManager lightData]readPhone] valiMobile]) {
        [[DataManager lightData] removeSkey];
        [DataManager removeSkey];
    }
}

- (void) closeShareView{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeShareView" object:nil];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler{

    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        
//        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"版本更新提示"
//                                                            message:@"有新版本啦，请更新客户端！"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles: nil];
//        alterView.tag = 1;
//        [alterView show];
    }

    return YES;
}

- (void)notificationPushToDetailWith:(NSDictionary *)userInfo {
    
    NSLog(@"launchOptions %@", userInfo);
    if (userInfo) {
        [[DataManager lightData] saveUserInfoDict:userInfo];
    }
    /*1*/
    [self pushToViewControllerWith:userInfo];
}

- (void)pushToViewControllerWith:(NSDictionary *)userInfo {
    
    NSDictionary *hintDic = @{@"currentID":@"id"};
    self.messageObj = [CMLMessageObj objectWithModelDic:userInfo hintDic:hintDic];
    NSLog(@"%d", [[DataManager lightData].readIsLogin intValue]);
    
    if ([[DataManager lightData].readIsLogin intValue] == 0) {
        [[DataManager lightData] saveIsLoginOfPush:[NSNumber numberWithInt:1]];
    }else {
        NSLog(@"%d", [[[DataManager lightData] readIsLaunchOfPush] intValue]);
        NSLog(@"%d", [self.messageObj.objType intValue]);
        if (self.messageObj.objType) {
            switch ([self.messageObj.objType intValue]) {
                case 1:
                {
                    [[VCManger mainVC] popToRootVC];
                    [[VCManger homeVC] showCurrentViewController:0];
                    NSLog(@"首页");
                }
                    break;
                    
                case 2:
                {
                    NSLog(@"活动");
                    [[VCManger mainVC] popToRootVC];
                    [[VCManger homeVC] showCurrentViewController:1];
                }
                    break;
                    
                case 3:
                {
                    NSLog(@"商城");
                    [[VCManger mainVC] popToRootVC];
                    [[VCManger homeVC] showCurrentViewController:4];
                }
                    break;
                    
                case 4:
                {
                    NSLog(@"花伴");
                    [[VCManger mainVC] popToRootVC];
                    [[VCManger homeVC] showCurrentViewController:2];
                }
                    break;
                    
                case 5:
                {
                    /*活动详情页*/
                    [[VCManger homeVC] showCurrentViewController:3];
                    CMLMessageViewController *baseVC = [[CMLMessageViewController alloc] init];
                    [[VCManger mainVC] pushVC:baseVC animate:NO];
                    ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:self.messageObj.objId];
                    [[VCManger mainVC] pushVC:vc animate:YES];
                }
                    break;
                    
                case 6:
                {
                    /*单品详情页*/
                    [[VCManger homeVC] showCurrentViewController:3];
                    CMLMessageViewController *baseVC = [[CMLMessageViewController alloc] init];
                    [[VCManger mainVC] pushVC:baseVC animate:NO];
                    CMLCommodityDetailMessageVC *vc = [[CMLCommodityDetailMessageVC alloc] initWithObjId:self.messageObj.objId];
                    [[VCManger mainVC] pushVC:vc animate:YES];
                    
                }
                    break;
                    
                case 7:
                {
                    /*服务详情页*/
                    [[VCManger homeVC] showCurrentViewController:3];
                    CMLMessageViewController *baseVC = [[CMLMessageViewController alloc] init];
                    [[VCManger mainVC] pushVC:baseVC animate:NO];
                    ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:self.messageObj.objId];
                    [[VCManger mainVC] pushVC:vc animate:YES];
                }
                    break;
                    
                case 8:
                {
                    /*花伴活动详情*/
                    [[VCManger homeVC] showCurrentViewController:3];
                    CMLMessageViewController *baseVC = [[CMLMessageViewController alloc] init];
                    [[VCManger mainVC] pushVC:baseVC animate:NO];
                    CMLUserPushActivityDetailVC *vc = [[CMLUserPushActivityDetailVC alloc] initWithObjId:self.messageObj.objId];
                    [[VCManger mainVC] pushVC:vc animate:YES];
                }
                    break;
                    
                case 9:
                {
                    /*花伴单品详情*/
                    [[VCManger homeVC] showCurrentViewController:3];
                    CMLMessageViewController *baseVC = [[CMLMessageViewController alloc] init];
                    [[VCManger mainVC] pushVC:baseVC animate:NO];
                    CMLUserPushGoodsVC *vc = [[CMLUserPushGoodsVC alloc] initWithObjId:self.messageObj.objId];
                    [[VCManger mainVC] pushVC:vc animate:YES];
                }
                    break;
                    
                case 10:
                {
                    /*专题详情页*/
                    [[VCManger homeVC] showCurrentViewController:3];
                    CMLMessageViewController *baseVC = [[CMLMessageViewController alloc] init];
                    [[VCManger mainVC] pushVC:baseVC animate:NO];
                    CMLNewSpecialDetailTopicVC *vc = [[CMLNewSpecialDetailTopicVC alloc] initWithCurrentId:self.messageObj.objId];
                    [[VCManger mainVC] pushVC:vc animate:YES];
                }
                    break;
                    
                case 11:
                {
                    /*资讯详情页*/
                    [[VCManger homeVC] showCurrentViewController:3];
                    CMLMessageViewController *baseVC = [[CMLMessageViewController alloc] init];
                    [[VCManger mainVC] pushVC:baseVC animate:NO];
                    CMLUserArticleVC *vc = [[CMLUserArticleVC alloc] initWithObj:self.messageObj.objId];
                    [[VCManger mainVC] pushVC:vc animate:YES];
                }
                    break;
                    
                case 12:
                {
                    /*H5页面*/
                    [[VCManger homeVC] showCurrentViewController:3];
                    CMLMessageViewController *baseVC = [[CMLMessageViewController alloc] init];
                    [[VCManger mainVC] pushVC:baseVC animate:NO];
                    
                    WebViewLinkVC *vc = [[WebViewLinkVC alloc] init];
                    vc.url = self.messageObj.objUrl;
                    vc.name = self.messageObj.content;
                    //        vc.isDetailMes = YES;
                    [[VCManger mainVC] pushVC:vc animate:YES];
                    //                vc.shareUrl = obj.shareUrl;
                    //                vc.isShare = obj.shareStatus;
                    //                vc.desc = obj.desc;
                    
                }
                    break;
                    
                case 13:
                {
                    /*专区*/
                    [[VCManger homeVC] showCurrentViewController:3];
                    CMLMessageViewController *baseVC = [[CMLMessageViewController alloc] init];
                    [[VCManger mainVC] pushVC:baseVC animate:NO];
                    CMLPrefectureVC *vc = [[CMLPrefectureVC alloc] init];
                    vc.currentID = self.messageObj.objId;
                    [[VCManger mainVC] pushVC:vc animate:YES];
                }
                    break;

                default:
                {
                    [[VCManger mainVC] popToRootVC];/*回到根视图-如果处于二级页面*/
                    [[VCManger homeVC] showCurrentViewController:0];
                    NSLog(@"首页");
                }
                    break;
            }
        }
    }
}

- (void)setPushTag {
    __autoreleasing NSMutableSet *tags = [NSMutableSet set];
    [self.tagsArray removeAllObjects];
    [self.tagsArray addObject:@"10001"];
    if ([[DataManager lightData] readRoleId]) {
        switch ([[[DataManager lightData] readRoleId] intValue]) {
            case 1:/*粉*/
                [self.tagsArray addObject:@"20001"];
                break;
            case 2:/*粉银*/
                [self.tagsArray addObject:@"20001"];
                break;
            case 3:/*粉金*/
                [self.tagsArray addObject:@"20002"];
                break;
            case 4:/*粉钻*/
                [self.tagsArray addObject:@"20001"];
                break;
            case 5:/*黛*/
                [self.tagsArray addObject:@"30001"];
                break;
            case 6:/*黛*/
                [self.tagsArray addObject:@"30001"];
                break;
            case 7:/*金*/
                [self.tagsArray addObject:@"40001"];
                break;
            case 8:/*墨*/
                [self.tagsArray addObject:@"50001"];
                break;
            case 10:/*企业卡*/
                [self.tagsArray addObject:@"100001"];
                break;
            case 11:/*城市合伙人*/
                [self.tagsArray addObject:@"110001"];
                break;
                
            default:
                break;
        }
    }else {
        if ([[DataManager lightData] readUserLevel]) {
            switch ([[[DataManager lightData] readUserLevel] intValue]) {
                    
                case 1:/*粉*/
                    [self.tagsArray addObject:@"20001"];
                    break;
                case 2:/*黛*/
                    [self.tagsArray addObject:@"30001"];
                    break;
                case 3:/*金*/
                    [self.tagsArray addObject:@"40001"];
                    break;
                case 4:/*墨*/
                    [self.tagsArray addObject:@"50001"];
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    if ([[DataManager lightData] readUserLevel] || [[DataManager lightData] readRoleId]) {
        [tags addObjectsFromArray:self.tagsArray];
        NSLog(@"AppDelegate tags %@", tags);
//        [JPUSHService setTags:tags completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//            NSLog(@"iResCode %ld", (long)iResCode);
//            if (iResCode == 0) {
//                NSLog(@"AppDelegatePushTag设置成功");
//            }
//        } seq:0];
//        [UMessage addTags:self.tagsArray response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {
//            NSLog(@"addTags%@", responseObject);
//        }];
//        [UMessage getTags:^(NSSet * _Nonnull responseTags, NSInteger remain, NSError * _Nullable error) {
//            NSLog(@"getTags%@", responseTags);
//        }];
    }
}

- (NSMutableArray *)tagsArray {
    
    if (!_tagsArray) {
        _tagsArray = [NSMutableArray array];
    }
    return _tagsArray;
}

#pragma mark LoginVCDelegate
- (void)registerPushAfterLogin {
    
//    [self jpushInitWith:[[DataManager lightData] readUserInfoDict]];
    /*推送2*/
//    [self registerAPNsAuthorizationWithApplication:[UIApplication sharedApplication]];
    [self initUMPushWithLaunchOptions:[[DataManager lightData] readUserInfoDict]];
    
}

/*推送2*/
- (void)registerAPNsAuthorizationWithApplication:(UIApplication *)application {
 
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                NSLog(@"注册成功");
            }else {
                NSLog(@"注册失败");
            }
        }];
        /*获取用户权限设置*/
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"PushSetting====%@", settings);
        }];
    }else if (@available(iOS 8.0, *)) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    /*注册远端消息通知获取devicetoken*/
    [application registerForRemoteNotifications];
    
}
@end
