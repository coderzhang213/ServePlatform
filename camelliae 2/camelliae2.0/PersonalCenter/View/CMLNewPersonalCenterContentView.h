//
//  CMLNewPersonalCenterModelView.h
//  camelliae2.0
//
//  Created by 张越 on 2018/8/10.
//  Copyright © 2018年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewPersonalCenterContentViewDelegate <NSObject>

- (void) shareCML;

- (void) signCML;

@end

@interface CMLNewPersonalCenterContentView : UIView

- (instancetype)initWithObj:(BaseResultObj *)obj;

@property (nonatomic,assign) CGFloat currentHeight;

@property (nonatomic, assign) BOOL isHidden;

@property (nonatomic,weak) id<NewPersonalCenterContentViewDelegate> delegate;

@end
