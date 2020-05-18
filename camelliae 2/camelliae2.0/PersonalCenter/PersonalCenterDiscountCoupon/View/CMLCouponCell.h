//
//  CMLCouponCell.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/7/8.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMLMyCouponsModel;

@protocol CMLCouponCellDelegate <NSObject>

- (void)useContentButtonClickedOfCouponCellWith:(CGFloat)height;

@end
NS_ASSUME_NONNULL_BEGIN

@interface CMLCouponCell : UITableViewCell

- (void)refreshCurrentCell:(CMLMyCouponsModel *)model withIsUse:(int)isUse withProcess:(int)process;

@property (nonatomic, assign) CGFloat currentHeight;

@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, strong) void (^myCouponBlock)(NSInteger tag);

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *higherBgImageView;

@property (nonatomic, strong) UILabel *amoutLabel;

@property (nonatomic, strong) UIImageView *lineView;/*虚线*/

@property (nonatomic, strong) UIImageView *leftLineView;/*虚线*/

@property (nonatomic, strong) UILabel *fullLabel;

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UILabel *periodLabel;/*有效期*/

@property (nonatomic, strong) UILabel *useLabel;

@property (nonatomic, strong) UIImageView *useContentImageView;

@property (nonatomic, strong) UIImageView *usedImageView;/*已使用*/

@property (nonatomic, strong) UIImageView *overdueImageView;/*已过期*/

@property (nonatomic, strong) UILabel *useContentLabel;

@property (nonatomic, weak) id <CMLCouponCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
