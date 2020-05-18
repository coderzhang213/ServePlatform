//
//  WangMaiInterstitialAdDelegate.h
//  SdkSample
//
//  Created by 周泽浩 on 2018/6/4.
//  Copyright © 2018年 周泽浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WangMaiInterstitialAdDelegate <NSObject>

// 详解:当接收服务器返回的广告数据成功后调用该函数
- (void)interstitialSuccessToLoad;

// 广告预加载失败回调
//
// 详解:当接收服务器返回的广告数据失败后调用该函数
- (void)interstitialFailToLoad:(NSString *)error;

// 插屏广告将要展示回调
//
// 详解: 插屏广告即将展示回调该函数
- (void)interstitialWillPresentScreen;

// 插屏广告视图展示成功回调
//
// 详解: 插屏广告展示成功回调该函数
- (void)interstitialDidPresentScreen;

//点击回调
- (void)interstitialClicked;

// 插屏广告展示结束回调
//
// 详解: 插屏广告展示结束回调该函数
- (void)interstitialDidDismissScreen;

// 应用进入后台时回调
//
// 详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
- (void)interstitialDidDismissFullScreen;



@end
