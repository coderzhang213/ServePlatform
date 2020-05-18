//
//  CMLCutDownView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/5/11.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^TimeOverBlock)();

@interface CMLCutDownView : UIView

- (instancetype)initWithTime:(NSNumber *) time;

- (instancetype)initWithObj:(BaseResultObj *) obj;

@property (nonatomic,assign) CGFloat viewHeight;

@property (nonatomic,copy) TimeOverBlock timeOver;

- (void) removeTimer;

- (void) startTimer;
@end
