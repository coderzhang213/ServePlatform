//
//  CMLInvoiceSelectView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/20.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLInvoiceSelectView.h"
#import "UIColor+SDExspand.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "CommonImg.h"

@implementation CMLInvoiceSelectView

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
    
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    UILabel *invoiceTypeOne = [[UILabel alloc] init];
    invoiceTypeOne.backgroundColor = [UIColor CMLWhiteColor];
    invoiceTypeOne.textColor = [UIColor CMLLineGrayColor];
    invoiceTypeOne.text = @"发票抬头：";
    invoiceTypeOne.font = KSystemBoldFontSize12;
    [invoiceTypeOne sizeToFit];
    invoiceTypeOne.frame = CGRectMake(30*Proportion,
                                      30*Proportion ,
                                      invoiceTypeOne.frame.size.width,
                                      invoiceTypeOne.frame.size.height);
    [self addSubview:invoiceTypeOne];
    
}

@end
