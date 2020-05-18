//
//  BrandShowView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/8.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandShowView : UIView

- (instancetype)initWithSource:(NSArray *) sourceArray andSelectArray:(NSArray *) selectArray withBaseObj:(BaseResultObj *)baseObj;

@property (nonatomic,assign) CGFloat currentheight;

@property (nonatomic,assign) int tempTotalMoney;

- (void) refreshPoints:(NSNumber *) point;

- (void) refreshOldPoints;

@end
