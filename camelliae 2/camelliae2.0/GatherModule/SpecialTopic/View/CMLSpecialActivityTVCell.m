//
//  CMLSpecialActivityTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 16/7/6.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLSpecialActivityTVCell.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "NSString+CMLExspand.h"

#define CMLSpecialActivityTopImageTopMargin           20
#define CMLSpecialActivityTopImageLeftMargin          30
#define CMLSpecialActivityImageAndTypeSpace           10
#define CMLSpecialActivityTopImageBottomMargin        30
#define CMLSpecialActivityMainImageViewHeight         162
#define CMLSpecialActivityTitleLeftMargin             20
#define CMLSpecialActivityDianHeight                  10
#define CMLSpecialActivityDianTopMargin               20
#define CMLSpecialActivityDianAndAttributeSpace       10
#define CMLSpecialActivityAttributeSpace              10

@interface CMLSpecialActivityTVCell ()

@property (nonatomic,strong) UILabel *typeLabel;

@property (nonatomic,strong) UILabel *lvlLab;

@property (nonatomic,strong) UIImageView *mainImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *timeLabel;


@end

@implementation CMLSpecialActivityTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{


    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadViews];
        
    }
    return self;
}

- (void) loadViews{

    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.font = KSystemFontSize10;
    self.typeLabel.textColor = [UIColor CMLBrownColor];
    [self.contentView addSubview:self.typeLabel];
    
    self.lvlLab = [[UILabel alloc] init];
    self.lvlLab.font = KSystemFontSize10;
    self.lvlLab.textColor = [UIColor CMLLineGrayColor];
    self.lvlLab.textAlignment = NSTextAlignmentCenter;
    self.lvlLab.layer.cornerRadius = 4*Proportion;
    self.lvlLab.layer.borderWidth = 1*Proportion;
    self.lvlLab.layer.borderColor = [UIColor CMLLineGrayColor].CGColor;
    self.lvlLab.backgroundColor = [UIColor whiteColor];
    self.lvlLab.layer.masksToBounds = YES;
    self.lvlLab.clipsToBounds = YES;
    [self.contentView addSubview:self.lvlLab];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.layer.cornerRadius = 4*Proportion;
    self.timeLabel.layer.borderWidth = 1*Proportion;
    self.timeLabel.layer.borderColor = [UIColor CMLLineGrayColor].CGColor;
    self.timeLabel.font = KSystemFontSize10;
    self.timeLabel.textColor = [UIColor CMLLineGrayColor];
    [self.contentView addSubview:self.timeLabel];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = KSystemFontSize14;
    self.titleLabel.textColor = [UIColor CMLUserBlackColor];
    [self.contentView addSubview:self.titleLabel];
    
    _mainImageView = [[UIImageView alloc] init];
    _mainImageView.frame = CGRectMake(CMLSpecialActivityTopImageLeftMargin*Proportion,
                                      CMLSpecialActivityTopImageBottomMargin*Proportion,
                                      CMLSpecialActivityMainImageViewHeight*Proportion/9*16,
                                      CMLSpecialActivityMainImageViewHeight*Proportion);
    _mainImageView.backgroundColor = [UIColor CMLPromptGrayColor];
    _mainImageView.layer.cornerRadius = 4*Proportion;
    _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    _mainImageView.clipsToBounds = YES;
    [self.contentView addSubview:_mainImageView];

}

- (void) refreshCurrentActivityCell{
    
    [NetWorkTask setImageView:self.mainImageView WithURL:self.imageUrl placeholderImage:nil];
    
    self.typeLabel.text = self.type;
    [self.typeLabel sizeToFit];
    self.typeLabel.frame = CGRectMake(CGRectGetMaxX(_mainImageView.frame) + CMLSpecialActivityTitleLeftMargin*Proportion,
                                      CMLSpecialActivityTopImageBottomMargin*Proportion,
                                      self.typeLabel.frame.size.width,
                                      self.typeLabel.frame.size.height);
    
    self.titleLabel.frame = CGRectZero;
    self.titleLabel.text = self.title;
    [self.titleLabel sizeToFit];
    if (self.titleLabel.frame.size.width < WIDTH - CMLSpecialActivityMainImageViewHeight*Proportion/9*16 - CMLSpecialActivityTitleLeftMargin*Proportion - CMLSpecialActivityTopImageLeftMargin*Proportion*2) {
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.mainImageView.frame) + CMLSpecialActivityTitleLeftMargin*Proportion,
                                           CGRectGetMaxY(self.typeLabel.frame) + 10*Proportion,
                                           WIDTH - CMLSpecialActivityMainImageViewHeight*Proportion/9*16 - CMLSpecialActivityTitleLeftMargin*Proportion - CMLSpecialActivityTopImageLeftMargin*Proportion*2,
                                           self.titleLabel.frame.size.height);
        
        
    }else{
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.mainImageView.frame) + CMLSpecialActivityTitleLeftMargin*Proportion,
                                           CGRectGetMaxY(self.typeLabel.frame) + 10*Proportion,
                                           WIDTH - CMLSpecialActivityMainImageViewHeight*Proportion/9*16 - CMLSpecialActivityTitleLeftMargin*Proportion - CMLSpecialActivityTopImageLeftMargin*Proportion*2,
                                           self.titleLabel.frame.size.height*2);
        

        
    }
    [self.contentView addSubview:_titleLabel];
    

    switch ([self.currentLvl intValue]) {
        case 1:
            self.lvlLab.text = @"粉色";
            break;
        case 2:
            self.lvlLab.text = @"黛色";
            break;
        case 3:
            self.lvlLab.text = @"金色";
            break;
        case 4:
            self.lvlLab.text = @"墨色";
            break;
            
        default:
            break;
    }
    
    
    [self.lvlLab sizeToFit];
    self.lvlLab.frame = CGRectMake(CGRectGetMaxX(_mainImageView.frame) + 20*Proportion,
                                   CGRectGetMaxY(_mainImageView.frame) - 30*Proportion,
                                   self.lvlLab.frame.size.width + 20*Proportion,
                                   30*Proportion);
    
    self.timeLabel.text = [NSString getProjectStartTime:self.beginTime];
    [self.timeLabel sizeToFit];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.lvlLab.frame) + 10*Proportion,
                                      CGRectGetMaxY(_mainImageView.frame) - 30*Proportion,
                                      self.timeLabel.frame.size.width + 20*Proportion,
                                      30*Proportion);
    
    
    self.currentHeight = CGRectGetMaxY(self.mainImageView.frame) + CMLSpecialActivityTopImageTopMargin*Proportion;


}

@end
