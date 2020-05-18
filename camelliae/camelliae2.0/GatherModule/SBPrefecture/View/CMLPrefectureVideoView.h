//
//  CMLPrefectureVideoView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/5/5.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseResultObj;

@interface CMLPrefectureVideoView : UIView

- (instancetype)initWithObj:(BaseResultObj *) obj;

@property (nonatomic,assign) CGFloat viewHeight;

@end
