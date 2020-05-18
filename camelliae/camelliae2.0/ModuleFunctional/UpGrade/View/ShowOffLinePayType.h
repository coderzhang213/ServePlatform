//
//  ShowOffLinePayType.h
//  camelliae2.0
//
//  Created by 张越 on 2016/12/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowOffLinePayTypeDelegate  <NSObject>

- (void) cancelCallUser;

- (void) callUser;

@end

@interface ShowOffLinePayType : UIView

- (instancetype)initWithTag:(int) tag andBgView:(UIView *) bgView andTele:(NSString *)tele;

@property (nonatomic,weak) id<ShowOffLinePayTypeDelegate> delegate;

@end
