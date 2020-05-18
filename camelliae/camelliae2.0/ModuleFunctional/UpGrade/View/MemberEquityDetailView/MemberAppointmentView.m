//
//  MemberAppointmentView.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/15.
//  Copyright © 2019 张越. All rights reserved.
//

#import "MemberAppointmentView.h"
#import "NetWorkTask.h"
#import "NetConfig.h"
#import "SVProgressHUD.h"
#import "UpGradeVC.h"
#import "VCManger.h"

@interface MemberAppointmentView ()<UITextFieldDelegate, NetWorkProtocol>

@property (nonatomic, copy) NSString *currentApiName;

@property (nonatomic, strong) UITextField *appointmentTextField;

@property (nonatomic, strong) UIButton *confirmAppointmentBtn;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) UIButton *secondButton;

@property (nonatomic, strong) UIButton *thirdButton;

@property (nonatomic, strong) UIButton *fourthButton;

@property (nonatomic, strong) UIButton *firstButton;

@property (nonatomic, assign) BOOL isSelected;

@end

@implementation MemberAppointmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        self.clipsToBounds = YES;
        self.isSelected = YES;
        self.layer.cornerRadius = 10 * Proportion;
        self.backgroundColor = [UIColor CMLF1F1F1Color];
        [self loadMemberAppointmentView];
        
    }
    return self;
}

- (void)loadMemberAppointmentView {
    
    self.titleArray = @[@"生活便利服务", @"餐饮预约", @"酒店预订", @"高端陪诊"];
    
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLMemberEquityAppointmentImage]];
    iconImage.backgroundColor = [UIColor clearColor];
    [iconImage sizeToFit];
    iconImage.frame = CGRectMake(42 * Proportion,
                                 57 * Proportion,
                                 CGRectGetWidth(iconImage.frame),
                                 CGRectGetHeight(iconImage.frame));
    [self addSubview:iconImage];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"请选择预约服务";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake(CGRectGetMaxX(iconImage.frame) + 20 * Proportion,
                                  CGRectGetMidY(iconImage.frame) - CGRectGetHeight(titleLabel.frame)/2,
                                  CGRectGetWidth(titleLabel.frame),
                                  CGRectGetHeight(titleLabel.frame));
    [self addSubview:titleLabel];
    
    [self createChooseView];
    
    self.confirmAppointmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmAppointmentBtn setImage:[UIImage imageNamed:CMLConfirmAppointmentButtonNoSelectImg] forState:UIControlStateNormal];
    [self.confirmAppointmentBtn setImage:[UIImage imageNamed:CMLConfirmAppointmentButtonSelectImg] forState:UIControlStateSelected];
    [self.confirmAppointmentBtn sizeToFit];
    self.confirmAppointmentBtn.highlighted = NO;
    self.confirmAppointmentBtn.frame = CGRectMake(CGRectGetWidth(self.frame)/2 - CGRectGetWidth(self.confirmAppointmentBtn.frame)/2,
                                                  CGRectGetHeight(self.frame) - CGRectGetHeight(self.confirmAppointmentBtn.frame) - 28 * Proportion,
                                                  CGRectGetWidth(self.confirmAppointmentBtn.frame),
                                                  CGRectGetHeight(self.confirmAppointmentBtn.frame));
    [self.confirmAppointmentBtn addTarget:self action:@selector(confirmAppointmentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.confirmAppointmentBtn];
    
}

