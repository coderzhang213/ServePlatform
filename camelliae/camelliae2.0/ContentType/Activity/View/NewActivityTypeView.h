//
//  NewActivityTypeView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/7/28.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseResultObj;

@protocol NewSelectViewDelegate <NSObject>

- (void) selectedActivityType:(int) index;


- (void) cancelSelectActivity;



@end


@interface NewActivityTypeView : UIView

@property (nonatomic,weak) id<NewSelectViewDelegate> delegate;

- (instancetype)initWithObj:(BaseResultObj *) obj;


@end
