//
//  CMLIncomeTableView.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/18.
//  Copyright © 2019 张越. All rights reserved.
//

#import "CMLBaseTableView.h"

@protocol CMLIncomeTableViewDelegate <NSObject>

- (void)refreshEarningsRecordViewWithIncomeTableViewWith:(NSString *_Nullable)income withGetCash:(NSString *_Nullable)getCash;

- (void)setWhiteNavBar;

- (void)setBlackNavBar;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CMLIncomeTableView : CMLBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withTimeString:(NSString *)timeString;

@property (nonatomic, weak) id <CMLIncomeTableViewDelegate> incomeDelegate;

@end

NS_ASSUME_NONNULL_END
