//
//  WMMobNativeAdvertising.h
//  SdkSample
//
//  Created by 周泽浩 on 2018/9/5.
//  Copyright © 2018年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AdReport.h"
#import "WMNativeAdDelegete.h"
@interface WMMobNativeAdvertising : NSObject<AdReport>

@property (weak, nonatomic) NSObject<WMNativeAdDelegete> *delegate;
//信息流
- (id) initWithAppToken: (NSString *)appToken andSign: (NSString *)sign andAdslotId: (NSString *)adslotId andController: (UIViewController *)controller;
/*
 * 广告数据渲染完毕，即将展示时需调用AttachAd方法。
 */
- (void)attachAd:(UIView *)view;
/**
 *  广告点击调用方法
 *  详解：当用户点击广告时，开发者需调用本方法，系统会弹出内嵌浏览器、或内置AppStore、
 *      或打开系统Safari，来展现广告目标页面
 */
- (void)clickAd;

@end
