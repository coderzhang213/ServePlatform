//
//  BrandModuleObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/11/28.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"
#import "ModuleForGoods.h"


@interface BrandModuleObj : BaseResultObj

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,strong) NSArray *coverPicArr;

@property (nonatomic,strong) NSNumber *createdAt;

@property (nonatomic,copy) NSString *detail;

@property (nonatomic,copy) NSString *firstLetter;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,copy) NSString *logoPic;

@property (nonatomic,strong) NSArray *logoPicArr;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) NSNumber *sort;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,strong) NSNumber *goodsCount;

@property (nonatomic,strong) NSNumber *projectCount;

@property (nonatomic,strong) NSArray *recommLogoPicArr;

@property (nonatomic,copy) NSString *recommLogoPic;

@property (nonatomic,strong) ModuleForGoods *bestRecommList;

@property (nonatomic,copy) NSString *brandListPic;

@end
