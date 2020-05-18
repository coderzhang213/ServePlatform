//
//  CMLNavigationBar.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/25.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLNavigationBar.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "CMLLine.h"

@interface CMLNavigationBar ()

@end

@implementation CMLNavigationBar

- (instancetype)init{

    self = [super init];
    if (self) {
        self.frame = CGRectMake(0,
                                0,
                                WIDTH,
                                NavigationBarHeight + StatusBarHeight);
        self.backgroundColor = [UIColor clearColor];

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                WIDTH - NavigationBarHeight*2,
                                                                20)];
        [self addSubview:view];
        
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               StatusBarHeight,
                                                               WIDTH,
                                                               NavigationBarHeight)];
        self.bgView.backgroundColor = [UIColor clearColor];
//        self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.bgView.layer.shadowOpacity = 0.05;
//        self.bgView.layer.shadowOffset = CGSizeMake(0, 2);
        [self addSubview:self.bgView];
        
        self.bottomLine = [[CMLLine alloc] init];
        self.bottomLine.lineWidth = 2*Proportion;
        self.bottomLine.lineLength = WIDTH;
        self.bottomLine.LineColor = [UIColor CMLNewGrayColor];
        self.bottomLine.startingPoint = CGPointMake(0, NavigationBarHeight - 2*Proportion);
        [self.bgView addSubview:self.bottomLine];
        
        
        UITapGestureRecognizer *doubleRecognizer;
        doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom)];
        doubleRecognizer.numberOfTapsRequired = 2; /*双击*/
        [view addGestureRecognizer:doubleRecognizer];
    }
    return self;
}

- (void) hiddenLine{

    self.bottomLine.hidden = YES;
}
- (void)layoutSubviews{

    [super layoutSubviews];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = self.titleContent;
    self.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel sizeToFit];
    if (self.titleLabel.frame.size.width > ([UIScreen mainScreen].bounds.size.width - NavigationBarHeight*2)) {

        self.titleLabel.font = KSystemBoldFontSize15;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.frame = CGRectMake(WIDTH/2.0 - (WIDTH - NavigationBarHeight*2)/2.0,
                                      NavigationBarHeight/2.0 - (self.titleLabel.frame.size.height*2)/2.0,
                                      WIDTH - NavigationBarHeight*2,
                                      self.titleLabel.frame.size.height*2);

    }else{

        self.titleLabel.frame = CGRectMake(WIDTH/2.0 - (WIDTH - NavigationBarHeight*2)/2.0,
                                      NavigationBarHeight/2.0 - self.titleLabel.frame.size.height/2.0 ,
                                      WIDTH - NavigationBarHeight*2,
                                      self.titleLabel.frame.size.height);

    }
    
    if (!self.titleColor) {
        self.titleLabel.textColor = [UIColor CMLBlack2D2D2DColor];
    }else{
        self.titleLabel.textColor = self.titleColor;
    }
    
    [self.bgView addSubview:self.titleLabel];
    self.bgView.backgroundColor = self.backgroundColor;
}

- (void) setLeftBarItem{
   
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   NavigationBarHeight,
                                                                   NavigationBarHeight)];
    [leftBtn setImage:[UIImage imageNamed:NavcBackBtnImg] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(dismissCurrentVController) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:leftBtn];

}

- (void) setWhiteLeftBarItem{

    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   NavigationBarHeight,
                                                                   NavigationBarHeight)];
    [leftBtn setImage:[UIImage imageNamed:VIPBackImg] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(dismissCurrentVController) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:leftBtn];
    
}

- (void) setYellowLeftBarItem{
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   NavigationBarHeight,
                                                                   NavigationBarHeight)];
    [leftBtn setImage:[UIImage imageNamed:BackBtnImg] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(dismissCurrentVController) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:leftBtn];

}

- (void) setCloseBarItem{

    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   NavigationBarHeight,
                                                                   NavigationBarHeight)];
    [leftBtn setImage:[UIImage imageNamed:ImageCloseBtnImg] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(dismissCurrentVController) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:leftBtn];

}

