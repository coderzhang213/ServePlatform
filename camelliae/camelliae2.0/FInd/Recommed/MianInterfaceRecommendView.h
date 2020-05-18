//
//  MianInterfaceRecommendView.h
//  camelliae2.0
//
//  Created by 张越 on 2016/12/19.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecommendDelegate <NSObject>

- (void) loadViewSuccess;

- (void) progressSuccess;

- (void) progressError:(NSString *) msg andCode:(int) code;

@end

@interface MianInterfaceRecommendView : UIView

@property (nonatomic,weak) id<RecommendDelegate>delegate;

@end
