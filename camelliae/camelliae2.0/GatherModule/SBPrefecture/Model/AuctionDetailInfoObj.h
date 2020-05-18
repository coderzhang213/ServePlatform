//
//  AuctionDetailInfoObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/5/9.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface AuctionDetailInfoObj : BaseResultObj

@property (nonatomic,strong) NSNumber *authorId;

@property (nonatomic,copy) NSString *briefIntro;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,copy) NSString *coverPicThumb;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *hitNum;

@property (nonatomic,copy) NSString *objCoverPic;

@property (nonatomic,strong) NSNumber *parent_zone_module_id;

@property (nonatomic,strong) NSNumber *publishDate;

@property (nonatomic,copy) NSString *publishTimeStr;

@property (nonatomic,strong) NSNumber *rootTypeId;

@property (nonatomic,copy) NSString *rootTypeName;

@property (nonatomic,copy) NSString *shareLink;

@property (nonatomic,strong) NSNumber *shareNum;

@property (nonatomic,strong) NSNumber *subTypeId;

@property (nonatomic,copy) NSString *subTypeName;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSNumber *totalAmount;

@property (nonatomic,copy) NSString *coverPicThumbNew;

@property (nonatomic,strong) PackageInfoObj *packageInfo;

@property (nonatomic,copy) NSString *totalAmountStr;

@end
