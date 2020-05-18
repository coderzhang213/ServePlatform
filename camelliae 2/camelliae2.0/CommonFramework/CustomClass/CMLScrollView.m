//
//  CMLScrollView.m
//  testOfTableView
//
//  Created by 张越 on 16/5/19.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLScrollView.h"
#import "NetWorkTask.h"
#import "UIColor+SDExspand.h"
#import "UIColor+SDExspand.h"
#import "CommonNumber.h"
#import "CMLPageControl.h"
#import "ZXCycleScrollView.h"
#import "RollView.h"

@interface CMLScrollView ()<UIScrollViewDelegate,ZXCycleScrollViewDelegate,RollViewDelegate>

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) ZXCycleScrollView *scrollView;

@property (nonatomic,strong)UIPageControl *currentPageControl;

@property (nonatomic,strong) RollView *rollView;

@end

@implementation CMLScrollView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor CMLWhiteColor];
    
    }
    return self;
}


- (void) refreshCurrentView{
    
    self.rollView = [[RollView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               WIDTH, self.frame.size.height - 40*Proportion)
                              withDistanceForScroll:30*Proportion
                                            withGap:20*Proportion];
    
    self.rollView.backgroundColor = [UIColor CMLWhiteColor];
    self.rollView.delegate = self;
    self.rollView.radius = 30*Proportion;
    [self.rollView rollView:self.imagesUrlArray];
    [self addSubview:self.rollView];
        
    self.currentPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
                                                                              CGRectGetMaxY(self.rollView.frame),
                                                                              self.frame.size.width,
                                                                              40*Proportion)];
    self.currentPageControl.currentPage = 0;
    self.currentPageControl.numberOfPages = (int)self.imagesUrlArray.count;
    self.currentPageControl.userInteractionEnabled = NO;
    self.currentPageControl.currentPageIndicatorTintColor = [UIColor CMLBrownColor];
    self.currentPageControl.pageIndicatorTintColor = [[UIColor CMLBrownColor] colorWithAlphaComponent:0.3];
    [self addSubview:self.currentPageControl];
    
}

-(void)didSelectPicWithIndexPath:(NSInteger)index{
 
    [self.delegate selectIndex:index];
}


#pragma mark -- ZXCycleScrollViewDelegate
- (void) scrollX:(CGFloat) x{

    int index = x/WIDTH;
    if (x == 0) {
        
        self.currentPageControl.currentPage = 0;
    }else{
        
        self.currentPageControl.currentPage = index + 1;
    }
    

}




@end
