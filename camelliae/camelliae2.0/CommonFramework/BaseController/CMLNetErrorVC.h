//
//  CMLNetErrorVC.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/6/25.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMLNetErrorVC : CMLBaseVC
//没有网络的提示
- (void)showNetErrorTipOfNormalVC;
- (void)hideNetErrorTipOfNormalVC;

@end

NS_ASSUME_NONNULL_END
