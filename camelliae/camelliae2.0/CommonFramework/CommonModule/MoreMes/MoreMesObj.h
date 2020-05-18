//
//  MoreMesObj.h
//  camelliae2.0
//
//  Created by 张越 on 16/6/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"
@class WechatPreCallInfo;

@class LoginUserObj;

@class CMLProjectObj;

@class CMLOrderInfoObj;

@class CMLServeObj;

@class LoginBannerImageObj;

@class CMLRecommendCommonModuleObj;

@class ActivityMesTimeLineInfoObj;

@class ActivityMesDataInfoObj;

@class Privilege;

@class BannerObj;

@class AdPoster;

@class CMLServeModuleObj;

@class PackageInfoObj;

@class VideoInfo;

@class ZoneInfoObj;

@class AdLeftInfo;

@class AdRightInfo;

@class StarInfo;

@class AuctionInfo;

@class TimingInfoObj;

@class NavigationInfo;

@interface MoreMesObj : BaseResultObj

@property (nonatomic,strong) NSNumber *timelineId;

@property (nonatomic,strong) NSNumber *isUpdate;

@property (nonatomic,copy) NSString *appDownloadUrl;

@property (nonatomic,copy) NSString *urlAboutUs;

@property (nonatomic,copy) NSString *urlIpr;

@property (nonatomic,copy) NSString *urlMemberGrade;

@property (nonatomic,copy) NSString *urlMemberRight;

@property (nonatomic,copy) NSString *urlProvision;

@property (nonatomic,copy) NSString *urlUpGrade;

@property (nonatomic,strong) NSNumber *serverTime;

@property (nonatomic,strong) CMLServeObj *projectInfo;

@property (nonatomic,strong) CMLOrderInfoObj *orderInfo;

@property (nonatomic,strong) CMLServeObj *goodsInfo;

@property (nonatomic,strong) NSNumber *isLogin;

@property (nonatomic,copy) NSString *sKey;

@property (nonatomic,copy) NSString *skey;

@property (nonatomic,strong) LoginUserObj *userInfo;

@property (nonatomic,strong) LoginUserObj *user;

@property (nonatomic,strong) NSArray *objList;

@property (nonatomic,copy) NSString *objTitle;

@property (nonatomic,strong) NSNumber *dataCount;

@property (nonatomic,strong) NSArray *dataList;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *typeId;

@property (nonatomic,copy) NSString *typeName;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *briefIntro;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,copy) NSString *objCoverPic;

@property (nonatomic,strong) NSNumber *memberLevelId;

@property (nonatomic,strong) NSNumber *freeJoin;

@property (nonatomic,strong) NSNumber *memberLimitNum;

@property (nonatomic,strong) NSNumber *joinNum;

@property (nonatomic,copy) NSString *address;

@property (nonatomic,strong) NSNumber *actBeginTime;

@property (nonatomic,strong) NSNumber *actEndTime;

@property (nonatomic,strong) NSNumber *hitNum;

@property (nonatomic,strong) NSNumber *favNum;

@property (nonatomic,strong) NSNumber *shareNum;

@property (nonatomic,strong) NSNumber *publishDate;

@property (nonatomic,strong) NSNumber *isUserSubscribe;

@property (nonatomic,strong) NSNumber *isUserFav;

@property (nonatomic,strong) NSNumber *mobile;

@property (nonatomic,copy) NSString *telephone;

@property (nonatomic,strong) NSNumber *awardPoints;

@property (nonatomic,strong) NSNumber *isHasTimeZone;

@property (nonatomic,strong) NSNumber *payMode;

@property (nonatomic,copy) NSString *projectAddress;

@property (nonatomic,strong) NSNumber *projectBeginTime;

@property (nonatomic,strong) NSNumber *projectEndTime;

@property (nonatomic,copy) NSString *projectContact;

@property (nonatomic,strong) NSNumber *projectMemberLimit;

@property (nonatomic,strong) NSNumber *projectThemeObjId;

@property (nonatomic,strong) NSNumber *projectThemeTypeId;

