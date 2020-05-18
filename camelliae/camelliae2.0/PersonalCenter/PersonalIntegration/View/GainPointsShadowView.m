//
//  GainPointsShadowView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/8/21.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "GainPointsShadowView.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "CommonImg.h"
#import "UIColor+SDExspand.h"


#define ShowViewHeightAndWidth  500
#define SHowImageTopMargin      50


@interface GainPointsShadowView ()


@property (nonatomic,strong) NSNumber *currentDays;

@property (nonatomic,strong) NSNumber *points;

@end

@implementation GainPointsShadowView

- (instancetype)initWithDays:(NSNumber *) CurrentDays andPoints:(NSNumber *) points{

    self = [super init];
    
    if (self) {
     
        self.currentDays = CurrentDays;
        self.points = points;
        [self loadViews];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void) loadViews{

    UIButton *bgView = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  WIDTH,
                                                                  HEIGHT)];
    bgView.backgroundColor = [[UIColor CMLBlackColor] colorWithAlphaComponent:0.3];
    [self addSubview:bgView];
    [bgView addTarget:self action:@selector(dismissCurrentView) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2.0 - ShowViewHeightAndWidth*Proportion/2.0,
                                                                HEIGHT/2.0 - ShowViewHeightAndWidth*Proportion/2.0,
                                                                ShowViewHeightAndWidth*Proportion,
                                                                ShowViewHeightAndWidth*Proportion)];
    showView.backgroundColor = [UIColor CMLWhiteColor];
    showView.userInteractionEnabled = YES;
    showView.layer.cornerRadius = 30*Proportion;
    [bgView addSubview:showView];
    
    
    UIImageView *showImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IntegraSignInSuccessImg]];
    showImage.backgroundColor = [UIColor clearColor];
    showImage.userInteractionEnabled = YES;
    [showImage sizeToFit];
    showImage.frame = CGRectMake(showView.frame.size.width/2.0 - 200*Proportion/2.0,
                                 SHowImageTopMargin*Proportion,
                                 200*Proportion,
                                 200*Proportion);
    [showView addSubview:showImage];
    
    UILabel *showLab = [[UILabel alloc] init];
    showLab.text = @"签到成功";
    showLab.userInteractionEnabled = YES;
    showLab.textColor = [UIColor CMLBrownColor];
    showLab.font = KSystemFontSize12;
    [showLab sizeToFit];
    showLab.frame = CGRectMake(showView.frame.size.width/2.0 - showLab.frame.size.width/2.0,
                               CGRectGetMaxY(showImage.frame) + 30*Proportion,
                               showLab.frame.size.width,
                               showLab.frame.size.height);
    [showView addSubview:showLab];
    
    UILabel *showPointsLab = [[UILabel alloc] init];
    showPointsLab.userInteractionEnabled = YES;
    showPointsLab.textColor = [UIColor CMLBlackColor];
    showPointsLab.font = KSystemBoldFontSize21;
    if ([self.currentDays intValue]%7 == 0) {
        
        showPointsLab.text = [NSString stringWithFormat:@"额外获得%@积分",self.points];
        
    }else{
    
        showPointsLab.text = [NSString stringWithFormat:@"+%@积分",self.points];
    }
    
    [showPointsLab sizeToFit];
    showPointsLab.frame = CGRectMake(showView.frame.size.width/2.0 - showPointsLab.frame.size.width/2.0,
                                     CGRectGetMaxY(showLab.frame) + 10*Proportion,
                                     showPointsLab.frame.size.width,
                                     showPointsLab.frame.size.height);
    [showView addSubview:showPointsLab];
    
    
    UILabel *currentDaysLab = [[UILabel alloc] init];
    currentDaysLab.userInteractionEnabled = YES;
    currentDaysLab.backgroundColor = [UIColor CMLBlackColor];
    currentDaysLab.textColor = [UIColor CMLWhiteColor];
    currentDaysLab.text = [NSString stringWithFormat:@"已累计签到%@天",self.currentDays];
    currentDaysLab.font = KSystemFontSize12;
    currentDaysLab.textAlignment = NSTextAlignmentCenter;
    currentDaysLab.frame = CGRectMake(showView.frame.size.width/2.0 - 220*Proportion/2.0,
                                      CGRectGetMaxY(showPointsLab.frame) + 42*Proportion,
                                      220*Proportion,
                                      50*Proportion);
    currentDaysLab.layer.cornerRadius = 50*Proportion/2.0;
    currentDaysLab.layer.masksToBounds = YES;
    [showView addSubview:currentDaysLab];
    
    [self performSelector:@selector(dismissCurrentView) withObject:nil afterDelay:3.0];
    
}


- (void) dismissCurrentView{
    
    if (self) {
     
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.alpha = 0;
            
        }completion:^(BOOL finished) {
            
            [weakSelf removeFromSuperview];
            
        }];
    }
    
}
@end
