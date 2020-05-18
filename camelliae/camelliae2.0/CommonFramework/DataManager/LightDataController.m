//
//  LightDataController.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/18.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "LightDataController.h"
#import "BaseResultObj.h"
#import "LoginUserObj.h"
#import "CMLMessageObj.h"


@interface LightDataController ()

@property (nonatomic,strong) NSUserDefaults *defaults;
@end

@implementation LightDataController

- (instancetype)init{

    self = [super init];
    
    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

/**保存skey*/
- (void)saveSkey:(NSString *)skey{
        [self.defaults setObject:skey forKey:@"skeyOfCAMELLIAE"];
        [self.defaults synchronize];
}
- (NSString *)readSkey{
        return [self.defaults objectForKey:@"skeyOfCAMELLIAE"];
}
- (void)removeSkey{
        [self.defaults removeObjectForKey:@"skeyOfCAMELLIAE"];
}

- (void) saveAbsoluteString:(NSString *) absoluteString{
    
    [self.defaults setObject:absoluteString forKey:@"absoluteString"];
    [self.defaults synchronize];
}
- (NSString *)readAbsoluteString{
    
    return [self.defaults objectForKey:@"absoluteString"];
}
- (void)removeAbsoluteString{
    
    return [self.defaults removeObjectForKey:@"absoluteString"];
}

- (void) saveUserID:(NSNumber *)uid{
    [self.defaults setObject:uid forKey:@"userID"];
    [self.defaults synchronize];
}
- (NSNumber *)readUserID{
    return [self.defaults objectForKey:@"userID"];
}
- (void)removeUserID{
    [self.defaults removeObjectForKey:@"userID"];
}

/**保存城市ID*/

- (void) saveCityID:(NSNumber *)cityID{
  [self.defaults setObject:cityID forKey:@"currentCityID"];
    [self.defaults synchronize];
}
- (NSNumber *)readCityID{
   return [self.defaults objectForKey:@"currentCityID"];
}
- (void) removeCityID{

    [self.defaults removeObjectForKey:@"currentCityID"];
}

/**存储手机号*/
- (void) savePhone:(NSString *) phone{
  [self.defaults setObject:phone forKey:@"phone"];
  [self.defaults synchronize];
}
- (NSString *)readPhone{
   return [self.defaults objectForKey:@"phone"];
}
- (void) removePhone{
   [self.defaults removeObjectForKey:@"phone"];
}

/**real name*/
- (void) saveUserName:(NSString *)userName{
  [self.defaults setObject:userName forKey:@"userName"];
  [self.defaults synchronize];
}
- (NSString *)readUserName{
   return [self.defaults objectForKey:@"userName"];
}
- (void) removeUserName{
   [self.defaults removeObjectForKey:@"userName"];
}
/**nick name*/
- (void) saveNickName:(NSString *)nickName{
  [self.defaults setObject:nickName forKey:@"nickName"];
    [self.defaults synchronize];
}
- (NSString *)readNickName{
  return [self.defaults objectForKey:@"nickName"];
}
- (void) removeNickName{
  [self.defaults removeObjectForKey:@"nickName"];
}

/**头像地址*/
- (void) saveUserHeadImgUrl:(NSString *)imgUrl{
   [self.defaults setObject:imgUrl forKey:@"imgUrl"];
    [self.defaults synchronize];
}
- (NSString *)readUserHeadImgUrl{
   return [self.defaults objectForKey:@"imgUrl"];
}
- (void) removeUserHeadImgUrl{
  [self.defaults removeObjectForKey:@"imgUrl"];
}

/**用户性别*/
- (void) saveUserSex:(NSNumber *)sex{
  [self.defaults setObject:sex forKey:@"sex"];
    [self.defaults synchronize];
}
- (NSNumber *)readUserSex{
  return [self.defaults objectForKey:@"sex"];
}
- (void) removeUserSex{
  [self.defaults removeObjectForKey:@"sex"];
}

/**用户生日*/
- (void) saveUserBirth:(NSNumber *)birth{
  [self.defaults setObject:birth forKey:@"birth"];
    [self.defaults synchronize];
}
- (NSNumber *)readUserBirth{
  return [self.defaults objectForKey:@"birth"];
}
- (void) removeUserBirth{
  [self.defaults removeObjectForKey:@"birth"];
}

/**memberlvl*/
- (void) saveUserLevel:(NSNumber *)userLevel{

    [self.defaults setObject:userLevel forKey:@"userLevel"];
    [self.defaults synchronize];

}
- (NSNumber *)readUserLevel{

    return [self.defaults objectForKey:@"userLevel"];
}
- (void) removeUserLevel{
    
 [self.defaults removeObjectForKey:@"userLevel"];

}

/*会员角色roleId 1-普通粉色 2-粉银 3-粉金 4-粉钻 5-黛色*/
- (void)saveRoleId:(NSNumber *)roleId {
    [self.defaults setObject:roleId forKey:@"roleId"];
    [self.defaults synchronize];
}
- (NSNumber *)readRoleId {
    return [self.defaults objectForKey:@"roleId"];
}
- (void)removeRoleId {
    [self.defaults removeObjectForKey:@"roleId"];
}

/**用户积分*/
- (void) saveUserPoints:(NSNumber *)userPoints{
    [self.defaults setObject:userPoints forKey:@"userPoints"];
    [self.defaults synchronize];
}
- (NSNumber *)readUserPoints{
    return [self.defaults objectForKey:@"userPoints"];
}
- (void) removeUserPoints{
    [self.defaults removeObjectForKey:@"userPoints"];
}

/**登录方式*/
- (void) saveOpenType:(NSNumber *)type{
  [self.defaults setObject:type forKey:@"opentype"];
    [self.defaults synchronize];
}
- (NSNumber *)readOpenType{
  return [self.defaults objectForKey:@"opentype"];
}
- (void) removeOpenType{
  [self.defaults removeObjectForKey:@"opentype"];
}

/**是否被绑定*/
- (void) saveBindPhoneStatus:(NSNumber *) status{
    [self.defaults setObject:status forKey:@"isBindPhone"];
    [self.defaults synchronize];
}
- (NSNumber *)readBindPhoneStatus{
    return [self.defaults objectForKey:@"isBindPhone"];
}
- (void) removeBindStatus{
    [self.defaults removeObjectForKey:@"isBindPhone"];
}


/**用户签名*/
- (void) saveSignature:(NSString *) signature{
    [self.defaults setObject:signature forKey:@"signature"];
    [self.defaults synchronize];
}
- (NSString *)readSignature{
     return [self.defaults objectForKey:@"signature"];
}
- (void) removeSignature{
     [self.defaults removeObjectForKey:@"signature"];
}


/**用户粉丝数*/
- (void) saveRelFansCount:(NSNumber *) relFansCount{
    [self.defaults setObject:relFansCount forKey:@"relFansCount"];
    [self.defaults synchronize];
}
- (NSNumber *)readRelFansCount{
     return [self.defaults objectForKey:@"relFansCount"];
}
- (void) removeRelFansCount{
    [self.defaults removeObjectForKey:@"relFansCount"];
}

/**用户关注人数*/
- (void) saveRelWatchCount:(NSNumber *) relWatchCount{
    [self.defaults setObject:relWatchCount forKey:@"relWatchCount"];
    [self.defaults synchronize];
}
- (NSNumber *)readRelWatchCount{
    return [self.defaults objectForKey:@"relWatchCount"];
}
- (void) removeRelWatchCount{
    [self.defaults removeObjectForKey:@"relWatchCount"];
}

/**邀请码*/
- (void) saveInviteCode:(NSString *) inviteCode{
    [self.defaults setObject:inviteCode forKey:@"inviteCode"];
    [self.defaults synchronize];
}
- (NSString *)readInviteCode{
    return [self.defaults objectForKey:@"inviteCode"];
}
- (void) removeInviteCode{
    [self.defaults removeObjectForKey:@"inviteCode"];
}

/**收货地址ID*/
- (void) saveDeliveryAddressID:(NSNumber *) deliveryAddressID{
    [self.defaults setObject:deliveryAddressID forKey:@"deliveryAddressID"];
    [self.defaults synchronize];
}
- (NSNumber *)readDeliveryAddressID{
    return [self.defaults objectForKey:@"deliveryAddressID"];
}
- (void) removeDeliveryAddressID{
    [self.defaults removeObjectForKey:@"deliveryAddressID"];
}

/**用户收货地址*/
- (void) saveDeliveryAddress:(NSString *) address{
    [self.defaults setObject:address forKey:@"deliveryAddress"];
    [self.defaults synchronize];
}
- (NSString *)readDeliveryAddress{
    return [self.defaults objectForKey:@"deliveryAddress"];
}
- (void) removeDeliveryAddress{
    [self.defaults removeObjectForKey:@"deliveryAddress"];
}
/**收货联系人*/
- (void) saveDeliveryUser:(NSString *) deliveryUser{
  [self.defaults setObject:deliveryUser forKey:@"deliveryUser"];
    [self.defaults synchronize];
}
- (NSString *)readDeliveryUser{
  return [self.defaults objectForKey:@"deliveryUser"];
}
- (void) removeDeliveryUser{
  [self.defaults removeObjectForKey:@"deliveryUser"];
}

/**收货电话*/
- (void) saveDeliveryPhone:(NSString *) deliveryPhone{
   [self.defaults setObject:deliveryPhone forKey:@"deliveryPhone"];
    [self.defaults synchronize];
}
- (NSString *)readDeliveryPhone{
   return [self.defaults objectForKey:@"deliveryPhone"];
}
- (void) removeDeliveryPhone{
   [self.defaults removeObjectForKey:@"deliveryPhone"];
}

/**版本号存储*/
- (void) saveVersion:(NSString *)version{
    [self.defaults setObject:version forKey:@"versionOfCamelliae"];
    [self.defaults synchronize];
}
- (NSString *) readVersion{
    return [self.defaults objectForKey:@"versionOfCamelliae"];
}

/**推荐地址*/
- (void) saveAppDownloadUrl:(NSString *)appDownloadUrl{
    [self.defaults setObject:appDownloadUrl forKey:@"appDownloadUrl"];
    [self.defaults synchronize];
}
- (NSString *) readAppDownloadUrl{
    return [self.defaults objectForKey:@"appDownloadUrl"];
}

/**关于我们地址*/
- (void) saveAboutUsUrl:(NSString *) currentUrl{
    [self.defaults setObject:currentUrl forKey:@"aboutus"];
    [self.defaults synchronize];
}
- (NSString *) readAboutUsUrl{
    return  [self.defaults objectForKey:@"aboutus"];
    
}

/**知识产权保护说明*/
- (void) saveIntellectualPropertyRightsUrl:(NSString *) currentUrl{
    [self.defaults setObject:currentUrl forKey:@"intellectualpropertyrights"];
    [self.defaults synchronize];
    
}
- (NSString *) readIntellectualPropertyRightsUrl{
    return [self.defaults objectForKey:@"intellectualpropertyrights"];
    
}

/**用户协议*/
- (void)saveUrlAgreement:(NSString *)currentUrl {
    [self.defaults setObject:currentUrl forKey:@"urlAgreement"];
    [self.defaults synchronize];
    
}
- (NSString *)readUrlAgreement {
    return [self.defaults objectForKey:@"urlAgreement"];
    
}

/**服务及隐私条款*/
- (void) saveServiceAndPrivacyUrl:(NSString *) currentUrl{
    [self.defaults setObject:currentUrl forKey:@"serviceandprivacy"];
    [self.defaults synchronize];
    
}
- (NSString *) readServiceAndPrivacyUrl{
    return [self.defaults objectForKey:@"serviceandprivacy"];
}

/**商城规则*/
- (void) saveRuleUrl:(NSString *) currentUrl{
    
    [self.defaults setObject:currentUrl forKey:@"ruleUrl"];
    [self.defaults synchronize];
}
- (NSString *) readRuleUrl{
    
    return [self.defaults objectForKey:@"ruleUrl"];
}
/**花伴权力*/
- (void)saveFlowersWithPower:(NSString *) currentUrl{
    [self.defaults setObject:currentUrl forKey:@"flowerswithpower"];
    [self.defaults synchronize];
}
- (NSString *) readFlowersWithPowerUrl{
    return [self.defaults objectForKey:@"flowerswithpower"];
}

/**花伴升级*/
- (void) saveFlowersWithUpgrade:(NSString *) currentUrl{
    [self.defaults setObject:currentUrl forKey:@"flowerswithupgrade"];
    [self.defaults synchronize];
}
- (NSString *) readFlowersWithUpgradeUrl{
    return [self.defaults objectForKey:@"flowerswithupgrade"];
}

/**花伴等级*/
- (void) saveFlowersWithLevel:(NSString *) currentUrl{
    [self.defaults setObject:currentUrl forKey:@"flowerswithlevel"];
    [self.defaults synchronize];
    
}
- (NSString *) readFlowersWithLevel{
    return [self.defaults objectForKey:@"flowerswithlevel"];
}

- (void) saveLoginBannerUrl:(NSString *) imageUrl{
    [self.defaults setObject:imageUrl forKey:@"loginBanner"];
    [self.defaults synchronize];
    
}
- (NSString *) readLoginBannerImageUlr{
    return [self.defaults objectForKey:@"loginBanner"];
}

- (void) saveMemberVipGrade:(NSString *) vipGrade{

    [self.defaults setObject:vipGrade forKey:@"memberVipGrade"];
    [self.defaults synchronize];
}

- (NSString *) readMemberVipGrade{
    return [self.defaults objectForKey:@"memberVipGrade"];
}

- (void) saveMemberListNumber:(NSNumber *) number{

    [self.defaults setObject:number forKey:@"memberListNumber"];
    [self.defaults synchronize];
}
- (NSNumber *) readMemberListNumber{

    return [self.defaults objectForKey:@"memberListNumber"];
}

- (void) saveGradeBuyState:(NSNumber *) state{

    [self.defaults setObject:state forKey:@"gradeBuyState"];
    [self.defaults synchronize];
}
- (NSNumber *) readGradeBuyState{

    return [self.defaults objectForKey:@"gradeBuyState"];
}

- (void) saveLetterReadState:(NSNumber *) state{

    [self.defaults setObject:state forKey:@"readState"];
    [self.defaults synchronize];
}
- (NSNumber *) readLetterReadState{

    return [self.defaults objectForKey:@"readState"];
}

- (void) saveAdPoster:(NSString *) str{

   [self.defaults setObject:str forKey:@"adPoster"];
    [self.defaults synchronize];
}
- (NSString *) readAdPoster{

    return [self.defaults objectForKey:@"adPoster"];
}

- (void) savePrivilegeExpiryDate:(NSString *) str{

    [self.defaults setObject:str forKey:@"privilegeExpiryDate"];
    [self.defaults synchronize];
}
- (NSString *) readPrivilegeExpiryDate{

    return [self.defaults objectForKey:@"privilegeExpiryDate"];
}

- (void) saveMemberIvlUrl:(NSString *)url{

    [self.defaults setObject:url forKey:@"memberLvlUrl"];
    [self.defaults synchronize];
}
- (NSString *)readMemberLvlUrl{

    return [self.defaults objectForKey:@"memberLvlUrl"];
}

/**保存黛色类别*/
- (void)saveDistributionLevel:(NSNumber *)distributionLevel {
    [self.defaults setObject:distributionLevel forKey:@"distributionLevel"];
    [self.defaults synchronize];
}
- (NSNumber *)readDistributionLevel {
    return [self.defaults objectForKey:@"distributionLevel"];
}
- (void) removeDistributionLevel {
    [self.defaults removeObjectForKey:@"distributionLevel"];
}

/**保存是否为3个月试用期*/
- (void)saveDistributionLevelStatus:(NSNumber *)distributionLevelStatus {
    [self.defaults setObject:distributionLevelStatus forKey:@"distributionLevelStatus"];
    [self.defaults synchronize];
}
- (NSNumber *)readDistributionLevelStatus {
    return [self.defaults objectForKey:@"distributionLevelStatus"];
}
- (void) removeDistributionLevelStatus {
    [self.defaults removeObjectForKey:@"distributionLevelStatus"];
}

/**保存黛色会员到期时间*/
- (void)saveDistributionEndTime:(NSString *)distributionEndTime {
    [self.defaults setObject:distributionEndTime forKey:@"distributionEndTime"];
    [self.defaults synchronize];
}
- (NSString *)readDistributionEndTime {
    return [self.defaults objectForKey:@"distributionEndTime"];
}
- (void)removeDistributionEndTime {
    [self.defaults removeObjectForKey:@"distributionEndTime"];
}

/*一级人数*/
- (void)saveOneCount:(NSString *)oneCount {
    [self.defaults setObject:oneCount forKey:@"oneCount"];
    [self.defaults synchronize];
}
- (NSString *)readOneCount {
    return [self.defaults objectForKey:@"oneCount"];
}
- (void)removeOneCount {
    [self.defaults removeObjectForKey:@"oneCount"];
}

/*二级人数*/
- (void)saveTwoCount:(NSString *)twoCount {
    [self.defaults setObject:twoCount forKey:@"twoCount"];
    [self.defaults synchronize];
}
- (NSString *)readTwoCount {
    return [self.defaults objectForKey:@"twoCount"];
}
- (void)removeTwoCount {
    [self.defaults removeObjectForKey:@"twoCount"];
}

/*粉金人数*/
- (void)savePinkGoldCount:(NSString *)pinkGoldCount {
    [self.defaults setObject:pinkGoldCount forKey:@"pinkGoldCount"];
    [self.defaults synchronize];
}
- (NSString *)readPinkGoldCount {
    return [self.defaults objectForKey:@"pinkGoldCount"];
}
- (void)removePinkGoldCount {
    [self.defaults removeObjectForKey:@"pinkGoldCount"];
}
/*粉钻人数*/
- (void)savePinkDiamondCount:(NSString *)pinkDiamondCount {
    [self.defaults setObject:pinkDiamondCount forKey:@"pinkDiamondCount"];
    [self.defaults synchronize];
}
- (NSString *)readPinkDiamondCount {
    return [self.defaults objectForKey:@"pinkDiamondCount"];
}
- (void)removePinkDiamondCount {
    [self.defaults removeObjectForKey:@"pinkDiamondCount"];
}

/*返利*/
- (void)savePink:(NSString *)pink {
    [self.defaults setObject:pink forKey:@"pink"];
    [self.defaults synchronize];
}
- (NSString *)readPink {
    return [self.defaults objectForKey:@"pink"];
}
- (void)removePink {
    [self.defaults removeObjectForKey:@"pink"];
}

///**/
//- (void)savePink:(NSString *)pink {
//    [self.defaults setObject:pink forKey:@"pink"];
//    [self.defaults synchronize];
//}
//- (NSString *)readPink {
//    return [self.defaults objectForKey:@"pink"];
//}
//- (void)removePink {
//    [self.defaults removeObjectForKey:@"pink"];
//}


/*总金额*/
- (void)saveAllEarnings:(NSString *)earnings {
    [self.defaults setObject:earnings forKey:@"earnings"];
    [self.defaults synchronize];
}
- (NSString *)readAllEarnings {
    return [self.defaults objectForKey:@"earnings"];
}
- (void)removeAllEarnings {
    [self.defaults removeObjectForKey:@"earnings"];
}

/*A级id*/
- (void)saveADetailID:(NSNumber *)detailID {
    [self.defaults setObject:detailID forKey:@"detailID"];
    [self.defaults synchronize];
}
- (NSString *)readADetailID {
    return [self.defaults objectForKey:@"detailID"];
}
- (void)removeADetailID {
    [self.defaults removeObjectForKey:@"detailID"];
}

/*提现姓名*/
- (void)saveGetCashName:(NSString *)getCashName {
    [self.defaults setObject:getCashName forKey:@"getCashName"];
    [self.defaults synchronize];
}
- (NSString *)readGetCashName {
    return [self.defaults objectForKey:@"getCashName"];
}
- (void)removeGetCashName {
    [self.defaults removeObjectForKey:@"getCashName"];
}

/*提现卡号*/
- (void)saveGetCashCard:(NSString *)getCashCard {
    [self.defaults setObject:getCashCard forKey:@"getCashCard"];
    [self.defaults synchronize];
}
- (NSString *)readGetCashCard {
    return [self.defaults objectForKey:@"getCashCard"];
}
- (void)removeGetCashCard {
    [self.defaults removeObjectForKey:@"getCashCard"];
}

/*是否在专题列表显示专区 isTopicZone：1-显示  2-不显示*/
- (void)saveTopicZone:(NSNumber *)isTopicZone {
    [self.defaults setObject:isTopicZone forKey:@"isTopicZone"];
    [self.defaults synchronize];
}
- (NSNumber *)readTopicZone {
    return [self.defaults objectForKey:@"isTopicZone"];
}
- (void)removeTopicZone {
    [self.defaults removeObjectForKey:@"isTopicZone"];
}

/*isLogin*/
- (void)saveIsLogin:(NSNumber *)isLogin {
    [self.defaults setObject:isLogin forKey:@"isLogin"];
    [self.defaults synchronize];
}
- (NSNumber *)readIsLogin {
    return [self.defaults objectForKey:@"isLogin"];
}
- (void)removeIsLogin {
    [self.defaults removeObjectForKey:@"isLogin"];
}

/*coverPic*/
- (void)saveCoverPic:(NSNumber *)coverPic {
    [self.defaults setObject:coverPic forKey:@"coverPic"];
    [self.defaults synchronize];
}
- (NSNumber *)readCoverPic {
    return [self.defaults objectForKey:@"coverPic"];
}
- (void)removeCoverPic {
    [self.defaults removeObjectForKey:@"coverPic"];
}

/****************/
- (void) saveUserInfo:(BaseResultObj *)obj{

    LoginUserObj *userInfo = obj.retData.userInfo;
    
    if (userInfo.uid) {
     
        [self savePhone:userInfo.mobile];
        [self saveUserID:userInfo.uid];
        [self saveUserName:userInfo.userRealName];
        [self saveUserLevel:userInfo.memberLevel];
    
        [self saveDistributionLevel:userInfo.distributionLevel];
        [self saveDistributionEndTime:userInfo.distributionEndTime];
        [self saveDistributionLevelStatus:userInfo.distributionLevelStatus];
        
        [self saveUserPoints:userInfo.userPoints];
        [self saveNickName:userInfo.nickName];
        [self saveOpenType:userInfo.openIdType];
        [self saveUserHeadImgUrl:userInfo.gravatar];
        [self saveUserSex:userInfo.gender];
        [self saveUserBirth:userInfo.birthday];
        [self saveBindPhoneStatus:userInfo.isBindMobile];
        [self saveSignature:userInfo.signature];
        [self saveRelFansCount:userInfo.relFansCount];
        [self saveRelWatchCount:userInfo.relWatchCount];
        [self saveInviteCode:userInfo.inviteCode];
        [self saveDeliveryAddressID:userInfo.deliveryAddressId];
        [self saveDeliveryAddress:userInfo.deliveryAddress];
        [self saveDeliveryUser:userInfo.deliveryConsignee];
        [self saveDeliveryPhone:userInfo.deliveryMobile];
        [self saveMemberVipGrade:userInfo.memberVipGrade];
        [self saveGradeBuyState:userInfo.memberPrivilegeLevel];
        [self saveMemberListNumber:userInfo.timeLineCount];
        [self saveLetterReadState:userInfo.hadUnreadMsg];
        [self savePrivilegeExpiryDate:userInfo.privilegeExpiryDate];
        [self saveRoleId:userInfo.roleId];
    }
}

- (void) saveUser:(BaseResultObj *)obj{

    LoginUserObj *userInfo = obj.retData.user;
    
    [self savePhone:userInfo.mobile];
    [self saveUserID:userInfo.uid];
    [self saveUserName:userInfo.userRealName];
    [self saveUserLevel:userInfo.memberLevel];
    [self saveRoleId:userInfo.roleId];
    [self saveUserPoints:userInfo.userPoints];
    [self saveNickName:userInfo.nickName];
    
    [self saveDistributionLevel:userInfo.distributionLevel];
    [self saveDistributionEndTime:userInfo.distributionEndTime];
    [self saveDistributionLevelStatus:userInfo.distributionLevelStatus];
    
    [self saveOpenType:userInfo.openIdType];
    [self saveUserHeadImgUrl:userInfo.gravatar];
    [self saveUserSex:userInfo.gender];
    [self saveUserBirth:userInfo.birthday];
    [self saveBindPhoneStatus:userInfo.isBindMobile];
    [self saveSignature:userInfo.signature];
    [self saveRelFansCount:userInfo.relFansCount];
    [self saveRelWatchCount:userInfo.relWatchCount];
    [self saveInviteCode:userInfo.inviteCode];
    [self saveDeliveryAddressID:userInfo.deliveryAddressId];
    [self saveDeliveryAddress:userInfo.deliveryAddress];
    [self saveDeliveryUser:userInfo.deliveryConsignee];
    [self saveDeliveryPhone:userInfo.deliveryMobile];
    [self saveMemberVipGrade:userInfo.memberVipGrade];
    [self saveGradeBuyState:userInfo.memberPrivilegeLevel];
    [self saveMemberListNumber:userInfo.timeLineCount];
    [self saveLetterReadState:userInfo.hadUnreadMsg];
    [self savePrivilegeExpiryDate:userInfo.privilegeExpiryDate];
    

}

- (void) saveUrlMessage:(BaseResultObj *)obj{

    [self saveAppDownloadUrl:obj.retData.appDownloadUrl];
    [self saveAboutUsUrl:obj.retData.urlAboutUs];
    [self saveIntellectualPropertyRightsUrl:obj.retData.urlIpr];
    [self saveServiceAndPrivacyUrl:obj.retData.urlProvision];
    [self saveUrlAgreement:obj.retData.urlAgreement];
    [self saveRuleUrl:obj.retData.rlueUrl];
    [self saveFlowersWithPower:obj.retData.urlMemberRight];
    [self saveFlowersWithLevel:obj.retData.urlMemberGrade];
    [self saveFlowersWithUpgrade:obj.retData.urlUpGrade];

}

- (void)saveCurrentTime:(NSDate *)currentDate {
    [self.defaults setObject:currentDate forKey:@"navigationShow"];
    [self.defaults synchronize];
}
- (NSDate *)readCurrentTime {
    return [self.defaults objectForKey:@"navigationShow"];
}
- (void)saveShowAd:(NSNumber *)isShow {
    [self.defaults setObject:isShow forKey:@"isShow"];
    [self.defaults synchronize];
}

- (NSNumber *)readIsShow{

    return [self.defaults objectForKey:@"isShow"];
}

- (void) saveTimePeriod:(NSNumber *) period{

    [self.defaults setObject:period forKey:@"TimePeriod"];
    [self.defaults synchronize];
}

- (NSNumber *)readPeriod{

    return [self.defaults objectForKey:@"isShow"];
}

- (void) saveNavImageUrl:(NSString *) imageUrl{

    [self.defaults setObject:imageUrl forKey:@"NavImageUrl"];
    [self.defaults synchronize];
}
- (NSString *) readNavImageUrl{

     return [self.defaults objectForKey:@"NavImageUrl"];
}

- (void) saveNavImageWidth:(NSNumber *) width{

    [self.defaults setObject:width forKey:@"Navwidth"];
    [self.defaults synchronize];
}
- (NSNumber *) readNavImageWidth{

    return [self.defaults objectForKey:@"Navwidth"];
}

- (void) saveNavImageHeight:(NSNumber *) height{

    [self.defaults setObject:height forKey:@"Navheight"];
    [self.defaults synchronize];
}
- (NSNumber *) readNavImageHeight{

    return [self.defaults objectForKey:@"Navheight"];
}

- (void) saveObjID:(NSNumber *) objID{

    [self.defaults setObject:objID forKey:@"objID"];
    [self.defaults synchronize];
}
- (NSNumber *) readObjID{

    return [self.defaults objectForKey:@"objID"];
}

- (void) saveDataType:(NSNumber *) dataType{
    

    [self.defaults setObject:dataType forKey:@"dataType"];
    [self.defaults synchronize];
}
- (NSNumber *) readDataType{

    return [self.defaults objectForKey:@"dataType"];
}

- (void) saveObjType:(NSNumber *) objType{

    [self.defaults setObject:objType forKey:@"objType"];
    [self.defaults synchronize];
}
- (NSNumber *) readObjType{

    return [self.defaults objectForKey:@"objType"];
}

- (void) saveEnterWebUrl:(NSString *) url{

    [self.defaults setObject:url forKey:@"WebUrl"];
    [self.defaults synchronize];
}
- (NSString *) readWebUrl{

    return [self.defaults objectForKey:@"WebUrl"];
}
- (void) saveNewStatus:(NSNumber *) status{

    [self.defaults setObject:status forKey:@"NewStatus"];
    [self.defaults synchronize];
}
- (NSNumber *) readNewStatus{

    return [self.defaults objectForKey:@"NewStatus"];
}

- (void) saveSignStatus:(NSNumber *) status{

    [self.defaults setObject:status forKey:@"SignStatus"];
    [self.defaults synchronize];
}
- (NSNumber *) readSignStatus{

    return [self.defaults objectForKey:@"SignStatus"];
}

- (void) saveThirdVideoPlayerStatus:(NSNumber *) status{

    [self.defaults setObject:status forKey:@"ThirdVideoPlayerStatus"];
    [self.defaults synchronize];
}
- (NSNumber *) readThirdVideoPlayerStatus{

    return [self.defaults objectForKey:@"ThirdVideoPlayerStatus"];
}

- (void) saveThirdVideoPlayerUrl:(NSString *) url{

    [self.defaults setObject:url forKey:@"ThirdVideoPlayerUrl"];
    [self.defaults synchronize];
}
- (NSString *) readThirdVideoPlayerUrl{

    return [self.defaults objectForKey:@"ThirdVideoPlayerUrl"];
}

- (void) saveThirdVideoPlaySecond:(NSNumber *) second{


    [self.defaults setObject:second forKey:@"ThirdVideoPlaySecond"];
    [self.defaults synchronize];
}
- (NSNumber *) readThirdVideoPlaySecond{

     return [self.defaults objectForKey:@"ThirdVideoPlaySecond"];
}

- (void) saveVideoShowMonitorUrl:(NSString *) url{

    [self.defaults setObject:url forKey:@"VideoShowMonitorUrl"];
    [self.defaults synchronize];
}
- (NSString *) readShowMonitorUrl{

    return [self.defaults objectForKey:@"VideoShowMonitorUrl"];
}

- (void) saveVideoClickMonItorUrl:(NSString *) url{

    [self.defaults setObject:url forKey:@"VideoClickMonItorUrl"];
    [self.defaults synchronize];
}
- (NSString *) readClickMonItorUrl{

    return [self.defaults objectForKey:@"VideoClickMonItorUrl"];
}

- (void) saveOpenVideoUrl:(NSString *) url{

    [self.defaults setObject:url forKey:@"OpenVideoUrl"];
    [self.defaults synchronize];
}
- (NSString *) readOpenVideoUrl{

    return [self.defaults objectForKey:@"OpenVideoUrl"];
}

- (void) saveVideoShowStartUrl:(NSString *) url{

    [self.defaults setObject:url forKey:@"VideoShowStartUrl"];
    [self.defaults synchronize];

}
- (NSString *) readVideoShowStartUrl{

    return [self.defaults objectForKey:@"VideoShowStartUrl"];
}

- (void) saveVideoShowCenterUrl:(NSString *) url{

    [self.defaults setObject:url forKey:@"VideoShowCenterUrl"];
    [self.defaults synchronize];
}
- (NSString *) readVideoCenterStartUrl{


    return [self.defaults objectForKey:@"VideoShowCenterUrl"];
}

- (void) saveVideoShowEndUrl:(NSString *) url{
    [self.defaults setObject:url forKey:@"VideoShowEndUrl"];
    [self.defaults synchronize];

}
- (NSString *) readVideoShowEndUrl{

    return [self.defaults objectForKey:@"VideoShowEndUrl"];
}

- (void) saveVideoPlayArray:(NSArray *) array{
  
    [self.defaults setObject:array forKey:@"VideoPlayArray"];
    [self.defaults synchronize];
}
- (NSArray *) readVideoPlayArray{
    
    return [self.defaults objectForKey:@"VideoPlayArray"];
}

- (void) saveAddBlockListStatus:(NSNumber *) status{
    
    [self.defaults setObject:status forKey:@"BlackStatus"];
    [self.defaults synchronize];
}
- (NSNumber *) readBlockListStatus{
    
     return [self.defaults objectForKey:@"BlackStatus"];
}

- (void) savePromVersion:(NSString *) version{
    
    [self.defaults setObject:version forKey:@"PromVersion"];
    [self.defaults synchronize];
    
}
- (NSString *) readPromVersion{
    
    return [self.defaults objectForKey:@"PromVersion"];
}

- (void) saveCanPushState:(NSNumber *) status{
    
    [self.defaults setObject:status forKey:@"pushState"];
    [self.defaults synchronize];
}
- (NSNumber *) readCanPushState{
    
    return [self.defaults objectForKey:@"pushState"];
}
- (void) removeCanPushState{
    
     [self.defaults removeObjectForKey:@"pushState"];
    
}

- (void) saveParentName:(NSString *) parentName{
    
    [self.defaults setObject:parentName forKey:@"parentName"];
    [self.defaults synchronize];
}
- (NSString *) readParentName{
    
    return [self.defaults objectForKey:@"parentName"];
}

/*MianInterfaceRecommendView-dataArray*/
- (void)saveMianInterfaceRecommendDataArray:(NSArray *)mianInterfaceRecommendDataArray {
    [self.defaults setObject:mianInterfaceRecommendDataArray forKey:@"mianInterfaceRecommendDataArray"];
    [self.defaults synchronize];
}
- (NSMutableArray *)readMianInterfaceRecommendDataArray {
    return [self.defaults objectForKey:@"mianInterfaceRecommendDataArray"];
}
- (void)removeMianInterfaceRecommendDataArray {
    [self.defaults removeObjectForKey:@"mianInterfaceRecommendDataArray"];
}
/*推送角标数*/
- (void)saveBadgeNumber:(NSNumber *)badgeNumber {
    [self.defaults setObject:badgeNumber forKey:@"badgeNumber"];
    [self.defaults synchronize];
}
- (NSNumber *)readBadgeNumber {
    return [self.defaults objectForKey:@"badgeNumber"];
}
- (void)removeBadgeNumber {
    [self.defaults removeObjectForKey:@"badgeNumber"];
}

/*推送obj*/
- (void)saveUserInfoDict:(NSDictionary *)userInfoDict {
    [self.defaults setObject:userInfoDict forKey:@"userInfoDict"];
    [self.defaults synchronize];
}
- (NSDictionary *)readUserInfoDict {
    return [self.defaults objectForKey:@"userInfoDict"];
}
- (void)removeUserInfoDict {
    [self.defaults removeObjectForKey:@"userInfoDict"];
}

/*is推送*/
- (void)saveIsLoginOfPush:(NSNumber *)isLoginOfPush {
    [self.defaults setObject:isLoginOfPush forKey:@"isLoginOfPush"];
    [self.defaults synchronize];
}
- (NSNumber *)readIsLoginOfPush {
    return [self.defaults objectForKey:@"isLoginOfPush"];
}
- (void)removeIsLoginOfPush {
    [self.defaults removeObjectForKey:@"isLoginOfPush"];
}


/*is推送2*/
- (void)saveIsLaunchOfPush:(NSNumber *)isLaunchOfPush {
    [self.defaults setObject:isLaunchOfPush forKey:@"isLaunchOfPush"];
    [self.defaults synchronize];
}
- (NSNumber *)readIsLaunchOfPush {
    return [self.defaults objectForKey:@"isLaunchOfPush"];
}
- (void)removeIsLaunchOfPush {
    [self.defaults removeObjectForKey:@"isLaunchOfPush"];
}

/*消息列表弹出通知设置记录*/
- (void)saveIsSettingOfPush:(NSNumber *)isSettingOfPush {
    [self.defaults setObject:isSettingOfPush forKey:@"isSettingOfPush"];
    [self.defaults synchronize];
}
- (NSNumber *)readIsSettingOfPush {
    return [self.defaults objectForKey:@"isSettingOfPush"];
}
- (void)removeIsSettingOfPush {
    [self.defaults removeObjectForKey:@"isSettingOfPush"];
}

/*弹出通知设置记录*/
- (void)saveIsMainOfPush:(NSNumber *)isMainOfPush {
    [self.defaults setObject:isMainOfPush forKey:@"isMainOfPush"];
    [self.defaults synchronize];
}
- (NSNumber *)readIsMainOfPush {
    return [self.defaults objectForKey:@"isMainOfPush"];
}
- (void)removeIsMainOfPush {
    [self.defaults removeObjectForKey:@"isMainOfPush"];
}

/*更新提示*/
- (void)saveIsCanUpdate:(NSNumber *)isCanUpdate {
    [self.defaults setObject:isCanUpdate forKey:@"isCanUpdate"];
    [self.defaults synchronize];
}
- (NSNumber *)readIsCanUpdate {
    return [self.defaults objectForKey:@"isCanUpdate"];
}
- (void)removeIsCanUpdate {
    [self.defaults removeObjectForKey:@"isCanUpdate"];
}

/*会员角色id-1-粉色 2-粉银、3-粉金、4-粉钻、5-黛色*/
- (void)saveRole_id:(NSNumber *)role_id {
    [self.defaults setObject:role_id forKey:@"role_id"];
    [self.defaults synchronize];
}
- (NSNumber *)readRole_id {
    return [self.defaults objectForKey:@"role_id"];
}
- (void)removeRole_id {
    [self.defaults removeObjectForKey:@"role_id"];
}

/*选择优惠券字典*/
- (void)saveSelectDict:(NSMutableDictionary *)selectDict {
    [self.defaults setObject:selectDict forKey:@"selectDict"];
    [self.defaults synchronize];
}
- (NSMutableDictionary *)readSelectDict {
    return [self.defaults objectForKey:@"selectDict"];
}
- (void)removeSelectDict {
    [self.defaults removeObjectForKey:@"selectDict"];
}

/**保存deviceToken*/
- (void)saveDeviceTokenString:(NSString *)deviceTokenString {
    [self.defaults setObject:deviceTokenString forKey:@"deviceTokenString"];
    [self.defaults synchronize];
}
- (NSString *)readDeviceTokenString {
    return [self.defaults objectForKey:@"deviceTokenString"];
}
- (void)removeDeviceTokenString {
    [self.defaults removeObjectForKey:@"deviceTokenString"];
}

@end
