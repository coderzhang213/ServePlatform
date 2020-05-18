//
//  WangMaiAdvertisingSizeData.h
//  JinRiTouTiaoAdvertising
//
//  Created by 周泽浩 on 2018/9/6.
//  Copyright © 2018年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WangMaiAdvertisingSizeData : NSObject
//单利方法
+ (instancetype)sharedInstance;
#pragma mark ====================开屏====================
@property (nonatomic,assign) CGRect splashAdFrame;

#pragma mark ====================插屏====================
// 宽度
@property (nonatomic, assign) NSInteger interstitialAdWidth;
// 高度
@property (nonatomic, assign) NSInteger interstitialAdHeight;
#pragma mark ====================信息流====================
// 宽度
@property (nonatomic, assign) NSInteger nativeAdImageWidth;
// 高度
@property (nonatomic, assign) NSInteger nativeAdImageHeight;
//信息流视频尺寸
@property (nonatomic, assign) CGRect videoFrame;
@end
