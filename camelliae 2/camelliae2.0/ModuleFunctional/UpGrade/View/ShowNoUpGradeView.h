//
//  ShowNoUpGradeView.h
//  camelliae2.0
//
//  Created by 张越 on 2016/12/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowNoUpGradeViewDelegate <NSObject>

- (void) dissmissCurrentUpGradeView;

@end

@interface ShowNoUpGradeView : UIView

- (instancetype)initWithTag:(int) tag andBgView:(UIView *) view;

@property (nonatomic,weak) id<ShowNoUpGradeViewDelegate> delegate;

@end
