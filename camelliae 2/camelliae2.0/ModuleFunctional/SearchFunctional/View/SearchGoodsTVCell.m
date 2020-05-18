//
//  SearchGoodsTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2017/8/1.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "SearchGoodsTVCell.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "PackageInfoObj.h"
#import "PackDetailInfoObj.h"
#import "SearchResultObj.h"

#define ImageWidth  330
#define ImageHeight 330

@interface SearchGoodsTVCell ()

@property (nonatomic,strong) UIView *imageBgView;

@property (nonatomic,strong) UIImageView *mainImageView;

@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) UILabel *priceLab;

@property (nonatomic,strong) UILabel *tagLab;

@property (nonatomic,strong) UILabel *preTag;

@property (nonatomic,strong) UILabel *verbLab;

/*新增：浏览量*/
@property (nonatomic, strong) UIImageView *hitImageView;

@property (nonatomic, strong) UILabel *hitLabel;


@end

@implementation SearchGoodsTVCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    self.imageBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                ImageWidth*Proportion,
                                                                ImageHeight*Proportion)];
    self.imageBgView.backgroundColor = [UIColor CMLWhiteColor];
    self.imageBgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.imageBgView.layer.shadowColor = [UIColor CMLBlackColor].CGColor;
    self.imageBgView.layer.shadowOpacity = 0.05;
    [self.contentView addSubview:self.imageBgView];
    
    self.mainImageView = [[UIImageView alloc] initWithFrame:self.imageBgView.bounds];
    self.mainImageView.backgroundColor = [UIColor CMLPromptGrayColor];
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.mainImageView.clipsToBounds = YES;
    self.mainImageView.layer.cornerRadius = 10*Proportion;
    [self.imageBgView addSubview:self.mainImageView];
    
    
    self.preTag = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            82*Proportion,
                                                            50*Proportion)];
    self.preTag.backgroundColor = [UIColor CMLBlackColor];
    self.preTag.textColor = [UIColor CMLBrownColor];
    self.preTag.font = KSystemFontSize13;
    self.preTag.text = @"预售";
    self.preTag.textAlignment = NSTextAlignmentCenter;
    [self.mainImageView addSubview:self.preTag];
    self.preTag.hidden = YES;
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.font = KSystemBoldFontSize13;
    self.titleLab.numberOfLines = 2;
    self.titleLab.textColor = [UIColor CMLBlackColor];
    [self.contentView addSubview:self.titleLab];
    
    
    self.priceLab = [[UILabel alloc] init];
    self.priceLab.font = KSystemRealBoldFontSize18;
    self.priceLab.numberOfLines = 2;
    self.priceLab.textColor = [UIColor CMLBrownColor];
    [self.contentView addSubview:self.priceLab];
    
    self.tagLab = [[UILabel alloc] init];
    self.tagLab.font = KSystemFontSize11;
    self.tagLab.textColor = [UIColor CMLLightBrownColor];
    self.tagLab.layer.cornerRadius = 2*Proportion;
    self.tagLab.layer.borderWidth = 1*Proportion;
    self.tagLab.layer.borderColor = [UIColor CMLLightBrownColor].CGColor;
    self.tagLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.tagLab];
    
    
    _verbLab = [[UILabel alloc] init];
    _verbLab.text = @"订金";
    _verbLab.font = KSystemFontSize10;
    _verbLab.layer.cornerRadius = 6*Proportion;
    _verbLab.clipsToBounds  = YES;
    _verbLab.textColor = [UIColor CMLWhiteColor];
    _verbLab.textAlignment = NSTextAlignmentCenter;
    _verbLab.backgroundColor = [UIColor CMLBrownColor];
    [self.contentView addSubview:_verbLab];
    
    /*新增L：浏览量 - 单品*/
    self.hitImageView = [[UIImageView alloc] init];
    self.hitImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.hitImageView.image = [UIImage imageNamed:CMLHitImage];
    self.hitImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.hitImageView];
    
    self.hitLabel = [[UILabel alloc] init];
    self.hitLabel.font = KSystemFontSize12;
    self.hitLabel.textColor = [UIColor CMLBtnTitleNewGrayColor];
    [self.contentView addSubview:self.hitLabel];

}

