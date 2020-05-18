//
//  MoreMesView.h
//  camelliae2.0
//
//  Created by 张越 on 16/7/7.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreMesView : UIView

@property (nonatomic,assign) BOOL isInfo;

@property (nonatomic,strong) NSArray *List;

@property (nonatomic,strong) NSNumber *currentClass;

@property (nonatomic,assign) CGFloat currentHeight;

- (void) createViews;

@end
