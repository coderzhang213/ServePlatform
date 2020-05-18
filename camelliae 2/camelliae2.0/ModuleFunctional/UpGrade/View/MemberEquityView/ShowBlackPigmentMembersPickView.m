//
//  ShowBlackPigmentMembersPickView.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/8.
//  Copyright © 2019 张越. All rights reserved.
//

#import "ShowBlackPigmentMembersPickView.h"

@implementation ShowBlackPigmentMembersPickView

- (instancetype)initWithFrame:(CGRect)frame withVIPImage:(UIImage *)image withTitle:(NSString *)title withPrice:(NSString *)price withIntro:(NSString *)intro
{
    self = [super init];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8 * Proportion;
        self.clipsToBounds = YES;
        [self loadPickViewWithVIPImage:image withTitle:title withPrice:price withIntro:intro];
    }
    return self;
}

- (void)loadPickViewWithVIPImage:(UIImage *)image withTitle:(NSString *)title withPrice:(NSString *)price withIntro:(NSString *)intro {
    
    /*vip图标*/
    UIImageView *vipImage = [[UIImageView alloc] initWithImage:image];
    vipImage.backgroundColor = [UIColor clearColor];
    [vipImage sizeToFit];
    vipImage.frame = CGRectMake(27 * Proportion,
                                27 * Proportion,
                                CGRectGetWidth(vipImage.frame),
                                CGRectGetHeight(vipImage.frame));
    [self addSubview:vipImage];
    
    /*黛色会员标题*/
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = KSystemBoldFontSize15;
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake(CGRectGetMaxX(vipImage.frame) + 7*Proportion,
                                  37 * Proportion,
                                  CGRectGetWidth(titleLabel.frame),
                                  CGRectGetHeight(titleLabel.frame));
    
    [self addSubview:titleLabel];
    
    /*价格*/
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.text = price;
    priceLabel.font = KSystemBoldFontSize21;
    priceLabel.textColor = [UIColor CMLE5C48AColor];
    [priceLabel sizeToFit];
    priceLabel.frame = CGRectMake(CGRectGetWidth(self.frame) - 16*Proportion - CGRectGetWidth(priceLabel.frame),
                                  27 * Proportion,
                                  CGRectGetWidth(priceLabel.frame),
                                  CGRectGetHeight(priceLabel.frame));
    [self addSubview:priceLabel];
    
    /*虚线*/
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(31 * Proportion, CGRectGetMaxY(titleLabel.frame) + 30 * Proportion, CGRectGetWidth(self.frame) - 31 * Proportion - 16 * Proportion, 1*Proportion)];
    [self addBorderToLayer:lineView];
    [self addSubview:lineView];
    
    /*黛色intro*/
    UILabel *introLabel = [[UILabel alloc] init];
    introLabel.text = intro;
    introLabel.font = KSystemFontSize12;
    introLabel.textColor = [UIColor CMLA2A2A2Color];
    [introLabel sizeToFit];
    introLabel.frame = CGRectMake(31 * Proportion,
                                  CGRectGetHeight(self.frame) - 9*Proportion - CGRectGetHeight(introLabel.frame),
                                  CGRectGetWidth(introLabel.frame),
                                  CGRectGetHeight(introLabel.frame));
    [self addSubview:introLabel];
    
}

- (void)addBorderToLayer:(UIView *)view {
    CAShapeLayer *border = [CAShapeLayer layer];
    //  线条颜色
    border.strokeColor = [UIColor CMLNewGrayColor].CGColor;
    
    border.fillColor = nil;
    
    UIBezierPath *pat = [UIBezierPath bezierPath];
    [pat moveToPoint:CGPointMake(0, 0)];
    if (CGRectGetWidth(view.frame) > CGRectGetHeight(view.frame)) {
        [pat addLineToPoint:CGPointMake(view.bounds.size.width, 0)];
    }else{
        [pat addLineToPoint:CGPointMake(0, view.bounds.size.height)];
    }
    border.path = pat.CGPath;
    
    border.frame = view.bounds;
    
    /*不要设太大 不然看不出效果*/
    border.lineWidth = 0.5;
    border.lineCap = @"butt";
    
    /*第一个是 线条长度   第二个是间距    nil时为实线*/
    border.lineDashPattern = @[@3, @3];
    
    [view.layer addSublayer:border];
}


@end
