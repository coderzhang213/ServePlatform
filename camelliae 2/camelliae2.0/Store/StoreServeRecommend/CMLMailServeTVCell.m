//
//  CMLMailServeTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/25.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLMailServeTVCell.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "CMLServeObj.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"

@interface CMLMailServeTVCell()

@property (nonatomic,strong) UIImageView *mainImage;

@property (nonatomic,strong) UILabel *tagLab;

@property (nonatomic,strong) UILabel *tagLab1;

@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) UILabel *priceLab;

@property (nonatomic,strong) UIImageView *tagImage;

@property (nonatomic,strong) UIView *bottomLine;

@property (nonatomic,strong) UILabel *pricePromLab;

@property (nonatomic,strong) UILabel *preTag;

@property (nonatomic,strong) UIButton *videoBtn;

/*新增：浏览量*/
@property (nonatomic, strong) UIImageView *hitImageView;

@property (nonatomic, strong) UILabel *hitLabel;

@end

@implementation CMLMailServeTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    self.mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                   30*Proportion,
                                                                   WIDTH - 30*Proportion*2,
                                                                   460*Proportion)];
    self.mainImage.clipsToBounds = YES;
    self.mainImage.contentMode = UIViewContentModeScaleAspectFill;
    self.mainImage.userInteractionEnabled = YES;
    self.mainImage.layer.cornerRadius = 10*Proportion;
    self.mainImage.backgroundColor = [UIColor CMLNewGrayColor];
    [self.contentView addSubview:self.mainImage];
    
    self.videoBtn = [[UIButton alloc] initWithFrame:self.mainImage.bounds];
    self.videoBtn.backgroundColor = [UIColor clearColor];
    [self.videoBtn setImage:[UIImage imageNamed:NewMesListVideoPlayImg] forState:UIControlStateNormal];
    [self.mainImage addSubview:self.videoBtn];
    [self.videoBtn addTarget:self action:@selector(showVideo) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.preTag = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 82*Proportion, 50*Proportion)];
    self.preTag.backgroundColor = [UIColor CMLBlackColor];
    self.preTag.textColor = [UIColor CMLBrownColor];
    self.preTag.font = KSystemFontSize13;
    self.preTag.text = @"预售";
    self.preTag.textAlignment = NSTextAlignmentCenter;
    [self.mainImage addSubview:self.preTag];
    self.preTag.hidden = YES;
    
    self.tagLab = [[UILabel alloc] init];
    self.tagLab.textColor = [UIColor CMLLightBrownColor];
    self.tagLab.font = KSystemFontSize10;
    self.tagLab.textAlignment = NSTextAlignmentCenter;
    self.tagLab.layer.borderColor = [UIColor CMLLightBrownColor].CGColor;
    self.tagLab.layer.borderWidth = 1*Proportion;
    [self.contentView addSubview:self.tagLab];
    
    self.tagLab1 = [[UILabel alloc] init];
    self.tagLab1.textColor = [UIColor CMLLightBrownColor];
    self.tagLab1.font = KSystemFontSize10;
    self.tagLab1.textAlignment = NSTextAlignmentCenter;
    self.tagLab1.layer.borderColor = [UIColor CMLLightBrownColor].CGColor;
    self.tagLab1.layer.borderWidth = 1*Proportion;
    [self.contentView addSubview:self.tagLab1];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.font = KSystemBoldFontSize15;
    self.titleLab.textColor = [UIColor CMLBlackColor];
    self.titleLab.numberOfLines = 0;
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLab];
    
    self.priceLab = [[UILabel alloc] init];
    self.priceLab.font = KSystemBoldFontSize21;
    self.priceLab.textColor = [UIColor CMLBrownColor];
    [self.contentView addSubview:self.priceLab];

    
    self.pricePromLab = [[UILabel alloc] init];
    self.pricePromLab.textColor = [UIColor CMLWhiteColor];
    self.pricePromLab.text = @"订金";
    self.pricePromLab.font = KSystemFontSize10;
    self.pricePromLab.layer.cornerRadius = 6*Proportion;
    self.pricePromLab.clipsToBounds = YES;
    self.pricePromLab.textAlignment = NSTextAlignmentCenter;
    self.pricePromLab.backgroundColor = [UIColor CMLBrownColor];
    [self.contentView addSubview:self.pricePromLab];
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = [UIColor CMLNewGrayColor];
    [self.contentView addSubview:self.bottomLine];
    
    /*新增L：浏览量*/
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

