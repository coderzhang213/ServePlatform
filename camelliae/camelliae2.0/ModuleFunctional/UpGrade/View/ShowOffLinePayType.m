//
//  ShowOffLinePayType.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "ShowOffLinePayType.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "CommonImg.h"
#import "UIColor+SDExspand.h"
#import "NSString+CMLExspand.h"
#import "CMLLine.h"

@implementation ShowOffLinePayType

- (instancetype)initWithTag:(int) tag andBgView:(UIView *) bgView andTele:(NSString *)tele{

    self = [super init];
    if (self) {
        
        self.frame = bgView.bounds;
        self.backgroundColor = [UIColor clearColor];
        
        [self loadViewsWithTag:tag andBgView:bgView andTele:tele];
    }
    return self;
}

- (void) loadViewsWithTag:(int) tag andBgView:(UIView *) bgView andTele:(NSString *) tele{

    /**控制周边不伸缩*/
    UIImage *bgImage = [[UIImage imageNamed:UpGradeMessageShowBgLongImg] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)
                                                                                        resizingMode:UIImageResizingModeStretch];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.userInteractionEnabled = YES;
    [bgImageView sizeToFit];
    bgImageView.frame = CGRectMake(0,
                                   0,
                                   690*Proportion,
                                   690*Proportion);
    bgImageView.center = self.center;
    [self addSubview:bgImageView];
    
    UIImageView *topPromImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:UpGradeMessageTopGoldImg]];
    if (tag == 2) {
        topPromImageView.image = [UIImage imageNamed:UpGradeMessageTopPigmentImg];
    }else{
        topPromImageView.image = [UIImage imageNamed:UpGradeMessageTopGoldImg];
    }
    topPromImageView.contentMode = UIViewContentModeScaleAspectFill;
    [topPromImageView sizeToFit];
    topPromImageView.frame = CGRectMake(bgImageView.frame.size.width/2.0 - topPromImageView.frame.size.width/2.0,
                                        40*Proportion,
                                        topPromImageView.frame.size.width,
                                        topPromImageView.frame.size.height);
    [bgImageView addSubview:topPromImageView];
    
    UILabel *topTitle = [[UILabel alloc] init];
    if (tag == 2) {
        
        topTitle.text = @"购买黛色特权";
    }else{
        
        topTitle.text = @"购买金色特权";
    }
    
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
    dottedLine.startingPoint = CGPointMake(bgImageView.frame.size.width/2.0 - 530*Proportion/2.0, CGRectGetMaxY(topTitle.frame) + 20*Proportion);
    dottedLine.lineWidth = 1*Proportion;
    dottedLine.lineLength = 530*Proportion;
    dottedLine.LineColor = [UIColor CMLOrangeColor];
    [bgImageView addSubview:dottedLine];
    
    UILabel *telePromLabel = [[UILabel alloc] init];
    telePromLabel.text = @"客服电话";
    telePromLabel.font = KSystemBoldFontSize16;
    telePromLabel.textColor = [UIColor CMLUserBlackColor];
    [telePromLabel sizeToFit];
    telePromLabel.frame = CGRectMake(690*Proportion/2.0 - telePromLabel.frame.size.width/2.0,
                                     CGRectGetMaxY(topTitle.frame) + 20*Proportion + 40*Proportion,
                                     telePromLabel.frame.size.width,
                                     telePromLabel.frame.size.height);
    [bgImageView addSubview:telePromLabel];
    
    UILabel *teleLabel = [[UILabel alloc] init];
    teleLabel.textColor = [UIColor CMLUserBlackColor];
    teleLabel.font = KSystemBoldFontSize16;
    teleLabel.text = tele;
    [teleLabel sizeToFit];
    teleLabel.frame = CGRectMake(690*Proportion/2.0 - teleLabel.frame.size.width/2.0,
                                 CGRectGetMaxY(telePromLabel.frame) + 20*Proportion,
                                 teleLabel.frame.size.width,
                                 teleLabel.frame.size.height);
    [bgImageView addSubview:teleLabel];
    
    UILabel *wayPromLabel = [[UILabel alloc] init];
    wayPromLabel.font = KSystemBoldFontSize12;
    wayPromLabel.textColor = [UIColor CMLLineGrayColor];
    wayPromLabel.text  = @"（线下支付用户请联系我们的客服人员）";
    [wayPromLabel sizeToFit];
    wayPromLabel.frame = CGRectMake(690*Proportion/2.0 - wayPromLabel.frame.size.width/2.0,
                                    CGRectGetMaxY(teleLabel.frame) + 40*Proportion,
                                    wayPromLabel.frame.size.width,
                                    wayPromLabel.frame.size.height);
    [bgImageView addSubview:wayPromLabel];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(80*Proportion,
                                                                     CGRectGetMaxY(wayPromLabel.frame) + 60*Proportion,
                                                                     192*Proportion,
                                                                     68*Proportion)];
    cancelBtn.titleLabel.font = KSystemFontSize12;
    [cancelBtn setTitleColor:[UIColor CMLLineGrayColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"暂不联系" forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor CMLNewGrayColor];
    [bgImageView addSubview:cancelBtn];
    cancelBtn.layer.cornerRadius = 4*Proportion;
    [cancelBtn addTarget:self action:@selector(hiddenShadow) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *callBtn = [[UIButton alloc] initWithFrame:CGRectMake(690*Proportion- 80*Proportion - 192*Proportion,
                                                                   CGRectGetMaxY(wayPromLabel.frame) + 60*Proportion,
                                                                   192*Proportion,
                                                                   68*Proportion)];
    callBtn.titleLabel.font = KSystemFontSize12;
    [callBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
    [callBtn setTitle:@"立即联系" forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(startCall) forControlEvents:UIControlEventTouchUpInside];
    callBtn.backgroundColor = [UIColor CMLGreeenColor];
    callBtn.tag = tag;
    [bgImageView addSubview:callBtn];
    callBtn.layer.cornerRadius = 4*Proportion;
    
    bgImageView.frame = CGRectMake(self.frame.size.width/2.0 - 690*Proportion/2.0,
                                   self.frame.size.height/2.0 - (CGRectGetMaxY(callBtn.frame) + 80*Proportion)/2.0,
                                   690*Proportion,
                                   CGRectGetMaxY(callBtn.frame) + 60*Proportion);

}

- (void) hiddenShadow{

    [self.delegate cancelCallUser];
}

- (void) startCall{

     [self.delegate callUser];
}
@end
