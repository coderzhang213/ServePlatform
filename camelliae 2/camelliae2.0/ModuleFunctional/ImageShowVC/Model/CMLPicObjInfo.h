//
//  CMLPicObjInfo.h
//  camelliae2.0
//
//  Created by 张越 on 2016/9/26.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface CMLPicObjInfo : BaseResultObj

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,copy) NSString *originPic;

@property (nonatomic,copy) NSString *ratio;

@property (nonatomic,strong) NSNumber *picWidth;

@property (nonatomic,strong) NSNumber *picHeight;

@end
