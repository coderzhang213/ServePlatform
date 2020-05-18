//
//  PopTransition.m
//  camelliae1.0.1
//
//  Created by 张越 on 16/5/2.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "PopTransition.h"

@interface PopTransition ()<CAAnimationDelegate>

@end

@implementation PopTransition
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    //返回动画的执行时间
    return 0.5f;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //不添加的话，屏幕什么都没有
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    
    
    CATransition *transition = [CATransition animation];
    transition.duration =0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"cube";
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    
    [fromVC.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
}
@end
