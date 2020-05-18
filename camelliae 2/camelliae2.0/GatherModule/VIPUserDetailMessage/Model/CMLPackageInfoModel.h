//
//  CMLPackageInfoModel.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/5/20.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "BaseResultObj.h"



@interface CMLPackageInfoModel : BaseResultObj

@property (nonatomic, strong) NSNumber *payMoney;

@property (nonatomic, strong) NSArray *unitsPropertyInfo;

@property (nonatomic, strong) NSNumber *memberLevel;

@property (nonatomic, strong) NSNumber *status;

@property (nonatomic, strong) NSNumber *pre_end_time;

@property (nonatomic, strong) NSNumber *pre_price;

@property (nonatomic, strong) NSNumber *is_pre;

@property (nonatomic, copy) NSString *packageName;

@property (nonatomic, copy) NSString *updateTime;

@property (nonatomic, copy) NSString *brief;

@property (nonatomic, copy) NSString *totalAmountStr;

@property (nonatomic, copy) NSString *packageCode;

@property (nonatomic, strong) NSNumber *point;

@property (nonatomic, strong) NSNumber *projectMemberLimit;

@property (nonatomic, strong) NSNumber *currentID;

@property (nonatomic, strong) NSNumber *true_totalAmount;

@property (nonatomic, strong) NSNumber *projectObjId;

@property (nonatomic, strong) NSNumber *totalAmount;

@property (nonatomic, strong) NSNumber *authorId;

@property (nonatomic, strong) NSNumber *surplusStock;

@end
