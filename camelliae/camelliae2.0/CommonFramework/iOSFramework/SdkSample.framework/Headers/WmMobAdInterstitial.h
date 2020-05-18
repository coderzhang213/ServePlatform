//
//  WmMobAdInterstitial.h
//  SdkSample
//
//  Created by 周泽浩 on 2018/8/29.
//  Copyright © 2018年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WangMaiInterstitialAdDelegate.h"
#import <UIKit/UIKit.h>
#import "AdReport.h"
@interface WmMobAdInterstitial : NSObject<AdReport>

@property (weak, nonatomic) NSObject<WangMaiInterstitialAdDelegate> *delegate;//旺脉插屏广告协议
@property (nonatomic, retain) NSDate *now;
@property (nonatomic, assign) int requestDuration;//请求时间
@property (nonatomic, retain) NSDictionary *apiData;
@property (nonatomic, copy) NSString *posId;
@property (nonatomic, copy) NSString *requestId;
//本地保存参数
@property (nonatomic, copy) NSString *appToken;
@property (nonatomic, copy) NSString *appSign;
//初始化插屏广告
- (id) initWithAppToken: (NSString *)appToken andSign: (NSString *)sign andAdslotId: (NSString *)adslotId;
//展示插屏广告请求
- (void)showAd:(UIViewController *)c;
//销毁
- (void) onDestroy;

@end
