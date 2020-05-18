//
//  CMLStoreGoodsTopRecommendView.h
//  camelliae2.0
//
//  Created by 张越 on 2018/5/28.
//  Copyright © 2018年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMLStoreGoodsRecommendViewDelegate<NSObject>

@optional

- (void) refeshCurrentRecommendView;

- (void) goodsVerbSelect:(int) selectIndex;

- (void)netErrorOfStoreGoodsRecommendView;

@end


@interface CMLStoreGoodsTopRecommendView : UIView

- (void)refreshDataOfPull;

@property (nonatomic,weak) id<CMLStoreGoodsRecommendViewDelegate> delegate;

@property (nonatomic,assign) CGFloat currentheight;

@end
