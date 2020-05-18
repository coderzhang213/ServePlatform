//
//  CMLNewInvoiceSelectView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/27.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLNewInvoiceSelectView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"

@interface CMLNewInvoiceSelectView ()

@property (nonatomic,strong) UIButton *personalBtn;

@property (nonatomic,strong) UIButton *companyBtn;

@property (nonatomic,strong) UIButton *normalBtn;

@property (nonatomic,strong) UIButton *professionalBtn;

@end

@implementation CMLNewInvoiceSelectView

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void) loadViews{
    
    UILabel *firstSelectPromlab = [[UILabel alloc] init];
    firstSelectPromlab.text = @"发票抬头：";
    firstSelectPromlab.font = KSystemFontSize12;
    firstSelectPromlab.textColor = [UIColor CMLLineGrayColor];
    [firstSelectPromlab sizeToFit];
    firstSelectPromlab.frame = CGRectMake(30*Proportion,
                                          30*Proportion,
                                          firstSelectPromlab.frame.size.width,
                                          firstSelectPromlab.frame.size.height);
    [self addSubview:firstSelectPromlab];
    
    self.personalBtn = [[UIButton alloc] init];
    [self.personalBtn setImage:[UIImage imageNamed:MailCarBrandNoSelectImg] forState:UIControlStateNormal];
    [self.personalBtn setImage:[UIImage imageNamed:MailCarBrandSelectedImg] forState:UIControlStateSelected];
    [self.personalBtn setTitle:@"个人" forState:UIControlStateNormal];
    self.personalBtn.titleLabel.font = KSystemFontSize13;
    [self.personalBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20*Proportion, 0, 0)];
    [self.personalBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    [self.personalBtn sizeToFit];
    self.personalBtn.frame = CGRectMake(30*Proportion,
                                        CGRectGetMaxY(firstSelectPromlab.frame) + 30*Proportion,
                                        self.personalBtn.frame.size.width + 40*Proportion,
                                        self.personalBtn.frame.size.height);
    self.personalBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:self.personalBtn];
    [self.personalBtn addTarget:self action:@selector(changePersonalStatus) forControlEvents:UIControlEventTouchUpInside];
    
    self.companyBtn = [[UIButton alloc] init];
    [self.companyBtn setImage:[UIImage imageNamed:MailCarBrandNoSelectImg] forState:UIControlStateNormal];
    [self.companyBtn setImage:[UIImage imageNamed:MailCarBrandSelectedImg] forState:UIControlStateSelected];
    [self.companyBtn setTitle:@"企业" forState:UIControlStateNormal];
    self.companyBtn.titleLabel.font = KSystemFontSize13;
    [self.companyBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    [self.companyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20*Proportion, 0, 0)];
    self.companyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.companyBtn sizeToFit];
    self.companyBtn.frame = CGRectMake(90*Proportion + CGRectGetMaxX(self.personalBtn.frame),
                                       CGRectGetMaxY(firstSelectPromlab.frame) + 30*Proportion,
                                       self.companyBtn.frame.size.width + 40*Proportion,
                                       self.companyBtn.frame.size.height);
    [self addSubview:self.companyBtn];
    [self.companyBtn addTarget:self action:@selector(changeCompanyStatus) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *secondSelectPromlab = [[UILabel alloc] init];
    secondSelectPromlab.text = @"发票类型：";
    secondSelectPromlab.font = KSystemFontSize12;
    secondSelectPromlab.textColor = [UIColor CMLLineGrayColor];
    [secondSelectPromlab sizeToFit];
    secondSelectPromlab.frame = CGRectMake(30*Proportion,
                                           80*Proportion + CGRectGetMaxY(self.personalBtn.frame),
                                           secondSelectPromlab.frame.size.width,
                                           secondSelectPromlab.frame.size.height);
    [self addSubview:secondSelectPromlab];
    
    self.normalBtn = [[UIButton alloc] init];
    [self.normalBtn setImage:[UIImage imageNamed:MailCarBrandNoSelectImg] forState:UIControlStateNormal];
    [self.normalBtn setImage:[UIImage imageNamed:MailCarBrandSelectedImg] forState:UIControlStateSelected];
    [self.normalBtn setTitle:@"普通发票" forState:UIControlStateNormal];
    self.normalBtn.titleLabel.font = KSystemFontSize13;
    [self.normalBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    [self.normalBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20*Proportion, 0, 0)];
    self.normalBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.normalBtn sizeToFit];
    self.normalBtn.frame = CGRectMake(30*Proportion,
                                      CGRectGetMaxY(secondSelectPromlab.frame) + 30*Proportion,
                                      self.normalBtn.frame.size.width + 40*Proportion,
                                      self.normalBtn.frame.size.height);
    [self addSubview:self.normalBtn];
    [self.normalBtn addTarget:self action:@selector(changeNormalStatus) forControlEvents:UIControlEventTouchUpInside];
    
    self.professionalBtn = [[UIButton alloc] init];
    [self.professionalBtn setImage:[UIImage imageNamed:MailCarBrandNoSelectImg] forState:UIControlStateNormal];
    [self.professionalBtn setImage:[UIImage imageNamed:MailCarBrandSelectedImg] forState:UIControlStateSelected];
    [self.professionalBtn setTitle:@"专用发票" forState:UIControlStateNormal];
    self.professionalBtn.titleLabel.font = KSystemFontSize13;
    [self.professionalBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    [self.professionalBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20*Proportion, 0, 0)];
    self.professionalBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.professionalBtn sizeToFit];
    self.professionalBtn.frame = CGRectMake(90*Proportion + CGRectGetMaxX(self.normalBtn.frame),
                                            CGRectGetMaxY(secondSelectPromlab.frame) + 30*Proportion,
                                            self.professionalBtn.frame.size.width + 40*Proportion,
                                            self.professionalBtn.frame.size.height);
    [self addSubview:self.professionalBtn];
    [self.professionalBtn addTarget:self action:@selector(changeProfessionalStatus) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ([self.invoiceType intValue] == 1) {
        
        self.normalBtn.selected = YES;
        
    }else if ([self.invoiceType intValue] == 2){
        
        self.professionalBtn.selected = YES;
    }
    
    if ([self.userType intValue] == 1) {
        
        self.personalBtn.selected = YES;
        self.professionalBtn.userInteractionEnabled = NO;
        [self.professionalBtn setTitleColor:[UIColor CMLPromptGrayColor] forState:UIControlStateNormal];
        
    }else if ([self.userType intValue] == 2){
        
        self.companyBtn.selected = YES;
    }
    
    self.frame = CGRectMake(0,
                            0,
                            WIDTH,
                            CGRectGetMaxY(self.professionalBtn.frame));
    
}

