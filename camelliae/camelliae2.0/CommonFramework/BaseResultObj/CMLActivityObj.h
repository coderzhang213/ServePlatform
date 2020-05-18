//
//  CMLActivityObj.h
//  camelliae2.0
//
//  Created by 张越 on 16/5/30.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"
#import "ObjInfoObj.h"
#import "LoginUserObj.h"

@interface CMLActivityObj : BaseResultObj

@property (nonatomic,copy) NSString *objCoverPic;

@property (nonatomic,strong) NSNumber *objId;

@property (nonatomic,strong) NSNumber *authorId;

@property (nonatomic,strong) NSNumber *awardPoints;

@property (nonatomic,copy) NSString *briefIntro;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,strong) NSNumber *favNum;

@property (nonatomic,strong) NSNumber *favTime;

@property (nonatomic,copy) NSString *hitNum;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *isDeleted;

@property (nonatomic,strong) NSNumber *isHasTimeZone;

@property (nonatomic,copy) NSString *orderViewLink;

@property (nonatomic,strong) NSNumber *payMode;

@property (nonatomic,copy) NSString *projectAddress;

@property (nonatomic,strong) NSNumber *projectBeginTime;

@property (nonatomic,strong) NSNumber *actBeginTime;

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

@property (nonatomic,copy) NSString *typeName;

@property (nonatomic,strong) NSNumber *rootTypeId;

@property (nonatomic,copy) NSString *rootTypeName;

@property (nonatomic,strong) NSNumber *subTypeId;

@property (nonatomic,copy) NSString *subTypeName;

@property (nonatomic,strong) NSNumber *isUserLike;

@property (nonatomic,strong) NSNumber *isUserFav;

@property (nonatomic,strong) NSNumber *likeNum;

@property (nonatomic,strong) NSNumber *isWebView;

@property (nonatomic,copy) NSString *webViewLink;

@property (nonatomic,copy) NSString *address;

@property (nonatomic,copy) NSString *provinceName;

@property (nonatomic,strong) NSNumber *memberLevelId;

@property (nonatomic,copy) NSString *shareLink;

@property (nonatomic,strong) NSNumber *isUserSubscribe;

@property (nonatomic,copy) NSString *coverPicThumb;

@property (nonatomic,strong) NSNumber *event_time;

@property (nonatomic,strong) ObjInfoObj *objInfo;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,copy) NSString *publishTimeStr;

@property (nonatomic,copy) NSString *cityName;

@property (nonatomic,strong) NSNumber *isUserPublish;


@property (nonatomic,strong) NSNumber *price;

@property (nonatomic,copy) NSNumber *act_begin_time;

@property (nonatomic,strong) NSNumber *memberLevel;

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,copy) NSString *signature;

@property (nonatomic,copy) NSString *gravatar;

@property (nonatomic,strong) NSNumber *userId;

/*新增：审核状态 1-审核通过 3-审核中*/
@property (nonatomic, copy) NSString *status;

@end
