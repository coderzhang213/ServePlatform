//
//  ActivityWebMessageView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/7/31.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseResultObj;

@interface ActivityWebMessageView : UIView

- (instancetype)initWithObj:(BaseResultObj *) obj;

@property (nonatomic,assign) CGFloat currentHeight;

@end
