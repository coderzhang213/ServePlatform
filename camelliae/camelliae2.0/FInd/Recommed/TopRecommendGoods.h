//
//  TopRecommendGoods.h
//  camelliae2.0
//
//  Created by 张越 on 2018/9/19.
//  Copyright © 2018年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseResultObj;

@interface TopRecommendGoods : UIView

- (instancetype)initWith:(BaseResultObj *)obj;

@property (nonatomic,assign) CGFloat currentHeight;

@end
