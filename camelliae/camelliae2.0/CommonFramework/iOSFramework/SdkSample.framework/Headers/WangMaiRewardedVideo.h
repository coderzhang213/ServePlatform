//
//  WangMaiRewardedVideo.h
//  SdkSample
//
//  Created by 周泽浩 on 2018/10/16.
//  Copyright © 2018年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WangMaiRewardedVideoDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface WangMaiRewardedVideo : NSObject

@property (nonatomic,weak) id<WangMaiRewardedVideoDelegate>delegate;

//创建激励视频
- (id) initWithAppToken: (NSString *)appToken andSign: (NSString *)sign andAdslotId: (NSString *)adslotId andUserId: (NSString *)userId;
//展现广告
- (void)wangmaiShowAdFromRootViewController:(UIViewController *)rootViewController;

@end

NS_ASSUME_NONNULL_END
