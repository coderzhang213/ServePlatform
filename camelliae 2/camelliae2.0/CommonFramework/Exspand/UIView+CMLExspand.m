//
//  UIView+CMLExspand.m
//  camelliae2.0
//
//  Created by 张越 on 2017/10/18.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "UIView+CMLExspand.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>


@implementation UIView (CMLExspand)

- (float)boundsWidth{
    return self.bounds.size.width;
}

- (float)boundsHeight{
    return self.bounds.size.width;
}

- (void)setBoundsWidth:(float)w{
    CGRect frame = self.bounds;
    frame.size.width = w;
    self.bounds = frame;
}

- (void)setBoundsHeight:(float)h{
    CGRect frame = self.bounds;
    frame.size.height = h;
    self.bounds = frame;
}

- (float)x{
    return self.frame.origin.x;
}

- (float)y{
    return self.frame.origin.y;
}

- (float)width{
    return self.frame.size.width;
}

- (float)height{
    return self.frame.size.height;
}

- (void)setX:(float)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(float)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setWidth:(float)w{
    CGRect frame = self.frame;
    frame.size.width = w;
    self.frame = frame;
}

- (void)setHeight:(float)h{
    CGRect frame = self.frame;
    frame.size.height = h;
    self.frame = frame;
}


@end
