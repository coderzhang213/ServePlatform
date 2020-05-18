//
//  ZoneInfoObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/5/9.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface ZoneInfoObj : BaseResultObj

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *brandId;

@property (nonatomic,copy) NSString *brandName;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,copy) NSString *logoPic;

@property (nonatomic,copy) NSString *title;



@end
