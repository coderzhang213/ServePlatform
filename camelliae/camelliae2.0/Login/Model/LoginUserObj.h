//
//  LoginUserObj.h
//  camelliae2.0
//
//  Created by 张越 on 16/5/24.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface LoginUserObj : BaseResultObj

@property (nonatomic,copy) NSString *address;

@property (nonatomic,strong) NSNumber *birthday;

@property (nonatomic,strong) NSNumber *createTime;

@property (nonatomic,strong) NSNumber *emailVerified;

@property (nonatomic,strong) NSNumber *gender;

@property (nonatomic,copy) NSString *gravatar;

@property (nonatomic,strong) NSNumber *isBindMobile;

@property (nonatomic,strong) NSNumber *memberLevel;

@property (nonatomic,copy) NSString *memberLevelName;

@property (nonatomic,copy) NSString *mobile;

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,copy) NSString *openId;

@property (nonatomic,strong) NSNumber *openIdType;

@property (nonatomic,copy) NSString *openUnionId;

@property (nonatomic,strong) NSNumber *uid;

@property (nonatomic,strong) NSNumber *userPoints;

@property (nonatomic,copy) NSString *userRealName;

@property (nonatomic,strong) NSNumber *userStatus;

@property (nonatomic,copy) NSString *signature;

@property (nonatomic,strong) NSNumber *relFansCount;

@property (nonatomic,strong) NSNumber *relWatchCount;

@property (nonatomic,copy) NSString *inviteCode;

@property (nonatomic,strong) NSNumber *deliveryAddressId;

@property (nonatomic,copy) NSString *deliveryAddress;

@property (nonatomic,copy) NSString *deliveryConsignee;

@property (nonatomic,copy) NSString *deliveryMobile;

@property (nonatomic,copy) NSString *memberVipGrade;

@property (nonatomic,strong) NSNumber *isOpenTimeLine;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSArray *relTags;

@property (nonatomic,strong) NSNumber *memberPrivilegeLevel;

@property (nonatomic,strong) NSNumber *timeLineCount;


/******/
@property (nonatomic,strong) NSNumber *userId;

@property (nonatomic,copy) NSString *brief;

@property (nonatomic,copy) NSString *bgPicPath;

@property (nonatomic,strong) NSNumber *isUserFollow;

@property (nonatomic,copy) NSString *memberShareUrl;

@property (nonatomic,strong) NSNumber *hadUnreadMsg;

@property (nonatomic,copy) NSString *privilegeExpiryDate;

@property (nonatomic,strong) NSNumber *signStatus;


/****/
@property (nonatomic,strong) NSNumber *fansReadStatus;

@property (nonatomic,strong) NSNumber *likeReadStatus;

@property (nonatomic,strong) NSNumber *commentReadStatus;

@property (nonatomic,strong) NSNumber *messageReadStatus;

@property (nonatomic,strong) NSNumber *isHaveActivity;

@property (nonatomic,strong) NSNumber *isHaveProject;

@property (nonatomic,strong) NSNumber *isHaveGoods;

/*会员等级-1-980 2-9800 3-38000（五年）4-38000（原来的分享成员）*/
@property (nonatomic, strong) NSNumber *distributionLevel;

/*1-正常 2- 3个月试用期*/
@property (nonatomic, strong) NSNumber *distributionLevelStatus;

/*会员到期时间*/
@property (nonatomic, copy) NSString *distributionEndTime;

/*1-普通粉色 2-粉银 3-粉金 4-粉钻 5-黛*/
@property (nonatomic, strong) NSNumber *roleId;
/*黛色活动可报名次数*/
@property (nonatomic, strong) NSNumber *darkActNum;
/*可享权益数量*/
@property (nonatomic, strong) NSNumber *equityCount;

@property (nonatomic, copy) NSString *coverUrl;

@property (nonatomic, copy) NSString *vUrl;

@property (nonatomic, copy) NSString *roleName;

@end
