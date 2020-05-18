//
//  CommentObj.h
//  camelliae2.0
//
//  Created by 张越 on 16/6/8.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface CommentObj : BaseResultObj

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *objId;

@property (nonatomic,strong) NSNumber *objType;

@property (nonatomic,strong) NSNumber *userId;

@property (nonatomic,copy) NSString *userNickName;

@property (nonatomic,copy) NSString *userHeadImg;

@property (nonatomic,strong) NSNumber *postTime;

@property (nonatomic,copy) NSString *postTimeStr;

@property (nonatomic,copy) NSString *comment;

@property (nonatomic,strong) NSNumber *isUserLike;

@property (nonatomic,strong) NSNumber *likeNum;
@end
