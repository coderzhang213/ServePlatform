//
//  TImeLineCommentObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/9/27.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface TImeLineCommentObj : BaseResultObj

@property (nonatomic,strong) NSNumber *authorId;

@property (nonatomic,copy) NSString *comment;

@property (nonatomic,copy) NSString *userHeadImg;

@property (nonatomic,copy) NSString *postTimeStr;

@property (nonatomic,strong) NSNumber *likeNum;

@property (nonatomic,strong) NSNumber *isUserLike;

@property (nonatomic,copy) NSString *userNickName;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *userId;

@property (nonatomic,copy) NSString *nickName;


@end
