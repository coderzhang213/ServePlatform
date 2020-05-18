//
//  HomeVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/24.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "HomeVC.h"
#import "CommonNumber.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "AppGroup.h"
#import "NetWorkTask.h"
#import "NetConfig.h"
#import "BaseResultObj.h"
#import "DataManager.h"
#import "NSString+CMLExspand.h"
#import "VCManger.h"
#import "UIColor+SDExspand.h"
#import "VCManger.h"
#import "LoginVC.h"
#import "CMLLine.h"
#import "JPUSHService.h"
#import <UMPush/UMessage.h>

#define TabBarViewHeight         98
#define TabBarNameBottomMargin   6
#define TabBarImageTopMargin     16


@interface HomeVC ()<UITabBarControllerDelegate,NetWorkProtocol>


@property (nonatomic,strong) UIImageView *sectionOneImage;

@property (nonatomic,strong) UIImageView *sectionTwoImage;

@property (nonatomic,strong) UIImageView *sectionThreeImage;

@property (nonatomic,strong) UIImageView *sectionFourImage;

@property (nonatomic,strong) UIImageView *sectionFiveImage;

@property (nonatomic,strong) UILabel *sectionOneName;

@property (nonatomic,strong) UILabel *sectionTwoName;

@property (nonatomic,strong) UILabel *sectionThreeName;

@property (nonatomic,strong) UILabel *sectionFourName;

@property (nonatomic,strong) UILabel *sectionFiveName;

@property (nonatomic,strong) UIViewController *currentVC;

@property (nonatomic,assign) NSInteger selectedNum;

@property (nonatomic,strong) UIView *redPointsView;

@property (nonatomic, strong) NSMutableArray *tagsArray;

@end

@implementation HomeVC

- (NSMutableArray *)tagsArray {
    
    if (!_tagsArray) {
        _tagsArray = [NSMutableArray array];
    }
    return _tagsArray;
}


- (instancetype)init{

    self = [super init];
    
    if (self) {
        
    }
    return self;
}

/*设置推送tags*/
- (void)setPushTag {
    __autoreleasing NSMutableSet *tags = [NSMutableSet set];
    [self.tagsArray removeAllObjects];
    [self.tagsArray addObject:@"10001"];
    NSLog(@"%d", [[[DataManager lightData] readRoleId] intValue]);
    if ([[DataManager lightData] readRoleId]) {
        switch ([[[DataManager lightData] readRoleId] intValue]) {
            case 1:/*粉*/
                [self.tagsArray addObject:@"20001"];
                break;
            case 2:/*粉*/
                [self.tagsArray addObject:@"20001"];
                break;
            case 3:/*粉*/
                [self.tagsArray addObject:@"20002"];
                break;
            case 4:/*粉*/
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
        NSLog(@"HomeVC tags %@", tags);
        [JPUSHService setTags:tags completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
            NSLog(@"iResCode %ld", (long)iResCode);
            if (iResCode == 0) {
                NSLog(@"HomeVCpushTag设置成功");
            }
        } seq:0];
        [UMessage addTags:self.tagsArray response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {
            NSLog(@"HomeVCaddTags%@", responseObject);
        }];
        [UMessage getTags:^(NSSet * _Nonnull responseTags, NSInteger remain, NSError * _Nullable error) {
            NSLog(@"HomeVCgetTags%@", responseTags);
        }];
    }
}

