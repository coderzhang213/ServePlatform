//
//  Network.m
//  XHLaunchAdExample
//
//  Created by zhuxiaohui on 2016/6/28.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHLaunchAd
//  数据请求类
#import "Network.h"
#import "DataManager.h"
@implementation Network

/**
 *  此处模拟广告数据请求,实际项目中请做真实请求
 */
+(void)getLaunchAdImageDataSuccess:(NetworkSucess)success failure:(NetworkFailure)failure;
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LaunchImageAd" ofType:@"json"]];
        NSDictionary *json =  [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
        if(success) success(json);

    });
}
/**
 *  此处模拟广告数据请求,实际项目中请做真实请求
 */
+(void)getLaunchAdVideoDataSuccess:(NetworkSucess)success failure:(NetworkFailure)failure;
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([[DataManager lightData]readThirdVideoPlayerUrl].length > 0) {
            NSMutableDictionary *targetDic = [NSMutableDictionary dictionary];
            [targetDic setObject:[NSNumber numberWithInt:200] forKey:@"code"];
            [targetDic setObject:@"success" forKey:@"msg"];
            
            NSNumber *currnetSecond;
            
            if ([[[DataManager lightData] readThirdVideoPlaySecond] intValue] > 15) {
                
                currnetSecond = [NSNumber numberWithInt:15];
            }else{
            
                currnetSecond = [[DataManager lightData] readThirdVideoPlaySecond];
            }

            
            NSDictionary *dataDic = @{@"content":[[DataManager lightData]readThirdVideoPlayerUrl],
                                      @"openUrl":[[DataManager lightData] readOpenVideoUrl],
                                      @"contentSize":@"720*1280",
                                      @"duration":currnetSecond};
            [targetDic setObject:dataDic forKey:@"data"];
            
            if(success) success(targetDic);
        }
    });
}
@end
