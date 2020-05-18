//
//  CMLTopicObj.h
//  camelliae2.0
//
//  Created by 张越 on 16/7/9.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"
#import "BrandModuleObj.h"
#import "PackageInfoObj.h"

@interface CMLTopicObj : BaseResultObj


@property (nonatomic,copy) NSString *objCoverPic;

@property (nonatomic,strong) NSNumber *dataType;

@property (nonatomic,copy) NSString *viewLink;

@property (nonatomic,strong) NSNumber *rootTypeId;

@property (nonatomic,copy) NSString *rootTypeName;

@property (nonatomic,strong) NSNumber *subTypeId;

@property (nonatomic,copy) NSString *subTypeName;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,strong) NSNumber *hitNum;

@property (nonatomic,strong) NSNumber *favNum;

@property (nonatomic,strong) NSNumber *likeNum;

@property (nonatomic,strong) NSNumber *shareNum;

@property (nonatomic,strong) NSNumber *totalAmount;

@property (nonatomic,strong) NSNumber *isUserFav;

@property (nonatomic,strong) NSNumber *isUserLike;

@property (nonatomic,copy) NSString *briefIntro;

@property (nonatomic,copy) NSString *provinceName;

@property (nonatomic,copy) NSString *subhead;

@property (nonatomic,strong) NSNumber *isHasPriceInterval;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,strong) NSNumber *memberLevelId;

@property (nonatomic,strong) NSNumber *actBeginTime;

@property (nonatomic,strong) NSNumber *projectBeginTime;

@property (nonatomic,strong) NSNumber *isHasTimeZone;

@property (nonatomic,copy) NSString *shortTitle;

@property (nonatomic,copy) NSString *countRecord;

@property (nonatomic,copy) NSString *countRecordStr;

@property (nonatomic,copy) NSString *shareUrl;

@property (nonatomic,strong) NSNumber *shareStatus;

@property (nonatomic,copy) NSString *shareImg;

@property (nonatomic,strong) NSNumber *pre_end_time;

@property (nonatomic,strong) NSNumber *pre_price;

@property (nonatomic,strong) NSNumber *is_pre;

@property (nonatomic,strong) NSNumber *pre_totalAmount;

@property (nonatomic,strong) BrandModuleObj *brandInfo;

@property (nonatomic,copy) NSString *brandName;

@property (nonatomic,strong) NSNumber *totalAmountMin;

@property (nonatomic,strong) NSNumber *payMode;

@property (nonatomic,strong) PackageInfoObj *packageInfo;

@property (nonatomic,strong) NSNumber *deposit_money;

@property (nonatomic,strong) NSNumber *is_deposit;

@property (nonatomic,strong) NSNumber *deposit_total;

@property (nonatomic,strong) NSNumber *price;

@property (nonatomic,copy) NSString *parentTypeName;

@property (nonatomic,strong) ObjInfo *objInfo;

@property (nonatomic,strong) NSNumber *objId;

@property (nonatomic,copy) NSString *cityName;

@property (nonatomic,copy) NSString *publishTimeStr;


@end