- (void) changePersonalStatus{
    
    self.personalBtn.selected = !self.personalBtn.selected;
    if (self.personalBtn.selected) {
        
        self.userType = [NSNumber numberWithInt:1];
        
        self.companyBtn.selected = NO;
        if (self.professionalBtn.selected){
            self.invoiceType = [NSNumber numberWithInt:0];
        }
        self.professionalBtn.selected = NO;
        self.professionalBtn.userInteractionEnabled = NO;
        [self.professionalBtn setTitleColor:[UIColor CMLPromptGrayColor] forState:UIControlStateNormal];
    }else{
        
        self.userType = [NSNumber numberWithInt:0];
    }
   
    if ([self.userType intValue] == 1 && [self.invoiceType intValue] == 1) {
    
        [self.delegate selectType:[NSNumber numberWithInt:1]];
    }
    
}

- (void) changeCompanyStatus{
    
    self.companyBtn.selected = !self.companyBtn.selected;
    if (self.companyBtn.selected) {
        
        self.userType = [NSNumber numberWithInt:2];
        
        self.personalBtn.selected = NO;
        
        if (!self.professionalBtn.userInteractionEnabled) {
            
            self.professionalBtn.userInteractionEnabled = YES;
            [self.professionalBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
        }
    }else{
        
        self.userType = [NSNumber numberWithInt:0];
    }
    
    if ([self.userType intValue] == 2 && [self.invoiceType intValue] == 1) {
        
        [self.delegate selectType:[NSNumber numberWithInt:2]];
    }else if ([self.userType intValue] == 2 && [self.invoiceType intValue] == 2){
        
         [self.delegate selectType:[NSNumber numberWithInt:3]];
    }
}

- (void) changeNormalStatus{
    
    self.normalBtn.selected = !self.normalBtn.selected;
    
    if (self.normalBtn.selected) {
     
        self.invoiceType = [NSNumber numberWithInt:1];
        self.professionalBtn.selected = NO;
    }else{
        
        self.invoiceType = [NSNumber numberWithInt:0];
    }
    
    if ([self.invoiceType intValue] == 1 && [self.userType intValue] == 1) {
        
        [self.delegate selectType:[NSNumber numberWithInt:1]];
    }else if ([self.invoiceType intValue] == 1 && [self.userType intValue] == 2){
        
        [self.delegate selectType:[NSNumber numberWithInt:2]];
    }
}

- (void) changeProfessionalStatus{
    
    self.professionalBtn.selected = !self.professionalBtn.selected;
    
    if (self.professionalBtn.selected) {
        
        self.invoiceType = [NSNumber numberWithInt:2];
        self.normalBtn.selected = NO;
    }else{
        
        self.invoiceType = [NSNumber numberWithInt:0];
    }
    
    if ([self.invoiceType intValue] == 2 && [self.invoiceType intValue] == 2) {
        
        [self.delegate selectType:[NSNumber numberWithInt:3]];
    }
}
@end
