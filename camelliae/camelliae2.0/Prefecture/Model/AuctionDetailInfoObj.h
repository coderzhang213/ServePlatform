//
//  AuctionDetailInfoObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/5/9.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@class PackageInfoObj;

@interface AuctionDetailInfoObj : BaseResultObj

@property (nonatomic,strong) NSNumber *authorId;

@property (nonatomic,copy) NSString *briefIntro;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,copy) NSString *coverPicThumb;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,copy) NSString *hitNum;

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

@property (nonatomic,strong) NSNumber *totalAmount;/*无数据*/

@property (nonatomic,copy) NSString *coverPicThumbNew;/*无此字段*/

@property (nonatomic, strong) NSNumber *totalAmountMin;

@property (nonatomic, strong) NSNumber *totalAmountMax;

@property (nonatomic, strong) PackageInfoObj *packageInfo;

@end
