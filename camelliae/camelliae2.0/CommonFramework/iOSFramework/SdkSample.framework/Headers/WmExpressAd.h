//
//  WmExpressAd.h
//  SdkSample
//
//  Created by 周泽浩 on 2018/9/3.
//  Copyright © 2018年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AdReport.h"
#import "WMNativeExpressAdDelegete.h"

@interface WmExpressAd : NSObject<AdReport>

@property (weak, nonatomic) NSObject<WMNativeExpressAdDelegete> *delegate;

//初始化原生模板广告
- (id) initWithAppToken: (NSString *)appToken andSign: (NSString *)sign andAdslotId: (NSString *)adslotId andAdRect:(CGRect)adRect;
/**
 *[必选]
 *原生模板广告渲染
 */
- (void)render;
//设置父控制器
- (void)setAdSuperController:(UIViewController *)controller;
@end
