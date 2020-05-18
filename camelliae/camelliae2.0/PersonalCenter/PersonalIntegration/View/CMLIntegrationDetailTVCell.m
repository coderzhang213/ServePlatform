//
//  CMLIntegrationDetailTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2017/8/17.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLIntegrationDetailTVCell.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"


@interface CMLIntegrationDetailTVCell ()

@property (nonatomic,strong) UILabel *integrationDetailLab;

@property (nonatomic,strong) UILabel *pointsLab;

@property (nonatomic,strong) UILabel *timeLab;


@end

@implementation CMLIntegrationDetailTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self loadViews];
    }
    
    return self;
}


- (void) loadViews{

    self.integrationDetailLab = [[UILabel alloc] init];
    self.integrationDetailLab.font = KSystemFontSize13;
    self.integrationDetailLab.textColor = [UIColor CMLBlackColor];
    [self.contentView addSubview:self.integrationDetailLab];
    
    self.timeLab = [[UILabel alloc] init];
    self.timeLab.font = KSystemFontSize11;
    self.timeLab.textColor = [UIColor CMLLineGrayColor];
    [self.contentView addSubview:self.timeLab];
    
    self.pointsLab = [[UILabel alloc] init];
    self.pointsLab.font = KSystemFontSize15;
    self.pointsLab.textColor = [UIColor CMLLineGrayColor];
    [self.contentView addSubview:self.pointsLab];
}

- (void) refreshCurrentTVCell{

    
    self.integrationDetailLab.text = self.logTypeName;
    [self.integrationDetailLab sizeToFit];
    self.integrationDetailLab.frame = CGRectMake(30*Proportion,
                                                 30*Proportion,
                                                 self.integrationDetailLab.frame.size.width,
                                                 self.integrationDetailLab.frame.size.height);
    
    self.timeLab.text = self.createTime;
    [self.timeLab sizeToFit];
    self.timeLab.frame = CGRectMake(30*Proportion,
                                    CGRectGetMaxY(self.integrationDetailLab.frame) + 12*Proportion,
                                    self.timeLab.frame.size.width,
                                    self.timeLab.frame.size.height);
    if ([self.status intValue] == 1) {
        
        self.pointsLab.text = [NSString stringWithFormat:@"+%@",self.point];
        self.pointsLab.textColor = [UIColor CMLGreeenColor];
    }else{
    
        self.pointsLab.text = [NSString stringWithFormat:@"-%@",self.point];
        self.pointsLab.textColor = [UIColor CMLNewPinkColor];
    }
    
    
    [self.pointsLab sizeToFit];
    self.pointsLab.frame = CGRectMake(WIDTH - 30*Proportion - self.pointsLab.frame.size.width,
                                      120*Proportion/2.0 - self.pointsLab.frame.size.height/2.0,
                                      self.pointsLab.frame.size.width,
                                      self.pointsLab.frame.size.height);
}
@end
