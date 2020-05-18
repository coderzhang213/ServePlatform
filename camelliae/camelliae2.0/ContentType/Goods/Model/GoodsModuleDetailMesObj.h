//
//  GoodsModuleDetailMesObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/7/12.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface GoodsModuleDetailMesObj : BaseResultObj

@property (nonatomic,strong) NSNumber *goodsUnitPropertyId;

@property (nonatomic,strong) NSNumber *parentUnitId;

@property (nonatomic,copy) NSString *propertyName;

@property (nonatomic,copy) NSString *propertyValue;

@end

