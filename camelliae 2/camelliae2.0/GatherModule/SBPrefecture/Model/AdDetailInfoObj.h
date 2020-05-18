//
//  AdDetailInfoObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/5/9.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface AdDetailInfoObj : BaseResultObj

@property (nonatomic,strong) NSNumber *bannerIndexId;

@property (nonatomic,strong) NSNumber *bannerTypeId;

@property (nonatomic,copy) NSString *bannerTypeName;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,strong) NSNumber *dataType;

@property (nonatomic,copy) NSString *dataTypeName;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *objId;

@property (nonatomic,strong) NSNumber *objType;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *viewLink;

@property (nonatomic,strong) NSNumber *shareStatus;

@property (nonatomic,copy) NSString *shareUrl;

@property (nonatomic,copy) NSString *shareImg;

@end
