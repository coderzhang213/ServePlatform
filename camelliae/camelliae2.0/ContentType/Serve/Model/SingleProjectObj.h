//
//  SingleProjectObj.h
//  camelliae2.0
//
//  Created by 张越 on 16/7/4.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface SingleProjectObj : BaseResultObj

@property (nonatomic,strong) NSNumber *type;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSNumber *objId;

@property (nonatomic,copy) NSString *href;

@property (nonatomic,copy) NSString *coverPic;

@end
