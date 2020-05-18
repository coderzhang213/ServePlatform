//
//  CustomTransition1.h
//  transitionOfViewController
//
//  Created by 张越 on 16/8/29.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,NewCustomTransitionType) {

    PushCustomTransition = 0,
    PopCustomTransition,

};

@interface CustomTransition : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype) transitionWith:(NewCustomTransitionType)customTransitionType;

- (instancetype) initTransitionWith:(NewCustomTransitionType) customTransitionType;

@end
