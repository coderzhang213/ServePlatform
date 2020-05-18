//
//  AdLeftInfo.h
//  camelliae2.0
//
//  Created by 张越 on 2017/5/9.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"
#import "ModuleDetailInfoObj.h"

@interface AdLeftInfo : BaseResultObj

@property (nonatomic,strong) NSNumber *dataCount;

@property (nonatomic,strong) NSArray *dataList;

@property (nonatomic,strong) ModuleDetailInfoObj *dataInfo;

@end
