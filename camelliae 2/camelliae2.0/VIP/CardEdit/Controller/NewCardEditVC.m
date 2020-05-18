//
//  NewCardEditVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/9/26.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "NewCardEditVC.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "UITextView+Placeholder.h"
#import "VCManger.h"

@interface NewCardEditVC ()<UITextFieldDelegate,UITextViewDelegate,NavigationBarProtocol,NetWorkProtocol>

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) UITextField *titileTextField;

@property (nonatomic,strong) UITextField *commpanyTextField;

@property (nonatomic,strong) UITextField *teleTextField;

@property (nonatomic,strong) UITextField *emailTextField;

@property (nonatomic,strong) UITextView *addressTextView;

@property (nonatomic,strong) UIView *addressBottomLine;

@property (nonatomic,strong) UIScrollView *bgScrollView;

@property (nonatomic,strong) UIButton *saveBtn;


@end

@implementation NewCardEditVC

- (instancetype)initWithObj:(BaseResultObj *) obj{

    self = [super init];
    
    if (self) {
        
        self.obj = obj;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    self.navBar.titleContent = @"编辑名片";
    self.navBar.delegate = self;
    [self.navBar setLeftBarItem];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    [self loadViews];
}

- (void)viewWillDisappear:(BOOL)animated{

//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void) loadViews{
    
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(self.navBar.frame),
                                                                       WIDTH,
                                                                       HEIGHT - CGRectGetMaxY(self.navBar.frame))];
    self.bgScrollView.showsVerticalScrollIndicator = NO;
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    self.bgScrollView.contentSize = CGSizeMake(WIDTH, HEIGHT + 100*Proportion);
    [self.contentView addSubview:self.bgScrollView];

    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = KSystemFontSize13;
    titleLab.textColor = [UIColor CMLtextInputGrayColor];
    titleLab.text = @"头衔";
    [titleLab sizeToFit];
    titleLab.frame = CGRectMake(30*Proportion,
                                30*Proportion,
                                titleLab.frame.size.width,
                                titleLab.frame.size.height);
    [self.bgScrollView addSubview:titleLab];
    
    self.titileTextField = [[UITextField alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                         CGRectGetMaxY(titleLab.frame) + 10*Proportion,
                                                                         WIDTH - 30*Proportion*2,
                                                                         67*Proportion)];
    self.titileTextField.placeholder = @"请输入头衔";
    self.titileTextField.text = self.obj.retData.title;
    self.titileTextField.font = KSystemFontSize14;
    self.titileTextField.delegate = self;
    [self.bgScrollView addSubview:self.titileTextField];
    
    UIView *titleBottomLine = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                       CGRectGetMaxY(self.titileTextField.frame),
                                                                       WIDTH - 30*Proportion*2,
                                                                       1)];
    titleBottomLine.backgroundColor = [UIColor CMLPromptGrayColor];
    [self.bgScrollView addSubview:titleBottomLine];
    
    UILabel *companyLab = [[UILabel alloc] init];
    companyLab.font = KSystemFontSize13;
    companyLab.textColor = [UIColor CMLtextInputGrayColor];
    companyLab.text = @"公司";
    [companyLab sizeToFit];
    companyLab.frame = CGRectMake(30*Proportion,
                                  CGRectGetMaxY(self.titileTextField.frame) + 50*Proportion,
                                  companyLab.frame.size.width,
                                  companyLab.frame.size.height);
    [self.bgScrollView addSubview:companyLab];
    
    self.commpanyTextField = [[UITextField alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                           CGRectGetMaxY(companyLab.frame) + 10*Proportion,
                                                                           WIDTH - 30*Proportion*2,
                                                                           67*Proportion)];
    self.commpanyTextField.placeholder = @"请输入公司";
    self.commpanyTextField.text = self.obj.retData.companyName;
    self.commpanyTextField.font = KSystemFontSize14;
    self.commpanyTextField.delegate = self;
    [self.bgScrollView addSubview:self.commpanyTextField];
    
    UIView *commpanyBottomLine = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                          CGRectGetMaxY(self.commpanyTextField.frame),
                                                                          WIDTH - 30*Proportion*2,
                                                                          1)];
    commpanyBottomLine.backgroundColor = [UIColor CMLPromptGrayColor];
    [self.bgScrollView addSubview:commpanyBottomLine];


    UILabel *teleLab = [[UILabel alloc] init];
    teleLab.font = KSystemFontSize13;
    teleLab.textColor = [UIColor CMLtextInputGrayColor];
    teleLab.text = @"电话";
    [teleLab sizeToFit];
    teleLab.frame = CGRectMake(30*Proportion,
                               CGRectGetMaxY(self.commpanyTextField.frame) + 50*Proportion,
                               teleLab.frame.size.width,
                               teleLab.frame.size.height);
    [self.bgScrollView addSubview:teleLab];
    
    self.teleTextField = [[UITextField alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                       CGRectGetMaxY(teleLab.frame) + 10*Proportion,
                                                                       WIDTH - 30*Proportion*2,
                                                                       67*Proportion)];
    self.teleTextField.placeholder = @"请输入电话";
    self.teleTextField.text = self.obj.retData.contactPhone;
    self.teleTextField.font = KSystemFontSize14;
    self.teleTextField.delegate = self;
    [self.bgScrollView addSubview:self.teleTextField];
    
    UIView *teleBottomLine = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                          CGRectGetMaxY(self.teleTextField.frame),
                                                                          WIDTH - 30*Proportion*2,
                                                                          1)];
    teleBottomLine.backgroundColor = [UIColor CMLPromptGrayColor];
    [self.bgScrollView addSubview:teleBottomLine];
    
    UILabel *emailLab = [[UILabel alloc] init];
    emailLab.font = KSystemFontSize13;
    emailLab.textColor = [UIColor CMLtextInputGrayColor];
    emailLab.text = @"邮箱";
    [emailLab sizeToFit];
    emailLab.frame = CGRectMake(30*Proportion,
                                CGRectGetMaxY(self.teleTextField.frame) + 50*Proportion,
                                emailLab.frame.size.width,
                                emailLab.frame.size.height);
    [self.bgScrollView addSubview:emailLab];
    
    self.emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                       CGRectGetMaxY(emailLab.frame) + 10*Proportion,
                                                                       WIDTH - 30*Proportion*2,
                                                                       67*Proportion)];
    self.emailTextField.placeholder = @"请输入邮箱";
    self.emailTextField.text = self.obj.retData.contactEmail;
    self.emailTextField.font = KSystemFontSize14;
    self.emailTextField.delegate = self;
    [self.bgScrollView addSubview:self.emailTextField];
    
    UIView *emailBottomLine = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                      CGRectGetMaxY(self.emailTextField.frame),
                                                                      WIDTH - 30*Proportion*2,
                                                                      1)];
    emailBottomLine.backgroundColor = [UIColor CMLPromptGrayColor];
    [self.bgScrollView addSubview:emailBottomLine];
    
    
    UILabel *addressLab = [[UILabel alloc] init];
    addressLab.font = KSystemFontSize13;
    addressLab.textColor = [UIColor CMLtextInputGrayColor];
    addressLab.text = @"地址";
    [addressLab sizeToFit];
    addressLab.frame = CGRectMake(30*Proportion,
                                 CGRectGetMaxY(self.emailTextField.frame) + 50*Proportion,
                                 addressLab.frame.size.width,
                                 addressLab.frame.size.height);
    [self.bgScrollView addSubview:addressLab];
    
    self.addressTextView = [[UITextView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                        CGRectGetMaxY(addressLab.frame) + 10*Proportion,
                                                                        WIDTH - 30*Proportion*2,
                                                                        67*Proportion)];

    self.addressTextView.text = self.obj.retData.contactAddress;
