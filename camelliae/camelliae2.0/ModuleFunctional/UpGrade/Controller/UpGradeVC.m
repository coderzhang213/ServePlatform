//
//  UpGradeVC.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/9.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "UpGradeVC.h"
#import "VCManger.h"
#import "ShowNoUpGradeView.h"
#import "Privilege.h"
#import "DetailPrivilegeObj.h"
#import "ShowVIPGradeMessageView.h"
#import "ShowBuyTypeView.h"
#import "ShowOffLinePayType.h"
#import "WechatPreCallInfo.h"
#import "CMLRSAModule.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MoreMesView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "NSString+CMLExspand.h"
#import "CMLRSAModule.h"
#import "UpGradeParaDicProduce.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"
#import "CMLLine.h"
#import "AppDelegate.h"
#import "WebViewLinkVC.h"
#import "ShowBlackPigmentMemberView.h"
#import "ShowMemberEquityView.h"
#import "ShowBlackPigmentMembersPickView.h"
#import "ShowAgreementView.h"
#import "MemberEquityDetailView.h"
#import "MemberAppointmentView.h"
#import "CMLUpGradeImageBgView.h"
#import "CMLPCMemberCardModel.h"

#define EnTitleFontSize    ([UIScreen mainScreen].bounds.size.width*2) > 750 ? 12:10.9


@interface UpGradeVC ()<NavigationBarProtocol, ShowNoUpGradeViewDelegate, NetWorkProtocol, ShowVIPGradeMessageDelegate, ShowBuyTypeDelegate, ShowOffLinePayTypeDelegate, ShowAgreementViewDelegate, ShowMemberEquityViewDelegate, MemberEquityDetailViewDelegate, UIScrollViewDelegate, WXApiDelegate, MemberAppointmentViewDelegate, CMLUpGradeImageBgViewDelegate>

@property (nonatomic,strong) UIView *currentShadow;

@property (nonatomic,assign) int currentType;

@property (nonatomic,assign) int payType;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) NSMutableArray *currentImages;

@property (nonatomic,strong) NSMutableArray *currentTitles;

@property (nonatomic,copy) NSString *detailPrivilegeLink;

@property (nonatomic,strong) NSNumber *projectId;

@property (nonatomic, copy) NSString *tele;

@property (nonatomic,strong) NSNumber *tempPrice;

@property (nonatomic,strong) NSNumber *points;

@property (nonatomic,copy) NSString *linkProjectName;

@property (nonatomic,copy) NSString *orderId;

/***支付信息**/
@property (nonatomic,copy) NSString *appid;

@property (nonatomic,copy) NSString *noncestr;

@property (nonatomic,copy) NSString *package;

@property (nonatomic,strong) id partnerid;

@property (nonatomic,copy) NSString *prepayid;

@property (nonatomic,copy) NSString *sign;

@property (nonatomic,assign) int timestamp;

@property (nonatomic,strong) BaseResultObj *obj;

/**键盘显示*/
@property (nonatomic,assign) BOOL isShowKeyBoard;

@property (nonatomic,strong) UIScrollView *mainScroll;

@property (nonatomic,strong) UIScrollView *titleScroll;

@property (nonatomic,strong) UIView *imageBgView;

@property (nonatomic,strong) UIImageView *firstImage;

@property (nonatomic,strong) UIImageView *secondImage;

@property (nonatomic,strong) UIImageView *thirdImage;

@property (nonatomic,strong) UIImageView *fourthImage;

@property (nonatomic,strong) UIImageView *fifthImage;

@property (nonatomic,strong) UIImageView *promImage;

@property (nonatomic,strong) NSMutableArray *btnArray;

@property (nonatomic,strong) UIView *mesPromBgView;

@property (nonatomic,strong) UIButton *buyPromBtn;

@property (nonatomic, strong) ShowMemberEquityView *equityBgView;

@property (nonatomic, strong) ShowBlackPigmentMembersPickView *fristBPMember;

@property (nonatomic, strong) ShowBlackPigmentMembersPickView *secondBPMember;

@property (nonatomic, strong) ShowBlackPigmentMembersPickView *thirdBPMember;

/*协议详情*/
@property (nonatomic, strong) ShowAgreementView *fristAgreementView;

@property (nonatomic, strong) MemberEquityDetailView *detailView;

@property (nonatomic, strong) MemberAppointmentView *memberAppointmentView;
/*会员权益“卡片”*/
@property (nonatomic, strong) CMLUpGradeImageBgView *upGradeImageBgView;

@property (nonatomic, copy) NSString *purpleLevel;

@property (nonatomic, copy) NSString *distributionLevel;

@property (nonatomic, copy) NSString *memberLevelId;

@property (nonatomic, copy) NSString *roleId;

@property (nonatomic, assign) NSInteger isBuySucceed;

@property (nonatomic, assign) BOOL isCanHidden;

@property (nonatomic, strong) NSMutableArray *tagsArray;

@property (nonatomic, strong) NSMutableArray *roleArray;

@end

@implementation UpGradeVC

- (NSMutableArray *)btnArray{
    
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    
    return _btnArray;
}

- (NSMutableArray *)currentImages{

    if (!_currentImages) {
        _currentImages = [NSMutableArray array];
    }
    return _currentImages;
}

- (NSMutableArray *)currentTitles{

    if (!_currentTitles) {
        _currentTitles = [NSMutableArray array];
    }
    return _currentTitles;
}

- (NSMutableArray *)roleArray {
    if (!_roleArray) {
        _roleArray = [NSMutableArray array];
    }
    return _roleArray;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
     [UIApplication sharedApplication].statusBarHidden = YES;
    //微信支付成功
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(GradeWeixinPaySuccess)
     
                                                 name:@"WXPaySuccess" object:nil];
    //支付宝支付
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(GradeZFBPaySuccess)
                                                 name:@"successPayOfZFB"
                                               object:nil];
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"WXPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"WXPayError" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"successPayOfZFB" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    

}

- (void) GradeWeixinPaySuccess{

    [self setConfirmAppointmentRequest];
}

- (void) GradeZFBPaySuccess{

    [self setConfirmAppointmentRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*会员*/
    self.navBar.delegate = self;
    self.navBar.backgroundColor = [UIColor CMLNewBlackColor];
    [self.navBar setWhiteLeftBarItem];
    self.navBar.bottomLine.hidden = YES;
    self.navBar.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor CMLNewBlackColor];
    self.view.backgroundColor = [UIColor CMLNewBlackColor];
    [self loadMessageOfVC];
    self.isBuySucceed = 0;
    self.isCanHidden = YES;

    __weak typeof(self) weakSelf = self;
    self.refreshViewController = ^(){
    
        [weakSelf hideNetErrorTipOfMainVC];
        [weakSelf loadMessageOfVC];
    };
}

