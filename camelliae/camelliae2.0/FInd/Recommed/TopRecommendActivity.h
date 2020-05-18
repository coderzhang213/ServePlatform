//
//  TopRecommendActivity.h
//  camelliae2.0
//
//  Created by 张越 on 2016/12/20.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseResultObj;

@interface TopRecommendActivity : UIView

- (instancetype)initWith:(BaseResultObj *)obj;

@property (nonatomic,assign) CGFloat currentHeight;

@end
