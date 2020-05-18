//
//  LightDataController.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/18.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseResultObj;
@class CMLMessageObj;

@interface LightDataController : NSObject

/**保存skey*/
- (void)saveSkey:(NSString *)skey;
- (NSString *)readSkey;
- (void)removeSkey;

- (void) saveAbsoluteString:(NSString *) absoluteString;
- (NSString *)readAbsoluteString;
- (void)removeAbsoluteString;

/**userID*/
- (void) saveUserID:(NSNumber *)uid;
- (NSNumber *)readUserID;
- (void)removeUserID;

/**保存城市ID*/
- (void) saveCityID:(NSNumber *)cityID;
- (NSNumber *)readCityID;
- (void) removeCityID;

 /**存储手机号*/
- (void) savePhone:(NSString *) phone;
- (NSString *)readPhone;
- (void) removePhone;

/**real name*/
- (void) saveUserName:(NSString *)userName;
- (NSString *)readUserName;
- (void) removeUserName;

/**nick name*/
- (void) saveNickName:(NSString *)nickName;
- (NSString *)readNickName;
- (void) removeNickName;

/**头像地址*/
- (void) saveUserHeadImgUrl:(NSString *)imgUrl;
- (NSString *)readUserHeadImgUrl;
- (void) removeUserHeadImgUrl;

/**用户积分*/
- (void) saveUserSex:(NSNumber *)sex;
- (NSNumber *)readUserSex;
- (void) removeUserSex;

/**用户生日*/
- (void) saveUserBirth:(NSNumber *)birth;
- (NSNumber *)readUserBirth;
- (void) removeUserBirth;

/**memberlvl*/
- (void) saveUserLevel:(NSNumber *)userLevel;
- (NSNumber *)readUserLevel;
- (void) removeUserLevel;

/*会员角色roleId 1-普通粉色 2-粉银 3-粉金 4-粉钻 5-黛色*/
- (void)saveRoleId:(NSNumber *)roleId;
- (NSNumber *)readRoleId;
- (void)removeRoleId;

/**用户性别*/
- (void) saveUserPoints:(NSNumber *)userPoints;
- (NSNumber *)readUserPoints;
- (void) removeUserPoints;

/**登录方式*/
- (void) saveOpenType:(NSNumber *)type;
- (NSNumber *)readOpenType;
- (void) removeOpenType;

/**是否被绑定*/
- (void) saveBindPhoneStatus:(NSNumber *) status;
- (NSNumber *)readBindPhoneStatus;
- (void) removeBindStatus;

/**用户签名*/
- (void) saveSignature:(NSString *) signature;
- (NSString *)readSignature;
- (void) removeSignature;

/**用户粉丝数*/
- (void) saveRelFansCount:(NSNumber *) relFansCount;
- (NSNumber *)readRelFansCount;
- (void) removeRelFansCount;

/**用户关注人数*/
- (void) saveRelWatchCount:(NSNumber *) relWatchCount;
- (NSNumber *)readRelWatchCount;
- (void) removeRelWatchCount;

/**邀请码*/
- (void) saveInviteCode:(NSString *) inviteCode;
- (NSString *)readInviteCode;
- (void) removeInviteCode;

/**保存ID*/
- (void) saveDeliveryAddressID:(NSNumber *) deliveryAddressID;
- (NSNumber *)readDeliveryAddressID;
- (void) removeDeliveryAddressID;

/**用户收货地址*/
- (void) saveDeliveryAddress:(NSString *) address;
- (NSString *)readDeliveryAddress;
- (void) removeDeliveryAddress;

/**收货联系人*/
- (void) saveDeliveryUser:(NSString *) deliveryUser;
- (NSString *)readDeliveryUser;
- (void) removeDeliveryUser;

/**收货电话*/
- (void) saveDeliveryPhone:(NSString *) deliveryPhone;
- (NSString *)readDeliveryPhone;
- (void) removeDeliveryPhone;

/**版本号存储*/
- (void) saveVersion:(NSString *)version;
- (NSString *) readVersion;

/**推荐地址*/
- (void) saveAppDownloadUrl:(NSString *)appDownloadUrl;
- (NSString *) readAppDownloadUrl;

/**关于我们地址*/
- (void) saveAboutUsUrl:(NSString *) currentUrl;
- (NSString *) readAboutUsUrl;

/**知识产权保护说明*/
- (void) saveIntellectualPropertyRightsUrl:(NSString *) currentUrl;
- (NSString *) readIntellectualPropertyRightsUrl;

/**服务及隐私条款*/
- (void) saveServiceAndPrivacyUrl:(NSString *) currentUrl;
- (NSString *) readServiceAndPrivacyUrl;

/**用户协议*/
- (void)saveUrlAgreement:(NSString *)currentUrl;
- (NSString *)readUrlAgreement;

