//
//  CMLAppointmentObj.h
//  camelliae2.0
//
//  Created by 张越 on 16/5/31.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@class PackageInfoObj;

@interface CMLAppointmentObj : BaseResultObj


@property (nonatomic,copy) NSString *objCoverPic;

@property (nonatomic,strong) NSNumber *actBeginTime;

@property (nonatomic,strong) NSNumber *actEndTime;

@property (nonatomic,copy) NSString *actionViewLink;

@property (nonatomic,copy) NSString *address;

@property (nonatomic,strong) NSNumber *authorId;

@property (nonatomic,copy) NSString *briefIntro;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,strong) NSNumber *favNum;

@property (nonatomic,strong) NSNumber *freeJoin;

@property (nonatomic,strong) NSNumber *hitNum;

@property (nonatomic,strong) NSNumber *isAllowApply;

@property (nonatomic,strong) NSNumber *isDeleted;

@property (nonatomic,strong) NSNumber *isExpire;

@property (nonatomic,strong) NSNumber *joinNum;

@property (nonatomic,copy) NSString *listCoverPic;

@property (nonatomic,strong) NSNumber *memberLevelId;

@property (nonatomic,strong) NSNumber *memberLimitNum;

@property (nonatomic,strong) NSNumber *modifyTime;

@property (nonatomic,strong) NSNumber *publishDate;

@property (nonatomic,strong) NSNumber *shareNum;

@property (nonatomic,copy) NSString *shortTitle;

@property (nonatomic,strong) NSNumber *sortNum;

@property (nonatomic,strong) NSNumber *status;

@property (nonatomic,copy) NSString *statusStr;

@property (nonatomic,strong) NSNumber *subscribeId;

@property (nonatomic,strong) NSNumber *subscribeTime;

@property (nonatomic,strong) NSNumber *sysApplyStatus;

@property (nonatomic,copy) NSString *sysApplyStatusName;

@property (nonatomic,strong) NSNumber *sysSetAllowJoin;

@property (nonatomic,copy) NSString *telephone;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSNumber *typeId;

@property (nonatomic,copy) NSString *typeName;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,copy) NSString *provinceName;

@property (nonatomic,copy) NSString *actDateZone;

@property (nonatomic,strong) PackageInfoObj *packageInfo;

@property (nonatomic,strong) NSNumber *invitation;

@property (nonatomic,copy) NSString *activityQrCode;

@end
