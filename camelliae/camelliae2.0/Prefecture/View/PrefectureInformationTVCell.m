//
//  PrefectureInformationTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/8.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "PrefectureInformationTVCell.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "AuctionDetailInfoObj.h"
#import "NetWorkTask.h"

#define LeftMargin         30
#define TopAndBottomMargin 20
#define ImageWidth         252
#define ImageHeight        180
#define Space              20

@interface PrefectureInformationTVCell ()

@property (nonatomic,strong) UIImageView *mainImage;

@property (nonatomic,strong) UILabel *tittleLab;

@property (nonatomic,strong) UILabel *briefLab;

@property (nonatomic,strong) UILabel *timeLab;

@property (nonatomic,strong) UIButton *hitNum;



@end

@implementation PrefectureInformationTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{

    
    self.mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(LeftMargin*Proportion,
                                                                   TopAndBottomMargin*Proportion,
                                                                   ImageWidth*Proportion,
                                                                   ImageHeight*Proportion)];
    self.mainImage.backgroundColor = [UIColor CMLPromptGrayColor];
    self.mainImage.clipsToBounds = YES;
    self.mainImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.mainImage];
    
    self.tittleLab = [[UILabel alloc] init];
    self.tittleLab.font = KSystemBoldFontSize14;
    self.tittleLab.numberOfLines = 2;
    self.tittleLab.textAlignment = NSTextAlignmentLeft;
    self.tittleLab.textColor = [UIColor CMLBlackColor];
    [self.contentView addSubview:self.tittleLab];
    
    self.briefLab = [[UILabel alloc] init];
    self.briefLab.font = KSystemBoldFontSize12;
    self.briefLab.textColor = [UIColor CMLLineGrayColor];
    self.briefLab.numberOfLines = 2;
    self.briefLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.briefLab];
    
    self.timeLab = [[UILabel alloc] init];
    self.timeLab.textColor = [UIColor CMLtextInputGrayColor];
    self.timeLab.font = KSystemBoldFontSize12;
    [self.contentView addSubview:self.timeLab];
    
    self.hitNum = [[UIButton alloc] init];
    [self.hitNum setTitleColor:[UIColor CMLLineGrayColor] forState:UIControlStateNormal];
    self.hitNum.titleLabel.font = KSystemFontSize12;
    [self.hitNum setImage:[UIImage imageNamed:PrefectureHitNumImg] forState:UIControlStateNormal];
    [self.contentView addSubview:self.hitNum];
}

- (void) refreshCurrentCell:(AuctionDetailInfoObj *) obj{

    [NetWorkTask setImageView:self.mainImage WithURL:obj.coverPic placeholderImage:nil];
    self.tittleLab.frame = CGRectZero;
    self.tittleLab.text = obj.title;
    [self.tittleLab sizeToFit];
    if (self.tittleLab.frame.size.width > WIDTH - CGRectGetMaxX(self.mainImage.frame) - Space*Proportion - LeftMargin*Proportion) {
        
        self.tittleLab.frame = CGRectMake(CGRectGetMaxX(self.mainImage.frame) + Space*Proportion,
                                          TopAndBottomMargin*Proportion,
                                          WIDTH - CGRectGetMaxX(self.mainImage.frame) - Space*Proportion - LeftMargin*Proportion,
                                          self.tittleLab.frame.size.height*2);
    }else{
    
        self.tittleLab.frame = CGRectMake(CGRectGetMaxX(self.mainImage.frame) + Space*Proportion,
                                          TopAndBottomMargin*Proportion,
                                          WIDTH - CGRectGetMaxX(self.mainImage.frame) - Space*Proportion - LeftMargin*Proportion,
                                          self.tittleLab.frame.size.height);
    }
    
    self.briefLab.frame = CGRectZero;
    self.briefLab.text = obj.briefIntro;
    [self.briefLab sizeToFit];
    
    if (self.briefLab.frame.size.width > WIDTH - CGRectGetMaxX(self.mainImage.frame) - Space*Proportion - LeftMargin*Proportion) {
        
        self.briefLab.frame = CGRectMake(CGRectGetMaxX(self.mainImage.frame) + Space*Proportion,
                                         CGRectGetMaxY(self.tittleLab.frame) + Space*Proportion,
                                         WIDTH - CGRectGetMaxX(self.mainImage.frame) - Space*Proportion - LeftMargin*Proportion,
                                         self.briefLab.frame.size.height*2);
    }else{
    
        self.briefLab.frame = CGRectMake(CGRectGetMaxX(self.mainImage.frame) + Space*Proportion,
                                         CGRectGetMaxY(self.tittleLab.frame) + Space*Proportion,
                                         WIDTH - CGRectGetMaxX(self.mainImage.frame) - Space*Proportion - LeftMargin*Proportion,
                                         self.briefLab.frame.size.height);
    }
    
    self.timeLab.text = obj.publishTimeStr;
    [self.timeLab sizeToFit];
    self.timeLab.frame = CGRectMake(CGRectGetMaxX(self.mainImage.frame) + Space*Proportion,
                                    CGRectGetMaxY(self.mainImage.frame) - self.timeLab.frame.size.height,
                                    self.timeLab.frame.size.width,
                                    self.timeLab.frame.size.height);
    
    [self.hitNum setTitle:[NSString stringWithFormat:@"%@",obj.hitNum] forState:UIControlStateNormal];
    [self.hitNum sizeToFit];
    self.hitNum.frame = CGRectMake(WIDTH - LeftMargin*Proportion - self.hitNum.frame.size.width,
                                   self.timeLab.center.y - self.hitNum.frame.size.height/2.0,
                                   self.hitNum.frame.size.width,
                                   self.hitNum.frame.size.height);
    
    self.cellHeight = CGRectGetMaxY(self.mainImage.frame) + TopAndBottomMargin*Proportion;

}
@end
