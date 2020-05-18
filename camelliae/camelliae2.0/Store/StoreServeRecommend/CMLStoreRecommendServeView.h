//
//  CMLStoreRecommendServeView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/11/26.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseResultObj;

@protocol CMLStoreRecommendServeViewDelegate <NSObject>

- (void) priceVerbWithSign:(int) signTag;
@end

@interface CMLStoreRecommendServeView : UIView

- (instancetype)initWithObj:(BaseResultObj *) obj andName:(NSString *) name;

@property (nonatomic,weak) id<CMLStoreRecommendServeViewDelegate>delegate;


@property (nonatomic,assign) CGFloat currentHeight;

@end
