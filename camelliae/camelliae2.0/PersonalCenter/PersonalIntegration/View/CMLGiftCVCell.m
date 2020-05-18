//
//  CMLGiftCVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2017/8/22.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLGiftCVCell.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "NetWorkTask.h"
#import "UIColor+SDExspand.h"
#import "CMLIntegrationGiftObj.h"
#import "CommonImg.h"


#define GoodsImageWIdthAndHeight   240

@interface CMLGiftCVCell ()

@property (nonatomic,strong) UIImageView *goodsImg;

@property (nonatomic,strong) UILabel *goodsNameLab;

@property (nonatomic,strong) UILabel *goodsPriceLab;

@property (nonatomic,strong) UIButton *goodsPointsBtn;

@end

@implementation CMLGiftCVCell

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
     
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{

    
    self.goodsImg = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH/2.0 - 30*Proportion)/2.0 - GoodsImageWIdthAndHeight*Proportion/2.0,
                                                                  50*Proportion,
                                                                  GoodsImageWIdthAndHeight*Proportion,
                                                                  GoodsImageWIdthAndHeight*Proportion)];
    self.goodsImg.backgroundColor = [UIColor CMLNewGrayColor];
    self.goodsImg.contentMode = UIViewContentModeScaleAspectFill;
    self.goodsImg.clipsToBounds = YES;
    [self addSubview:self.goodsImg];

    
    self.goodsNameLab = [[UILabel alloc] init];
    self.goodsNameLab.font = KSystemFontSize14;
    self.goodsNameLab.textColor = [UIColor CMLBlackColor];
    self.goodsNameLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.goodsNameLab];
    
    self.goodsPriceLab = [[UILabel alloc] init];
    self.goodsPriceLab.font = KSystemFontSize13;
    self.goodsPriceLab.textColor = [UIColor CMLBlackColor];
    self.goodsPriceLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.goodsPriceLab];
    
    self.goodsPointsBtn = [[UIButton alloc] init];
    self.goodsPointsBtn.layer.borderWidth = 1;
    self.goodsPointsBtn.layer.borderColor = [UIColor CMLBrownColor].CGColor;
    self.goodsPointsBtn.titleLabel.font = KSystemFontSize16;
    [self addSubview:self.goodsPointsBtn];
}

- (void) refreshCurrentCellWith:(CMLIntegrationGiftObj *) obj{

    [NetWorkTask setImageView:self.goodsImg WithURL:obj.coverPicThumb placeholderImage:nil];
    self.goodsNameLab.text = obj.shortTitle;
    [self.goodsNameLab sizeToFit];
    self.goodsNameLab.frame = CGRectMake(20*Proportion,
                                         CGRectGetMaxY(self.goodsImg.frame) + 20*Proportion,
                                         (WIDTH/2.0 - 30*Proportion) - 20*Proportion*2,
                                         self.goodsNameLab.frame.size.height);
    
    self.goodsPriceLab.text = obj.marketPriceStr;
    [self.goodsPriceLab sizeToFit];
    self.goodsPriceLab.frame = CGRectMake(20*Proportion,
                                          CGRectGetMaxY(self.goodsNameLab.frame) + 52*Proportion,
                                          (WIDTH/2.0 - 30*Proportion) - 20*Proportion*2,
                                          self.goodsPriceLab.frame.size.height);
    
    [self.goodsPointsBtn setTitle:[NSString stringWithFormat:@"%@",obj.point] forState:UIControlStateNormal];
    [self.goodsPointsBtn setImage:[UIImage imageNamed:IntegrationIconImg] forState:UIControlStateNormal];
    [self.goodsPointsBtn setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateNormal];
    self.goodsPointsBtn.frame = CGRectMake((WIDTH/2.0 - 30*Proportion)/2.0 - 240*Proportion/2.0,
                                           CGRectGetMaxY(self.goodsPriceLab.frame) + 30*Proportion,
                                           240*Proportion,
                                           60*Proportion);
    [self.goodsPointsBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,
                                                             10*Proportion,
                                                             0,
                                                             0)];
    [self.goodsPointsBtn setImageEdgeInsets:UIEdgeInsetsMake(0,
                                                             -10*Proportion,
                                                             0,
                                                             0)];
}
@end
