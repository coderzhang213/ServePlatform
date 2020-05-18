//
//  CMLCommMemberObj.h
//  camelliae2.0
//
//  Created by 张越 on 16/6/23.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface CMLCommMemberObj : BaseResultObj

@property (nonatomic,copy) NSString *gravatar;

@property (nonatomic,strong) NSNumber *isFollow;

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,strong) NSNumber *userId;

@property (nonatomic,copy) NSString *userName;

@end
