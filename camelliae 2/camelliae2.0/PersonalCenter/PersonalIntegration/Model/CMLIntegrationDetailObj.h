//
//  CMLIntegrationDetailObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/8/21.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface CMLIntegrationDetailObj : BaseResultObj

@property (nonatomic,copy) NSString *createTime;

@property (nonatomic,strong) NSNumber *date;

@property (nonatomic,copy) NSString *logTypeName;

@property (nonatomic,strong) NSNumber *status;

@property (nonatomic,strong) NSNumber *point;

@end
