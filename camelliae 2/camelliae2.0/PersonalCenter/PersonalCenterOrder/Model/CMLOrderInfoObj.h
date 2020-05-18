//
//  CMLOrderInfoObj.h
//  camelliae2.0
//
//  Created by 张越 on 16/6/1.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@class CMLNewInvoiceObj;

@interface CMLOrderInfoObj : BaseResultObj

@property (nonatomic,strong) NSNumber *clientId;

@property (nonatomic,copy) NSString *clientName;

@property (nonatomic,copy) NSString *contactName;

@property (nonatomic,copy) NSString *customerPhone;

@property (nonatomic,copy) NSString *contactPhone;

@property (nonatomic,copy) NSString *isAnonymous;

@property (nonatomic,copy) NSString *orderId;

@property (nonatomic,strong) NSNumber *orderStatus;

@property (nonatomic,copy) NSString *orderStatusStr;

@property (nonatomic,strong) NSNumber *orderTime;

@property (nonatomic,strong) NSNumber *payAmtE2;

@property (nonatomic,strong) NSNumber *payClientTypeId;

@property (nonatomic,copy) NSString *payClientTypeName;

@property (nonatomic,copy) NSString *payEndTime;

@property (nonatomic,copy) NSString *payStatus;

@property (nonatomic,copy) NSString *payStatusStr;

@property (nonatomic,strong) NSNumber *pointsCost;

@property (nonatomic,strong) NSNumber *pointsDeductionAmount;

@property (nonatomic,strong) NSNumber *userId;

@property (nonatomic,strong) NSNumber *goodsNum;

@property (nonatomic,copy) NSString *consigneeName;

@property (nonatomic,copy) NSString *consigneePhone;

@property (nonatomic,copy) NSString *consigneeAddress;

@property (nonatomic,strong) NSNumber *expressStatus;

@property (nonatomic,copy) NSString *expressUrl;

@property (nonatomic,copy) NSString *tradingStr;

@property (nonatomic,copy) NSString *remark;

@property (nonatomic,strong) NSNumber *packageId;

@property (nonatomic,copy) NSString *unitsStr;

@property (nonatomic,strong) NSNumber *point;

@property (nonatomic,strong) NSNumber *invoiceStatus;

@property (nonatomic,strong) CMLNewInvoiceObj *invoiceInfo;

@property (nonatomic,strong) NSNumber *freightE2;

@property (nonatomic, strong) NSNumber *deduc_money;

/*新增：票数*/
@property (nonatomic, strong) NSNumber *activity_num;

@property (nonatomic,copy) NSString *activityQrCode;

@end