/**商城规则*/
- (void) saveRuleUrl:(NSString *) currentUrl;
- (NSString *) readRuleUrl;

/**花伴权力*/
- (void)saveFlowersWithPower:(NSString *) currentUrl;
- (NSString *) readFlowersWithPowerUrl;

/**花伴升级*/
- (void) saveFlowersWithUpgrade:(NSString *) currentUrl;
- (NSString *) readFlowersWithUpgradeUrl;

/**花伴等级*/
- (void) saveFlowersWithLevel:(NSString *) currentUrl;
- (NSString *) readFlowersWithLevel;

/**登录头图*/
- (void) saveLoginBannerUrl:(NSString *) imageUrl;
- (NSString *) readLoginBannerImageUlr;

/**精分等级*/
- (void) saveMemberVipGrade:(NSString *) vipGrade;
- (NSString *) readMemberVipGrade;

- (void) saveMemberListNumber:(NSNumber *) number;
- (NSNumber *) readMemberListNumber;

- (void) saveGradeBuyState:(NSNumber *) state;
- (NSNumber *) readGradeBuyState;

- (void) saveLetterReadState:(NSNumber *) state;
- (NSNumber *) readLetterReadState;

/**海报*/
- (void) saveAdPoster:(NSString *) str;
- (NSString *) readAdPoster;
/**会员特权包有效期*/
- (void) savePrivilegeExpiryDate:(NSString *) str;
- (NSString *) readPrivilegeExpiryDate;

- (void) saveMemberIvlUrl:(NSString *)url;
- (NSString *)readMemberLvlUrl;

/*********/
- (void) saveUserInfo:(BaseResultObj *)obj;

- (void) saveUser:(BaseResultObj *)obj;

- (void) saveUrlMessage:(BaseResultObj *)obj;

/**广告播放时间*/
- (void) saveCurrentTime:(NSDate *) currentDate;
- (NSDate *) readCurrentTime;

- (void) saveShowAd:(NSNumber *) isShow;
- (NSNumber *) readIsShow;

- (void) saveTimePeriod:(NSNumber *) period;
- (NSNumber *) readPeriod;

- (void) saveNavImageUrl:(NSString *) imageUrl;
- (NSString *) readNavImageUrl;

- (void) saveNavImageWidth:(NSNumber *) width;
- (NSNumber *) readNavImageWidth;

- (void) saveNavImageHeight:(NSNumber *) height;
- (NSNumber *) readNavImageHeight;

- (void) saveObjID:(NSNumber *) objID;
- (NSNumber *) readObjID;

- (void) saveDataType:(NSNumber *) dataType;
- (NSNumber *) readDataType;

- (void) saveObjType:(NSNumber *) objType;
- (NSNumber *) readObjType;

- (void) saveEnterWebUrl:(NSString *) url;
- (NSString *) readWebUrl;

- (void) saveNewStatus:(NSNumber *) status;
- (NSNumber *) readNewStatus;

- (void) saveSignStatus:(NSNumber *) status;
- (NSNumber *) readSignStatus;

- (void) saveThirdVideoPlayerStatus:(NSNumber *) status;
- (NSNumber *) readThirdVideoPlayerStatus;

- (void) saveThirdVideoPlayerUrl:(NSString *) url;
- (NSString *) readThirdVideoPlayerUrl;

- (void) saveThirdVideoPlaySecond:(NSNumber *) second;
- (NSNumber *) readThirdVideoPlaySecond;

- (void) saveVideoShowMonitorUrl:(NSString *) url;
- (NSString *) readShowMonitorUrl;

- (void) saveVideoClickMonItorUrl:(NSString *) url;
- (NSString *) readClickMonItorUrl;

- (void) saveOpenVideoUrl:(NSString *) url;
- (NSString *) readOpenVideoUrl;

- (void) saveVideoShowStartUrl:(NSString *) url;
- (NSString *) readVideoShowStartUrl;

- (void) saveVideoShowCenterUrl:(NSString *) url;
- (NSString *) readVideoCenterStartUrl;

- (void) saveVideoShowEndUrl:(NSString *) url;
- (NSString *) readVideoShowEndUrl;

- (void) saveVideoPlayArray:(NSArray *) array;
- (NSArray *) readVideoPlayArray;

- (void) saveAddBlockListStatus:(NSNumber *) status;
- (NSNumber *) readBlockListStatus;

- (void) savePromVersion:(NSString *) version;
- (NSString *) readPromVersion;

- (void) saveCanPushState:(NSNumber *) status;
- (NSNumber *) readCanPushState;
- (void) removeCanPushState;

- (void) saveParentName:(NSString *) parentName;
- (NSString *) readParentName;

/**保存黛色类别*/
- (void) saveDistributionLevel:(NSNumber *)distributionLevel;
- (NSNumber *)readDistributionLevel;
- (void) removeDistributionLevel;

