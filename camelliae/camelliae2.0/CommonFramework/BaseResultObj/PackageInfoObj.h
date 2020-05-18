//
//  PackageInfoObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/4/26.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface PackageInfoObj : BaseResultObj

@property (nonnull,strong) NSArray *chargeInfo;

NS_ASSUME_NONNULL_BEGIN


@property (nonatomic,strong) NSNumber *dataCount;

@property (nonatomic,strong) NSArray *dataList;

NS_ASSUME_NONNULL_END

@end
