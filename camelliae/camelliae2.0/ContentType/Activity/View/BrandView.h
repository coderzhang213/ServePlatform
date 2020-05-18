//
//  BrandView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/7/26.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseResultObj;

@interface BrandView : UIView

- (instancetype)initWithObj:(BaseResultObj *) obj;

@property (nonatomic,assign) CGFloat currentheight;

@end
