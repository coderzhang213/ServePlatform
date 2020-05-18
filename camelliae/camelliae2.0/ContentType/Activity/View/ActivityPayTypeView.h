//
//  ActivityPayTypeView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/4/24.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActivityPayTypeViewDelegate <NSObject>

- (void) startActivityPayType;

- (void) activityPayTypeError:(NSString *) str;

- (void) stopActivityPayType;

- (void) cancelActivityPayProgress;


@end

@interface ActivityPayTypeView : UIView

@property (nonatomic,weak) id<ActivityPayTypeViewDelegate> delegate;

@property (nonatomic,copy) NSString *orderId;

@property (nonatomic,assign) CGFloat viewWidth;

@property (nonatomic,assign) CGFloat viewHeight;

@end
