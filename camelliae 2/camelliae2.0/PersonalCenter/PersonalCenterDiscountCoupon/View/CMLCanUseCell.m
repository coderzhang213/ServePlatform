//
//  CMLCanUseCell.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/8/1.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLCanUseCell.h"
#import "CMLMyCouponsModel.h"

@interface CMLCanUseCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *higherBgImageView;

@property (nonatomic, strong) UILabel *amoutLabel;

@property (nonatomic, strong) UIImageView *lineView;/*虚线*/

@property (nonatomic, strong) UIImageView *leftLineView;/*虚线*/

@property (nonatomic, strong) UILabel *fullLabel;

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UILabel *periodLabel;/*有效期*/

@property (nonatomic, strong) UILabel *useLabel;

@property (nonatomic, strong) UIImageView *useContentImageView;

@property (nonatomic, strong) UIImageView *usedImageView;/*已使用*/

@property (nonatomic, strong) UIImageView *overdueImageView;/*已过期*/

@property (nonatomic, strong) UILabel *useContentLabel;

@property (nonatomic, strong) UIButton *unfoldButton;/*展开按钮*/

@property (nonatomic, assign) int isUse;

@property (nonatomic, assign) int process;

@property (nonatomic, copy)   NSString *currentApiName;

@property (nonatomic, strong) CMLMyCouponsModel *couponModel;

@property (nonatomic, strong) UILabel *getFullLabel;/*满减条件*/

@end

@implementation CMLCanUseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadViews];
    }
    return self;
}

- (void)loadViews {
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.bgImageView];
    [self.bgView addSubview:self.higherBgImageView];
    [self.bgView sendSubviewToBack:self.higherBgImageView];
    [self.higherBgImageView addSubview:self.useContentLabel];
    [self.bgImageView addSubview:self.amoutLabel];
    [self.bgImageView addSubview:self.fullLabel];
    [self.bgImageView addSubview:self.dateLabel];
    [self.bgImageView addSubview:self.periodLabel];
    [self.bgImageView addSubview:self.lineView];
    [self.bgImageView addSubview:self.useLabel];
    [self.bgImageView addSubview:self.useContentImageView];
    [self.bgImageView addSubview:self.overdueImageView];
    [self.bgImageView addSubview:self.usedImageView];
    [self.bgImageView addSubview:self.unfoldButton];
    [self.bgImageView addSubview:self.chooseButton];
    [self.bgImageView addSubview:self.getFullLabel];
    
}

