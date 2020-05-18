//
//  CMLUpGradeImageBgView.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/7/8.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMLUpGradeImageBgViewDelegate <NSObject>

- (void)pickBlackPigmentMemberOfImageBgView:(UIButton *_Nullable)button;

- (void)showMessageOfImageBgView:(UIButton *_Nullable)button;

- (void)enterGoldIntroduceOfImageBgView;

- (void)showMemberEquityViewOfImageBgViewWith:(int)location;

- (void)cityPartnerApplyButtonClickOfUpGradeImageBgView;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CMLUpGradeImageBgView : UIView

- (instancetype)initWithFrame:(CGRect)frame withRoleObj:(BaseResultObj *)roleObj;

@property (nonatomic, weak) id <CMLUpGradeImageBgViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
