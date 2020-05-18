//
//  CMLMemberEquityCell.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/8/12.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLMemberEquityCell.h"
#import "NetWorkTask.h"
#import "CMLEquityModel.h"

@interface CMLMemberEquityCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation CMLMemberEquityCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadViews];
    }
    return self;
}

- (void)loadViews {
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.iconImageView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.contentLabel];
    
}

- (void)refreshCurrentCellWith:(CMLEquityModel *)equityModel {
    
    if ([[[DataManager lightData] readRoleId] intValue] == [equityModel.role_id intValue]) {
        self.iconImageView.image = [UIImage imageNamed:CMLCustomGiftSelectImg];
    }
    
    if (equityModel.logo.length > 0) {
        [NetWorkTask setImageView:self.iconImageView WithURL:equityModel.logo placeholderImage:nil];
    }
    
    if (equityModel.title.length > 0) {
        self.titleLabel.text = equityModel.title;
        [self.titleLabel sizeToFit];
        self.titleLabel.frame = CGRectMake(CGRectGetMidX(self.bgView.frame) - CGRectGetWidth(self.titleLabel.frame)/2,
                                           self.titleLabel.frame.origin.y,
                                           CGRectGetWidth(self.titleLabel.frame),
                                           CGRectGetHeight(self.titleLabel.frame));
    }
    if (equityModel.desc.length > 0) {
        self.contentLabel.text = equityModel.desc;
        [self.contentLabel sizeToFit];
        self.contentLabel.frame = CGRectMake(CGRectGetMidX(self.bgView.frame) - CGRectGetWidth(self.contentLabel.frame)/2,
                                             self.contentLabel.origin.y,
                                             CGRectGetWidth(self.contentLabel.frame),
                                             CGRectGetHeight(self.contentLabel.frame));
    }
    
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.bgView.frame) - 68 * Proportion/2,
                                                                       0,
                                                                       68 * Proportion,
                                                                       68 * Proportion)];
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60 * Proportion, 60 * Proportion)];
//        view.layer.cornerRadius = 30 * Proportion;
//        view.clipsToBounds = YES;
//        view.backgroundColor = [UIColor CMLGray979797Color];
//        UIImage *image = [UIImage getImageFromView:view];
        _iconImageView.image = [UIImage imageNamed:CMLCustomGiftNoSelectImg];
        _iconImageView.backgroundColor = [UIColor whiteColor];
//        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
        
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = @"会员权益";
        _titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        [_titleLabel sizeToFit];
        _titleLabel.frame = CGRectMake(CGRectGetMidX(self.bgView.frame) - CGRectGetWidth(_titleLabel.frame)/2,
                                       CGRectGetMaxY(self.iconImageView.frame) + 18 * Proportion,
                                       CGRectGetWidth(_titleLabel.frame),
                                       CGRectGetHeight(_titleLabel.frame));
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.text = @"会员权益";
        _contentLabel.font = KSystemFontSize9;
        _contentLabel.textColor = [UIColor CMLGray979797Color];
        [_contentLabel sizeToFit];
        _contentLabel.frame = CGRectMake(CGRectGetMidX(self.bgView.frame) - CGRectGetWidth(_contentLabel.frame)/2,
                                         CGRectGetMaxY(self.titleLabel.frame),
                                         CGRectGetWidth(_contentLabel.frame),
                                         CGRectGetHeight(_contentLabel.frame));
    }
    return _contentLabel;
}

@end
