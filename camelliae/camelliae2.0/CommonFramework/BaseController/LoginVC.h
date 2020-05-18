//
//  LoginVC.h
//  camelliae2.0
//
//  Created by 张越 on 16/5/20.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLBaseVC.h"

@protocol LoginVCDelegate <NSObject>

- (void)registerPushAfterLogin;

@end

@interface LoginVC : CMLBaseVC

@property (nonatomic, weak) id <LoginVCDelegate> delegate;

@property (nonatomic, assign) BOOL isNetError;

@end
