//
//  CMLPushMessageRemindView.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/6/13.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLPushMessageRemindView.h"

@interface CMLPushMessageRemindView ()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *openButton;

@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation CMLPushMessageRemindView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        [self loadViews];
    }
    return self;
}

- (void)loadViews {
    
    [self addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.titleLabel];
    [self.bgImageView addSubview:self.openButton];
    [self.bgImageView addSubview:self.closeButton];
    
}

- (void)openButtonClicked {
    [self.delegate pushRemindViewOpenButtonClicked];
}

- (void)closeButtonClicked {
    [self.delegate pushRemindViewCloseButtonClicked];
}

- (UIImageView *)bgImageView {
    
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bgImageView.backgroundColor = [UIColor clearColor];
        _bgImageView.image = [UIImage imageNamed:CMLOpenPushHintImage];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = @"开启推送通知";
        _titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
        _titleLabel.textColor = [UIColor CMLWhiteColor];
        [_titleLabel sizeToFit];
        _titleLabel.frame = CGRectMake(CGRectGetMidX(self.bgImageView.frame) - 120 * Proportion, 190 * Proportion * 2, CGRectGetWidth(_titleLabel.frame), CGRectGetHeight(_titleLabel.frame));
    }
    return _titleLabel;
}

- (UIButton *)openButton {
    
    if (!_openButton) {
        _openButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _openButton.frame = CGRectMake(CGRectGetMidX(self.bgImageView.frame) - 227 * Proportion, CGRectGetMaxY(_titleLabel.frame) + 16 * 2 * Proportion, 227 * 2 * Proportion, 40 * 2 * Proportion);
        [_openButton setTitle:@"请通知我" forState:UIControlStateNormal];
        [_openButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_openButton.titleLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightRegular]];
        _openButton.layer.cornerRadius = 6 * Proportion;
        _openButton.clipsToBounds = YES;
        _openButton.backgroundColor = [UIColor CMLYellowD9AB5EColor];

        [_openButton addTarget:self action:@selector(openButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openButton;
}

- (UIButton *)closeButton {
    
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        _closeButton.backgroundColor = [UIColor clearColor];
        [_closeButton setTitle:@"暂时不要" forState:UIControlStateNormal];
        [_closeButton.titleLabel setFont:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular]];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeButton sizeToFit];
        _closeButton.frame = CGRectMake(CGRectGetMidX(self.bgImageView.frame) - 227 * Proportion, CGRectGetMaxY(_openButton.frame) + 6 * 2 * Proportion, 227 * 2 * Proportion, CGRectGetHeight(_closeButton.frame));
        [_closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
