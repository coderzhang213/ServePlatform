//
//  ActivityPromMessageView.h
//  camelliae2.0
//
//  Created by 张越 on 2016/12/27.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol   ActivityPromMessageDelegate <NSObject>

- (void) cancelcurrentAppointment;

@end

@interface ActivityPromMessageView : UIView

- (instancetype)init;

@property (nonatomic,weak) id<ActivityPromMessageDelegate> delegate;

@property (nonatomic,assign) CGFloat currentWidth;

@property (nonatomic,assign) CGFloat currentHeight;

@end
