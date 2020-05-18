//
//  CMLPersonalCenterVC.m
//  camelliae2.0
//
//  Created by 张越 on 16/5/19.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLPersonalCenterVC.h"
#import "CMLPersonCenterSettingVC.h"
#import "PersonalCenterCollectionVC.h"
#import "CMLPersonalCenterPointsVC.h"
#import "CMLPersonalCenterOrderVC.h"
#import "VCManger.h"
#import "LoginUserObj.h"
#import "CMLVIPNewsImageShowVC.h"
#import "NewPersonDetailInfoVC.h"
#import "CMLVIPNewDetailVC.h"
#import "CMLNewPersonalVIPVC.h"
#import "CMLGoodsOrderListVC.h"
#import "CMLNewIntegrationVC.h"
#import "CMLInviteFriendsVC.h"
#import "GainPointsShadowView.h"
#import "CMLNewVipVC.h"
#import "CMLNewPersonalCenterContentView.h"
#import "CMLNewPersonalTopContentView.h"
#import "AppDelegate.h"

#define PersonalCenterRowHeight                100
#define PersonalCenterMyIconLeftmargin         15
#define PersonalCenterMyIconAllRoundMargin     30
#define PersonalCenterMyIconHeightAndWidth     48
#define UpViewHeight                           20
#define CMLPersonalCenterVCletfMargin          30

@interface CMLPersonalCenterVC ()<NetWorkProtocol,NavigationBarProtocol,UIScrollViewDelegate,NewRefreshPersonalCenterDelegate,UITableViewDataSource,UITableViewDelegate,NewPersonalCenterContentViewDelegate, CMLNewPersonalTopContentViewDelegate>

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) UIButton *signBtn;

@property (nonatomic,assign) BOOL isFirstRequest;

@property (nonatomic,strong) CMLNewPersonalCenterContentView *personalCenterContentView;

@property (nonatomic,strong) CMLNewPersonalTopContentView *personalTopView;

@property (nonatomic,strong) UITableView *testTableView;

@property (nonatomic, strong) UIScrollView *contentScrollView;

@end

@implementation CMLPersonalCenterVC

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
//    self.view.hidden = YES;
    if (self.isFirstRequest) {
     
        [self refrshPersonalCenter];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shareWXSuccess)
                                                 name:@"WXShareSuccess"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shareWXError)
                                                 name:@"WXShareError"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeCurrentShareView)
                                                 name:@"closeShareView"
                                               object:nil];
    
    [MobClick beginLogPageView:@"PageOneOfPersonalCenter"];

}

- (void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WXShareSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WXShareError" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"closeShareView" object:nil];
    [MobClick endLogPageView:@"PageOneOfPersonalCenter"];
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.contentView.backgroundColor = [UIColor CMLNewCenterGrayColor];
    self.navBar.hidden = YES;
    [self loadData];
    
    self.isFirstRequest = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction) name:@"refreshUserCenterView" object:nil];

}

- (void) loadData{
    
    /********shareblock********/
    __weak typeof(self) weakSelf = self;
    
    self.baseShareContent = @"卡枚连是中国首个以独立自主精神为主题的专属女性VIP社区。";
    self.baseShareTitle = @"卡枚连";
    self.baseShareLink = [[DataManager lightData] readAppDownloadUrl];
    
    self.shareSuccessBlock = ^(){
        
        [weakSelf hiddenCurrentVCShareView];
    };
    
    self.sharesErrorBlock = ^(){
        
        [weakSelf hiddenCurrentVCShareView];
    };
    
    self.refreshViewController = ^(){
        
        [weakSelf hideNetErrorTipOfNormalVC];
        [weakSelf refreshPersonalCenterVC];
    };
    
    self.baseShareImage = [UIImage imageNamed:RecommendImg];
    
    [self refrshPersonalCenter];
    
    [self startLoading];
    

}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *idetifer = @"myCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idetifer ];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    
    return cell;
}