- (void)refreshCanUseCurrentCell:(CMLMyCouponsModel *)model withIsUse:(int)isUse withProcess:(int)process withRow:(NSInteger)row {
    
    self.isUse = isUse;
    self.couponModel = model;
    self.useContentLabel.hidden = NO;
    self.useContentImageView.hidden = NO;
    self.useLabel.hidden = NO;
    self.lineView.hidden = NO;
    self.unfoldButton.hidden = NO;
    self.chooseButton.hidden = NO;
    self.chooseButton.tag = row;
    self.getFullLabel.hidden = NO;
    
    self.amoutLabel.text = [NSString stringWithFormat:@"%@元", model.breaksMoney];
    NSMutableAttributedString *amoutAttString = [[NSMutableAttributedString alloc] initWithString:self.amoutLabel.text];
    [amoutAttString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13 weight:UIFontWeightMedium]} range:NSMakeRange(self.amoutLabel.text.length - 1, 1)];
    self.amoutLabel.attributedText = amoutAttString;
    [self.amoutLabel sizeToFit];
    self.amoutLabel.frame = CGRectMake(230 * Proportion/2 - CGRectGetWidth(self.amoutLabel.frame)/2 + 10 * Proportion,
                                       CGRectGetMinY(self.dateLabel.frame) - CGRectGetHeight(self.amoutLabel.frame)/2 - 5 * Proportion,
                                       CGRectGetWidth(self.amoutLabel.frame),
                                       CGRectGetHeight(self.amoutLabel.frame));
    
    /*满减条件*/
    if ([model.isSill intValue] == 1) {
        
        if ([model.fullMoney intValue] == 0) {
            self.getFullLabel.text = @"无使用门槛";
        }else {
            self.getFullLabel.text = [NSString stringWithFormat:@"满%@元可用", model.fullMoney];
        }
        [self.getFullLabel sizeToFit];
        self.getFullLabel.frame = CGRectMake(CGRectGetMidX(self.amoutLabel.frame) - CGRectGetWidth(self.getFullLabel.frame)/2,
                                             CGRectGetMaxY(self.amoutLabel.frame) + 5 * Proportion,
                                             CGRectGetWidth(self.getFullLabel.frame),
                                             CGRectGetHeight(self.getFullLabel.frame));
        
    }else {
        self.getFullLabel.text = @"无使用门槛";
        [self.getFullLabel sizeToFit];
        self.getFullLabel.frame = CGRectMake(CGRectGetMidX(self.amoutLabel.frame) - CGRectGetWidth(self.getFullLabel.frame)/2,
                                             CGRectGetMaxY(self.amoutLabel.frame) + 5 * Proportion,
                                             CGRectGetWidth(self.getFullLabel.frame),
                                             CGRectGetHeight(self.getFullLabel.frame));
    }
    
    /*购物券名称*/
    if (model.name.length > 0) {
        
        self.fullLabel.text = model.name;
        [self.fullLabel sizeToFit];
        self.fullLabel.frame = CGRectMake(257 * Proportion,
                                          25 * Proportion,
                                          348 * Proportion,
                                          CGRectGetHeight(self.fullLabel.frame));
    }
    
    if (model.beginTimeStr.length > 0 && model.endTimeStr.length > 0) {
        self.periodLabel.text = [NSString stringWithFormat:@"%@-%@", model.beginTimeStr, model.endTimeStr];
        [self.periodLabel sizeToFit];
        self.periodLabel.frame = CGRectMake(CGRectGetMaxX(self.dateLabel.frame) + 26 * Proportion,
                                            CGRectGetMidY(self.dateLabel.frame) - CGRectGetHeight(self.periodLabel.frame)/2.0,
                                            CGRectGetWidth(self.periodLabel.frame),
                                            CGRectGetHeight(self.periodLabel.frame));
    }
    
    /*isUse: 0-未使用 1-已使用 3-all 查询已过期的时候 process传3*/
    if (isUse == 1) {
        self.bgImageView.image = [UIImage imageNamed:CMLDiscountCouponNoSelectCase];
        self.higherBgImageView.image = [UIImage imageNamed:CMLDiscountCouponCaseDownNoSelect];
        self.usedImageView.hidden = NO;
        self.overdueImageView.hidden = YES;
        self.amoutLabel.textColor = [UIColor CMLBlackColor];
        self.dateLabel.textColor = [UIColor CMLBlack393939Color];
        self.dateLabel.backgroundColor = [UIColor CMLGrayF3F3F3Color];
        self.lineView.image = [UIImage imageNamed:CMLDiscountCouponNoSelectLine];
        self.getFullLabel.textColor = [UIColor CML9E9E9EColor];
    }else if (isUse == 3) {
        if (process == 3) {
            self.bgImageView.image = [UIImage imageNamed:CMLDiscountCouponNoSelectCase];
            self.higherBgImageView.image = [UIImage imageNamed:CMLDiscountCouponCaseDownNoSelect];
            self.usedImageView.hidden = YES;
            self.overdueImageView.hidden = NO;
            self.amoutLabel.textColor = [UIColor CMLBlackColor];
            self.dateLabel.textColor = [UIColor CMLBlack393939Color];
            self.dateLabel.backgroundColor = [UIColor CMLGrayF3F3F3Color];
            self.lineView.image = [UIImage imageNamed:CMLDiscountCouponNoSelectLine];
            self.getFullLabel.textColor = [UIColor CML9E9E9EColor];
        }
    }
    
    if (model.desc.length > 0) {
        self.useContentLabel.text = model.desc;
        NSLog(@"useContentLabel   %@", self.useContentLabel.text);
        self.useContentLabel.numberOfLines = 0;
        [self.useContentLabel sizeToFit];
        self.useContentLabel.frame = CGRectMake(20 * Proportion,
                                                215 * Proportion,
                                                CGRectGetWidth(self.higherBgImageView.frame) - 20 * Proportion * 2,
                                                CGRectGetHeight(self.useContentLabel.frame));
    }
    
    self.currentHeight = self.bgView.size.height;
    NSLog(@"cell %f", self.frame.size.height);
    
}

