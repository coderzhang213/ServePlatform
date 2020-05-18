//
//  CMLOrderObj.h
//  camelliae2.0
//
//  Created by 张越 on 16/6/1.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"
#import "CMLOrderInfoObj.h"

@interface CMLOrderObj : BaseResultObj

@property (nonatomic,strong) NSNumber *authorId;

@property (nonatomic,strong) NSNumber *awardPoints;

@property (nonatomic,copy) NSString *briefIntro;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,strong) NSNumber *favNum;

@property (nonatomic,strong) NSNumber *hitNum;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *isDeleted;

@property (nonatomic,strong) NSNumber *isHasTimeZone;

@property (nonatomic,strong) CMLOrderInfoObj *orderInfo;

@property (nonatomic,copy) NSString *orderViewLink;

@property (nonatomic,strong) NSNumber *payMode;

@property (nonatomic,copy) NSString *projectAddress;

@property (nonatomic,strong) NSNumber *projectBeginTime;

@property (nonatomic,copy) NSString *projectContact;

@property (nonatomic,strong) NSNumber *projectEndTime;

@property (nonatomic,strong) NSNumber *projectMemberLimit;

@property (nonatomic,strong) NSNumber *projectThemeObjId;

@property (nonatomic,strong) NSNumber *projectThemeTypeId;

@property (nonatomic,copy) NSString *projectThemeTypeName;

@property (nonatomic,strong) NSNumber *projectTypeId;

@property (nonatomic,copy) NSString *projectTypeName;

@property (nonatomic,strong) NSNumber *publishDate;

@property (nonatomic,strong) NSNumber *shareNum;

@property (nonatomic,copy) NSString *shortTitle;

@property (nonatomic,strong) NSNumber *sortNum;

@property (nonatomic,strong) NSNumber *subscription;

@property (nonatomic,strong) NSNumber *sysOrderStatus;

@property (nonatomic,copy) NSString *sysOrderStatusName;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSNumber *totalAmount;

@property (nonatomic,strong) NSNumber *typeId;

@property (nonatomic,copy) NSString *parentTypeName;

@property (nonatomic,copy) NSString *parentTypeId;

@property (nonatomic,copy) NSString *projectDateZone;

@property (nonatomic,copy) NSString *actDateZone;

@property (nonatomic,strong) PackageInfoObj *packageInfo;

@property (nonatomic,strong) NSNumber *point;

@property (nonatomic,strong) NSNumber *isPhysicalObject;

@property (nonatomic,copy) NSString *coverPicThumb;

@property (nonatomic,strong) NSNumber *isUserPublish;

@end