- (void) refreshCVCell:(SearchResultObj *) obj{
    
    if (self.isMoveModule) {
        
        self.imageBgView.frame = CGRectMake(30*Proportion,
                                          0,
                                          ImageWidth*Proportion,
                                          ImageHeight*Proportion);
    }else{
        
        self.imageBgView.frame = CGRectMake(0,
                                          0,
                                          ImageWidth*Proportion,
                                          ImageHeight*Proportion);
    }
    
    [NetWorkTask setImageView:self.mainImageView WithURL:obj.coverPic placeholderImage:nil];
    
    
    self.titleLab.frame = CGRectZero;
    self.titleLab.text =  obj.title;
    [self.titleLab sizeToFit];

    self.priceLab.frame = CGRectZero;
    self.priceLab.text = [NSString stringWithFormat:@"¥%@",obj.totalAmountMin];
    if ([obj.is_deposit intValue] == 1) {
        
        self.priceLab.text = [NSString stringWithFormat:@"¥%@",obj.deposit_money];
    }
    [self.priceLab sizeToFit];
    
    self.tagLab.frame = CGRectZero;
    if (obj.brandName.length > 0) {
        self.tagLab.hidden = NO;
    }else {
        self.tagLab.hidden = YES;
    }
    self.tagLab.text = [NSString stringWithFormat:@"%@",obj.brandName];
    [self.tagLab sizeToFit];

    if ([obj.is_pre intValue] == 1) {
        
        self.preTag.hidden = NO;
    }else{
        self.preTag.hidden = YES;
        
    }
    
    
    if (self.isMoveModule) {
        
        self.tagLab.frame = CGRectMake(30*Proportion,
                                       CGRectGetMaxY(self.imageBgView.frame) + 10*Proportion,
                                       self.tagLab.frame.size.width + 20*Proportion,
                                       34*Proportion);
        
        if (self.titleLab.frame.size.width > ImageWidth*Proportion) {
            
            self.titleLab.frame = CGRectMake(30*Proportion,
                                             CGRectGetMaxY(self.tagLab.frame) + 15*Proportion,
                                             ImageWidth*Proportion,
                                             self.titleLab.frame.size.height*2);
            
            self.priceLab.frame = CGRectMake(30*Proportion,
                                             CGRectGetMaxY(self.titleLab.frame) + 20*Proportion,
                                             self.priceLab.frame.size.width,
                                             self.priceLab.frame.size.height);
        }else{
            
            self.titleLab.frame = CGRectMake(30*Proportion,
                                             CGRectGetMaxY(self.tagLab.frame) + 15*Proportion,
                                             ImageWidth*Proportion,
                                             self.titleLab.frame.size.height);
            
            self.priceLab.frame = CGRectMake(30*Proportion,
                                             CGRectGetMaxY(self.titleLab.frame) + 20*Proportion + self.titleLab.frame.size.height,
                                             self.priceLab.frame.size.width,
                                             self.priceLab.frame.size.height);
        }

    }else{
        
        self.tagLab.frame = CGRectMake(0,
                                       CGRectGetMaxY(self.imageBgView.frame) + 10*Proportion,
                                       self.tagLab.frame.size.width + 20*Proportion,
                                       34*Proportion);
        
        if (self.titleLab.frame.size.width > ImageWidth*Proportion) {
            
            self.titleLab.frame = CGRectMake(0,
                                             CGRectGetMaxY(self.tagLab.frame) + 15*Proportion,
                                             ImageWidth*Proportion,
                                             self.titleLab.frame.size.height*2);
            
            self.priceLab.frame = CGRectMake(0,
                                             CGRectGetMaxY(self.titleLab.frame) + 20*Proportion,
                                             self.priceLab.frame.size.width,
                                             self.priceLab.frame.size.height);
        }else{
            
            self.titleLab.frame = CGRectMake(0,
                                             CGRectGetMaxY(self.tagLab.frame) + 15*Proportion,
                                             ImageWidth*Proportion,
                                             self.titleLab.frame.size.height);
            
            self.priceLab.frame = CGRectMake(0,
                                             CGRectGetMaxY(self.titleLab.frame) + 20*Proportion + self.titleLab.frame.size.height,
                                             self.priceLab.frame.size.width,
                                             self.priceLab.frame.size.height);
        }

    }
    
    if ([obj.is_deposit intValue] == 1) {
        
        self.verbLab.hidden = NO;
        [self.verbLab sizeToFit];
        self.verbLab.frame = CGRectMake(CGRectGetMaxX(self.priceLab.frame) + 10*Proportion,
                                        self.priceLab.center.y - 30*Proportion/2.0,
                                        50*Proportion,
                                        30*Proportion);
    }else{
        
        self.verbLab.hidden = YES;
    }
    
   
        
    /*新增：浏览量*/
    
    if (obj.hitNum) {
        self.hitLabel.text =  [NSString stringWithFormat:@"%@", obj.hitNum];
    }else {
        self.hitLabel.text = @"0";
    }
    
    [self.hitLabel sizeToFit];
    self.hitLabel.frame = CGRectMake(CGRectGetMaxX(self.imageBgView.frame) - self.hitLabel.frame.size.width,
                                     self.priceLab.center.y - self.hitLabel.frame.size.height/2.0,
                                     self.hitLabel.frame.size.width,
                                     self.hitLabel.frame.size.height);
    
    [self.hitImageView sizeToFit];
    self.hitImageView.frame = CGRectMake(self.hitLabel.frame.origin.x - self.hitImageView.frame.size.width - 10 * Proportion,
                                         self.priceLab.center.y - self.hitImageView.frame.size.height/2.0,
                                         self.hitImageView.frame.size.width,
                                         self.hitImageView.frame.size.height);
    

    
}

@end
