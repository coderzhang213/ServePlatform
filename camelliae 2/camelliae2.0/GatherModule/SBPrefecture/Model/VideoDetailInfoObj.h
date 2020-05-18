//
//  VideoDetailInfoObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/5/9.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface VideoDetailInfoObj : BaseResultObj

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,strong) NSNumber *obj_type;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *urlLink;
@end
