//
//  CMLImageObj.h
//  camelliae2.0
//
//  Created by 张越 on 16/7/11.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface CMLImageObj : BaseResultObj

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,copy) NSString *coverPicThumb;

@property (nonatomic,strong) NSNumber *picHeight;

@property (nonatomic,strong) NSNumber *picWidth;

@property (nonatomic,strong) NSNumber *ratio;

@end
