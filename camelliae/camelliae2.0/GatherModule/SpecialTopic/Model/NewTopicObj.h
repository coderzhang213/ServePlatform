//
//  NewTopicObj.h
//  camelliae2.0
//
//  Created by 张越 on 2016/11/11.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"
#import "CMLPicObjInfo.h"

@interface NewTopicObj : BaseResultObj

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *objCover;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,strong) NSNumber *countRecord;

@property (nonatomic,strong) CMLPicObjInfo *picObjInfo;

@property (nonatomic,strong) NSNumber *publishTime;

@property (nonatomic,strong) NSNumber *updateTime;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,copy) NSString *viewLink;

@property (nonatomic,copy) NSString *shortTitle;

@property (nonatomic,strong) NSNumber *dataType;

@property (nonatomic,copy) NSString *countRecordStr;

@property (nonatomic,strong) NSNumber *pass_due;

@end
