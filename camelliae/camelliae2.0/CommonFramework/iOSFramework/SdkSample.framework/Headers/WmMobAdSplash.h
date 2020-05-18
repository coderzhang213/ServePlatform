//
//  WmMobAdSplash.h
//  SdkSample
//
//  Created by 周泽浩 on 2018/8/22.
//  Copyright © 2018年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WangMaiSplashAdDelegate.h"
#import "AdReport.h"

@interface WmMobAdSplash : NSObject<AdReport>

@property (nonatomic, strong) UIWindow *groupView;
@property (nonatomic, retain) NSDate *now;
@property (nonatomic, assign) int requestDuration;//请求时间
@property (nonatomic, retain) NSDictionary *apiData;
@property (nonatomic, copy) NSString *keepAdslodId;
@property (nonatomic, copy) NSString *requestId;
@property (nonatomic, copy) NSString *appToken;
@property (nonatomic, copy) NSString *appSign;
//开屏协议
@property (nonatomic,weak) id<WangMaiSplashAdDelegate>delegate;
//创建全屏广告
- (id) initWithAppToken: (NSString *)appToken andSign: (NSString *)sign andAdslotId: (NSString *)adslotId withParent: (UIWindow *)parent;
//半开屏
- (id) initWithAppToken: (NSString *)appToken andSign: (NSString *)sign andAdslotId: (NSString *)adslotId withParent: (UIWindow *)parent withBottomView:(UIView *)bottomView;

//销毁
- (void) onDestroy;

@end
