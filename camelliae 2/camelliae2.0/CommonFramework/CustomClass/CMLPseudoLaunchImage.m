//
//  CMLPseudoLaunchImage.m
//  camelliae2.0
//
//  Created by 张越 on 16/5/26.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLPseudoLaunchImage.h"
#import "CommonNumber.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "CMLLine.h"
#import "DataManager.h"
#import "NetWorkTask.h"

#define StartBtnBottomMargin  160
#define LaunchLabelTopMargin  870
#define LaunchLabelAndLineSpace 20
#define PageControlBottomMargin 80
@interface CMLPseudoLaunchImage ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,strong) UIView *pageOne;

@property (nonatomic,strong) UIView *pageTwo;

@property (nonatomic,strong) UIView *pageThree;

//@property (nonatomic,strong) UIView *pageFour;

@property (nonatomic,strong) UIPageControl *basePageControl;


@end

@implementation CMLPseudoLaunchImage

- (instancetype)initWithImage:(UIImage *)image{

    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;//显示原图片大小
        _imageView.center = self.center;
        _imageView.image = image;
        
    }
    return self;
}

- (void) showLeadView{
    
    /**虚拟加载页*/
    [self addSubview:_imageView];
    
    
//    _pageFour = [[UIView alloc] initWithFrame:CGRectMake(0,
//                                                          0,
//                                                          WIDTH,
//                                                          HEIGHT)];
//    _pageFour.backgroundColor = [UIColor whiteColor];
//
//    UIImageView *imageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:LeadFourPageImg]];
//    [imageView4 sizeToFit];
//    imageView4.contentMode = UIViewContentModeScaleAspectFill;
//    imageView4.clipsToBounds = YES;
//    imageView4.frame = CGRectMake(0,
//                                  0,
//                                  WIDTH,
//                                  HEIGHT);
//    [_pageFour addSubview:imageView4];
//
//    [self addSubview:_pageFour];
    
    
    _pageThree = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                          0,
                                                          WIDTH,
                                                          HEIGHT)];
    _pageThree.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:LeadThreePageImg]];
    [imageView3 sizeToFit];
    imageView3.contentMode = UIViewContentModeScaleAspectFill;
    imageView3.clipsToBounds = YES;
    imageView3.frame = CGRectMake(0,
                                  0,
                                  WIDTH,
                                  HEIGHT);
    [_pageThree addSubview:imageView3];
    
    [self addSubview:_pageThree];
    
    
    
    _pageTwo = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                        0,
                                                        WIDTH,
                                                        HEIGHT)];
    _pageTwo.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:LeadTwoPageImg]];
    [imageView2 sizeToFit];
    imageView2.contentMode = UIViewContentModeScaleAspectFill;
    imageView2.clipsToBounds = YES;
    imageView2.frame = CGRectMake(0,
                                  0,
                                  WIDTH,
                                  HEIGHT);
    [_pageTwo addSubview:imageView2];
    
    [self addSubview:_pageTwo];
    
    _pageOne = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                        0,
                                                        WIDTH,
                                                        HEIGHT)];
    _pageOne.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:LeadOnePageImg]];
    [imageView1 sizeToFit];
    imageView1.contentMode = UIViewContentModeScaleAspectFill;
    imageView1.clipsToBounds = YES;
    imageView1.frame = CGRectMake(0,
                                  0,
                                  WIDTH,
                                  HEIGHT);
    [_pageOne addSubview:imageView1];
    
    [self addSubview:_pageOne];
    

    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     WIDTH,
                                                                     HEIGHT)];
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.bouncesZoom = NO;
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    _mainScrollView.contentSize = CGSizeMake(3*WIDTH, HEIGHT);
    [self addSubview:_mainScrollView];
    
    self.basePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
                                                                           HEIGHT - 60*Proportion  - SafeAreaBottomHeight,
                                                                           WIDTH,
                                                                           20*Proportion)];
    self.basePageControl.backgroundColor = [UIColor clearColor];
    self.basePageControl.pageIndicatorTintColor = [[UIColor CMLBlackColor] colorWithAlphaComponent:0.3];
    self.basePageControl.currentPageIndicatorTintColor = [UIColor CMLBlackColor];
    self.basePageControl.numberOfPages = 3;
    [self addSubview:self.basePageControl];
    
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:LeadBtnImg] forState:UIControlStateNormal];
    [button sizeToFit];
    button.frame = CGRectMake(WIDTH*2 +WIDTH/2.0 - button.frame.size.width/2.0,
                              HEIGHT - 100*Proportion - button.frame.size.height - SafeAreaBottomHeight,
                              button.frame.size.width,
                              button.frame.size.height);    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = KSystemFontSize14;
    [_mainScrollView addSubview:button];
    [button addTarget:self action:@selector(enterMainVC) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) showHypotheticalView{

    [self addSubview:_imageView];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.x <= [UIScreen mainScreen].bounds.size.width) {
        _pageOne.alpha = 1 - scrollView.contentOffset.x/WIDTH;
        
    }else if ((scrollView.contentOffset.x >= WIDTH) &&(scrollView.contentOffset.x <= 2*WIDTH)){
        _pageTwo.alpha = 1 - (scrollView.contentOffset.x - WIDTH) /WIDTH;
        
    }else if ((scrollView.contentOffset.x >= WIDTH*2) &&(scrollView.contentOffset.x <= 3*WIDTH)){
        _pageThree.alpha = 1 - (scrollView.contentOffset.x - WIDTH*2) /WIDTH;
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x/self.frame.size.width == 0) {
        
        self.basePageControl.currentPage = 0;
        
    }else if (scrollView.contentOffset.x/self.frame.size.width == 1){
        

        self.basePageControl.currentPage = 1;
        
    }else if (scrollView.contentOffset.x/self.frame.size.width == 2){
        
        self.basePageControl.hidden = YES;
        self.basePageControl.currentPage = 2;
        
    }
