//
//  UserLikeListObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/9/27.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface UserLikeListObj : BaseResultObj

@property (nonatomic,strong) NSNumber *dataCount;

@property (nonatomic,strong) NSArray *dataList;

@end