@property (nonatomic,copy) NSString *projectThemeTypeName;

@property (nonatomic,strong) NSNumber *projectTypeId;

@property (nonatomic,copy) NSString *projectTypeName;

@property (nonatomic,strong) NSNumber *subscription;

@property (nonatomic,strong) NSNumber *totalAmount;

@property (nonatomic,copy) NSString *shareLink;

@property (nonatomic,copy) NSString *uploadBucket;

@property (nonatomic,copy) NSString *uploadKeyName;

@property (nonatomic,copy) NSString *upToken;

@property (nonatomic,strong) NSNumber *isAllowApply;

@property (nonatomic,copy) NSString *shortTitle;

@property (nonatomic,strong) NSNumber *authorId;

@property (nonatomic,strong) NSNumber *favTime;

@property (nonatomic,strong) NSNumber *isDeleted;

@property (nonatomic,copy) NSString *orderViewLink;

@property (nonatomic,strong) NSNumber *sortNum;

@property (nonatomic,strong) NSNumber *sysOrderStatus;

@property (nonatomic,copy) NSString *sysOrderStatusName;

@property (nonatomic,strong) NSNumber *likeNum;

@property (nonatomic,strong) NSNumber *isUserLike;

@property (nonatomic,copy) NSString *projectDateZone;

@property (nonatomic,strong) NSNumber *rootTypeId;

@property (nonatomic,strong) NSNumber *subTypeId;

@property (nonatomic,copy) NSString *rootTypeName;

@property (nonatomic,copy) NSString *subTypeName;

@property (nonatomic,copy) NSString *parentTypeName;

@property (nonatomic,strong) NSNumber *parentTypeId;

@property (nonatomic,strong) NSNumber *sysApplyStatus;

@property (nonatomic,copy) NSString *sysApplyStatusName;

@property (nonatomic,copy) NSString *actionViewLink;

@property (nonatomic,copy) NSString *actDateZone;

@property (nonatomic,copy) NSString *detailUrl;

@property (nonatomic,strong) NSArray *recommList;

@property (nonatomic,strong) NSNumber *isHasReview;

@property (nonatomic,strong) NSNumber *isRelVideo;

@property (nonatomic,copy) NSString *relVideoLink;

@property (nonatomic,strong) NSNumber *reviewType;

@property (nonatomic,strong) id reviewObj;

@property (nonatomic,strong) WechatPreCallInfo *wechatPreCallInfo;

@property (nonatomic,copy) NSString *orderId;

@property (nonatomic,copy) NSString *orderIdHash;

@property (nonatomic,copy) NSString *href;

@property (nonatomic,strong) NSNumber *objId;

@property (nonatomic,strong) NSNumber *type;

@property (nonatomic,strong) NSNumber *isOfficialAct;

@property (nonatomic,copy) NSString *sponsor;

@property (nonatomic,copy) NSString *appid;

@property (nonatomic,copy) NSString *noncestr;

@property (nonatomic,copy) NSString *package;

@property (nonatomic,strong) id partnerid;

@property (nonatomic,copy) NSString *prepayid;

@property (nonatomic,copy) NSString *sign;

@property (nonatomic,strong) NSNumber *timestamp;

@property (nonatomic,copy) NSString *alipaySign;

@property (nonatomic,copy) NSString *alipaySignToken;

@property (nonatomic,copy) NSString *videoCoverPic;

@property (nonatomic,strong) NSNumber *memberLevel;

@property (nonatomic,copy) NSString *memberLevelName;

@property (nonatomic,copy) NSString *memberVipGrade;

@property (nonatomic,strong) NSNumber *userPoints;

@property (nonatomic,copy) NSString *subTitle;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,strong) NSNumber *isHasPriceInterval;

@property (nonatomic,strong) NSNumber *commentCount;

@property (nonatomic,copy) NSString *publishTimeStr;

@property (nonatomic,strong) NSNumber *objType;

@property (nonatomic,strong) NSNumber *subObjType;

@property (nonatomic,strong) NSNumber *serveType;

