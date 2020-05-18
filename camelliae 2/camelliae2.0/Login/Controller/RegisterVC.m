//
//  RegisterVC.m
//  camelliae2.0
//
//  Created by 张越 on 16/5/24.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "RegisterVC.h"
#import "VCManger.h"
#import "HomeVC.h"
//#import "HyLoglnButton.h"
#import "LoginUserObj.h"
#import "PerfectInfoVC.h"
#import <UMAnalytics/MobClick.h>
#import "AppDelegate.h"
#import "CMLSettingDetailVC.h"


#define RegisterVCTopImageHeight                 360
#define RegisterVCOneLineLength                  630
#define RegisterVCThreeLineLength                220
#define RegisterVCUserOfOneLineOrginX            30
#define RegisterVCUserOfOneLineMaxY              20
#define RegisterVCTwoLineOfOneLineOrginY         140
#define RegisterVCLoginBtnHeight                 60
#define RegisterVCLoginBtnTopMargin              80
#define RegisterVCForgetBtnTopMargin             20
#define RegisterVCLineAndLabelSpace              30
#define RegisterVCregisterBtnAndLastLineSpace    6
#define RegisterVCLastLineBottomSpace            40
#define RegistrVCTeleInputLeftMargin             40
#define RegisterVCLineLeftMargin                 75


@interface RegisterVC ()<NetWorkProtocol,UITextFieldDelegate>

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,copy) NSString *telephoneNum;

@property (nonatomic,copy) NSString *code;

@property (nonatomic,copy) NSString *smsCode;

@property (nonatomic,strong) UITextField *textFieldOfTelephone;

@property (nonatomic,strong) UITextField *textFieldOfCode;

@property (nonatomic,strong) UITextField *textFieldOfsmsCode;

@property (nonatomic,assign) NSInteger oldtextLength;

@property (nonatomic,strong) UIButton *registerBtn;

@property (nonatomic,strong) UIButton *postSmsCodeBtn;

@property (nonatomic,strong) UIButton *loginBtn;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) int currentSeconds;

@property (nonatomic,strong) UILabel *promptLabel;

@property (nonatomic, strong) UIButton *agreeButton;

@property (nonatomic, assign) BOOL isSelected;

@end

@implementation RegisterVC

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    /**退出控制器时对定时器的处理*/
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.navBar.hidden = YES;
    self.oldtextLength  = 0;
    self.currentSeconds = 60;
    self.isSelected = YES;
    /***************************/
    
    [self loadViews];
}


#pragma mark - keyboardWasShown
- (void) keyboardWasShown:(NSNotification*) noti{
    
    NSDictionary *info = [noti userInfo];
    
    //获取高度
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    
    CGSize keyboardSize = [value CGRectValue].size;
    
    self.contentView.center = CGPointMake(self.contentView.center.x, self.view.center.y - keyboardSize.height/2.0);
    
}

- (void) keyboardWillBeHidden{
    
    self.contentView.center = self.view.center;
    
}

