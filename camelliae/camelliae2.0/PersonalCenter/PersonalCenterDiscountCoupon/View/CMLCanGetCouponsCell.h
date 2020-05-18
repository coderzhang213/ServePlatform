//
//  CMLCanGetCouponsCell.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/7/30.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMLMyCouponsModel;

@protocol CMLCanGetCouponsCellDelegate <NSObject>

- (void)getCouponsClickedOfCanGetCouponsCell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CMLCanGetCouponsCell : UITableViewCell

/*可领取优惠券*/
- (void)refreshCanGetCurrentCell:(CMLMyCouponsModel *)model withIsUse:(NSNumber *_Nullable)isUse withProcess:(NSNumber *_Nullable)process;

@property (nonatomic, assign) CGFloat currentHeight;

@property (nonatomic, assign) BOOL isGet;

@property (nonatomic, weak) id <CMLCanGetCouponsCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
