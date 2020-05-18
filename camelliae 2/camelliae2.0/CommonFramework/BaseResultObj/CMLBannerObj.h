//
//  CMLBannerObj.h
//  camelliae2.0
//
//  Created by 张越 on 16/8/18.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"
#import "CMLPicObjInfo.h"

@interface CMLBannerObj : BaseResultObj

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *dataType;

@property (nonatomic,strong) NSNumber *objId;

@property (nonatomic,strong) NSNumber *objType;

@property (nonatomic,strong) NSNumber *bannerTypeId;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,copy) NSString *sort;

@property (nonatomic,copy) NSString *viewLink;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,strong) NSNumber *created_at;

@property (nonatomic,strong) NSNumber *updated_at;

@property (nonatomic,strong) NSNumber *bannerIndexId;

@property (nonatomic,copy) NSString *bannerTypeName;

@property (nonatomic,copy) NSString *dataTypeName;

@property (nonatomic,strong) CMLPicObjInfo *picObjInfo;

@property (nonatomic,copy) NSString *shareLink;

@property (nonatomic,copy) NSString *shortTitle;

@property (nonatomic,copy) NSString *shareUrl;

@property (nonatomic,strong) NSNumber *shareStatus;

@property (nonatomic,copy) NSString *shareImg;

@property (nonatomic,strong) NSNumber *timelineTypeId;

@property (nonatomic,copy) NSString *logoPic;

@property (nonatomic,strong) NSNumber *goodsCount;

@property (nonatomic,strong) NSNumber *projectCount;

@property (nonatomic,strong) NSNumber *rootTypeId;

@property (nonatomic,strong) NSNumber *isJumpOut;

@property (nonatomic,strong) NSNumber *isCanPublish;

@end
