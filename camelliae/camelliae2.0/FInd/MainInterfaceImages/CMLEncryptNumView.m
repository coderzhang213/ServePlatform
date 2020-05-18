//
//  CMLEncryptNumView.m
//  camelliae2.0
//
//  Created by 张越 on 2018/6/19.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "CMLEncryptNumView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"

@interface CMLEncryptNumView()<UITextFieldDelegate>

@end

@implementation CMLEncryptNumView

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.frame = CGRectMake(0,
                                0,
                                396*Proportion,
                                396*Proportion);
        self.backgroundColor = [[UIColor CMLWhiteColor] colorWithAlphaComponent:0.5];
        

        
        [self loadViews];
    }
    
    return self;
}


- (void) loadViews{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10*Proportion,
                                                              10*Proportion,
                                                              self.frame.size.width - 10*Proportion*2,
                                                              self.frame.size.height - 10*Proportion*2)];
    bgView.backgroundColor = [UIColor CMLWhiteColor];
    [self addSubview:bgView];
    
    UILabel *topTitleLab = [[UILabel alloc] init];
    topTitleLab.font = KSystemBoldFontSize17;
    topTitleLab.textColor = [UIColor CMLNewbgBrownColor];
    topTitleLab.text = @"此图集已加密";
    [topTitleLab sizeToFit];
    topTitleLab.frame =  CGRectMake(self.frame.size.width/2.0 - topTitleLab.frame.size.width/2.0,
                                    46*Proportion,
                                    topTitleLab.frame.size.width,
                                    topTitleLab.frame.size.height);
    [self addSubview:topTitleLab];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2.0 - 220*Proportion/2.0,
                                                                CGRectGetMaxY(topTitleLab.frame) + 12*Proportion,
                                                                220*Proportion,
                                                                1*Proportion)];
    lineView.backgroundColor = [UIColor CMLNewbgBrownColor];
    [self addSubview:lineView];
    
    UILabel *promTitleLab = [[UILabel alloc] init];
    promTitleLab.font = KSystemFontSize11;
    promTitleLab.textColor = [UIColor CMLNewbgBrownColor];
    promTitleLab.text = @"请联系花伴使者";
    [promTitleLab sizeToFit];
    promTitleLab.frame =  CGRectMake(self.frame.size.width/2.0 - promTitleLab.frame.size.width/2.0,
                                    CGRectGetMaxY(lineView.frame) + 20*Proportion,
                                    promTitleLab.frame.size.width,
                                    promTitleLab.frame.size.height);
    [self addSubview:promTitleLab];
    
    
    self.inputEncrptNumField = [[UITextField alloc] initWithFrame:CGRectMake(self.frame.size.width/2.0 - 276*Proportion/2.0,
                                                                             CGRectGetMaxY(promTitleLab.frame) + 44*Proportion,
                                                                             276*Proportion,
                                                                             48*Proportion)];
    self.inputEncrptNumField.layer.cornerRadius = 6*Proportion;
    self.inputEncrptNumField.layer.borderColor = [UIColor CMLNewbgBrownColor].CGColor;
    self.inputEncrptNumField.delegate = self;
    self.inputEncrptNumField.layer.borderWidth = 1*Proportion;
    self.inputEncrptNumField.placeholder = @"请输入密码";
    self.inputEncrptNumField.textAlignment = NSTextAlignmentCenter;
    self.inputEncrptNumField.font = KSystemFontSize11;
    [self addSubview:self.inputEncrptNumField];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2.0 - 276*Proportion/2.0,
                                                                      CGRectGetMaxY(self.inputEncrptNumField.frame) + 24*Proportion,
                                                                      276*Proportion,
                                                                      48*Proportion)];
    confirmBtn.backgroundColor = [UIColor CMLNewbgBrownColor];
    confirmBtn.layer.cornerRadius = 6*Proportion;
    confirmBtn.titleLabel.font = KSystemFontSize11;
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
    [self addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirmNum) forControlEvents:UIControlEventTouchUpInside];
    

}

- (void) confirmNum{
    
    [self.delegate confirmEncryptNum];
}
#pragma mark - UITextFieldDelegate

@end
