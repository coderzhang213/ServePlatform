//
//  VIPNoteObj.h
//  camelliae2.0
//
//  Created by 张越 on 16/6/13.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@class VIPVideoObj;

@interface VIPNoteObj : BaseResultObj

@property (nonatomic,strong) NSNumber *userId;

@property (nonatomic,strong) NSNumber *recodeId;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,strong) NSArray *coverPicArr;

@property (nonatomic,strong) NSNumber *likeNum;

@property (nonatomic,strong) NSNumber *publishTimeStamp;

@property (nonatomic,copy) NSString *publishTimeStr;

@property (nonatomic,strong) NSNumber *year;

@property (nonatomic,strong) NSNumber *recordId;

@property (nonatomic,strong) VIPVideoObj *videoObj;

@end
