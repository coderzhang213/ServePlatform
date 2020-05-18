//
//  CMLCommodityPayMessageVC.h
//  camelliae2.0
//
//  Created by 张越 on 2017/5/17.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLBaseVC.h"
#import "BaseResultObj.h"
#import "MoreMesObj.h"

@interface CMLCommodityPayMessageVC : CMLBaseVC

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) NSNumber *packageID;

@property (nonatomic,strong) NSNumber *parentType;

@property (nonatomic,assign) int buyNum;

@property (nonatomic,assign) BOOL isPush;

@end
