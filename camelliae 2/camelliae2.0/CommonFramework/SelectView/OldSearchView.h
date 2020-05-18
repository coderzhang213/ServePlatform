//
//  OldSearchView.h
//  camelliae2.0
//
//  Created by 张越 on 2018/8/3.
//  Copyright © 2018年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OldSelectDelegate <NSObject>

- (void) selectOldSearchIndex:(NSInteger) index title:(NSString *)title;

- (void) deleteAllSearch;

@end

@interface OldSearchView : UIView

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,assign) BOOL isSelectedState;

@property (nonatomic,assign) int currentIndex;

@property (nonatomic,assign) CGFloat contentTopMargin;

@property (nonatomic,assign) CGFloat contentLeftMargin;

@property (nonatomic,assign) CGFloat selectViewHeight;

@property (nonatomic,strong) UIColor *buttontitleColor;

@property (nonatomic,weak) id<OldSelectDelegate> delegate;

- (void) refreshOldSelectView;


@end