- (void)viewDidLoad{

    [super viewDidLoad];
    /**清除登录视图*/
    [self clearLoginVC];
    [self setPushTag];
    self.tabBar.hidden = YES;
    /*NO：self.view的原点从导航栏左下角开始计算*/
    [UITabBar appearance].translucent = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    /*检查更新*/
    [self checkUpdate];

    /**设置子控制器*/
    self.vipVC = [[CMLNewVipVC alloc] init];
    self.vipVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil
                                                          image:[UIImage imageNamed:DisVIPImg]
                                                  selectedImage:[UIImage imageNamed:VIPImg]];
    
    self.mainInterfaceVC = [[CMLMainInterfaceVC alloc] init];
    self.mainInterfaceVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil
                                                                    image:[UIImage imageNamed:DisFindImg]
                                                            selectedImage:[UIImage imageNamed:FindImg]];
    self.personalCenterVC = [[CMLPersonalCenterVC alloc] init];
    self.personalCenterVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil
                                                                     image:[UIImage imageNamed:DisUserImg]
                                                             selectedImage:[UIImage imageNamed:UserImg]];
    self.ActivityVC = [[CMLNewActivityVC alloc] init];
    self.ActivityVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil
                                                               image:[UIImage imageNamed:DisActivityImg]
                                                       selectedImage:[UIImage imageNamed:ActivityImg]];
    
    self.storeVC = [[CMLStoreVC alloc] init];
    self.storeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil
                                                               image:[UIImage imageNamed:DisStoreImg]
                                                       selectedImage:[UIImage imageNamed:StoreImg]];
    
    self.viewControllers = @[self.mainInterfaceVC,
                             self.ActivityVC,
                             self.vipVC,
                             self.personalCenterVC,
                             self.storeVC];
    self.selectedIndex = 0;
    
    
    /**自定义tabbar*/
    self.tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               HEIGHT - UITabBarHeight - SafeAreaBottomHeight,
                                                               WIDTH,
                                                               UITabBarHeight)];
    self.tabBarView.backgroundColor = [UIColor whiteColor];
    [self.view bringSubviewToFront:self.tabBarView];
    [self.view addSubview:self.tabBarView];
    
    CMLLine *lineOne = [[CMLLine alloc] init];
    lineOne.startingPoint = CGPointMake(0, 0);
    lineOne.lineWidth = 1*Proportion;
    lineOne.LineColor = [UIColor CMLPromptGrayColor];
    lineOne.lineLength = WIDTH;
    [self.tabBarView addSubview:lineOne];
    
    CGFloat itemSpace = WIDTH/5.0;
    
    /**find*/
    self.sectionOneImage = [[UIImageView alloc] init];
    self.sectionOneImage.image = [UIImage imageNamed:FindImg];
    [self.sectionOneImage sizeToFit];
    self.sectionOneImage.frame = CGRectMake(itemSpace/2.0 - self.sectionOneImage.frame.size.width/2.0,
                                            TabBarImageTopMargin*Proportion,
                                            self.sectionOneImage.frame.size.width,
                                            self.sectionOneImage.frame.size.height);
    self.sectionOneImage.userInteractionEnabled = YES;
    [self.tabBarView addSubview:self.sectionOneImage];
    
    self.sectionOneName = [[UILabel alloc] init];
    self.sectionOneName.text = @"发现";
    self.sectionOneName.font = KSystemFontSize10;
    [self.sectionOneName sizeToFit];
    self.sectionOneName.userInteractionEnabled = YES;
    self.sectionOneName.textColor = [UIColor CMLLineGrayColor];

    self.sectionOneName.frame = CGRectMake(self.sectionOneImage.center.x - self.sectionOneName.frame.size.width/2.0,
                                           CGRectGetMaxY(self.sectionOneImage.frame) + 4*Proportion,//self.tabBar.frame.size.height - self.sectionOneName.frame.size.height - TabBarNameBottomMargin*Proportion,
                                           self.sectionOneName.frame.size.width,
                                           self.sectionOneName.frame.size.height);
    [self.tabBarView addSubview:self.sectionOneName];
    
    UIButton *sectionOneBtn = [[UIButton alloc] initWithFrame:CGRectMake(itemSpace/2.0 - self.tabBar.frame.size.height/2.0,
                                                                         0,
                                                                         self.tabBar.frame.size.height,
                                                                         self.tabBar.frame.size.height)];
    sectionOneBtn.tag = 1;
    [self.tabBarView addSubview:sectionOneBtn];
    [sectionOneBtn addTarget:self action:@selector(changeVC:) forControlEvents:UIControlEventTouchUpInside];
    
    
    /**活动*/
    self.sectionTwoImage = [[UIImageView alloc] init];
    self.sectionTwoImage.image = [UIImage imageNamed:DisActivityImg];
    [self.sectionTwoImage sizeToFit];
    self.sectionTwoImage.userInteractionEnabled = YES;
    self.sectionTwoImage.frame = CGRectMake(itemSpace/2.0 - self.sectionTwoImage.frame.size.width/2.0 + itemSpace,
                                            TabBarImageTopMargin*Proportion,
                                            self.sectionTwoImage.frame.size.width,
                                            self.sectionTwoImage.frame.size.height);
    [self.tabBarView addSubview:self.sectionTwoImage];
    
    self.sectionTwoName = [[UILabel alloc] init];
    self.sectionTwoName.text = @"活动";
    self.sectionTwoName.font = KSystemFontSize10;
    [self.sectionTwoName sizeToFit];
    self.sectionTwoName.userInteractionEnabled = YES;
    self.sectionTwoName.textColor = [UIColor CMLLineGrayColor];
    self.sectionTwoName.frame = CGRectMake(self.sectionTwoImage.center.x - self.sectionTwoName.frame.size.width/2.0,
                                           CGRectGetMaxY(self.sectionOneImage.frame) + 4*Proportion,//self.tabBar.frame.size.height - self.sectionTwoName.frame.size.height - TabBarNameBottomMargin*Proportion,
                                           self.sectionTwoName.frame.size.width,
                                           self.sectionTwoName.frame.size.height);
    [self.tabBarView addSubview:self.sectionTwoName];
    
    UIButton *sectionTwoBtn = [[UIButton alloc] initWithFrame:CGRectMake(itemSpace/2.0 - self.tabBar.frame.size.height/2.0 + itemSpace,
                                                                         0,
                                                                         self.tabBar.frame.size.height,
                                                                         self.tabBar.frame.size.height)];
    sectionTwoBtn.tag = 2;
    [self.tabBarView addSubview:sectionTwoBtn];
    [sectionTwoBtn addTarget:self action:@selector(changeVC:) forControlEvents:UIControlEventTouchUpInside];
    
    /**商城*/
    self.sectionFiveImage = [[UIImageView alloc] init];
    self.sectionFiveImage.image = [UIImage imageNamed:DisUserImg];
    [self.sectionFiveImage sizeToFit];
    self.sectionFiveImage.userInteractionEnabled = YES;
    self.sectionFiveImage.frame = CGRectMake(itemSpace/2.0 - self.sectionFiveImage.frame.size.width/2.0 + itemSpace*2,
                                             TabBarImageTopMargin*Proportion,
                                             self.sectionFiveImage.frame.size.width,
                                             self.sectionFiveImage.frame.size.height);
    [self.tabBarView addSubview:self.sectionFiveImage];
    
   

    
    self.sectionFiveName = [[UILabel alloc] init];
    self.sectionFiveName.text = @"商城";
    self.sectionFiveName.font = KSystemFontSize10;
    [self.sectionFiveName sizeToFit];
    self.sectionFiveName.userInteractionEnabled = YES;
    self.sectionFiveName.textColor = [UIColor CMLLineGrayColor];
    self.sectionFiveName.frame = CGRectMake(self.sectionFiveImage.center.x - self.sectionFiveName.frame.size.width/2.0,
                                            CGRectGetMaxY(self.sectionOneImage.frame) + 4*Proportion,//self.tabBar.frame.size.height - self.sectionFiveName.frame.size.height - TabBarNameBottomMargin*Proportion,
                                            self.sectionFiveName.frame.size.width,
                                            self.sectionFiveName.frame.size.height);
    [self.tabBarView addSubview:self.sectionFiveName];
    
    UIButton *sectionFiveBtn = [[UIButton alloc] initWithFrame:CGRectMake(itemSpace/2.0 - self.tabBar.frame.size.height/2.0 + itemSpace*2,
                                                                          0,
                                                                          self.tabBar.frame.size.height,
                                                                          self.tabBar.frame.size.height)];
    
    sectionFiveBtn.tag = 5;
    [self.tabBarView addSubview:sectionFiveBtn];
    [sectionFiveBtn addTarget:self action:@selector(changeVC:) forControlEvents:UIControlEventTouchUpInside];
    
    /**vip*/
    self.sectionThreeImage = [[UIImageView alloc] init];
    self.sectionThreeImage.image = [UIImage imageNamed:DisVIPImg];
    [self.sectionThreeImage sizeToFit];
    self.sectionThreeImage.userInteractionEnabled = YES;
    self.sectionThreeImage.frame = CGRectMake(itemSpace/2.0 - self.sectionThreeImage.frame.size.width/2.0 + itemSpace*3,
                                              TabBarImageTopMargin*Proportion,
                                              self.sectionThreeImage.frame.size.width,
                                              self.sectionThreeImage.frame.size.height);
    [self.tabBarView addSubview:self.sectionThreeImage];
    
    self.sectionThreeName = [[UILabel alloc] init];
    self.sectionThreeName.text = @"花伴";
    self.sectionThreeName.font = KSystemFontSize10;
    [self.sectionThreeName sizeToFit];
    self.sectionThreeName.userInteractionEnabled = YES;
    self.sectionThreeName.textColor = [UIColor CMLLineGrayColor];
    self.sectionThreeName.frame = CGRectMake(self.sectionThreeImage.center.x - self.sectionThreeName.frame.size.width/2.0,
                                             CGRectGetMaxY(self.sectionOneImage.frame) + 4*Proportion,//self.tabBar.frame.size.height - self.sectionThreeName.frame.size.height - TabBarNameBottomMargin*Proportion,
                                             self.sectionThreeName.frame.size.width,
                                             self.sectionThreeName.frame.size.height);
    [self.tabBarView addSubview:self.sectionThreeName];

    UIButton *sectionThreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(itemSpace/2.0 - self.tabBar.frame.size.height/2.0 + itemSpace*3,
                                                                           0,
                                                                           self.tabBar.frame.size.height,
                                                                           self.tabBar.frame.size.height)];

    sectionThreeBtn.tag = 3;
    [self.tabBarView addSubview:sectionThreeBtn];
    [sectionThreeBtn addTarget:self action:@selector(changeVC:) forControlEvents:UIControlEventTouchUpInside];
    
    
    /**我的*/
    self.sectionFourImage = [[UIImageView alloc] init];
    self.sectionFourImage.image = [UIImage imageNamed:DisUserImg];
    [self.sectionFourImage sizeToFit];
    self.sectionFourImage.userInteractionEnabled = YES;
    self.sectionFourImage.frame = CGRectMake(itemSpace/2.0 - self.sectionFourImage.frame.size.width/2.0 + itemSpace*4,
                                             TabBarImageTopMargin*Proportion,
                                             self.sectionFourImage.frame.size.width,
                                             self.sectionFourImage.frame.size.height);
    [self.tabBarView addSubview:self.sectionFourImage];
    
    self.sectionFourName = [[UILabel alloc] init];
    self.sectionFourName.text = @"我的";
    self.sectionFourName.font = KSystemFontSize10;
    [self.sectionFourName sizeToFit];
    self.sectionFourName.userInteractionEnabled = YES;
    self.sectionFourName.textColor = [UIColor CMLLineGrayColor];
    self.sectionFourName.frame = CGRectMake(self.sectionFourImage.center.x - self.sectionFourName.frame.size.width/2.0,
                                            CGRectGetMaxY(self.sectionOneImage.frame) + 4*Proportion,//self.tabBar.frame.size.height - self.sectionFourName.frame.size.height - TabBarNameBottomMargin*Proportion,
                                            self.sectionFourName.frame.size.width,
                                            self.sectionFourName.frame.size.height);
    [self.tabBarView addSubview:self.sectionFourName];
    
    UIButton *sectionFourBtn = [[UIButton alloc] initWithFrame:CGRectMake(itemSpace/2.0 - self.tabBar.frame.size.height/2.0 + itemSpace*4,
                                                                          0,
                                                                          self.tabBar.frame.size.height,
                                                                          self.tabBar.frame.size.height)];
    
    sectionFourBtn.tag = 4;
    [self.tabBarView addSubview:sectionFourBtn];
    [sectionFourBtn addTarget:self action:@selector(changeVC:) forControlEvents:UIControlEventTouchUpInside];
    
    [self showCurrentViewController:homeMainInterfaceTag];
    
}

