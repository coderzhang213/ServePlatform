//
//  CMLNewInvoiceDetailMesView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/27.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLNewInvoiceDetailMesView.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "UITextView+Placeholder.h"

@interface CMLNewInvoiceDetailMesView ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *currentTextField;

@property (nonatomic,strong) NSMutableDictionary *tempDic;

@end


@implementation CMLNewInvoiceDetailMesView

- (NSMutableDictionary *)tempDic{
    
    if (!_tempDic) {
        _tempDic = [NSMutableDictionary dictionary];
    }
    return _tempDic;
}

- (void) refrshViews{
    

    self.tempDic = [NSMutableDictionary dictionaryWithDictionary:self.targetDic];
    
    if ([[self.tempDic valueForKey:@"type"] intValue]  == 1 && [[self.tempDic valueForKey:@"invoiceTop"] intValue] == 2) {
        
        [self loadSecondTypeMes];
    }else if ([[self.tempDic valueForKey:@"type"] intValue]  == 2 && [[self.tempDic valueForKey:@"invoiceTop"] intValue] == 2){
        
        [self loadThirdTypeMes];
    }else{
        
        [self loadfirstTypeMes];
    }
    
}

- (void) loadfirstTypeMes{
    
    UILabel *firstSelectPromlab = [[UILabel alloc] init];
    firstSelectPromlab.text = @"收票人信息：";
    firstSelectPromlab.font = KSystemFontSize12;
    firstSelectPromlab.textColor = [UIColor CMLLineGrayColor];
    [firstSelectPromlab sizeToFit];
    firstSelectPromlab.frame = CGRectMake(30*Proportion,
                                          30*Proportion,
                                          firstSelectPromlab.frame.size.width,
                                          firstSelectPromlab.frame.size.height);
    [self addSubview:firstSelectPromlab];
    
    UILabel *userNameLab = [[UILabel alloc] init];
    userNameLab.font = KSystemBoldFontSize12;
    userNameLab.text = @"个人姓名：";
    userNameLab.textColor = [UIColor CMLBlackColor];
    [userNameLab sizeToFit];
    userNameLab.frame = CGRectMake(30*Proportion,
                                   CGRectGetMaxY(firstSelectPromlab.frame) + 57*Proportion,
                                   userNameLab.frame.size.width,
                                   userNameLab.frame.size.height);
    [self addSubview:userNameLab];
    
    UITextField *userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userNameLab.frame),
                                                                                   userNameLab.center.y - 100*Proportion/2.0,
                                                                                   WIDTH - CGRectGetMaxX(userNameLab.frame) - 30*Proportion,
                                                                                   100*Proportion)];
    userNameTextField.placeholder = @"选填，请输入个人姓名";
    userNameTextField.font = KSystemBoldFontSize13;
    
    userNameTextField.text = [self.tempDic objectForKey:@"personalName"];
    userNameTextField.delegate = self;
    [self addSubview:userNameTextField];
    [userNameTextField addTarget:self action:@selector(inputMessage:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *endLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userNameLab.frame),
                                                               CGRectGetMaxY(userNameTextField.frame),
                                                               userNameTextField.frame.size.width,
                                                               1*Proportion)];
    endLine.backgroundColor = [UIColor CMLPromptGrayColor];
    [self addSubview:endLine];
    
    UILabel *userCardLab = [[UILabel alloc] init];
    userCardLab.font = KSystemBoldFontSize12;
    userCardLab.text = @"身份号码：";
    userCardLab.textColor = [UIColor CMLBlackColor];
    [userCardLab sizeToFit];
    userCardLab.frame = CGRectMake(30*Proportion,
                                   CGRectGetMaxY(userNameLab.frame) + 76*Proportion,
                                   userCardLab.frame.size.width,
                                   userCardLab.frame.size.height);
    [self addSubview:userCardLab];
    
    UITextField *userCardTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userCardLab.frame),
                                                                                   userCardLab.center.y - 100*Proportion/2.0,
                                                                                   WIDTH - CGRectGetMaxX(userCardLab.frame) - 30*Proportion,
                                                                                   100*Proportion)];
    userCardTextField.placeholder = @"选填，请输入个人身份证号码";
    userCardTextField.text = [self.tempDic objectForKey:@"idCard"];
    userCardTextField.font = KSystemBoldFontSize13;
    userCardTextField.delegate = self;
    [self addSubview:userCardTextField];
    [userCardTextField addTarget:self action:@selector(inputMessage:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *endLineTwo = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userCardLab.frame),
                                                                  CGRectGetMaxY(userCardTextField.frame),
                                                                  userCardTextField.frame.size.width,
                                                                  1*Proportion)];
    endLineTwo.backgroundColor = [UIColor CMLPromptGrayColor];
    [self addSubview:endLineTwo];
    
    [self setVerbView:CGRectGetMaxY(userCardTextField.frame)];

}

