//
//  CMLServeOrderObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/11.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@class CMLCommenOrderObj;

@interface CMLServeOrderObj : BaseResultObj

@property (nonatomic,strong) CMLCommenOrderObj *orderInfo;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *coverPicThumb;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *isDeleted;

@property (nonatomic,strong) NSNumber *is_video_project;

@property (nonatomic,strong) NSNumber *isUserPublish;


@end
