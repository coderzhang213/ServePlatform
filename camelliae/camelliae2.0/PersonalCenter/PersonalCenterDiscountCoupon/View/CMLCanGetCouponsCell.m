//
//  CMLCanGetCouponsCell.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/7/30.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLCanGetCouponsCell.h"
#import "CMLMyCouponsModel.h"
#import "SVProgressHUD.h"
#import "NetWorkTask.h"
#import "NetConfig.h"

@interface CMLCanGetCouponsCell ()<NetWorkProtocol>

@property (nonatomic, strong) NSNumber *isUse;

@property (nonatomic, strong) NSNumber *process;

@property (nonatomic, copy)   NSString *currentApiName;

@property (nonatomic, strong) CMLMyCouponsModel *couponModel;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UILabel *amoutLabel;

@property (nonatomic, strong) UIImageView *lineView;/*虚线*/

@property (nonatomic, strong) UILabel *fullLabel;

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UILabel *periodLabel;/*有效期*/

@property (nonatomic, strong) UIButton *getCouponsButton;

@property (nonatomic, strong) UILabel *getFullLabel;

@property (nonatomic, strong) UIButton *getButton;/*领取按钮*/

@property (nonatomic, assign) BOOL isCanOfRoleId;

@end

@implementation CMLCanGetCouponsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.userInteractionEnabled = YES;
        [self loadViews];
        self.isCanOfRoleId = YES;
        
    }
    return self;
}

- (void)loadViews {
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.amoutLabel];
    [self.bgImageView addSubview:self.fullLabel];
    [self.bgImageView addSubview:self.dateLabel];
    [self.bgImageView addSubview:self.periodLabel];
    [self.bgImageView addSubview:self.lineView];
    [self.bgImageView addSubview:self.getCouponsButton];/*立即领取*/
    [self.bgImageView addSubview:self.getFullLabel];/*可领取满减*/
    //    [self.bgImageView addSubview:self.getButton];/*领取*/
    
}

/*详情页可领取优惠券*/
- (void)refreshCanGetCurrentCell:(CMLMyCouponsModel *)model withIsUse:(NSNumber * _Nullable)isUse withProcess:(NSNumber * _Nullable)process {
    
    self.isUse = isUse;
    self.couponModel = model;
    self.getCouponsButton.hidden = NO;
    self.getFullLabel.hidden = NO;
    self.getButton.hidden = NO;

    if (self.couponModel.surplusStock.length > 0) {
        if ([self.couponModel.surplusStock intValue] > 0) {
            
            if ([self.couponModel.isGet intValue] == 1) {
                if ([self.couponModel.isCanGet intValue] == 1) {
                    self.getCouponsButton.selected = NO;
                    [self.getCouponsButton setTitle:@"继续领取" forState:UIControlStateNormal];/*UIControlStateNormal*/
                    self.getCouponsButton.userInteractionEnabled = YES;
                }else {
                    self.getCouponsButton.selected = YES;
                    
                    [self.getCouponsButton setTitle:@"已领取" forState:UIControlStateSelected];
                    self.getCouponsButton.userInteractionEnabled = NO;
                }
            }else {
                if ([self.couponModel.isCanGet intValue] == 1) {
                    self.getCouponsButton.selected = NO;
//                    [self.getCouponsButton setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
                    [self.getCouponsButton setTitle:@"立即领取" forState:UIControlStateNormal];
                }
            }
            
        }else {
            /*是否已领取优惠券 1-已领取*/
            if (self.couponModel.isGet.length > 0) {
                if ([self.couponModel.isGet intValue] == 1) {
                    self.getCouponsButton.selected = YES;
                    [self.getCouponsButton setTitle:@"已领完" forState:UIControlStateSelected];
                    self.getCouponsButton.userInteractionEnabled = NO;
                }
            }else {
                self.getCouponsButton.selected = NO;
                [self.getCouponsButton setTitle:@"已领完" forState:UIControlStateNormal];
                self.getButton.userInteractionEnabled = NO;
            }

        }
    }
    
    if (self.getCouponsButton.selected == YES) {
        self.getCouponsButton.backgroundColor = [UIColor CMLWhiteColor];
    }else {
        self.getCouponsButton.backgroundColor = [UIColor CMLYellowD9AB5EColor];
    }
    
    /*优惠金额*/
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
        
        self.fullLabel.text = model.name;//[NSString stringWithFormat:@"满%@元可用", model.name];
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
    
    self.currentHeight = self.bgView.size.height;
    
}

