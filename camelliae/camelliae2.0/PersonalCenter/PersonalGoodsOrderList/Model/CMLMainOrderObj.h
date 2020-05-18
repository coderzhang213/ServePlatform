//
//  CMLMainOrderObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/11.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface CMLMainOrderObj : BaseResultObj

@property (nonatomic,copy) NSString *orderId;

@property (nonatomic,copy) NSString *payStatusStr;

@property (nonatomic,strong) NSNumber *point;

@property (nonatomic,strong) NSNumber *payAmtE2;

@property (nonatomic,copy) NSString *tradingStr;

@property (nonatomic,strong,readonly) NSNumber *deduc_money;

@property (nonatomic,strong) NSNumber *freightE2;


@end
