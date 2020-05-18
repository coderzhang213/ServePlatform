//
//  ActivityAppointmentMessageView.h
//  camelliae2.0
//
//  Created by 张越 on 2016/12/27.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseResultObj;

@protocol ActivityAppointmentMessageDelegate <NSObject>

- (void) activityAppointmentSuccess:(NSString *) str;
- (void) activityAppointmentError:(NSString *) str;

- (void) activityStartAppoint;

- (void) activityStopAppoint;

@end

@interface ActivityAppointmentMessageView : UIView


- (instancetype)initWith:(BaseResultObj *) obj andType:(NSNumber *) type;

@property (nonatomic,weak) id<ActivityAppointmentMessageDelegate> delegate;

@property (nonatomic,copy) NSString *appointmentProm;

@property (nonatomic,assign) CGFloat currentHeight;

@property (nonatomic,assign) CGFloat currentWidth;

@property (nonatomic,copy) NSString *orderID;

- (void) resignUserNameFirstResponder;

@end
