//
//  ActivityFooterView.h
//  camelliae2.0
//
//  Created by 张越 on 2016/12/26.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseResultObj;

@protocol ActivityFooterViewDelegate <NSObject>

- (void) showActivityMessage;

@end

@interface ActivityFooterView : UIView

- (instancetype)initWith:(BaseResultObj *)obj withIsJoin:(NSString *)isJoin;

- (instancetype)initUserPushWith:(BaseResultObj *) obj;

@property (nonatomic,assign) CGFloat currentHeight;

@property (nonatomic,weak) id<ActivityFooterViewDelegate> delegate;

- (void) confirmAppointment;

@end
