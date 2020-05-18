//
//  CMLSpecialServeTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 16/7/6.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLSpecialServeTVCell.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "NSString+CMLExspand.h"

#define CMLSpecialServeTopImageTopMargin           20
#define CMLSpecialServeTopImageLeftMargin          30
#define CMLSpecialServeImageAndTypeSpace           10
#define CMLSpecialServeTopImageBottomMargin        30
#define CMLSpecialServeMainImageViewHeight         162
#define CMLSpecialServeTitleLeftMargin             20
#define CMLSpecialServeShortTitleTopMargin         20
#define CMLSpecialServePricelAroundMargin          10


@interface CMLSpecialServeTVCell ()

@property (nonatomic,strong) UIImageView *mainImageView;

@property (nonatomic,strong) UILabel *tagOne;

@property (nonatomic,strong) UILabel *tagTwo;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *pricelLabel;

@property (nonatomic,strong) UILabel *preLab;

@property (nonatomic,strong) UILabel *verbLab;

@end

@implementation CMLSpecialServeTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self loadViews];
    }
    return self;
}

- (void) loadViews{
    
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = KSystemFontSize14;
    self.titleLabel.textColor = [UIColor CMLUserBlackColor];
    [self.contentView addSubview:self.titleLabel];
    
    self.tagOne = [[UILabel alloc] init];
    self.tagOne.font = KSystemFontSize10;
    self.tagOne.layer.borderColor = [UIColor CMLNewbgBrownColor].CGColor;
    self.tagOne.textColor = [UIColor CMLNewbgBrownColor];
    self.tagOne.layer.borderWidth = 1*Proportion;
    self.tagOne.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.tagOne];
    
    self.tagTwo = [[UILabel alloc] init];
    self.tagTwo.font = KSystemFontSize10;
    self.tagTwo.layer.borderColor = [UIColor CMLNewbgBrownColor].CGColor;
    self.tagTwo.textColor = [UIColor CMLNewbgBrownColor];
    self.tagTwo.layer.borderWidth = 1*Proportion;
    self.tagTwo.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.tagTwo];
    
    _mainImageView = [[UIImageView alloc] init];
    _mainImageView.frame = CGRectMake(CMLSpecialServeTopImageLeftMargin*Proportion,
                                      CMLSpecialServeTopImageBottomMargin*Proportion,
                                      CMLSpecialServeMainImageViewHeight*Proportion/9*16,
                                      CMLSpecialServeMainImageViewHeight*Proportion);
    _mainImageView.layer.cornerRadius = 4*Proportion;
    _mainImageView.backgroundColor = [UIColor CMLPromptGrayColor];
    _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    _mainImageView.clipsToBounds = YES;
    [self.contentView addSubview:_mainImageView];
    
    _preLab = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                        0,
                                                        66*Proportion,
                                                        40*Proportion)];
    _preLab.text = @"预售";
    _preLab.textAlignment = NSTextAlignmentCenter;
    _preLab.font = KSystemFontSize11;
    _preLab.textColor = [UIColor CMLBrownColor];
    _preLab.backgroundColor = [UIColor CMLBlackColor];
    [self.mainImageView addSubview:_preLab];
    
    _pricelLabel = [[UILabel alloc] init];
    _pricelLabel.font = KSystemBoldFontSize16;
    _pricelLabel.textColor = [UIColor CMLBrownColor];
    [self.contentView addSubview:_pricelLabel];
    
    _verbLab = [[UILabel alloc] init];
    _verbLab.text = @"订金";
    _verbLab.font = KSystemFontSize10;
    _verbLab.textColor = [UIColor CMLWhiteColor];
    _verbLab.textAlignment = NSTextAlignmentCenter;
    _verbLab.backgroundColor = [UIColor CMLBrownColor];
    [self.contentView addSubview:_verbLab];
    
}


