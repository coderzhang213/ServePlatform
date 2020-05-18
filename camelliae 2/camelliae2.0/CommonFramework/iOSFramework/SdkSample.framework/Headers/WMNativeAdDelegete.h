//
//  WMNativeAdDelegete.h
//  PublicFilePackage
//
//  Created by 周泽浩 on 2018/9/5.
//  Copyright © 2018年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WmNativeAdResponse;
@protocol WMNativeAdDelegete <NSObject>
/**
 * 拉取广告成功的回调
 */
- (void)nativeAdSuccessToLoad:(NSArray<WmNativeAdResponse *> *)nativeAdDataArray;

/**
 * 拉取广告失败的回调
 */
- (void)nativeAdFailToLoad:(NSString *)error;

@end
