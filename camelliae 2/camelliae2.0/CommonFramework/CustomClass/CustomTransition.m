//
//  CustomTransition1.m
//  transitionOfViewController
//
//  Created by 张越 on 16/8/29.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CustomTransition.h"

@interface CustomTransition ()

@property (nonatomic,assign) NewCustomTransitionType currentTransitionType;

@end

@implementation CustomTransition

- (instancetype)initTransitionWith:(NewCustomTransitionType)customTransitionType{

    self = [super init];
    if (self) {
        _currentTransitionType = customTransitionType;
    }
    return self;
}

+ (instancetype)transitionWith:(NewCustomTransitionType)customTransitionType{

    return [[self alloc] initTransitionWith:customTransitionType];
}


- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{

    return 0.3f;

}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{

    switch (_currentTransitionType) {
            
        case PushCustomTransition:
            [self pushAnimationTransition:transitionContext];
            break;
        case PopCustomTransition:
            [self popAnimationTransition:transitionContext];
            break;
            
        default:
            break;
    }
    

}

- (void) pushAnimationTransition:(id <UIViewControllerContextTransitioning>)transitionContext{

    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    toVC.view.frame = CGRectMake(0,
                                 0,
                                 containerView.frame.size.width,
                                 containerView.frame.size.height);
    toVC.view.alpha = 0;

    [UIView animateWithDuration:0.5 animations:^{
        
        toVC.view.alpha = 1;
        
    } completion:^(BOOL finished) {
    
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];

}


- (void) popAnimationTransition:(id <UIViewControllerContextTransitioning>)transitionContext{

    
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
 
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
//    fromVC.view.frame = CGRectMake(0,
//                                   0,
//                                   containerView.frame.size.width,
//                                   containerView.frame.size.height);
    
    [UIView animateWithDuration:0.4 animations:^{
    
        fromVC.view.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
    
    
    
}

@end
