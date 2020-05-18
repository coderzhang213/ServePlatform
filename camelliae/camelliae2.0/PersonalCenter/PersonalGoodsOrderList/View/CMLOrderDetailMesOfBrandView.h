//
//  CMLOrderDetailMesOfBrandView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/12.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMLOrderListObj;

@interface CMLOrderDetailMesOfBrandView : UIView

- (instancetype)initWith:(CMLOrderListObj *) obj;

- (instancetype)initWith:(CMLOrderListObj *) obj andDeducMoney:(NSNumber *) money;

@property (nonatomic,assign) BOOL isHasExpress;

@property (nonatomic,assign) CGFloat curentHeight;

@end