- (void)createChooseView {

    for (int i = 0; i < 5; i++) {
        
        UIView *chooseView = [[UIView alloc] initWithFrame:CGRectMake(20 * Proportion, i*134*Proportion + 108 * Proportion, CGRectGetWidth(self.frame) - 20 * Proportion * 2, 114 * Proportion)];
        
        chooseView.backgroundColor = [UIColor CMLFAFAFAColor];
        chooseView.clipsToBounds = YES;
        chooseView.layer.cornerRadius = 8 * Proportion;
        chooseView.layer.borderColor = [UIColor CMLGrayD8D8D8Color].CGColor;
        chooseView.layer.borderWidth = 1 * Proportion;
        
        [self addSubview:chooseView];
        
        if (i == 0) {
            self.firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.firstButton.tag = i;
            [self.firstButton setImage:[UIImage imageNamed:CMLMemberEquityNotCheckImage] forState:UIControlStateNormal];
            [self.firstButton setImage:[UIImage imageNamed:CMLCheckButtonSelectImg] forState:UIControlStateSelected];
            [self.firstButton sizeToFit];
            self.firstButton.frame = CGRectMake(CGRectGetWidth(chooseView.frame) - CGRectGetWidth(self.firstButton.frame) - 26 * Proportion,
                                                CGRectGetHeight(chooseView.frame)/2 - CGRectGetHeight(self.firstButton.frame)/2,
                                                CGRectGetWidth(self.firstButton.frame),
                                                CGRectGetHeight(self.firstButton.frame));
            [self.firstButton addTarget:self action:@selector(chooseImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [chooseView addSubview:self.firstButton];
        }else if (i == 1) {
            self.secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.secondButton.tag = i;
            [self.secondButton setImage:[UIImage imageNamed:CMLMemberEquityNotCheckImage] forState:UIControlStateNormal];
            [self.secondButton setImage:[UIImage imageNamed:CMLCheckButtonSelectImg] forState:UIControlStateSelected];
            [self.secondButton sizeToFit];
            self.secondButton.frame = CGRectMake(CGRectGetWidth(chooseView.frame) - CGRectGetWidth(self.secondButton.frame) - 26 * Proportion,
                                                 CGRectGetHeight(chooseView.frame)/2 - CGRectGetHeight(self.secondButton.frame)/2,
                                                 CGRectGetWidth(self.secondButton.frame),
                                                 CGRectGetHeight(self.secondButton.frame));
            [self.secondButton addTarget:self action:@selector(chooseImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [chooseView addSubview:self.secondButton];
        }else if (i == 2) {
            self.thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.thirdButton.tag = i;
            [self.thirdButton setImage:[UIImage imageNamed:CMLMemberEquityNotCheckImage] forState:UIControlStateNormal];
            [self.thirdButton setImage:[UIImage imageNamed:CMLCheckButtonSelectImg] forState:UIControlStateSelected];
            [self.thirdButton sizeToFit];
            self.thirdButton.frame = CGRectMake(CGRectGetWidth(chooseView.frame) - CGRectGetWidth(self.thirdButton.frame) - 26 * Proportion,
                                                CGRectGetHeight(chooseView.frame)/2 - CGRectGetHeight(self.thirdButton.frame)/2,
                                                CGRectGetWidth(self.thirdButton.frame),
                                                CGRectGetHeight(self.thirdButton.frame));
            [self.thirdButton addTarget:self action:@selector(chooseImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [chooseView addSubview:self.thirdButton];
        }else if (i == 3) {
            self.fourthButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.fourthButton.tag = i;
            [self.fourthButton setImage:[UIImage imageNamed:CMLMemberEquityNotCheckImage] forState:UIControlStateNormal];
            [self.fourthButton setImage:[UIImage imageNamed:CMLCheckButtonSelectImg] forState:UIControlStateSelected];
            [self.fourthButton sizeToFit];
            self.fourthButton.frame = CGRectMake(CGRectGetWidth(chooseView.frame) - CGRectGetWidth(self.fourthButton.frame) - 26 * Proportion,
                                                 CGRectGetHeight(chooseView.frame)/2 - CGRectGetHeight(self.fourthButton.frame)/2,
                                                 CGRectGetWidth(self.fourthButton.frame),
                                                 CGRectGetHeight(self.fourthButton.frame));
            [self.fourthButton addTarget:self action:@selector(chooseImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [chooseView addSubview:self.fourthButton];
        }else {
            self.appointmentTextField = [[UITextField alloc] initWithFrame:CGRectMake(19 * Proportion, CGRectGetHeight(chooseView.frame)/2 - 32 * Proportion/2, CGRectGetWidth(chooseView.frame) - 19 * Proportion * 2, 32 * Proportion)];
            self.appointmentTextField.delegate = self;
            self.appointmentTextField.placeholder = @"请填写您要预约的品牌货店铺名称";
            self.appointmentTextField.font = [UIFont systemFontOfSize:13 weight:UIFontWeightThin];
            self.appointmentTextField.textColor = [UIColor CMLIntroGrayColor];
            self.appointmentTextField.textAlignment = NSTextAlignmentLeft;
            self.appointmentTextField.returnKeyType = UIReturnKeyDone;
            self.remark = self.appointmentTextField.text;
            [chooseView addSubview:self.appointmentTextField];
        }
        
        if (i < 4) {
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = self.titleArray[i];
            titleLabel.textColor = [UIColor CMLIntroGrayColor];
            titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
            [titleLabel sizeToFit];
            titleLabel.frame = CGRectMake(19 * Proportion, CGRectGetHeight(chooseView.frame)/2 - CGRectGetHeight(titleLabel.frame)/2, CGRectGetWidth(titleLabel.frame), CGRectGetHeight(titleLabel.frame));
            [chooseView addSubview:titleLabel];
            
        }
        
    }
    
}

- (void)chooseImageButtonClicked:(UIButton *)button {
    
    self.confirmAppointmentBtn.selected = YES;
    if (button.tag == 0) {
        self.firstButton.selected = YES;
        self.secondButton.selected = NO;
        self.thirdButton.selected = NO;
        self.fourthButton.selected = NO;
    }else if (button.tag == 1) {
        self.firstButton.selected = NO;
        self.secondButton.selected = YES;
        self.thirdButton.selected = NO;
        self.fourthButton.selected = NO;
    }else if (button.tag == 2) {
        self.firstButton.selected = NO;
        self.secondButton.selected = NO;
        self.thirdButton.selected = YES;
        self.fourthButton.selected = NO;
    }else {
        self.firstButton.selected = NO;
        self.secondButton.selected = NO;
        self.thirdButton.selected = NO;
        self.fourthButton.selected = YES;
    }
    
    self.title = self.titleArray[(int)button.tag];
    
}

- (void)confirmAppointmentBtnClicked {
    
    if (self.confirmAppointmentBtn.selected == YES) {
        /*上传数据*/
        NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
        delegate.delegate = self;
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        NSNumber *userID = [[DataManager lightData] readUserID];
        [paraDic setObject:userID forKey:@"user_id"];
        [paraDic setObject:self.title forKey:@"title"];
        [paraDic setObject:self.remark forKey:@"remark"];
        [NetWorkTask postResquestWithApiName:MemberVIPAppointment paraDic:paraDic delegate:delegate];
        self.currentApiName = MemberVIPAppointment;
        [SVProgressHUD showWithStatus:@"提交中"];
    }

}

- (void)requestSucceedBack:(id)responseResult withApiName:(NSString *)apiName {
    
    if ([self.currentApiName isEqualToString:MemberVIPAppointment]) {
        
        BaseResultObj *resObj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([resObj.retCode intValue] == 0 && resObj) {
            
            [SVProgressHUD showSuccessWithStatus:@"提交预约成功"];
            UpGradeVC *vc = [[UpGradeVC alloc] init];
            [[VCManger mainVC] pushVC:vc animate:YES];
            
        }else {
            
            [SVProgressHUD showSuccessWithStatus:@"预约失败"];
            
        }
        
    }
    
}

- (void)requestFailBack:(id)errorResult withApiName:(NSString *)apiName {
    
    [SVProgressHUD showErrorWithStatus:@"网络连接失败" duration:1.0];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.appointmentTextField) {
        
        if (range.length == 1 && string.length == 0) {
            return YES;
        }else if (self.appointmentTextField.text.length >= 18) {
            self.appointmentTextField.text = [textField.text substringToIndex:18];
            return NO;
        }
    }
    return YES;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.appointmentTextField resignFirstResponder];
    [self.delegate recoveryMemberAppointmentView];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self.delegate offsetMemberAppointmentView];
    
    return YES;
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.delegate recoveryMemberAppointmentView];

    [self.appointmentTextField resignFirstResponder];
    
    return YES;
    
}

- (void)appointmentTextFieldResignFirstResponder {
    
    [self.appointmentTextField resignFirstResponder];
    
}

@end
