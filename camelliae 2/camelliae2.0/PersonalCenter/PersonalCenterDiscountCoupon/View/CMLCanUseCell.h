//
//  CMLCanUseCell.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/8/1.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CMLMyCouponsModel;

@protocol CMLCanUseCellDelegate <NSObject>

- (void)useContentButtonClickedOfCouponsCellWith:(CGFloat)height;

- (void)backChooseButtonRow:(NSInteger)row withCurrentSelect:(BOOL)isSelect;

- (void)changeChooseStatus:(BOOL)isSelect currentCouponsId:(NSString *_Nullable)couponsId;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CMLCanUseCell : UITableViewCell

@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, assign) CGFloat currentHeight;

@property (nonatomic, strong) UIButton *chooseButton;

@property (nonatomic, weak) id <CMLCanUseCellDelegate> delegate;

- (void)refreshCanUseCurrentCell:(CMLMyCouponsModel *)model withIsUse:(int)isUse withProcess:(int)process withRow:(NSInteger)row;

- (void)refreshCanUseCurrentCell:(CMLMyCouponsModel *)model withChooseCouponsIdArray:(NSArray *)chooseCouponsIdArray withRow:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
