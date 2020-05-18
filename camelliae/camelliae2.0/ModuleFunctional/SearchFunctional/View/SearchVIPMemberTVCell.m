//
//  SearchVIPMemberTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2017/1/10.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "SearchVIPMemberTVCell.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"


@interface SearchVIPMemberTVCell ()

@property (nonatomic,strong) UIImageView *userImage;

@property (nonatomic,strong) UILabel *userNickNameLab;

@property (nonatomic,strong) UILabel *userLvlLab;

@property (nonatomic,strong) UILabel *userVIPGradeLab;

@property (nonatomic,strong) UILabel *userPositionLab;

@property (nonatomic,strong) UIImageView *promEnterImg;

@end

@implementation SearchVIPMemberTVCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self loadViews];
    }
    return self;
}

- (void) loadViews{

    
    self.userImage = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                   20*Proportion,
                                                                   100*Proportion,
                                                                   100*Proportion)];
    self.userImage.layer.cornerRadius = 4*Proportion;
    self.userImage.userInteractionEnabled = YES;
    self.userImage.contentMode = UIViewContentModeScaleAspectFill;
    self.userImage.clipsToBounds = YES;
    self.userImage.backgroundColor = [UIColor CMLPromptGrayColor];
    [self.contentView addSubview:self.userImage];
    
    self.userNickNameLab = [[UILabel alloc] init];
    self.userNickNameLab.font = KSystemBoldFontSize14;
    self.userNickNameLab.textColor = [UIColor CMLBlackColor];
    [self.contentView addSubview:self.userNickNameLab];
    
    self.userLvlLab = [[UILabel alloc] init];
    self.userLvlLab.font = KSystemFontSize10;
    self.userLvlLab.textAlignment = NSTextAlignmentCenter;
    self.userLvlLab.layer.borderWidth = 1*Proportion;
    self.userLvlLab.layer.cornerRadius = 2*Proportion;
    self.userLvlLab.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.userLvlLab];
    
    self.userVIPGradeLab = [[UILabel alloc] init];
    self.userVIPGradeLab.font = KSystemFontSize10;
    self.userVIPGradeLab.textAlignment = NSTextAlignmentCenter;
    self.userVIPGradeLab.layer.borderWidth = 1*Proportion;
    self.userVIPGradeLab.layer.cornerRadius = 2*Proportion;
    self.userVIPGradeLab.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.userVIPGradeLab];
    
    self.userPositionLab = [[UILabel alloc] init];
    self.userPositionLab.font = KSystemFontSize12;
    self.userPositionLab.textColor = [UIColor CMLLineGrayColor];
    [self.contentView addSubview:self.userPositionLab];
    
    UIImageView *enterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NewPersonalCenterUserEnterVCImg]];
    [enterImage sizeToFit];
    enterImage.frame = CGRectMake(WIDTH - 30*Proportion - enterImage.frame.size.width,
                                  140*Proportion/2.0 - enterImage.frame.size.height/2.0,
                                  enterImage.frame.size.width,
                                  enterImage.frame.size.height);
    [self.contentView addSubview:enterImage];
    
}

- (void) refreshSearchCell{

    [NetWorkTask setImageView:self.userImage WithURL:self.userImageUrl placeholderImage:nil];
    
    self.userNickNameLab.text = self.nickName;
    [self.userNickNameLab sizeToFit];
    self.userNickNameLab.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 10*Proportion,
                                            20*Proportion,
                                            self.userNickNameLab.frame.size.width,
                                            self.userNickNameLab.frame.size.height);
    self.userPositionLab.text = self.position;
    [self.userPositionLab sizeToFit];
    self.userPositionLab.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 10*Proportion,
                                            CGRectGetMaxY(self.userNickNameLab.frame) + 10*Proportion,
                                            self.userPositionLab.frame.size.width,
                                            self.userPositionLab.frame.size.height);
    
    self.userLvlLab.text = self.lvl;
    self.userLvlLab.layer.borderColor = [UIColor getLvlColor:self.memberLvl].CGColor;
    self.userLvlLab.textColor = [UIColor getLvlColor:self.memberLvl];
    [self.userLvlLab sizeToFit];
    self.userLvlLab.frame = CGRectMake(CGRectGetMaxX(self.userNickNameLab.frame) + 10*Proportion,
                                       20*Proportion,
                                       self.userLvlLab.frame.size.width + 20*Proportion,
                                       28*Proportion);
    
    switch ([self.vipGrade intValue]) {
        case 0:
            self.userVIPGradeLab.hidden = YES;
            break;
            
        case 1:
            self.userVIPGradeLab.hidden = YES;
            break;
            
        case 2:
            self.userVIPGradeLab.text = @"黛色特权";
            self.userVIPGradeLab.layer.borderColor = [UIColor CMLBlackPigmentColor].CGColor;
            self.userVIPGradeLab.textColor = [UIColor CMLBlackPigmentColor];
            break;
            
        case 3:
            self.userVIPGradeLab.text = @"金色特权";
            self.userVIPGradeLab.layer.borderColor = [UIColor CMLGoldColor].CGColor;
            self.userVIPGradeLab.textColor = [UIColor CMLGoldColor];
            break;
            
        case 4:
            self.userVIPGradeLab.hidden = YES;
            break;
            
        default:
            break;
    }
    [self.userVIPGradeLab sizeToFit];
    self.userVIPGradeLab.frame = CGRectMake(CGRectGetMaxX(self.userLvlLab.frame) + 10*Proportion,
                                            20*Proportion,
                                            self.userVIPGradeLab.frame.size.width + 20*Proportion,
                                            28*Proportion);
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
