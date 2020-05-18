//
//  InformationWkView.h
//  camelliae2.0
//
//  Created by 张越 on 2016/12/28.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LoadWebViewFinish)(CGFloat currentHeight);

@interface InformationWkView : UIView

- (instancetype)initWith:(NSString *) url;

@property (nonatomic,copy) LoadWebViewFinish loadWebViewFinish;

@end
