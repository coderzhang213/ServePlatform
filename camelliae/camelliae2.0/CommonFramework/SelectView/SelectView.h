//
//  SelectView.h
//  camelliae2.0
//
//  Created by 张越 on 16/9/1.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectDelegate <NSObject>

- (void) selectIndex:(NSInteger) index title:(NSString *)title;

@end

@interface SelectView : UIView

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,assign) BOOL isSelectedState;

@property (nonatomic,assign) int currentIndex;

@property (nonatomic,assign) CGFloat contentTopMargin;

@property (nonatomic,assign) CGFloat contentLeftMargin;

@property (nonatomic,assign) CGFloat selectViewHeight;

@property (nonatomic,strong) UIColor *buttontitleColor;

@property (nonatomic,weak) id<SelectDelegate> delegate;

- (void) refreshSelectView;

@end
