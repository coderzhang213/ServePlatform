//
//  ServeTopMessageView.h
//  camelliae2.0
//
//  Created by 张越 on 2016/12/26.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseResultObj;

@protocol ServeTopMessageViewDelegate <NSObject>

@optional

- (void) showSuccessWith:(NSString *)str;

- (void) showErrorWith:(NSString *)str;

- (void)showCanGetCouponViewOfServeTopMessageViewWith:(BaseResultObj *)obj;

@end


@interface ServeTopMessageView : UIView

- (instancetype)initWith:(BaseResultObj *) obj;

@property (nonatomic,assign) CGFloat currentHeight;

@property (nonatomic,weak) id<ServeTopMessageViewDelegate>delegate;

- (void) removeVideo;

@end
