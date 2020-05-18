//
//  CMLImagleObj.h
//  camelliae2.0
//
//  Created by 张越 on 16/6/12.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"
#import "CMLPicObjInfo.h"

@interface CMLImagleDetailObj : BaseResultObj

@property (nonatomic,strong) NSNumber *picId;

@property (nonatomic,strong) NSNumber *parentAlbumId;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *briefIntro;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,copy) NSString *originPicPath;

@property (nonatomic,strong) NSNumber *hitNum;

@property (nonatomic,strong) NSNumber *favNum;

@property (nonatomic,strong) NSNumber *shareNum;

@property (nonatomic,strong) NSNumber *downloadNum;

@property (nonatomic,strong) NSNumber *publishDate;

@property (nonatomic,strong) NSNumber *isUserFav;

@property (nonatomic,strong) NSNumber *isUserLike;

@property (nonatomic,copy) NSString *coverPicThumb;

@property (nonatomic,strong) CMLPicObjInfo *picObjInfo;

@end