- (void) loadSecondTypeMes{
    
    UILabel *firstSelectPromlab = [[UILabel alloc] init];
    firstSelectPromlab.text = @"收票人信息：";
    firstSelectPromlab.font = KSystemFontSize12;
    firstSelectPromlab.textColor = [UIColor CMLLineGrayColor];
    [firstSelectPromlab sizeToFit];
    firstSelectPromlab.frame = CGRectMake(30*Proportion,
                                          30*Proportion,
                                          firstSelectPromlab.frame.size.width,
                                          firstSelectPromlab.frame.size.height);
    [self addSubview:firstSelectPromlab];
    
    UILabel *userNameLab = [[UILabel alloc] init];
    userNameLab.font = KSystemBoldFontSize12;
    userNameLab.text = @"纳税人税号：";
    userNameLab.textColor = [UIColor CMLBlackColor];
    [userNameLab sizeToFit];
    userNameLab.frame = CGRectMake(30*Proportion,
                                   CGRectGetMaxY(firstSelectPromlab.frame) + 57*Proportion,
                                   userNameLab.frame.size.width,
                                   userNameLab.frame.size.height);
    [self addSubview:userNameLab];
    
    UITextField *userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userNameLab.frame),
                                                                                   userNameLab.center.y - 100*Proportion/2.0,
                                                                                   WIDTH - CGRectGetMaxX(userNameLab.frame) - 30*Proportion,
                                                                                   100*Proportion)];
    userNameTextField.placeholder = @"必填，请输入纳税人识别号";
    userNameTextField.text = [self.tempDic objectForKey:@"taxpayerCode"];
    userNameTextField.font = KSystemBoldFontSize13;
    userNameTextField.delegate = self;
    [self addSubview:userNameTextField];
    [userNameTextField addTarget:self action:@selector(inputMessage:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *endLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userNameLab.frame),
                                                               CGRectGetMaxY(userNameTextField.frame),
                                                               userNameTextField.frame.size.width,
                                                               1*Proportion)];
    endLine.backgroundColor = [UIColor CMLPromptGrayColor];
    [self addSubview:endLine];
    
    UILabel *userCardLab = [[UILabel alloc] init];
    userCardLab.font = KSystemBoldFontSize12;
    userCardLab.text = @"单位名称：";
    userCardLab.textColor = [UIColor CMLBlackColor];
    [userCardLab sizeToFit];
    userCardLab.frame = CGRectMake(30*Proportion,
                                   CGRectGetMaxY(userNameLab.frame) + 76*Proportion,
                                   userCardLab.frame.size.width,
                                   userCardLab.frame.size.height);
    [self addSubview:userCardLab];
    
    UITextField *userCardTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userCardLab.frame),
                                                                                   userCardLab.center.y - 100*Proportion/2.0,
                                                                                   WIDTH - CGRectGetMaxX(userCardLab.frame) - 30*Proportion,
                                                                                   100*Proportion)];
    userCardTextField.placeholder = @"必填，请输入单位名称";
    userCardTextField.text = [self.tempDic objectForKey:@"companyName"];
    userCardTextField.font = KSystemBoldFontSize13;
    userCardTextField.delegate = self;
    [self addSubview:userCardTextField];
    [userCardTextField addTarget:self action:@selector(inputMessage:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *endLineTwo = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userCardLab.frame),
                                                                  CGRectGetMaxY(userCardTextField.frame),
                                                                  userCardTextField.frame.size.width,
                                                                  1*Proportion)];
    endLineTwo.backgroundColor = [UIColor CMLPromptGrayColor];
    [self addSubview:endLineTwo];
    [self setVerbView:CGRectGetMaxY(userCardTextField.frame)];
}

