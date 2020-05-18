//
//  BrandInfoObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/7/27.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface MerchantInfo : BaseResultObj

@property (nonatomic,copy) NSString *address;

@property (nonatomic,strong) NSNumber *authorId;

@property (nonatomic,copy) NSString *merchantsName;

@property (nonatomic,copy) NSString *describe;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *inviteCode;

@property (nonatomic,copy) NSString *mobile;

@property (nonatomic,copy) NSString *objCoverPic;

@property (nonatomic,copy) NSString *objLogoPic;

@property (nonatomic,strong) NSNumber *publicTime;

@property (nonatomic,copy) NSString *remark;

@property (nonatomic,strong) NSNumber *status;

@end
