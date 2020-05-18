//
//  CMLMyWithdrawalViewController.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/11.
//  Copyright © 2019 张越. All rights reserved.
//

#import "CMLMyWithdrawalViewController.h"
#import "VCManger.h"
#import "Network.h"
#import "NetConfig.h"
#import "SVProgressHUD.h"
#import "CMLGetCashSucceedViewController.h"
#import "CMLWalletCenterNavView.h"

@interface CMLMyWithdrawalViewController ()<NavigationBarProtocol, NetWorkProtocol, UITextFieldDelegate>

@property (nonatomic, strong) UIView *topView;

@property (nonatomic,strong) UIView *currentShadow;

@property (nonatomic, strong) UITextField *importTextField;

@property (nonatomic, copy) NSString *cash;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *card;

@property (nonatomic, copy) NSString *bankName;

@property (nonatomic, copy) NSString *currentApiName;

@property (nonatomic, strong) UIView *informationView;
/**键盘显示*/
@property (nonatomic, assign) BOOL isShowKeyBoard;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *cardLabel;

@property (nonatomic, strong) UILabel *cardNameLabel;/*开户行*/

@property (nonatomic, strong) UITextField *nameTextField;/*姓名*/

@property (nonatomic, strong) UITextField *cardTextField;/*银行卡号*/

@property (nonatomic, strong) UITextField *cardNameTextField;/*开户行名称*/

@property (nonatomic, strong) UIButton *getCButton;/*确认 申请提现*/

@property (nonatomic, strong) UILabel *firstineLabel;

@property (nonatomic, strong) UILabel *secondLineLabel;

@property (nonatomic, strong) UILabel *thirdLineLabel;

@property (weak, nonatomic) IBOutlet UITextField *getCash;/*textfield：请输入余额*/

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;/*余额*/

@property (weak, nonatomic) IBOutlet UIButton *allGetCashButton;/*全部提现*/

@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

@property (weak, nonatomic) IBOutlet UIButton *getCashButton;/*申请提现按钮*/

/*提现完成*/
@property (nonatomic, strong) UILabel *titlesLabel;

@property (nonatomic, strong) UILabel *introLabel;

@property (nonatomic, strong) UIButton *completeButton;

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) NSString *nameString;

@property (nonatomic, strong) NSString *cardString;

@end

@implementation CMLMyWithdrawalViewController

- (UIView *)informationView {
    
    if (!_informationView) {
        _informationView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    HEIGHT,
                                                                    WIDTH,
                                                                    997 * Proportion)];
        _informationView.backgroundColor = [UIColor whiteColor];
    }
    return _informationView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"填写提现信息";
        _titleLabel.textColor = [UIColor CML383838Color];
        _titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
        [_titleLabel sizeToFit];
        _titleLabel.frame = CGRectMake(38 * Proportion,
                                       32 * Proportion,
                                       CGRectGetWidth(_titleLabel.frame),
                                       CGRectGetHeight(_titleLabel.frame));
    }
    return _titleLabel;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"姓       名";
        _nameLabel.textColor = [UIColor CML383838Color];
        _nameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        [_nameLabel sizeToFit];
        _nameLabel.frame = CGRectMake(39 * Proportion,
                                      CGRectGetMaxY(self.titleLabel.frame) + 66 * Proportion,
                                      CGRectGetWidth(_nameLabel.frame),
                                      CGRectGetHeight(_nameLabel.frame));
    }
    return _nameLabel;
}

- (UILabel *)firstineLabel {
    
    if (!_firstineLabel) {
        _firstineLabel = [[UILabel alloc] init];
        _firstineLabel.backgroundColor = [UIColor CMLGrayD8D8D8Color];
        _firstineLabel.frame = CGRectMake(38 * Proportion,
                                          CGRectGetMaxY(self.nameLabel.frame) + 24 *Proportion,
                                          WIDTH - 38 * Proportion,
                                          2 * Proportion);
    }
    return _firstineLabel;
}

- (UILabel *)cardLabel {
    
    if (!_cardLabel) {
        _cardLabel = [[UILabel alloc] init];
        _cardLabel.text = @"银行卡号";
        _cardLabel.textColor = [UIColor CML383838Color];
        _cardLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        [_cardLabel sizeToFit];
        _cardLabel.frame = CGRectMake(39 * Proportion,
                                      CGRectGetMaxY(self.firstineLabel.frame) + 34 * Proportion,
                                      CGRectGetWidth(_cardLabel.frame),
                                      CGRectGetHeight(_cardLabel.frame));
    }
    return _cardLabel;
}