- (void) showCurrentViewController:(HomeTag) tag{
    NSLog(@"%u", tag);
    switch (tag) {
        case homeMainInterfaceTag:/*首页0*/
            self.selectedViewController = self.mainInterfaceVC;
            self.currentVC = self.mainInterfaceVC;
            self.selectedNum =1;
            break;
        case homeActivityTag:/*活动1*/
            self.selectedViewController = self.ActivityVC;
            self.currentVC = self.ActivityVC;
            self.selectedNum =2;
            break;
        case homeVIPTag:/*花伴2*/
            self.selectedViewController = self.vipVC;
            self.currentVC = self.vipVC;
            self.selectedNum = 3;
            break;
        case homePersoncenterTag:/*我的3*/
            self.selectedViewController = self.personalCenterVC;
            self.currentVC = self.personalCenterVC;
            self.selectedNum =4;
            break;
        case homeStoreTag:/*商城4*/
            self.selectedViewController = self.storeVC;
            self.currentVC = self.storeVC;
            self.selectedNum =5;
            break;
            
        default:
            break;
    }
    [self setButtonState:self.selectedNum];
    
}

- (void) setCurrnetVC:(NSUInteger) num{
    
    switch (num) {
        case 1:
            
            self.selectedViewController = self.mainInterfaceVC;
            self.currentVC = self.mainInterfaceVC;
            self.selectedNum = 1;
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

            break;
        case 3:
            
            self.selectedViewController = self.vipVC;
            self.currentVC = self.vipVC;
            self.selectedNum = 3;
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

            break;
        case 4:
            self.selectedViewController = self.personalCenterVC;
            self.currentVC = self.personalCenterVC;
            self.selectedNum = 4;
            [self.personalCenterVC refreshPersonalCenterVC];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            
            break;
        case 2:
            
            self.selectedViewController = self.ActivityVC;
            self.currentVC = self.ActivityVC;
            [self.ActivityVC refrshCurrentVC];
            self.selectedNum = 2;
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
           
            break;
        case 5:
            
            self.selectedViewController = self.storeVC;
            self.currentVC = self.storeVC;
            self.selectedNum = 5;
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            
            break;
            
        default:
            break;
    }
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    self.currentVC = viewController;
    return YES;
}


