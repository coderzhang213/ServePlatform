//
//  CustomTransition1.h
//  transitionOfViewController
//
//  Created by 张越 on 16/8/29.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,DefaultTransitionType) {

    PushDefaultTransition = 0,
    PopDefaultTransition,

};

@interface DefaultTransition : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype) transitionWith:(DefaultTransitionType)customTransitionType;

- (instancetype) initTransitionWith:(DefaultTransitionType) customTransitionType;

@end
