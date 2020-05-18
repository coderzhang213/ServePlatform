//
//  UIView+CMLExspand.h
//  camelliae2.0
//
//  Created by 张越 on 2017/10/18.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^touchBlock)(UITouch *t, UIView *target);

@interface UIView (CMLExspand)

- (float)x;
- (float)y;
- (float)width;
- (float)height;

- (void)setX:(float)x;
- (void)setY:(float)y;
- (void)setWidth:(float)w;
- (void)setHeight:(float)h;

- (float)boundsWidth;
- (float)boundsHeight;
- (void)setBoundsWidth:(float)w;
- (void)setBoundsHeight:(float)h;

@end
