//
//  CMLCommenOrderObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/11.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface CMLCommenOrderObj : BaseResultObj

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *coverPicThumb;

@property (nonatomic,strong) PackageInfoObj *packageInfo;

@property (nonatomic,strong) NSNumber *afterSaleStatus;

@property (nonatomic,copy) NSString *afterSaleStatusStr;

@property (nonatomic,strong) NSNumber *backOutStatus;

@property (nonatomic,strong) NSNumber *tradingStatus;

@property (nonatomic,copy) NSString *tradingStr;

@property (nonatomic,strong) NSNumber *payAmtE2;

@property (nonatomic,strong) NSNumber *goodsNum;

@property (nonatomic,copy) NSString *packageName;

@property (nonatomic,strong) NSNumber *expressStatus;

@property (nonatomic,copy) NSString *courierName;

@property (nonatomic,copy) NSString *expressSingle;

@property (nonatomic,copy) NSString *expressUrl;

@property (nonatomic,strong) NSNumber *payType;

@property (nonatomic,strong) NSNumber *backOutType;

@end