- (UILabel *)secondLineLabel {
    
    if (!_secondLineLabel) {
        _secondLineLabel = [[UILabel alloc] init];
        _secondLineLabel.backgroundColor = [UIColor CMLGrayD8D8D8Color];
        _secondLineLabel.frame = CGRectMake(38 * Proportion,
                                            CGRectGetMaxY(self.cardLabel.frame) + 24 *Proportion,
                                            WIDTH - 38 * Proportion,
                                            2 * Proportion);
    }
    return _secondLineLabel;
}

- (UILabel *)cardNameLabel {
    
    if (!_cardNameLabel) {
        _cardNameLabel = [[UILabel alloc] init];
        _cardNameLabel.text = @"开  户  行";
        _cardNameLabel.textColor = [UIColor CML383838Color];
        _cardNameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        [_cardNameLabel sizeToFit];
        _cardNameLabel.frame = CGRectMake(39 * Proportion,
                                          CGRectGetMaxY(self.secondLineLabel.frame) + 34 * Proportion,
                                          CGRectGetWidth(_cardNameLabel.frame),
                                          CGRectGetHeight(_cardNameLabel.frame));
    }
    return _cardNameLabel;
}

- (UILabel *)thirdLineLabel {
    
    if (!_thirdLineLabel) {
        _thirdLineLabel = [[UILabel alloc] init];
        _thirdLineLabel.backgroundColor = [UIColor CMLGrayD8D8D8Color];
        _thirdLineLabel.frame = CGRectMake(38 * Proportion,
                                           CGRectGetMaxY(self.cardNameLabel.frame) + 24 *Proportion,
                                           WIDTH - 38 * Proportion,
                                           2 * Proportion);
    }
    return _thirdLineLabel;
}

- (UIButton *)getCButton {
    
    if (!_getCButton) {
        _getCButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_getCButton setImage:[UIImage imageNamed:CMLWalletCenterWithdrawalBtnNoSelectedImage] forState:UIControlStateNormal];
        [_getCButton setImage:[UIImage imageNamed:CMLWalletCenterWithdrawalBtnImage] forState:UIControlStateSelected];
        _getCButton.backgroundColor = [UIColor clearColor];
        _getCButton.selected = NO;
        [_getCButton sizeToFit];
        _getCButton.frame = CGRectMake(WIDTH/2 - CGRectGetWidth(_getCButton.frame)/2,
                                       118 * Proportion + CGRectGetMaxY(self.thirdLineLabel.frame),
                                       CGRectGetWidth(_getCButton.frame),
                                       CGRectGetHeight(_getCButton.frame));
        [_getCButton addTarget:self action:@selector(getCButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getCButton;
}

- (UITextField *)nameTextField {
    
    if (!_nameTextField) {
        
        _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 80 * Proportion,
                                                                       CGRectGetMidY(self.nameLabel.frame) - 26 * Proportion,
                                                                       WIDTH - CGRectGetMaxX(self.nameLabel.frame) - 80 * Proportion - 39 * Proportion,
                                                                       26 * Proportion * 2)];
        _nameTextField.delegate = self;
        _nameTextField.placeholder = @"请输入姓名";
        _nameTextField.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _nameTextField.textColor = [UIColor CMLIntroGrayColor];
        _nameTextField.textAlignment = NSTextAlignmentLeft;
        _nameTextField.returnKeyType = UIReturnKeyDone;
        _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
    }
    return _nameTextField;
}

- (UITextField *)cardTextField {
    if (!_cardTextField) {
        _cardTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 80 * Proportion,
                                                                       CGRectGetMidY(self.cardLabel.frame) - 26 * Proportion,
                                                                       WIDTH - CGRectGetMaxX(self.nameLabel.frame) - 80 * Proportion - 39 * Proportion,
                                                                       26 * Proportion * 2)];
        _cardTextField.delegate = self;
        _cardTextField.placeholder = @"请输入银行卡号";
        _cardTextField.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _cardTextField.textColor = [UIColor CMLIntroGrayColor];
        _cardTextField.textAlignment = NSTextAlignmentLeft;
        _cardTextField.returnKeyType = UIReturnKeyDone;
        _cardTextField.keyboardType = UIKeyboardTypeNumberPad;
        _cardTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _cardTextField;
}

