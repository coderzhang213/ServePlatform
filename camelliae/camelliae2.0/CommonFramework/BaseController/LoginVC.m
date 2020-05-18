//
//  LoginVC.m
//  camelliae2.0
//
//  Created by 张越 on 16/5/20.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "LoginVC.h"
#import "VCManger.h"
#import "HomeVC.h"
#import "CMLLine.h"
//#import "HyLoglnButton.h"
#import "GetCodeVC.h"
#import "LoginUserObj.h"
#import "RegisterVC.h"
#import <UMAnalytics/MobClick.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "PerfectInfoVC.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UMSocialUIUtility.h>

#import "ActivityDefaultVC.h"
#import "CMLUserArticleVC.h"
#import "CMLUserPushActivityDetailVC.h"
#import "CMLUserPushGoodsVC.h"
#import "ServeDefaultVC.h"
#import "CMLCommodityDetailMessageVC.h"
#import "CMLNewSpecialDetailTopicVC.h"
#import "WebViewLinkVC.h"
#import "CMLMessageObj.h"
#import "CMLMessageViewController.h"
#import "NSObject+CMLKeyValue.h"
#import "CMLPrefectureVC.h"
#import "AppDelegate.h"

#define LoginVCTopImageHeight                 360
#define LoginVCTypeLoginBtnTopMargin          40
#define LoginVCTypeLoginBtnLeftMargin         60
#define LoginVCTypeLoginBtnSpace              100
#define LoginVCLoginBtnTopMargin              60
#define LoginVCTwoLineOfOneLineOrginY         140
#define LoginVCOneLineOrginY                  140
#define LoginVCOneLineLength                  630
#define LoginVCForgetBtnTopMargin             30
#define LoginVCsmapleLabelTopMargin           180
#define LoginVCThreeLineLength                240
#define LoginVCOtherLoginStyleTopMargin       60
#define LoginVCOtherLoginBtnSpace             140



#define LoginVCUserOfOneLineOrginX            30
#define LoginVCUserOfOneLineMaxY              20
#define LoginVCLoginBtnHeight                 72
#define LoginVCLineAndLabelSpace              30
#define LoginVCregisterBtnAndLastLineSpace    6
#define LoginVCLastLineBottomSpace            40


@interface LoginVC ()<NetWorkProtocol,UITextFieldDelegate>

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,copy) NSString *telephoneNum;

@property (nonatomic,copy) NSString *code;

@property (nonatomic,strong) UITextField *textFieldOfTelephone;

@property (nonatomic,strong) UITextField *textFieldOfCode;

@property (nonatomic,assign) NSInteger oldtextLength;

@property (nonatomic,strong) UIButton *loginBtn;

@property (nonatomic,strong) UILabel *promptLabel;

@property (nonatomic,strong) UIButton *smsInterBtn;

@property (nonatomic,strong) UIButton *codeInterBtn;

@property (nonatomic,strong) CMLLine *enterTypeBottomLine;

@property (nonatomic,strong) UIButton *registerBtn;

@property (nonatomic,strong) CMLLine *lastLine;

@property (nonatomic,strong) UIView *forgetBtnAndRegisterBtnbgView;

@property (nonatomic,strong) UIImageView *keyIcon;

@property (nonatomic,strong) UIButton *codeStyleBtn;

@property (nonatomic,strong) UIButton *getSmsCodeBtn;

@property (nonatomic,assign) int currentSeconds;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) BOOL isExistAccount;

/**第三方登录获取的信息*/
@property (nonatomic,copy) NSString *openUnionId;

@property (nonatomic,strong) NSNumber *openIdType;

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,strong) NSNumber *sex;

@property (nonatomic,copy) NSString *gravatar;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self clearOtherVC];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navBar.hidden = YES;
    self.oldtextLength  = 0;
    self.currentSeconds = 60;
    
    [self loadViews];
}

