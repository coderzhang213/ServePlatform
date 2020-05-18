//
//  CMLCommIndexObj.h
//  camelliae2.0
//
//  Created by 张越 on 16/6/5.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"
#import "CMLPicObjInfo.h"

@interface CMLCommIndexObj : BaseResultObj

@property (nonatomic,copy) NSString *shareLink;

@property (nonatomic,copy) NSString *objCoverPic;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,strong) NSNumber *dataType;

@property (nonatomic,strong) NSNumber *favNum;

@property (nonatomic,strong) NSNumber *hitNum;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *likeNum;

@property (nonatomic,strong) NSNumber *objTypeId;

@property (nonatomic,copy) NSString *objTypeName;

@property (nonatomic,copy) NSString *rootTypeName;

@property (nonatomic,copy) NSString *briefIntro;

@property (nonatomic,copy) NSString *provinceName;

@property (nonatomic,strong) NSNumber *shareNum;

@property (nonatomic,strong) NSNumber *subTypeId;

@property (nonatomic,copy) NSString *subTypeName;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSNumber *totalAmount;

@property (nonatomic,copy) NSString *viewLink;

@property (nonatomic,strong) NSNumber *rootTypeId;

@property (nonatomic,strong) NSNumber *isUserFav;

@property (nonatomic,strong) NSNumber *isUserLike;

@property (nonatomic,strong) NSArray *albumList;

@property (nonatomic,copy) NSString *subhead;

@property (nonatomic,strong) NSArray *coverPicArr;

@property (nonatomic,strong) NSNumber *subscription;

@property (nonatomic,strong) CMLPicObjInfo *picObjInfo;

@property (nonatomic,strong) NSNumber *memberLevelId;

@property (nonatomic,strong) NSNumber *actBeginTime;

@property (nonatomic,strong) NSNumber *isHasPriceInterval;

@property (nonatomic,strong) NSNumber *projectBeginTime;

@property (nonatomic,strong) NSNumber *isHasTimeZone;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,copy) NSString *shortTitle;

@property (nonatomic,strong) NSNumber *isUserSubscribe;

@property (nonatomic,copy) NSString *coverPicThumb;

@end