//    else if (scrollView.contentOffset.x/self.frame.size.width == 3){
//
//        self.basePageControl.hidden = YES;
//        self.basePageControl.currentPage = 3;
//
//    }
}

- (void) enterMainVC{
    
    typeof(self) __weak weak = self;
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionLayoutSubviews animations:^{

        weak.pageOne.center = CGPointMake(weak.pageOne.center.x - WIDTH, weak.pageOne.center.y);
        weak.pageTwo.center = CGPointMake(weak.pageTwo.center.x - WIDTH, weak.pageTwo.center.y);
        weak.pageThree.center = CGPointMake(weak.pageThree.center.x - WIDTH, weak.pageThree.center.y);
//        weak.pageFour.center = CGPointMake(weak.pageFour.center.x - WIDTH, weak.pageFour.center.y);
        weak.mainScrollView.center = CGPointMake(weak.mainScrollView.center.x - WIDTH, weak.mainScrollView.center.y);
        
        
    } completion:^(BOOL finished) {
        [weak.pageOne removeFromSuperview];
        [weak.pageTwo removeFromSuperview];
        [weak.pageThree removeFromSuperview];
//         [weak.pageFour removeFromSuperview];
        [weak.mainScrollView removeFromSuperview];

        [weak.delegate startApp];
    }];
    
}

- (void) imageRemoveFromKeyWindow{

    /**需修改*/
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:3.0];
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.autoreverses = NO;
    scaleAnimation.repeatCount = 0;
    scaleAnimation.duration = 1.0f;
    [self.layer addAnimation:scaleAnimation forKey:@"animation1"];
    
    
    typeof(self) __weak weak = self;
    [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionLayoutSubviews animations:^{
        weak.alpha = 0;
    } completion:^(BOOL finished) {
        [weak removeFromSuperview];
    }];
    
}
@end
