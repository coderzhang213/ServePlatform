//
//  ReplaceTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2017/1/18.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "ReplaceTVCell.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "CMLLine.h"
#import "NSString+CMLExspand.h"
#import "CommenClickBottomView.h"

#define CMLInfoCellTypeTopMargin       30
#define CMLInfoCellTypeBottomMargin    30
#define CMLInfoCellTypeImageAndTypeSpace  10
#define CMLInfoCellImageHeight         200
#define CMLInfoCellImageWidth          280
#define CMLInfoCellHeight              70
#define CMLInfoCellLeftMargin          20
#define CMLInfoCellLineAndTitleSpace   10
#define CMLInfoCellBtnTopMargin        30
#define CMLInfoCellBtnBottomMargin     30
#define CMLInfoCellBtnAndBtnSpace      60
#define CMLInfoCellBtnImgAndTitleSpace 10
#define CMLInfoCellBottomMargin        40
#define CMLInfoCellBottomViewHeight    20

@interface ReplaceTVCell ()


@property (nonatomic,strong) UIImageView *mainImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *briefLabel;

@property (nonatomic,strong) UILabel *shortBriefLabel;

@property (nonatomic,strong) UIView *bottomView;

@end
@implementation ReplaceTVCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadviews];
      
    }
    return self;
}

- (void) loadviews{
    
    self.mainImageView = [[UIImageView alloc] init];
    self.mainImageView.backgroundColor = [UIColor CMLUserGrayColor];
    self.mainImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.mainImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = KSystemBoldFontSize18;
    self.titleLabel.textColor = [UIColor CMLUserGrayColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.backgroundColor = [UIColor CMLUserGrayColor];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    self.briefLabel = [[UILabel alloc] init];
    self.briefLabel.font = KSystemFontSize13;
    self.briefLabel.textColor = [UIColor CMLUserGrayColor];
    self.briefLabel.backgroundColor = [UIColor CMLUserGrayColor];
    self.briefLabel.numberOfLines = 0;
    self.briefLabel.textAlignment =NSTextAlignmentLeft;
    [self.contentView addSubview:self.briefLabel];
    
    self.shortBriefLabel = [[UILabel alloc] init];
    self.shortBriefLabel.font = KSystemFontSize13;
    self.shortBriefLabel.textColor = [UIColor CMLUserGrayColor];
    self.shortBriefLabel.backgroundColor = [UIColor CMLUserGrayColor];
    self.shortBriefLabel.numberOfLines = 0;
    self.shortBriefLabel.textAlignment =NSTextAlignmentLeft;
    [self.contentView addSubview:self.shortBriefLabel];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor CMLUserGrayColor];
    [self.contentView addSubview:self.bottomView];
    
}

- (void) reloadCurrentCell{
    
    /**图片请求*/
    self.mainImageView.frame = CGRectMake(WIDTH - CMLInfoCellLeftMargin*Proportion - CMLInfoCellImageWidth*Proportion,
                                          40*Proportion,
                                          CMLInfoCellImageWidth*Proportion,
                                          CMLInfoCellImageHeight*Proportion);

    /**名字*/
    self.titleLabel.text = @"占位";
    [self.titleLabel sizeToFit];
        
    self.titleLabel.frame = CGRectMake(CMLInfoCellLeftMargin*Proportion,
                                           40*Proportion,
                                           WIDTH - CMLInfoCellLeftMargin*Proportion*3 - CMLInfoCellImageWidth*Proportion,
                                           self.titleLabel.frame.size.height);
    /**brief*/
    
    self.briefLabel.text = @"占位";
    [self.briefLabel sizeToFit];
    self.briefLabel.frame = CGRectMake(CMLInfoCellLeftMargin*Proportion,
                                       CGRectGetMaxY(self.titleLabel.frame) + 20*Proportion,
                                       WIDTH - CMLInfoCellLeftMargin*Proportion*3 - CMLInfoCellImageWidth*Proportion,
                                       self.briefLabel.frame.size.height);
    
    self.shortBriefLabel.text = @"占位占位占位";
    [self.shortBriefLabel sizeToFit];
    self.shortBriefLabel.frame = CGRectMake(CMLInfoCellLeftMargin*Proportion,
                                       CGRectGetMaxY(self.briefLabel.frame) + 20*Proportion,
                                       self.shortBriefLabel.frame.size.width,
                                       self.shortBriefLabel.frame.size.height);
    
    self.bottomView.frame =CGRectMake(0,
                                      CGRectGetMaxY(self.mainImageView.frame) + CMLInfoCellBottomMargin*Proportion,
                                      WIDTH,
                                      CMLInfoCellBottomViewHeight*Proportion);
    
    self.cellheight = CGRectGetMaxY(self.bottomView.frame);
}


@end
