//
//  CMLPushMessageRemindView.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/6/13.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CMLPushMessageRemindViewDelegate <NSObject>

- (void)pushRemindViewOpenButtonClicked;

- (void)pushRemindViewCloseButtonClicked;

@end

@interface CMLPushMessageRemindView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, weak) id<CMLPushMessageRemindViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
