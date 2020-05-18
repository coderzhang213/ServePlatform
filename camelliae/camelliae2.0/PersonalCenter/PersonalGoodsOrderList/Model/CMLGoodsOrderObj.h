//
//  CMLGoodsOrderObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/11.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@class CMLCommenOrderObj;

@interface CMLGoodsOrderObj : BaseResultObj

@property (nonatomic,copy) NSString *coverPicThumb;

@property (nonatomic,strong) CMLCommenOrderObj *orderInfo;

@property (nonatomic,strong) NSNumber *isDeleted;

@property (nonatomic,copy) NSString *brandName;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *deposit_money;

@property (nonatomic,strong) NSNumber *is_deposit;

@property (nonatomic,strong) NSNumber *deposit_total;

@property (nonatomic,strong) NSNumber *isUserPublish;

@end
