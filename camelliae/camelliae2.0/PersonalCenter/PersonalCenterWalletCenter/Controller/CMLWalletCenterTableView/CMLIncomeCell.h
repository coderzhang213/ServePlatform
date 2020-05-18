//
//  CMLIncomeCell.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/18.
//  Copyright © 2019 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CMLWalletCenterModel;
NS_ASSUME_NONNULL_BEGIN

@interface CMLIncomeCell : UITableViewCell

- (void)refreshCurrentCell:(CMLWalletCenterModel *)obj;

- (void)refreshRebateCurrentCell:(CMLWalletCenterModel *)obj;

@end

NS_ASSUME_NONNULL_END
