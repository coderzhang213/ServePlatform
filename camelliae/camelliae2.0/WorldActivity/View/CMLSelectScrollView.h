//
//  CMLSelectScrollView.h
//  transitionOfViewController
//
//  Created by 张越 on 2016/10/11.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectScrollViewDelegate <NSObject>

- (void) selectItemName:(NSString *)name index:(int) index;

@end

@interface CMLSelectScrollView : UIView

@property (nonatomic,strong) NSArray *itemNamesArray;

@property (nonatomic,assign) CGFloat leftAndRightMargin;

@property (nonatomic,assign) CGFloat itemsSpace;

@property (nonatomic,strong) UIColor *selectColor;

@property (nonatomic,strong) UIColor *normalColor;

@property (nonatomic,strong) UIFont *itemNameSize;


@property (nonatomic,weak) id<SelectScrollViewDelegate>delgate;

- (void) refreshSelectScrollView:(int) index;

- (void) loadSelectViewAndData;

- (void) loadNewStyleSelectView;

@end
