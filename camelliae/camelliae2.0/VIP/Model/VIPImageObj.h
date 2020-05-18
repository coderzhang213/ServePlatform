//
//  VIPImageObj.h
//  camelliae2.0
//
//  Created by 张越 on 16/6/14.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface VIPImageObj : BaseResultObj

@property (nonatomic,strong) NSNumber *picId;

@property (nonatomic,strong) NSNumber *parentUserId;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *briefIntro;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,copy) NSString *originPicPath;

@property (nonatomic,strong) NSNumber *hitNum;

@property (nonatomic,strong) NSNumber *likeNum;

@property (nonatomic,strong) NSNumber *publishDate;

@property (nonatomic,strong) NSNumber *isUserFav;

@property (nonatomic,strong) NSNumber *isUserLike;

@property (nonatomic,copy) NSString *coverPicThumb;

@end
