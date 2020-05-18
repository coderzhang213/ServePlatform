//
//  CMLRecommendUserFooterView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/11/2.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMLRecommendUserFooterViewDelegate <NSObject>

@optional

- (void) refershCurrentVCData;

- (void) initRecommendUserFooterView:(UIView *) currentView;

@end

@interface CMLRecommendUserFooterView : UIView

- (instancetype)init;

@property (nonatomic,weak) id<CMLRecommendUserFooterViewDelegate> delegate;



@end
