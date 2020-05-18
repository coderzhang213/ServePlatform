//
//  CMLIntegrationGiftObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/8/22.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface CMLIntegrationGiftObj : BaseResultObj

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *authorId;

@property (nonatomic,copy) NSString *coverPicThumb;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,strong) NSNumber *giftNum;

@property (nonatomic,strong) NSNumber *memberLevel;

@property (nonatomic,strong) NSNumber *numFav;

@property (nonatomic,strong) NSNumber *numHit;

@property (nonatomic,strong) NSNumber *numLike;

@property (nonatomic,strong) NSNumber *numShare;

@property (nonatomic,copy) NSString *objCoverPic;

@property (nonatomic,strong) NSNumber *point;

@property (nonatomic,copy) NSString *publicTime;

@property (nonatomic,copy) NSString *shortTitle;

@property (nonatomic,strong) NSNumber *sortNum;

@property (nonatomic,strong) NSNumber *status;

@property (nonatomic,strong) NSNumber *surplusStock;

@property (nonatomic,copy) NSString *sysApplyStatusName;

@property (nonatomic,strong) NSNumber *sysApplyStatus;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSNumber *userBuyStatus;

@property (nonatomic,strong) NSNumber *marketPrice;

@property (nonatomic,copy) NSString *marketPriceStr;

@end