@property (nonatomic,strong) CMLRecommendCommonModuleObj *moduleActivity;

@property (nonatomic,strong) CMLRecommendCommonModuleObj *moduleMsgTips;

@property (nonatomic,strong) CMLRecommendCommonModuleObj *moduleProjectRecomm;

@property (nonatomic,strong) CMLRecommendCommonModuleObj *modulePicAlbum;

@property (nonatomic,strong) CMLRecommendCommonModuleObj *moduleTopic;

@property (nonatomic,copy) NSString *message;

@property (nonatomic,strong) ActivityMesTimeLineInfoObj *timelineInfo;

@property (nonatomic,strong) ActivityMesDataInfoObj *dataInfo;

@property (nonatomic,strong) LoginBannerImageObj *loginBanner;

@property (nonatomic,copy) NSString *companyName;

@property (nonatomic,copy) NSString *contactAddress;

@property (nonatomic,copy) NSString *contactEmail;

@property (nonatomic,copy) NSString *contactPhone;

@property (nonatomic,strong) NSNumber *userId;

@property (nonatomic,copy) NSString *userProfile;

@property (nonatomic,strong) NSArray *relTags;

@property (nonatomic,strong) Privilege *basic;

@property (nonatomic,strong) Privilege *other;

@property (nonatomic,strong) NSNumber *linkProjectId;

@property (nonatomic,copy) NSString *projectDetailLink;

@property (nonatomic,strong) BannerObj *banner;

@property (nonatomic,strong) BannerObj *upgradeBanner;

@property (nonatomic,copy) NSString *userResource;

@property (nonatomic,strong) AdPoster *adPoster;

@property (nonatomic,strong) CMLServeModuleObj *ModuleForGrow;

@property (nonatomic,strong) CMLServeModuleObj *ModuleForTravel;

@property (nonatomic,copy) NSString *reviewTitle;

@property (nonatomic,copy) NSString *costInfo;

@property (nonatomic,copy) NSString *guidelines;

@property (nonatomic,strong) NSNumber *costMoney;

@property (nonatomic,strong) NSNumber *residueNum;

@property (nonatomic,copy) NSString *guideLinesUrl;

@property (nonatomic,copy) NSString *url;

@property (nonatomic,copy) NSString *memberLevelUrl;

@property (nonatomic,strong) NSDictionary *calendarList;

@property (nonatomic,strong) NSNumber *countNum;

@property (nonatomic,strong) NSNumber *maxDate;

@property (nonatomic,strong) NSNumber *minDate;

@property (nonatomic,strong) PackageInfoObj *packageInfo;

@property (nonatomic,strong) NSNumber *payState;

@property (nonatomic,strong) NSNumber *invitation;

@property (nonatomic,strong) NSNumber *countDown;

@property (nonatomic,strong) VideoInfo *videoInfoModule;

@property (nonatomic,strong) ZoneInfoObj *zoneInfo;

@property (nonatomic,strong) AdLeftInfo *zoneAdInfoModule;

@property (nonatomic,strong) StarInfo *newsInfoModule;

@property (nonatomic,strong) AuctionInfo *goodsInfoModule;

@property (nonatomic,strong) AuctionInfo *picInfoModule;

@property (nonatomic,strong) AuctionInfo *activityInfoModule;

@property (nonatomic,strong) NSArray *friendsInfoModule;

@property (nonatomic,copy) NSString *buyInfo;

@property (nonatomic,copy) NSString *officialMobile;

#pragma 添加专区后注释 @property (nonatomic,strong) TimingInfoObj *timingInfo;

@property (nonatomic,strong) NavigationInfo *navigationInfo;

@property (nonatomic,strong) NSArray *coverPicArr;

@property (nonatomic,copy) NSString *goodsBuyStr;

@property (nonatomic,strong) NSNumber *multipleBuyStatus;

@property (nonatomic,strong) NSNumber *surplusStock;

@property (nonatomic,strong) NSNumber *freight;

@property (nonatomic,copy) NSString *brandName;

@property (nonatomic,strong) NSNumber *recommListTypeId;


@end
