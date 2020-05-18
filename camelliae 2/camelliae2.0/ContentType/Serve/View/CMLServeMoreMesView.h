//
//  CMLServeMoreMesView.h
//  camelliae2.0
//
//  Created by 张越 on 2018/4/16.
//  Copyright © 2018年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLServeMoreMesView : UIView

@property (nonatomic,assign) BOOL isInfo;

@property (nonatomic,strong) NSArray *List;

@property (nonatomic,strong) NSNumber *currentClass;

@property (nonatomic,assign) CGFloat currentHeight;

- (void) createViews;

@end
