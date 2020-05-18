//
//  CMLStoreRecommendGoodsView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/11/26.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseResultObj;

@protocol CMLStoreRecommendGoodsViewDelegate <NSObject>

- (void) goodsPriceVerbWithSign:(int) signTag;
@end

@interface CMLStoreRecommendGoodsView : UIView

- (instancetype)initWithObj:(BaseResultObj *) obj andName:(NSString *) name;

@property (nonatomic,assign) CGFloat currentHeight;

@property (nonatomic,weak) id<CMLStoreRecommendGoodsViewDelegate>delegate;


@end
