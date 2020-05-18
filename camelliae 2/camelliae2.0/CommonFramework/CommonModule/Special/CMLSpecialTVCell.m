//
//  CMLSpecialTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 16/6/2.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLSpecialTVCell.h"
#import "NetWorkTask.h"
#import "UIColor+SDExspand.h"
#import "CommonFont.h"
#import "CommonNumber.h"


#define SpecialTVCellMaxY  210
#define SpecialTVCellBottomViewHeight 20
#define SpecialTVCellSpecialTopMargin 20
#define SpecialTVCellSpecialHeight    40
#define SpecialTVCellSpecialWidth     100

@interface CMLSpecialTVCell ()

@property (nonatomic,strong) UIImageView *mainImageView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *label;

@property (nonatomic,strong) UIView *bottomView;

@end

@implementation CMLSpecialTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadViews];
    }
    return self;
}

- (void) loadViews{

    self.mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       [UIScreen mainScreen].bounds.size.width,
                                                                       [UIScreen mainScreen].bounds.size.width/16*9)];
    self.mainImageView.backgroundColor = [UIColor CMLPromptGrayColor];
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.mainImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.mainImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor CMLWhiteColor];
    _nameLabel.font =KSystemFontSize17;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.mainImageView addSubview:_nameLabel];
    
    _label = [[UILabel alloc] init];
    _label.text = @"专题";
    _label.textColor = [UIColor CMLWhiteColor];
    _label.font = KSystemFontSize14;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.layer.borderColor = [UIColor CMLWhiteColor].CGColor;
    _label.layer.borderWidth = 1;
    [self.mainImageView addSubview:_label];
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor CMLUserGrayColor];
    [self.contentView addSubview:_bottomView];
    
}

- (void) refreshCurrentCellWithImageUrl:(NSString*)imageUrl SpecialName:(NSString *)specialName{
    
    
    [NetWorkTask setImageView:self.mainImageView WithURL:imageUrl placeholderImage:nil];
    
    /**name*/
    _nameLabel.text = specialName;
    CGRect nameRect = [specialName boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2*30*Proportion, 1000)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:KSystemFontSize17}
                                                context:nil];
    _nameLabel.frame = CGRectMake(30*Proportion,
                                 SpecialTVCellMaxY*Proportion - nameRect.size.height,
                                 [UIScreen mainScreen].bounds.size.width - 2*30*Proportion,
                                 nameRect.size.height);
    
    _label.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2.0 - SpecialTVCellSpecialWidth*Proportion/2.0,
                              CGRectGetMaxY(_nameLabel.frame) + SpecialTVCellSpecialTopMargin*Proportion,
                              SpecialTVCellSpecialWidth*Proportion,
                              SpecialTVCellSpecialHeight*Proportion);
    _label.layer.cornerRadius = SpecialTVCellSpecialHeight*Proportion/2.0;
    
    _bottomView.frame = CGRectMake(0,
                                   CGRectGetMaxY(self.mainImageView.frame),
                                   [UIScreen mainScreen].bounds.size.width,
                                   SpecialTVCellBottomViewHeight*Proportion);
    
    self.rowHeight = CGRectGetMaxY(_bottomView.frame);

}
@end