- (void) loadViews{
    
    /**logo*/
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                              0,
                                                                              WIDTH,
                                                                              LoginVCTopImageHeight*Proportion)];
    topImageView.clipsToBounds = YES;
    topImageView.contentMode = UIViewContentModeScaleAspectFit;
    topImageView.backgroundColor = [UIColor CMLPromptGrayColor];
    [self.contentView addSubview:topImageView];
    
    
    
    /**头图的自动变化*/
    if ([[DataManager lightData] readLoginBannerImageUlr].length > 0 ) {
        
        [NetWorkTask setImageView:topImageView WithURL:[[DataManager lightData] readLoginBannerImageUlr] placeholderImage:nil];
        
    }else{
        topImageView.image = [UIImage imageNamed:LaunchBannerImg];
        
    }
    
    /**验证码登录*/
    self.smsInterBtn = [[UIButton alloc] init];
    self.smsInterBtn.titleLabel.font = KSystemFontSize15;
    [self.smsInterBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    [self.smsInterBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateSelected];
    [self.smsInterBtn setTitle:@"验证码快捷登录" forState:UIControlStateNormal];
    [self.smsInterBtn sizeToFit];
    self.smsInterBtn.frame = CGRectMake(LoginVCTypeLoginBtnLeftMargin*Proportion,
                                        CGRectGetMaxY(topImageView.frame) + LoginVCTypeLoginBtnTopMargin*Proportion,
                                        self.smsInterBtn.frame.size.width,
                                        self.smsInterBtn.frame.size.height);
    [self.contentView addSubview:self.smsInterBtn];
    self.smsInterBtn.selected = YES;
    [self.smsInterBtn addTarget:self action:@selector(changeSmsEnterType) forControlEvents:UIControlEventTouchUpInside];
    
    /**密码登录*/
    self.codeInterBtn = [[UIButton alloc] init];
    self.codeInterBtn.titleLabel.font = KSystemFontSize15;
    [self.codeInterBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    [self.codeInterBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateSelected];
    [self.codeInterBtn setTitle:@"密码登录" forState:UIControlStateNormal];
    [self.codeInterBtn sizeToFit];
    self.codeInterBtn.frame = CGRectMake(LoginVCTypeLoginBtnSpace*Proportion + CGRectGetMaxX(self.smsInterBtn.frame),
                                        CGRectGetMaxY(topImageView.frame) + LoginVCTypeLoginBtnTopMargin*Proportion,
                                        self.codeInterBtn.frame.size.width,
                                        self.codeInterBtn.frame.size.height);
    [self.contentView addSubview:self.codeInterBtn];
    [self.codeInterBtn addTarget:self action:@selector(changeCodeEnterType) forControlEvents:UIControlEventTouchUpInside];
    
    
    /**变动的下划线*/
    self.enterTypeBottomLine = [[CMLLine alloc] init];
    self.enterTypeBottomLine.lineWidth = 1;
    self.enterTypeBottomLine.lineLength = self.smsInterBtn.frame.size.width;
    self.enterTypeBottomLine.LineColor = [UIColor CMLBlackColor];
    self.enterTypeBottomLine.startingPoint = CGPointMake(self.smsInterBtn.frame.origin.x,
                                                         CGRectGetMaxY(self.smsInterBtn.frame) );
    [self.contentView addSubview:self.enterTypeBottomLine];
    
    /**第一条线*/
    CMLLine *oneLine = [[CMLLine alloc] init];
    oneLine.startingPoint = CGPointMake(self.view.center.x - LoginVCOneLineLength*Proportion/2.0,
                                        LoginVCOneLineOrginY*Proportion+ CGRectGetMaxY(self.smsInterBtn.frame));
    oneLine.directionOfLine = HorizontalLine;
    oneLine.lineWidth = 1;
    oneLine.lineLength = LoginVCOneLineLength*Proportion;
    oneLine.LineColor = [UIColor CMLPromptGrayColor];
    [self.contentView addSubview:oneLine];
    
    UIImageView *userIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:LoginVCUser]];
    userIcon.contentMode = UIViewContentModeScaleAspectFit;
    [userIcon sizeToFit];
    userIcon.backgroundColor = [UIColor whiteColor];
    userIcon.frame = CGRectMake(self.view.center.x - LoginVCOneLineLength*Proportion/2.0,
                                oneLine.startingPoint.y - LoginVCUserOfOneLineMaxY*Proportion - userIcon.frame.size.height,
                                userIcon.frame.size.width,
                                userIcon.frame.size.height);
    [self.contentView addSubview:userIcon];
    
    /**手机号输入框*/
    
    self.textFieldOfTelephone = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userIcon.frame) + 30*Proportion,
                                                                              userIcon.frame.origin.y - LoginVCUserOfOneLineMaxY*Proportion,
                                                                              oneLine.lineLength - userIcon.frame.size.width - 30*Proportion,
                                                                              CGRectGetHeight(userIcon.frame) + 2*LoginVCUserOfOneLineMaxY*Proportion)];
    self.textFieldOfTelephone.keyboardType = UIKeyboardTypeNumberPad;
    self.textFieldOfTelephone.backgroundColor = [UIColor whiteColor];
    self.textFieldOfTelephone.placeholder = @"请输入手机号";
    self.textFieldOfTelephone.font = KSystemFontSize15;
    self.textFieldOfTelephone.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textFieldOfTelephone.delegate = self;
    [self.textFieldOfTelephone addTarget:self action:@selector(inputTelephoneNum) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:self.textFieldOfTelephone];
    
    
    /**第二条线*/
    CMLLine *twoLine = [[CMLLine alloc] init];
    twoLine.startingPoint = CGPointMake(oneLine.startingPoint.x, oneLine.startingPoint.y + LoginVCTwoLineOfOneLineOrginY*Proportion);
    twoLine.directionOfLine = HorizontalLine;
    twoLine.lineWidth = 1;
    twoLine.lineLength = LoginVCOneLineLength*Proportion;
    twoLine.LineColor = [UIColor CMLPromptGrayColor];
    [self.contentView addSubview:twoLine];
    
    self.keyIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MesCodeImg]];
    _keyIcon.contentMode = UIViewContentModeScaleAspectFit;
    _keyIcon.frame = CGRectMake(self.view.center.x - LoginVCOneLineLength*Proportion/2.0,
                               twoLine.startingPoint.y - LoginVCUserOfOneLineMaxY*Proportion - _keyIcon.frame.size.height,
                               _keyIcon.frame.size.width,
                               _keyIcon.frame.size.height);
    [self.contentView addSubview:_keyIcon];
    
    /**密码是否可见*/
    self.codeStyleBtn = [[UIButton alloc] init];
    [_codeStyleBtn setImage:[UIImage imageNamed:LoginVCUnSee] forState:UIControlStateNormal];
    [_codeStyleBtn setImage:[UIImage imageNamed:LoginVCSee] forState:UIControlStateSelected];
    _codeStyleBtn.frame = CGRectMake(twoLine.startingPoint.x + twoLine.lineLength - (CGRectGetHeight(_keyIcon.frame) + 2*LoginVCUserOfOneLineMaxY*Proportion),
                                    _keyIcon.frame.origin.y - LoginVCUserOfOneLineMaxY*Proportion,
                                    CGRectGetHeight(_keyIcon.frame) + 2*LoginVCUserOfOneLineMaxY*Proportion,
                                    CGRectGetHeight(_keyIcon.frame) + 2*LoginVCUserOfOneLineMaxY*Proportion);
    _codeStyleBtn.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_codeStyleBtn];
    [_codeStyleBtn addTarget:self action:@selector(changeCodeInputStyle:) forControlEvents:UIControlEventTouchUpInside];
    _codeStyleBtn.hidden = YES;
    
    /**验证码请求*/
    self.getSmsCodeBtn = [[UIButton alloc] init];
    [self.getSmsCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.getSmsCodeBtn.titleLabel.font = KSystemFontSize12;
    [self.getSmsCodeBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    [self.getSmsCodeBtn sizeToFit];
    CGFloat currentWidth = self.getSmsCodeBtn.frame.size.width + 40*Proportion;
    
    self.getSmsCodeBtn.frame = CGRectMake(twoLine.startingPoint.x + twoLine.lineLength - currentWidth,
                                          twoLine.startingPoint.y - LoginVCUserOfOneLineMaxY*Proportion - 52*Proportion,
                                          self.getSmsCodeBtn.frame.size.width + 40*Proportion,
                                          52*Proportion);
    self.getSmsCodeBtn.layer.cornerRadius = 52*Proportion/2.0;
    self.getSmsCodeBtn.backgroundColor = [UIColor CMLNewGrayColor];
    [self.contentView addSubview:self.getSmsCodeBtn];
    [self.getSmsCodeBtn addTarget:self action:@selector(setGetSmsCodeTimerAndRequest) forControlEvents:UIControlEventTouchUpInside];
    
    
    /**密码输入框*/
    self.textFieldOfCode = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_keyIcon.frame) + 30*Proportion,
                                                                         _keyIcon.frame.origin.y - LoginVCUserOfOneLineMaxY*Proportion,
                                                                         twoLine.lineLength - self.getSmsCodeBtn.frame.size.width - self.keyIcon.frame.size.width - 30*Proportion,
                                                                         CGRectGetHeight(_keyIcon.frame) + 2*LoginVCUserOfOneLineMaxY*Proportion)];
    self.textFieldOfCode.keyboardType = UIKeyboardTypeNumberPad;
    self.textFieldOfCode.placeholder = @"请输入验证码";
    self.textFieldOfCode.font = KSystemFontSize15;
    self.textFieldOfCode.delegate = self;
    [self.contentView addSubview:self.textFieldOfCode];
    

    
    /**登录键*/
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2.0 - LoginVCOneLineLength*Proportion/2.0,
                                                                    twoLine.startingPoint.y + LoginVCLoginBtnTopMargin*Proportion,
                                                                    LoginVCOneLineLength*Proportion,
                                                                    LoginVCLoginBtnHeight*Proportion)];
    self.loginBtn.backgroundColor = [UIColor CMLBlackColor];
    self.loginBtn.layer.cornerRadius = LoginVCLoginBtnHeight*Proportion/2.0;
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = KSystemBoldFontSize15;
    self.loginBtn.titleLabel.textColor = [UIColor whiteColor];
    [self.loginBtn addTarget:self action:@selector(postLoginRequest) forControlEvents:UIControlEventTouchUpInside];
    
    self.promptLabel = [[UILabel alloc] init];
    self.promptLabel.font = KSystemFontSize10;
    self.promptLabel.text = @"账号或密码有误，请重新试试吧！";
    self.promptLabel.textColor = [UIColor CMLRedColor];
    [self.promptLabel sizeToFit];
    self.promptLabel.frame = CGRectMake(WIDTH/2.0 - self.promptLabel.frame.size.width/2.0,
                                        twoLine.startingPoint.y + 10*Proportion,
                                        self.promptLabel.frame.size.width,
                                        self.promptLabel.frame.size.height);
    self.promptLabel.hidden = YES;
    [self.contentView addSubview:self.promptLabel];
    
    
    self.registerBtn = [[UIButton alloc] init];
    NSString *registerStr = @"还没有账号？去注册！";
    CGSize registerSize = [registerStr sizeWithFontCompatible:KSystemFontSize13];
    _registerBtn.titleLabel.font = KSystemFontSize13;
    [_registerBtn setTitle:registerStr forState:UIControlStateNormal];
    [_registerBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    _registerBtn.frame = CGRectMake(WIDTH/2.0 - registerSize.width/2.0,
                                    CGRectGetMaxY(self.loginBtn.frame) + LoginVCForgetBtnTopMargin*Proportion,
                                    registerSize.width,
                                    registerSize.height);
    [_registerBtn addTarget:self action:@selector(enterRegisterVC) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_registerBtn];
    
    self.lastLine = [[CMLLine alloc] init];
    _lastLine.startingPoint = CGPointMake(_registerBtn.frame.origin.x, CGRectGetMaxY(_registerBtn.frame) + LoginVCregisterBtnAndLastLineSpace*Proportion);
    _lastLine.lineWidth = 1;
    _lastLine.lineLength = registerSize.width;
    _lastLine.LineColor = [UIColor CMLPromptGrayColor];
    _lastLine.directionOfLine = HorizontalLine;
    [self.contentView addSubview:_lastLine];
    
    
    /**忘记密码和注册*/
    self.forgetBtnAndRegisterBtnbgView = [[UIView alloc] init];
    self.forgetBtnAndRegisterBtnbgView.backgroundColor = [UIColor CMLWhiteColor];
    [self.contentView addSubview:self.forgetBtnAndRegisterBtnbgView];
    
    /**忘记密码*/
    UIButton *forgetBtn = [[UIButton alloc] init];
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = KSystemFontSize13;
    [forgetBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    NSString *str = @"忘记密码？";
    CGSize btnSize = [str sizeWithFontCompatible:KSystemFontSize13];
    forgetBtn.frame = CGRectMake(0,
                                 0,
                                 btnSize.width,
                                 btnSize.height);
    [forgetBtn addTarget:self action:@selector(enterGetCodeVC) forControlEvents:UIControlEventTouchUpInside];
    [self.forgetBtnAndRegisterBtnbgView addSubview:forgetBtn];
    
    UIButton *registerBtn = [[UIButton alloc] init];
    [registerBtn setTitle:@"手机号注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = KSystemFontSize13;
    [registerBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    NSString *str2 = @"手机号注册";
    CGSize registerBtnSize = [str2 sizeWithFontCompatible:KSystemFontSize13];
    registerBtn.frame = CGRectMake(CGRectGetMaxX(forgetBtn.frame) + 60*Proportion,
                                   0,
                                   registerBtnSize.width,
                                   registerBtnSize.height);
    [registerBtn addTarget:self action:@selector(enterRegisterVC) forControlEvents:UIControlEventTouchUpInside];
    [self.forgetBtnAndRegisterBtnbgView addSubview:registerBtn];
    
    self.forgetBtnAndRegisterBtnbgView.frame = CGRectMake(WIDTH/2.0 - (forgetBtn.frame.size.width + registerBtn.frame.size.width + 60*Proportion)/2.0,
                                                          CGRectGetMaxY(self.loginBtn.frame) + LoginVCForgetBtnTopMargin*Proportion,
                                                          forgetBtn.frame.size.width + registerBtn.frame.size.width + 60*Proportion,
                                                          registerBtn.frame.size.height);
    CMLLine *centerLine = [[CMLLine alloc] init];
    centerLine.lineWidth = 1;
    centerLine.LineColor = [UIColor CMLtextInputGrayColor];
    centerLine.directionOfLine = VerticalLine;
    centerLine.lineLength = self.forgetBtnAndRegisterBtnbgView.frame.size.height;
    centerLine.startingPoint = CGPointMake(self.forgetBtnAndRegisterBtnbgView.frame.size.width/2.0, 0);
    [self.forgetBtnAndRegisterBtnbgView addSubview:centerLine];
    self.forgetBtnAndRegisterBtnbgView.hidden = YES;
    
    
    UILabel *bottomLab = [[UILabel alloc] init];
    bottomLab.text = @"第三方账号登录";
    bottomLab.textColor = [UIColor CMLtextInputGrayColor];
    bottomLab.font = KSystemFontSize12;
    [bottomLab sizeToFit];
    bottomLab.frame = CGRectMake(WIDTH/2.0 - bottomLab.frame.size.width/2.0,
                                 HEIGHT - 60*Proportion - bottomLab.frame.size.height,
                                 bottomLab.frame.size.width,
                                 bottomLab.frame.size.height);
    [self.contentView addSubview:bottomLab];
    
    UIButton *wechatBtn = [[UIButton alloc] init];
    [wechatBtn setImage:[UIImage imageNamed:LoginVCWechat] forState:UIControlStateNormal];
    [wechatBtn setImage:[UIImage imageNamed:LoginVCHightLightWechat] forState:UIControlStateHighlighted];
    [wechatBtn sizeToFit];
    wechatBtn.frame = CGRectMake(WIDTH/2.0 - wechatBtn.frame.size.width/2.0,
                                bottomLab.frame.origin.y - 30*Proportion - wechatBtn.frame.size.height,
                                wechatBtn.frame.size.width,
                                wechatBtn.frame.size.height);
    wechatBtn.tag = 2;
    [wechatBtn addTarget:self action:@selector(otherLoginWay:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:wechatBtn];
    
    
    [self.contentView addSubview:self.loginBtn];
    
    
}


- (void) setTelephoneLoginRequest{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    self.telephoneNum = [self.textFieldOfTelephone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [paraDic setObject:self.telephoneNum forKey:@"mobile"];
    [paraDic setObject:@"0" forKey:@"smsCode"];
    [paraDic setObject:[NSString getEncryptStringfrom:@[self.textFieldOfCode.text]] forKey:@"password"];
    [paraDic setObject:[NSNumber numberWithInt:[AppGroup getCurrentDate]] forKey:@"reqTime"];
    [paraDic setObject:[NSNumber numberWithInt:0] forKey:@"inviteCode"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.telephoneNum,[[DataManager lightData] readSkey],@"0",self.textFieldOfCode.text]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:TelephoneLogin paraDic:paraDic delegate:delegate];
    self.currentApiName = TelephoneLogin;

}

- (void) setOtherLoginRequest{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    [paraDic setObject:self.openUnionId forKey:@"openUnionId"];
    [paraDic setObject:self.openIdType forKey:@"openIdType"];
    [paraDic setObject:self.nickName forKey:@"nickName"];
    [paraDic setObject:self.sex forKey:@"sex"];
    [paraDic setObject:self.gravatar forKey:@"gravatar"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.openUnionId,
                                                           self.openIdType,
                                                           [[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:UniteLogin paraDic:paraDic delegate:delegate];
    self.currentApiName = UniteLogin;
    
    
}

#pragma mark - inputTelephoneNum
- (void) inputTelephoneNum{
    
    if (self.textFieldOfTelephone.text.length >13) {
        
        /**控制输入长度*/
        NSMutableString *tempPhoneNum = [NSMutableString stringWithFormat:@"%@",self.textFieldOfTelephone.text];
        self.textFieldOfTelephone.text = [tempPhoneNum substringToIndex:13];
        
    }else{
        
        /**根据增删进行空格补位*/
        if (self.oldtextLength < self.textFieldOfTelephone.text.length) {
            
            if ((self.textFieldOfTelephone.text.length == 3) || (self.textFieldOfTelephone.text.length == 8)) {
                
                self.textFieldOfTelephone.text = [NSString stringWithFormat:@"%@ ",self.textFieldOfTelephone.text];
            }
        }
        self.oldtextLength = self.textFieldOfTelephone.text.length;
    }
}

#pragma mark - changeCodeInputStyle
- (void) changeCodeInputStyle:(UIButton *) button{

    button.selected = !button.selected;
    
    if (button.selected) {
        self.textFieldOfCode.secureTextEntry = NO;
    }else{
        self.textFieldOfCode.secureTextEntry = YES;
    }
}

#pragma mark - postLoginRequest
- (void) postLoginRequest{
    
    [self startLoading];
    [self.textFieldOfCode resignFirstResponder];
    [self.textFieldOfTelephone resignFirstResponder];
    NSLog(@"readSkey: %@", [[DataManager lightData] readSkey]);
    if ([[DataManager lightData] readSkey].length == 0) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (appDelegate.isNetError) {
            [appDelegate setAppStartMes];
        }
    }

    self.telephoneNum = [self.textFieldOfTelephone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (self.codeInterBtn.selected) {
        
        
        if ([self.telephoneNum valiMobile] && self.textFieldOfCode.text.length > 0) {
            
            /**发送登录请求*/
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            if (!appDelegate.isNetError) {
                [self setTelephoneLoginRequest];
            }else {
                [appDelegate setAppStartMes];
                [self stopLoading];
            }
            
        }else{
            
            self.promptLabel.text = @"账号或密码有误，请重新试试吧！";
            [SVProgressHUD showErrorWithStatus:@"账号或密码有误，请重新试试吧！"];
            [self stopLoading];
            self.promptLabel.hidden = NO;
            [self performSelector:@selector(hiddenPromptLabel) withObject:nil afterDelay:5];
//            [self.loginBtn ErrorRevertAnimationCompletion:nil];

        }
    }else{
    
        if ([self.telephoneNum valiMobile] && self.textFieldOfCode.text.length > 0) {
            
            /**发送登录请求*/
            [self postCheckRequest];
        }else{
            
            self.promptLabel.text = @"手机号或验证码有误，请重新试试吧！";
            [SVProgressHUD showErrorWithStatus:@"手机号或验证码有误，请重新试试吧！"];
            [self stopLoading];
            self.promptLabel.hidden = NO;
            [self performSelector:@selector(hiddenPromptLabel) withObject:nil afterDelay:5];
//            [self.loginBtn ErrorRevertAnimationCompletion:nil];

        }
    }
}

#pragma mark - 第三方登录
- (void) otherLoginWay:(UIButton *) button{

    self.openIdType = [NSNumber numberWithInt:1];
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        
        if (error) {
            
        }else{
            
            if ([result isKindOfClass:[UMSocialUserInfoResponse class]]) {
                
                UMSocialUserInfoResponse *resp = result;
                
                if (resp.uid) {
                    self.openUnionId = resp.uid;
                }
                
                if (resp.name) {
                    self.nickName = resp.name;
                }
                
                if (resp.iconurl) {
                    self.gravatar = resp.iconurl;
                }
                
                if (resp.gender) {

                    if ([resp.gender isEqualToString:@"男"]) {
                        self.sex = [NSNumber numberWithInt:1];
                    }else if ([resp.gender isEqualToString:@"女"]){
                        self.sex = [NSNumber numberWithInt:2];
                    }else{
                        self.sex = [NSNumber numberWithInt:3];
                    }
                }
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                if (!appDelegate.isNetError) {
                    [self setOtherLoginRequest];
                    [self startIndicatorLoadingWithShadow];
                }else {
                    [appDelegate setAppStartMes];
                    [self stopLoading];
                }
            }
        }
    }];
}

#pragma mark - 进入主界面
- (void) enterMainVC{
    /*是否是推送进入*/
    if ([[[DataManager lightData] readIsLoginOfPush] intValue] == 1) {
//        [[DataManager lightData] saveIsLoginOfPush:[NSNumber numberWithInt:0]];
        NSDictionary *hintDic = @{@"currentID":@"id"};
        CMLMessageObj *obj = [CMLMessageObj objectWithModelDic:[[DataManager lightData] readUserInfoDict] hintDic:hintDic];
        NSLog(@"%@", obj.objType);
        [[VCManger mainVC] pushVC:[VCManger homeVC] animate:NO];
        [[VCManger homeVC] viewDidLoad];
        switch ([obj.objType intValue]) {
            case 1:
            {
                NSLog(@"首页");
                [[VCManger homeVC] showCurrentViewController:0];
                [[VCManger mainVC] pushVC:[VCManger homeVC] animate:NO];
            }
                break;
                
            case 2:
            {
                NSLog(@"活动");
                [[VCManger homeVC] showCurrentViewController:1];
                [[VCManger mainVC] pushVC:[VCManger homeVC] animate:NO];
            }
                break;
                
            case 3:
            {
                NSLog(@"商城");
                [[VCManger homeVC] showCurrentViewController:4];
                [[VCManger mainVC] pushVC:[VCManger homeVC] animate:NO];
            }
                break;
                
            case 4:
            {
                NSLog(@"花伴");
                [[VCManger homeVC] showCurrentViewController:2];
                [[VCManger mainVC] pushVC:[VCManger homeVC] animate:NO];
            }
                break;
                
            case 5:
            {
                /*活动详情页*/
                [[VCManger homeVC] showCurrentViewController:3];
                CMLMessageViewController *baseVC = [[CMLMessageViewController alloc] init];
                [[VCManger mainVC] pushVC:baseVC animate:NO];
                ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:obj.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
            }
                break;
                
            case 6:
            {
                /*单品详情页*/
                [[VCManger homeVC] showCurrentViewController:3];
                CMLMessageViewController *baseVC = [[CMLMessageViewController alloc] init];
                [[VCManger mainVC] pushVC:baseVC animate:NO];
                CMLCommodityDetailMessageVC *vc = [[CMLCommodityDetailMessageVC alloc] initWithObjId:obj.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
                
            }
                break;
                
            case 7:
            {
                /*服务详情页*/
                [[VCManger homeVC] showCurrentViewController:3];
                CMLMessageViewController *baseVC = [[CMLMessageViewController alloc] init];
                [[VCManger mainVC] pushVC:baseVC animate:NO];
                ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:obj.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
            }
                break;
                
            case 8:
            {
                /*花伴活动详情*/
                [[VCManger homeVC] showCurrentViewController:3];
                CMLMessageViewController *baseVC = [[CMLMessageViewController alloc] init];
                [[VCManger mainVC] pushVC:baseVC animate:NO];
                CMLUserPushActivityDetailVC *vc = [[CMLUserPushActivityDetailVC alloc] initWithObjId:obj.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
            }
                break;
                
            case 9:
            {
                /*花伴单品详情*/
                [[VCManger homeVC] showCurrentViewController:3];
                CMLMessageViewController *baseVC = [[CMLMessageViewController alloc] init];
                [[VCManger mainVC] pushVC:baseVC animate:NO];
                CMLUserPushGoodsVC *vc = [[CMLUserPushGoodsVC alloc] initWithObjId:obj.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
            }
                break;
                
            case 10:
            {
                /*专题详情页*/
                [[VCManger homeVC] showCurrentViewController:3];
                CMLMessageViewController *baseVC = [[CMLMessageViewController alloc] init];
                [[VCManger mainVC] pushVC:baseVC animate:NO];
                CMLNewSpecialDetailTopicVC *vc = [[CMLNewSpecialDetailTopicVC alloc] initWithCurrentId:obj.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
            }
                break;
                
            case 11:
            {
                /*资讯详情页*/
                [[VCManger homeVC] showCurrentViewController:3];
                CMLMessageViewController *baseVC = [[CMLMessageViewController alloc] init];
                [[VCManger mainVC] pushVC:baseVC animate:NO];
                CMLUserArticleVC *vc = [[CMLUserArticleVC alloc] initWithObj:obj.objId];
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
                vc.url = obj.objUrl;
                vc.name = obj.content;
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
                vc.currentID = obj.objId;
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
    }else {
        NSArray *array = [VCManger mainVC].viewControllers;
        BOOL hasHomeVC = NO;
        for (int i = 0; i < array.count; i++) {
            
            if ([array[i] isKindOfClass:[HomeVC class]]) {
                hasHomeVC = YES;
            }
        }
        
        if (!hasHomeVC) {
            [[VCManger mainVC] pushVC:[VCManger homeVC] animate:NO];
            [[VCManger homeVC] viewDidLoad];
            
        }else{
            
            [[VCManger mainVC] popToRootVC];
        }
        [self.delegate registerPushAfterLogin];
        [[DataManager lightData] saveIsLogin:[NSNumber numberWithInt:1]];
    }
}

#pragma mark - 进入忘记密码页面
- (void) enterGetCodeVC{

    GetCodeVC *vc = [[GetCodeVC alloc] init];
    [[VCManger mainVC] pushVC:vc animate:NO];

}

#pragma mark - 进入注册页面
- (void) enterRegisterVC{

    RegisterVC *vc = [[RegisterVC alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void)enterPerfectInfoVC{

    PerfectInfoVC *vc = [[PerfectInfoVC alloc] init];
    vc.isNormalRegisterStyle = NO;
    [[VCManger mainVC] pushVC:vc animate:YES];
}
#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    if ([self.currentApiName isEqualToString:TelephoneLogin]) {

        /**电话请求*/
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            /**统计帐号类型*/
            [MobClick profileSignInWithPUID:[NSString stringWithFormat:@"%@",obj.retData.user.uid]];
            /**************************/
            /**基本信息存储*/
            
            [self saveUserInfo:obj];
//            __weak typeof(self) weakSelf = self;
//            [self.loginBtn ExitAnimationCompletion:^{
                [self enterMainVC];
//            }];

        }else{
            
            self.promptLabel.hidden = NO;
            self.promptLabel.text = @"账号或密码有误，请重新试试吧！";
            [SVProgressHUD showErrorWithStatus:@"账号或密码有误，请重新试试吧！"];
            [self stopLoading];
            [self performSelector:@selector(hiddenPromptLabel) withObject:nil afterDelay:5];
//            [self.loginBtn ErrorRevertAnimationCompletion:nil];

        }
        
    }else if ([self.currentApiName isEqualToString:UniteLogin]){
         [self stopIndicatorLoadingWithShadow];
        /**第三方登录*/
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0 && obj) {
            
            /**统计帐号类型*/
            NSString *openType;
            switch ([obj.retData.user.openIdType intValue]) {
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
            [MobClick profileSignInWithPUID:[NSString stringWithFormat:@"%@",obj.retData.user.uid] provider:openType];
            /***********************************************/
            
            [self saveUserInfo:obj];
            [self enterMainVC];
        }else{
            [self showFailTemporaryMes:obj.retMsg];
        }
    }else if ([self.currentApiName isEqualToString:MessageVerify]){
    
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0 && obj) {
            [self showSuccessTemporaryMes:@"验证码已发送"];
            
        }else{
            [self showFailTemporaryMes:obj.retMsg];
            [self initializeTimer];
        }
    
        [self stopIndicatorLoading];
        
    }else if ([self.currentApiName isEqualToString:CheckUser]){
    
        /**电话请求*/
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 100302 && obj) {
            /**发送验证码请求*/
            self.isExistAccount = NO;
            [self smsCodeLoginRequest];
            
        }else if ([obj.retCode intValue] == 0 && obj){
            
            self.isExistAccount = YES;
            [self smsCodeLoginRequest];
            
        }else{
            
            [self showFailTemporaryMes:obj.retMsg];
//            [self.loginBtn ErrorRevertAnimationCompletion:nil];
        }
    }else if ([self.currentApiName isEqualToString:SmsCodeLogin]){
    
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 ){
            
            if (self.isExistAccount) {
              
                /**************************/
                /**基本信息存储*/
                [self saveUserInfo:obj];
//                __weak typeof(self) weakSelf = self;
//                [self.loginBtn ExitAnimationCompletion:^{
                    [self enterMainVC];
//                }];
            }else{
            
                [MobClick profileSignInWithPUID:[NSString stringWithFormat:@"%@",obj.retData.user.uid]];
                /**************************/
                /**基本信息存储*/
                [self saveUserInfo:obj];
//                __weak typeof(self) weakSelf = self;
//                [self.loginBtn ExitAnimationCompletion:^{
                    [self enterPerfectInfoVC];
//                }];
                
            }
            
        }else{
            
            [self showFailTemporaryMes:obj.retMsg];
//            [self.loginBtn ErrorRevertAnimationCompletion:nil];
        }
    }
    [self stopLoading];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    [self stopLoading];
    [self stopIndicatorLoadingWithShadow];
    [self stopIndicatorLoading];
    /**允许输入*/
    self.promptLabel.text = @"账号或密码有误，请重新试试吧！";
    self.promptLabel.hidden = NO;
    [self performSelector:@selector(hiddenPromptLabel) withObject:nil afterDelay:5];
//    [self.loginBtn ErrorRevertAnimationCompletion:nil];
    [self showFailTemporaryMes:@"网络链接失败"];
    
}


#pragma mark - UITextViewDelegate


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    /**键盘放弃第一响应者*/
    [self.textFieldOfTelephone resignFirstResponder];
    [self.textFieldOfCode resignFirstResponder];
    
}

#pragma mark - 信息存储
- (void) saveUserInfo:(BaseResultObj *)obj{
    
    [[DataManager lightData] saveSkey:obj.retData.skey];
    [DataManager saveSkey:obj.retData.skey];
    [[DataManager lightData] saveUser:obj];
    
}


#pragma mark - clearOtherVC
- (void) clearOtherVC{

    NSArray *array = [VCManger mainVC].viewControllers;
        for (int i = 0; i < array.count - 1; i++) {
            UIViewController *vc = array[i];
            [vc removeFromParentViewController];
        }
}

#pragma mark - hiddenPromptLabel
- (void) hiddenPromptLabel{

    self.promptLabel.hidden = YES;
}

#pragma mark-  切换登录方式
- (void) changeSmsEnterType{
    
    
    [self.textFieldOfCode resignFirstResponder];
    [self.textFieldOfTelephone resignFirstResponder];
    
    if (!self.smsInterBtn.selected) {
     
        self.textFieldOfCode.keyboardType = UIKeyboardTypeNumberPad;
        self.textFieldOfCode.secureTextEntry = NO;
        self.textFieldOfCode.text = @"";
        self.textFieldOfTelephone.text = @"";
        
        /**初始化计时器*/
        [self initializeTimer];
        
        
        /**状态切换*/
        self.smsInterBtn.selected = YES;
        self.codeInterBtn.selected = NO;
        
        
        [self.enterTypeBottomLine removeFromSuperview];
        /**下划线变化*/
        self.enterTypeBottomLine = [[CMLLine alloc] init];
        self.enterTypeBottomLine.lineWidth = 1;
        self.enterTypeBottomLine.lineLength = self.smsInterBtn.frame.size.width;
        self.enterTypeBottomLine.LineColor = [UIColor CMLBlackColor];
        self.enterTypeBottomLine.startingPoint = CGPointMake(self.smsInterBtn.frame.origin.x, CGRectGetMaxY(self.smsInterBtn.frame) );
        
        [self.contentView addSubview:self.enterTypeBottomLine];
        [self.contentView sendSubviewToBack:self.enterTypeBottomLine];
        self.forgetBtnAndRegisterBtnbgView.hidden = YES;
        self.registerBtn.hidden = NO;
        self.lastLine.hidden = NO;
        self.keyIcon.image = [UIImage imageNamed:MesCodeImg];
        self.codeStyleBtn.hidden = NO;
        self.getSmsCodeBtn.hidden = NO;
        _codeStyleBtn.hidden = YES;
        self.textFieldOfCode.placeholder = @"请输入验证码";
        self.textFieldOfCode.frame = CGRectMake(CGRectGetMaxX(_keyIcon.frame) + 30*Proportion,
                                                _keyIcon.frame.origin.y - LoginVCUserOfOneLineMaxY*Proportion,
                                                LoginVCOneLineLength*Proportion - self.keyIcon.frame.size.width - 30*Proportion - self.getSmsCodeBtn.frame.size.width,
                                                CGRectGetHeight(_keyIcon.frame) + 2*LoginVCUserOfOneLineMaxY*Proportion);

    }
}

- (void) changeCodeEnterType{
    
    /**初始化计时器*/
    [self initializeTimer];

    [self.textFieldOfCode resignFirstResponder];
    [self.textFieldOfTelephone resignFirstResponder];
    
    if (!self.codeInterBtn.selected) {
     
        self.textFieldOfCode.keyboardType = UIKeyboardTypeDefault;
        self.textFieldOfCode.secureTextEntry = YES;
        self.textFieldOfCode.text = @"";
        self.textFieldOfTelephone.text = @"";
        self.codeStyleBtn.selected = NO;
        
        self.smsInterBtn.selected = NO;
        self.codeInterBtn.selected = YES;
        
        [self.enterTypeBottomLine removeFromSuperview];
        self.enterTypeBottomLine = [[CMLLine alloc] init];
        self.enterTypeBottomLine.lineWidth = 1;
        self.enterTypeBottomLine.lineLength = self.codeInterBtn.frame.size.width;
        self.enterTypeBottomLine.LineColor = [UIColor CMLBlackColor];
        self.enterTypeBottomLine.startingPoint = CGPointMake(self.codeInterBtn .frame.origin.x, CGRectGetMaxY(self.codeInterBtn.frame) );
        [self.contentView addSubview:self.enterTypeBottomLine];
        [self.contentView sendSubviewToBack:self.enterTypeBottomLine];
        
        self.forgetBtnAndRegisterBtnbgView.hidden = NO;
        self.registerBtn.hidden = YES;
        self.lastLine.hidden = YES;
        
        self.keyIcon.image = [UIImage imageNamed:LoginVCCode];
        self.codeStyleBtn.hidden = YES;
        self.getSmsCodeBtn.hidden = YES;
        _codeStyleBtn.hidden = NO;
        self.textFieldOfCode.placeholder = @"请输入密码";
        self.textFieldOfCode.frame = CGRectMake(CGRectGetMaxX(_keyIcon.frame) + 30*Proportion,
                                                _keyIcon.frame.origin.y - LoginVCUserOfOneLineMaxY*Proportion,
                                                LoginVCOneLineLength*Proportion - self.keyIcon.frame.size.width - 30*Proportion - self.codeStyleBtn.frame.size.width,
                                                CGRectGetHeight(_keyIcon.frame) + 2*LoginVCUserOfOneLineMaxY*Proportion);

    }
}

#pragma mark - 获取验证码
- (void) setGetSmsCodeTimerAndRequest{
    
    self.telephoneNum = [self.textFieldOfTelephone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([self.telephoneNum valiMobile]) {
     
        [self.textFieldOfCode becomeFirstResponder];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (!appDelegate.isNetError) {
            [self setSmsRequest];
        }else {
            [appDelegate setAppStartMes];
            [self stopLoading];
        }
        
    }else{
    
        self.promptLabel.text = @"账号有误，请重新试试吧。";
        [self stopLoading];
        self.promptLabel.hidden = NO;
        [self performSelector:@selector(hiddenPromptLabel) withObject:nil afterDelay:5];
    }

}

#pragma mark - changeCurrentSeconds
- (void) changeCurrentSeconds{

    if (self.currentSeconds != 0) {
     
        self.currentSeconds--;
        [self.getSmsCodeBtn setTitle:[NSString stringWithFormat:@"%dS",self.currentSeconds]
                            forState:UIControlStateNormal];
        
    }else{

        [self initializeTimer];
    }
}

- (void) initializeTimer{

    self.currentSeconds = 60;
    self.getSmsCodeBtn.userInteractionEnabled = YES;
    [self.timer invalidate];
    self.timer = nil;
    [self.getSmsCodeBtn setTitle:@"发送验证码"
                        forState:UIControlStateNormal];

}

- (void) setSmsRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.telephoneNum forKey:@"mobile"];
    [paraDic setObject:[NSNumber numberWithInt:10004] forKey:@"reqType"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    [paraDic setObject:[NSNumber numberWithInt:[AppGroup getCurrentDate]] forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.telephoneNum,[NSNumber numberWithInt:10004],[[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:MessageVerify paraDic:paraDic delegate:delegate];
    self.currentApiName = MessageVerify;
    
    [self startIndicatorLoading];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(changeCurrentSeconds)
                                                userInfo:nil
                                                 repeats:YES];
    self.getSmsCodeBtn.userInteractionEnabled = NO;
    
}

- (void) postCheckRequest{
    
    /**请求*/
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    self.telephoneNum = [self.textFieldOfTelephone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [paraDic setObject:self.telephoneNum forKey:@"account"];
    [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"accountType"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    [paraDic setObject:[NSNumber numberWithInt:[AppGroup getCurrentDate]] forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.telephoneNum,[[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:CheckUser paraDic:paraDic delegate:delegate];
    self.currentApiName = CheckUser;
    
}

- (void) smsCodeLoginRequest{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    self.telephoneNum = [self.textFieldOfTelephone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [paraDic setObject:self.telephoneNum forKey:@"mobile"];
    [paraDic setObject:self.textFieldOfCode.text forKey:@"smsCode"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    int currentReqtime = [AppGroup getCurrentDate];
    [paraDic setObject:[NSNumber numberWithInt:currentReqtime] forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.telephoneNum,
                                                           [[DataManager lightData] readSkey],
                                                           self.textFieldOfCode.text,
                                                           [NSNumber numberWithInt:currentReqtime]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:SmsCodeLogin paraDic:paraDic delegate:delegate];
    self.currentApiName = SmsCodeLogin;
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    /**退出控制器时对定时器的处理*/
    [self initializeTimer];
}
@end
