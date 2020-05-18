//
//  CMLActivityTicketPriceVC.h
//  camelliae2.0
//
//  Created by 张越 on 2018/11/8.
//  Copyright © 2018 张越. All rights reserved.
//

#import "CMLBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ActivityTicketPriceDelegate <NSObject>

- (void) outputTicketType:(NSString *) str number:(int) num price:(int) price;

@end



@interface CMLActivityTicketPriceVC : CMLBaseVC

@property (nonatomic, strong) NSNumber *costPrice;

@property (nonatomic, strong) NSNumber *costNumber;

@property (nonatomic,weak) id<ActivityTicketPriceDelegate> activityTicketPriceDelegate;

@end

NS_ASSUME_NONNULL_END
