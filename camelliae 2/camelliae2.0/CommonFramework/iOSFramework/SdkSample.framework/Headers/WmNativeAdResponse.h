//
//  WmNativeAdResponse.h
//  PublicFilePackage
//
//  Created by 周泽浩 on 2018/9/5.
//  Copyright © 2018年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WmNativeAdResponse : NSObject

@property (nonatomic,copy) NSString *keyTitle;
@property (nonatomic,copy) NSString *keyDesc;
@property (nonatomic,copy) NSString *keyIconUrl;
@property (nonatomic,copy) NSString *keyImgUrl;
@property (nonatomic,strong) UIView *videoView;


#pragma mark ====================获取数据方法====================
//获取标题
- (NSString *)getAdKeyTitle;
//获取应用描述
- (NSString *)getAdKeyDesc;
//获取icon
- (NSString *)getAdKeyIconUrl;
//获取图片
- (NSString *)getAdKeyImgUrl;

//获取视频视图
- (UIView *)getAdVideoView;
@end