- (UITextField *)cardNameTextField {
    if (!_cardNameTextField) {
        _cardNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 80 * Proportion,
                                                                           CGRectGetMidY(self.cardNameLabel.frame) - 26 * Proportion,
                                                                           WIDTH - CGRectGetMaxX(self.cardNameLabel.frame) - 80 * Proportion - 39 * Proportion,
                                                                           26 * Proportion * 2)];
        _cardNameTextField.delegate = self;
        _cardNameTextField.placeholder = @"请输入准确的开户行信息";
        _cardNameTextField.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _cardNameTextField.textColor = [UIColor CMLIntroGrayColor];
        _cardNameTextField.textAlignment = NSTextAlignmentLeft;
        _cardNameTextField.returnKeyType = UIReturnKeyDone;
        _cardNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _cardNameTextField;
}

- (void)viewWillAppear:(BOOL)animated {
    
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

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.delegate = self;
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.titleContent = @"提现";
    [self.navBar setLeftBarItem];
    self.navBar.bottomLine.lineWidth = 2 * Proportion;
    self.contentView.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navBar];
    self.earnings = [[DataManager lightData] readAllEarnings];
    [self loadWalletCenterView];
    
}

/*点击第一个申请提现*/
- (IBAction)geCashButtonClick:(id)sender {
    if (self.getCashButton.selected) {
        self.cash = self.getCash.text;
        [self loadInformationView];
    }
}

/*点击全部提现*/
- (IBAction)allGetCashButtonClick:(id)sender {
    if ([self.earnings floatValue] <= 0) {
        [SVProgressHUD showErrorWithStatus:@"每笔金额至少1元"];
    }else {
        self.getCash.text = [NSString stringWithFormat:@"%.2f", [self.earnings floatValue]];
        self.getCashButton.selected = YES;
    }
}

/*输入*/
- (IBAction)getCashTextField:(UITextField *)sender {
    NSLog(@"sender.text: %@", sender.text);
    NSLog(@"self.getCash.text: %@", self.getCash.text);
    if ([self.getCash.text floatValue] == 0) {
        self.getCashButton.selected = NO;
    }
}

- (void)loadWalletCenterView {
    
    NSString *string = [NSString stringWithFormat:@"可提现余额%.2f", [[[DataManager lightData] readAllEarnings] floatValue]];
    /*可提现余额*/
    self.balanceLabel.text = string;
    self.getCash.delegate = self;
    self.currentShadow = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  WIDTH,
                                                                  HEIGHT)];
    self.currentShadow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [self.view addSubview:self.currentShadow];
    [self.view bringSubviewToFront:self.currentShadow];
    self.currentShadow.hidden = YES;
    [self.getCash addTarget:self action:@selector(textFieldIsChange:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)textFieldIsChange:(UITextField *)textField {
    
    if ([self.getCash.text floatValue] > [self.earnings floatValue]) {
        self.warningLabel.hidden = NO;
        self.getCashButton.selected = NO;
    }else {
        self.warningLabel.hidden = YES;
        self.getCashButton.selected = YES;
    }
    
}

/*填写姓名+银行卡号*/
- (void)loadInformationView {
    
    [self.currentShadow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.currentShadow.hidden = NO;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"getCName"]) {
        self.nameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"getCName"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"getCCard"]) {
        self.cardTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"getCCard"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"getCCardName"]) {
        self.cardNameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"getCCardName"];
    }
    
    if (self.nameTextField.text.length > 0 && self.cardTextField.text.length > 0 && self.cardNameTextField.text.length > 0) {
        self.getCButton.selected = YES;
    }else {
        self.getCButton.selected = NO;
    }

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.informationView.frame = CGRectMake(0,
                                                    HEIGHT - SafeAreaBottomHeight - 997 * Proportion,
                                                    WIDTH, 997 * Proportion);
    }];
    
    [self.currentShadow addSubview:self.informationView];
    [self.informationView addSubview:self.titleLabel];
    [self.informationView addSubview:self.nameLabel];
    [self.informationView addSubview:self.nameTextField];
    [self.informationView addSubview:self.firstineLabel];
    [self.informationView addSubview:self.cardLabel];
    [self.informationView addSubview:self.cardTextField];
    [self.informationView addSubview:self.secondLineLabel];
    [self.informationView addSubview:self.cardNameLabel];
    [self.informationView addSubview:self.thirdLineLabel];
    [self.informationView addSubview:self.cardNameTextField];
    [self.informationView addSubview:self.getCButton];/*第二个申请提现按钮*/
    
    [self.nameTextField addTarget:self action:@selector(cardTextFieldIsChange) forControlEvents:UIControlEventEditingChanged];
    [self.cardTextField addTarget:self action:@selector(cardTextFieldIsChange) forControlEvents:UIControlEventEditingChanged];
    [self.cardNameTextField addTarget:self action:@selector(cardTextFieldIsChange) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)cardTextFieldIsChange {
    
    if (self.nameTextField.text.length == 0 || self.cardTextField.text.length == 0 || self.cardNameTextField.text.length == 0) {
        self.getCButton.selected = NO;
    }else {
        self.getCButton.selected = YES;
    }
    
}

