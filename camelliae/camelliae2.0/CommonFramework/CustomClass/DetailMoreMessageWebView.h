//
//  DetailMoreMessageWebView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/3/30.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^LoadWebViewFinish)(CGFloat currentHeight);


@class BaseResultObj;

@interface DetailMoreMessageWebView : UIView

- (instancetype)initWith:(BaseResultObj *) obj;

@property (nonatomic,copy) LoadWebViewFinish loadWebViewFinish;

@property (nonatomic,assign) CGFloat bottomHeight;


@end
