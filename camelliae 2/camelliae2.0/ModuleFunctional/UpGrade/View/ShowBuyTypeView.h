//
//  ShowBuyTypeView.h
//  camelliae2.0
//
//  Created by 张越 on 2016/12/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowBuyTypeDelegate <NSObject>

- (void) selectBuyType:(int) tag;

- (void) cancelPay;

@end

@interface ShowBuyTypeView : UIView

- (instancetype)initWithBgView:(UIView *) bgView;

@property (nonatomic,weak) id<ShowBuyTypeDelegate>delegate;

@end