- (void)getCouponsButtonClicked:(UIButton *)button {
    NSLog(@"立即领取");
    [self shouldGetCoupons];
    /*
    if (self.couponModel.roleId.length > 0) {
        if (self.couponModel.roleId.length > 1) {
            [self shouldGetCoupons];
        }else {
            
            if ([[[DataManager lightData] readRole_id] intValue] != [self.couponModel.roleId intValue]) {
                NSLog(@"%@", self.couponModel.roleId);
                switch ([self.couponModel.roleId intValue]) {
                    case 0:
                        [self shouldGetCoupons];
                        break;
                    case 1:
                        [SVProgressHUD showErrorWithStatus:@"仅限粉色会员领取" duration:2];
                        break;
                        
                    case 2:
                        [SVProgressHUD showErrorWithStatus:@"仅限粉银会员领取" duration:2];
                        break;
                        
                    case 3:
                        [SVProgressHUD showErrorWithStatus:@"仅限粉金会员领取" duration:2];
                        break;
                        
                    case 4:
                        [SVProgressHUD showErrorWithStatus:@"仅限粉钻会员领取" duration:2];
                        break;
                        
                    case 5:
                        [SVProgressHUD showErrorWithStatus:@"仅限黛色会员领取" duration:2];
                        break;
                        
                    default:
                        break;
                }
            }else {
                [self shouldGetCoupons];
            }
        }
    }*/
    
}

- (void)shouldGetCoupons {
    /*优惠券库存*/
    if ([self.couponModel.surplusStock intValue] > 0) {
        
        /*是否可领取*/
        if ([self.couponModel.isCanGet intValue] == 1) {
            self.getCouponsButton.userInteractionEnabled = NO;
            /*领取请求*/
//            [self canGetOfRole];
            [self setGetCouponsRequest];
        
        }else {
            /*是否已领取优惠券 1-已领取*/
            if ([self.couponModel.isGet intValue] == 1) {
                self.getCouponsButton.selected = YES;
                [self.getCouponsButton setTitle:@"已领取" forState:UIControlStateSelected];
                self.getCouponsButton.userInteractionEnabled = NO;
            }else {
                
            }
        }
        
    }else {

        self.getCouponsButton.selected = YES;
        [self.getCouponsButton setTitle:@"已领完" forState:UIControlStateSelected];
        self.getCouponsButton.userInteractionEnabled = NO;
        
    }

}

/*领取条件判断--暂时不需要：不能领取的不显示*/
- (void)canGetOfRole {
    NSArray *array = [NSMutableArray array];
    NSLog(@"roleId %@", self.couponModel.roleId);
    if ([self.couponModel.roleId rangeOfString:@","].location != NSNotFound) {
        array = [self.couponModel.roleId componentsSeparatedByString:@","];
        for (int i = 0; i < array.count; i++) {
            if ([[[DataManager lightData] readRoleId] intValue] == [array[i] intValue]) {
                self.isCanOfRoleId = YES;
            }else {
                self.isCanOfRoleId = NO;
            }
        }
    }else {
        if ([[[DataManager lightData] readRoleId] intValue] == [self.couponModel.roleId intValue] || [self.couponModel.roleId intValue] == 0) {
            self.isCanOfRoleId = YES;
        }else {
            self.isCanOfRoleId = NO;
        }
    }
    if (self.isCanOfRoleId) {
        [self setGetCouponsRequest];
    }else {
        [SVProgressHUD showErrorWithStatus:@"领取失败"];
    }

}

/*领取请求*/
- (void)setGetCouponsRequest {
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    [dict setObject:self.couponModel.currentID forKey:@"objId"];
    
    [NetWorkTask postResquestWithApiName:PersonCenterUserGetCoupons paraDic:dict delegate:delegate];
    self.currentApiName = PersonCenterUserGetCoupons;
    
}

