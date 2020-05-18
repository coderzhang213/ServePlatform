//
//  CMLImageListObj.h
//  camelliae2.0
//
//  Created by 张越 on 16/6/12.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface CMLImageListObj : BaseResultObj
@property (nonatomic,strong) NSNumber *albumId;

@property (nonatomic,strong) NSNumber *rootTypeId;

@property (nonatomic,copy) NSString *rootTypeName;

@property (nonatomic,strong) NSNumber *parentTypeId;

@property (nonatomic,copy) NSString *parentTypeName;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *shortTitle;

@property (nonatomic,copy) NSString *briefIntro;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,strong) NSNumber *hitNum;

@property (nonatomic,strong) NSNumber *likeNum;

@property (nonatomic,strong) NSNumber *favNum;

@property (nonatomic,strong) NSNumber *shareNum;

@property (nonatomic,strong) NSNumber *downloadNum;

@property (nonatomic,strong) NSNumber *publishDate;

@property (nonatomic,strong) NSNumber *isUserFav;

@property (nonatomic,strong) NSNumber *isUserLike;

@property (nonatomic,copy) NSString *coverPicThumb;

@property (nonatomic,copy) NSString *detailCoverPic;

@property (nonatomic,strong) NSNumber *detailPicCount;

@property (nonatomic,copy) NSString *detailCoverPicThumb;

@property (nonatomic,strong) NSNumber *isEncrypt;

@property (nonatomic,strong) NSNumber *encryptNum;

@end
