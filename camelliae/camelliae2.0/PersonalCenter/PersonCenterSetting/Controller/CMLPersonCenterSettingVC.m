//
//  CMLPersonCenterSettingVC.m
//  camelliae2.0
//
//  Created by 张越 on 16/5/26.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLPersonCenterSettingVC.h"
#import "VCManger.h"
#import "SDImageCache.h"
#import "LoginVC.h"
#import "CMLSettingDetailVC.h"
#import "CMLFeedBackVC.h"

#define PersonCenterSettingRowHeight                       80
#define PersonCenterSettingSectionHeight                   20
#define PersonCenterSettingRightMargin                     20
#define PersonCenterSettingLogoutBtnHeight                 72
#define PersonCenterSettingLogoutBtnWidth                  (self.view.frame.size.width)*0.8
#define PersonCenterSettingFooterViewHeight                (self.view.frame.size.height)*0.3
#define EditionLabelTopMargin                              1074

@interface CMLPersonCenterSettingVC ()<NavigationBarProtocol,NetWorkProtocol>

@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic,strong) NSMutableDictionary *dataDic;

@property (nonatomic,strong) UIButton *logoutBtn;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@end

@implementation CMLPersonCenterSettingVC

- (NSMutableDictionary *)dataDic{

    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
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
    
    [MobClick beginLogPageView:@"PageThreeOfPersonalSetting"];
    
}

- (void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WXShareSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WXShareError" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"closeShareView" object:nil];
    
    [MobClick endLogPageView:@"PageThreeOfPersonalSetting"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.delegate = self;
    self.navBar.titleContent = @"设置";
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.backgroundColor = [UIColor whiteColor];
    [self.navBar setLeftBarItem];
    /***************************************************/
    /********shareblock********/
    __weak typeof(self) weakSelf = self;
    
    self.baseShareContent = @"卡枚连是中国首个以独立自主精神为主题的专属女性VIP社区。";
    self.baseShareTitle = @"卡枚连";
    self.baseShareLink =[[DataManager lightData] readAppDownloadUrl];
    self.shareSuccessBlock = ^(){
    
        [weakSelf hiddenCurrentVCShareView];
    };
    
    self.sharesErrorBlock = ^(){
    
        [weakSelf hiddenCurrentVCShareView];
    };
    self.baseShareImage = [UIImage imageNamed:RecommendImg];
    [self loadViews];
    
}

- (void) loadViews{

    /*********/
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         CGRectGetMaxY(self.navBar.frame) ,
                                                                         WIDTH,
                                                                         HEIGHT - self.navBar.frame.size.height)];
    self.mainScrollView.backgroundColor = [UIColor CMLUserGrayColor];
    self.mainScrollView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.mainScrollView];
    
    NSArray *dataArray = @[@"清除缓存", @"给个好评", @"给我们些建议吧", @"商城规则", @"用户协议", @"知识产权保护说明", @"服务及隐私条款", @"关于我们", @"退出当前账号"];
    
    for (int i = 0; i < dataArray.count; i++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor CMLWhiteColor];
        if (i < 3) {
            view.frame = CGRectMake(0,
                                    PersonCenterSettingRowHeight*Proportion*i,
                                    WIDTH,
                                    PersonCenterSettingRowHeight*Proportion);
        }else{
        
            if (i < 7) {
                view.frame = CGRectMake(0,
                                        (PersonCenterSettingRowHeight*Proportion*3 + PersonCenterSettingSectionHeight*Proportion) + PersonCenterSettingRowHeight*Proportion*(i-3),
                                        WIDTH,
                                        PersonCenterSettingRowHeight*Proportion);
            }else{
                view.frame = CGRectMake(0,
                                        PersonCenterSettingRowHeight*Proportion*7 + PersonCenterSettingSectionHeight*Proportion,
                                        WIDTH,
                                        PersonCenterSettingRowHeight*Proportion);
            }
        
        }
        view.userInteractionEnabled = YES;
        [self.mainScrollView addSubview:view];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = dataArray[i];
        nameLabel.font = KSystemFontSize14;
        nameLabel.textColor = [UIColor CMLUserBlackColor];
        [nameLabel sizeToFit];
        nameLabel.frame = CGRectMake(PersonCenterSettingRightMargin*Proportion,
                                     view.frame.size.height/2.0 - nameLabel.frame.size.height/2.0,
                                     nameLabel.frame.size.width,
                                     nameLabel.frame.size.height);
        [view addSubview:nameLabel];
        
        if (i < 9) {
            UIImageView * enterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PersonalCenterUserEnterVCImg]];
            [enterImage sizeToFit];
            enterImage.frame = CGRectMake(WIDTH - enterImage.frame.size.width - PersonCenterSettingRightMargin*Proportion,
                                          view.frame.size.height/2.0 - enterImage.frame.size.height/2.0,
                                          enterImage.frame.size.width,
                                          enterImage.frame.size.height);
            [view addSubview:enterImage];
            
            if (i == 0) {
                UILabel *label = [[UILabel alloc] init];
                label.text = [NSString stringWithFormat:@"%luM",[[SDImageCache sharedImageCache] getSize]/(1024*1024)];
                label.font = KSystemFontSize14;
                label.textColor = [UIColor CMLPromptGrayColor];
                [label sizeToFit];
                label.frame = CGRectMake(WIDTH - label.frame.size.width - enterImage.frame.size.width - PersonCenterSettingRightMargin*Proportion,
                                         (view.frame.size.height - label.frame.size.height)/2.0,
                                         label.frame.size.width,
                                         label.frame.size.height);
                [view addSubview:label];
            }
        }
        
        if (i == 0 || i == 1 || i == 3 || i == 4 || i == 5 || i == 6 || i == 7) {
            CMLLine *line = [[CMLLine alloc] init];
            line.lineWidth = 0.5;
            line.lineLength = WIDTH - PersonCenterSettingRightMargin*Proportion*2;
            line.LineColor = [UIColor CMLPromptGrayColor];
            line.startingPoint = CGPointMake(PersonCenterSettingRightMargin*Proportion, view.frame.size.height-0.5);
            [view addSubview:line];
            
        }
        
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      WIDTH,
                                                                      PersonCenterSettingRowHeight*Proportion)];
        button.tag = i;
        [view addSubview:button];
        [button addTarget:self action:@selector(startOperate:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    UILabel *editionLabel = [[UILabel alloc] init];
    editionLabel.font = KSystemFontSize12;
    editionLabel.text = @"当前版本";
    editionLabel.textColor = [UIColor CMLUserBlackColor];
    [editionLabel sizeToFit];
    editionLabel.frame = CGRectMake(WIDTH/2.0 - editionLabel.frame.size.width/2.0,
                                    EditionLabelTopMargin*Proportion,
                                    editionLabel.frame.size.width,
                                    editionLabel.frame.size.height);
    [self.mainScrollView addSubview:editionLabel];
    
    UILabel *editionNum = [[UILabel alloc] init];
    editionNum.font = KSystemFontSize12;
    editionNum.textColor = [UIColor CMLUserBlackColor];
    editionNum.text = [NSString stringWithFormat:@"%@",[AppGroup appVersion]];
    [editionNum sizeToFit];
    editionNum.frame = CGRectMake(WIDTH/2.0 - editionNum.frame.size.width/2.0,
                                  CGRectGetMaxY(editionLabel.frame) + 10*Proportion,
                                  editionNum.frame.size.width,
                                  editionNum.frame.size.height);
    [self.mainScrollView addSubview:editionNum];
    
}

- (void) startOperate:(UIButton *) button{

    if (button.tag == 0) {
        
        /**清除缓存*/
        [self startIndicatorLoading];
        
        [[SDImageCache sharedImageCache] clearMemory];
        
        __weak typeof(self) weakSelf = self;
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
            [weakSelf stopIndicatorLoading];
            [weakSelf showSuccessTemporaryMes:@"缓存已清除"];
            [weakSelf viewDidLoad];
            
        }];
        
    }else if (button.tag == 1){
    
        /**进入苹果商店*/
        NSString *path = @"https://appsto.re/cn/T5kWbb.i";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];
        
    }else if (button.tag == 2){
        
        CMLFeedBackVC *VC= [[CMLFeedBackVC alloc] init];
        [[VCManger mainVC] pushVC:VC animate:YES];
        
        
    }else if (button.tag == 3){
        
        CMLSettingDetailVC *vc = [[CMLSettingDetailVC alloc] initWithTitle:@"商城规则"];
        [[VCManger mainVC] pushVC:vc animate:YES];
    
    }else if (button.tag == 4){
        
        CMLSettingDetailVC *vc = [[CMLSettingDetailVC alloc] initWithTitle:@"用户协议"];
        [[VCManger mainVC] pushVC:vc animate:YES];
    
    }else if (button.tag == 5){
    
        CMLSettingDetailVC *vc = [[CMLSettingDetailVC alloc] initWithTitle:@"关于产权保护说明"];
        [[VCManger mainVC] pushVC:vc animate:YES];
    
    }else if (button.tag == 6){
    
        CMLSettingDetailVC *vc = [[CMLSettingDetailVC alloc] initWithTitle:@"服务及隐私条款"];
        [[VCManger mainVC] pushVC:vc animate:YES];
    
    }else if (button.tag == 7){
        
        CMLSettingDetailVC *vc = [[CMLSettingDetailVC alloc] initWithTitle:@"关于我们"];
        [[VCManger mainVC] pushVC:vc animate:YES];
    
    }else if (button.tag == 8){
        
        [self setLogoutRequest];
    }

}

