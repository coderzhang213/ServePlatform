//
//  CMLOrderListObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/11.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@class CMLMainOrderObj;

@class CMLOrderTransitObj;

@interface CMLOrderListObj : BaseResultObj

@property (nonatomic,strong) CMLOrderTransitObj *goodsOrderInfo;

@property (nonatomic,strong) CMLOrderTransitObj *projectOrderInfo;

@property (nonatomic,strong) CMLMainOrderObj *orderInfo;


@end
