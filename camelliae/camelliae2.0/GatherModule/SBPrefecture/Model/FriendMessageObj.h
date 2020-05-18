//
//  FriendMessageObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/5/10.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface FriendMessageObj : BaseResultObj

@property (nonatomic,strong) NSNumber *dataCount;

@property (nonatomic,strong) NSArray *dataList;

@property (nonatomic,strong) NSNumber *year;

@end
