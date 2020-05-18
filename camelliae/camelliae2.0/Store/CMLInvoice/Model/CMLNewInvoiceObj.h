//
//  CMLNewInvoiceObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/27.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface CMLNewInvoiceObj : BaseResultObj

@property (nonatomic,copy) NSString *personalName;

@property (nonatomic,copy) NSString *idCard;

@property (nonatomic,copy) NSString *companyAddress;

@property (nonatomic,copy) NSString *companyName;

@property (nonatomic,copy) NSString *companyPhone;

@property (nonatomic,copy) NSString *bankName;

@property (nonatomic,copy) NSString *bankAccount;

@property (nonatomic,strong) NSNumber *invoiceTop;

@property (nonatomic,strong) NSNumber *type;

@property (nonatomic,copy) NSString *taxpayerCode;


@end
