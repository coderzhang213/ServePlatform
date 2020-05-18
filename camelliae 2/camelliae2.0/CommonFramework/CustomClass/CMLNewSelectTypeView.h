//
//  CMLNewSelectTypeView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/11/22.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMLNewSelectTypeViewDelegate <NSObject>;

- (void) newSelectTypeViewSelect:(int) index;

@end

@interface CMLNewSelectTypeView : UIView

- (instancetype)initWithFrame:(CGRect)frame andTypeNamesArray:(NSArray *) nameArray;

@property (nonatomic,strong) UIColor *selectColor;

@property (nonatomic,strong) UIColor *normalColor;

@property (nonatomic,strong) UIColor *lineColor;

@property (nonatomic,strong) UIFont *titleFont;

@property (nonatomic,assign) int currentSelectIndex;

@property (nonatomic,weak) id<CMLNewSelectTypeViewDelegate> delegate;

- (void) refreshNewTypeViews;

- (void) refreshSelectType:(int) inedx;

@end
