//
//  CMLRecommendCommonModuleObj.h
//  camelliae2.0
//
//  Created by 张越 on 2016/11/6.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"
#import "CMLModuleObj.h"
#import "CMLBannerDetailObj.h"
#import "CMLModuleMsgTipsObj.h"


@interface CMLRecommendCommonModuleObj : BaseResultObj

@property (nonatomic,strong) NSNumber *dataCount;

@property (nonatomic,strong) NSArray *dataList;

@property (nonatomic,copy) NSString *message;

@property (nonatomic,copy) NSString *dataTitle;

@property (nonatomic,strong) CMLModuleMsgTipsObj *dataInfo;

@property (nonatomic,strong) NSNumber *objId;

@property (nonatomic,copy) NSString *objTitle;

@property (nonatomic,strong) CMLModuleObj *bannerInfo;

@property (nonatomic,strong) CMLBannerDetailObj *bannerDetail;

@property (nonatomic,copy) NSString *viewLink;

@end