- (void) loadMessageOfVC{
    
    [self loadViews];
}

- (void) loadViews{
    
    /*弧形斜边背景*/
    UIImageView *topBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLVIPCenterBg2Img]];
    topBgView.contentMode = UIViewContentModeScaleAspectFill;
    topBgView.clipsToBounds = YES;
    topBgView.userInteractionEnabled = YES;
    topBgView.backgroundColor = [UIColor clearColor];
    [topBgView sizeToFit];
    topBgView.frame = CGRectMake(-70*Proportion,
                                 0,
                                 WIDTH,
                                 topBgView.frame.size.height);
    [self.contentView addSubview:topBgView];
    [self.contentView bringSubviewToFront:self.navBar];
    
    /*会员中心 Member Center图片*/
    UIImageView *nameImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:UpGradeTitleImg]];
    nameImg.contentMode = UIViewContentModeScaleAspectFill;
    nameImg.clipsToBounds = YES;
    nameImg.backgroundColor = [UIColor clearColor];
    [nameImg sizeToFit];
    nameImg.frame = CGRectMake(WIDTH/2.0 - nameImg.frame.size.width/2.0,
                               107*Proportion,
                               nameImg.frame.size.width,
                               nameImg.frame.size.height);
    [self.contentView addSubview:nameImg];
    
    self.titleScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                      CGRectGetMaxY(nameImg.frame) + 27*Proportion,
                                                                      WIDTH,
                                                                      52*Proportion)];
    self.titleScroll.backgroundColor = [UIColor clearColor];
    self.titleScroll.showsHorizontalScrollIndicator = NO;
    self.titleScroll.showsVerticalScrollIndicator = NO;
    self.titleScroll.contentSize = CGSizeMake(0, 0);
    self.titleScroll.userInteractionEnabled = NO;
    [self.contentView addSubview:self.titleScroll];
    
    UILabel *testLab = [[UILabel alloc] init];
    testLab.text = @"粉色会员";
    testLab.font = KSystemFontSize14;
    [testLab sizeToFit];
    
    CGFloat space1 = (WIDTH - testLab.frame.size.width*2)/3.0;
    CGFloat space2 = (WIDTH - 30*Proportion*2 - testLab.frame.size.width*3)/2.0;

    CGFloat currentLeft = space1;
    for (int i = 0 ; i < self.roleObj.retData.dataList.count; i++) {
        CMLPCMemberCardModel *cardModel = [CMLPCMemberCardModel getBaseObjFrom:self.roleObj.retData.dataList[i]];
        UILabel *titleLab = [[UILabel alloc] init];
        [titleLab sizeToFit];
        titleLab.textColor = [UIColor CMLWhiteColor];
        titleLab.backgroundColor = [UIColor clearColor];
        titleLab.text = cardModel.group_name;
        titleLab.userInteractionEnabled = YES;
        titleLab.font = KSystemFontSize14;
        [titleLab sizeToFit];
        
        titleLab.frame = CGRectMake(currentLeft,
                                    0,
                                    titleLab.frame.size.width,
                                    titleLab.frame.size.height);
        if (i < 1) {
            currentLeft = (CGRectGetMaxX(titleLab.frame) + space1);
            self.promImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:UserUpGradePromImg]];
            self.promImage.contentMode = UIViewContentModeScaleAspectFill;
            self.promImage.clipsToBounds = YES;
            [self.promImage sizeToFit];
            self.promImage.frame = CGRectMake(titleLab.center.x - self.promImage.frame.size.width/2.0,
                                              CGRectGetMaxY(titleLab.frame) + 12*Proportion,
                                              self.promImage.frame.size.width,
                                              self.promImage.frame.size.height);
            [self.titleScroll addSubview:self.promImage];
        }else if(i >= 1 && i < self.roleObj.retData.dataList.count - 1){
            currentLeft = (CGRectGetMaxX(titleLab.frame) + space2);
        }else{
            currentLeft = (CGRectGetMaxX(titleLab.frame) + space1);
        }
        [self.titleScroll addSubview:titleLab];
        
        UIButton *currentBtn = [[UIButton alloc] initWithFrame:titleLab.bounds];
        currentBtn.backgroundColor = [UIColor clearColor];
        currentBtn.tag = i;
        [titleLab addSubview:currentBtn];
        [currentBtn addTarget:self action:@selector(selectCurrentLvl:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnArray addObject:currentBtn];
        
        if (i == self.roleObj.retData.dataList.count - 1) {
            self.titleScroll.contentSize = CGSizeMake(CGRectGetMaxX(titleLab.frame) + space1, self.titleScroll.frame.size.height);
        }
    }

    self.mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                     CGRectGetMaxY(nameImg.frame) + 79*Proportion ,
                                                                     WIDTH,
                                                                     HEIGHT - (CGRectGetMaxY(nameImg.frame) + 91*Proportion))];
    self.mainScroll.pagingEnabled = YES;
    self.mainScroll.backgroundColor = [UIColor CMLNewBlackColor];
    self.mainScroll.delegate = self;
    self.mainScroll.contentSize = CGSizeMake(WIDTH*self.roleObj.retData.dataList.count,
                                             HEIGHT - (CGRectGetMaxY(nameImg.frame) + 91*Proportion + 12*Proportion));
    [self.contentView addSubview:self.mainScroll];
    
    /*会员中心：会员权益等-新*/
    self.upGradeImageBgView = [[CMLUpGradeImageBgView alloc] initWithFrame:CGRectMake(0,
                                                                                      0,
                                                                                      WIDTH*self.roleObj.retData.dataList.count,
                                                                                      HEIGHT - (CGRectGetMaxY(nameImg.frame) + 91*Proportion + 12*Proportion))
                                                               withRoleObj:self.roleObj];
    self.upGradeImageBgView.delegate = self;
    self.upGradeImageBgView.backgroundColor = [UIColor clearColor];
    self.upGradeImageBgView.userInteractionEnabled = YES;
    [self.mainScroll addSubview:self.upGradeImageBgView];
    
    self.currentShadow = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  WIDTH,
                                                                  HEIGHT)];
    self.currentShadow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [self.contentView addSubview:self.currentShadow];
    [self.contentView bringSubviewToFront:self.currentShadow];
    self.currentShadow.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    if ([[DataManager lightData] readRoleId]) {
        
        int roleNum = [[[DataManager lightData] readRoleId] intValue];
        for (int i = 0 ; i < self.roleObj.retData.dataList.count; i++) {
            CMLPCMemberCardModel *cardModel = [CMLPCMemberCardModel getBaseObjFrom:self.roleObj.retData.dataList[i]];
            /*从提现升级提示跳转过来*/
            if (self.isUpgrade) {
                /*第i个是黛色*/
                if ([cardModel.role_id intValue] == 5) {
                    self.mainScroll.contentOffset = CGPointMake(WIDTH*i, 0);
                    UIButton *button = self.btnArray[i];
                    self.promImage.center = CGPointMake(button.superview.center.x, self.promImage.center.y);
                    [UIView animateWithDuration:0.3 animations:^{
                        weakSelf.upGradeImageBgView.frame = CGRectMake((WIDTH - 601 * Proportion - 20 * Proportion) * i,
                                                                       weakSelf.upGradeImageBgView.origin.y,
                                                                       weakSelf.upGradeImageBgView.size.width,
                                                                       weakSelf.upGradeImageBgView.size.height);
                        weakSelf.titleScroll.contentOffset = CGPointMake(button.superview.center.x - weakSelf.titleScroll.frame.size.width/2.0, 0);
                    }];

                    UIButton *secondButton = [[UIButton alloc] init];
                    secondButton.tag = 5;
                    [self showAgreementViewWith:secondButton];
                    
                }
            }else {
                if (roleNum == [cardModel.role_id intValue]) {
                    self.mainScroll.contentOffset = CGPointMake(WIDTH*i, 0);
                    [UIView animateWithDuration:0.3 animations:^{
                        
                        weakSelf.upGradeImageBgView.frame = CGRectMake((WIDTH - 601 * Proportion - 20*Proportion)*i,
                                                                       weakSelf.upGradeImageBgView.frame.origin.y,
                                                                       weakSelf.upGradeImageBgView.frame.size.width,
                                                                       weakSelf.upGradeImageBgView.frame.size.height);
                    }];
                    
                    UIButton *btn = self.btnArray[i];
                    self.promImage.center = CGPointMake(btn.superview.center.x, self.promImage.center.y);
                    [UIView animateWithDuration:0.3f animations:^{
                        weakSelf.titleScroll.contentOffset = CGPointMake(btn.superview.center.x - weakSelf.titleScroll.frame.size.width/2.0, 0);
                    }];
                }
            }
        }
    }
}

