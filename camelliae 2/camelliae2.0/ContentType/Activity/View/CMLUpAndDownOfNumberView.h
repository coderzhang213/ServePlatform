//
//  CMLUpAndDownOfNumberView.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/5/9.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMLUpAndDownOfNumberViewDelegate <NSObject>

- (void)confirmNumber:(int)number;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CMLUpAndDownOfNumberView : UIView

- (instancetype)initWithFrame:(CGRect)frame withObj:(BaseResultObj *)obj withType:(NSNumber *)type;

@property (nonatomic, weak) id <CMLUpAndDownOfNumberViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
