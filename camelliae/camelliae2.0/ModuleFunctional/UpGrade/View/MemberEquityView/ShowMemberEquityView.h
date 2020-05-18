//
//  ShowMemberEquityView.h
//  camelliae2.0
//
//  Created by 孙志泽 on 2019/3/7.
//  Copyright © 2019 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CMLPCMemberCardModel;

@protocol ShowMemberEquityViewDelegate <NSObject>

- (void)showMemberEquityViewButtonClickedDelegateWith:(int)location;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ShowMemberEquityView : UIView

@property (nonatomic, weak) id <ShowMemberEquityViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withRoleCardModel:(CMLPCMemberCardModel *)roleCardModel;

@end

NS_ASSUME_NONNULL_END
