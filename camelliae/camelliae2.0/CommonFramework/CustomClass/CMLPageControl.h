//
//  CMLPageControl.h
//  transitionOfViewController
//
//  Created by 张越 on 2016/10/10.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLPageControl : UIView

@property (nonatomic,assign) int pageNum;

@property (nonatomic,strong) UIColor *selectColor;

@property (nonatomic,strong) UIColor *otherColor;

@property (nonatomic,assign) CGFloat pageLineSpace;

@property (nonatomic,assign) CGFloat pageLineWidth;

- (void) initPageControl;

- (void) refreshPageControl:(int) index;


@end
