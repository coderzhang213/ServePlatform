//
//  ObjInfoObj.h
//  camelliae2.0
//
//  Created by 张越 on 2018/10/15.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface ObjInfoObj : BaseResultObj

@property (nonatomic,strong) NSNumber *actBeginTime;

@property (nonatomic,strong) NSNumber *authorId;

@property (nonatomic,copy) NSString *cityName;

@property (nonatomic,strong) NSNumber *commentCount;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,strong) NSNumber *gender;

@property (nonatomic,copy) NSString *gravatar;

@property (nonatomic,strong) NSNumber *hadProjectInfoStatus;

@property (nonatomic,strong) NSNumber *hadUserInfoStatus;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *isFollow;

@property (nonatomic,strong) NSNumber *isUserLike;

@property (nonatomic,strong) NSNumber *likeNum;

@property (nonatomic,strong) NSNumber *memberLevel;

@property (nonatomic,copy) NSString *memberLevelName;

@property (nonatomic,copy) NSString *memberVipGrade;

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,copy) NSString *objCoverPic;

@property (nonatomic,strong) NSNumber *objType;

@property (nonatomic,copy) NSString *objTypeName;

@property (nonatomic,strong) NSNumber *publishTimeStamp;

@property (nonatomic,copy) NSString *publishTimeStr;

@property (nonatomic,strong) NSNumber *recommStatus;

@property (nonatomic,strong) NSNumber *recordId;

@property (nonatomic,strong) NSNumber *rootTypeId;

@property (nonatomic,copy) NSString *rootTypeName;

@property (nonatomic,copy) NSString *signature;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSNumber *memberLevelId;

@property (nonatomic, copy) NSString *hitNum;

@end
