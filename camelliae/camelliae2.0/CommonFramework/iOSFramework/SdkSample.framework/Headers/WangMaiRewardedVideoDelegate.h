//
//  WangMaiRewardedVideoDelegate.h
//  PublicFilePackage
//
//  Created by 周泽浩 on 2018/10/16.
//  Copyright © 2018年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WangMaiRewardedVideoDelegate <NSObject>
/**
 rewardedVideoAd 激励视频广告物料加载成功
 */
- (void)rewardedVideoAdDidLoad;

/**
 rewardedVideoAd 广告位即将展示
 */
- (void)rewardedVideoAdWillVisible;

/**
 rewardedVideoAd 激励视频广告关闭
 */
- (void)rewardedVideoAdDidClose;

/**
 rewardedVideoAd 激励视频广告点击下载
 */
- (void)rewardedVideoAdDidClickDownload;

/**
 rewardedVideoAd 激励视频广告素材加载失败
 @param error 错误对象
 */
- (void)rewardedVideoAdFailWithError:(NSString *)error;

/**
 rewardedVideoAd 激励视频广告播放完成或发生错误
 
 @param error 错误对象
 */
- (void)rewardedVideoAdDidPlayFinishOrDidFailWithError:(NSString *)error;

/**
 服务器校验后的结果,异步 rewardedVideoAd publisher
 @param verify 有效性验证结果
 */
- (void)rewardedVideoAdServerRewardDidSucceedWithVerify:(BOOL)verify;

/**
 rewardedVideoAd publisher
 */
- (void)rewardedVideoAdServerRewardDidFail;

@end

