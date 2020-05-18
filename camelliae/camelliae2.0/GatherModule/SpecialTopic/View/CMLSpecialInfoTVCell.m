//
//  CMLSpecialInfoTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 16/7/6.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLSpecialInfoTVCell.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"

#define CMLSpecialInfoTopImageTopMargin           20
#define CMLSpecialInfoTopImageLeftMargin          30
#define CMLSpecialInfoImageAndTypeSpace           10
#define CMLSpecialInfoTopImageBottomMargin        30
#define CMLSpecialInfoMainImageViewHeight         162
#define CMLSpecialInfoTitleLeftMargin             20

@interface CMLSpecialInfoTVCell ()

@property (nonatomic,strong) UILabel *descLabel;

@property (nonatomic,strong) UIImageView *mainImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *timeImg;

@property (nonatomic,strong) UILabel *timeLab;

@property (nonatomic,strong) UIImageView *addressImg;

@property (nonatomic,strong) UILabel *addressLab;

@end

@implementation CMLSpecialInfoTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self loadViews];
    }
    return self;
}

- (void) loadViews{
    
    
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.font = KSystemFontSize12;
    self.descLabel.textColor = [UIColor CMLLineGrayColor];
    self.descLabel.numberOfLines = 2;
    self.descLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.descLabel];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = KSystemFontSize14;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textColor = [UIColor CMLUserBlackColor];
    [self.contentView addSubview:self.titleLabel];
    
    _mainImageView = [[UIImageView alloc] init];
    _mainImageView.frame = CGRectMake(CMLSpecialInfoTopImageLeftMargin*Proportion,
                                     CMLSpecialInfoTopImageBottomMargin*Proportion,
                                     CMLSpecialInfoMainImageViewHeight*Proportion/9*16,
                                     CMLSpecialInfoMainImageViewHeight*Proportion);
    _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    _mainImageView.layer.cornerRadius = 4*Proportion;
    _mainImageView.clipsToBounds = YES;
    _mainImageView.backgroundColor = [UIColor CMLPromptGrayColor];
    [self.contentView addSubview:_mainImageView];
    
    self.timeImg = [[UIImageView alloc] init];
    self.timeImg.contentMode = UIViewContentModeScaleAspectFill;
    self.timeImg.image = [UIImage imageNamed:ListActivityTimeImg];
    self.timeImg.clipsToBounds = YES;
    [self.contentView addSubview:self.timeImg];
    
    self.timeLab = [[UILabel alloc] init];
    self.timeLab.font = KSystemFontSize12;
    self.timeLab.textColor = [UIColor CMLBlackColor];
    [self.contentView addSubview:self.timeLab];
    
    self.addressImg = [[UIImageView alloc] init];
    self.addressImg.contentMode = UIViewContentModeScaleAspectFill;
    self.addressImg.image = [UIImage imageNamed:ListActivityAddressImg];
    self.addressImg.clipsToBounds = YES;
    [self.contentView addSubview:self.addressImg];
    
    self.addressLab = [[UILabel alloc] init];
    self.addressLab.font = KSystemFontSize12;
    self.addressLab.textColor = [UIColor CMLBlackColor];
    [self.contentView addSubview:self.addressLab];


}

