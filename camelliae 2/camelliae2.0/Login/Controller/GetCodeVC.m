//
//  GetCodeVC.m
//  camelliae2.0
//
//  Created by 张越 on 16/5/22.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "GetCodeVC.h"
#import "VCManger.h"
#import "HomeVC.h"
#import "HyLoglnButton.h"
#import "LoginUserObj.h"
#import <UMAnalytics/MobClick.h>
#import "NSString+CMLExspand.h"

#define GetCodeVCTopImageHeight                 360
#define GetCodeVCOneLineLength                  630
#define GetCodeVCUserOfOneLineOrginX            30
#define GetCodeVCUserOfOneLineMaxY              20
#define GetCodeVCTwoLineOfOneLineOrginY         140
#define GetCodeVCLoginBtnHeight                 60
#define GetCodeVCLoginBtnTopMargin              80
#define GetCodeVCForgetBtnTopMargin             20
#define GetCodeVCLineAndLabelSpace              30
#define GetCodeVCregisterBtnAndLastLineSpace    6
#define GetCodeVCLineLeftMargin                 75

@interface GetCodeVC ()<NetWorkProtocol,UITextFieldDelegate>

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,copy) NSString *telephoneNum;

@property (nonatomic,copy) NSString *code;

@property (nonatomic,copy) NSString *smsCode;

@property (nonatomic,strong) UITextField *textFieldOfTelephone;

@property (nonatomic,strong) UITextField *textFieldOfCode;

@property (nonatomic,strong) UITextField *textFieldOfsmsCode;

@property (nonatomic,assign) NSInteger oldtextLength;

@property (nonatomic,strong) HyLoglnButton *registerBtn;

@property (nonatomic,strong) UIButton *postSmsCodeBtn;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) int currentSeconds;

@end