- (void)requestSucceedBack:(id)responseResult withApiName:(NSString *)apiName {
    
    NSLog(@"优惠券领取请求：%@", responseResult);
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    if ([obj.retCode intValue] == 0) {
        [SVProgressHUD showSuccessWithStatus:@"领取成功" duration:1];
        
//        if (self.couponModel.surplusStock.length > 0) {
//            if ([self.couponModel.surplusStock intValue] > 0) {
//
//                if (self.couponModel.isCanGet.length > 0) {
//                    if ([self.couponModel.isCanGet intValue] == 1) {
//                        [self.getCouponsButton setTitle:@"继续领取" forState:UIControlStateNormal];
//                        self.getCouponsButton.userInteractionEnabled = YES;
//                    }else {
//                        [self.getCouponsButton setTitle:@"已领取" forState:UIControlStateSelected];
//                        self.getCouponsButton.userInteractionEnabled = NO;
//                    }
//                }
//
//            }else {
//                [self.getCouponsButton setTitle:@"已领完" forState:UIControlStateNormal];
//                self.getCouponsButton.userInteractionEnabled = NO;
//            }
//        }
//        [self refreshCanGetCurrentCell:self.couponModel withIsUse:self.isUse withProcess:self.process];
        [self.delegate getCouponsClickedOfCanGetCouponsCell];
        
    }else {
        [SVProgressHUD showErrorWithStatus:obj.retMsg duration:1];
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [SVProgressHUD showErrorWithStatus:@"网络好像有问题，请稍后重试" duration:2];
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

/*虚线*/
- (UIImageView *)lineView {
    
    if (!_lineView) {
        _lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLDiscountCouponSelectLine]];
        _lineView.contentMode = UIViewContentModeScaleAspectFill;
        _lineView.backgroundColor = [UIColor clearColor];
        _lineView.clipsToBounds = YES;
        _lineView.hidden = YES;
        [_lineView sizeToFit];
        _lineView.frame = CGRectMake(CGRectGetMinX(self.dateLabel.frame),
                                     CGRectGetHeight(self.bgImageView.frame) - 60 * Proportion - 4 * Proportion - 10 * Proportion,
                                     412 * Proportion - 4 * Proportion,
                                     4 * Proportion);
    }
    return _lineView;
}

- (UIButton *)getButton {
    
    if (!_getButton) {
        _getButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bgImageView.frame) - CGRectGetHeight(self.bgImageView.frame),
                                                                0,
                                                                CGRectGetHeight(self.bgImageView.frame),
                                                                CGRectGetHeight(self.bgImageView.frame))];
        _getButton.backgroundColor = [UIColor clearColor];
        _getButton.hidden = YES;
        [_getButton addTarget:self action:@selector(getCouponsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getButton;
}

/*立即领取*/
- (UIButton *)getCouponsButton {
    
    if (!_getCouponsButton) {
        _getCouponsButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bgImageView.frame) - 27 * Proportion - 142 * Proportion,
                                                                       CGRectGetHeight(self.bgImageView.frame) - 22 * Proportion - 40 * Proportion,
                                                                       142 * Proportion,
                                                                       40 * Proportion)];
        _getCouponsButton.backgroundColor = [UIColor CMLYellowD9AB5EColor];
        _getCouponsButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
        [_getCouponsButton setTitle:@"立即领取" forState:UIControlStateNormal];
        [_getCouponsButton setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
        [_getCouponsButton setTitleColor:[UIColor CMLYellowD9AB5EColor] forState:UIControlStateSelected];
        _getCouponsButton.layer.cornerRadius = 20 * Proportion;
        _getCouponsButton.layer.borderWidth = 1 * Proportion;
        _getCouponsButton.layer.borderColor = [UIColor CMLYellowD9AB5EColor].CGColor;
        _getCouponsButton.clipsToBounds = YES;
        _getCouponsButton.hidden = YES;
        [_getCouponsButton addTarget:self action:@selector(getCouponsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _getCouponsButton;
}

/*详情可领取满减*/
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