#pragma mark - setLogoutRequest
- (void) setLogoutRequest{

    [self startIndicatorLoading];
    self.logoutBtn.userInteractionEnabled = NO;
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:[AppGroup getCurrentDate]] forKey:@"reqTime"];
    NSNumber *userID = [[DataManager lightData] readUserID];
    [paraDic setObject:[NSString stringWithFormat:@"%@",userID] forKey:@"userId"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[[NSString stringWithFormat:@"%@",userID],skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:Logout paraDic:paraDic delegate:delegate];
    
}

#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    [self stopIndicatorLoading];
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    if ([obj.retCode intValue] == 0 && obj) {
        
        [self deleteUserInfo];
        
        LoginVC *vc = [[LoginVC alloc] init];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }else if ([obj.retCode intValue] == 100101){
        
        [self stopLoading];
        [self showReloadView];
        
    }else{
        [self showAlterViewWithText:@"登出失败"];
    }
    self.logoutBtn.userInteractionEnabled = YES;
    
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    [self stopLoading];
    [self stopIndicatorLoading];
    [self showAlterViewWithText:@"您的网络不给力奥～"];
}


#pragma mark - NavigationBarProtocol
- (void) didSelectedLeftBarItem{
   [[VCManger mainVC] dismissCurrentVCWithAnimate:YES];
}

- (void) deleteUserInfo{

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
    [[DataManager lightData] removeCanPushState];
    [[DataManager lightData] saveIsLoginOfPush:[NSNumber numberWithInt:0]];
    [[DataManager lightData] saveIsLogin:[NSNumber numberWithInt:0]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OffTimer" object:nil];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self hiddenCurrentVCShareView];
}

@end
