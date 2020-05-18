//
//  CMLChooseCouponsTableView.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/8/9.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLBaseTableView.h"
@class CMLMyCouponsModel;

@protocol CMLChooseCouponsTableViewDelegate <NSObject>

@optional
- (void)backCarCouponsSelectObj:(NSArray *_Nullable)chooseCoupons wihtRow:(NSInteger)row withIsSelect:(BOOL)isSelect;//

- (void)backCarCouponsPriceWith:(int)dataCount with:(BaseResultObj *_Nullable)carCouponsObj;//

- (void)backCarCouponsWithDataArray:(NSArray *_Nullable)dataArray WithDict:(NSMutableDictionary *_Nullable)dict;

@end
NS_ASSUME_NONNULL_BEGIN

@interface CMLChooseCouponsTableView : CMLBaseTableView

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, weak) id <CMLChooseCouponsTableViewDelegate> chooseTableDelegate;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style carId:(NSString *)carIdArr priceArr:(NSString *)priceArr chooseCouponsIdArray:(NSArray *)chooseCouponsIdArray;

- (void)refreshWith:(NSInteger)row with:(BOOL)isSelect;

@end

NS_ASSUME_NONNULL_END