- (void) refreshCurrentServeCell{
    
    [NetWorkTask setImageView:self.mainImageView WithURL:self.imageUrl placeholderImage:nil];
    
    if ([self.isPre intValue] == 1) {
        
        self.preLab.hidden = NO;
    }else{
        
        self.preLab.hidden = YES;
    }
    
    self.tagOne.text = self.typeName;
    [self.tagOne sizeToFit];
    self.tagOne.frame = CGRectMake(CGRectGetMaxX(self.mainImageView.frame) + CMLSpecialServeTitleLeftMargin*Proportion,
                                   self.mainImageView.frame.origin.y,
                                   self.tagOne.frame.size.width + 10*Proportion,
                                   self.tagOne.frame.size.height + 5*Proportion);
    
    self.tagTwo.text = self.brandName;
    [self.tagTwo sizeToFit];
    self.tagTwo.frame = CGRectMake(CGRectGetMaxX(self.tagOne.frame) + 20*Proportion,
                                   self.mainImageView.frame.origin.y,
                                   self.tagTwo.frame.size.width + 10*Proportion,
                                   self.tagTwo.frame.size.height + 5*Proportion);
    
    self.titleLabel.frame = CGRectZero;
    self.titleLabel.text = self.title;
    [self.titleLabel sizeToFit];
    if (self.titleLabel.frame.size.width < WIDTH - CMLSpecialServeMainImageViewHeight*Proportion/9*16 - CMLSpecialServeTitleLeftMargin*Proportion - CMLSpecialServeTopImageLeftMargin*Proportion*2) {
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.mainImageView.frame) + CMLSpecialServeTitleLeftMargin*Proportion,
                                           CGRectGetMaxY(self.tagTwo.frame) + 10*Proportion,
                                           WIDTH - CMLSpecialServeMainImageViewHeight*Proportion/9*16 - CMLSpecialServeTitleLeftMargin*Proportion - CMLSpecialServeTopImageLeftMargin*Proportion*2,
                                           self.titleLabel.frame.size.height);
        
    }else{
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.mainImageView.frame) + CMLSpecialServeTitleLeftMargin*Proportion,
                                           CGRectGetMaxY(self.tagTwo.frame) + 10*Proportion,
                                           WIDTH - CMLSpecialServeMainImageViewHeight*Proportion/9*16 - CMLSpecialServeTitleLeftMargin*Proportion - CMLSpecialServeTopImageLeftMargin*Proportion*2,
                                           self.titleLabel.frame.size.height*2);
        
    }

    [self.contentView addSubview:_titleLabel];
    
    
    if ([self.isHasPriceInterval intValue] == 1) {
        
        self.pricelLabel.text = [NSString stringWithFormat:@"¥%@起",self.price];
        
    }else{
    
        self.pricelLabel.text = [NSString stringWithFormat:@"¥%@",self.price];
        
    }
    
    [self.pricelLabel sizeToFit];
    self.pricelLabel.textAlignment = NSTextAlignmentCenter;
    self.pricelLabel.frame = CGRectMake(CGRectGetMaxX(self.mainImageView.frame) + CMLSpecialServeTitleLeftMargin*Proportion,
                                        CGRectGetMaxY(self.titleLabel.frame) + 10*Proportion,
                                        self.pricelLabel.frame.size.width,
                                        self.pricelLabel.frame.size.height);
    
    if ([self.isVerb intValue] == 1) {
        
        self.verbLab.hidden = NO;
        [self.verbLab sizeToFit];
        self.verbLab.frame = CGRectMake(CGRectGetMaxX(self.pricelLabel.frame) + 10*Proportion,
                                        self.pricelLabel.center.y - 30*Proportion/2.0,
                                        50*Proportion,
                                        30*Proportion);
    }else{
        
        self.verbLab.hidden = YES;
    }
        
    self.currentHeight = CGRectGetMaxY(self.mainImageView.frame) + CMLSpecialServeTopImageTopMargin*Proportion;

}

@end
