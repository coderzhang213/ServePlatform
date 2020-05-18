//
//  ActivityTopMessageView.h
//  camelliae2.0
//
//  Created by 张越 on 2016/12/26.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseResultObj;

@interface ActivityBriefInformationView : UIView

- (instancetype)initWith:(BaseResultObj *) obj;

@property (nonatomic,assign) CGFloat currentHeight;

@property (nonatomic,strong) UIImageView *currentImage;

@property (nonatomic,assign) int currentIndex;


- (void) hiddenTopImage;

- (void) showTopImage;

@end