- (void)didSelectedLeftBarItem {
    [[VCManger mainVC] popToRootVCWithAnimated];
}

#pragma mark - 购买黛色成功
- (void) showBuyPigmentSuccess{
    
    [self.currentShadow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.isCanHidden = NO;
    self.currentShadow.hidden = NO;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:UpGradeBuyPigmentSuccessImg]];
    if ([self.roleId intValue] == 2) {
        imageView.image = [UIImage imageNamed:UpGradeBuyPinkSilverSuccessImg];
    }else if ([self.roleId intValue] == 3) {
        imageView.image = [UIImage imageNamed:UpGradeBuyPinkGoldSuccessImg];
    }
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView sizeToFit];
    imageView.frame = CGRectMake(WIDTH/2.0 - 601*Proportion/2.0,
                                 self.mainScroll.frame.origin.y + 23*Proportion ,
                                 601*Proportion,
                                 imageView.frame.size.height/imageView.frame.size.width*601*Proportion);
    [self.currentShadow addSubview:imageView];

    /*成功后刷新黛色页面*/
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestUserData];
    });

    self.isBuySucceed = 1;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", (long)self.isBuySucceed] forKey:@"isBuySucceed"];

}

#pragma mark - 购买金色成功
- (void) showBuyGoldSuccess{
    
    [self.currentShadow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.isCanHidden = NO;
    self.currentShadow.hidden = NO;
   
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:UpGradeBuyGoldSuccessImg]];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView sizeToFit];
    imageView.frame = CGRectMake(WIDTH/2.0 - 601*Proportion/2.0,
                                 self.mainScroll.frame.origin.y + 23*Proportion,
                                 601*Proportion,
                                 imageView.frame.size.height/imageView.frame.size.width*601*Proportion);
    [self.currentShadow addSubview:imageView];
   
    /*重新载入会员权益页面*/
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestUserData];
    });
    
}

#pragma mark - 展示价格及等级
- (void) showCurrentVIPPrice:(NSNumber *) lvl{

    [self.currentShadow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.currentShadow.hidden = NO;

    /*购买-特权*/
    ShowVIPGradeMessageView *view = [[ShowVIPGradeMessageView alloc] initWithLvl:[lvl intValue]
                                                                        andPrice:self.tempPrice
                                                                       andPoints:self.points
                                                                       andBgView:self.currentShadow
                                                                        roleName:self.linkProjectName];
    view.delegate = self;
    view.alpha = 0;
    [self.currentShadow addSubview:view];
    [UIView animateWithDuration:0.4 animations:^{

        view.alpha = 1;
    }];

}

- (void) showPayTypeView{
    
    [self.currentShadow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.currentShadow.hidden = NO;
    
    ShowBuyTypeView *view = [[ShowBuyTypeView alloc] initWithBgView:self.currentShadow];
    view.delegate = self;
    view.alpha = 0;
    [self.currentShadow addSubview:view];
    
    [UIView animateWithDuration:0.4 animations:^{
        view.alpha = 1;
    }];
}

- (void) showOfflinePayType:(int) tag{

    [self.currentShadow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.currentShadow.hidden = NO;
    
    /**/
    ShowOffLinePayType *view = [[ShowOffLinePayType alloc] initWithTag:self.currentType
                                                             andBgView:self.currentShadow
                                                               andTele:self.tele];
    view.delegate = self;
    view.alpha = 0;
    [self.currentShadow addSubview:view];

    [UIView animateWithDuration:0.4 animations:^{
        view.alpha = 1;
    }];
}

/*触摸事件*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    /*self.fristAgreementView*/
    CGPoint point = [[touches anyObject] locationInView:self.view];
    point = [self.fristAgreementView.layer convertPoint:point fromLayer:self.view.layer];
    if ([self.fristAgreementView.layer containsPoint:point]) {
        return;
    }
    
    if (self.isCanHidden) {
        if (!self.isShowKeyBoard) {
            
            if (self.memberAppointmentView.hidden == NO) {
                [self.memberAppointmentView appointmentTextFieldResignFirstResponder];
            }else {
                self.currentShadow.hidden = YES;
            }
            self.currentShadow.hidden = YES;
        }else{
            self.isShowKeyBoard = NO;
        }
    }
}

#pragma mark - ShowNoUpGradeViewDelegate
- (void) dissmissCurrentUpGradeView{

    [self hiddenShadow];
}

#pragma mark - ShowVIPGradeMessageDelegate
- (void) cancelBuyState{

    [self hiddenShadow];
}

- (void) entreBuyState:(int)tag{
    
    [self setCreateAppointmentRequest];
}

#pragma mark - ShowBuyTypeDelegate
- (void) selectBuyType:(int) tag{

    self.payType = tag;
    if (tag == 1) {
        [self startPayProcess];
    }else if (tag == 2){
        [self startzhifubaoPayProcess];
    }
}

- (void) cancelPay{
    [self hiddenShadow];
}

#pragma mark - ShowOffLinePayTypeDelegate

- (void) cancelCallUser{

    [self hiddenShadow];
}

- (void ) callUser{

    [self hiddenShadow];
    
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.tele];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void) hiddenShadow{
    
    self.currentShadow.hidden = YES;
}

#pragma mark - 进入微信支付流程
- (void) startPayProcess{
    
    if ([WXApi isWXAppInstalled]) {
        
        [self getWeiXinMesRequest];
    }else{
        [self showFailTemporaryMes:@"没有检测到您的支付软件"];
    }
    
}

#pragma mark - 进入支付宝
- (void) startzhifubaoPayProcess{
    
    NSURL * myURL_APP_A = [NSURL URLWithString:@"alipay:"];
    if (![[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
        [self showFailTemporaryMes:@"没有检测到您的支付软件"];
    }else{
        [self getZFBMesRequest];
    }
}

- (void)setSpecialPrivilegeRequest {
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.roleId forKey:@"roleId"];
    if (self.memberLevelId.length > 0) {
        [paraDic setObject:self.memberLevelId forKey:@"memberLevelId"];
    }
    if (self.distributionLevel.length > 0) {
        [paraDic setObject:self.distributionLevel forKey:@"distributionLevel"];
    }
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    
    [NetWorkTask getRequestWithApiName:SpecialNewPrivilege param:paraDic delegate:delegate];
    self.currentApiName = SpecialNewPrivilege;
    
    [self startIndicatorLoading];
}

- (void)getMemberCenterEquity {
    
    /**request*/
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.projectId forKey:@"objId"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.projectId,reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask getRequestWithApiName:ProjectInfo param:paraDic delegate:delegate];
    self.currentApiName = ProjectInfo;
    [self startIndicatorLoading];
    
}

- (void) getProjectInfo{
    
    /**request*/
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.projectId forKey:@"objId"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.projectId,reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask getRequestWithApiName:ProjectInfo param:paraDic delegate:delegate];
    self.currentApiName = ProjectInfo;
    [self startIndicatorLoading];
    
}

