//
//  CMLPersonContentScrollView.m
//  camelliae2.0
//
//  Created by 孙志泽 on 2019/10/25.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLPersonContentScrollView.h"

@interface CMLPersonContentScrollView () <UIGestureRecognizerDelegate>

@end

@implementation CMLPersonContentScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