/**保存是否为3个月试用期*/
- (void)saveDistributionLevelStatus:(NSNumber *)distributionLevelStatus;
- (NSNumber *)readDistributionLevelStatus;
- (void) removeDistributionLevelStatus;

/**保存黛色会员到期时间*/
- (void)saveDistributionEndTime:(NSString *)distributionEndTime;
- (NSString *)readDistributionEndTime;
- (void) removeDistributionEndTime;

/*一级人数*/
- (void)saveOneCount:(NSString *)oneCount;
- (NSString *)readOneCount;
- (void)removeOneCount;

/*二级人数*/
- (void)saveTwoCount:(NSString *)twoCount;
- (NSString *)readTwoCount;
- (void)removeTwoCount;

/*粉金人数*/
- (void)savePinkGoldCount:(NSString *)pinkGoldCount;
- (NSString *)readPinkGoldCount;
- (void)removePinkGoldCount;

/*粉钻人数*/
- (void)savePinkDiamondCount:(NSString *)pinkDiamondCount;
- (NSString *)readPinkDiamondCount;
- (void)removePinkDiamondCount;

///*返利人数*/
- (void)savePink:(NSString *)pink;
- (NSString *)readPink;
- (void)removePink;

/*总金额*/
- (void)saveAllEarnings:(NSString *)earnings;
- (NSString *)readAllEarnings;
- (void)removeAllEarnings;

/*A级id*/
- (void)saveADetailID:(NSNumber *)detailID;
- (NSString *)readADetailID;
- (void)removeADetailID;

/*提现姓名*/
- (void)saveGetCashName:(NSString *)getCashName;
- (NSString *)readGetCashName;
- (void)removeGetCashName;

/*提现卡号*/
- (void)saveGetCashCard:(NSString *)getCashCard;
- (NSString *)readGetCashCard;
- (void)removeGetCashCard;

/*是否在专题列表显示专区 isTopicZone：1-显示  2-不显示*/
- (void)saveTopicZone:(NSNumber *)isTopicZone;
- (NSNumber *)readTopicZone;
- (void)removeTopicZone;

/*isLogin*/
- (void)saveIsLogin:(NSNumber *)isLogin;
- (NSNumber *)readIsLogin;
- (void)removeIsLogin;

/*coverPic*/
- (void)saveCoverPic:(NSNumber *)coverPic;
- (NSNumber *)readCoverPic;
- (void)removeCoverPic;

/*MianInterfaceRecommendView-dataArray*/
- (void)saveMianInterfaceRecommendDataArray:(NSArray *)mianInterfaceRecommendDataArray;
- (NSArray *)readMianInterfaceRecommendDataArray;
- (void)removeMianInterfaceRecommendDataArray;

/*推送角标数*/
- (void)saveBadgeNumber:(NSNumber *)badgeNumber;
- (NSNumber *)readBadgeNumber;
- (void)removeBadgeNumber;

/*推送obj*/
- (void)saveUserInfoDict:(NSDictionary *)userInfoDict;
- (NSDictionary *)readUserInfoDict;
- (void)removeUserInfoDict;

/*is推送*/
- (void)saveIsLoginOfPush:(NSNumber *)isLoginOfPush;
- (NSNumber *)readIsLoginOfPush;
- (void)removeIsLoginOfPush;

/*is推送2*/
- (void)saveIsLaunchOfPush:(NSNumber *)isLaunchOfPush;
- (NSNumber *)readIsLaunchOfPush;
- (void)removeIsLaunchOfPush;

/*消息列表弹出通知设置记录*/
- (void)saveIsSettingOfPush:(NSNumber *)isSettingOfPush;
- (NSNumber *)readIsSettingOfPush;
- (void)removeIsSettingOfPush;

/*弹出通知设置记录*/
- (void)saveIsMainOfPush:(NSNumber *)isMainOfPush;
- (NSNumber *)readIsMainOfPush;
- (void)removeIsMainOfPush;

/*更新提示*/
- (void)saveIsCanUpdate:(NSNumber *)isCanUpdate;
- (NSNumber *)readIsCanUpdate;
- (void)removeIsCanUpdate;

/*会员角色id-新增粉银、粉金、粉钻*/
- (void)saveRole_id:(NSNumber *)role_id;
- (NSNumber *)readRole_id;
- (void)removeRole_id;

/*选择优惠券字典*/
- (void)saveSelectDict:(NSMutableDictionary *)selectDict;
- (NSMutableDictionary *)readSelectDict;
- (void)removeSelectDict;

/**保存deviceToken*/
- (void)saveDeviceTokenString:(NSString *)deviceTokenString;
- (NSString *)readdeviceTokenString;
- (void)removeDeviceTokenString;

@end