- (void) setCreateAppointmentRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    PackDetailInfoObj *tempObj = [PackDetailInfoObj getBaseObjFrom:[self.obj.retData.packageInfo.dataList lastObject]];
    
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"clientId"];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [paraDic setObject:[NSNumber numberWithInt:[appDelegate.pid intValue]] forKey:@"pid"];
    appDelegate.pid = @"0";
    NSNumber *currentNum;
    if (tempObj.currentID) {
        
        for (int i = 0; i < self.obj.retData.packageInfo.dataList.count; i++) {
            
            PackDetailInfoObj *costObj = [PackDetailInfoObj getBaseObjFrom:self.obj.retData.packageInfo.dataList[i]];
            
            if ([tempObj.currentID intValue] == [costObj.currentID intValue]) {
                [paraDic setObject:[NSNumber numberWithInt:[costObj.totalAmount intValue]*100] forKey:@"payAmtE2"];
                [paraDic setObject:self.obj.retData.currentID forKey:@"objId"];
                [paraDic setObject:costObj.currentID forKey:@"packageId"];
                currentNum = costObj.currentID;
                break;
            }
            
        }
    }else{
        PackDetailInfoObj *costObj = [PackDetailInfoObj getBaseObjFrom:[self.obj.retData.packageInfo.dataList firstObject]];
        
        [paraDic setObject:[NSNumber numberWithInt:[costObj.totalAmount intValue]*100] forKey:@"payAmtE2"];
        [paraDic setObject:self.obj.retData.currentID forKey:@"objId"];
        [paraDic setObject:costObj.currentID forKey:@"packageId"];
        
        currentNum = costObj.currentID;
    }
    
    
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"goodsNum"];
    
    [paraDic setObject:[NSNumber numberWithInt:3] forKey:@"parentType"];
    
    int reqTime = [AppGroup getCurrentDate];
    
    [paraDic setObject:[NSNumber numberWithInt:reqTime] forKey:@"reqTime"];
    [paraDic setObject:@"" forKey:@"consigneeName"];
    [paraDic setObject:[[DataManager lightData] readPhone] forKey:@"consigneePhone"];
    [paraDic setObject:@"" forKey:@"consigneeAddress"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    
    NSString *hashToken;
    
    hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:1],
                                                 [paraDic valueForKey:@"packageId"],
                                                 [NSNumber numberWithInt:3],
                                                 self.obj.retData.currentID,
                                                 [[DataManager lightData] readSkey],
                                                 [NSNumber numberWithInt:reqTime]]];
    
    
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:OrderCreate paraDic:paraDic delegate:delegate];
    
    self.currentApiName = OrderCreate;
    
}

- (void) getWeiXinMesRequest{
    if (self.orderId) {
        NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
        delegate.delegate = self;
        
        NSMutableDictionary *paraDic = [UpGradeParaDicProduce getWXMesWithOrderID:self.orderId];
        [NetWorkTask postResquestWithApiName:GoodsWXGetMessage paraDic:paraDic delegate:delegate];
        self.currentApiName = GoodsWXGetMessage;
        
        [self startIndicatorLoading];
    }
}

- (void) getZFBMesRequest{
    if (self.orderId) {
        NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
        delegate.delegate = self;
        
        NSMutableDictionary *paraDic = [UpGradeParaDicProduce getZFBMesWithOrderID:self.orderId];
        [NetWorkTask postResquestWithApiName:GoodsZFBGetMessage paraDic:paraDic delegate:delegate];
        self.currentApiName = GoodsZFBGetMessage;
        
        [self startIndicatorLoading];
    }
}

- (void) setConfirmAppointmentRequest{
    
    if (self.orderId) {
        NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
        delegate.delegate = self;
        
        NSMutableDictionary *paraDic = [UpGradeParaDicProduce getConfirmAppointmentWithOrderID:self.orderId];
        [NetWorkTask postResquestWithApiName:GoodsOrderConfirm paraDic:paraDic delegate:delegate];
        self.currentApiName = GoodsOrderConfirm;
    }
    
}


- (void) enterWXAPP{
    
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = self.partnerid;
    req.prepayId            = self.prepayid;
    req.nonceStr            = self.noncestr;
    req.timeStamp           = self.timestamp;
    req.package             = self.package;
    req.sign                = [CMLRSAModule decryptString:self.sign publicKey:PUBKEY];
    
    [WXApi sendReq:req];
    
}

