//
//  CMLPCMemberCardModel.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/7/15.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "BaseResultObj.h"
@class CMLEquityModel;
NS_ASSUME_NONNULL_BEGIN

@interface CMLPCMemberCardModel : BaseResultObj

@property (nonatomic, strong) NSNumber *role_id;                /*角色ID*/

@property (nonatomic, copy) NSString *group_name;               /*角色名称*/

@property (nonatomic, copy) NSString *acl;                      /*角色权限*/

@property (nonatomic, copy) NSString *created_at;               

@property (nonatomic, copy) NSString *updated_at;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *memberLevel;              /*角色等级*/

@property (nonatomic, strong) NSArray *equity;                  /*角色权益*/

@property (nonatomic, copy) NSString *equityCount;              /*权益数量*/

@property (nonatomic, strong) NSNumber *isSell;                 /*是否可售卖 1-可售卖 2-不可售*/

@property (nonatomic, copy) NSString *logoUrl;                  /**/

@property (nonatomic, copy) NSString *vUrl;                     /*v*/

@end

NS_ASSUME_NONNULL_END