- (void) loadThirdTypeMes{
    
    UILabel *firstSelectPromlab = [[UILabel alloc] init];
    firstSelectPromlab.text = @"收票人信息：";
    firstSelectPromlab.font = KSystemFontSize12;
    firstSelectPromlab.textColor = [UIColor CMLLineGrayColor];
    [firstSelectPromlab sizeToFit];
    firstSelectPromlab.frame = CGRectMake(30*Proportion,
                                          30*Proportion,
                                          firstSelectPromlab.frame.size.width,
                                          firstSelectPromlab.frame.size.height);
    [self addSubview:firstSelectPromlab];
    
    UILabel *userNameLab = [[UILabel alloc] init];
    userNameLab.font = KSystemBoldFontSize12;
    userNameLab.text = @"纳税人识别码：";
    userNameLab.textColor = [UIColor CMLInvoiceBlackColor];
    [userNameLab sizeToFit];
    userNameLab.frame = CGRectMake(30*Proportion,
                                   CGRectGetMaxY(firstSelectPromlab.frame) + 57*Proportion,
                                   userNameLab.frame.size.width,
                                   userNameLab.frame.size.height);
    [self addSubview:userNameLab];
    
    UITextField *userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userNameLab.frame),
                                                                                   userNameLab.center.y - 100*Proportion/2.0,
                                                                                   WIDTH - CGRectGetMaxX(userNameLab.frame) - 30*Proportion,
                                                                                   100*Proportion)];
    userNameTextField.placeholder = @"必填，请输入纳税人识别号";
    userNameTextField.text = [self.tempDic objectForKey:@"taxpayerCode"];
    userNameTextField.font = KSystemBoldFontSize13;
    userNameTextField.delegate = self;
    [self addSubview:userNameTextField];
    [userNameTextField addTarget:self action:@selector(inputMessage:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *endLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userNameLab.frame),
                                                               CGRectGetMaxY(userNameTextField.frame),
                                                               userNameTextField.frame.size.width,
                                                               1*Proportion)];
    endLine.backgroundColor = [UIColor CMLPromptGrayColor];
    [self addSubview:endLine];
    
    UILabel *userCardLab = [[UILabel alloc] init];
    userCardLab.font = KSystemBoldFontSize12;
    userCardLab.text = @"单位名称：";
    userCardLab.textColor = [UIColor CMLInvoiceBlackColor];
    [userCardLab sizeToFit];
    userCardLab.frame = CGRectMake(30*Proportion,
                                   CGRectGetMaxY(userNameLab.frame) + 76*Proportion,
                                   userCardLab.frame.size.width,
                                   userCardLab.frame.size.height);
    [self addSubview:userCardLab];
    
    UITextField *userCardTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userCardLab.frame),
                                                                                   userCardLab.center.y - 100*Proportion/2.0,
                                                                                   WIDTH - CGRectGetMaxX(userCardLab.frame) - 30*Proportion,
                                                                                   100*Proportion)];
    userCardTextField.placeholder = @"必填，请输入单位名称";
    userCardTextField.font = KSystemBoldFontSize13;
    userCardTextField.text = [self.tempDic objectForKey:@"companyName"];
    userCardTextField.delegate = self;
    [self addSubview:userCardTextField];
    [userCardTextField addTarget:self action:@selector(inputMessage:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *endLineTwo = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userCardLab.frame),
                                                                  CGRectGetMaxY(userCardTextField.frame),
                                                                  userCardTextField.frame.size.width,
                                                                  1*Proportion)];
    endLineTwo.backgroundColor = [UIColor CMLPromptGrayColor];
    [self addSubview:endLineTwo];
    
    UILabel *userAddressLab = [[UILabel alloc] init];
    userAddressLab.font = KSystemBoldFontSize12;
    userAddressLab.text = @"公司地址：";
    userAddressLab.numberOfLines = 0;
    userAddressLab.textColor = [UIColor CMLInvoiceBlackColor];
    [userAddressLab sizeToFit];
    userAddressLab.frame = CGRectMake(30*Proportion,
                                      CGRectGetMaxY(userCardLab.frame) + 76*Proportion,
                                      userAddressLab.frame.size.width,
                                      userAddressLab.frame.size.height);
    [self addSubview:userAddressLab];
    
    
    UITextField *userAddressTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userAddressLab.frame),
                                                                                      userAddressLab.center.y - 100*Proportion/2.0,
                                                                                      WIDTH - CGRectGetMaxX(userAddressLab.frame) - 30*Proportion,
                                                                                      100*Proportion)];
    userAddressTextField.placeholder = @"必填，请输入公司地址";
    userAddressTextField.text = [self.tempDic objectForKey:@"companyAddress"];
    userAddressTextField.font = KSystemBoldFontSize13;
    userAddressTextField.delegate = self;
    [self addSubview:userAddressTextField];
    [userAddressTextField addTarget:self action:@selector(inputMessage:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *endLineThree = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userAddressLab.frame),
                                                                    CGRectGetMaxY(userAddressTextField.frame),
                                                                    userAddressTextField.frame.size.width,
                                                                    1*Proportion)];
    endLineThree.backgroundColor = [UIColor CMLPromptGrayColor];
    [self addSubview:endLineThree];
    
    UILabel *userTeleLab = [[UILabel alloc] init];
    userTeleLab.font = KSystemBoldFontSize12;
    userTeleLab.text = @"公司电话：";
    userTeleLab.textColor = [UIColor CMLInvoiceBlackColor];
    [userTeleLab sizeToFit];
    userTeleLab.frame = CGRectMake(30*Proportion,
                                      CGRectGetMaxY(userAddressLab.frame) + 76*Proportion,
                                      userTeleLab.frame.size.width,
                                      userTeleLab.frame.size.height);
    [self addSubview:userTeleLab];
    
    UITextField *userTeleTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userTeleLab.frame),
                                                                                      userTeleLab.center.y - 100*Proportion/2.0,
                                                                                      WIDTH - CGRectGetMaxX(userTeleLab.frame) - 30*Proportion,
                                                                                      100*Proportion)];
    userTeleTextField.placeholder = @"必填，请输入公司电话";
    userTeleTextField.text = [self.tempDic objectForKey:@"companyPhone"];
    userTeleTextField.font = KSystemBoldFontSize13;
    userTeleTextField.delegate = self;
    [self addSubview:userTeleTextField];
    [userTeleTextField addTarget:self action:@selector(inputMessage:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *endLineFour = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userTeleLab.frame),
                                                                    CGRectGetMaxY(userTeleTextField.frame),
                                                                    userTeleTextField.frame.size.width,
                                                                    1*Proportion)];
    endLineFour.backgroundColor = [UIColor CMLPromptGrayColor];
    [self addSubview:endLineFour];
    
    UILabel *userBankLab = [[UILabel alloc] init];
    userBankLab.font = KSystemBoldFontSize12;
    userBankLab.text = @"开户银行：";
    userBankLab.textColor = [UIColor CMLInvoiceBlackColor];
    [userBankLab sizeToFit];
    userBankLab.frame = CGRectMake(30*Proportion,
                                   CGRectGetMaxY(userTeleLab.frame) + 76*Proportion,
                                   userBankLab.frame.size.width,
                                   userBankLab.frame.size.height);
    [self addSubview:userBankLab];
    
    UITextField *userBankTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userBankLab.frame),
                                                                                   userBankLab.center.y - 100*Proportion/2.0,
                                                                                   WIDTH - CGRectGetMaxX(userBankLab.frame) - 30*Proportion,
                                                                                   100*Proportion)];
    userBankTextField.placeholder = @"必填，请输入开户银行";
    userBankTextField.text = [self.tempDic objectForKey:@"bankName"];
    userBankTextField.font = KSystemBoldFontSize13;
    userBankTextField.delegate = self;
    [self addSubview:userBankTextField];
    [userBankTextField addTarget:self action:@selector(inputMessage:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *endLineFive = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userBankLab.frame),
                                                                   CGRectGetMaxY(userBankTextField.frame),
                                                                   userBankTextField.frame.size.width,
                                                                   1*Proportion)];
    endLineFive.backgroundColor = [UIColor CMLPromptGrayColor];
    [self addSubview:endLineFive];
    
    UILabel *userBankAccountLab = [[UILabel alloc] init];
    userBankAccountLab.font = KSystemBoldFontSize12;
    userBankAccountLab.text = @"银行账号：";
    userBankAccountLab.textColor = [UIColor CMLInvoiceBlackColor];
    [userBankAccountLab sizeToFit];
    userBankAccountLab.frame = CGRectMake(30*Proportion,
                                          CGRectGetMaxY(userBankLab.frame) + 76*Proportion,
                                          userBankAccountLab.frame.size.width,
                                          userBankAccountLab.frame.size.height);
    [self addSubview:userBankAccountLab];
    
    UITextField *userBankAccountTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userBankAccountLab.frame),
                                                                                          userBankAccountLab.center.y - 100*Proportion/2.0,
                                                                                          WIDTH - CGRectGetMaxX(userBankAccountLab.frame) - 30*Proportion,
                                                                                          100*Proportion)];
    userBankAccountTextField.placeholder = @"必填，请输入银行账号";
    userBankAccountTextField.text = [self.tempDic objectForKey:@"bankAccount"];
    userBankAccountTextField.font = KSystemBoldFontSize13;
    userBankAccountTextField.delegate = self;
    [self addSubview:userBankAccountTextField];
    [userBankAccountTextField addTarget:self action:@selector(inputMessage:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *endLineSix = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userBankAccountLab.frame),
                                                                  CGRectGetMaxY(userBankAccountTextField.frame)+10*Proportion,
                                                                  userBankAccountTextField.frame.size.width,
                                                                  1*Proportion)];
    endLineSix.backgroundColor = [UIColor CMLPromptGrayColor];
    [self addSubview:endLineSix];



    [self setVerbView:CGRectGetMaxY(userBankAccountTextField.frame)];
}


