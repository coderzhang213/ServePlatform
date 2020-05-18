//
//  WMNativeExpressAdDelegete.h
//  SdkSample
//
//  Created by 周泽浩 on 2018/5/28.
//  Copyright © 2018年 周泽浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WMNativeExpressAdDelegete <NSObject>
/**
 * 拉取广告成功的回调
 */
- (void)nativeEAdSuccessToLoad:(UIView *)adView;

/**
 * 拉取广告失败的回调
 */
- (void)nativeEAdRenderFail;

/**
 * 拉取原生模板广告失败
 */
- (void)nativeEAdFailToLoad:(NSString *)error;

- (void)nativeEAdViewRenderSuccess;

- (void)nativeEAdViewClicked;

- (void)nativeEAdViewClosed;


@end
