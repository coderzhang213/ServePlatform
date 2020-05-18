//
//  WechatPreCallInfo.h
//  camelliae2.0
//
//  Created by 张越 on 16/6/27.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface WechatPreCallInfo : BaseResultObj

@property (nonatomic,copy) NSString *appid;

@property (nonatomic,copy) NSString *noncestr;

@property (nonatomic,copy) NSString *package;

@property (nonatomic,strong) id partnerid;

@property (nonatomic,copy) NSString *prepayid;

@property (nonatomic,copy) NSString *sign;

@property (nonatomic,strong) NSNumber *timestamp;

@end
