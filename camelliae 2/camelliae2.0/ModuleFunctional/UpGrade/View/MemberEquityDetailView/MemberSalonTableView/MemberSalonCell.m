//
//  MemberSalonCell.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/14.
//  Copyright © 2019 张越. All rights reserved.
//

#import "MemberSalonCell.h"
#import "MemberSalonModel.h"
#import "NetWorkTask.h"

@interface MemberSalonCell ()

@property (nonatomic, strong) UIView *memberSalonBgView;

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *stateImage;

@end

@implementation MemberSalonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadSalonCellView];
    }
    return self;
    
}

- (void)loadSalonCellView {
    
    [self addSubview:self.memberSalonBgView];
    [self.memberSalonBgView addSubview:self.iconImage];
    [self.memberSalonBgView addSubview:self.stateImage];
    [self.memberSalonBgView addSubview:self.titleLabel];
    
}

- (void)refreshCurrentCell:(MemberSalonModel *)obj withCanJoin:(NSString *)canJoin {
    
    [NetWorkTask setImageView:self.iconImage WithURL:obj.objCoverPic placeholderImage:nil];
/*固定了label大小*/
    self.titleLabel.text = obj.title;
    
    if ([canJoin intValue] == 1) {
        
        if ([obj.isJoin intValue] == 1) {
            self.stateImage.image = [UIImage imageNamed:CMLMemberEquityBeenUseImage];
        }else {
            self.stateImage.image = [UIImage imageNamed:CMLMemberEquityNotUseImage];
        }
        
    }

    self.currentHeight = CGRectGetHeight(self.memberSalonBgView.frame) + 20 * Proportion;
    
}

- (UIView *)memberSalonBgView {
    
    if (!_memberSalonBgView) {
        _memberSalonBgView = [[UIView alloc] initWithFrame:CGRectMake(48 * Proportion,
                                                                      10 * Proportion,
                                                                      504 * Proportion,
                                                                      126 * Proportion)];
        
        _memberSalonBgView.backgroundColor = [UIColor CMLFAFAFAColor];
        _memberSalonBgView.clipsToBounds = YES;
        _memberSalonBgView.layer.cornerRadius = 8 * Proportion;
        _memberSalonBgView.layer.borderColor = [UIColor CMLScrollLineWhiterColor].CGColor;
        _memberSalonBgView.layer.borderWidth = 1*Proportion;
        _memberSalonBgView.userInteractionEnabled  = YES;
        
    }
    return _memberSalonBgView;
}

- (UIImageView *)iconImage {
    
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   196 * Proportion,
                                                                   126 * Proportion)];
        _iconImage.backgroundColor = [UIColor CMLNewGrayColor];
//        _iconImage.contentMode = UIViewContentModeScaleAspectFill;
        _iconImage.userInteractionEnabled = YES;
        
    }
    return _iconImage;
    
}

- (UIImageView *)stateImage {
    
    if (!_stateImage) {
        _stateImage = [[UIImageView alloc] initWithFrame:CGRectMake(504 * Proportion - 70 * Proportion,
                                                                    0,
                                                                    70 * Proportion,
                                                                    74 * Proportion)];
        _stateImage.backgroundColor = [UIColor clearColor];
        _stateImage.contentMode = UIViewContentModeScaleAspectFill;
        _stateImage.userInteractionEnabled = YES;
        
    }
    return _stateImage;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(210 * Proportion, 31 * Proportion, 264 * Proportion, 66 * Proportion)];
        _titleLabel.textColor = [UIColor CMLIntroGrayColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    }
    return _titleLabel;
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
