//
//  CMLGainPointsTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2017/8/17.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLGainPointsTVCell.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"


@interface CMLGainPointsTVCell ()

@property (nonatomic,strong) UIImageView *promImage;

@property (nonatomic,strong) UILabel *typeLab;

@property (nonatomic,strong) UILabel *detailMesLab;

@property (nonatomic,strong) UIButton *touchBtn;

@end

@implementation CMLGainPointsTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    
        [self loadViews];
    }
    
    return self;
}



- (void) loadViews{

    self.promImage = [[UIImageView alloc] init];
    self.promImage.backgroundColor = [UIColor clearColor];
    self.promImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.promImage];
    
    self.typeLab = [[UILabel alloc] init];
    self.typeLab.font = KSystemFontSize14;
    self.typeLab.textColor = [UIColor CMLBlackColor];
    self.typeLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.typeLab];
    
    self.detailMesLab = [[UILabel alloc] init];
    self.detailMesLab.font  = KSystemFontSize11;
    self.detailMesLab.textColor = [UIColor CMLLineGrayColor];
    self.detailMesLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.detailMesLab];
    
    self.touchBtn = [[UIButton alloc] init];
    self.touchBtn.titleLabel.font = KSystemFontSize12;
    [self.contentView addSubview:self.touchBtn];
    [self.touchBtn addTarget:self action:@selector(getPoints) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void) refreshCurrentTVCellWithIndex:(NSInteger) index{

    switch (index) {
        case 0:
            self.promImage.image = [UIImage imageNamed:IntegrationTaskOfInvationImg];
            break;
        case 1:
            self.promImage.image = [UIImage imageNamed:IntegrationTaskOfSignInImg];
            break;
        case 2:
            self.promImage.image = [UIImage imageNamed:IntegrationTaskOfUserMessageImg];
            break;
        case 3:
            self.promImage.image = [UIImage imageNamed:IntegrationTaskOfBookFreeActivityImg];
            break;
        case 4:
            self.promImage.image = [UIImage imageNamed:IntegrationTaskOfBookCostActivityImg];
            break;
        case 5:
            self.promImage.image = [UIImage imageNamed:IntegrationTaskOfBuyGoodsImg];
            break;
        case 6:
            self.promImage.image = [UIImage imageNamed:IntegrationTaskOfAppointmentServeImg];
            break;
            
            
        default:
            break;
    }
    
    [self.promImage sizeToFit];
    self.promImage.frame = CGRectMake(30*Proportion,
                                      140*Proportion/2.0 - self.promImage.frame.size.height/2.0,
                                      self.promImage.frame.size.width,
                                      self.promImage.frame.size.height);
    
    self.touchBtn.layer.borderColor = [UIColor CMLBlackColor].CGColor;
    self.touchBtn.layer.borderWidth = 1*Proportion;
    self.touchBtn.frame =  CGRectMake(WIDTH - 30*Proportion - 120*Proportion,
                                      140*Proportion/2.0 - 50*Proportion/2.0,
                                      120*Proportion,
                                      50*Proportion);
    [self.touchBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];

    self.typeLab.text = self.title;
    [self.typeLab sizeToFit];
    
    self.detailMesLab.text = self.desc;
    self.detailMesLab.numberOfLines = 0;
    [self.detailMesLab sizeToFit];
    if (self.detailMesLab.frame.size.width > WIDTH - CGRectGetMaxX(self.promImage.frame) - 10*Proportion - 30*Proportion*2 - 120*Proportion) {
      
        self.detailMesLab.frame = CGRectMake(CGRectGetMaxX(self.promImage.frame) + 20*Proportion,
                                             140*Proportion/2.0 - (self.typeLab.frame.size.height + self.detailMesLab.frame.size.height*2 + 10*Proportion)/2.0 + self.typeLab.frame.size.height + 10*Proportion,
                                             WIDTH - CGRectGetMaxX(self.promImage.frame) - 10*Proportion - 30*Proportion*2 - 120*Proportion,
                                             self.detailMesLab.frame.size.height*2);
    }else{

        
        self.detailMesLab.frame = CGRectMake(CGRectGetMaxX(self.promImage.frame) + 20*Proportion,
                                             140*Proportion/2.0 - (self.typeLab.frame.size.height + self.detailMesLab.frame.size.height + 10*Proportion)/2.0+ self.typeLab.frame.size.height + 10*Proportion,
                                             WIDTH - CGRectGetMaxX(self.promImage.frame) - 10*Proportion - 30*Proportion*2 - 120*Proportion,
                                             self.detailMesLab.frame.size.height);

    }
    

    self.typeLab.frame = CGRectMake(CGRectGetMaxX(self.promImage.frame) + 20*Proportion,
                                    self.detailMesLab.frame.origin.y - 10*Proportion - self.typeLab.frame.size.height,
                                    self.typeLab.frame.size.width,
                                    self.typeLab.frame.size.height);
    
    if ([self.finishStatus intValue] == 1) {
        self.detailMesLab.textColor = [UIColor CMLNewPinkColor];
        self.touchBtn.userInteractionEnabled = NO;
        self.touchBtn.selected = YES;
        [self.touchBtn setTitle:self.finishStatusStr forState:UIControlStateSelected];
        self.touchBtn.backgroundColor = [UIColor CMLtextInputGrayColor];
        [self.touchBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateSelected];
        self.touchBtn.layer.borderColor = [UIColor CMLtextInputGrayColor].CGColor;
        self.touchBtn.layer.borderWidth = 1*Proportion;
        
        
        if ([self.title isEqualToString:@"签到"] || [self.title isEqualToString:@"邀请好友注册"]) {
            
            self.detailMesLab.textColor = [UIColor CMLLineGrayColor];
            
        }
    }else{
        [self.touchBtn setTitle:self.finishStatusStr forState:UIControlStateNormal];
    }
    
}

- (void) getPoints{

    self.touchBlock(self.tyoe);
}
@end