@implementation GetCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.navBar.hidden = YES;
    self.oldtextLength  = 0;
    self.currentSeconds = 60;
    
    [self loadViews];
}

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

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    /**退出控制器时对定时器的处理*/
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - 调整content的高度
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
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor CMLPromptGrayColor];
    imageView.frame = CGRectMake(0,
                                 0,
                                 WIDTH,
                                 GetCodeVCTopImageHeight*Proportion);
    [self.contentView addSubview:imageView];
    
    if ([[DataManager lightData] readLoginBannerImageUlr].length > 0 ) {
        
        [NetWorkTask setImageView:imageView WithURL:[[DataManager lightData] readLoginBannerImageUlr] placeholderImage:nil];
        
    }else{
        
        imageView.image = [UIImage imageNamed:LaunchBannerImg];
    }
    
    /**backBtn*/
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                   StatusBarHeight,
                                                                   NavigationBarHeight,
                                                                   NavigationBarHeight)];
    [leftBtn setImage:[UIImage imageNamed:NavcBackBtnImg] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(dismissCurrentVC) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:leftBtn];
    
    /**promptLabel*/
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"重新设置密码";
    nameLabel.textColor = [UIColor CMLBlackColor];
    nameLabel.font = KSystemFontSize15;
    [nameLabel sizeToFit];
    nameLabel.frame = CGRectMake(60*Proportion,
                                 CGRectGetMaxY(imageView.frame) + 40*Proportion,
                                 nameLabel.frame.size.width,
                                 nameLabel.frame.size.height);
    [self.contentView addSubview:nameLabel];
    
    /**first line*/
    CMLLine *oneLine = [[CMLLine alloc] init];
    oneLine.startingPoint = CGPointMake(self.view.center.x - GetCodeVCOneLineLength*Proportion/2.0,GetCodeVCTwoLineOfOneLineOrginY*Proportion + CGRectGetMaxY(nameLabel.frame));
    oneLine.directionOfLine = HorizontalLine;
    oneLine.lineWidth = 1;
    oneLine.lineLength = GetCodeVCOneLineLength*Proportion;
    oneLine.LineColor = [UIColor CMLPromptGrayColor];
    [self.contentView addSubview:oneLine];
    
    
    /**account*/
    UIImageView *userIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:LoginVCUser]];
    userIcon.contentMode = UIViewContentModeScaleAspectFit;
    userIcon.frame = CGRectMake(oneLine.startingPoint.x,
                                oneLine.startingPoint.y - userIcon.frame.size.height - 20*Proportion,
                                userIcon.frame.size.width,
                                userIcon.frame.size.height);
    [self.contentView addSubview:userIcon];
    
    self.textFieldOfTelephone = [[UITextField alloc] initWithFrame:CGRectMake(oneLine.startingPoint.x + userIcon.frame.size.width + GetCodeVCUserOfOneLineOrginX*Proportion,
                                                                              userIcon.frame.origin.y - 20*Proportion,
                                                                              GetCodeVCOneLineLength*Proportion - userIcon.frame.size.width - GetCodeVCUserOfOneLineOrginX*Proportion,
                                                                              userIcon.frame.size.height + 2*GetCodeVCUserOfOneLineMaxY*Proportion)];
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
    twoLine.startingPoint = CGPointMake(oneLine.startingPoint.x, oneLine.startingPoint.y + GetCodeVCTwoLineOfOneLineOrginY*Proportion);
    twoLine.directionOfLine = HorizontalLine;
    twoLine.lineWidth = 1;
    twoLine.lineLength = GetCodeVCOneLineLength*Proportion;
    twoLine.LineColor = [UIColor CMLPromptGrayColor];
    [self.contentView addSubview:twoLine];
    
    
    UIImageView *smsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MesCodeImg]];
    smsIcon.contentMode = UIViewContentModeScaleAspectFit;
    smsIcon.frame = CGRectMake(oneLine.startingPoint.x,
                               twoLine.startingPoint.y - smsIcon.frame.size.height - 20*Proportion,
                               smsIcon.frame.size.width,
                               smsIcon.frame.size.height);
    [self.contentView addSubview:smsIcon];
    
    /**smsCode*/
    self.postSmsCodeBtn = [[UIButton alloc] init];
    [self.postSmsCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.postSmsCodeBtn.titleLabel.font = KSystemFontSize12;
    [self.postSmsCodeBtn sizeToFit];
    self.postSmsCodeBtn.backgroundColor = [UIColor CMLNewGrayColor];
    [self.postSmsCodeBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    
    self.postSmsCodeBtn.frame = CGRectMake(WIDTH - 40*Proportion - self.postSmsCodeBtn.frame.size.width - oneLine.startingPoint.x,
                                           twoLine.startingPoint.y - 52*Proportion - GetCodeVCUserOfOneLineMaxY*Proportion,
                                           self.postSmsCodeBtn.frame.size.width + 40*Proportion,
                                           52*Proportion);
    self.postSmsCodeBtn.layer.cornerRadius = 52*Proportion/2.0;
    [self.postSmsCodeBtn addTarget:self action:@selector(postCheckRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.postSmsCodeBtn];
    
    
    self.textFieldOfsmsCode = [[UITextField alloc] initWithFrame:CGRectMake(twoLine.startingPoint.x + smsIcon.frame.size.width + GetCodeVCUserOfOneLineOrginX*Proportion,
                                                                            smsIcon.frame.origin.y - 20*Proportion,
                                                                            self.textFieldOfTelephone.frame.size.width - self.postSmsCodeBtn.frame.size.width,
                                                                            self.textFieldOfTelephone.frame.size.height)];
    self.textFieldOfsmsCode.keyboardType = UIKeyboardTypeNumberPad;
    self.textFieldOfsmsCode.textAlignment = NSTextAlignmentLeft;
    self.textFieldOfsmsCode.placeholder = @"请输入验证码";
    self.textFieldOfsmsCode.font = KSystemFontSize14;
    self.textFieldOfsmsCode.delegate = self;
    [self.contentView addSubview:self.textFieldOfsmsCode];
    
    
    /**third line*/
    CMLLine *threeLine = [[CMLLine alloc] init];
    threeLine.startingPoint = CGPointMake(oneLine.startingPoint.x, twoLine.startingPoint.y + GetCodeVCTwoLineOfOneLineOrginY*Proportion);
    threeLine.directionOfLine = HorizontalLine;
    threeLine.lineWidth = 1;
    threeLine.lineLength = GetCodeVCOneLineLength*Proportion;
    threeLine.LineColor = [UIColor CMLPromptGrayColor];
    [self.contentView addSubview:threeLine];
    
    
    UIImageView *codeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:LoginVCCode]];
    codeIcon.contentMode = UIViewContentModeScaleAspectFit;
    codeIcon.frame = CGRectMake(oneLine.startingPoint.x,
                                  threeLine.startingPoint.y - 20*Proportion - codeIcon.frame.size.height,
                                  codeIcon.frame.size.width,
                                  codeIcon.frame.size.height);
    [self.contentView addSubview:codeIcon];
    
    
    self.textFieldOfCode = [[UITextField alloc] initWithFrame:CGRectMake(threeLine.startingPoint.x + codeIcon.frame.size.width +  GetCodeVCUserOfOneLineOrginX*Proportion,
                                                                         codeIcon.frame.origin.y - 20*Proportion,
                                                                         self.textFieldOfTelephone.frame.size.width,
                                                                         self.textFieldOfTelephone.frame.size.height)];
    self.textFieldOfCode.textAlignment = NSTextAlignmentLeft;
    self.textFieldOfCode.placeholder = @"请输入密码(不能低于6位)";
    self.textFieldOfCode.font = KSystemFontSize14;
    self.textFieldOfCode.delegate = self;
    self.textFieldOfCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.contentView addSubview:self.textFieldOfCode];
    
    
    /***/
    HyLoglnButton *registerBtn = [[HyLoglnButton alloc] initWithFrame:CGRectMake(WIDTH/2.0 - GetCodeVCOneLineLength*Proportion/2.0,
                                                                                 threeLine.startingPoint.y + 60*Proportion,
                                                                                 GetCodeVCOneLineLength*Proportion ,
                                                                                 GetCodeVCLoginBtnHeight*Proportion)];
    registerBtn.backgroundColor = [UIColor CMLBlackColor];
    registerBtn.layer.cornerRadius = GetCodeVCLoginBtnHeight*Proportion/2.0;
    [registerBtn setTitle:@"完成" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = KSystemFontSize15;
    registerBtn.titleLabel.textColor = [UIColor whiteColor];
    self.registerBtn = registerBtn;
    [self.contentView addSubview:registerBtn];
    [self.registerBtn addTarget:self action:@selector(postfinsihedRequest) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.telephoneNum,
                                                           [[DataManager lightData] readSkey],
                                                           @"0",
                                                           self.textFieldOfCode.text]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:TelephoneLogin paraDic:paraDic delegate:delegate];
    self.currentApiName = TelephoneLogin;
    
}