/*car*/
- (void)refreshCanUseCurrentCell:(CMLMyCouponsModel *)model withChooseCouponsIdArray:(NSArray *)chooseCouponsIdArray withRow:(NSInteger)row {
    
    self.couponModel = model;
    self.useContentLabel.hidden = NO;
    self.useContentImageView.hidden = NO;
    self.useLabel.hidden = NO;
    self.lineView.hidden = NO;
    self.unfoldButton.hidden = NO;
    self.chooseButton.hidden = NO;
    self.chooseButton.tag = row;
    self.getFullLabel.hidden = NO;
    
    for (int i = 0; i < chooseCouponsIdArray.count; i++) {
        NSLog(@"%ld", (unsigned long)chooseCouponsIdArray.count);
        if ([self.couponModel.currentID intValue] == [chooseCouponsIdArray[i] intValue]) {
            self.chooseButton.selected = YES;
        }
    }
    
    self.amoutLabel.text = [NSString stringWithFormat:@"%@元", model.breaksMoney];
    NSMutableAttributedString *amoutAttString = [[NSMutableAttributedString alloc] initWithString:self.amoutLabel.text];
    [amoutAttString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13 weight:UIFontWeightMedium]} range:NSMakeRange(self.amoutLabel.text.length - 1, 1)];
    self.amoutLabel.attributedText = amoutAttString;
    [self.amoutLabel sizeToFit];
    self.amoutLabel.frame = CGRectMake(230 * Proportion/2 - CGRectGetWidth(self.amoutLabel.frame)/2 + 10 * Proportion,
                                       CGRectGetMinY(self.dateLabel.frame) - CGRectGetHeight(self.amoutLabel.frame)/2 - 5 * Proportion,
                                       CGRectGetWidth(self.amoutLabel.frame),
                                       CGRectGetHeight(self.amoutLabel.frame));
    
    /*满减条件*/
    if ([model.isSill intValue] == 1) {
        
        if ([model.fullMoney intValue] == 0) {
            self.getFullLabel.text = @"无使用门槛";
        }else {
            self.getFullLabel.text = [NSString stringWithFormat:@"满%@元可用", model.fullMoney];
        }
        [self.getFullLabel sizeToFit];
        self.getFullLabel.frame = CGRectMake(CGRectGetMidX(self.amoutLabel.frame) - CGRectGetWidth(self.getFullLabel.frame)/2,
                                             CGRectGetMaxY(self.amoutLabel.frame) + 5 * Proportion,
                                             CGRectGetWidth(self.getFullLabel.frame),
                                             CGRectGetHeight(self.getFullLabel.frame));
        
    }else {
        self.getFullLabel.text = @"无使用门槛";
        [self.getFullLabel sizeToFit];
        self.getFullLabel.frame = CGRectMake(CGRectGetMidX(self.amoutLabel.frame) - CGRectGetWidth(self.getFullLabel.frame)/2,
                                             CGRectGetMaxY(self.amoutLabel.frame) + 5 * Proportion,
                                             CGRectGetWidth(self.getFullLabel.frame),
                                             CGRectGetHeight(self.getFullLabel.frame));
    }
    
    
    if (model.name.length > 0) {
        
        self.fullLabel.text = model.name;
        [self.fullLabel sizeToFit];
        self.fullLabel.frame = CGRectMake(257 * Proportion,
                                          25 * Proportion,
                                          348 * Proportion,
                                          CGRectGetHeight(self.fullLabel.frame));
    }
    
    if (model.beginTimeStr.length > 0 && model.endTimeStr.length > 0) {
        self.periodLabel.text = [NSString stringWithFormat:@"%@-%@", model.beginTimeStr, model.endTimeStr];
        [self.periodLabel sizeToFit];
        self.periodLabel.frame = CGRectMake(CGRectGetMaxX(self.dateLabel.frame) + 26 * Proportion,
                                            CGRectGetMidY(self.dateLabel.frame) - CGRectGetHeight(self.periodLabel.frame)/2.0,
                                            CGRectGetWidth(self.periodLabel.frame),
                                            CGRectGetHeight(self.periodLabel.frame));
    }
    
    if (model.desc.length > 0) {
        self.useContentLabel.text = model.desc;
        NSLog(@"useContentLabel   %@", self.useContentLabel.text);
        self.useContentLabel.numberOfLines = 0;
        [self.useContentLabel sizeToFit];
        self.useContentLabel.frame = CGRectMake(20 * Proportion,
                                                215 * Proportion,
                                                CGRectGetWidth(self.higherBgImageView.frame) - 20 * Proportion * 2,
                                                CGRectGetHeight(self.useContentLabel.frame));
    }
    
    self.currentHeight = self.bgView.size.height;
    NSLog(@"cell %f", self.frame.size.height);
    
}

