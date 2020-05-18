//
//  CMLIncomeCell.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/18.
//  Copyright © 2019 张越. All rights reserved.
//

#import "CMLIncomeCell.h"
#import "CommonImg.h"
#import "Network.h"
#import "CMLWalletCenterModel.h"

@interface CMLIncomeCell ()

@property (nonatomic, strong) UIView *myTeamCellBgView;

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) UIImageView *probationImage;

@property (nonatomic, strong) UILabel *teamCountLabel;

@end

@implementation CMLIncomeCell

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
    [self.myTeamCellBgView addSubview:self.titleLabel];
    [self.myTeamCellBgView addSubview:self.nameLabel];
    [self.myTeamCellBgView addSubview:self.timeLabel];
    [self.myTeamCellBgView addSubview:self.probationImage];
    [self.myTeamCellBgView addSubview:self.statusLabel];
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(34 * Proportion, CGRectGetHeight(self.myTeamCellBgView.frame) - 2 * Proportion, WIDTH - 34 * Proportion * 2, 1 * Proportion)];
    lineLabel.backgroundColor = [UIColor CMLDBDBDBColor];
    [self.myTeamCellBgView addSubview:lineLabel];
    
}

- (void)refreshCurrentCell:(CMLWalletCenterModel *)obj {
    
    [NetWorkTask setImageView:self.headImageView WithURL:obj.gravatar placeholderImage:nil];
    
    if (obj.userName) {
        
        self.nameLabel.frame = CGRectZero;
        self.nameLabel.text = obj.userName;
        CGRect currentRect = [self.nameLabel.text boundingRectWithSize:CGSizeMake(WIDTH - (CGRectGetMaxX(self.headImageView.frame) + 28 * Proportion)*2, HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 weight:UIFontWeightRegular]} context:nil];
        
        self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame) + 28 * Proportion,
                                          CGRectGetMidY(self.headImageView.frame) - currentRect.size.height/2,
                                          currentRect.size.width,
                                          currentRect.size.height);
    }
    
    if ([obj.type intValue] == 4 ) {
        
        self.probationImage.hidden = YES;
        self.statusLabel.hidden = NO;
        self.statusLabel.text = @"提现";
        if ([obj.status intValue] == 1) {
            self.statusLabel.text = @"提现";
        }else if ([obj.status intValue] == 2){
            self.statusLabel.text = @"提现中";
        }else {
            self.statusLabel.text = @"提现失败";
        }
        [self.statusLabel sizeToFit];
        self.statusLabel.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 18 * Proportion,
                                  CGRectGetMinY(self.nameLabel.frame) + 4*Proportion,
                                  CGRectGetWidth(self.statusLabel.frame),
                                  CGRectGetHeight(self.statusLabel.frame));
    }else {
        
        self.statusLabel.hidden = YES;
        
        if ([obj.type intValue] == 2) {
            self.probationImage.hidden = NO;
        }
        self.probationImage.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame),
                                               CGRectGetMidY(self.nameLabel.frame) - CGRectGetHeight(self.probationImage.frame)/2,
                                               CGRectGetWidth(self.probationImage.frame),
                                               CGRectGetHeight(self.probationImage.frame));
        
    }

    self.teamCountLabel.text = obj.costStr;
    NSLog(@"costStr===%@", obj.costStr);
    [self.teamCountLabel sizeToFit];
    self.teamCountLabel.frame = CGRectMake(CGRectGetWidth(self.myTeamCellBgView.frame) - CGRectGetWidth(self.teamCountLabel.frame) - 32 * Proportion,
                                           56 * Proportion,
                                           190 * Proportion,
                                           CGRectGetHeight(self.teamCountLabel.frame));
    [self.myTeamCellBgView addSubview:self.teamCountLabel];
    
    if ([obj.status intValue] == 3) {
        self.teamCountLabel.textColor = [UIColor redColor];
    }
    
    self.timeLabel.text = obj.created_at_str;
    [self.timeLabel sizeToFit];
    self.timeLabel.frame = CGRectMake(CGRectGetWidth(self.myTeamCellBgView.frame) - CGRectGetWidth(self.timeLabel.frame) - 32 * Proportion - 10 * Proportion,
                                      CGRectGetMaxY(self.teamCountLabel.frame) + 8*Proportion,
                                      CGRectGetWidth(self.timeLabel.frame) + 10 * Proportion,
                                      CGRectGetHeight(self.timeLabel.frame));
    
}

