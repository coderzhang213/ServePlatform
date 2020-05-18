//
//  CMLGoodsVC.h
//  camelliae2.0
//
//  Created by 张越 on 2018/11/10.
//  Copyright © 2018 张越. All rights reserved.
//

#import "CMLBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GoodsPriceDelegate <NSObject>

- (void) outputgoodsPrice:(int) price andNum:(int) num andFreight:(int) price1;

@end

@interface CMLGoodsVC : CMLBaseVC

@property (nonatomic, strong) NSNumber *costPrice;

@property (nonatomic, strong) NSNumber *costNumber;

@property (nonatomic, strong) NSNumber *costFreight;

@property (nonatomic,weak) id<GoodsPriceDelegate> goodsPriceDelegate;

@end

NS_ASSUME_NONNULL_END
