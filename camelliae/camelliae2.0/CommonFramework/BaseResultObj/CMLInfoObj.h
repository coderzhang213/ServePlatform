//
//  CMLInfoObj.h
//  camelliae2.0
//
//  Created by 张越 on 16/6/6.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface CMLInfoObj : BaseResultObj

@property (nonatomic,copy) NSString *objCoverPic;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *typeId;

@property (nonatomic,copy) NSString *typeName;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *briefIntro;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,strong) NSNumber *hitNum;

@property (nonatomic,strong) NSNumber *favNum;

@property (nonatomic,strong) NSNumber *shareNum;

@property (nonatomic,strong) NSNumber *likeNum;

@property (nonatomic,strong) NSNumber *publishDate;

@property (nonatomic,strong) NSNumber *isUserFav;

@property (nonatomic,strong) NSNumber *isUserLike;

@property (nonatomic,strong) NSNumber *rootTypeId;

@property (nonatomic,strong) NSNumber *isDeleted;

@property (nonatomic,copy) NSString *rootTypeName;

@property (nonatomic,copy) NSString *subTypeName;

@property (nonatomic,copy) NSString *coverPicThumb;

@end