- (void)refreshRebateCurrentCell:(CMLWalletCenterModel *)obj {
    
    [NetWorkTask setImageView:self.headImageView WithURL:obj.gravatar placeholderImage:nil];
        
    self.titleLabel.frame = CGRectZero;
    if (obj.title.length > 0) {
        self.titleLabel.text = obj.title;
    }else {
        self.titleLabel.text = @"暂无订单名称";
    }
    
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame) + 28 * Proportion,
                                      56 * Proportion,
                                      WIDTH/2,
                                      CGRectGetHeight(self.titleLabel.frame));
    
    
    if (obj.userName.length > 0) {
        self.nameLabel.text = obj.userName;
    }else {
        self.nameLabel.text = @"暂无名字信息";
    }
    self.nameLabel.textColor = [UIColor CML9E9E9EColor];
    self.nameLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightThin];
    [self.nameLabel sizeToFit];
    self.nameLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame),
                                      CGRectGetMaxY(self.titleLabel.frame) + 8*Proportion,
                                      CGRectGetWidth(self.nameLabel.frame) + 10 * Proportion,
                                      CGRectGetHeight(self.nameLabel.frame));
    
    
    if ([obj.type intValue] == 4 ) {
        
        self.probationImage.hidden = YES;
        self.statusLabel.hidden = NO;
        self.statusLabel.text = @"提现";
        if ([obj.status intValue] == 1) {
            self.statusLabel.text = @"提现";
        }else if ([obj.status intValue] == 2){
            self.statusLabel.text = @"提现中";
        }else {
            self.statusLabel.text = @"提现失败";
        }
        [self.statusLabel sizeToFit];
        self.statusLabel.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 18 * Proportion,
                                            CGRectGetMinY(self.nameLabel.frame) + 4*Proportion,
                                            CGRectGetWidth(self.statusLabel.frame),
                                            CGRectGetHeight(self.statusLabel.frame));
    }else {
        
        self.statusLabel.hidden = YES;
        
        if ([obj.type intValue] == 2) {
            self.probationImage.hidden = NO;
        }
        self.probationImage.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame),
                                               CGRectGetMidY(self.nameLabel.frame) - CGRectGetHeight(self.probationImage.frame)/2,
                                               CGRectGetWidth(self.probationImage.frame),
                                               CGRectGetHeight(self.probationImage.frame));
        
    }
    
    self.timeLabel.text = obj.created_at_str;
    [self.timeLabel sizeToFit];
    self.timeLabel.frame = CGRectMake(CGRectGetWidth(self.myTeamCellBgView.frame) - CGRectGetWidth(self.timeLabel.frame) - 32 * Proportion - 10 * Proportion,
                                      CGRectGetMaxY(self.titleLabel.frame) + 8*Proportion,
                                      CGRectGetWidth(self.timeLabel.frame) + 10 * Proportion,
                                      CGRectGetHeight(self.timeLabel.frame));
    
    self.teamCountLabel.text = obj.costStr;
    NSLog(@"costStr===%@", obj.costStr);
    [self.teamCountLabel sizeToFit];
    self.teamCountLabel.frame = CGRectMake(CGRectGetWidth(self.myTeamCellBgView.frame) - CGRectGetWidth(self.teamCountLabel.frame) - 32 * Proportion,
                                           56 * Proportion,
                                           190 * Proportion,
                                           CGRectGetHeight(self.teamCountLabel.frame));
    [self.myTeamCellBgView addSubview:self.teamCountLabel];
    if ([obj.status intValue] == 3) {
        self.teamCountLabel.textColor = [UIColor redColor];
    }
    
}


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
        _probationImage.hidden = YES;
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
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightThin];
        _timeLabel.numberOfLines = 1;
    }
    return _timeLabel;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor CMLUserBlackColor];
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UILabel *)teamCountLabel {
    
    if (!_teamCountLabel) {
        _teamCountLabel = [[UILabel alloc] init];
        _teamCountLabel.textColor = [UIColor CMLUserBlackColor];
        _teamCountLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    }
    return _teamCountLabel;
}

- (UILabel *)statusLabel {
    
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = [UIColor CML686868Color];
        _statusLabel.hidden = YES;
        _statusLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
    }
    return _statusLabel;
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
