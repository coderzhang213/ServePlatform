//
//  BannerObj.h
//  camelliae2.0
//
//  Created by 张越 on 2016/12/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface BannerObj : BaseResultObj

@property (nonatomic,strong) NSNumber *uid;

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,copy) NSString *userRealName;

@property (nonatomic,strong) NSNumber *gender;

@property (nonatomic,copy) NSString *gravatar;

@property (nonatomic,copy) NSString *bgPicPath;

@property (nonatomic,copy) NSString *companyName;

@property (nonatomic,strong) NSNumber *isShow;

@end
