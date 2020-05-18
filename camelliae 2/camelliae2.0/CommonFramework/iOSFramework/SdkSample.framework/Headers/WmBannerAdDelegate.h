//
//  WmBannerAdDelegate.h
//  SdkSample
//
//  Created by 周泽浩 on 2018/4/23.
//  Copyright © 2018年 周泽浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WmBannerAdDelegate <NSObject>

/*
 请求广告失败
 */
- (void) wmBannerFailToReceived:(NSString *)error;

/*
 展现回调
 */
-(void) wmBannerExposured;
/*
 点击回调
 */
-(void) wmBannerViewClicked;
/*
 广告被用户关闭时回调
 */
-(void) wmBannerWillClose;


@end
