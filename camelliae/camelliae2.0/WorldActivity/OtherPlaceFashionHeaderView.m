//
//  OtherPlaceFashionHeaderView.m
//  camelliae2.0
//
//  Created by 张越 on 2018/9/25.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "OtherPlaceFashionHeaderView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"

@interface OtherPlaceFashionHeaderView ()

@property (nonatomic,strong) UIPageControl *currentPageControl;

@end

@implementation OtherPlaceFashionHeaderView

- (instancetype)initWithObj:(BaseResultObj *)obj{
    
    self = [super init];
    
    if (self) {
        
        [self loadViews];
    }
    return self;
}

- (void) loadViews{
    
    UIScrollView *worldScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                                   0,
                                                                                   WIDTH,
                                                                                   WIDTH/16*9)];
    worldScrollView.pagingEnabled = YES;
    [self addSubview:worldScrollView];
    self.currentPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
                                                                              CGRectGetMaxY(worldScrollView.frame),
                                                                              self.frame.size.width,
                                                                              40*Proportion)];
    self.currentPageControl.currentPage = 0;
    self.currentPageControl.numberOfPages = 3;
    self.currentPageControl.userInteractionEnabled = NO;
    self.currentPageControl.currentPageIndicatorTintColor = [UIColor CMLBrownColor];
    self.currentPageControl.pageIndicatorTintColor = [[UIColor CMLBrownColor] colorWithAlphaComponent:0.3];
    [self addSubview:self.currentPageControl];
    
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = KSystemRealBoldFontSize18;
    titleLab.textColor = [UIColor CMLBlackColor];
    titleLab.text = @"今日焦点";
    [titleLab sizeToFit];
    titleLab.frame = CGRectMake(WIDTH/2.0 - titleLab.frame.size.width/2.0,
                                CGRectGetMaxY(self.currentPageControl.frame) + 30*Proportion,
                                titleLab.frame.size.width,
                                titleLab.frame.size.height);
    [self addSubview:titleLab];
    
    UILabel *descLab = [[UILabel alloc] init];
    descLab.font = KSystemFontSize12;
    descLab.text = @"街力强袭，#经典由你#PUMA SUEDE 50热力持续，再掀潮流话题";
    [descLab sizeToFit];
    descLab.frame = CGRectMake(WIDTH/2.0 - descLab.frame.size.width/2.0, CGRectGetMaxY(titleLab.frame) + 30*Proportion, descLab.frame.size.width, descLab.frame.size.height);
    [self addSubview:descLab];
    
    UIScrollView *todayScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                                   CGRectGetMaxY(descLab.frame) + 54*Proportion,
                                                                                   WIDTH - 30*Proportion*2,
                                                                                   (WIDTH - 30*Proportion*2)/16*9)];
    todayScrollView.pagingEnabled = YES;
    [self addSubview:descLab];
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(todayScrollView.frame) + 40*Proportion,
                                                                  WIDTH,
                                                                  20*Proportion)];
    bottomView.backgroundColor = [UIColor CMLNewUserGrayColor];
    [self addSubview:bottomView];
    
    UILabel *worldTitleLab = [[UILabel alloc] init];
    worldTitleLab.font = KSystemRealBoldFontSize18;
    worldTitleLab.text = @"全球动态";
    [worldTitleLab sizeToFit];
    worldTitleLab.frame = CGRectMake(WIDTH/2.0 - worldTitleLab.frame.size.width/2.0,
                                     60*Proportion + CGRectGetMaxY(bottomView.frame),
                                     worldTitleLab.frame.size.width,
                                     worldTitleLab.frame.size.height);
    [self addSubview:worldTitleLab];
    
    self.frame = CGRectMake(WIDTH/2.0 - worldTitleLab.frame.size.width/2.0,
                            CGRectGetMaxY(worldTitleLab.frame) + 40*Proportion,
                            WIDTH,
                            CGRectGetMaxY(worldTitleLab.frame) + 40*Proportion);
    
}


@end
