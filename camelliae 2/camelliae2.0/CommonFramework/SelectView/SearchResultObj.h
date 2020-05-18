//
//  SearchResultObj.h
//  camelliae2.0
//
//  Created by 张越 on 16/9/2.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"
#import "PackageInfoObj.h"

@interface SearchResultObj : BaseResultObj

@property (nonatomic,strong) NSNumber *authorId;

@property (nonatomic,copy) NSString *briefIntro;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,strong) NSNumber *favNum;

@property (nonatomic,copy) NSString *hitNum;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *likeNum;

@property (nonatomic,copy) NSString *objCoverPic;

@property (nonatomic,strong) NSNumber *publishDate;

@property (nonatomic,copy) NSString *publishTimeStr;

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,strong) NSNumber *rootTypeId;

@property (nonatomic,copy) NSString *rootTypeName;

@property (nonatomic,strong) NSNumber *shareNum;

@property (nonatomic,strong) NSNumber *subTypeId;

@property (nonatomic,copy) NSString *subTypeName;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSNumber *isOfficialAct;

@property (nonatomic,strong) NSNumber *memberLevelId;

@property (nonatomic,strong) NSNumber *totalAmount;

@property (nonatomic,copy) NSString *parentTypeName;

@property (nonatomic,copy) NSString *typeName;

@property (nonatomic,copy) NSString *provinceName;

@property (nonatomic,strong) NSNumber *isHasTimeZone;

@property (nonatomic,copy) NSString *orderViewLink;

@property (nonatomic,strong) NSNumber *payMode;

@property (nonatomic,copy) NSString *projectAddress;

@property (nonatomic,strong) NSNumber *projectBeginTime;

@property (nonatomic,strong) NSNumber *actBeginTime;

@property (nonatomic,strong) PackageInfoObj *packageInfo;

@property (nonatomic,copy) NSString *brandName;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,strong) NSNumber *totalAmountMin;

@property (nonatomic,strong) NSNumber *price;

@property (nonatomic,strong) NSNumber *pre_end_time;

@property (nonatomic,strong) NSNumber *pre_price;

@property (nonatomic,strong) NSNumber *is_pre;

@property (nonatomic,strong) NSNumber *pre_totalAmount;

@property (nonatomic,strong) NSNumber *deposit_money;

@property (nonatomic,strong) NSNumber *is_deposit;

@property (nonatomic,strong) NSNumber *deposit_total;

@property (nonatomic,strong) NSNumber *isUserPublish;

@property (nonatomic,strong) NSNumber *objId;


@end