- (void) weixinPaySuccess{
    
    [self setConfirmAppointmentRequest];
    [self startIndicatorLoading];
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    if ([self.currentApiName isEqualToString:SpecialNewPrivilege]){/*会员中心黛色 金色会员*/
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0 && obj) {
        
            self.detailPrivilegeLink = obj.retData.projectDetailLink;
            self.projectId = obj.retData.linkProjectId;
            self.linkProjectName = obj.retData.linkProjectName;
            
            [self.currentTitles removeAllObjects];
            [self.currentImages removeAllObjects];
            
            for (int i = 0; i < obj.retData.basic.dataList.count; i++) {
                
                DetailPrivilegeObj *tempObj = [DetailPrivilegeObj getBaseObjFrom:obj.retData.basic.dataList[i]];
                [self.currentTitles addObject:tempObj.title];
                [self.currentImages addObject:tempObj.icon];
                
            }
            
            [self getProjectInfo];
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            [self showFailTemporaryMes:obj.retMsg];
            [self stopLoading];
        }
        
        /*（服务详情）*/
    }else if ([self.currentApiName isEqualToString:ProjectInfo]){
    
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        self.obj = obj;
        
        if ([obj.retCode intValue] == 0 && obj) {
            
            PackDetailInfoObj *costObj = [PackDetailInfoObj getBaseObjFrom:[self.obj.retData.packageInfo.dataList firstObject]];
            
            self.tempPrice = costObj.totalAmount;
            self.points = obj.retData.awardPoints;
            self.tele = obj.retData.projectContact;
            
            /*购买-特权*/
            [self showCurrentVIPPrice:[NSNumber numberWithString:self.roleId]];
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            [self showFailTemporaryMes:obj.retMsg];
            [self stopLoading];
        }
    }else if ([self.currentApiName isEqualToString:OrderCreate]){
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0 && obj) {
            
                self.orderId = obj.retData.orderId;
                [self showPayTypeView];
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{

            [self showFailTemporaryMes:obj.retMsg];
        }
        
        [self stopIndicatorLoading];
        
    }else if ([self.currentApiName isEqualToString:GoodsOrderConfirm]){
 
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if (([obj.retCode intValue] == 200503 || [obj.retCode intValue] == 0) && obj) {
            [self hiddenShadow];
            self.orderId = nil;
//            [self.delegate refreshCurrentUserMessage];
            if ([self.roleId intValue] == 7) {
                [self showBuyGoldSuccess];
            }else{
                [self showBuyPigmentSuccess];
            }
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopIndicatorLoading];
            [self showReloadView];
            
        }else{
            
            [self showFailTemporaryMes:obj.retMsg];
            
        }
        [self stopIndicatorLoading];
        
    }else if ([self.currentApiName isEqualToString:GoodsWXGetMessage]){
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            /**微信支付所需信息*/
            self.appid = obj.retData.appid;
            self.noncestr = obj.retData.noncestr;
            self.package = obj.retData.package;
            self.partnerid = obj.retData.partnerid;
            self.prepayid = obj.retData.prepayid;
            self.sign = obj.retData.sign;
            self.timestamp = [obj.retData.timestamp intValue];
            /**************/
            /**进入微信进行支付*/
            [self enterWXAPP];
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            [self showFailTemporaryMes:obj.retMsg];
        }
        [self stopIndicatorLoading];
        
    }else if ([self.currentApiName isEqualToString:GoodsZFBGetMessage]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            NSString *sign1 =[CMLRSAModule decryptString:obj.retData.alipaySignToken  publicKey:PUBKEY];
            if ([[obj.retData.alipaySign md5] isEqualToString:sign1]) {
                [[AlipaySDK defaultService] payOrder:obj.retData.alipaySign fromScheme:@"alipaySDKCML" callback:^(NSDictionary *resultDic) {
                    
                }];
            }
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            [self showFailTemporaryMes:obj.retMsg];
        }
        [self stopIndicatorLoading];
    }else {
        /*NewMemberUser*/
        BaseResultObj *resObj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([resObj.retCode intValue] == 0 && resObj) {
            self.obj = resObj;
            LoginUserObj *userInfo = resObj.retData.user;
            
            [[DataManager lightData] saveSignStatus:userInfo.signStatus];
            [[DataManager lightData] saveUser:self.obj];
            [self setPushTag];/*升级成功后重新设置推送tags*/
            [self viewDidLoad];
            
        }else if ([resObj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{

        }
        
    }
    [self stopIndicatorLoading];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self hiddenShadow];
    [self stopLoading];
    [self stopIndicatorLoading];
    [self showFailTemporaryMes:@"网络连接失败"];
    [self showNetErrorTipOfNormalVC];
    
}

#pragma mark -  keyboardWasShown
- (void) keyboardWasShown:(NSNotification*) noti{
    
    self.isShowKeyBoard = YES;
}


#pragma mark - keyboardWillBeHidden
- (void) keyboardWillBeHidden{
    

    self.isShowKeyBoard = NO;

}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    /*新*/
    __weak typeof(self) weakSelf = self;
    if (self.mainScroll.contentOffset.x < WIDTH/2.0) {
        if (self.upGradeImageBgView.frame.origin.x != 0) {
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.upGradeImageBgView.frame = CGRectMake(0,
                                                               weakSelf.upGradeImageBgView.frame.origin.y,
                                                               weakSelf.upGradeImageBgView.frame.size.width,
                                                               weakSelf.upGradeImageBgView.frame.size.height);
            }];
        }
    }
    
    for (int i = 0; i < self.roleObj.retData.dataList.count; i++) {

        if (self.mainScroll.contentOffset.x >= (WIDTH/2.0 + WIDTH * i) && self.mainScroll.contentOffset.x < (WIDTH/2.0 + WIDTH * (i + 1))) {
            if (self.upGradeImageBgView.frame.origin.x != (WIDTH - 601 * Proportion - 20 * Proportion) * (i + 1)) {
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.upGradeImageBgView.frame = CGRectMake((WIDTH - 601 * Proportion - 20 * Proportion) * (i + 1),
                                                                   weakSelf.upGradeImageBgView.origin.y,
                                                                   weakSelf.upGradeImageBgView.size.width,
                                                                   weakSelf.upGradeImageBgView.size.height);
                }];
            }
        }
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    /*新*/
    __weak typeof(self) weakSelf = self;
    if (self.mainScroll.contentOffset.x < WIDTH/2.0) {
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.upGradeImageBgView.frame = CGRectMake(0,
                                                           weakSelf.upGradeImageBgView.frame.origin.y,
                                                           weakSelf.upGradeImageBgView.frame.size.width,
                                                           weakSelf.upGradeImageBgView.frame.size.height);
        }];
        UIButton *button = self.btnArray[0];
        self.promImage.center = CGPointMake(button.superview.center.x, self.promImage.center.y);
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.titleScroll.contentOffset = CGPointMake(0, 0);
        }];
    }
    for (int i = 0; i < self.roleObj.retData.dataList.count; i++) {
        
        if (self.mainScroll.contentOffset.x >= (WIDTH/2.0 + WIDTH * i) && self.mainScroll.contentOffset.x < (WIDTH/2.0 + WIDTH * (i + 1))) {
            if (self.upGradeImageBgView.frame.origin.x != (WIDTH - 601 * Proportion - 20 * Proportion) * (i + 1)) {
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.upGradeImageBgView.frame = CGRectMake((WIDTH - 601 * Proportion - 20 * Proportion) * (i + 1),
                                                                   weakSelf.upGradeImageBgView.origin.y,
                                                                   weakSelf.upGradeImageBgView.size.width,
                                                                   weakSelf.upGradeImageBgView.size.height);
                }];
            }
            UIButton *button = self.btnArray[i + 1];
            self.promImage.center = CGPointMake(button.superview.center.x, self.promImage.center.y);
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.titleScroll.contentOffset = CGPointMake(button.superview.center.x - weakSelf.titleScroll.frame.size.width/2.0, 0);
            }];
        }
    }
}


