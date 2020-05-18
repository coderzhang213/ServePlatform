//
//  RollView.h
//  camelliae2.0
//
//  Created by 张越 on 2018/11/22.
//  Copyright © 2018 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RollViewDelegate <NSObject>

-(void)didSelectPicWithIndexPath:(NSInteger)index;

- (void) scrollX:(CGFloat) x;
@end



@interface RollView : UIView

@property (nonatomic, assign) id<RollViewDelegate> delegate;

/**
 初始化
 
 @param frame 设置View大小
 @param distance 设置Scroll距离View两侧距离
 @param gap 设置Scroll内部 图片间距
 @return 初始化返回值
 */
- (instancetype)initWithFrame:(CGRect)frame withDistanceForScroll:(float)distance withGap:(float)gap;

/** 滚动视图数据 */
-(void)rollView:(NSArray *)dataArr;

@property (nonatomic,assign) CGFloat radius;

@end

NS_ASSUME_NONNULL_END
