//
//  CMLNewArcticleTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2018/10/16.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "CMLNewArticleTVCell.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NetWorkTask.h"
#import "NetConfig.h"
#import "NetWorkDelegate.h"
#import "UIColor+SDExspand.h"
#import "CMLLine.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "NSString+CMLExspand.h"
#import "BaseResultObj.h"
#import <UMAnalytics/MobClick.h>
#import "NSDate+CMLExspand.h"
#import "CommenClickBottomView.h"

#define CMLActivityCellLeftMargin            20
#define CMLActivityCellTitleTopMargin        20

#define CMLActivityCellBtnTopMargin        30
#define CMLActivityCellBtnBottomMargin     30
#define CMLActivityCellBtnAndBtnSpace      60
#define CMLActivityCellBtnImgAndTitleSpace 10
#define CMLActivityCellBottomViewHeight    20


@interface CMLNewArticleTVCell ()

/**UI*/

@property (nonatomic,strong) UIImageView *mainImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) NSNumber *typeID;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) UILabel *levelLabel;

@property (nonatomic,strong) CMLLine *bottomLine;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UILabel *descLab;

@property (nonatomic,strong) UILabel *timeLab;

/***数据*/
@property (nonatomic,copy) NSString *imgUrl;

@property (nonatomic,copy) NSString *infoTitle;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,copy) NSString *timeStr;


@end

@implementation CMLNewArticleTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadViews];
        self.backgroundColor = [UIColor whiteColor];
        self.typeID =[NSNumber numberWithInt:2];
    }
    return self;
}

- (void) refrshArcticleCellInActivityVC:(CMLActivityObj *) obj{
    
    if (obj) {
        self.imgUrl        = obj.objCoverPic;
        self.infoTitle     = obj.title;
        self.desc          = obj.desc;
        self.timeStr       = obj.publishTimeStr;
    }else{
        self.imgUrl        = @"";
        self.infoTitle     = @"test";
        self.desc          = @"test";
        
    }
    [self reloadCurrentCell];
}


- (void) loadViews{
    
    self.mainImageView = [[UIImageView alloc] init];
    self.mainImageView.backgroundColor = [UIColor CMLPromptGrayColor];
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.mainImageView.layer.cornerRadius = 8*Proportion;
    self.mainImageView.clipsToBounds = YES;
    self.mainImageView.frame = CGRectMake(30*Proportion,
                                          40*Proportion,
                                          WIDTH - 30*Proportion*2,
                                          (WIDTH - 30*Proportion*2)/16*9);
    [self.contentView addSubview:self.mainImageView];
    
    self.timeLab = [[UILabel alloc] init];
    self.timeLab.font = KSystemFontSize10;
    self.timeLab.backgroundColor = [UIColor CMLWhiteColor];
    [self.mainImageView addSubview:self.timeLab];

    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = KSystemBoldFontSize18;
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textColor = [UIColor CMLUserBlackColor];
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleLabel];
    
    self.descLab = [[UILabel alloc] init];
    self.descLab.font = KSystemFontSize12;
    self.descLab.textColor = [UIColor CMLLineGrayColor];
    self.descLab.numberOfLines = 0;
    self.descLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.descLab];
    
    
    self.levelLabel = [[UILabel alloc] init];
    self.levelLabel.layer.cornerRadius = 2;
    self.levelLabel.layer.borderWidth = 1*Proportion;
    self.levelLabel.layer.borderColor = [UIColor CMLLineGrayColor].CGColor;
    self.levelLabel.font = KSystemFontSize12;
    self.levelLabel.textColor = [UIColor CMLLineGrayColor];
    [self.contentView addSubview:self.levelLabel];
    
}

- (void) reloadCurrentCell{
    
    /*********/
    /**图片请求*/
    [NetWorkTask setImageView:self.mainImageView
                      WithURL:self.imgUrl
             placeholderImage:nil];
    
    
    self.timeLab.text = self.timeStr;
    self.timeLab.textAlignment = NSTextAlignmentCenter;
    [self.timeLab sizeToFit];
    self.timeLab.frame = CGRectMake(self.mainImageView.frame.size.width - self.timeLab.frame.size.width - 20*Proportion,
                                    self.mainImageView.frame.size.height - 35*Proportion - 16*Proportion,
                                    self.timeLab.frame.size.width + 20*Proportion,
                                    35*Proportion);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.timeLab.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(35*Proportion,35*Proportion)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.timeLab.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.timeLab.layer.mask = maskLayer;

    /**名字*/
    self.titleLabel.frame = CGRectZero;
    self.titleLabel.text = self.infoTitle;
    [self.titleLabel sizeToFit];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.frame = CGRectMake(30*Proportion,
                                       CGRectGetMaxY(_mainImageView.frame) + CMLActivityCellTitleTopMargin*Proportion,
                                       [UIScreen mainScreen].bounds.size.width - CMLActivityCellLeftMargin*Proportion*2,
                                       self.titleLabel.frame.size.height);
    
    self.descLab.frame = CGRectZero;
    self.descLab.text = self.desc;
    [self.descLab sizeToFit];
    if (self.descLab.frame.size.width > self.imageView.frame.size.width) {
        
        self.descLab.frame = CGRectMake(30*Proportion,
                                        CGRectGetMaxY(self.titleLabel.frame) + 5*Proportion,
                                        self.mainImageView.frame.size.width,
                                        self.descLab.frame.size.height);
        
        self.cellheight = CGRectGetMaxY(self.descLab.frame) + self.descLab.frame.size.height  + 17*Proportion;
        
    }else{
        
        self.descLab.frame = CGRectMake(30*Proportion,
                                        CGRectGetMaxY(self.titleLabel.frame) + 5*Proportion,
                                        self.mainImageView.frame.size.width,
                                        self.descLab.frame.size.height);
        
        self.cellheight = CGRectGetMaxY(self.descLab.frame) + self.descLab.frame.size.height + 17*Proportion;
    }
    
}


@end
