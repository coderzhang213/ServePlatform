//
//  DetailWebView.h
//  camelliae2.0
//
//  Created by 张越 on 2016/12/27.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LoadWebViewFinish)(CGFloat currentHeight);

typedef void(^ShowAllMessage) (CGFloat currentHeight);

@class BaseResultObj;

@interface DetailWebView : UIView

- (instancetype)initWith:(BaseResultObj *) obj;

@property (nonatomic,copy) LoadWebViewFinish loadWebViewFinish;

@property (nonatomic,copy) ShowAllMessage showAllMessage;

@end
