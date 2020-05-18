//
//  CMLLabel.h
//  camelliae2.0
//
//  Created by 张越 on 2017/10/18.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLLabel : UIView

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic) NSInteger lineSpace;
@property (nonatomic) NSTextAlignment textAlignment;

- (void)debugDraw;
- (void)clear;
- (BOOL)touchPoint:(CGPoint)point;

@end
