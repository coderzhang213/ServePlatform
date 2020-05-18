//
//  AppDelegate.h
//  camelliae2.0
//
//  Created by 张越 on 16/5/3.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *appKey = @"350b39c5bc69f5a9b2c7e4b4";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSString *pid;
}

- (void)setAppStartMes;

@property (nonatomic,copy) NSString *pid;

@property (nonatomic, assign) BOOL isNetError;

@property (strong, nonatomic) UIWindow *window;

- (void)registerAPNsAuthorizationWithApplication:(UIApplication *)application;

@end

