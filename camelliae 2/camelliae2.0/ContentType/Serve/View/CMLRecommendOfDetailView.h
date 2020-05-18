//
//  CMLRecommendOfDetailView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/1.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseResultObj;


@protocol CMLRecommendOfDetailViewDelegate<NSObject>

- (void) showWriteView;

- (void) showFailMessage:(NSString *) mes;

- (void) enterRecommendVC;

@end

@interface CMLRecommendOfDetailView : UIView

- (instancetype)initWith:(BaseResultObj *) obj;

@property (nonatomic,weak) id<CMLRecommendOfDetailViewDelegate>delegate;

@property (nonatomic,assign) CGFloat currentHeight;

- (void) refreshCurrentRecommendView:(NSString *) mes;

- (void) stopVideo;

@end
