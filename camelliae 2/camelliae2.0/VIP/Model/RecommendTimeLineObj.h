//
//  RecommendTimeLineObj.h
//  camelliae2.0
//
//  Created by 张越 on 2016/12/18.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

#import "ProjectInfoObj.h"

#import "ThemeObj.h"

@interface RecommendTimeLineObj : BaseResultObj

@property (nonatomic,strong) NSNumber *recordId;

@property (nonatomic,strong) NSNumber *userId;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) NSString *userRealName;

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,strong) NSNumber *gender;

@property (nonatomic,copy) NSString *brief;

@property (nonatomic,copy) NSString *bgPicPath;

@property (nonatomic,copy) NSString *gravatar;

@property (nonatomic,strong) NSNumber *memberLevel;

@property (nonatomic,strong) NSArray *coverPicArr;

@property (nonatomic,copy) NSString *signature;

@property (nonatomic,copy) NSString *publishTimeStr;

@property (nonatomic,strong) NSNumber *likeNum;

@property (nonatomic,strong) NSNumber *commentCount;

@property (nonatomic,strong) ProjectInfoObj *linkProjectInfo;

@property (nonatomic,strong) NSNumber *RecommObjId;

@property (nonatomic,strong) NSNumber *hadProjectInfoStatus;

@property (nonatomic,strong) NSNumber *isUserLike;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,copy) NSString *objCoverPic;

@property (nonatomic,copy) NSString *timelineProjectTitle;

@property (nonatomic,strong) NSNumber *objType;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,strong) NSNumber *hitNum;

@property (nonatomic,strong) NSNumber *commentNum;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) ThemeObj *themeInfo;

@property (nonatomic,strong) NSNumber *themeTimeLineCount;

@end
