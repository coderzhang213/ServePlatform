//
//  ProjectInfoObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/9/22.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface ProjectInfoObj : BaseResultObj

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *objCoverPic;

@property (nonatomic,copy) NSString * address;

@property (nonatomic,copy) NSString *publishTimeStr;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSString *provinceName;

@end
