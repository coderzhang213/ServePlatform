//
//  CMLUserPushProjectMessageView.h
//  camelliae2.0
//
//  Created by 张越 on 2018/11/17.
//  Copyright © 2018 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseResultObj.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UserPushProjectMessageViewDelegate <NSObject>

- (void) activityAppointmentSuccess:(NSString *) str;
- (void) activityAppointmentError:(NSString *) str;

- (void) activityStartAppoint;

- (void) activityStopAppoint;

@end

@interface CMLUserPushProjectMessageView : UIView

- (instancetype)initWith:(BaseResultObj *) obj andType:(NSNumber *) type;

@property (nonatomic,weak) id<UserPushProjectMessageViewDelegate> delegate;

@property (nonatomic,copy) NSString *appointmentProm;

@property (nonatomic,assign) CGFloat currentHeight;

@property (nonatomic,assign) CGFloat currentWidth;

@property (nonatomic,copy) NSString *orderID;

//- (void) resignUserNameFirstResponder;

@end

NS_ASSUME_NONNULL_END