/*第二个申请提现*/
- (void)getCButtonClicked {
    
    if (self.getCButton.selected == YES) {
        self.name = self.nameTextField.text;
        self.card = self.cardTextField.text;
        self.bankName = self.cardNameTextField.text;
        [self showAlertWithTitle:@"确定提现" message:nil];
    }
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self getCashRequest];
//        [self getCashSucceedViewController];/*测试提现成功-注释掉[self getCashRequest];*/
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.currentShadow.hidden = YES;
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

/*提现请求*/
- (void)getCashRequest {
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSString *skey = [[DataManager lightData] readSkey];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:self.cash forKey:@"cash"];
    [paraDic setObject:self.name forKey:@"name"];
    [paraDic setObject:self.card forKey:@"card"];
    [paraDic setObject:self.bankName forKey:@"bankName"];
    NSLog(@"%@", paraDic);
    [NetWorkTask postResquestWithApiName:WalletCenterMyTeamGetCash paraDic:paraDic delegate:delegate];
    self.currentApiName = WalletCenterMyTeamGetCash;
    
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    
    if ([obj.retCode intValue] == 0) {
        
        [self getCashSucceedViewController];

    }else if ([obj.retCode intValue] == 100101){

    }else{
        [SVProgressHUD showErrorWithStatus:obj.retMsg];
    }

}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName {
    [SVProgressHUD showErrorWithStatus:@"网络连接错误"];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.getCash) {
        NSString *currentEarnings = [NSString stringWithFormat:@"%.2f", [self.earnings floatValue]];
        
        if ([textField.text floatValue] > [currentEarnings floatValue]) {
            if ([textField.text floatValue] == 0) {
                return;
            }
            self.warningLabel.hidden = NO;
            [SVProgressHUD showErrorWithStatus:@"余额不足"];
        }else {
            self.warningLabel.hidden = YES;
        }
        
    }else{
        
        if (self.nameTextField.text.length > 0 && self.cardTextField.text.length > 0 && self.cardNameTextField.text.length > 0) {
            self.getCButton.selected = YES;
        }else {
            self.getCButton.selected = NO;
        }
        if (textField == self.nameTextField) {
            [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"getCName"];
        }
        if (textField == self.cardTextField) {
            [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"getCCard"];
        }
        if (textField == self.cardNameTextField) {
            [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"getCCardName"];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.getCash) {
        if ([self.getCash.text floatValue] > [self.earnings floatValue]) {
            self.warningLabel.hidden = NO;
            self.getCashButton.selected = NO;
        }else {
            self.warningLabel.hidden = YES;
            self.getCashButton.selected = YES;
        }
        
        //限制只能输入数字
        BOOL isHaveDian = YES;
        if ([string isEqualToString:@" "]) {
            return NO;
        }
        
        if ([textField.text rangeOfString:@"."].location == NSNotFound) {
            isHaveDian = NO;
        }
        
        if ([string length] > 0) {
            
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if ((single >= '0' && single <= '9') || single == '.') {
                //数据格式正确
                if([textField.text length] == 0){
                    if(single == '.' || single == '0') {
                        [SVProgressHUD showErrorWithStatus:@"每笔金额至少1元"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                //输入的字符是否是小数点
                if (single == '.') {
                    if(!isHaveDian) {
                        //text中还没有小数点
                        isHaveDian = YES;
                        return YES;
                        
                    }else{
                        [SVProgressHUD showErrorWithStatus:@"请输入正确的金额"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }else{
                    //存在小数点
                    if (isHaveDian) {
                        
                        //判断小数点的位数
                        NSRange ran = [textField.text rangeOfString:@"."];
                        if (range.location - ran.location <= 2) {
                            return YES;
                        }else{
//                            [SVProgressHUD showErrorWithStatus:@"请输入正确的金额"];
                            return NO;
                        }
                    }else{
                        return YES;
                    }
                }
            }else{
                //输入的数据格式不正确
                [SVProgressHUD showErrorWithStatus:@"请输入正确的金额"];
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }else{
            return YES;
        }
    }
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.getCash resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    [self.cardTextField resignFirstResponder];
    [self.cardNameTextField resignFirstResponder];
    return YES;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.getCash resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    [self.cardTextField resignFirstResponder];
    [self.cardNameTextField resignFirstResponder];
    /*self.fristAgreementView*/
    CGPoint point = [[touches anyObject] locationInView:self.view];
    point = [self.informationView.layer convertPoint:point fromLayer:self.view.layer];
    if ([self.informationView.layer containsPoint:point]) {
        return;
    }
    
    if (!self.isShowKeyBoard) {
        if (self.informationView.hidden == NO) {
            self.currentShadow.hidden = NO;
        }else {
            self.currentShadow.hidden  = YES;
        }
        self.currentShadow.hidden = YES;
    }else{
        self.isShowKeyBoard = NO;
    }
    
}

#pragma mark -  keyboardWasShown
- (void)keyboardWasShown:(NSNotification*)noti {
    self.isShowKeyBoard = YES;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.informationView.frame = CGRectMake(0,
                                                    HEIGHT - SafeAreaBottomHeight - 1150 * Proportion,
                                                    WIDTH, 1150 * Proportion);
    }];
}

#pragma mark - keyboardWillBeHidden
- (void)keyboardWillBeHidden {
    self.isShowKeyBoard = NO;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.informationView.frame = CGRectMake(0,
                                                    HEIGHT - SafeAreaBottomHeight - 997 * Proportion,
                                                    WIDTH, 1150 * Proportion);
    }];
}

- (void)getCashSucceedViewController {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              StatusBarHeight + NavigationBarHeight,
                                                              WIDTH,
                                                              HEIGHT - SafeAreaBottomHeight - StatusBarHeight + NavigationBarHeight)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    [self.view bringSubviewToFront:self.navBar];
    self.iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"钱包中心_提现申请成功"]];
    self.iconImage.backgroundColor = [UIColor clearColor];
    [self.iconImage sizeToFit];
    self.iconImage.frame = CGRectMake(WIDTH/2 - CGRectGetWidth(self.iconImage.frame)/2, 107 * Proportion, CGRectGetWidth(self.iconImage.frame), CGRectGetHeight(self.iconImage.frame));
    [bgView addSubview:self.iconImage];
    
    self.titlesLabel = [[UILabel alloc] init];
    self.titlesLabel.text = @"提现申请成功";
    self.titlesLabel.textColor = [UIColor CML383838Color];
    self.titlesLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    [self.titlesLabel sizeToFit];
    self.titlesLabel.frame = CGRectMake(WIDTH/2 - CGRectGetWidth(self.titlesLabel.frame)/2, CGRectGetMaxY(self.iconImage.frame) + 76 * Proportion, CGRectGetWidth(self.titlesLabel.frame), CGRectGetHeight(self.titlesLabel.frame));
    [bgView addSubview:self.titlesLabel];
    
    self.introLabel = [[UILabel alloc] init];
    self.introLabel.text = @"请等待客服联系";
    self.introLabel.textColor = [UIColor CML888888Color];
    self.introLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [self.introLabel sizeToFit];
    self.introLabel.frame = CGRectMake(WIDTH/2 - CGRectGetWidth(self.introLabel.frame)/2, CGRectGetMaxY(self.titlesLabel.frame) + 5 * Proportion, CGRectGetWidth(self.introLabel.frame), CGRectGetHeight(self.introLabel.frame));
    [bgView addSubview:self.introLabel];
    
    self.completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.completeButton setImage:[UIImage imageNamed:@"钱包中心_完成"] forState:UIControlStateNormal];
    self.completeButton.backgroundColor = [UIColor clearColor];
    [self.completeButton sizeToFit];
    self.completeButton.frame = CGRectMake(WIDTH/2 - CGRectGetWidth(self.completeButton.frame)/2,
                                           CGRectGetMaxY(self.introLabel.frame) + 71 * Proportion,
                                           CGRectGetWidth(self.completeButton.frame),
                                           CGRectGetHeight(self.completeButton.frame));
    [bgView addSubview:self.completeButton];
    [self.completeButton addTarget:self action:@selector(completeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)completeButtonClick {
    
    [self.delegate refreshWalletCenterViewController];
    [[VCManger mainVC] dismissCurrentVC];
    
}

- (void) didSelectedLeftBarItem{
    [self.delegate refreshWalletCenterViewController];
    [[VCManger mainVC] dismissCurrentVC];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
