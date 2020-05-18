//
//  CustomTransition1.m
//  transitionOfViewController
//
//  Created by 张越 on 16/8/29.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "DefaultTransition.h"

@interface DefaultTransition ()

@property (nonatomic,assign) DefaultTransitionType currentTransitionType;

@end

@implementation DefaultTransition

- (instancetype)initTransitionWith:(DefaultTransitionType)customTransitionType{

    self = [super init];
    if (self) {
        _currentTransitionType = customTransitionType;
    }
    return self;
}

+ (instancetype)transitionWith:(DefaultTransitionType)customTransitionType{

    return [[self alloc] initTransitionWith:customTransitionType];
}


- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{

    return 0.5f;

}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{

    switch (_currentTransitionType) {
            
        case PushDefaultTransition:
            [self pushAnimationTransition:transitionContext];
            break;
        case PopDefaultTransition:
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
    toVC.view.frame = CGRectMake(- containerView.frame.size.height,
                                 0,
                                 containerView.frame.size.width,
                                 containerView.frame.size.height);
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionLayoutSubviews animations:^{
        toVC.view.frame = CGRectMake(0,
                                     0,
                                     containerView.frame.size.width,
                                     containerView.frame.size.height);
        
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
    fromVC.view.frame = CGRectMake(0,
                                   0,
                                   containerView.frame.size.width,
                                   containerView.frame.size.height);
    [UIView animateWithDuration:0.8
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionLayoutSubviews animations:^{
                            fromVC.view.frame = CGRectMake(containerView.frame.size.height,
                                                           0,
                                                           containerView.frame.size.width,
                                                           containerView.frame.size.height);
                            
                        } completion:^(BOOL finished) {
                            
                            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                        }];

    
    
}

@end
