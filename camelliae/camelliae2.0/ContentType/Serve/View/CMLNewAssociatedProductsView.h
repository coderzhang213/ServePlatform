//
//  CMLNewAssociatedProductsView.h
//  camelliae2.0
//
//  Created by 张越 on 2018/9/7.
//  Copyright © 2018年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseResultObj;

@protocol CMLNewAssociatedProductsViewDelegate<NSObject>


- (void) changeShowView;


@end

@interface CMLNewAssociatedProductsView : UIView


- (instancetype)initWith:(BaseResultObj *) obj;

@property (nonatomic,weak) id<CMLNewAssociatedProductsViewDelegate>delegate;

@property (nonatomic,assign) CGFloat currentHeight;

@end
