//
//  CMLNewPersonalTopContentView.h
//  camelliae2.0
//
//  Created by 张越 on 2018/8/13.
//  Copyright © 2018年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMLNewPersonalTopContentViewDelegate <NSObject>

- (void)refreshCurrentUserWithTopContentView;

@end

@interface CMLNewPersonalTopContentView : UIView

- (instancetype)initWithObj:(BaseResultObj *)obj withCoverImage:(UIImage *)coverImage vImage:(UIImage *)vImage;

@property (nonatomic,assign) CGFloat currentHeight;

@property (nonatomic, weak) id <CMLNewPersonalTopContentViewDelegate> topDelegate;

@end