- (void) refreshCurrent:(CMLServeObj *) obj{
    
    
    self.imageRect = self.mainImage.frame;
    
    [NetWorkTask setImageView:self.mainImage WithURL:obj.coverPic placeholderImage:nil];
    
    if (obj.video_url.length > 0 || [obj.is_video_project intValue] == 1) {
        
        self.videoBtn.hidden = NO;
        self.videoBtn.frame = CGRectMake(self.mainImage.frame.size.width/2.0 - 76*Proportion/2.0,
                                         self.mainImage.frame.size.height/2.0 - 76*Proportion/2.0,
                                         76*Proportion,
                                         76*Proportion);
        
    }else{
        
        self.videoBtn.hidden = YES;
    }
    
    self.tagLab.frame = CGRectZero;
    self.tagLab.text = obj.brandInfo.name;
    [self.tagLab sizeToFit];
    self.tagLab.frame = CGRectMake(30*Proportion,
                                   CGRectGetMaxY(self.mainImage.frame) + 20*Proportion,
                                   self.tagLab.frame.size.width + 10*Proportion,
                                   self.tagLab.frame.size.height + 5*Proportion);
    self.tagLab1.frame = CGRectZero;
    self.tagLab1.text = obj.parentTypeName;
    [self.tagLab1 sizeToFit];
    self.tagLab1.frame = CGRectMake(CGRectGetMaxX(self.tagLab.frame) + 20*Proportion,
                                    CGRectGetMaxY(self.mainImage.frame) + 20*Proportion,
                                    self.tagLab1.frame.size.width + 10*Proportion,
                                    self.tagLab1.frame.size.height + 5*Proportion);
    
    
    self.titleLab.frame = CGRectZero;
    self.titleLab.text = obj.title;
    
    CGRect currentRect = [self.titleLab.text boundingRectWithSize:CGSizeMake(WIDTH - 30*Proportion*2,HEIGHT)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:KSystemFontSize17}
                                                          context:nil];

    
    
    self.titleLab.frame = CGRectMake(30*Proportion,
                                     CGRectGetMaxY(self.tagLab.frame) + 20*Proportion,
                                     WIDTH - 30*Proportion*2,
                                     currentRect.size.height);
    
    
    
    self.priceLab.frame = CGRectZero;
    self.priceLab.text = [NSString stringWithFormat:@"¥%@",obj.price];
    [self.priceLab sizeToFit];
    self.priceLab.frame = CGRectMake(30*Proportion,
                                     CGRectGetMaxY(self.titleLab.frame) + 30*Proportion,
                                     self.priceLab.frame.size.width,
                                     self.priceLab.frame.size.height);
    
    
    PackDetailInfoObj *costObj = [PackDetailInfoObj getBaseObjFrom:[obj.packageInfo.dataList firstObject]];
    if ([costObj.payMode intValue] == 1) {
        self.pricePromLab.hidden = NO;
        self.pricePromLab.frame = CGRectMake(CGRectGetMaxX(self.priceLab.frame) + 10*Proportion,
                                             self.priceLab.center.y - 40*Proportion/2.0,
                                             50*Proportion,
                                             40*Proportion);
    }else{
        
        self.pricePromLab.hidden = YES;
    }

    if ([costObj.is_pre intValue] == 1) {
        
        self.preTag.hidden = NO;
    }else{
        
        self.preTag.hidden = YES;
    }
    
    
    
    self.bottomLine.frame = CGRectMake(30*Proportion,
                                       CGRectGetMaxY(self.priceLab.frame) + 30*Proportion,
                                       WIDTH - 30*Proportion*2,
                                       1);
    
    /*新增：浏览量*/
    if (obj.hitNum) {
        self.hitLabel.text =  [NSString stringWithFormat:@"%@", obj.hitNum];
    }else {
        self.hitLabel.text = @"0";
    }
    
    [self.hitLabel sizeToFit];
    self.hitLabel.frame = CGRectMake(CGRectGetMaxX(self.mainImage.frame) - self.hitLabel.frame.size.width,
                                     self.priceLab.center.y - self.hitLabel.frame.size.height/2.0,
                                     self.hitLabel.frame.size.width,
                                     self.hitLabel.frame.size.height);
    
    [self.hitImageView sizeToFit];
    self.hitImageView.frame = CGRectMake(self.hitLabel.frame.origin.x - 10*Proportion - self.hitImageView.frame.size.width,
                                         self.hitLabel.center.y - self.hitImageView.frame.size.height/2.0,
                                         self.hitImageView.frame.size.width,
                                         self.hitImageView.frame.size.height);
    
    
    self.currentheight = CGRectGetMaxY(self.bottomLine.frame);
    

    
}

- (void) showVideo{
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cl_tableViewCellPlayVideoWithCell:)]) {
        
        [self.delegate cl_tableViewCellPlayVideoWithCell:self];
    }
}

- (void) showBtnView{
    
    
    self.videoBtn.hidden = NO;
}

- (void) hidenBtnView{
    
    self.videoBtn.hidden = YES;
}
@end
