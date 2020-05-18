//
//  CMLMyCouponsModel.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/7/17.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "BaseResultObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMLMyCouponsModel : BaseResultObj

@property (nonatomic, copy) NSString *currentID;      /*该条内容id*/

@property (nonatomic, copy) NSString *userId;         /*用户id*/

@property (nonatomic, copy) NSString *couponsId;      /*优惠券id*/

@property (nonatomic, copy) NSString *isUse;          /*是否使用 1-已使用 0-未使用*/

@property (nonatomic, copy) NSString *beginTimeStr;   /*开始时间戳*/

@property (nonatomic, copy) NSString *endTimeStr;     /*结束时间戳*/

@property (nonatomic, copy) NSString *name;           /*优惠券名称*/

@property (nonatomic, copy) NSString *desc;           /*优惠券介绍*/

@property (nonatomic, copy) NSString *isSill;         /*是否有门槛 0-无使用门槛 1-有*/

@property (nonatomic, copy) NSString *breaksMoney;    /*面值*/

@property (nonatomic, copy) NSString *fullMoney;       /*满多少可使用*/

@property (nonatomic, copy) NSString *num;             /*总量*/

@property (nonatomic, copy) NSString *surplusStock;    /*剩余库存*/

/*详情可领取部分字段*/
@property (nonatomic, copy) NSString *isAll;           /*是否全部可用：1-是 0-不是*/

@property (nonatomic, strong) NSArray *goods;          /*商品可用id集合*/

@property (nonatomic, strong) NSArray *projects;       /*服务可用id集合*/

@property (nonatomic, copy) NSString *roleId;          /*可领取用户身份 1 1,2 0-全部*/

@property (nonatomic, copy) NSString *count;           /*可领取数量-每位用户*/

@property (nonatomic, copy) NSString *status;          /*状态 1-正常*/

@property (nonatomic, copy) NSString *type;            /*类型 1-满减*/

@property (nonatomic, copy) NSString *isGet;           /*是否已领取优惠券*/

@property (nonatomic, copy) NSString *isCanGet;        /*是否还能领取优惠券*/

@property (nonatomic, copy) NSString *isAuto;          /*是否自动分发 1-是 0-不是*/

@property (nonatomic, copy) NSString *memberRole;      /*自动分发要求的升级的角色等级*/

@end

NS_ASSUME_NONNULL_END