- (void) refreshCurrentInfoCell{
 
    [NetWorkTask setImageView:self.mainImageView WithURL:self.imageUrl placeholderImage:nil];
    
    self.titleLabel.frame = CGRectZero;
    self.titleLabel.text = self.title;
    [self.titleLabel sizeToFit];
    if (self.titleLabel.frame.size.width < WIDTH - CMLSpecialInfoMainImageViewHeight*Proportion/9*16 - CMLSpecialInfoTitleLeftMargin*Proportion - CMLSpecialInfoTopImageLeftMargin*Proportion*2) {
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.mainImageView.frame) + CMLSpecialInfoTitleLeftMargin*Proportion,
                                           self.mainImageView.frame.origin.y,
                                           WIDTH - CMLSpecialInfoMainImageViewHeight*Proportion/9*16 - CMLSpecialInfoTitleLeftMargin*Proportion - CMLSpecialInfoTopImageLeftMargin*Proportion*2,
                                           self.titleLabel.frame.size.height);

    }else{
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.mainImageView.frame) + CMLSpecialInfoTitleLeftMargin*Proportion,
                                           self.mainImageView.frame.origin.y,
                                           WIDTH - CMLSpecialInfoMainImageViewHeight*Proportion/9*16 - CMLSpecialInfoTitleLeftMargin*Proportion - CMLSpecialInfoTopImageLeftMargin*Proportion*2,
                                           self.titleLabel.frame.size.height*2);
    
    }
    
    [self.contentView addSubview:self.titleLabel];
    
    self.descLabel.text = self.desc;
    [self.descLabel sizeToFit];
    
    if (self.descLabel.frame.size.width <  WIDTH - CMLSpecialInfoMainImageViewHeight*Proportion/9*16 - CMLSpecialInfoTitleLeftMargin*Proportion - CMLSpecialInfoTopImageLeftMargin*Proportion*2) {
    
        self.descLabel.frame = CGRectMake(CGRectGetMaxX(self.mainImageView.frame) + CMLSpecialInfoTitleLeftMargin*Proportion,
                                          CGRectGetMaxY(_mainImageView.frame) - self.descLabel.frame.size.height,
                                          WIDTH - CMLSpecialInfoMainImageViewHeight*Proportion/9*16 - CMLSpecialInfoTitleLeftMargin*Proportion - CMLSpecialInfoTopImageLeftMargin*Proportion*2,
                                          self.descLabel.frame.size.height);
    }else{
    
        self.descLabel.frame = CGRectMake(CGRectGetMaxX(self.mainImageView.frame) + CMLSpecialInfoTitleLeftMargin*Proportion,
                                          CGRectGetMaxY(_mainImageView.frame) - self.descLabel.frame.size.height*2,
                                          WIDTH - CMLSpecialInfoMainImageViewHeight*Proportion/9*16 - CMLSpecialInfoTitleLeftMargin*Proportion - CMLSpecialInfoTopImageLeftMargin*Proportion*2,
                                          self.descLabel.frame.size.height*2);
    
    }
    
    [self.timeImg sizeToFit];
    self.timeImg.frame = CGRectMake(CGRectGetMaxX(self.mainImageView.frame) + CMLSpecialInfoTitleLeftMargin*Proportion,
                                    CGRectGetMaxY(self.mainImageView.frame) - self.timeImg.frame.size.height,
                                    self.timeImg.frame.size.width,
                                    self.timeImg.frame.size.height);
    
    self.timeLab.text = self.beginTimeStr;
    [self.timeLab sizeToFit];
    self.timeLab.frame = CGRectMake(CGRectGetMaxX(self.timeImg.frame) + 5*Proportion,
                                    CGRectGetMaxY(self.mainImageView.frame) - self.timeLab.frame.size.height,
                                    self.timeLab.frame.size.width,
                                    self.timeLab.frame.size.height);
    
    [self.addressImg sizeToFit];
    self.addressImg.frame = CGRectMake(CGRectGetMaxX(self.timeLab.frame) + 20*Proportion,
                                       CGRectGetMaxY(self.mainImageView.frame) - self.addressImg.frame.size.height,
                                       self.addressImg.frame.size.width,
                                       self.addressImg.frame.size.height);
    
    if (self.city.length > 0 ) {
        self.addressLab.text = self.city;
    }else{
        self.addressLab.text = @"上海";
    }
    
    [self.addressLab sizeToFit];
    self.addressLab.frame = CGRectMake(CGRectGetMaxX(self.addressImg.frame) + 5*Proportion,
                                       CGRectGetMaxY(self.mainImageView.frame) - self.addressLab.frame.size.height,
                                       self.addressLab.frame.size.width,
                                       self.addressLab.frame.size.height);
    self.currentHeight = CGRectGetMaxY(self.mainImageView.frame) + CMLSpecialInfoTopImageTopMargin*Proportion;
}
@end
