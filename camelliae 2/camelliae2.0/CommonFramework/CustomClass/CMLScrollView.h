//
//  CMLScrollView.h
//  testOfTableView
//
//  Created by 张越 on 16/5/19.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMLScrollViewDelegate <NSObject>

- (void) selectIndex:(NSInteger) index;

@end

@interface CMLScrollView : UIView


@property (nonatomic,strong) NSArray *imagesUrlArray;

@property (nonatomic,strong) id<CMLScrollViewDelegate>delegate;

- (void) refreshCurrentView;

@end
