//
//  ActivityTypeObj.h
//  camelliae2.0
//
//  Created by 张越 on 2016/10/26.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface ActivityTypeObj : BaseResultObj

@property (nonatomic,strong) NSNumber *typeId;

@property (nonatomic,copy) NSString *typeName;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,copy) NSString *title;

@end
