//
//  TopRecommendTopic.h
//  camelliae2.0
//
//  Created by 张越 on 2016/12/21.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseResultObj;

@interface TopRecommendTopic : UIView

- (instancetype)initWith:(BaseResultObj *)obj;

@property (nonatomic,assign) CGFloat currentHeight;

@end
