//
//  CMLCarChooseCouponsVC.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/8/9.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLBaseVC.h"
@class CMLMyCouponsModel;
@protocol CMLCarChooseCouponsVCDelegate <NSObject>

- (void)backChooseCarModelOfChooseVC:(NSArray *_Nullable)chooseCoupons withRow:(NSNumber *_Nullable)row withIsSelect:(BOOL)isSelect;
@optional
- (void)backChooseCarCouponsRefreshPrice;

- (void)backChooseCarCouponsWithDataCount:(int)dataCount with:(BaseResultObj *_Nullable)carCouponsObj;

- (void)backCarChooseCouponsWithDataArray:(NSArray *_Nullable)dataArray WithDict:(NSMutableDictionary *_Nullable)dict;

@end
NS_ASSUME_NONNULL_BEGIN

@interface CMLCarChooseCouponsVC : CMLBaseVC

@property (nonatomic, copy) NSString *carIdArr;

@property (nonatomic, copy) NSString *carPriceArr;

@property (nonatomic, strong) NSArray *carIdArray;

@property (nonatomic, strong) NSArray *carPriceArray;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, strong) NSArray *couponsIdArray;

@property (nonatomic, strong) NSMutableDictionary *carSelectDict;

@property (nonatomic, weak) id <CMLCarChooseCouponsVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
