//
//  CMLIndicatorView.h
//  camelliae2.0
//
//  Created by 张越 on 16/6/7.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLIndicatorView : UIView
/**
 设置颜色
 */
@property (readwrite, nonatomic) UIColor *bounceColor;
/**
 设置半径
 */
@property (readwrite, nonatomic) CGFloat radius;
/**
 设置动画延迟
 */
@property (readwrite, nonatomic) CGFloat delay;
/**
 设置动画持续时间
 */
@property (readwrite, nonatomic) CGFloat duration;

- (void)startAnimating;

- (void)stopAnimating;
@end
