//
//  ShowAgreementView.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/8.
//  Copyright © 2019 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowAgreementViewDelegate <NSObject>

- (void)confirmAgreementWith:(UIButton *_Nullable)button;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ShowAgreementView : UIView

@property (nonatomic, weak) id <ShowAgreementViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withType:(UIButton *)button;

@end

NS_ASSUME_NONNULL_END
