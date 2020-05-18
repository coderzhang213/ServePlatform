//
//  NotificationService.h
//  CMLServiceExtension
//
//  Created by 卡枚连 on 2019/6/4.
//  Copyright © 2019 卡枚连. All rights reserved.
//
#import <Foundation/Foundation.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>

@interface NotificationService : UNNotificationServiceExtension

@end
#endif
