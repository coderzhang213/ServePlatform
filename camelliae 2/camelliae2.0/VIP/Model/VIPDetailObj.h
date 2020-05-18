//
//  VIPDetailObj.h
//  camelliae2.0
//
//  Created by 张越 on 16/6/13.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface VIPDetailObj : BaseResultObj

//@property (nonatomic,strong) NSNumber *userId;

@property (nonatomic,strong) NSNumber *uid;

@property (nonatomic,copy) NSString *openUnionId;

@property (nonatomic,strong) NSNumber *openIdType;

@property (nonatomic,strong) NSNumber *emailVerified;

@property (nonatomic,strong) NSNumber *isBindMobile;

@property (nonatomic,copy) NSString *mobile;

@property (nonatomic,copy) NSString *userRealName;

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,strong) NSNumber *gender;

@property (nonatomic,copy) NSString *brief;

@property (nonatomic,copy) NSString *bgPicPath;

@property (nonatomic,copy) NSString *gravatar;

@property (nonatomic,strong) NSNumber *userStatus;

@property (nonatomic,copy) NSString *signature;

@property (nonatomic,strong) NSNumber *relFansCount;

@property (nonatomic,strong) NSNumber *relWatchCount;

@property (nonatomic,strong) NSNumber *isUserFollow;

@property (nonatomic,strong) NSArray *coverPicArr;

@property (nonatomic,strong) NSNumber *memberLevel;

@property (nonatomic,copy) NSString *memberVipGrade;

@property (nonatomic,copy) NSString *userProfile;

@property (nonatomic,strong) NSArray *relTags;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSNumber *isBothFollow;

@property (nonatomic,strong) NSNumber *reqUserFollowStatus;

@property (nonatomic,strong) NSNumber *memberPrivilegeLevel;

@property (nonatomic,copy) NSString *companyName;


@end
