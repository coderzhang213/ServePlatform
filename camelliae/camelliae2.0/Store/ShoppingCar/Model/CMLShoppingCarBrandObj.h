//
//  CMLShoppingCarBrandObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/7.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"
#import "BrandAndServeObj.h"
#import "PackDetailInfoObj.h"

@interface CMLShoppingCarBrandObj : BaseResultObj

@property (nonatomic,strong) NSNumber *carId;

@property (nonatomic,strong) NSNumber *userId;

@property (nonatomic,strong) NSNumber *objType;

@property (nonatomic,strong) NSNumber *objId;

@property (nonatomic,strong) NSNumber *packageId;

@property (nonatomic,strong) NSNumber *goodNum;

@property (nonatomic,strong) BrandAndServeObj *projectInfo;

@property (nonatomic,strong) PackDetailInfoObj *packageInfo;

@end