#pragma mark - 验证手机号
- (void) postCheckRequest{
    
    [self.textFieldOfTelephone resignFirstResponder];
    [self.textFieldOfCode resignFirstResponder];
    [self.textFieldOfsmsCode resignFirstResponder];
    
    self.telephoneNum = [self.textFieldOfTelephone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([self.telephoneNum valiMobile]) {
     
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
        
        /**定时器*/
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(readSeconds)
                                                    userInfo:nil
                                                     repeats:YES];
        
        
    }else{
    
        [self showFailTemporaryMes:@"手机号输入有误"];
    }
    
}
- (void) postSmsRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    self.telephoneNum = [self.textFieldOfTelephone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [paraDic setObject:self.telephoneNum forKey:@"mobile"];
    [paraDic setObject:[NSNumber numberWithInt:10005] forKey:@"reqType"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    [paraDic setObject:[NSNumber numberWithInt:[AppGroup getCurrentDate]] forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.telephoneNum,
                                                           [NSNumber numberWithInt:10005],
                                                           [[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:MessageVerify paraDic:paraDic delegate:delegate];
    self.currentApiName = MessageVerify;
    
}

#pragma mark - postLoginRequest
- (void) postfinsihedRequest{
    
    /**键盘放弃第一响应者*/
    [self.textFieldOfTelephone resignFirstResponder];
    [self.textFieldOfCode resignFirstResponder];
    [self.textFieldOfsmsCode resignFirstResponder];
    
    /**发送召回请求*/
    [self postFindCodeRequest];
}

- (void) postFindCodeRequest{
    
    self.telephoneNum = [self.textFieldOfTelephone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([self.telephoneNum valiMobile]) {
        
        if (self.textFieldOfsmsCode.text.length > 0) {
            
            if (self.textFieldOfCode.text.length >= 6) {
                
                NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
                delegate.delegate = self;
                NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
                [paraDic setObject:self.telephoneNum forKey:@"mobile"];
                [paraDic setObject:self.textFieldOfsmsCode.text forKey:@"smsCode"];
                [paraDic setObject:[NSString getEncryptStringfrom:@[self.textFieldOfCode.text]] forKey:@"password"];
                [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
                [paraDic setObject:[NSNumber numberWithInt:[AppGroup getCurrentDate]] forKey:@"reqTime"];
                NSString *hashToken = [NSString getEncryptStringfrom:@[self.telephoneNum,
                                                                       [[DataManager lightData] readSkey],
                                                                       self.textFieldOfsmsCode.text,
                                                                       self.textFieldOfCode.text]];
                [paraDic setObject:hashToken forKey:@"hashToken"];
                [NetWorkTask postResquestWithApiName:FindPassword paraDic:paraDic delegate:delegate];
                self.currentApiName = FindPassword;
                
            }else{
                [self.registerBtn ErrorRevertAnimationCompletion:nil];
                [self showFailTemporaryMes:@"请确保您的密码至少为6位数"];
            }
        }else{
            [self.registerBtn ErrorRevertAnimationCompletion:nil];
            [self showFailTemporaryMes:@"请输入验证码"];
        }
        
    }else{
    
        [self.registerBtn ErrorRevertAnimationCompletion:nil];
        [self showFailTemporaryMes:@"手机号输入错误"];
    }

}
#pragma mark - 手机号的限制
- (void) inputTelephoneNum{
    
    if (self.textFieldOfTelephone.text.length >13) {

        /**控制输入长度*/
        NSMutableString *tempPhoneNum = [NSMutableString stringWithFormat:@"%@",self.textFieldOfTelephone.text];
        self.textFieldOfTelephone.text = [tempPhoneNum substringToIndex:13];

    }else{
    
        /**判断字符串的增减*/
        if (self.oldtextLength < self.textFieldOfTelephone.text.length) {
    
            if ((self.textFieldOfTelephone.text.length == 3) || (self.textFieldOfTelephone.text.length == 8)) {
    
                /**手机号码分解*/
                self.textFieldOfTelephone.text = [NSString stringWithFormat:@"%@ ",self.textFieldOfTelephone.text];
            }
    
        }
        self.oldtextLength = self.textFieldOfTelephone.text.length;
        
    }

}

#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:CheckUser]) {
        /**电话请求*/
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
         if ([obj.retCode intValue] == 0){
            
            /**发送验证码请求*/
            [self postSmsRequest];
        }else{
            
            [self stopIndicatorLoading];
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
        
    }else if ([self.currentApiName isEqualToString:FindPassword]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0 && obj) {
            
            [self setTelephoneLoginRequest];
            
        }else{
            
            [self.registerBtn ErrorRevertAnimationCompletion:nil];
            [self showFailTemporaryMes:obj.retMsg];
            [self initTimer];
        }
    }else if ([self.currentApiName isEqualToString:TelephoneLogin]){
    
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            /**帐号统计*/
            [MobClick profileSignInWithPUID:[NSString stringWithFormat:@"%@",obj.retData.user.uid]];
            
            [self saveUserInfo:obj];
            typeof(self) __weak weak = self;
            [self.registerBtn ExitAnimationCompletion:^{
                [weak enterMainVC];
            }];
            
        }else{
            [self.registerBtn ErrorRevertAnimationCompletion:nil];
            [self initTimer];
            [self showFailTemporaryMes:obj.retMsg];
        }
    }
    
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    
    [self.registerBtn ErrorRevertAnimationCompletion:nil];
    [self showFailTemporaryMes:@"网络连接失败"];
    [self initTimer];
    
}


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

#pragma mark - 读秒
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
    
    [self.timer invalidate];
    self.timer = nil;
    self.currentSeconds = 60;
    [self.postSmsCodeBtn setTitle:@"发送验证码"forState:UIControlStateNormal];
    self.postSmsCodeBtn.userInteractionEnabled = YES;
}


#pragma mark - enterPerfectInfoVC
- (void) enterMainVC{

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
        [[VCManger homeVC] viewDidLoad];
    }
}

#pragma mark -  NavigationBarProtocol
- (void) dismissCurrentVC{
    [[VCManger mainVC] dismissCurrentVCWithAnimate:YES];
    
}

@end