- (void)selectCurrentLvl:(UIButton *)btn {
    
    __weak typeof(self) weakSelf = self;
   
    /*新*/
    if (btn.tag == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.titleScroll.contentOffset = CGPointMake(0, 0);
        }];
    }else if (btn.tag == self.roleObj.retData.dataList.count - 1) {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.titleScroll.contentOffset = CGPointMake(weakSelf.titleScroll.contentSize.width - weakSelf.titleScroll.frame.size.width, 0);
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.titleScroll.contentOffset = CGPointMake(btn.superview.center.x - weakSelf.titleScroll.contentSize.width/2.0, 0);
        }];
    }
    self.promImage.center = CGPointMake(btn.superview.center.x, self.promImage.center.y);
    
    for (int i = 0; i < self.roleObj.retData.dataList.count; i++) {
        if (btn.tag == i) {
            self.mainScroll.contentOffset = CGPointMake(WIDTH * i, 0);
            
            if (i == 0) {
                [UIView animateWithDuration:0.2 animations:^{
                    weakSelf.upGradeImageBgView.frame = CGRectMake(0,
                                                                   weakSelf.upGradeImageBgView.frame.origin.y,
                                                                   weakSelf.upGradeImageBgView.frame.size.width,
                                                                   weakSelf.upGradeImageBgView.frame.size.height);
                }];
            }else {
                if (self.upGradeImageBgView.frame.origin.x != (WIDTH - 601 * Proportion - 20*Proportion)*i) {
                    [UIView animateWithDuration:0.2 animations:^{
                        weakSelf.upGradeImageBgView.frame = CGRectMake((WIDTH - 601 * Proportion - 20*Proportion)*i,
                                                                       weakSelf.upGradeImageBgView.frame.origin.y,
                                                                       weakSelf.upGradeImageBgView.frame.size.width,
                                                                       weakSelf.upGradeImageBgView.frame.size.height);
                    }];
                }
            }
        }
    }
}

- (void) enterOne{
    
    WebViewLinkVC *vc = [[WebViewLinkVC alloc] init];
    vc.url = @"http://m.camelliae.com/builtin/project/737";
    vc.name = @"粉色权益";
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

- (void) enterTwo{
    
    WebViewLinkVC *vc = [[WebViewLinkVC alloc] init];
    vc.url = @"http://m.camelliae.com/builtin/project/227";
    vc.name = @"黛色权益";
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) enterThree{

    WebViewLinkVC *vc = [[WebViewLinkVC alloc] init];
    vc.url = @"http://m.camelliae.com/builtin/project/228";
    vc.name = @"金色权益";

    [[VCManger mainVC] pushVC:vc animate:YES];
}

/*
- (void) loadMesPromBgView{
    
    self.mesPromBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.mesPromBgView.backgroundColor = [[UIColor CMLBlackColor] colorWithAlphaComponent:0.6];
    [self.view addSubview:self.mesPromBgView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2.0 - (WIDTH/5.0*4.0)/2.0,
                                                              0,
                                                              WIDTH/5.0*4.0,
                                                              0)];
    bgView.backgroundColor = [UIColor CMLWhiteColor];
    [self.mesPromBgView addSubview:bgView];
    UILabel *lab1 = [[UILabel alloc] init];
    lab1.text = @"亲爱的用户";
    lab1.font = KSystemRealBoldFontSize18;
    [lab1 sizeToFit];
    lab1.frame = CGRectMake(bgView.frame.size.width/2.0 - lab1.frame.size.width/2.0,
                            50*Proportion,
                            lab1.frame.size.width,
                            lab1.frame.size.height);
    [bgView addSubview:lab1];
    
    UILabel *lab2 = [[UILabel alloc] init];
    lab2.font = KSystemFontSize14;
    lab2.numberOfLines = 0;
    lab2.text = [NSString stringWithFormat:@"您是黛色用户%@的下级用户，您用该\
                 \n手机号码升级，将无法使用花伴的发布\
                 \n功能及账本后台。\
                 \n\n1）您可以用该手机号升级后，提供给我\
                 \n们新的手机号，同步升级为黛色，新的账\
                 \n号可以使用花伴的发布功能及账本后台。\
                 \n\n2）您可直接使用新的账号注册，升级黛\
                 \n色用户。\
                 \n\n如有问题，可联系卡枚连客服:\
                 \n64270396",[[DataManager lightData]readParentName]];
    CGRect current = [lab2.text boundingRectWithSize:CGSizeMake(bgView.frame.size.width - 100*Proportion, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KSystemFontSize14} context:nil];
    lab2.frame = CGRectMake(50*Proportion,
                            CGRectGetMaxY(lab1.frame) + 50*Proportion,
                            current.size.width,
                            current.size.height);
    [bgView addSubview:lab2];
    
    UILabel *lab3 = [[UILabel alloc] init];
    lab3.text = @"我已经阅读以上声明";
    lab3.font = KSystemRealBoldFontSize15;
    [lab3 sizeToFit];
    lab3.frame = CGRectMake(bgView.frame.size.width/2.0 - lab3.frame.size.width/2.0,
                            50*Proportion + CGRectGetMaxY(lab2.frame),
                            lab3.frame.size.width,
                            lab3.frame.size.height);
    [bgView addSubview:lab3];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab3.frame) + 10*Proportion,
                                                               lab3.frame.origin.y,
                                                               lab3.frame.size.height,
                                                               lab3.frame.size.height)];
    [btn setImage:[UIImage imageNamed:CMLNewNoSelectImg] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:CMLNewSelectImg] forState:UIControlStateSelected];
    btn.selected = YES;
    [bgView addSubview:btn];
    [btn addTarget:self action:@selector(changeBtnState:) forControlEvents:UIControlEventTouchUpInside];
    
    self.buyPromBtn = [[UIButton alloc] initWithFrame:CGRectMake(lab3.frame.origin.x,
                                                                 CGRectGetMaxY(lab3.frame) + 30*Proportion,
                                                                 lab3.frame.size.width,
                                                                 60*Proportion)];
    self.buyPromBtn.titleLabel.font = KSystemRealBoldFontSize16;
    [self.buyPromBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.buyPromBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    self.buyPromBtn.backgroundColor = [UIColor CMLNewGrayColor];
    [bgView addSubview:self.buyPromBtn];
    [self.buyPromBtn addTarget:self action:@selector(showBuyMes) forControlEvents:UIControlEventTouchUpInside];
    
    
    bgView.frame = CGRectMake(bgView.frame.origin.x,
                              HEIGHT/2.0 - (CGRectGetMaxY(self.buyPromBtn.frame) + 50*Proportion)/2.0,
                              bgView.frame.size.width,
                              CGRectGetMaxY(self.buyPromBtn.frame) + 50*Proportion);
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setImage:[UIImage imageNamed:AlterViewCloseBtnImg] forState:UIControlStateNormal];
    [cancelBtn sizeToFit];
    cancelBtn.frame = CGRectMake(WIDTH/2.0 - cancelBtn.frame.size.width/2.0,
                                 CGRectGetMaxY(bgView.frame) + 40*Proportion,
                                 cancelBtn.frame.size.width ,
                                 cancelBtn.frame.size.height);
    [self.mesPromBgView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelBuy) forControlEvents:UIControlEventTouchUpInside];
}
*/

- (void) changeBtnState:(UIButton *) btn{
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        self.buyPromBtn.userInteractionEnabled = YES;
    }else{
        self.buyPromBtn.userInteractionEnabled = NO;
    }
}

