//
//  ShoppingCarOrderVC.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/8.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLBaseVC.h"
#import "BaseResultObj.h"
#import "MoreMesObj.h"

@protocol ShoppingCarOrderVCDelegate <NSObject>

- (void)backToShoppingCar;

@end

@interface ShoppingCarOrderVC : CMLBaseVC

@property (nonatomic,strong) NSArray *sourceArray;

@property (nonatomic,strong) NSArray *selectArray;

@property (nonatomic, strong) BaseResultObj *carOrderBaseObj;

@property (nonatomic, weak) id <ShoppingCarOrderVCDelegate> oderDelegate;

@end
