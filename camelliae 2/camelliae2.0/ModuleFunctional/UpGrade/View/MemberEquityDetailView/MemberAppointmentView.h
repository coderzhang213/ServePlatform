//
//  MemberAppointmentView.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/15.
//  Copyright © 2019 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MemberAppointmentViewDelegate <NSObject>

- (void)offsetMemberAppointmentView;

- (void)recoveryMemberAppointmentView;

@end


NS_ASSUME_NONNULL_BEGIN

@interface MemberAppointmentView : UIView

- (void)appointmentTextFieldResignFirstResponder;

@property (nonatomic, weak) id <MemberAppointmentViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
