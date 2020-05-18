//
//  CMLWalletCenterMyTeamCell.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/17.
//  Copyright © 2019 张越. All rights reserved.
//

#import "CMLWalletCenterMyTeamCell.h"
#import "CommonImg.h"
#import "Network.h"
#import "CMLTeamInfoModel.h"

@interface CMLWalletCenterMyTeamCell ()

@property (nonatomic, strong) UIView *myTeamCellBgView;

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIImageView *probationImage;

@property (nonatomic, strong) UILabel *teamCountLabel;

@end

@implementation CMLWalletCenterMyTeamCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadMyTeamCellView];
    }
    return self;
    
}

- (void)loadMyTeamCellView {
    
    [self addSubview:self.myTeamCellBgView];
    [self.myTeamCellBgView addSubview:self.headImageView];
    [self.myTeamCellBgView addSubview:self.nameLabel];
    [self.myTeamCellBgView addSubview:self.timeLabel];
    [self.myTeamCellBgView addSubview:self.probationImage];
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(34 * Proportion,
                                                                   CGRectGetHeight(self.myTeamCellBgView.frame) - 1 * Proportion,
                                                                   WIDTH - 34 * Proportion * 2,
                                                                   1 * Proportion)];
    lineLabel.backgroundColor = [UIColor CMLDBDBDBColor];
    [self.myTeamCellBgView addSubview:lineLabel];
    
}

- (void)refreshCurrentCell:(CMLTeamInfoModel *)obj withTeamType:(int)teamType {
    
    [NetWorkTask setImageView:self.headImageView WithURL:obj.gravatar placeholderImage:nil];
    
    if (!obj.userName) {
        self.nameLabel.text = @"用户";
    }else {
        self.nameLabel.text = obj.userName;
    }
    [self.nameLabel sizeToFit];
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame) + 28 * Proportion,
                                      62 * Proportion,
                                      WIDTH/2,//CGRectGetWidth(self.nameLabel.frame),
                                      CGRectGetHeight(self.nameLabel.frame));
    
    if ([obj.distribution_level intValue] != 1) {
        self.probationImage.hidden = YES;
    }
    self.probationImage.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame),
                                           CGRectGetMidY(self.nameLabel.frame) - CGRectGetHeight(self.probationImage.frame)/2,
                                           CGRectGetWidth(self.probationImage.frame),
                                           CGRectGetHeight(self.probationImage.frame));
    
    self.timeLabel.text = obj.created_at_str;
    [self.timeLabel sizeToFit];
    self.timeLabel.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame),
                                      CGRectGetMaxY(self.nameLabel.frame) + 1*Proportion,
                                      CGRectGetWidth(self.timeLabel.frame) + 100 * Proportion,
                                      CGRectGetHeight(self.timeLabel.frame));

    if (teamType == 0) {
        NSString *countString = [NSString stringWithFormat:@"团队 %@ 人", obj.count];
        self.teamCountLabel.text = countString;
        [self.teamCountLabel sizeToFit];
        self.teamCountLabel.frame = CGRectMake(CGRectGetWidth(self.myTeamCellBgView.frame) - CGRectGetWidth(self.teamCountLabel.frame) - 30 * Proportion,
                                               62 * Proportion,
                                               CGRectGetWidth(self.teamCountLabel.frame),
                                               CGRectGetHeight(self.teamCountLabel.frame));
        [self.myTeamCellBgView addSubview:self.teamCountLabel];
    }
    
}
/*
- (void)refreshBCurrentCell:(CMLTeamInfoModel *)obj {
    
    [NetWorkTask setImageView:self.headImageView WithURL:obj.gravatar placeholderImage:nil];
    
    self.nameLabel.frame = CGRectZero;
    if (!obj.userName) {
        self.nameLabel.text = @"黛色用户";
    }else {
        self.nameLabel.text = obj.userName;
    }
    [self.nameLabel sizeToFit];
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame) + 28 * Proportion,
                                      62 * Proportion,
                                      CGRectGetWidth(self.nameLabel.frame),
                                      CGRectGetHeight(self.nameLabel.frame));
    
    if ([obj.distribution_level intValue] != 1) {
        self.probationImage.hidden = YES;
        self.probationImage.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame),
                                               CGRectGetMidY(self.nameLabel.frame) - CGRectGetHeight(self.probationImage.frame)/2,
                                               CGRectGetWidth(self.probationImage.frame),
                                               CGRectGetHeight(self.probationImage.frame));
    }
    
    self.timeLabel.text = obj.created_at_str;
    [self.timeLabel sizeToFit];
    self.timeLabel.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame),
                                      CGRectGetMaxY(self.nameLabel.frame) + 1*Proportion,
                                      CGRectGetWidth(self.timeLabel.frame),
                                      CGRectGetHeight(self.timeLabel.frame));
    
}
*/
- (UIView *)myTeamCellBgView {
    
    if (!_myTeamCellBgView) {
        _myTeamCellBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 179 * Proportion)];
        _myTeamCellBgView.backgroundColor = [UIColor whiteColor];
        _myTeamCellBgView.userInteractionEnabled  = YES;
    }
    return _myTeamCellBgView;
}

- (UIImageView *)headImageView {
    
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(69 * Proportion, 40 * Proportion, 100 * Proportion, 100 * Proportion)];
#pragma _headImageView.backgroundColor = [UIColor CMLGrayColor];
        _headImageView.backgroundColor = [UIColor CMLGrayColor];
        _headImageView.clipsToBounds = YES;
        _headImageView.layer.cornerRadius = 100 * Proportion/2;
        _headImageView.userInteractionEnabled = YES;
        
    }
    return _headImageView;
}

- (UIImageView *)probationImage {
    
    if (!_probationImage) {
        _probationImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLWalletCenterProbationImage]];
        _probationImage.backgroundColor = [UIColor clearColor];
        _probationImage.userInteractionEnabled = YES;
        [_probationImage sizeToFit];
    }
    return _probationImage;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor CMLUserBlackColor];
        _nameLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _nameLabel.numberOfLines = 1;
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor CML9E9E9EColor];
        _timeLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightThin];
        _timeLabel.numberOfLines = 1;
    }
    return _timeLabel;
}

- (UILabel *)teamCountLabel {
    
    if (!_teamCountLabel) {
        _teamCountLabel = [[UILabel alloc] init];
        _teamCountLabel.text = @"团队 0 人";
        _teamCountLabel.textColor = [UIColor CML686868Color];
        _teamCountLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    }
    return _teamCountLabel;
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
