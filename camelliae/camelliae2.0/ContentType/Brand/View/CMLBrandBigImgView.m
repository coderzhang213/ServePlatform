//
//  CMLBrandBigImgView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/29.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLBrandBigImgView.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NetWorkTask.h"
#import "CommonImg.h"
#import "VCManger.h"
#import "UIColor+SDExspand.h"

@interface CMLBrandBigImgView(){
    
}

@end

@implementation CMLBrandBigImgView

- (instancetype)initWithImageUrl:(NSString *)url andDetailMes:(NSString *)mes LogoImageUrl:(NSString *) logoUrl{
    
    self = [super init];
    
    if (self) {
        
        self.frame = CGRectMake(0,
                                0,
                                WIDTH,
                                HEIGHT);
        [self loadViewsWithBigUrl:url andDetail:mes andLogoUrl:logoUrl];
    }
    
    return self;
}

- (void) loadViewsWithBigUrl:(NSString *) bgImgUrl andDetail:(NSString *) mes andLogoUrl:(NSString *) logoUrl{
    
    
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       WIDTH,
                                                                       HEIGHT)];
    bgImg.backgroundColor = [UIColor CMLNewGrayColor];
    bgImg.clipsToBounds = YES;
    bgImg.userInteractionEnabled = YES;
    bgImg.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:bgImg];
    
    UIView *shaDowView = [[UIView alloc] initWithFrame:bgImg.bounds];
    shaDowView.backgroundColor = [[UIColor CMLBlackColor] colorWithAlphaComponent:0.3];
    [bgImg addSubview:shaDowView];
    
    [NetWorkTask setImageView:bgImg WithURL:bgImgUrl placeholderImage:nil];
    
    UIButton *scrollBtn = [[UIButton alloc] init];
    scrollBtn.backgroundColor = [UIColor clearColor];
    [scrollBtn setImage:[UIImage imageNamed:DownPromImg] forState:UIControlStateNormal];
    [scrollBtn sizeToFit];
    scrollBtn.frame = CGRectMake(WIDTH/2.0 - scrollBtn.frame.size.width/2.0,
                                 HEIGHT - 50*Proportion - scrollBtn.frame.size.height - SafeAreaBottomHeight,
                                 scrollBtn.frame.size.width,
                                 scrollBtn.frame.size.height);
    [self addSubview:scrollBtn];
    [scrollBtn addTarget:self action:@selector(scroll) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *detailLab = [[UILabel alloc] init];
    detailLab.backgroundColor = [UIColor clearColor];
    detailLab.textColor = [UIColor CMLWhiteColor];
    detailLab.textAlignment = NSTextAlignmentCenter;
    detailLab.font = KSystemFontSize13;
    detailLab.numberOfLines = 0;
    detailLab.text= mes;
    CGRect currentRect = [detailLab.text boundingRectWithSize:CGSizeMake(WIDTH - 80*Proportion*2, HEIGHT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:KSystemFontSize13}
                                                      context:nil];
    detailLab.frame = CGRectMake(80*Proportion,
                                 HEIGHT - scrollBtn.frame.size.height - 50*Proportion*2 - currentRect.size.height - SafeAreaBottomHeight,
                                 WIDTH - 80*Proportion*2,
                                 currentRect.size.height);
    [self addSubview:detailLab];
    
    
    UIView *logobgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2.0 - 150*Proportion/2.0,
                                                                  HEIGHT - detailLab.frame.size.height - scrollBtn.frame.size.height - 20*Proportion - 50*Proportion*2 - 150*Proportion - SafeAreaBottomHeight,
                                                                  150*Proportion,
                                                                  150*Proportion)];
    logobgView.backgroundColor = [UIColor CMLWhiteColor];
    logobgView.layer.cornerRadius = 150*Proportion/2.0;
    [self addSubview:logobgView];
    
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(5*Proportion,
                                                                         5*Proportion,
                                                                         140*Proportion,
                                                                         140*Proportion)];
    logoImg.clipsToBounds = YES;
    logoImg.contentMode = UIViewContentModeScaleAspectFill;
    logoImg.backgroundColor = [UIColor CMLNewGrayColor];
    logoImg.layer.cornerRadius = 140*Proportion/2.0;
    logoImg.layer.borderWidth = 1*Proportion;
    logoImg.layer.borderColor = [UIColor CMLBlackColor].CGColor;
    [logobgView addSubview:logoImg];
    [NetWorkTask setImageView:logoImg WithURL:logoUrl placeholderImage:nil];
    
    UIButton *backbtn = [[UIButton alloc] init];
    [backbtn setImage:[UIImage imageNamed:GoodsBackImg] forState:UIControlStateNormal];
    [backbtn sizeToFit];
    backbtn.backgroundColor = [UIColor clearColor];
    backbtn.frame =CGRectMake(0,
                              StatusBarHeight,
                              NavigationBarHeight,
                              NavigationBarHeight);
    [self addSubview:backbtn];
    
    [backbtn addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
}

- (void) scroll{
    
    [self.delegate clearBrandBigImgView];
}

- (void) backVC{
    
    [[VCManger mainVC]dismissCurrentVC];
}
@end
