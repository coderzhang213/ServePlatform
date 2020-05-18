//
//  NewSelectView.h
//  camelliae2.0
//
//  Created by 张越 on 16/9/12.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NewSelectDelegate <NSObject>

- (void) selectIndex:(NSInteger) index title:(NSString *)title;

@end
@interface NewSelectView : UIView
@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,assign) BOOL isSelectedState;

@property (nonatomic,assign) int currentIndex;

@property (nonatomic,assign) CGFloat contentTopMargin;

@property (nonatomic,assign) CGFloat contentLeftMargin;

@property (nonatomic,assign) CGFloat selectViewHeight;

@property (nonatomic,strong) UIColor *buttontitleColor;

@property (nonatomic,weak) id<NewSelectDelegate> delegate;

- (void) refreshSelectView;
@end
