//
//  CMLStoreRecommendView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/11/26.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMLStoreRecommendViewDelegate<NSObject>

@optional

- (void) refeshCurrentRecommendView;

- (void) selectIndex:(int) index;

- (void) serveVerbSelect:(int) selectIndex;


@end

@interface CMLStoreRecommendView : UIView

- (instancetype)initWithAttributeArray:(NSArray *) attributeArray;

@property (nonatomic,weak) id<CMLStoreRecommendViewDelegate> delegate;

@property (nonatomic,assign) CGFloat currentheight;


@end