- (void) setVerbView:(CGFloat) currentY{
    
    UILabel *promLab = [[UILabel alloc] init];
    promLab.text = @"发票须知：";
    promLab.font = KSystemRealBoldFontSize13;
    promLab.textColor = [UIColor CMLBlackColor];
    [promLab sizeToFit];
    promLab.frame = CGRectMake(30*Proportion,
                               currentY + 100*Proportion,
                               promLab.frame.size.width,
                               promLab.frame.size.height);
    [self addSubview:promLab];
    
    UILabel *labOne = [[UILabel alloc] init];
    labOne.textColor = [UIColor CMLBlackColor];
    labOne.font = KSystemBoldFontSize12;
    labOne.text = @"1、开票金额为用户实际支付的金额";
    [labOne sizeToFit];
    labOne.frame = CGRectMake(30*Proportion,
                              CGRectGetMaxY(promLab.frame) + 30*Proportion,
                              labOne.frame.size.width,
                              labOne.frame.size.height);
    [self addSubview:labOne];
    
    UILabel *labOneExpress = [[UILabel alloc] init];
    labOneExpress.textColor = [UIColor CMLLineGrayColor];
    labOneExpress.text = @"（不含不支持该发票类型的商品实付金额）";
    labOneExpress.font = KSystemBoldFontSize10;
    [labOneExpress sizeToFit];
    labOneExpress.frame = CGRectMake(30*Proportion*2,
                                     CGRectGetMaxY(labOne.frame) + 10*Proportion,
                                     labOneExpress.frame.size.width,
                                     labOneExpress.frame.size.height);
    [self addSubview:labOneExpress];
    
    UILabel *labTwo = [[UILabel alloc] init];
    labTwo.textColor = [UIColor CMLBlackColor];
    labTwo.font = KSystemBoldFontSize12;
    labTwo.text = @"2、未随商品寄出的纸质发票会在后期单独寄出";
    [labTwo sizeToFit];
    labTwo.frame = CGRectMake(30*Proportion,
                              CGRectGetMaxY(labOneExpress.frame) + 30*Proportion,
                              labTwo.frame.size.width,
                              labTwo.frame.size.height);
    [self addSubview:labTwo];
    
    UILabel *labThree = [[UILabel alloc] init];
    labThree.textColor = [UIColor CMLBlackColor];
    labThree.font = KSystemBoldFontSize12;
    labThree.text = @"3、单笔订单只支持开具一种类型的发票";
    [labThree sizeToFit];
    labThree.frame = CGRectMake(30*Proportion,
                                CGRectGetMaxY(labTwo.frame) + 30*Proportion,
                                labThree.frame.size.width,
                                labThree.frame.size.height);
    [self addSubview:labThree];
    
    self.frame = CGRectMake(0,
                            0,
                            WIDTH,
                            CGRectGetMaxY(labThree.frame) + 100*Proportion);
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.currentTextField = textField;
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.currentTextField resignFirstResponder];
}

