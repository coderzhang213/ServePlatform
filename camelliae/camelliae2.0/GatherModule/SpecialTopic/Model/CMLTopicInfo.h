//
//  CMLTopicInfo.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/6/12.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "BaseResultObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMLTopicInfo : BaseResultObj

@property (nonatomic, strong) NSNumber *currentID;

@property (nonatomic, copy) NSString *coverPic;

@property (nonatomic, strong) NSNumber *pass_due;

@property (nonatomic, copy) NSString *shortTitle;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSNumber *sortNum;

@property (nonatomic, strong) NSNumber *countRecord;

@property (nonatomic, copy) NSString *countRecordStr;

@property (nonatomic, copy) NSString *publishTime;

@property (nonatomic, copy) NSString *viewLink;

@property (nonatomic, copy) NSString *updateTime;

@end

NS_ASSUME_NONNULL_END
