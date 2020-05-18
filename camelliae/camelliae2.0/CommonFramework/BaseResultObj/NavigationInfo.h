//
//  NavigationInfo.h
//  camelliae2.0
//
//  Created by 张越 on 2017/5/12.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@class CMLPicObjInfo;

@interface NavigationInfo : BaseResultObj

@property (nonatomic,strong) NSNumber *isShow;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,strong) CMLPicObjInfo *picObjInfo;

@property (nonatomic,strong) NSNumber *obj_id;

@property (nonatomic,strong) NSNumber *obj_type;

@property (nonatomic,strong) NSNumber *timePeriod;

@property (nonatomic,strong) NSNumber *dataType;

@property (nonatomic,copy) NSString *webUrl;

@end
