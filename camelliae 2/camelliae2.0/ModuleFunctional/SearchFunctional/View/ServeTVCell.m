//
//  ServeTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 16/9/5.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "ServeTVCell.h"
#import "NetWorkTask.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NSString+CMLExspand.h"
#import "NSDate+CMLExspand.h"

#define ServeLeftMargin     20
#define ServeHeightAndWidth 200
#define ServeImageTopMargin 20
#define ServeTitleTopMargin 20


@interface ServeTVCell()

@property (nonatomic,strong) UIImageView *mainImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *provinceName;

@property (nonatomic,strong) UILabel *beginTimeLabel;

@property (nonatomic,strong) UILabel *totalAmountLabel;

@property (nonatomic,strong) UILabel *preTag;

@property (nonatomic,strong) UILabel *promLab;


@end


@implementation ServeTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self loadViews];
    }
    return self;
}

- (void) loadViews{
    
    _mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ServeLeftMargin*Proportion,
                                                                   ServeImageTopMargin*Proportion,
                                                                   ServeHeightAndWidth*Proportion,
                                                                   ServeHeightAndWidth*Proportion)];
    _mainImageView.backgroundColor = [UIColor CMLPromptGrayColor];
    _mainImageView.clipsToBounds = YES;
    _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_mainImageView];
    
    self.preTag = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 66*Proportion, 40*Proportion)];
    self.preTag.backgroundColor = [UIColor CMLBlackColor];
    self.preTag.textColor = [UIColor CMLBrownColor];
    self.preTag.font = KSystemFontSize11;
    self.preTag.text = @"预售";
    self.preTag.textAlignment = NSTextAlignmentCenter;
    [_mainImageView addSubview:self.preTag];
    
    _provinceName = [[UILabel alloc] init];
    _provinceName.textColor = [UIColor CMLtextInputGrayColor];
    _provinceName.backgroundColor = [UIColor whiteColor];
    _provinceName.layer.borderWidth = 1*Proportion;
    _provinceName.layer.borderColor = [UIColor CMLtextInputGrayColor].CGColor;
    _provinceName.font = KSystemFontSize12;
    _provinceName.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_provinceName];
    
    _beginTimeLabel = [[UILabel alloc] init];
    _beginTimeLabel.textColor = [UIColor CMLtextInputGrayColor];
    _beginTimeLabel.layer.borderWidth = 1*Proportion;
    _beginTimeLabel.layer.borderColor = [UIColor CMLtextInputGrayColor].CGColor;
    _beginTimeLabel.backgroundColor = [UIColor whiteColor];
    _beginTimeLabel.font = KSystemFontSize12;
    _beginTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_beginTimeLabel];
    
    _totalAmountLabel = [[UILabel alloc] init];
    _totalAmountLabel.font = KSystemRealBoldFontSize18;
    _totalAmountLabel.textColor = [UIColor CMLBrownColor];
    [self.contentView addSubview:_totalAmountLabel];
    
    self.promLab = [[UILabel alloc] init];
    self.promLab.font = KSystemFontSize10;
    self.promLab.backgroundColor = [UIColor CMLBrownColor];
    self.promLab.textColor = [UIColor CMLWhiteColor];
    self.promLab.textAlignment = NSTextAlignmentCenter;
    self.promLab.text = @"订金";
    [self.contentView addSubview:self.promLab];
    
}

- (void) refreshCurrentServeCell{
    
    [_titleLabel removeFromSuperview];
    
    [NetWorkTask setImageView:_mainImageView WithURL:self.imageUrl placeholderImage:nil];
    
    
    if ([self.is_pre intValue] == 1) {
        
        self.preTag.hidden = NO;
    }else{
        
        self.preTag.hidden = YES;
    }
    
    _provinceName.text = self.subTypeName;
    [_provinceName sizeToFit];
    _provinceName.frame = CGRectMake(CGRectGetMaxX(_mainImageView.frame) + ServeLeftMargin*Proportion,
                                     ServeImageTopMargin*Proportion,
                                     _provinceName.frame.size.width,
                                     _provinceName.frame.size.height);
    
    _beginTimeLabel.text = self.parentTypeName;
    [_beginTimeLabel sizeToFit];
    _beginTimeLabel.frame =  CGRectMake(CGRectGetMaxX(_provinceName.frame) + ServeLeftMargin*Proportion,
                                        ServeImageTopMargin*Proportion,
                                        _beginTimeLabel.frame.size.width,
                                        _beginTimeLabel.frame.size.height);
    

    
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = KSystemBoldFontSize15;
    _titleLabel.textColor = [UIColor CMLBlackColor];
    [self.contentView addSubview:_titleLabel];
    _titleLabel.text = self.title;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [_titleLabel sizeToFit];

    
    if (_titleLabel.frame.size.width > ([UIScreen mainScreen].bounds.size.width - ServeHeightAndWidth*Proportion - ServeLeftMargin*Proportion*3)) {
        
        _titleLabel.numberOfLines = 2;
        _titleLabel.frame = CGRectMake(CGRectGetMaxX(_mainImageView.frame) + ServeLeftMargin*Proportion,
                                       CGRectGetMaxY(_provinceName.frame) + ServeImageTopMargin*Proportion,
                                       WIDTH - ServeHeightAndWidth*Proportion - ServeLeftMargin*Proportion*3,
                                       _titleLabel.frame.size.height*2);
    }else{
        
        _titleLabel.numberOfLines = 1;
        _titleLabel.frame = CGRectMake(CGRectGetMaxX(_mainImageView.frame) + ServeLeftMargin*Proportion,
                                       CGRectGetMaxY(_provinceName.frame) + ServeImageTopMargin*Proportion,
                                       WIDTH - ServeHeightAndWidth*Proportion - ServeLeftMargin*Proportion*3,
                                       _titleLabel.frame.size.height);
        
    }
    
    

    
    
    _totalAmountLabel.text = [NSString stringWithFormat:@"￥%@",self.totalAmount];
    [_totalAmountLabel sizeToFit];
    _totalAmountLabel.frame =CGRectMake(CGRectGetMaxX(_mainImageView.frame) + ServeLeftMargin*Proportion,
                                        CGRectGetMaxY(_mainImageView.frame) - _totalAmountLabel.frame.size.height,
                                        _totalAmountLabel.frame.size.width,
                                        _totalAmountLabel.frame.size.height);
    
    if ([self.payMode intValue] == 1) {
        

        self.promLab.hidden = NO;
        self.promLab.frame = CGRectMake(CGRectGetMaxX(_totalAmountLabel.frame) + 10*Proportion,
                                        _totalAmountLabel.center.y - 30*Proportion/2.0,
                                        50*Proportion,
                                        30*Proportion);
        
    }else{
        
        self.promLab.hidden = YES;
    }

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
