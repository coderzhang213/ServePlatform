//
//  ObjInfo.h
//  camelliae2.0
//
//  Created by 张越 on 2017/9/28.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"
#import "ObjCover.h"

@interface ObjInfo : BaseResultObj

@property (nonatomic,strong) NSNumber *objType;

@property (nonatomic,copy) NSString *objTypeName;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,strong) NSNumber *objId;

@property (nonatomic,strong) NSNumber *city_id;

@property (nonatomic,copy) NSString *cityName;

@property (nonatomic,copy) NSString *publishTimeStr;

@end