/*
- (void) showBuyMes{
    
    self.mesPromBgView.hidden = YES;
    [self.mesPromBgView removeFromSuperview];
    
    [self getSpecialPrivilege:self.currentType];
    
}*/

- (void) cancelBuy{
    
    self.mesPromBgView.hidden = YES;
    [self.mesPromBgView removeFromSuperview];
}

/*升级判断-新*/
- (void)pickBlackPigmentMember:(UIButton *) button {
    NSLog(@"%ld", (long)button.tag);
    /*2-粉银 3-粉金 4-粉钻 5-9800/38000黛色 7-金色 8-墨色*/
    self.roleId = [NSString stringWithFormat:@"%ld", (long)button.tag];
    if (button.tag < 5) {
        /*1-粉色 2-黛色 3-金色*/
        self.memberLevelId = [NSString stringWithFormat:@"1"];
    }else if (button.tag == 5 || button.tag == 6) {
        self.roleId = [NSString stringWithFormat:@"5"];
        self.memberLevelId = [NSString stringWithFormat:@"2"];
        if (button.tag == 5) {
            /*2-9800黛色 3-38000黛色*/
            self.distributionLevel = [NSString stringWithFormat:@"2"];
        }else if (button.tag == 6) {
            self.distributionLevel = [NSString stringWithFormat:@"3"];
        }
    }else if (button.tag == 7) {
        self.memberLevelId = [NSString stringWithFormat:@"3"];
    }else if (button.tag == 10) {
        self.memberLevelId = [NSString stringWithFormat:@"5"];
    }else if (button.tag == 11) {
        self.memberLevelId = [NSString stringWithFormat:@"6"];
    }
    [self setSpecialPrivilegeRequest];
}
/*三种黛色-->两种--->一种：9800*/
- (void)pickBlackPigmentMember {
    
    [self.currentShadow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.currentShadow.hidden = NO;
    
    ShowBlackPigmentMemberView *blackPigmentMemberView = [[ShowBlackPigmentMemberView alloc] initWithFrame:CGRectMake(0,
                                                                                                                      0,
                                                                                                                      601 * Proportion,
                                                                                                                      450 * Proportion)];
    
    blackPigmentMemberView.alpha = 0;
    blackPigmentMemberView.center = self.currentShadow.center;
    
    [self.currentShadow addSubview:blackPigmentMemberView];
    
    self.secondBPMember = [[ShowBlackPigmentMembersPickView alloc] initWithFrame:CGRectMake(CGRectGetWidth(blackPigmentMemberView.frame)/2 - 543 * Proportion/2,
                                                                                            CGRectGetHeight(blackPigmentMemberView.frame)/2 - 158 * Proportion - 20 * Proportion/2,
                                                                                            543 * Proportion,
                                                                                            158 * Proportion)
                                                                    withVIPImage:[UIImage imageNamed:@"v"]
                                                                       withTitle:@"黛色会员"
                                                                       withPrice:@"￥9800"
                                                                       withIntro:@"1年黛色身份"];
    [blackPigmentMemberView addSubview:self.secondBPMember];
    /*
    self.fristBPMember = [[ShowBlackPigmentMembersPickView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.secondBPMember.frame), CGRectGetMinY(self.secondBPMember.frame) - 20*Proportion - CGRectGetHeight(self.secondBPMember.frame), 543 * Proportion, 158 * Proportion)
                                                                   withVIPImage:[UIImage imageNamed:@"v"]
                                                                      withTitle:@"黛色试用会员"
                                                                      withPrice:@"￥980"
                                                                      withIntro:@"3个月黛色身份，不享受黛色权益"];
    [blackPigmentMemberView addSubview:self.fristBPMember];
     */
    self.thirdBPMember = [[ShowBlackPigmentMembersPickView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.secondBPMember.frame),
                                                                                           CGRectGetMaxY(self.secondBPMember.frame) + 20*Proportion,
                                                                                           543 * Proportion,
                                                                                           158 * Proportion)
                                                                   withVIPImage:[UIImage imageNamed:@"v"]
                                                                      withTitle:@"黛色会员"
                                                                      withPrice:@"￥38000"
                                                                      withIntro:@"5年黛色身份"];
    [blackPigmentMemberView addSubview:self.thirdBPMember];
    
//    UIButton *fristButton = [[UIButton alloc] initWithFrame:self.fristBPMember.frame];
//    fristButton.tag = 980;
//    [blackPigmentMemberView addSubview:fristButton];
//    [fristButton addTarget:self action:@selector(fristClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *secondButton = [[UIButton alloc] initWithFrame:self.secondBPMember.frame];
    secondButton.tag = 5;
    [blackPigmentMemberView addSubview:secondButton];
    [secondButton addTarget:self action:@selector(secondClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *thirdButton = [[UIButton alloc] initWithFrame:self.thirdBPMember.frame];
    thirdButton.tag = 6;
    [blackPigmentMemberView addSubview:thirdButton];
    [thirdButton addTarget:self action:@selector(thirdClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:0.4 animations:^{
        blackPigmentMemberView.alpha = 1.0;
    }];
    
}


- (void)fristClick:(UIButton *)button {
    
    self.fristBPMember.backgroundColor = [UIColor CMLF1F1F1Color];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.fristBPMember.backgroundColor = [UIColor whiteColor];
        weakSelf.fristAgreementView = [[ShowAgreementView alloc] initWithFrame:CGRectMake(0, 0, 601 * Proportion, 946 * Proportion) withType:button];
        weakSelf.fristAgreementView.delegate = weakSelf;
        weakSelf.fristAgreementView.center = weakSelf.currentShadow.center;
        [weakSelf.currentShadow addSubview:weakSelf.fristAgreementView];
    });
    
    
}

- (void)secondClick:(UIButton *)button {
    
    self.secondBPMember.backgroundColor = [UIColor CMLF1F1F1Color];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.secondBPMember.backgroundColor = [UIColor whiteColor];
        weakSelf.fristAgreementView = [[ShowAgreementView alloc] initWithFrame:CGRectMake(0, 0, 601 * Proportion, 946 * Proportion) withType:button];
        weakSelf.fristAgreementView.delegate = weakSelf;
        weakSelf.fristAgreementView.center = weakSelf.currentShadow.center;
        [weakSelf.currentShadow addSubview:weakSelf.fristAgreementView];
    });
    
}

