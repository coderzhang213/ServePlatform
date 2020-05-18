//
//  CMLUserPorjectObj.h
//  camelliae2.0
//
//  Created by 张越 on 2018/11/14.
//  Copyright © 2018 张越. All rights reserved.
//

#import "BaseResultObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMLUserPorjectObj : BaseResultObj

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSNumber *price;

@property (nonatomic,copy) NSNumber *act_begin_time;

@property (nonatomic,copy) NSString *cityName;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,strong) NSNumber *rootTypeId;

@property (nonatomic,strong) NSNumber *memberLevel;

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,copy) NSString *signature;

@property (nonatomic,copy) NSString *gravatar;

@property (nonatomic,strong) NSNumber *userId;

@property (nonatomic,strong) NSNumber *objId;

@property (nonatomic,copy) NSNumber *actBeginTime;

/*新增：审核状态 1-审核通过 3-审核中*/
@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *hitNum;

@end

NS_ASSUME_NONNULL_END
