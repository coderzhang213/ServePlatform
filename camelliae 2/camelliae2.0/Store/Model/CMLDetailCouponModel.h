//
//  CMLDetailCouponModel.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/7/22.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "BaseResultObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMLDetailCouponModel : BaseResultObj

@property (nonatomic, copy) NSString *currentID;      /*优惠券id*/

@property (nonatomic, copy) NSString *name;           /*优惠券名称*/

@property (nonatomic, copy) NSString *num;            /*总量*/

@property (nonatomic, copy) NSString *isAll;          /*是否全部可用 1-是 0-不是*/

@property (nonatomic, copy) NSString *goods;          /*商品可用id集合*/

@property (nonatomic, copy) NSString *projects;       /*服务可用id集合*/

@property (nonatomic, copy) NSString *isSill;         /*是否有门槛 0-无使用门槛 1-有*/

@property (nonatomic, copy) NSString *fullMoney;      /*满多少可使用*/

@property (nonatomic, copy) NSString *breaksMoney;    /*减免多少钱*/

@property (nonatomic, copy) NSString *beginTimeStr;   /*开始时间*/

@property (nonatomic, copy) NSString *endTimeStr;     /*结束时间*/

@property (nonatomic, copy) NSString *days;           /*次日起多少天有效*/

@property (nonatomic, copy) NSString *roleId;         /*可领取用户身份 1 1,2 0-全部*/

@property (nonatomic, copy) NSString *count;          /*可领取数量/每位用户*/

@property (nonatomic, copy) NSString *desc;           /*优惠券介绍*/

@property (nonatomic, copy) NSString *status;         /*状态 1-正常*/

@property (nonatomic, copy) NSString *type;           /*类型 1-满减*/

@property (nonatomic, copy) NSString *surplusStock;   /*库存*/

@property (nonatomic, copy) NSString *isGet;          /*是否已领取优惠券*/

@property (nonatomic, copy) NSString *isCanGet;       /*是否还能领取优惠券*/

@property (nonatomic, copy) NSString *isAuto;         /*是否是自动分发 1-是 0-不是*/

@property (nonatomic, copy) NSString *memberRole;     /*自动分发要求的升级的角色等级*/


@end

NS_ASSUME_NONNULL_END
