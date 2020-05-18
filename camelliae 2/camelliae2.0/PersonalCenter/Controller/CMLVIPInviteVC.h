//
//  CMLVIPInviteVC.h
//  camelliae2.0
//
//  Created by 张越 on 2018/11/22.
//  Copyright © 2018 张越. All rights reserved.
//

#import "CMLBaseVC.h"

@protocol CMLVIPInviteVCDelegate <NSObject>

- (void) shareVIPInvite;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CMLVIPInviteVC : CMLBaseVC

@end

NS_ASSUME_NONNULL_END