- (void)useContentButtonClicked:(UIButton *)button {
    NSLog(@"点击了");
    
    if (!self.isOpen) {
        self.isOpen = YES;
        self.useContentImageView.image = [UIImage imageNamed:CMLDiscountCouponUseRuleDown];
        self.higherBgImageView.hidden = NO;
        self.useContentLabel.hidden = NO;
        self.bgView.frame = CGRectMake(self.bgView.origin.x,
                                       self.bgView.origin.y,
                                       self.bgView.frame.size.width,
                                       self.higherBgImageView.frame.size.height);
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.higherBgImageView.frame.size.height);
        self.currentHeight = self.higherBgImageView.frame.size.height + 20 * Proportion;
        self.bgView.frame = CGRectMake(0, 0, WIDTH, 306 * Proportion);
        
        
    }else {
        self.isOpen = NO;
        self.useContentImageView.image = [UIImage imageNamed:CMLDiscountCouponUseRuleUp];
        self.higherBgImageView.hidden = YES;
        self.currentHeight = self.bgImageView.frame.size.height + 20 * Proportion;
        self.bgView.frame = CGRectMake(0, 0, WIDTH, 216 * Proportion);
        self.useContentLabel.hidden = YES;
    }
    [self.delegate useContentButtonClickedOfCouponsCellWith:self.currentHeight];
    
}

- (void)chooseButtonClicked:(UIButton *)button {
    button.selected = !button.selected;
    [self.delegate backChooseButtonRow:button.tag withCurrentSelect:button.selected];
    [self.delegate changeChooseStatus:button.selected currentCouponsId:self.couponModel.currentID];
}

- (UIView *)bgView {
    
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 216 * Proportion)];
        _bgView.backgroundColor = [UIColor CMLWhiteColor];
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

- (UIImageView *)bgImageView {
    
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/2 - 672 * Proportion/2,
                                                                     10 * Proportion,
                                                                     672 * Proportion,
                                                                     196 * Proportion)];
        _bgImageView.image = [UIImage imageNamed:CMLDiscountCoupon];
        _bgImageView.backgroundColor = [UIColor clearColor];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.userInteractionEnabled = YES;
        
    }
    return _bgImageView;
}

- (UIImageView *)higherBgImageView {
    
    if (!_higherBgImageView) {
        _higherBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/2 - 658 * Proportion/2,
                                                                           12 * Proportion,
                                                                           658 * Proportion,
                                                                           274 * Proportion)];
        _higherBgImageView.image = [UIImage imageNamed:CMLDiscountCouponCaseDown];
        _higherBgImageView.backgroundColor = [UIColor clearColor];
        _higherBgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _higherBgImageView.hidden = YES;
        _higherBgImageView.userInteractionEnabled = YES;
    }
    return _higherBgImageView;
}

