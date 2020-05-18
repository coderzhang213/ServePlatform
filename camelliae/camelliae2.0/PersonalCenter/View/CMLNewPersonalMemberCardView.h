//
//  CMLNewPersonalMemberCardView.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/7/15.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CMLNewPersonalMemberCardViewDelegate <NSObject>

- (void)enterMemberCenterOfCardViewWithRoleObj:(BaseResultObj *)roleObj;

@end

@interface CMLNewPersonalMemberCardView : UIView

- (instancetype)initWithFrame:(CGRect)frame withObj:(BaseResultObj *)obj withCoverImage:(UIImage *)coverImage vImage:(UIImage *)vImage;

@property (nonatomic, weak) id <CMLNewPersonalMemberCardViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
