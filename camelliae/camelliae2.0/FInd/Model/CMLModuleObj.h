//
//  CMLModuleObj.h
//  camelliae2.0
//
//  Created by 张越 on 2016/11/6.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@class CMLPicObjInfo;

@class PackageInfoObj;

@interface CMLModuleObj : BaseResultObj

@property (nonatomic,strong) NSNumber *isUserPublish;

@property (nonatomic,strong) NSNumber *actBeginTime;

@property (nonatomic,copy) NSString *actDateZone;

@property (nonatomic,strong) NSNumber *actEndTime;

@property (nonatomic,copy) NSString *actionViewLink;

@property (nonatomic,copy) NSString *address;

@property (nonatomic,strong) NSNumber *authorId;

@property (nonatomic,copy) NSString *briefIntro;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,strong) NSNumber *commentCount;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,strong) NSNumber *favNum;

@property (nonatomic,strong) NSNumber *freeJoin;

@property (nonatomic,strong) NSNumber *hitNum;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *isAllowApply;

@property (nonatomic,strong) NSNumber *isExpire;

@property (nonatomic,strong) NSNumber *isHasReview;

@property (nonatomic,strong) NSNumber *isMerchantPub;

@property (nonatomic,strong) NSNumber *isOfficialAct;

@property (nonatomic,strong) NSNumber *isWebView;

@property (nonatomic,strong) NSNumber *joinNum;

@property (nonatomic,strong) NSNumber *likeNum;

@property (nonatomic,copy) NSString *listCoverPic;

@property (nonatomic,copy) NSString *memberLevelColor;

@property (nonatomic,strong) NSNumber *memberLevelId;

@property (nonatomic,copy) NSString *memberLevelStr;

@property (nonatomic,strong) NSNumber *memberLimitNum;

@property (nonatomic,strong) NSNumber *merchant_id;

@property (nonatomic,strong) NSNumber *modifyTime;

@property (nonatomic,copy) NSString *objCoverPic;

@property (nonatomic,copy) NSString *provinceName;

@property (nonatomic,strong) NSNumber *publishDate;

@property (nonatomic,copy) NSString *reviewObj;

@property (nonatomic,copy) NSString *reviewTitle;

@property (nonatomic,copy) NSString *reviewType;

@property (nonatomic,strong) NSNumber *rootTypeId;

@property (nonatomic,copy)  NSString *rootTypeName;

@property (nonatomic,strong) NSNumber *shareNum;

@property (nonatomic,copy) NSString *shortTitle;

@property (nonatomic,strong) NSNumber *sortNum;

@property (nonatomic,strong) NSNumber *subTypeId;

@property (nonatomic,copy) NSString *subTypeName;

@property (nonatomic,strong) NSNumber *sysApplyStatus;

@property (nonatomic,copy) NSString *sysApplyStatusName;

@property (nonatomic,strong) NSNumber *sysSetAllowJoin;

@property (nonatomic,copy) NSString *telephone;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *webViewLink;

@property (nonatomic,copy) NSString *projectAddress;

@property (nonatomic,strong) NSNumber *totalAmount;

@property (nonatomic,strong) NSNumber *picId;

@property (nonatomic,strong) NSNumber *parentAlbumId;

@property (nonatomic,copy) NSString *coverPicThumb;

@property (nonatomic,copy) NSString *originPicPath;

@property (nonatomic,strong) NSNumber *downloadNum;

@property (nonatomic,copy) NSString *viewLink;

@property (nonatomic,strong) NSNumber *isHasPriceInterval;

@property (nonatomic,strong) CMLPicObjInfo *picObjInfo;

@property (nonatomic,copy) NSString *shareLink;

@property (nonatomic,strong) NSNumber *costMoney;

@property (nonatomic,copy) NSString *sponsor;

@property (nonatomic,copy) NSString *brandName;

@property (nonatomic,strong) NSNumber *totalAmountMin;

@property (nonatomic,strong) NSNumber *price;

@property (nonatomic,copy) NSString *parentTypeName;

@property (nonatomic,strong) PackageInfoObj *packageInfo;

@property (nonatomic,strong) NSNumber *pre_end_time;

@property (nonatomic,strong) NSNumber *pre_price;

@property (nonatomic,strong) NSNumber *is_pre;

@property (nonatomic,strong) NSNumber *pre_totalAmount;

@property (nonatomic,strong) NSNumber *deposit_money;

@property (nonatomic,strong) NSNumber *is_deposit;

@property (nonatomic,strong) NSNumber *deposit_total;

@property (nonatomic,strong) NSNumber *objId;

@end
