//
//  WmMobBannerAd.h
//  SdkSample
//
//  Created by 周泽浩 on 2018/8/28.
//  Copyright © 2018年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WmBannerAdDelegate.h"
#import <UIKit/UIKit.h>
#import "AdReport.h"

@interface WmMobBannerAd : NSObject<AdReport>


@property (weak, nonatomic) NSObject<WmBannerAdDelegate> *delegate;//旺脉banner广告协议
@property (nonatomic, retain) UIView *groupView;
@property (nonatomic, retain) NSDate *now;
@property (nonatomic, assign) int requestDuration;
@property (nonatomic, retain) NSDictionary *apiData;
@property (nonatomic, copy) NSString *requestId;
@property (nonatomic, copy) NSString *posId;
//本地保存参数
@property (nonatomic, copy) NSString *appToken;
@property (nonatomic, copy) NSString *appSign;

//创建banner广告
- (id) initWithAppToken: (NSString *)appToken andSign: (NSString *)sign andAdslotId: (NSString *)adslotId andRect: (CGRect) rect andParent: (UIView *)parent andVC: (UIViewController *) controller;

- (void) onDestroy;


@end