#pragma mark - changeVC

- (void) changeVC:(UIButton *) button{
    
    [self setButtonState:button.tag];
    [self setCurrnetVC:button.tag];
    
}

- (void) setButtonState:(NSInteger) num{
    NSLog(@"%lud",(unsigned long) num);
    switch (num) {
        case 1:
            self.sectionOneImage.image = [UIImage imageNamed:FindImg];
            self.sectionTwoImage.image = [UIImage imageNamed:DisActivityImg];
            self.sectionThreeImage.image = [UIImage imageNamed:DisVIPImg];
            self.sectionFourImage.image = [UIImage imageNamed:DisUserImg];
            self.sectionFiveImage.image = [UIImage imageNamed:DisStoreImg];
            break;
        case 2:
            self.sectionOneImage.image = [UIImage imageNamed:DisFindImg];
            self.sectionTwoImage.image = [UIImage imageNamed:ActivityImg];
            self.sectionThreeImage.image = [UIImage imageNamed:DisVIPImg];
            self.sectionFourImage.image = [UIImage imageNamed:DisUserImg];
            self.sectionFiveImage.image = [UIImage imageNamed:DisStoreImg];
            break;
            
        case 3:
            self.sectionOneImage.image = [UIImage imageNamed:DisFindImg];
            self.sectionTwoImage.image = [UIImage imageNamed:DisActivityImg];
            self.sectionThreeImage.image = [UIImage imageNamed:VIPImg];
            self.sectionFourImage.image = [UIImage imageNamed:DisUserImg];
            self.sectionFiveImage.image = [UIImage imageNamed:DisStoreImg];
            break;
            
        case 4:
            self.sectionOneImage.image = [UIImage imageNamed:DisFindImg];
            self.sectionTwoImage.image = [UIImage imageNamed:DisActivityImg];
            self.sectionThreeImage.image = [UIImage imageNamed:DisVIPImg];
            self.sectionFourImage.image = [UIImage imageNamed:UserImg];
            self.sectionFiveImage.image = [UIImage imageNamed:DisStoreImg];
            break;
        case 5:
            self.sectionOneImage.image = [UIImage imageNamed:DisFindImg];
            self.sectionTwoImage.image = [UIImage imageNamed:DisActivityImg];
            self.sectionThreeImage.image = [UIImage imageNamed:DisVIPImg];
            self.sectionFourImage.image = [UIImage imageNamed:DisUserImg];
            self.sectionFiveImage.image = [UIImage imageNamed:StoreImg];
            break;
            
        default:
            break;
    }
    
}
#pragma mark - 清除登录控制器
- (void) clearLoginVC{

    NSArray *array = [VCManger mainVC].viewControllers;
    
    for (int i = 0; i < array.count; i++) {
        
        if ([array[i] isKindOfClass:[LoginVC class]]) {
            NSMutableArray *oldArray = [NSMutableArray arrayWithArray:array];
            [oldArray removeObjectAtIndex:i];
            [[VCManger mainVC] setViewControllers:oldArray];
            break;
        }
    }
}

