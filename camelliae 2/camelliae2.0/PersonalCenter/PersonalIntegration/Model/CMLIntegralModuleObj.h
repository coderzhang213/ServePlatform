//
//  CMLIntegralModuleObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/8/21.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface CMLIntegralModuleObj : BaseResultObj

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,strong) NSNumber *finishStatus;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSNumber *type;

@property (nonatomic,copy) NSString *finishStatusStr;

@end
