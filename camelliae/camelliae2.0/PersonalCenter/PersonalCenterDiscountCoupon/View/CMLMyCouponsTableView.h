//
//  CMLMyCouponsTableView.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/7/17.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLBaseTableView.h"
@class CMLMyCouponsModel;

typedef enum CouponsTableType {
    MyCouponsTableType = 0,
    CanUseCouponsTableType,
    CanGetCouponsTableType,
    CarCanUseCouponsTableType
} CouponsTableType;

@protocol CMLMyCouponsTableViewDelegate <NSObject>

@optional
- (void)backCouponsSelectObj:(CMLMyCouponsModel *_Nullable)chooseCouponsModel wihtRow:(NSInteger)row withIsSelect:(BOOL)isSelect;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CMLMyCouponsTableView : CMLBaseTableView

@property (nonatomic, weak) id <CMLMyCouponsTableViewDelegate> couponsTableDelegate;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, assign) BOOL isSelect;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withIsUse:(NSNumber * _Nullable)isUse withProcess:(NSNumber * _Nullable)process withObj:(BaseResultObj * _Nullable)obj withCouponsType:(CouponsTableType)type withPrice:(NSNumber * _Nullable)price;

- (void)refreshWith:(NSInteger)row with:(BOOL)isSelect;

@end

NS_ASSUME_NONNULL_END
