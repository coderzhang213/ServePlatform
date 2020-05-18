//
//  ServeRecommedUserObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/4.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface ServeRecommedUserObj : BaseResultObj

@property (nonatomic,copy) NSString *gravatar;

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,copy) NSString *userRealName;

@property (nonatomic,copy) NSString *signature;

@property (nonatomic,copy) NSString *recommDetail;

@property (nonatomic,strong) NSNumber *recommId;

@property (nonatomic,strong) NSNumber *recommendCount;

@property (nonatomic,strong) NSNumber *userId;

@property (nonatomic,copy) NSString *videoUrl;

@end
