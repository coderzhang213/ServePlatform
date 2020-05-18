//
//  GoodsModuleObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/7/12.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"


@interface GoodsModuleObj : BaseResultObj

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *parentGoodsTypeId;

@property (nonatomic,copy) NSString *unitName;

@property (nonatomic,strong) NSArray *propertyInfo;

@end
