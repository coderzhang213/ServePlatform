//
//  CMLServeDetailView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/1.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseResultObj;

@protocol CMLServeDetailViewDelegate<NSObject>

- (void) finshLoadDetailView;

- (void) changeShowView;


@end


@interface CMLServeDetailView : UIView

- (instancetype)initWith:(BaseResultObj *) obj;

@property (nonatomic,weak) id<CMLServeDetailViewDelegate>delegate;

@property (nonatomic,assign) CGFloat currentHeight;

@end
