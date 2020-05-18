//
//  CMLNewVIPRecommendView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/9/17.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseResultObj.h"

@protocol CMLNewVIPRecommendViewDelegate <NSObject>

- (void) selectListIndex:(int) index;

@optional
- (void) refreshCurrentVC;

@end

@interface CMLNewVIPRecommendView : UIView


@property (nonatomic,strong) BaseResultObj *recommend;

@property (nonatomic,assign) int currentSelectIndex;

@property (nonatomic,weak) id<CMLNewVIPRecommendViewDelegate> delegate;

@property (nonatomic,assign) CGFloat selctTopY;

- (void) refreshRecommendView;

@end
