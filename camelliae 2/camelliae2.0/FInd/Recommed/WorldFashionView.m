//
//  WorldFashionView.m
//  camelliae2.0
//
//  Created by 张越 on 2018/9/18.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "WorldFashionView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "VCManger.h"

@interface WorldFashionView()

@end

@implementation WorldFashionView

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
       
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = KSystemRealBoldFontSize18;
    titleLab.text = @"全球时尚";
    [titleLab sizeToFit];
    titleLab.frame = CGRectMake(WIDTH/2.0 - titleLab.frame.size.width/2.0,
                                46*Proportion,
                                titleLab.frame.size.width,
                                titleLab.frame.size.height);
    [self addSubview:titleLab];
    
    UILabel *descLab = [[UILabel alloc] init];
    descLab.font = KSystemBoldFontSize12;
    descLab.text = @"为你收集全球最in动态与活动";
    [descLab sizeToFit];
    descLab.frame = CGRectMake(WIDTH/2.0 - descLab.frame.size.width/2.0,
                               CGRectGetMaxY(titleLab.frame) + 30*Proportion,
                               descLab.frame.size.width,
                               descLab.frame.size.height);
    [self addSubview:descLab];
    
    UIImageView *worldImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:WorldFashionMapImg]];
    worldImg.contentMode = UIViewContentModeScaleAspectFill;
    [worldImg sizeToFit];
    worldImg.userInteractionEnabled = YES;
    worldImg.frame = CGRectMake(0, CGRectGetMaxY(descLab.frame) + 30*Proportion,
                                WIDTH,
                                WIDTH/worldImg.frame.size.width*worldImg.frame.size.height);
    [self addSubview:worldImg];
    

    
    UIButton *btn = [[UIButton alloc] init];
    [btn addTarget:self action:@selector(showWOrldFashion) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = worldImg.frame;
    [self addSubview:btn];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(btn.frame) + 40*Proportion,
                                                                  WIDTH,
                                                                  20*Proportion)];
    bottomView.backgroundColor = [UIColor CMLNewUserGrayColor];
    [self addSubview:bottomView];
    
    self.currentHeight = CGRectGetMaxY(bottomView.frame);
    
}

- (void) showWOrldFashion{
    
     [[VCManger homeVC] showCurrentViewController:homeActivityTag];
}
@end
