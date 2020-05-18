//
//  CMLGoodsAfterSalesVC.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/13.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLBaseVC.h"

@class CMLGoodsOrderObj;

@class CMLServeOrderObj;

@interface CMLGoodsAfterSalesVC : CMLBaseVC

- (instancetype)initWith:(NSString *)str;

@property (nonatomic,strong) NSNumber *brandType;

@property (nonatomic,strong) CMLGoodsOrderObj *goodsOrderObj;

@property (nonatomic,strong) CMLServeOrderObj *serveOrderObj;

@end
