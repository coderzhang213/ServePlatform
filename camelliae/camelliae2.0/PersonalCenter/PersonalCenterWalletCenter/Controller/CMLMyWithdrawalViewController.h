//
//  CMLMyWithdrawalViewController.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/11.
//  Copyright © 2019 张越. All rights reserved.
//

#import "CMLBaseVC.h"

@protocol CMLMyWithdrawalViewControllerDelegate <NSObject>

- (void)refreshWalletCenterViewController;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CMLMyWithdrawalViewController : CMLBaseVC

@property (nonatomic, copy) NSString *earnings;

@property (nonatomic, weak) id <CMLMyWithdrawalViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
