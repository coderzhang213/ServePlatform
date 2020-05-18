//
//  PackDetailInfoObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/4/26.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface PackDetailInfoObj : BaseResultObj

@property (nonatomic,strong) NSNumber *authorId;

@property (nonatomic,copy) NSString *brief;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,copy) NSString *packageName;

@property (nonatomic,strong) NSNumber *projectBeginTime;

@property (nonatomic,strong) NSNumber *projectEndTime;

@property (nonatomic,strong) NSNumber *projectMemberLimit;

@property (nonatomic,strong) NSNumber *projectObjId;

@property (nonatomic,strong) NSNumber *status;

@property (nonatomic,strong) NSNumber *surplusStock;

@property (nonatomic,strong) NSNumber *totalAmount;

@property (nonatomic,copy) NSString *rangeTotalAmount;

@property (nonatomic,copy) NSString *updateTime;

@property (nonatomic,copy) NSString *totalAmountStr;

@property (nonatomic,strong) NSArray *unitsPropertyInfo;

@property (nonatomic,strong) NSNumber *payMode;

@property (nonatomic,strong) NSNumber *subscription;

@property (nonatomic,strong) NSNumber *point;

@property (nonatomic,strong) NSNumber *pre_end_time;

@property (nonatomic,strong) NSNumber *pre_price;

@property (nonatomic,strong) NSNumber *is_pre;

@property (nonatomic,strong) NSNumber *pre_totalAmount;

@property (nonatomic, strong) NSNumber *isBuy;

@property (nonatomic, strong) NSNumber *payMoney;

@property (nonatomic, strong) NSNumber *discount;/*4.2.0套餐折扣价*/

@end
