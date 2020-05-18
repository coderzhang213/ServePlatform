//
//  WangMaiSplashAdDelegate.h
//  Wmpot
//
//  Created by HitiSoft on 19/04/2018.
//
#import <Foundation/Foundation.h>

@protocol WangMaiSplashAdDelegate <NSObject>

@optional
//开屏广告展现成功
- (void) splashAdSuccess;
//广告展现失败-- error:错误
- (void) splashlFail: (NSString *)error;
//广告被点击
- (void) splashClicked;
//广告消失
- (void) splashDismissed;
@end
