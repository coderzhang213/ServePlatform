//
//  CMLUserPushGoodsCVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2018/11/20.
//  Copyright © 2018 张越. All rights reserved.
//

#import "CMLUserPushGoodsCVCell.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "PackageInfoObj.h"
#import "PackDetailInfoObj.h"
#import "SearchResultObj.h"

#define ImageWidth  330
#define ImageHeight 330

@interface CMLUserPushGoodsCVCell ()

@property (nonatomic,strong) UIView *imageBgView;

@property (nonatomic,strong) UIImageView *mainImageView;

@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) UILabel *priceLab;

/*新增：浏览量*/
@property (nonatomic, strong) UIImageView *hitImageView;

@property (nonatomic, strong) UILabel *hitLabel;

@end

@implementation CMLUserPushGoodsCVCell
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
    self.priceLab.text = [NSString stringWithFormat:@"¥%@",obj.price];
    [self.priceLab sizeToFit];
    
    
    
    if (self.isMoveModule) {
        

        
        if (self.titleLab.frame.size.width > ImageWidth*Proportion) {
            
            self.titleLab.frame = CGRectMake(30*Proportion,
                                             CGRectGetMaxY(self.imageBgView.frame) + 10*Proportion,
                                             ImageWidth*Proportion,
                                             self.titleLab.frame.size.height*2);
            
            self.priceLab.frame = CGRectMake(30*Proportion,
                                             CGRectGetMaxY(self.titleLab.frame) + 20*Proportion,
                                             self.priceLab.frame.size.width,
                                             self.priceLab.frame.size.height);
        }else{
            
            self.titleLab.frame = CGRectMake(30*Proportion,
                                             CGRectGetMaxY(self.imageBgView.frame) + 10*Proportion,
                                             ImageWidth*Proportion,
                                             self.titleLab.frame.size.height);
            
            self.priceLab.frame = CGRectMake(30*Proportion,
                                             CGRectGetMaxY(self.titleLab.frame) + 20*Proportion + self.titleLab.frame.size.height,
                                             self.priceLab.frame.size.width,
                                             self.priceLab.frame.size.height);
        }
        
    }else{
        
        
        if (self.titleLab.frame.size.width > ImageWidth*Proportion) {
            
            self.titleLab.frame = CGRectMake(0,
                                             CGRectGetMaxY(self.imageBgView.frame) + 10*Proportion,
                                             ImageWidth*Proportion,
                                             self.titleLab.frame.size.height*2);
            
            self.priceLab.frame = CGRectMake(0,
                                             CGRectGetMaxY(self.titleLab.frame) + 20*Proportion,
                                             self.priceLab.frame.size.width,
                                             self.priceLab.frame.size.height);
        }else{
            
            self.titleLab.frame = CGRectMake(0,
                                             CGRectGetMaxY(self.imageBgView.frame) + 10*Proportion,
                                             ImageWidth*Proportion,
                                             self.titleLab.frame.size.height);
            
            self.priceLab.frame = CGRectMake(0,
                                             CGRectGetMaxY(self.titleLab.frame) + 20*Proportion + self.titleLab.frame.size.height,
                                             self.priceLab.frame.size.width,
                                             self.priceLab.frame.size.height);
        }
        
    }
    
    /*新增：浏览量*/
    [self.hitImageView sizeToFit];
    self.hitImageView.frame = CGRectMake(CGRectGetMaxX(self.priceLab.frame) + 20*Proportion,
                                         self.priceLab.center.y - self.hitImageView.frame.size.height/2.0,
                                         self.hitImageView.frame.size.width,
                                         self.hitImageView.frame.size.height);
    
    if (obj.hitNum) {
        self.hitLabel.text =  [NSString stringWithFormat:@"%@", obj.hitNum];
    }else {
        self.hitLabel.text = @"0";
    }

    [self.hitLabel sizeToFit];
    self.hitLabel.frame = CGRectMake(CGRectGetMaxX(self.hitImageView.frame) + 20*Proportion,
                                     self.priceLab.center.y - self.hitLabel.frame.size.height/2.0,
                                     self.hitLabel.frame.size.width,
                                     self.hitLabel.frame.size.height);
    
}


@end