- (UILabel *)amoutLabel {
    
    if (!_amoutLabel) {
        
        _amoutLabel = [[UILabel alloc] init];
        _amoutLabel.backgroundColor = [UIColor clearColor];
        _amoutLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightMedium];
        _amoutLabel.textColor = [UIColor CMLYellowD9AB5EColor];
        
    }
    return _amoutLabel;
}

- (UILabel *)fullLabel {
    
    if (!_fullLabel) {
        _fullLabel = [[UILabel alloc] init];
        _fullLabel.backgroundColor = [UIColor clearColor];
        _fullLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _fullLabel.textColor = [UIColor CMLUserBlackColor];
    }
    return _fullLabel;
}

- (UILabel *)dateLabel {
    
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.backgroundColor = [UIColor CMLFFF3DFColor];
        _dateLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        _dateLabel.textColor = [UIColor CMLYellowD9AB5EColor];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.text = @"有效期";
        _dateLabel.layer.cornerRadius = 6 * Proportion;
        _dateLabel.clipsToBounds = YES;
        _dateLabel.frame = CGRectMake(257 * Proportion,
                                      CGRectGetHeight(self.bgImageView.frame)/2 - 30 * Proportion/2,
                                      81 * Proportion,
                                      30 * Proportion);
        
    }
    return _dateLabel;
}

- (UILabel *)periodLabel {
    
    if (!_periodLabel) {
        _periodLabel = [[UILabel alloc] init];
        _periodLabel.backgroundColor = [UIColor clearColor];
        _periodLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightThin];
        _periodLabel.textColor = [UIColor CMLBlack1C1C1EColor];
    }
    return _periodLabel;
}

- (UILabel *)useLabel {
    
    if (!_useLabel) {
        
        _useLabel = [[UILabel alloc] init];
        _useLabel.backgroundColor = [UIColor clearColor];
        _useLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightThin];
        _useLabel.textColor = [UIColor CML9E9E9EColor];
        _useLabel.text = @"使用规则";
        _useLabel.hidden = YES;
        [_useLabel sizeToFit];
        _useLabel.frame = CGRectMake(257 * Proportion,
                                     CGRectGetHeight(self.bgImageView.frame) - 26 * Proportion - CGRectGetHeight(_useLabel.frame),
                                     CGRectGetWidth(_useLabel.frame),
                                     CGRectGetHeight(_useLabel.frame));
        
    }
    return _useLabel;
}

/*使用规则-icon*/
- (UIImageView *)useContentImageView {
    
    if (!_useContentImageView) {
        _useContentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLDiscountCouponUseRuleUp]];
        _useContentImageView.backgroundColor = [UIColor clearColor];
        _useContentImageView.userInteractionEnabled = YES;
        _useContentImageView.hidden = YES;
        [_useContentImageView sizeToFit];
        _useContentImageView.frame = CGRectMake(CGRectGetMaxX(self.useLabel.frame) + 260 * Proportion,
                                                CGRectGetMidY(self.useLabel.frame) - CGRectGetWidth(_useContentImageView.frame)/2,
                                                CGRectGetWidth(_useContentImageView.frame),
                                                CGRectGetHeight(_useContentImageView.frame));
    }
    return _useContentImageView;
}

/*虚线*/
- (UIImageView *)lineView {
    
    if (!_lineView) {
        _lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLDiscountCouponSelectLine]];
        _lineView.contentMode = UIViewContentModeScaleAspectFill;
        _lineView.backgroundColor = [UIColor clearColor];
        _lineView.clipsToBounds = YES;
        _lineView.hidden = YES;
        [_lineView sizeToFit];
        _lineView.frame = CGRectMake(CGRectGetMinX(self.useLabel.frame),
                                     CGRectGetHeight(self.bgImageView.frame) - 60 * Proportion - 4 * Proportion - 10 * Proportion,
                                     412 * Proportion - 4 * Proportion,
                                     4 * Proportion);
    }
    return _lineView;
}

