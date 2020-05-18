//
//  CMLPublishEditorModel.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/5/20.
//  Copyright © 2019 卡枚连. All rights reserved.
//  /*v3/goods/detail -- */

#import "BaseResultObj.h"

@class PackageInfoObj;

@interface CMLPublishEditorModel : BaseResultObj

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSNumber *rootTypeId;

@property (nonatomic, strong) NSNumber *userId;

@property (nonatomic, strong) NSNumber *objId;

@property (nonatomic, strong) NSNumber *goodsHadBuyNum;

@property (nonatomic, copy) NSNumber *totalAmountMax;

@property (nonatomic, copy) NSNumber *totalAmountMin;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) PackageInfoObj *packageInfoObj;

@end