- (void) loadViews{
    
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 4000)];
    self.contentScrollView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.contentScrollView];
    
    UIImageView *topBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLVIPCenterBgImg]];
    topBgView.contentMode = UIViewContentModeScaleAspectFill;
    topBgView.clipsToBounds = YES;
    topBgView.userInteractionEnabled = YES;
    topBgView.frame = CGRectMake(-80*Proportion,
                                 0,
                                 WIDTH,
                                 topBgView.frame.size.height - 15*Proportion);
    [self.contentScrollView addSubview:topBgView];
    
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topBgView.frame), WIDTH, HEIGHT)];
    testView.backgroundColor = [UIColor CMLWhiteColor];
    [self.contentScrollView addSubview:testView];
    
    [self.personalTopView removeFromSuperview];
    [self.personalCenterContentView removeFromSuperview];
    [self.testTableView removeFromSuperview];
    
    NSData *imageNata = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.obj.retData.user.coverUrl]];
    UIImage *image = [UIImage imageWithData:imageNata];
    
    NSData *vImageNata = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.obj.retData.user.vUrl]];
    UIImage *vImage = [UIImage imageWithData:vImageNata];
    
    self.personalTopView = [[CMLNewPersonalTopContentView alloc] initWithObj:self.obj withCoverImage:image vImage:vImage];
    self.personalTopView.topDelegate = self;
    self.personalTopView.backgroundColor = [UIColor clearColor];
    self.personalTopView.frame = CGRectMake(0,
                                            0,
                                            WIDTH,
                                            self.personalTopView.currentHeight);
    [self.contentScrollView addSubview:self.personalTopView];
    
    /*我的订单等+签到领积分等*/
    self.personalCenterContentView = [[CMLNewPersonalCenterContentView alloc] initWithObj:self.obj];
    self.personalCenterContentView.delegate = self;
    self.personalCenterContentView.frame = CGRectMake(0,
                                                      0,
                                                      WIDTH,
                                                      self.personalCenterContentView.currentHeight);
    self.testTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       375*Proportion,
                                                                       WIDTH,
                                                                       HEIGHT - UITabBarHeight - SafeAreaBottomHeight - 375*Proportion*Proportion)
                                                      style:UITableViewStylePlain];
    self.testTableView.backgroundColor = [UIColor clearColor];
    self.testTableView.showsHorizontalScrollIndicator = NO;
    self.testTableView.showsVerticalScrollIndicator = NO;
    self.testTableView.dataSource = self;
    self.testTableView.delegate = self;
    self.testTableView.tableHeaderView = self.personalCenterContentView;
    self.testTableView.rowHeight = 0;
    self.testTableView.tableFooterView = [[UIView alloc] init];
    self.testTableView.scrollEnabled = YES;
    [self.contentScrollView addSubview:self.testTableView];
    self.contentScrollView.frame = CGRectMake(0, 0, WIDTH, CGRectGetMaxY(self.testTableView.frame));//
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.contentScrollView.scrollEnabled = YES;
    if (self.testTableView.contentOffset.y <= 0) {
        
        if (self.testTableView.contentOffset.y <= -120) {
        
            self.testTableView.scrollEnabled = NO;
            NSLog(@"self.testTableView.contentOffset.y <= -120");
        }else{
            
            self.testTableView.scrollEnabled = YES;
            NSLog(@"0 > self.testTableView.contentOffset.y > -120");
        }
    }else if (self.testTableView.contentOffset.y >= 0) {
        self.testTableView.scrollEnabled = YES;
        
        NSLog(@"self.testTableView.contentOffset.y >= 0");
    }
}
 
- (void) refrshPersonalCenter{

    /**网络请求*/
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSNumber *userId = [[DataManager lightData] readUserID];
    [paraDic setObject:userId forKey:@"userId"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[userId,reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:NewMemberUser paraDic:paraDic delegate:delegate];
    self.currentApiName = NewMemberUser;
    
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:NewMemberUser]) {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (appDelegate.isNetError) {
            [appDelegate setAppStartMes];
        }
        
        BaseResultObj *resObj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([resObj.retCode intValue] == 0 && resObj) {
            self.obj = resObj;
            LoginUserObj *userInfo = resObj.retData.user;
            
            [[DataManager lightData] saveSignStatus:userInfo.signStatus];
            [[DataManager lightData] saveUser:self.obj];
            /**会员列表修改*/
            [self loadViews];
            
//            self.view.hidden = NO;
            
        }else if ([resObj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            
            NSLog(@"%@",resObj.retMsg);
        }
    }else{
    
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            GainPointsShadowView *successView = [[GainPointsShadowView alloc] initWithDays:obj.retData.totalSignDays
                                                                                 andPoints:obj.retData.points];
            successView.frame = CGRectMake(0,
                                           0,
                                           WIDTH,
                                           HEIGHT);
            
            
            [[[ UIApplication  sharedApplication ] keyWindow] addSubview : successView] ;
            self.signBtn.selected = YES;
            self.signBtn.userInteractionEnabled = NO;
             [[DataManager lightData] saveSignStatus:[NSNumber numberWithInt:1]];
            
        }else{
        
            [self showFailTemporaryMes:obj.retMsg];
        }
    }

    
    [self stopLoading];
    [self stopIndicatorLoading];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    [self showNetErrorTipOfMainVC];
    [self stopLoading];
    [self stopIndicatorLoading];
    
}

#pragma mark - 购买完刷新

//- (void)refreshCurrentUser {
//    NSLog(@"刷新了usermessage");
//    [self refrshPersonalCenter];
//}

- (void) refreshCurrentUserMessage{
    NSLog(@"刷新了usermessage");
    [self refrshPersonalCenter];
}

- (void) refreshPersonalCenterVC{
    
    [self refrshPersonalCenter];
}

- (void) readMessageRefreshCenter{

    [self refrshPersonalCenter];
}

- (void) refreshCurrentTopUserMessage{

    [self refrshPersonalCenter];
}

- (void) invitationFriendVC{

    CMLInviteFriendsVC *vc = [[CMLInviteFriendsVC alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) sign{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:IntegrationSign paraDic:paraDic delegate:delegate];
    self.currentApiName = IntegrationSign;
    [self stopIndicatorLoading];
}

- (void) notificationAction{

    self.signBtn.selected = YES;
    self.signBtn.userInteractionEnabled = NO;
    [[DataManager lightData] saveSignStatus:[NSNumber numberWithInt:1]];
}


#pragma mark - 朋友圈或对话分享成功
- (void) shareWXSuccess{
    
    [self showSuccessTemporaryMes:@"推荐成功"];
    [self hiddenCurrentVCShareView];
    
}

- (void) shareWXError{
    
    [self showSuccessTemporaryMes:@"推荐失败"];
    [self hiddenCurrentVCShareView];
}

#pragma mark - closeCurrentShareView
- (void) closeCurrentShareView{
    
    [self hiddenCurrentVCShareView];
    
}

- (void) signCML{
    
    [self sign];
}

- (void) shareCML{
    
    [self showCurrentVCShareView];
}

#pragma mark CMLNewPersonalTopContentViewDelegate
- (void)refreshCurrentUserWithTopContentView {
    
    [self refrshPersonalCenter];
    
}

@end