- (void)thirdClick:(UIButton *)button {
    
    self.thirdBPMember.backgroundColor = [UIColor CMLF1F1F1Color];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.thirdBPMember.backgroundColor = [UIColor whiteColor];
        weakSelf.fristAgreementView = [[ShowAgreementView alloc] initWithFrame:CGRectMake(0, 0, 601 * Proportion, 946 * Proportion) withType:button];
        weakSelf.fristAgreementView.delegate = weakSelf;
        weakSelf.fristAgreementView.center = weakSelf.currentShadow.center;
        [weakSelf.currentShadow addSubview:weakSelf.fristAgreementView];
    });
    
    
}

#pragma mark - ShowAgreementView
- (void)showAgreementViewWith:(UIButton *)button {
    
    [self.currentShadow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.currentShadow.hidden = NO;
    self.fristAgreementView = [[ShowAgreementView alloc] initWithFrame:CGRectMake(0, 0, 601 * Proportion, 946 * Proportion) withType:button];
    self.fristAgreementView.delegate = self;
    self.fristAgreementView.center = self.currentShadow.center;
    [self.currentShadow addSubview:self.fristAgreementView];
    
}

#pragma mark - ShowAgreementViewDelegate
- (void)confirmAgreementWith:(UIButton *)button {
    [self.currentShadow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.currentShadow.hidden = YES;
    [self pickBlackPigmentMember:button];
}

#pragma mark - ShowMemberEquityViewDelegate
- (void)showMemberEquityViewButtonClickedDelegateWith:(int)location {
    
    [self.currentShadow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.currentShadow.hidden = NO;
    
    self.detailView = [[MemberEquityDetailView alloc] initWithFrame:CGRectMake(74 * Proportion,
                                                                               HEIGHT,
                                                                               WIDTH - 2 * 74 * Proportion,
                                                                               HEIGHT - 102 * Proportion * 2)
                                                       withLocation:[NSString stringWithFormat:@"%d", location]];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        
        weakSelf.detailView.frame = CGRectMake(74 * Proportion, 102 * Proportion, WIDTH - 2 * 74 * Proportion, HEIGHT - 102 * Proportion * 2);
        
    }];
    
    self.detailView.delegate = self;
    self.detailView.hidden = NO;
    self.detailView.backgroundColor = [UIColor whiteColor];
    [self.currentShadow addSubview:self.detailView];
    
}

- (void)refreshFashionSalonEquityContent {
    
    [self showMemberEquityViewButtonClickedDelegateWith:4];
    
}

#pragma mark - MemberEquityDetailViewDelegate
- (void)cancelMemberEquityDetailView {
    
    [self.currentShadow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.currentShadow.hidden = YES;
    
}

- (void)chooseAppointment {
    
    self.detailView.hidden = YES;

    self.memberAppointmentView = [[MemberAppointmentView alloc] initWithFrame:CGRectMake(102 * Proportion, HEIGHT/2 - 923 * Proportion/2, WIDTH - 2 * 102 * Proportion, 923 * Proportion)];
    self.memberAppointmentView.delegate = self;
    [self.currentShadow addSubview:self.memberAppointmentView];
}

#pragma mark - MemberAppointmentViewDelegate
- (void)offsetMemberAppointmentView {
    
    self.memberAppointmentView.frame = CGRectMake(102 * Proportion, 0, WIDTH - 2 * 102 * Proportion, 923 * Proportion);
    
}

- (void)recoveryMemberAppointmentView {
    
    self.memberAppointmentView.frame = CGRectMake(102 * Proportion, HEIGHT/2 - 923 * Proportion/2, WIDTH - 2 * 102 * Proportion, 923 * Proportion);
    
}

#pragma mark - CMLUpGradeImageBgViewDelegate
- (void)pickBlackPigmentMemberOfImageBgView:(UIButton *)button {
    
    if (button.tag == 5) {
        [self showAgreementViewWith:button];/*黛色协议*/
    }else if (button.tag == 3) {
        [self showAgreementViewWith:button];/*粉金协议*/
    }else {
        [self pickBlackPigmentMember:button];/*其他暂无电子协议*/
    }
    
}

- (void)showMessageOfImageBgView:(UIButton *)button {
    
//    [self showMessage:button];
}

- (void)enterGoldIntroduceOfImageBgView {
    
    [self enterThree];
}

- (void)showMemberEquityViewOfImageBgViewWith:(int)location {
    
    [self showMemberEquityViewButtonClickedDelegateWith:location];
}

- (void)cityPartnerApplyButtonClickOfUpGradeImageBgView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"客服电话：(021)64270356" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", @"021-64270356"]]];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

/*代理？刷新用户数据*/
- (void)requestUserData {
    
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

- (void)setPushTag {
    __autoreleasing NSMutableSet *tags = [NSMutableSet set];
    [self.tagsArray removeAllObjects];
    [self.tagsArray addObject:@"10001"];
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
        NSLog(@"%@", tags);
//        [JPUSHService setTags:tags completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//            NSLog(@"iResCode %ld", (long)iResCode);
//            if (iResCode == 0) {
//                NSLog(@"pushTag设置成功");
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


@end
