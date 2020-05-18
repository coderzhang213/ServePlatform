//
//  CMLSecondTypeObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/22.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface CMLSecondTypeObj : BaseResultObj

@property (nonatomic,strong) NSNumber *typeId;

@property (nonatomic,copy) NSString *typeName;

@property (nonatomic,strong) NSNumber *parentServeType;

@property (nonatomic,copy) NSString *parentServeTypeName;

@property (nonatomic,copy) NSString *coverPic;

@end
