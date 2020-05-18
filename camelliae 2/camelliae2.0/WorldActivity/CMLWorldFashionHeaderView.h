//
//  CMLWorldFashionHeaderView.h
//  camelliae2.0
//
//  Created by 张越 on 2018/9/20.
//  Copyright © 2018年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseResultObj;

@interface CMLWorldFashionHeaderView : UIView

- (instancetype)initWithObj:(BaseResultObj *) obj;

@property (nonatomic,strong) NSArray *topScrollNarray;

@property (nonatomic,strong) NSArray *todayFocusNarray;

- (void) refreshCurrentView;



@end
