//
//  ShowNoUpGradeView.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "ShowNoUpGradeView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "CMLLine.h"
#import "DataManager.h"

@implementation ShowNoUpGradeView

- (instancetype)initWithTag:(int) tag andBgView:(UIView *) view{

    self = [super init];
    
    if (self) {
        
        self.frame = view.bounds;
        self.backgroundColor = [UIColor clearColor];
        
        [self loadViews:tag];
    }
    return self;
}

- (void) loadViews:(int) tag{

    /**控制周边不伸缩*/
    UIImage *bgImage = [[UIImage imageNamed:UpGradeMessageShowBgLongImg] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)
                                                                                        resizingMode:UIImageResizingModeStretch];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0,
                                   0,
                                   690*Proportion,
                                   690*Proportion);
    bgImageView.userInteractionEnabled = YES;
    bgImageView.center = self.center;
    [self addSubview:bgImageView];
    
    UIImageView *topPromImageView = [[UIImageView alloc] init];
    
    if (tag == 1) {
        
        topPromImageView.image = [UIImage imageNamed:UpGradeMessageTopPinkImg];
    }else if(tag == 2){
        
        topPromImageView.image = [UIImage imageNamed:UpGradeMessageTopPigmentImg];
    }else if (tag == 3){
        
        topPromImageView.image = [UIImage imageNamed:UpGradeMessageTopGoldImg];
    }else{
        
        topPromImageView.image = [UIImage imageNamed:UpGradeMessageTopGrayImg];
    }
    
    topPromImageView.contentMode = UIViewContentModeScaleAspectFill;
    [topPromImageView sizeToFit];
    topPromImageView.frame = CGRectMake(bgImageView.frame.size.width/2.0 - topPromImageView.frame.size.width/2.0,
                                        40*Proportion,
                                        topPromImageView.frame.size.width,
                                        topPromImageView.frame.size.height);
    [bgImageView addSubview:topPromImageView];
    
    UILabel *topTitle = [[UILabel alloc] init];
    topTitle.text = @"会员尊享特权";
    topTitle.font = KSystemFontSize12;
    topTitle.textColor = [UIColor CMLtextInputGrayColor];
    [topTitle sizeToFit];
    topTitle.frame = CGRectMake(bgImageView.frame.size.width/2.0 - topTitle.frame.size.width/2.0,
                                CGRectGetMaxY(topPromImageView.frame) + 20*Proportion,
                                topTitle.frame.size.width,
                                topTitle.frame.size.height);
    [bgImageView addSubview:topTitle];
    
    CMLLine *leftLine = [[CMLLine alloc] init];
    leftLine.startingPoint = CGPointMake(topTitle.frame.origin.x - 10*Proportion - 25*Proportion, topTitle.center.y);
    leftLine.lineWidth = 1*Proportion;
    leftLine.lineLength = 25*Proportion;
    leftLine.LineColor = [UIColor CMLtextInputGrayColor];
    leftLine.directionOfLine = HorizontalLine;
    [bgImageView addSubview:leftLine];
    
    CMLLine *rightLine = [[CMLLine alloc] init];
    rightLine.startingPoint = CGPointMake(CGRectGetMaxX(topTitle.frame) + 10*Proportion, topTitle.center.y);
    rightLine.lineWidth = 1*Proportion;
    rightLine.lineLength = 25*Proportion;
    rightLine.LineColor = [UIColor CMLtextInputGrayColor];
    rightLine.directionOfLine = HorizontalLine;
    [bgImageView addSubview:rightLine];
    
    CMLLine *dottedLine = [[CMLLine alloc] init];
    dottedLine.kindOfLine = DottedLine;
    dottedLine.startingPoint = CGPointMake(bgImageView.frame.size.width/2.0 - 530*Proportion/2.0, CGRectGetMaxY(topTitle.frame) + 40*Proportion);
    dottedLine.lineWidth = 1*Proportion;
    dottedLine.lineLength = 530*Proportion;
    dottedLine.LineColor = [UIColor CMLOrangeColor];
    [bgImageView addSubview:dottedLine];
    
    
    
    UILabel *label = [[UILabel alloc] init];
    label.font = KSystemBoldFontSize16;
    label.textColor = [UIColor CMLUserBlackColor];
    if (tag == 1) {
        
        label.text = @"您已经是粉色会员啦，去看看其他等级的特权吧！";
    }else if (tag == 2){
        
        label.text = @"您已经是黛色会员啦，去看看其他等级的特权吧！";
    }else if (tag == 3){
        
        label.text = @"您已经是金色会员啦，去看看其他等级的特权吧！";
    }else{
        
        label.text = @"墨色会员采用邀请制，暂时无法开通，敬请期待！";
    }
    
    if ([[[DataManager lightData] readUserLevel] intValue]== 1) {
    
        
        if (tag == 1) {
            
            label.text = @"您已经是粉色会员啦，去看看其他等级的特权吧！";
        }else if (tag == 4){
        
            label.text = @"墨色会员采用邀请制，暂时无法开通，敬请期待！";
        }
        
    }else if ([[[DataManager lightData] readUserLevel] intValue] == 2){
        
        if (tag == 1 || tag == 2) {
            
            label.text = @"您已经是黛色会员啦，去看看其他等级的特权吧！";
        }else if (tag == 4){
        
            label.text = @"墨色会员采用邀请制，暂时无法开通，敬请期待！";
        }
    
    
    }else if ([[[DataManager lightData] readUserLevel] intValue] == 3){
    
        if (tag == 1 || tag == 2 || tag == 3) {
            
            label.text = @"您已经是金色会员啦，去看看其他等级的特权吧！";
        }else{
        
            label.text = @"墨色会员采用邀请制，暂时无法开通，敬请期待！";
        }
    }else{
    
        label.text =  @"您已经是墨色会员啦，去看看其他等级的特权吧！";
        
    }
    
    [label sizeToFit];
    if (label.frame.size.width > 530*Proportion) {
        label.numberOfLines = 0;
        CGRect currentRect = [label.text boundingRectWithSize:CGSizeMake(530*Proportion, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KSystemBoldFontSize16} context:nil];
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(690*Proportion/2.0 - 530*Proportion/2.0,
                                 CGRectGetMaxY(topTitle.frame) + 40*Proportion + 60*Proportion,
                                 530*Proportion,
                                 currentRect.size.height);
        
    }else{
        
        label.frame = CGRectMake(690*Proportion/2.0 - label.frame.size.width/2.0, CGRectGetMaxY(topTitle.frame) + 40*Proportion + 60*Proportion, label.frame.size.width, label.frame.size.height);
    }
    
    [bgImageView addSubview:label];
    
    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(bgImageView.frame.size.width/2.0 - 530*Proportion/2.0,
                                                                  CGRectGetMaxY(label.frame) + 60*Proportion,
                                                                  530*Proportion,
                                                                  68*Proportion)];
    buyBtn.backgroundColor = [UIColor CMLGreeenColor];
    buyBtn.titleLabel.font = KSystemFontSize16;
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn setTitle:@"知道了" forState:UIControlStateNormal];
    buyBtn.layer.cornerRadius = 6*Proportion;
    [bgImageView addSubview:buyBtn];
    [buyBtn addTarget:self action:@selector(hiddenShadow) forControlEvents:UIControlEventTouchUpInside];
    
    bgImageView.frame = CGRectMake(self.frame.size.width/2.0 - 690*Proportion/2.0,
                                   self.frame.size.height/2.0 - (CGRectGetMaxY(buyBtn.frame) + 60*Proportion)/2.0,
                                   690*Proportion,
                                   CGRectGetMaxY(buyBtn.frame) + 60*Proportion);

}

- (void) hiddenShadow{

    [self.delegate dissmissCurrentUpGradeView];
}
@end
