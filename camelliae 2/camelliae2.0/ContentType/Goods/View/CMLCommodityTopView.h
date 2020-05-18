//
//  CMLCommodityTopView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/4.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseResultObj;

@protocol CMLCommodityTopViewDelegate <NSObject>

- (void)showCanGetCouponViewOfCommodityTopViewWith:(BaseResultObj *)obj;

@end

@interface CMLCommodityTopView : UIView

- (instancetype)initWith:(BaseResultObj *)obj;

@property (nonatomic,assign) CGFloat currentHeight;

@property (nonatomic, weak) id <CMLCommodityTopViewDelegate> delegate;

@end
