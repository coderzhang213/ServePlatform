//
//  ShoppingCarFooterView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/8.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShoppingCarFooterViewDelegate<NSObject>

- (void) selectAll;

- (void) cancelAll;

- (void) buyAllBrand;

@end

@interface ShoppingCarFooterView : UIView

@property (nonatomic,weak) id<ShoppingCarFooterViewDelegate> delegate;

- (void) refreshCurrentWithTotalMoney:(int) totalMoney;

- (void) changeAllSelectStatus;

@end
