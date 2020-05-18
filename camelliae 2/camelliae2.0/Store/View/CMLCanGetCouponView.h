//
//  CMLCanGetCouponView.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/7/23.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMLCanGetCouponViewDelegate <NSObject>

- (void)cancelCanGetCouponView;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CMLCanGetCouponView : UIView

- (instancetype)initWithFrame:(CGRect)frame withObj:(BaseResultObj *)obj;

@property (nonatomic, weak) id <CMLCanGetCouponViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
