//
//  AdReport.h
//  Wm_mobAd_SDK
//
//  Created by 周泽浩 on 2018/4/19.
//  Copyright © 2018年 周泽浩. All rights reserved.
//

#import <Foundation/Foundation.h>

//广告展现  点击报告协议
@protocol AdReport <NSObject>

@optional//可选实现
//展现
-(void) adShowReport;
//点击
-(void) adClickReport;
//错误
-(void)adErrorReport;

@end
