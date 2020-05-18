//
//  CMLScrollSelectView.h
//  camelliae2.0
//
//  Created by 张越 on 2018/9/12.
//  Copyright © 2018年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseResultObj;

@protocol CMLScrollSelectViewDelegate<NSObject>

- (void) scrollTag:(int) currentTag;

@end

@interface CMLScrollSelectView : UIView

- (instancetype)initWith:(BaseResultObj *) obj;

@property (nonatomic,weak) id<CMLScrollSelectViewDelegate> delegate;

@property (nonatomic,assign) BOOL isTouch;

@property (nonatomic,assign) CGFloat currentHeight;

- (void) refreshScrollSelectViewWith:(int) tag;

@end
