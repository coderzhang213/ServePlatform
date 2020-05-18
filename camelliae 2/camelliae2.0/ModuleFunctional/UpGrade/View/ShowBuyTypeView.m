//
//  ShowBuyTypeView.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "ShowBuyTypeView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "CMLLine.h"

@implementation ShowBuyTypeView

-(instancetype)initWithBgView:(UIView *)bgView{

    self = [super init];
    if (self) {
        
        self.frame = bgView.bounds;
        self.backgroundColor = [UIColor clearColor];
        
        [self loadViewsWith:bgView];
    }
    return self;
}

- (void) loadViewsWith:(UIView *) bgView{

    /**控制周边不伸缩*/
    UIImage *bgImage = [[UIImage imageNamed:UpGradeMessageShowBgLongImg] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)
                                                                                        resizingMode:UIImageResizingModeStretch];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.frame = CGRectMake(0,
                                   0,
                                   690*Proportion,
                                   690*Proportion);
    bgImageView.center = self.center;
    [self addSubview:bgImageView];
    
    UILabel *topTitle = [[UILabel alloc] init];
    topTitle.text = @"支付方式";
    topTitle.font = KSystemFontSize12;
    topTitle.textColor = [UIColor CMLUserBlackColor];
    [topTitle sizeToFit];
    topTitle.frame = CGRectMake(bgImageView.frame.size.width/2.0 - topTitle.frame.size.width/2.0,
                                50*Proportion,
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
    
    NSArray *payTypeImageArray = @[UpGradeVIPWXPayTypeImg,
                                   UpGradeVIPZFBPayTypeImg,
                                   UpGradeVIPRealPayTypeImg];
    NSArray *payTypeNameArray = @[@"微信支付",
                                  @"支付宝支付",
                                  @"线下支付"];
    for (int i = 0; i < payTypeNameArray.count - 1; i++) {
        
        UIButton *payTypeBgBtn = [[UIButton alloc] initWithFrame:CGRectMake(690*Proportion/2.0 - 600*Proportion/2.0,
                                                                            CGRectGetMaxY(topTitle.frame) + 20*Proportion + 120*Proportion*i,
                                                                            600*Proportion,
                                                                            120*Proportion)];
        payTypeBgBtn.backgroundColor = [UIColor whiteColor];
        payTypeBgBtn.tag = i+1;
        [payTypeBgBtn addTarget:self action:@selector(startPay:) forControlEvents:UIControlEventTouchUpInside];
        [bgImageView addSubview:payTypeBgBtn];
        
        UIImageView *payTypeImage = [[UIImageView alloc] init];
        payTypeImage.image = [UIImage imageNamed:payTypeImageArray[i]];
        payTypeImage.userInteractionEnabled = YES;
        [payTypeImage sizeToFit];
        payTypeImage.frame = CGRectMake(40*Proportion,
                                        120*Proportion/2.0 - payTypeImage.frame.size.height/2.0 + 10*Proportion,
                                        payTypeImage.frame.size.width,
                                        payTypeImage.frame.size.height);
        [payTypeBgBtn addSubview:payTypeImage];
        
        UILabel *payTypeName = [[UILabel alloc] init];
        payTypeName.font = KSystemFontSize14;
        payTypeName.textColor = [UIColor CMLUserBlackColor];
        payTypeName.text = payTypeNameArray[i];
        payTypeName.userInteractionEnabled = YES;
        [payTypeName sizeToFit];
        payTypeName.frame = CGRectMake(CGRectGetMaxX(payTypeImage.frame) + 20*Proportion, 120*Proportion/2.0 - payTypeName.frame.size.height/2.0, payTypeName.frame.size.width, payTypeName.frame.size.height);
        [payTypeBgBtn addSubview:payTypeName];
        
        UIImageView *enterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NewPersonalCenterUserEnterVCImg]];
        [enterImage sizeToFit];
        enterImage.frame = CGRectMake(payTypeBgBtn.frame.size.width - 30*Proportion - enterImage.frame.size.width,
                                      payTypeBgBtn.frame.size.height/2.0 - enterImage.frame.size.height/2.0,
                                      enterImage.frame.size.width,
                                      enterImage.frame.size.height);
        [payTypeBgBtn addSubview:enterImage];
        
        if (i < 2 - 1) {
            
            CMLLine *spaceLine = [[CMLLine alloc] init];
            spaceLine.lineWidth = 1*Proportion;
            spaceLine.lineLength = 600*Proportion;
            spaceLine.LineColor = [UIColor CMLUserGrayColor];
            spaceLine.startingPoint = CGPointMake(0, 120*Proportion -1*Proportion);
            [payTypeBgBtn addSubview:spaceLine];
        }else{
            
            UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(690*Proportion/2.0 - 198*Proportion/2.0, CGRectGetMaxY(payTypeBgBtn.frame) + 40*Proportion - 20 * Proportion + 120 * Proportion, 192*Proportion, 68*Proportion)];
            cancelBtn.titleLabel.font = KSystemFontSize12;
            cancelBtn.backgroundColor = [UIColor CMLNewGrayColor];
            [cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
            [cancelBtn setTitleColor:[UIColor CMLLineGrayColor] forState:UIControlStateNormal];
            [cancelBtn addTarget:self action:@selector(hiddenShadow) forControlEvents:UIControlEventTouchUpInside];
            cancelBtn.layer.cornerRadius = 4*Proportion;
            [bgImageView addSubview:cancelBtn];
        }
    }
}

- (void)startPay:(UIButton *) button{

    [self.delegate selectBuyType:(int)button.tag];
}

- (void)hiddenShadow{

    [self.delegate cancelPay];
}
@end