- (void) setSettingBarItem{

    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   NavigationBarHeight,
                                                                   NavigationBarHeight)];
    [leftBtn setImage:[UIImage imageNamed:PersonalCenterSettingImg] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(dismissCurrentVController) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:leftBtn];

}

- (void) setBlackCloseBarItem{

    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   NavigationBarHeight,
                                                                   NavigationBarHeight)];
    [leftBtn setImage:[UIImage imageNamed:CloseImg] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(dismissCurrentVController) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:leftBtn];

}

- (void) setRightBarItemWith:(NSString *) title{

    UIButton *titleBtn = [[UIButton alloc] init];
    [titleBtn setTitle:title forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor CMLYellowColor] forState:UIControlStateNormal];
    titleBtn.titleLabel.font = KSystemBoldFontSize15;
    [titleBtn sizeToFit];
    titleBtn.frame = CGRectMake(self.frame.size.width - titleBtn.frame.size.width - 20,
                                0,
                                titleBtn.frame.size.width +20,
                                NavigationBarHeight);
    [titleBtn addTarget:self action:@selector(determineChoose) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:titleBtn];
    [self.bgView bringSubviewToFront:titleBtn];
    
}

- (void)setCouponRightBarItemWith:(NSString *)title {
    
    UIButton *titleBtn = [[UIButton alloc] init];
    [titleBtn setTitle:title forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    titleBtn.titleLabel.font = KSystemBoldFontSize15;
    [titleBtn sizeToFit];
    titleBtn.frame = CGRectMake(self.frame.size.width - titleBtn.frame.size.width - 20,
                                0,
                                titleBtn.frame.size.width +20,
                                NavigationBarHeight);
    [titleBtn addTarget:self action:@selector(determineChoose) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:titleBtn];
    [self.bgView bringSubviewToFront:titleBtn];

    
}

- (void)setCancelBarItem{
    
}

- (void)setRightBarItem{
    

}

- (void) setCertainBarItem{

    

}

- (void)setRightShareBarItem {
 
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - NavigationBarHeight,
                                                                    0,
                                                                    NavigationBarHeight,
                                                                    NavigationBarHeight)];
    [shareBtn setImage:[UIImage imageNamed:CMLMemberInvitationShareImage] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(determineChoose) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:shareBtn];
    
}

- (void) setShareBarItem{
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - NavigationBarHeight,
                                                                    0,
                                                                    NavigationBarHeight,
                                                                    NavigationBarHeight)];
    [shareBtn setImage:[UIImage imageNamed:NavBarShareImg] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(determineChoose) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:shareBtn];

}

- (void) setNewShareBarItem{

    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - NavigationBarHeight,
                                                                    0,
                                                                    NavigationBarHeight,
                                                                    NavigationBarHeight)];
    [shareBtn setImage:[UIImage imageNamed:DetailMessageShareImg] forState:UIControlStateNormal];
    shareBtn.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview:shareBtn];
    [shareBtn addTarget:self action:@selector(determineChoose) forControlEvents:UIControlEventTouchUpInside];
}

- (void) setBlackShareBarItem{
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - NavigationBarHeight,
                                                                    0,
                                                                    NavigationBarHeight,
                                                                    NavigationBarHeight)];
    [shareBtn setImage:[UIImage imageNamed:ShareBtnImg] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(determineChoose) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:shareBtn];
    
}
#pragma mark - dismissCurrentVC

- (void) dismissCurrentVController{

    if ([self.delegate respondsToSelector:@selector(didSelectedLeftBarItem)]) {
        [self.delegate didSelectedLeftBarItem];
    }
}

#pragma mark - determineChoose

- (void) determineChoose{

    if ([self.delegate respondsToSelector:@selector(didSelectedRightBarItem)]) {
        [self.delegate didSelectedRightBarItem];
    }

}

#pragma mark- handleDoubleTapFrom
- (void) handleDoubleTapFrom{
    
    if ([self.delegate respondsToSelector:@selector(scrollViewScrollToTop)]) {
        [self.delegate scrollViewScrollToTop];
    }
    
}
@end