- (void) loadViews{
    
    
    /**logo*/
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                              0,
                                                                              WIDTH,
                                                                              RegisterVCTopImageHeight*Proportion)];
    topImageView.backgroundColor = [UIColor CMLYellowColor];
    topImageView.clipsToBounds = YES;
    topImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:topImageView];
    
    if ([[DataManager lightData] readLoginBannerImageUlr].length > 0 ) {
        
        [NetWorkTask setImageView:topImageView WithURL:[[DataManager lightData] readLoginBannerImageUlr] placeholderImage:nil];
        
    }else{
        
        topImageView.image = [UIImage imageNamed:LaunchBannerImg];
    }
    
    /**promptLbale*/
    UILabel *styleNamelabel = [[UILabel alloc] init];
    styleNamelabel.font = KSystemFontSize15;
    styleNamelabel.textColor = [UIColor CMLBlackColor];
    styleNamelabel.text = @"新用户注册";
    [styleNamelabel sizeToFit];
    styleNamelabel.frame = CGRectMake(60*Proportion, CGRectGetMaxY(topImageView.frame) + 40*Proportion, styleNamelabel.frame.size.width, styleNamelabel.frame.size.height);
    [self.contentView addSubview:styleNamelabel];
    
    /**first line*/
    CMLLine *oneLine = [[CMLLine alloc] init];
    oneLine.startingPoint = CGPointMake(self.view.center.x - RegisterVCOneLineLength*Proportion/2.0, CGRectGetMaxY(styleNamelabel.frame) +  140*Proportion);
    oneLine.directionOfLine = HorizontalLine;
    oneLine.lineWidth = 1;
    oneLine.lineLength = RegisterVCOneLineLength*Proportion;
    oneLine.LineColor = [UIColor CMLPromptGrayColor];
    [self.contentView addSubview:oneLine];
    
    /********提示语*********/
    self.promptLabel = [[UILabel alloc] init];
    self.promptLabel.font = KSystemFontSize10;
    self.promptLabel.text = @"该账号已注册，直接登录吧！";
    self.promptLabel.textColor = [UIColor CMLRedColor];
    [self.promptLabel sizeToFit];
    self.promptLabel.frame = CGRectMake(oneLine.startingPoint.x,
                                        oneLine.startingPoint.y + 10*Proportion,
                                        self.promptLabel.frame.size.width,
                                        self.promptLabel.frame.size.height);
    [self.contentView addSubview:self.promptLabel];
    self.promptLabel.hidden = YES;
    /*****************/
    
    
    UIImageView *userIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:LoginVCUser]];
    userIcon.contentMode = UIViewContentModeScaleAspectFit;
    userIcon.frame = CGRectMake(oneLine.startingPoint.x,
                                oneLine.startingPoint.y - RegisterVCUserOfOneLineMaxY*Proportion - userIcon.frame.size.height,
                                userIcon.frame.size.width,
                                userIcon.frame.size.height);
    [self.contentView addSubview:userIcon];
    
    self.textFieldOfTelephone = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userIcon.frame) + RegistrVCTeleInputLeftMargin*Proportion,
                                                                              userIcon.frame.origin.y - RegisterVCUserOfOneLineMaxY*Proportion,
                                                                              RegisterVCOneLineLength*Proportion - RegisterVCUserOfOneLineOrginX*Proportion - CGRectGetWidth(userIcon.frame) - RegistrVCTeleInputLeftMargin*Proportion,
                                                                              CGRectGetHeight(userIcon.frame) + 2*RegisterVCUserOfOneLineMaxY*Proportion)];
    self.textFieldOfTelephone.keyboardType = UIKeyboardTypeNumberPad;
    self.textFieldOfTelephone.textAlignment = NSTextAlignmentLeft;
    self.textFieldOfTelephone.placeholder = @"请输入手机号";
    self.textFieldOfTelephone.font = KSystemFontSize14;
    self.textFieldOfTelephone.delegate = self;
    self.textFieldOfTelephone.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.textFieldOfTelephone addTarget:self action:@selector(inputTelephoneNum) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:self.textFieldOfTelephone];
    
    /**second line*/
    CMLLine *twoLine = [[CMLLine alloc] init];
    twoLine.startingPoint = CGPointMake(oneLine.startingPoint.x, oneLine.startingPoint.y + RegisterVCTwoLineOfOneLineOrginY*Proportion);
    twoLine.directionOfLine = HorizontalLine;
    twoLine.lineWidth = 1;
    twoLine.lineLength = RegisterVCOneLineLength*Proportion;
    twoLine.LineColor = [UIColor CMLPromptGrayColor];
    [self.contentView addSubview:twoLine];
    
    UIImageView *smsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MesCodeImg]];
    smsIcon.contentMode = UIViewContentModeScaleAspectFit;
    smsIcon.frame = CGRectMake(oneLine.startingPoint.x,
                               twoLine.startingPoint.y - RegisterVCUserOfOneLineMaxY*Proportion - smsIcon.frame.size.height,
                               smsIcon.frame.size.width,
                               smsIcon.frame.size.height);
    [self.contentView addSubview:smsIcon];
    
    /**发送验证码*/
    self.postSmsCodeBtn = [[UIButton alloc] init];
    [self.postSmsCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.postSmsCodeBtn.titleLabel.font = KSystemFontSize12;
    [self.postSmsCodeBtn sizeToFit];
    self.postSmsCodeBtn.backgroundColor = [UIColor CMLNewGrayColor];
    [self.postSmsCodeBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    self.postSmsCodeBtn.frame = CGRectMake(WIDTH - 40*Proportion - self.postSmsCodeBtn.frame.size.width - twoLine.startingPoint.x,
                                           twoLine.startingPoint.y - 52*Proportion - 20*Proportion,
                                           self.postSmsCodeBtn.frame.size.width + 40*Proportion,
                                           52*Proportion);
    self.postSmsCodeBtn.layer.cornerRadius = 52*Proportion/2.0;
    [self.postSmsCodeBtn addTarget:self action:@selector(postCheckRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.postSmsCodeBtn];

    
    /**验证码输入框*/
    self.textFieldOfsmsCode = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(smsIcon.frame) + RegistrVCTeleInputLeftMargin*Proportion,
                                                                            smsIcon.frame.origin.y - RegisterVCUserOfOneLineMaxY*Proportion,
                                                                            RegisterVCOneLineLength*Proportion - 3*RegisterVCUserOfOneLineOrginX*Proportion - CGRectGetWidth(smsIcon.frame) - self.postSmsCodeBtn.frame.size.width - RegistrVCTeleInputLeftMargin*Proportion,
                                                                            CGRectGetHeight(smsIcon.frame) + 2*RegisterVCUserOfOneLineMaxY*Proportion)];
    self.textFieldOfsmsCode.keyboardType = UIKeyboardTypeNumberPad;
    self.textFieldOfsmsCode.textAlignment = NSTextAlignmentLeft;
    self.textFieldOfsmsCode.placeholder = @"请输入验证码";
    self.textFieldOfsmsCode.font = KSystemFontSize14;
    self.textFieldOfsmsCode.delegate = self;
    [self.contentView addSubview:self.textFieldOfsmsCode];
    
    
    /**third line*/
    CMLLine *threeLine = [[CMLLine alloc] init];
    threeLine.startingPoint = CGPointMake(oneLine.startingPoint.x, twoLine.startingPoint.y + RegisterVCTwoLineOfOneLineOrginY*Proportion);
    threeLine.directionOfLine = HorizontalLine;
    threeLine.lineWidth = 1;
    threeLine.lineLength = RegisterVCOneLineLength*Proportion;
    threeLine.LineColor = [UIColor CMLPromptGrayColor];
    [self.contentView addSubview:threeLine];
    
    UIImageView *codeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:LoginVCCode]];
    codeIcon.contentMode = UIViewContentModeScaleAspectFit;
    codeIcon.frame = CGRectMake(oneLine.startingPoint.x,
                                threeLine.startingPoint.y - 20*Proportion - codeIcon.frame.size.height,
                                codeIcon.frame.size.width,
                                codeIcon.frame.size.height);
    [self.contentView addSubview:codeIcon];
    
    
    self.textFieldOfCode = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(codeIcon.frame) + RegistrVCTeleInputLeftMargin*Proportion,
                                                                              codeIcon.frame.origin.y - RegisterVCUserOfOneLineMaxY*Proportion,
                                                                              RegisterVCOneLineLength*Proportion - RegisterVCUserOfOneLineOrginX*Proportion - CGRectGetWidth(codeIcon.frame) - RegistrVCTeleInputLeftMargin*Proportion,
                                                                              CGRectGetHeight(codeIcon.frame) + 2*RegisterVCUserOfOneLineMaxY*Proportion)];
    self.textFieldOfCode.textAlignment = NSTextAlignmentLeft;
    self.textFieldOfCode.placeholder = @"请输入密码(不能低于6位)";
    self.textFieldOfCode.font = KSystemFontSize14;
    self.textFieldOfCode.delegate = self;
    self.textFieldOfCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.contentView addSubview:self.textFieldOfCode];
    
    /**注册键*/
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                                 0,
                                                                                 RegisterVCOneLineLength*Proportion ,
                                                                                 RegisterVCLoginBtnHeight*Proportion)];
    registerBtn.backgroundColor = [UIColor CMLBlackColor];
    registerBtn.layer.cornerRadius = RegisterVCLoginBtnHeight*Proportion/2.0;
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = KSystemFontSize15;
    registerBtn.titleLabel.textColor = [UIColor whiteColor];
    registerBtn.center = CGPointMake(self.view.center.x,CGRectGetMaxY(styleNamelabel.frame) +  140*Proportion + 2*RegisterVCTwoLineOfOneLineOrginY*Proportion+RegisterVCLoginBtnTopMargin*Proportion + RegisterVCLoginBtnHeight*Proportion/2.0);
    self.registerBtn = registerBtn;
    [self.contentView addSubview:registerBtn];
    [self.registerBtn addTarget:self action:@selector(registerButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    
    /**登录界面*/
    self.loginBtn = [[UIButton alloc] init];
    NSString *loginStr = @"已经有账号了？去登录！";
    CGSize loginSize = [loginStr sizeWithFontCompatible:KSystemFontSize12];
    self.loginBtn.titleLabel.font = KSystemFontSize12;
    [self.loginBtn setTitle:loginStr forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    self.loginBtn.frame = CGRectMake(WIDTH/2.0 - loginSize.width/2.0,
                                     CGRectGetMaxY(registerBtn.frame) + 30*Proportion,
                                     loginSize.width,
                                     loginSize.height);
    [self.loginBtn addTarget:self action:@selector(enterLoginVC) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.loginBtn];
    
    CMLLine *lastLine = [[CMLLine alloc] init];
    lastLine.startingPoint = CGPointMake(self.loginBtn.frame.origin.x, CGRectGetMaxY(self.loginBtn.frame) + RegisterVCregisterBtnAndLastLineSpace*Proportion);
    lastLine.lineWidth = 1;
    lastLine.lineLength = loginSize.width;
    lastLine.LineColor = [UIColor CMLPromptGrayColor];
    lastLine.directionOfLine = HorizontalLine;
    [self.contentView addSubview:lastLine];
    
    /*用户协议-隐私条款*/
    UILabel *readLabel = [[UILabel alloc] init];
    readLabel.backgroundColor = [UIColor clearColor];
    readLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
    readLabel.text = @"我已阅读并同意";
    readLabel.textColor = [UIColor CMLGray515151Color];
    [self.contentView addSubview:readLabel];
    
    UIButton *agreementButton = [[UIButton alloc] init];
    agreementButton.backgroundColor = [UIColor clearColor];
    [agreementButton setTitle:@"《用户协议》" forState:UIControlStateNormal];
    [agreementButton setTitleColor:[UIColor CMLE5C48AColor] forState:UIControlStateNormal];
    [agreementButton.titleLabel setFont:[UIFont systemFontOfSize:11 weight:UIFontWeightRegular]];
    [self.contentView addSubview:agreementButton];
    
    UIButton *policyButton = [[UIButton alloc] init];
    policyButton.backgroundColor = [UIColor clearColor];
    [policyButton setTitle:@"《隐私条款》" forState:UIControlStateNormal];
    [policyButton setTitleColor:[UIColor CMLE5C48AColor] forState:UIControlStateNormal];
    [policyButton.titleLabel setFont:[UIFont systemFontOfSize:11 weight:UIFontWeightRegular]];
    [self.contentView addSubview:policyButton];
    
    [self.contentView addSubview:self.agreeButton];
    
    [self.agreeButton sizeToFit];
    [readLabel sizeToFit];
    [agreementButton sizeToFit];
    [policyButton sizeToFit];
    
    CGFloat length = CGRectGetWidth(self.agreeButton.frame) + CGRectGetWidth(readLabel.frame) + CGRectGetWidth(agreementButton.frame) + CGRectGetWidth(policyButton.frame) + 6 * Proportion;
    
    self.agreeButton.frame = CGRectMake(WIDTH/2 - length/2,
                                        HEIGHT - SafeAreaBottomHeight - CGRectGetHeight(self.agreeButton.frame) - 70 * Proportion,
                                        CGRectGetWidth(self.agreeButton.frame),
                                        CGRectGetHeight(self.agreeButton.frame));
    readLabel.frame = CGRectMake(CGRectGetMaxX(self.agreeButton.frame) + 6 * Proportion,
                                 CGRectGetMidY(self.agreeButton.frame) - CGRectGetHeight(readLabel.frame)/2,
                                 CGRectGetWidth(readLabel.frame),
                                 CGRectGetHeight(readLabel.frame));
    agreementButton.frame = CGRectMake(CGRectGetMaxX(readLabel.frame),
                                       CGRectGetMidY(self.agreeButton.frame) - CGRectGetHeight(agreementButton.frame)/2,
                                       CGRectGetWidth(agreementButton.frame),
                                       CGRectGetHeight(agreementButton.frame));
    policyButton.frame = CGRectMake(CGRectGetMaxX(agreementButton.frame),
                                    CGRectGetMinY(agreementButton.frame),
                                    CGRectGetWidth(policyButton.frame),
                                    CGRectGetHeight(policyButton.frame));
    
    [self.agreeButton addTarget:self action:@selector(agreeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [agreementButton addTarget:self action:@selector(agreementButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [policyButton addTarget:self action:@selector(policyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 用户协议
- (void)agreeButtonClicked {
    if (self.isSelected) {
        self.isSelected = NO;
        self.agreeButton.selected = YES;
    }else {
        self.isSelected = YES;
        self.agreeButton.selected = NO;
    }
}

- (void)agreementButtonClicked {
    CMLSettingDetailVC *vc = [[CMLSettingDetailVC alloc] initWithTitle:@"用户协议"];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void)policyButtonClicked {
    CMLSettingDetailVC *vc = [[CMLSettingDetailVC alloc] initWithTitle:@"服务及隐私条款"];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) setTelephoneRegisterRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    self.telephoneNum = [self.textFieldOfTelephone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [paraDic setObject:self.telephoneNum forKey:@"mobile"];
    [paraDic setObject:self.textFieldOfsmsCode.text forKey:@"smsCode"];
    [paraDic setObject:[NSString getEncryptStringfrom:@[self.textFieldOfCode.text]] forKey:@"password"];
    [paraDic setObject:[NSNumber numberWithInt:[AppGroup getCurrentDate]] forKey:@"reqTime"];
    [paraDic setObject:[NSNumber numberWithInt:0] forKey:@"inviteCode"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.telephoneNum,[[DataManager lightData] readSkey],self.textFieldOfsmsCode.text,self.textFieldOfCode.text]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:TelephoneLogin paraDic:paraDic delegate:delegate];
    self.currentApiName = TelephoneLogin;
    
}

#pragma mark - 检验手机号
- (void) postCheckRequest{
    
    [self.textFieldOfTelephone resignFirstResponder];
    [self.textFieldOfCode resignFirstResponder];
    [self.textFieldOfsmsCode resignFirstResponder];

    self.telephoneNum = [self.textFieldOfTelephone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.isNetError) {
        
        [appDelegate setAppStartMes];
        [self stopIndicatorLoading];
        
    }else {
        if ([self.telephoneNum valiMobile]) {
            
            /**请求*/
            NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
            delegate.delegate = self;
            
            NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
            [paraDic setObject:self.telephoneNum forKey:@"account"];
            [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"accountType"];
            [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
            [paraDic setObject:[NSNumber numberWithInt:[AppGroup getCurrentDate]] forKey:@"reqTime"];
            NSString *hashToken = [NSString getEncryptStringfrom:@[self.telephoneNum,[[DataManager lightData] readSkey]]];
            [paraDic setObject:hashToken forKey:@"hashToken"];
            [NetWorkTask postResquestWithApiName:CheckUser paraDic:paraDic delegate:delegate];
            self.currentApiName = CheckUser;
            
            [self startIndicatorLoading];
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                          target:self
                                                        selector:@selector(readSeconds)
                                                        userInfo:nil
                                                         repeats:YES];
            
        }else{
            
            [self showFailTemporaryMes:@"输入手机号有误"];
        }
    }

}
- (void) postSmsRequest{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    self.telephoneNum = [self.textFieldOfTelephone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [paraDic setObject:self.telephoneNum forKey:@"mobile"];
    [paraDic setObject:[NSNumber numberWithInt:10003] forKey:@"reqType"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    [paraDic setObject:[NSNumber numberWithInt:[AppGroup getCurrentDate]] forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.telephoneNum,[NSNumber numberWithInt:10003],[[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:MessageVerify paraDic:paraDic delegate:delegate];
    self.currentApiName = MessageVerify;
    
}

#pragma mark - 手机号输入限制
- (void) inputTelephoneNum{
    
    if (self.textFieldOfTelephone.text.length >13) {
        
        /**控制输入长度*/
        NSMutableString *tempPhoneNum = [NSMutableString stringWithFormat:@"%@",self.textFieldOfTelephone.text];
        self.textFieldOfTelephone.text = [tempPhoneNum substringToIndex:13];
        
    }else{
        if (self.oldtextLength < self.textFieldOfTelephone.text.length) {
            
            if ((self.textFieldOfTelephone.text.length == 3) || (self.textFieldOfTelephone.text.length == 8)) {
                
                self.textFieldOfTelephone.text = [NSString stringWithFormat:@"%@ ",self.textFieldOfTelephone.text];
            }
        }
        self.oldtextLength = self.textFieldOfTelephone.text.length;
    }
}

- (void)registerButtonClicked {
    if (self.isSelected) {
        [self postRegistereRequest];
    }else {
        [SVProgressHUD showErrorWithStatus:@"请先阅读并同意《用户协议》与《隐私条款》"];
    }
}

#pragma mark - postLoginRequest
- (void) postRegistereRequest{
    
    /**放弃第一响应者*/
    [self.textFieldOfTelephone resignFirstResponder];
    [self.textFieldOfCode resignFirstResponder];
    [self.textFieldOfsmsCode resignFirstResponder];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.isNetError) {
        
        [appDelegate setAppStartMes];
        [self stopIndicatorLoading];
        
    }else {
        if ([self.telephoneNum valiMobile]) {
            
            if (self.textFieldOfCode.text.length >= 6) {
                
                if (self.textFieldOfsmsCode.text.length > 0) {
                    
                    /**发送注册请求*/
                    [self setTelephoneRegisterRequest];
                    
                }else{
                    
                    [self showFailTemporaryMes:@"请输入验证码"];
//                    [self.registerBtn ErrorRevertAnimationCompletion:nil];
                }
                
            }else{
                
                [self showFailTemporaryMes:@"密码不能少于6位数"];
//                [self.registerBtn ErrorRevertAnimationCompletion:nil];
            }
            
        }else{
            [self showFailTemporaryMes:@"手机号输入有误"];
//            [self.registerBtn ErrorRevertAnimationCompletion:nil];
        }
    }

}

#pragma mark - enterGetCodeVC
- (void) enterLoginVC{
    
    [[VCManger mainVC] dismissCurrentVCWithAnimate:NO];
    
}
#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:CheckUser]) {
        
        [self stopIndicatorLoading];
        /**电话请求*/
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 100302 && obj) {
            /**发送验证码请求*/
            [self postSmsRequest];
            
        }else if ([obj.retCode intValue] == 0 && obj){
        
            self.promptLabel.hidden = NO;
            [self performSelector:@selector(hiddenPromptLabel) withObject:nil afterDelay:3.0f];
            [self initTimer];
        }else{
            [self showFailTemporaryMes:obj.retMsg];
            [self initTimer];
        }
        
    }else if ([self.currentApiName isEqualToString:MessageVerify]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        [self stopIndicatorLoading];
        
        if ([obj.retCode intValue] == 0 && obj) {
            [self showSuccessTemporaryMes:@"验证码已发送"];
            [self.textFieldOfsmsCode becomeFirstResponder];
            
            
        }else{
            
            [self showFailTemporaryMes:obj.retMsg];
            [self initTimer];
        }
    }else{
    
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0 && obj) {
            
            /**帐号统计*/
            [MobClick profileSignInWithPUID:[NSString stringWithFormat:@"%@",obj.retData.user.uid]];
            
            
            [self saveUserInfo:obj];
//            typeof(self) __weak weak = self;
//            [self.registerBtn ExitAnimationCompletion:^{
                [self enterPerfectInfoVC];
//            }];
            
        }else{
//            [self.registerBtn ErrorRevertAnimationCompletion:nil];
            [self showFailTemporaryMes:obj.retMsg];
        }
        
        [self initTimer];
    }
    [self stopIndicatorLoading];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self initTimer];
//    [self.registerBtn ErrorRevertAnimationCompletion:nil];
    [self showFailTemporaryMes:@"网络连接失败"];
    [self stopIndicatorLoading];
    
}



#pragma mark - UITextViewDelegate


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    /**键盘放弃第一响应者*/
    [self.textFieldOfTelephone resignFirstResponder];
    [self.textFieldOfCode resignFirstResponder];
    [self.textFieldOfsmsCode resignFirstResponder];
    
}


#pragma mark - 信息存储
- (void) saveUserInfo:(BaseResultObj *)obj{
    
    [[DataManager lightData] saveSkey:obj.retData.skey];
    [DataManager saveSkey:obj.retData.skey];
    [[DataManager lightData] saveUser:obj];
    
}

#pragma mark - 判断是否可登录
- (void)judgeRegister{
    
    if ((self.textFieldOfTelephone.text.length == 13) && (self.textFieldOfCode.text.length > 0) && (self.textFieldOfsmsCode.text.length > 0)) {
        self.registerBtn.userInteractionEnabled = YES;
    }else{
        self.registerBtn.userInteractionEnabled = NO;
    }
    
    /**判断是否可以发送验证码的请求*/
    if (self.textFieldOfTelephone.text.length == 13) {
        
        if (self.currentSeconds == 60) {
           self.postSmsCodeBtn.userInteractionEnabled = YES;
        }
    }else{
        
        self.postSmsCodeBtn.userInteractionEnabled = NO;
    }
}

- (void) readSeconds{

    self.currentSeconds--;
    
    if (self.currentSeconds == 0) {
        [self initTimer];
        
    }else{
         self.postSmsCodeBtn.userInteractionEnabled = NO;
         [self.postSmsCodeBtn setTitle:[NSString stringWithFormat:@"%d s",self.currentSeconds] forState:UIControlStateNormal];
    }
}

#pragma mark -  初始化timer
- (void) initTimer{

    self.postSmsCodeBtn.userInteractionEnabled = YES;
    [self.timer invalidate];
    self.timer = nil;
    self.currentSeconds = 60;
    [self.postSmsCodeBtn setTitle:@"发送验证码"forState:UIControlStateNormal];
    self.postSmsCodeBtn.userInteractionEnabled = YES;
    self.textFieldOfTelephone.userInteractionEnabled = YES;
}

#pragma mark - enterPerfectInfoVC
- (void) enterPerfectInfoVC{
    
    PerfectInfoVC *vc = [[PerfectInfoVC alloc] init];
    vc.isNormalRegisterStyle = YES;
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

- (void) hiddenPromptLabel{
    self.promptLabel.hidden = YES;
}

- (UIButton *)agreeButton {
    if (!_agreeButton) {
        _agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeButton.backgroundColor = [UIColor clearColor];
        [_agreeButton setImage:[UIImage imageNamed:CMLCheckButtonSelectImg] forState:UIControlStateNormal];
        [_agreeButton setImage:[UIImage imageNamed:CMLCheckButtonNoSelectImg] forState:UIControlStateSelected];
    }
    return _agreeButton;
}

@end
