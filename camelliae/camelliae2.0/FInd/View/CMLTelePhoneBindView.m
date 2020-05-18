//
//  CMLTelePhoneBindView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/8/29.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLTelePhoneBindView.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "DataManager.h"
#import "CMLLine.h"
#import "NSString+CMLExspand.h"
#import "AppGroup.h"
#import "BaseResultObj.h"
#import "SVProgressHUD.h"

@interface CMLTelePhoneBindView ()<NetWorkProtocol,UITextFieldDelegate>

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UITextField *textFieldOfTelephone;

@property (nonatomic,strong) UITextField *textFieldOfSmsCode;

@property (nonatomic,strong) UITextField *textFieldOfCode;

@property (nonatomic,strong) UITextField *inviteCodeTextField;

@property (nonatomic,strong) UIButton *getSmsCodeBtn;

@property (nonatomic,copy) NSString *telephoneNum;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) int currentSeconds;


@end

@implementation CMLTelePhoneBindView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
     
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        //监听当键将要退出时
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];

        
        self.backgroundColor = [UIColor CMLWhiteColor];
        self.currentSeconds = 60;
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    self.bgView = [[UIView alloc] initWithFrame:self.bounds];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    
    

    UIImageView *topBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           WIDTH,
                                                                           360*Proportion)];
    topBgView.backgroundColor = [UIColor CMLBlackColor];
    [self.bgView addSubview:topBgView];
    
    UIView *userImageBgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2.0 - 160*Proportion/2.0,
                                                                       360*Proportion - 160*Proportion/2.0,
                                                                       160*Proportion,
                                                                       160*Proportion)];
    userImageBgView.backgroundColor = [UIColor CMLWhiteColor];
    userImageBgView.layer.cornerRadius = 160*Proportion/2.0;
    [self.bgView  addSubview:userImageBgView];
    
    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(160*Proportion/2.0 - 140*Proportion/2.0,
                                                                           160*Proportion/2.0 - 140*Proportion/2.0,
                                                                           140*Proportion,
                                                                           140*Proportion)];
    userImage.backgroundColor = [UIColor CMLtextInputGrayColor];
    userImage.clipsToBounds = YES;
    userImage.layer.cornerRadius = 140*Proportion/2.0;
    [userImageBgView addSubview:userImage];
    [NetWorkTask setImageView:userImage WithURL:[[DataManager lightData] readUserHeadImgUrl] placeholderImage:nil];
     
    UILabel *promLabelOne = [[UILabel alloc] init];
    promLabelOne.textColor = [UIColor CMLBlackColor];
    promLabelOne.text = @"亲爱的卡枚连用户";
    promLabelOne.font = KSystemFontSize15;
    [promLabelOne sizeToFit];
    promLabelOne.frame = CGRectMake(WIDTH/2.0 - promLabelOne.frame.size.width/2.0,
                                    CGRectGetMaxY(userImageBgView.frame) + 10*Proportion,
                                    promLabelOne.frame.size.width,
                                    promLabelOne.frame.size.height);
    [self.bgView  addSubview:promLabelOne];
    
    UILabel *promLabelTwo = [[UILabel alloc] init];
    promLabelTwo.textColor = [UIColor CMLLineGrayColor];
    promLabelTwo.text = @"为了给您提供更好的服务请务必关联一个手机号";
    promLabelTwo.font = KSystemFontSize13;
    [promLabelTwo sizeToFit];
    promLabelTwo.frame = CGRectMake(WIDTH/2.0 - promLabelTwo.frame.size.width/2.0,
                                    CGRectGetMaxY(promLabelOne.frame) + 20*Proportion,
                                    promLabelTwo.frame.size.width,
                                    promLabelTwo.frame.size.height);
    [self.bgView  addSubview:promLabelTwo];
    
    /******************/
    UIView *oneBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 CGRectGetMaxY(promLabelTwo.frame) + 50*Proportion,
                                                                 WIDTH,
                                                                 120*Proportion)];
    oneBgView.backgroundColor = [UIColor CMLWhiteColor];
    [self.bgView  addSubview:oneBgView];
    
    UIImageView *teleImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:LoginVCUser]];
    [teleImg sizeToFit];
    teleImg.frame = CGRectMake(60*Proportion,
                               100*Proportion/2.0 - teleImg.frame.size.height/2.0 + 20*Proportion,
                               teleImg.frame.size.width,
                               teleImg.frame.size.height);
    [oneBgView addSubview:teleImg];
    
    self.textFieldOfTelephone = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(teleImg.frame) + 30*Proportion,
                                                                              20*Proportion,
                                                                              WIDTH - 60*Proportion - (CGRectGetMaxX(teleImg.frame) + 30*Proportion),
                                                                              100*Proportion)];
    self.textFieldOfTelephone.keyboardType = UIKeyboardTypeNumberPad;
    self.textFieldOfTelephone.backgroundColor = [UIColor whiteColor];
    self.textFieldOfTelephone.placeholder = @"请输入手机号";
    self.textFieldOfTelephone.font = KSystemFontSize15;
    self.textFieldOfTelephone.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textFieldOfTelephone.delegate = self;
    [self.textFieldOfTelephone addTarget:self action:@selector(inputTelephoneNum) forControlEvents:UIControlEventEditingChanged];
    [oneBgView addSubview:self.textFieldOfTelephone];
    
    CMLLine *oneBottomLine = [[CMLLine alloc] init];
    oneBottomLine.startingPoint = CGPointMake(60*Proportion, oneBgView.frame.size.height - 1*Proportion);
    oneBottomLine.lineWidth = 1*Proportion;
    oneBottomLine.lineLength = WIDTH - 60*Proportion*2;
    oneBottomLine.LineColor = [UIColor CMLNewGrayColor];
    [oneBgView addSubview:oneBottomLine];
    
    /***********/
    UIView *twoBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 CGRectGetMaxY(oneBgView.frame),
                                                                 WIDTH,
                                                                 120*Proportion)];
    twoBgView.backgroundColor = [UIColor CMLWhiteColor];
    [self.bgView  addSubview:twoBgView];
    
    UIImageView *smsCodeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MesCodeImg]];
    [smsCodeImg sizeToFit];
    smsCodeImg.frame = CGRectMake(60*Proportion,
                                  100*Proportion/2.0 - smsCodeImg.frame.size.height/2.0 + 20*Proportion,
                                  smsCodeImg.frame.size.width,
                                  smsCodeImg.frame.size.height);
    [twoBgView addSubview:smsCodeImg];
    
    /**验证码请求*/
    self.getSmsCodeBtn = [[UIButton alloc] init];
    [self.getSmsCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.getSmsCodeBtn.titleLabel.font = KSystemFontSize12;
    [self.getSmsCodeBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    [self.getSmsCodeBtn sizeToFit];
    CGFloat currentWidth = self.getSmsCodeBtn.frame.size.width + 40*Proportion;
    
    self.getSmsCodeBtn.frame = CGRectMake(WIDTH - 60*Proportion - currentWidth,
                                          100*Proportion/2.0 - 60*Proportion/2.0 + 20*Proportion,
                                          self.getSmsCodeBtn.frame.size.width + 40*Proportion,
                                          60*Proportion);
    self.getSmsCodeBtn.layer.cornerRadius = 52*Proportion/2.0;
    self.getSmsCodeBtn.backgroundColor = [UIColor CMLNewGrayColor];
    [twoBgView addSubview:self.getSmsCodeBtn];
    [self.getSmsCodeBtn addTarget:self action:@selector(setGetSmsCodeTimerAndRequest) forControlEvents:UIControlEventTouchUpInside];
    
    
    /**密码输入框*/
    self.textFieldOfSmsCode = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(smsCodeImg.frame) + 30*Proportion,
                                                                            20*Proportion,
                                                                            WIDTH - self.getSmsCodeBtn.frame.size.width - (CGRectGetMaxX(smsCodeImg.frame) + 30*Proportion),
                                                                            100*Proportion)];
    self.textFieldOfSmsCode.keyboardType = UIKeyboardTypeNumberPad;
    self.textFieldOfSmsCode.placeholder = @"请输入验证码";
    self.textFieldOfSmsCode.font = KSystemFontSize15;
    self.textFieldOfSmsCode.delegate = self;
    [twoBgView addSubview:self.textFieldOfSmsCode];
    
    
    CMLLine *twoBottomLine = [[CMLLine alloc] init];
    twoBottomLine.startingPoint = CGPointMake(60*Proportion, oneBgView.frame.size.height - 1*Proportion);
    twoBottomLine.lineWidth = 1*Proportion;
    twoBottomLine.lineLength = WIDTH - 60*Proportion*2;
    twoBottomLine.LineColor = [UIColor CMLNewGrayColor];
    [twoBgView addSubview:twoBottomLine];
    
    
    /***********/
    UIView *threeBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 CGRectGetMaxY(twoBgView.frame),
                                                                 WIDTH,
                                                                 120*Proportion)];
    threeBgView.backgroundColor = [UIColor CMLWhiteColor];
    [self.bgView  addSubview:threeBgView];
    
    
    UIImageView *codeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:LoginVCCode]];
    [codeImg sizeToFit];
    codeImg.frame = CGRectMake(60*Proportion,
                               100*Proportion/2.0 - codeImg.frame.size.height/2.0 + 20*Proportion,
                               codeImg.frame.size.width,
                               codeImg.frame.size.height);
    [threeBgView addSubview:codeImg];
    
    
    
    /**密码输入框*/
    self.textFieldOfCode = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(codeImg.frame) + 30*Proportion,
                                                                         20*Proportion,
                                                                         WIDTH - 60*Proportion - (CGRectGetMaxX(codeImg.frame) + 30*Proportion),
                                                                         100*Proportion)];
    self.textFieldOfCode.keyboardType = UIKeyboardTypeNumberPad;
    self.textFieldOfCode.placeholder = @"请设置初始密码，便于登录使用";
    self.textFieldOfCode.font = KSystemFontSize15;
    self.textFieldOfCode.delegate = self;
    [threeBgView addSubview:self.textFieldOfCode];
    
    
    CMLLine *threeBottomLine = [[CMLLine alloc] init];
    threeBottomLine.startingPoint = CGPointMake(60*Proportion, oneBgView.frame.size.height - 1*Proportion);
    threeBottomLine.lineWidth = 1*Proportion;
    threeBottomLine.lineLength = WIDTH - 60*Proportion*2;
    threeBottomLine.LineColor = [UIColor CMLNewGrayColor];
    [threeBgView addSubview:threeBottomLine];
    
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2.0 - 630*Proportion/2.0,
                                                                      CGRectGetMaxY(threeBgView.frame) + 60*Proportion,
                                                                      630*Proportion,
                                                                      80*Proportion)];
    confirmBtn.backgroundColor = [UIColor CMLBlackColor];
    confirmBtn.titleLabel.font = KSystemFontSize16;
    confirmBtn.layer.cornerRadius = 40*Proportion;
    [confirmBtn setTitle:@"确  认" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
    [self.bgView  addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(bindPhone) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

- (void) bindPhone{
    NSLog(@"%@", self.telephoneNum);
    self.telephoneNum = [self.textFieldOfTelephone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
//    if ([self.telephoneNum valiMobile]) {
    if (self.telephoneNum.length <= 11) {
        if (self.textFieldOfSmsCode.text.length > 0) {
            
            if (self.textFieldOfCode.text.length > 0) {
                
                [self setNewBindPhoneRequest];
                
            }else{
            
                [self.delegate showErrorMessageOfBindPhone:@"请输入密码"];
            }
            
        }else{
        
            [self.delegate showErrorMessageOfBindPhone:@"请输入验证码"];
        }
    
    }else{
        
        [self.delegate showErrorMessageOfBindPhone:@"请输入正确手机号"];
    }

}

- (void) inputTelephoneNum{
    
    if (self.textFieldOfTelephone.text.length > 11) {
        
        /**控制输入长度*/
        NSMutableString *tempPhoneNum = [NSMutableString stringWithFormat:@"%@",self.textFieldOfTelephone.text];
        NSLog(@"%@", tempPhoneNum);
        self.textFieldOfTelephone.text = [tempPhoneNum substringToIndex:11];
        NSLog(@"%@", tempPhoneNum);
    }else {
        NSLog(@"%@", self.textFieldOfTelephone.text);
        self.telephoneNum = [self.textFieldOfTelephone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"%@", self.telephoneNum);
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.textFieldOfTelephone resignFirstResponder];
    [self.textFieldOfSmsCode resignFirstResponder];
    [self.textFieldOfCode resignFirstResponder];
    [self.inviteCodeTextField resignFirstResponder];
}


#pragma mark - 获取验证码
- (void) setGetSmsCodeTimerAndRequest{
    
    self.telephoneNum = [self.textFieldOfTelephone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([self.telephoneNum valiMobile]) {
        
        [self.textFieldOfSmsCode becomeFirstResponder];
        [self setNewCheckBindPhoneNumRequest];
        
    }else{

        [self.delegate showErrorMessageOfBindPhone:@"请输入正确手机号"];
    }
    
}

- (void) setSmsRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    if (self.telephoneNum.length > 0) {
        [paraDic setObject:self.telephoneNum forKey:@"mobile"];
    }
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:[NSNumber numberWithInt:10001] forKey:@"reqType"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.telephoneNum,[NSNumber numberWithInt:10001],[[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:MessageVerify paraDic:paraDic delegate:delegate];
    self.currentApiName = MessageVerify;
    
    
}

#pragma mark - setBindPhoneRequest
- (void) setNewBindPhoneRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    if (self.telephoneNum.length > 0) {
        [paraDic setObject:self.telephoneNum forKey:@"mobile"];
    }
    if (self.textFieldOfSmsCode.text.length > 0) {
        [paraDic setObject:self.textFieldOfSmsCode.text forKey:@"smsCode"];
    }
    if (self.textFieldOfCode.text.length > 0) {
        [paraDic setObject:[NSString getEncryptStringfrom:@[self.textFieldOfCode.text]] forKey:@"passwd"];
    }
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    if (self.inviteCodeTextField.text.length > 0) {
        [paraDic setObject:self.inviteCodeTextField.text forKey:@"invite_code"];
    }
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,
                                                           self.telephoneNum,
                                                           self.textFieldOfSmsCode.text,
                                                           self.textFieldOfCode.text,
                                                           [[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:BindPhone paraDic:paraDic delegate:delegate];
    self.currentApiName = BindPhone;
    
    [self.delegate requestStartLoading];
    
}

#pragma mark - bindPhone
- (void) setNewCheckBindPhoneNumRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    if (self.telephoneNum.length > 0) {
        [paraDic setObject:self.telephoneNum forKey:@"mobile"];
    }
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,self.telephoneNum,[[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:CheckBindPhone paraDic:paraDic delegate:delegate];
    self.currentApiName = CheckBindPhone;
    [self.delegate requestStartLoading];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(changeCurrentSeconds)
                                                userInfo:nil
                                                 repeats:YES];
    
    self.getSmsCodeBtn.userInteractionEnabled = NO;
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
    
    [self.textFieldOfSmsCode resignFirstResponder];
    self.currentSeconds = 60;
    self.getSmsCodeBtn.userInteractionEnabled = YES;
    [self.timer invalidate];
    self.timer = nil;
    [self.getSmsCodeBtn setTitle:@"发送验证码"
                        forState:UIControlStateNormal];
    
}

#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if([self.currentApiName isEqualToString:BindPhone]){
        
       
        [self.delegate requestFinshedLoading];
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            [self.delegate showSuccessMessageOfBindPhone:@"绑定成功"];

            [[DataManager lightData] savePhone:self.telephoneNum];
            
            [self initializeTimer];
            
            [self clearSelfView];
            [[DataManager lightData] saveSkey:obj.retData.skey];
            [[DataManager lightData] saveUser:obj];
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self.delegate requestFinshedLoading];
            [self initializeTimer];
            
        }else{
         
            [self initializeTimer];
            [self.delegate showErrorMessageOfBindPhone:obj.retMsg];
        }
        
    }else if ([self.currentApiName isEqualToString:MessageVerify]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            [self.delegate showSuccessMessageOfBindPhone:@"验证码已发送"];
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self.delegate requestFinshedLoading];
    
            
        }else{
            [self.delegate showErrorMessageOfBindPhone:obj.retMsg];
        }
        
        [self.delegate requestFinshedLoading];
    }else if ([self.currentApiName isEqualToString:CheckBindPhone]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 200103 && obj) {
            
            [self setSmsRequest];
            
        }else if ([obj.retCode intValue] == 100101){
            
            
            [self initializeTimer];
            [self.delegate requestFinshedLoading];
            
            
        }else{
            [self.delegate requestFinshedLoading];
            [self initializeTimer];
            
            [self.delegate showErrorMessageOfBindPhone:@"该手机号已绑定"];
        }
    }
    
    [self.delegate requestFinshedLoading];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self initializeTimer];
    [self.delegate requestFinshedLoading];
    
}


- (void) clearSelfView{

    [self initializeTimer];
        
    [self removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    
}

//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    
    self.bgView.frame = CGRectMake(0, self.bgView.frame.origin.y - height, WIDTH, HEIGHT);
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    //获取键盘的高度
    
    self.bgView.frame = self.bounds;
}
@end