- (void) hiddenTabBarView{

    self.tabBarView.alpha = 0;
    
}

- (void) showTabBarView{

    self.tabBarView.alpha = 1;
}

/*检查更新*/
- (void)checkUpdate {
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"clientType"];
    [paraDic setObject:[AppGroup appVersion] forKey:@"version"];
    [NetWorkTask postResquestWithApiName:CMLIsUpdate paraDic:paraDic delegate:delegate];
}

#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    NSLog(@"CMLIsUpdate %@", responseResult);
    
    if ([obj.retCode intValue] == 0 && obj) {
        if ([obj.retData.isUpdate intValue] == 1) {
            [self checkCurrentVersion];
        }
    }else{
        
    }
    
}

- (BOOL)checkCurrentVersion {
    
    /*
     isUpdate：1 强制更新--当前版本低于服务器设定版本号时需要更新；
     服务器版本号 <= AppStore 版本号：不符合时说明AppStore尚未更新完成，此时暂时不提示更新消息
     */
    //签名的字符串、请求URL地址
    NSString *requestString = [NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",AppID];
    //header参数
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:requestString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
            
            NSLog(@"%d", realVersionNum);
            NSLog(@"%d", currentVersionNum);
            if (realVersionNum > currentVersionNum) {
                
                [[DataManager lightData] saveIsCanUpdate:[NSNumber numberWithInt:1]];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"版本更新提示"
                                                                                         message:@"有新版本啦，请更新客户端！"
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    /*打开App Store*/
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", AppID]];
                    [[UIApplication sharedApplication] openURL:url];
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
                
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


- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
}

/*AlertView点击*/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", AppID]];
    [[UIApplication sharedApplication] openURL:url];
}



@end
