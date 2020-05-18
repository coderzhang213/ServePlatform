//
//  CMLBrandModuleTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/28.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLBrandModuleTVCell.h"
#import "NetWorkTask.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "BrandModuleObj.h"

@interface CMLBrandModuleTVCell()

@property (nonatomic,strong) UIImageView *logoImg;

@property (nonatomic,strong) UILabel *brandName;

@property (nonatomic,strong) UIView *endLine;

@end

@implementation CMLBrandModuleTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    self.logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(25*Proportion, 40*Proportion, 80*Proportion, 80*Proportion)];
    self.logoImg.contentMode =  UIViewContentModeScaleAspectFill;
    self.logoImg.layer.cornerRadius = 80*Proportion/2.0;
    self.logoImg.backgroundColor = [UIColor CMLNewGrayColor];
    self.logoImg.layer.borderColor = [UIColor CMLSerachLineGrayColor].CGColor;
    self.logoImg.layer.borderWidth = 1*Proportion;;
    self.logoImg.clipsToBounds = YES;
    [self addSubview:self.logoImg];
    
    self.brandName = [[UILabel alloc] init];
    self.brandName.font = KSystemBoldFontSize15;
    self.brandName.textColor = [UIColor CMLBlackColor];
    [self addSubview:self.brandName];
    
    self.endLine = [[UILabel alloc] init];
    self.endLine.backgroundColor = [UIColor CMLNewGrayColor];
    [self addSubview:self.endLine];
    
    
}

- (void) refreshCurrentCellWith:(BrandModuleObj *) ob{
    
    
    [NetWorkTask setImageView:self.logoImg WithURL:ob.logoPic placeholderImage:nil];
    self.brandName.frame = CGRectZero;
    self.brandName.text = ob.name;
    [self.brandName sizeToFit];
    self.brandName.frame = CGRectMake(CGRectGetMaxX(self.logoImg.frame) + 20*Proportion,
                                      self.logoImg.center.y - self.brandName.frame.size.height/2.0,
                                      self.brandName.frame.size.width,
                                      self.brandName.frame.size.height);
    
    self.endLine.frame = CGRectMake(CGRectGetMaxX(self.logoImg.frame) + 20*Proportion,
                                    CGRectGetMaxY(self.logoImg.frame) + 29*Proportion,
                                    WIDTH - (CGRectGetMaxX(self.logoImg.frame) + 20*Proportion) - 30*Proportion,
                                    1*Proportion);
    
    
}
- (void) hiddenLine{
    
    self.endLine.hidden = YES;
}

- (void) showLine{
    self.endLine.hidden = NO;
}
@end