/*已使用-icon*/
- (UIImageView *)usedImageView {
    
    if (!_usedImageView) {
        _usedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLDiscountCouponBigBeenUsed]];
        _usedImageView.backgroundColor = [UIColor clearColor];
        _usedImageView.contentMode = UIViewContentModeScaleAspectFill;
        _usedImageView.hidden = YES;
        [_usedImageView sizeToFit];
        _usedImageView.frame = CGRectMake(CGRectGetWidth(self.bgImageView.frame) - 8 * Proportion - CGRectGetWidth(_usedImageView.frame),
                                          2 * Proportion,
                                          CGRectGetWidth(_usedImageView.frame),
                                          CGRectGetHeight(_usedImageView.frame));
    }
    return _usedImageView;
}

/*已过期-icon*/
- (UIImageView *)overdueImageView {
    if (!_overdueImageView) {
        _overdueImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLDiscountCouponBigOverdue]];
        _overdueImageView.backgroundColor = [UIColor clearColor];
        _overdueImageView.contentMode = UIViewContentModeScaleAspectFill;
        _overdueImageView.hidden = YES;
        [_overdueImageView sizeToFit];
        _overdueImageView.frame = CGRectMake(CGRectGetWidth(self.bgImageView.frame) - 8 * Proportion - CGRectGetWidth(_overdueImageView.frame),
                                             2 * Proportion,
                                             CGRectGetWidth(_overdueImageView.frame),
                                             CGRectGetHeight(_overdueImageView.frame));
    }
    return _overdueImageView;
}

/*使用规则*/
- (UILabel *)useContentLabel {
    if (!_useContentLabel) {
        _useContentLabel = [[UILabel alloc] init];
        _useContentLabel.backgroundColor = [UIColor clearColor];
        _useContentLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightThin];
        _useContentLabel.textColor = [UIColor CML9E9E9EColor];
        _useContentLabel.hidden = YES;
    }
    return _useContentLabel;
}

- (UIButton *)unfoldButton {
    
    if (!_unfoldButton) {
        _unfoldButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bgImageView.frame) - CGRectGetHeight(self.bgImageView.frame)/2,
                                                                   CGRectGetHeight(self.bgImageView.frame)/2,
                                                                   CGRectGetHeight(self.bgImageView.frame)/2,
                                                                   CGRectGetHeight(self.bgImageView.frame)/2)];
        _unfoldButton.backgroundColor = [UIColor clearColor];
        _unfoldButton.hidden = YES;
        [_unfoldButton addTarget:self action:@selector(useContentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unfoldButton;
}

- (UIButton *)chooseButton {
    if (!_chooseButton) {
        _chooseButton = [[UIButton alloc] init];
        _chooseButton.backgroundColor = [UIColor clearColor];
        [_chooseButton setImage:[UIImage imageNamed:CMLDisconutCouponNotChoose] forState:UIControlStateNormal];
        [_chooseButton setImage:[UIImage imageNamed:CMLDisconutCouponChoose] forState:UIControlStateSelected];
        _chooseButton.hidden = YES;
        [_chooseButton addTarget:self action:@selector(chooseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_chooseButton sizeToFit];
        _chooseButton.frame = CGRectMake(CGRectGetWidth(self.bgImageView.frame) - CGRectGetWidth(_chooseButton.frame) - 25 * Proportion,
                                         25 * Proportion,
                                         CGRectGetWidth(_chooseButton.frame),
                                         CGRectGetHeight(_chooseButton.frame));
    }
    return _chooseButton;
}

/*满减条件*/
- (UILabel *)getFullLabel {
    if (!_getFullLabel) {
        _getFullLabel = [[UILabel alloc] init];
        _getFullLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightThin];
        _getFullLabel.textColor = [UIColor CMLYellowD9AB5EColor];
        _getFullLabel.hidden = YES;
    }
    return _getFullLabel;
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