- (void) refreshInvoiceType:(NSNumber *) type{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if ([type intValue] == 1) {
        
        [self loadfirstTypeMes];
        
    }else if ([type intValue] == 2){
        
        [self loadSecondTypeMes];
        
    }else if ([type intValue] == 3){
        
        [self loadThirdTypeMes];
        
    }
    
    [self.delegate refreshCurrentHeight:self.frame.size.height];
}

- (void) inputMessage:(UITextField *) tempTextField{
    

    if ([tempTextField.placeholder isEqualToString:@"选填，请输入个人姓名"]) {
        
        [self.tempDic setObject:tempTextField.text forKey:@"personalName"];
        
    }else if ([tempTextField.placeholder isEqualToString:@"选填，请输入个人身份证号码"]){
        
        [self.tempDic setObject:tempTextField.text forKey:@"idCard"];
     
    }else if ([tempTextField.placeholder isEqualToString:@"必填，请输入纳税人识别号"]){
        
        [self.tempDic setObject:tempTextField.text forKey:@"taxpayerCode"];
  
    }else if ([tempTextField.placeholder isEqualToString:@"必填，请输入单位名称"]){
        
         [self.tempDic setObject:tempTextField.text forKey:@"companyName"];
        
        
    }else if ([tempTextField.placeholder isEqualToString:@"必填，请输入公司地址"]){
        
       [self.tempDic setObject:tempTextField.text forKey:@"companyAddress"];
       
    }else if ([tempTextField.placeholder isEqualToString:@"必填，请输入公司电话"]){
        
        [self.tempDic setObject:tempTextField.text forKey:@"companyPhone"];
        
    }else if ([tempTextField.placeholder isEqualToString:@"必填，请输入开户银行"]){
        
        [self.tempDic setObject:tempTextField.text forKey:@"bankName"];
       
    }else if ([tempTextField.placeholder isEqualToString:@"必填，请输入银行账号"]){
        
        [self.tempDic setObject:tempTextField.text forKey:@"bankAccount"];
     
    }
 
    self.targetDic = self.tempDic;
    
}
@end
