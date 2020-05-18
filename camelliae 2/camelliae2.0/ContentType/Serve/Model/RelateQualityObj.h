//
//  RelateQualityObj.h
//  camelliae2.0
//
//  Created by 张越 on 2018/4/20.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "BaseResultObj.h"

#import "GoodsAndServeObj.h"

@interface RelateQualityObj : BaseResultObj

@property (nonatomic,strong) GoodsAndServeObj *goods;

@property (nonatomic,strong) GoodsAndServeObj *project;
@end
