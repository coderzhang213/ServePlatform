//
//  CMLWalletCenterViewController.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/9.
//  Copyright © 2019 张越. All rights reserved.
//

#import "CMLBaseVC.h"

@protocol CMLWalletCenterViewControllerDelegate <NSObject>

- (void)walletCenterWithdrawalEnter;

- (void)reloadIncomeTableView;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CMLWalletCenterViewController : CMLBaseVC

@property (nonatomic, weak) id <CMLWalletCenterViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