//    self.addressTextView.placeholder = @"请输入地址";
    NSMutableAttributedString *placeholderAtt = [[NSMutableAttributedString alloc] initWithString:@"请输入地址" attributes:@{NSForegroundColorAttributeName : [UIColor CMLPromptGrayColor]}];
    self.addressTextView.attributedPlaceholder = placeholderAtt;

    self.addressTextView.font = KSystemFontSize14;
    self.addressTextView.delegate = self;
    [self.bgScrollView addSubview:self.addressTextView];
    
    self.addressBottomLine = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                      CGRectGetMaxY(self.addressTextView.frame),
                                                                      WIDTH - 30*Proportion*2,
                                                                      1)];
    self.addressBottomLine.backgroundColor = [UIColor CMLPromptGrayColor];
    [self.bgScrollView addSubview:self.addressBottomLine];
    
    self.saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2.0 - 350*Proportion/2.0,
                                                              CGRectGetMaxY(self.addressTextView.frame) + 50*Proportion,
                                                              350*Proportion,
                                                              64*Proportion)];
    self.saveBtn.backgroundColor = [UIColor CMLBlackColor];
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
    self.saveBtn.titleLabel.font = KSystemFontSize14;
    [self.bgScrollView addSubview:self.saveBtn];
    [self.saveBtn addTarget:self action:@selector(setUpCardMessageRequest) forControlEvents:UIControlEventTouchUpInside];
}

- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];
}


////当键盘出现
//- (void)keyboardWillShow:(NSNotification *)notification{
//    //获取键盘的高度
//    NSDictionary *userInfo = [notification userInfo];
//    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [value CGRectValue];
//    
//
//}
//
////当键退出
//- (void)keyboardWillHide:(NSNotification *)notification
//{
//    //获取键盘的高度
//    NSDictionary *userInfo = [notification userInfo];
//    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [value CGRectValue];
//    int height = keyboardRect.size.height;
//    
//}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{

    

}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{


    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    
    if (self.addressTextView) {
        
        CGRect frame = self.addressTextView.frame;
        CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
        CGSize size = [self.addressTextView sizeThatFits:constraintSize];
        
        
        self.addressTextView.frame = CGRectMake(frame.origin.x,
                                               frame.origin.y,
                                               frame.size.width,
                                               size.height);
        
        self.addressBottomLine.frame = CGRectMake(30*Proportion,
                                                  CGRectGetMaxY(self.addressTextView.frame),
                                                  WIDTH - 30*Proportion*2,
                                                  1);
        
        self.saveBtn.frame = CGRectMake(WIDTH/2.0 - 350*Proportion/2.0,
                                        CGRectGetMaxY(self.addressTextView.frame) + 50*Proportion,
                                        350*Proportion,
                                        64*Proportion);

    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.titileTextField resignFirstResponder];
    [self.commpanyTextField resignFirstResponder];
    [self.teleTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.addressTextView resignFirstResponder];
}

- (void) setUpCardMessageRequest{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.titileTextField.text forKey:@"title"];
    [paraDic setObject:self.teleTextField.text forKey:@"contactPhone"];
    [paraDic setObject:self.commpanyTextField.text forKey:@"companyName"];
    [paraDic setObject:self.emailTextField.text forKey:@"contactEmail"];
    [paraDic setObject:self.addressTextView.text forKey:@"contactAddress"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    if (self.emailTextField.text.length > 0) {
    
        if ([self isValidateEmail:self.emailTextField.text]) {
            
            if (self.teleTextField.text.length >0) {
            
                if ([self isValidateMobile:self.teleTextField.text]) {
                    
                    [NetWorkTask postResquestWithApiName:UpUserCardMesage paraDic:paraDic delegate:delegate];
                }else{
                
                    [self showFailTemporaryMes:@"请输入正确手机号"];
                }
            
            }else{
            
                [NetWorkTask postResquestWithApiName:UpUserCardMesage paraDic:paraDic delegate:delegate];
            }
        }else{
        
            [self showFailTemporaryMes:@"请输入正确邮箱"];
        }
    }else{
    
        if (self.teleTextField.text.length >0) {
            
            if ([self isValidateMobile:self.teleTextField.text]) {
                
                [NetWorkTask postResquestWithApiName:UpUserCardMesage paraDic:paraDic delegate:delegate];
            }else{
                
                [self showFailTemporaryMes:@"请输入正确手机号"];
            }
            
        }else{
            
            [NetWorkTask postResquestWithApiName:UpUserCardMesage paraDic:paraDic delegate:delegate];
        }

    }
    
}

- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    
    if ([obj.retCode intValue] == 0 ) {
        
        [[VCManger mainVC] dismissCurrentVC];
    }else{
    
        [self showFailTemporaryMes:obj.retMsg];
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    [self showFailTemporaryMes:@"网络连接错误"];
}

- (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (BOOL)isValidateMobile:(NSString *)mobile{
    //手机号以13、15、18开头，八个\d数字字符
//    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    return [phoneTest evaluateWithObject:mobile];
    return YES;
}

@end
