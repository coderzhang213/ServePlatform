//
//  CMLServePriceVC.h
//  camelliae2.0
//
//  Created by 张越 on 2018/11/10.
//  Copyright © 2018 张越. All rights reserved.
//

#import "CMLBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ServePriceDelegate <NSObject>

- (void) outputTicketPrice:(int) price andNum:(int) num;

@end



@interface CMLServePriceVC : CMLBaseVC

@property (nonatomic,weak) id<ServePriceDelegate> servePriceDelegate;

@end

NS_ASSUME_NONNULL_END
