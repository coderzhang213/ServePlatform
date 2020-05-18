//
//  CMLPageControl.m
//  transitionOfViewController
//
//  Created by 张越 on 2016/10/10.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLPageControl.h"

@interface CMLPageControl ()

@property (nonatomic,strong) UIView *bgView;



@end

@implementation CMLPageControl

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self loadViews];
    }
    return self;
}

- (void) loadViews{

    self.backgroundColor = [UIColor clearColor];
    self.bgView = [[UIView alloc] initWithFrame:self.bounds];
    self.bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgView];
}

- (void) initPageControl{

}
- (void)drawRect:(CGRect)rect {
    
    if (self.bgView.subviews.count == 0) {

        CGFloat leftMargin = (self.frame.size.width - self.pageLineWidth*self.pageNum - self.pageLineSpace*(self.pageNum - 1))/2.0;
        
        for (int i = 0 ; i < self.pageNum; i++) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake( leftMargin + (self.pageLineSpace + self.pageLineWidth)*i,
                                                                    self.frame.size.height/2.0 - 2/2.0,
                                                                    _pageLineWidth,
                                                                    2)];
            view.tag = i+1;
            if (i == 0) {
                view.backgroundColor = self.selectColor;
            }else{
                view.backgroundColor = self.otherColor;
                view.alpha = 0.3;
            }
            
            [self.bgView addSubview:view];
        }

    }
}

- (void) refreshPageControl:(int) index{
    
    [self.bgView removeFromSuperview];

    self.bgView = [[UIView alloc] initWithFrame:self.bounds];
    self.bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgView];
    
    CGFloat leftMargin = (self.frame.size.width - self.pageLineWidth*self.pageNum - self.pageLineSpace*(self.pageNum - 1))/2.0;
    
    for (int i = 0 ; i < self.pageNum; i++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake( leftMargin + (self.pageLineSpace + self.pageLineWidth)*i,
                                                                self.frame.size.height/2.0 - 2/2.0,
                                                                _pageLineWidth,
                                                                2)];
        view.tag = i+1;
        if (i == index) {
            view.backgroundColor = self.selectColor;
        }else{
            view.backgroundColor = self.otherColor;
            view.alpha = 0.3;
        }
        
        [self.bgView addSubview:view];
    }

}
@end
