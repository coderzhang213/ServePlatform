//
//  UILabel+CMLAdaptive.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/7/11.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (CMLAdaptive)

- (CGSize)sizeAdaptiveWithText:(NSString *)text textFont:(UIFont *)font textMaxSize:(CGSize )size textLineSpacing:(CGFloat)lineSpacing;

@end

NS_ASSUME_NONNULL_END
