//
//  CMLOrderTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 16/5/31.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLOrderTVCell.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "CMLLine.h"
#import "NetWorkTask.h"

#define CMLOrderTVCellTopMargin                   40
#define CMLOrderTVCellPriceTopMargin              10
#define CMLOrderTVCellTopFLeftMargin              30
#define CMLOrderTVCellTopTypeNameLeftMargin       20
#define CMLOrderTVCellLineLetfMargin              20
#define CMLOrderTVCellImageViewHeight             160
#define CMLOrderTVCellStatusHeight                44

@interface CMLOrderTVCell ()

@property (nonatomic,strong) UIImageView *mainImageView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UILabel *priceLabel;

@property (nonatomic,strong) CMLLine *lineTwo;

@property (nonatomic,strong) UILabel *status;

@property (nonatomic,strong) UIView *imageBgView;

@property (nonatomic,strong) UIButton *invitationBtn;

@property (nonatomic,strong) UILabel *invitationLab;


@end

@implementation CMLOrderTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadViews];
    }
    return self;
}

- (void) loadViews{
    
    _mainImageView = [[UIImageView alloc] init];
    _mainImageView.backgroundColor = [UIColor CMLPromptGrayColor];
    _mainImageView.layer.cornerRadius = 2;
    _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    _mainImageView.clipsToBounds = YES;
    _mainImageView.frame = CGRectMake(CMLOrderTVCellTopFLeftMargin*Proportion,
                                      CMLOrderTVCellTopMargin*Proportion + 20*Proportion,
                                      CMLOrderTVCellImageViewHeight*Proportion,
                                      CMLOrderTVCellImageViewHeight*Proportion);
    [self.contentView addSubview:_mainImageView];
    
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor CMLUserBlackColor];
    _nameLabel.font = KSystemFontSize14;
    _nameLabel.numberOfLines = 2;
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_nameLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor CMLtextInputGrayColor];
    _timeLabel.font = KSystemFontSize10;
    [self.contentView addSubview:_timeLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor CMLBrownColor];
    _priceLabel.font = KSystemFontSize14;
    [self.contentView addSubview:_priceLabel];
    
    self.imageBgView = [[UIView alloc] initWithFrame:CGRectMake(10*Proportion,
                                                               _mainImageView.frame.origin.y - 20*Proportion,
                                                               WIDTH - 10*Proportion*2,
                                                               _mainImageView.frame.size.height + 20*Proportion*2)];
    self.imageBgView.backgroundColor = [UIColor CMLOrderCellBgGrayColor];
    [self.contentView addSubview:self.imageBgView];
    [self.contentView sendSubviewToBack:self.imageBgView];
    
    _lineTwo = [[CMLLine alloc] init];
    _lineTwo.lineWidth = 1 * Proportion;
    _lineTwo.lineLength = [UIScreen mainScreen].bounds.size.width - 2*CMLOrderTVCellLineLetfMargin*Proportion;
    _lineTwo.LineColor = [UIColor CMLNewGrayColor];
    _lineTwo.directionOfLine = HorizontalLine;
    [self.contentView addSubview:_lineTwo];
    
    
    _invitationLab = [[UILabel alloc] init];
    _invitationLab.textColor = [UIColor CMLtextInputGrayColor];
    _invitationLab.font = KSystemFontSize12;
    _invitationLab.layer.cornerRadius = 6*Proportion;
    _invitationLab.layer.borderColor = [UIColor CMLtextInputGrayColor].CGColor;
    _invitationLab.layer.borderWidth = 1;
    _invitationLab.textAlignment = NSTextAlignmentCenter;
    _invitationLab.userInteractionEnabled = YES;
    [self.contentView addSubview:_invitationLab];
    
    _invitationBtn = [[UIButton alloc] init];
    _invitationBtn.backgroundColor = [UIColor clearColor];
    [_invitationLab addSubview:_invitationBtn];
    [_invitationBtn addTarget:self action:@selector(showCurrentInvitationView) forControlEvents:UIControlEventTouchUpInside];
    
    _status = [[UILabel alloc] init];
    _status.textColor = [UIColor CMLtextInputGrayColor];
    _status.font = KSystemFontSize12;
    _status.layer.cornerRadius = 6*Proportion;
    _status.layer.borderColor = [UIColor CMLtextInputGrayColor].CGColor;
    _status.layer.borderWidth = 1;
    _status.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_status];
    
}

- (void) refreshCurrentCell{
    

    [NetWorkTask setImageView:_mainImageView WithURL:self.imageUrl placeholderImage:nil];
    
    /***/
    _nameLabel.frame = CGRectZero;
    _nameLabel.text = self.orderName;
    CGRect curentRect = [_nameLabel.text boundingRectWithSize:CGSizeMake(WIDTH - CMLOrderTVCellTopTypeNameLeftMargin*Proportion*2 - _mainImageView.frame.size.width - 40*Proportion, 1000)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:KSystemFontSize14}
                                                      context:nil];
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_mainImageView.frame) + CMLOrderTVCellLineLetfMargin*Proportion,
                                 _mainImageView.frame.origin.y,
                                 WIDTH - CMLOrderTVCellTopTypeNameLeftMargin*Proportion*2 - _mainImageView.frame.size.width - 40*Proportion,
                                 curentRect.size.height);
    
    /**时间*/
    _timeLabel.text = [NSString stringWithFormat:@"时间：%@",self.serveTime];
    [_timeLabel sizeToFit];
    _timeLabel.frame = CGRectMake(_nameLabel.frame.origin.x,
                                 CGRectGetMaxY(_nameLabel.frame) + CMLOrderTVCellPriceTopMargin*Proportion,
                                 _timeLabel.frame.size.width,
                                 _timeLabel.frame.size.height);
    
    
    /**price*/
    if ([self.price intValue] == 0) {
        
        _priceLabel.text = @"费用：免费";
    }else{
        _priceLabel.text = [NSString stringWithFormat:@"费用：¥%0.2f", (float)[self.price intValue]/100];
    }
    [_priceLabel sizeToFit];
    _priceLabel.frame = CGRectMake(_timeLabel.frame.origin.x,
                                  CGRectGetMaxY(_mainImageView.frame) - _priceLabel.frame.size.height,
                                  _priceLabel.frame.size.width,
                                  _priceLabel.frame.size.height);
    
    if ([self.isHasTimeZone intValue] == 2) {
        _timeLabel.hidden = YES;
    }else{
    
        _timeLabel.hidden = NO;
    }
    
    /**status*/
    
    _invitationLab.text = @"查看邀请函";
    [_invitationLab sizeToFit];
    _invitationLab.frame = CGRectMake(WIDTH - 2*20*Proportion - _invitationLab.frame.size.width - CMLOrderTVCellTopFLeftMargin*Proportion,
                                      CGRectGetMaxY(_imageBgView.frame) + 20*Proportion,
                                      _invitationLab.frame.size.width + 2*20*Proportion,
                                      CMLOrderTVCellStatusHeight*Proportion);
    
    _invitationBtn.frame = _invitationLab.bounds;
    
    _status.text = @"预订成功";
    [_status sizeToFit];
    if (self.isActivityCell) {
        _invitationLab.hidden = NO;
        _status.frame = CGRectMake(_invitationLab.frame.origin.x - 20*Proportion - (_status.frame.size.width + 2*20*Proportion),
                                   CGRectGetMaxY(_imageBgView.frame) + 20*Proportion,
                                   _status.frame.size.width + 2*20*Proportion,
                                   CMLOrderTVCellStatusHeight*Proportion);
    }else{
    
        _invitationLab.hidden = YES;
        _status.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 2*20*Proportion - _status.frame.size.width - CMLOrderTVCellTopFLeftMargin*Proportion,
                                   CGRectGetMaxY(_imageBgView.frame) + 20*Proportion,
                                   _status.frame.size.width + 2*20*Proportion,
                                   CMLOrderTVCellStatusHeight*Proportion);
    }
    
    /*
    if ([self.isUserPush intValue] == 0) {
        
        _invitationLab.hidden = NO;
        _invitationBtn.hidden = NO;
        _status.frame = CGRectMake(_invitationLab.frame.origin.x - 20*Proportion - (_status.frame.size.width + 2*20*Proportion),
                                   CGRectGetMaxY(_imageBgView.frame) + 20*Proportion,
                                   _status.frame.size.width + 2*20*Proportion,
                                   CMLOrderTVCellStatusHeight*Proportion);
    }else{
        
        _invitationLab.hidden = YES;
        _invitationBtn.hidden = YES;
        _status.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 2*20*Proportion - _status.frame.size.width - CMLOrderTVCellTopFLeftMargin*Proportion,
                                   CGRectGetMaxY(_imageBgView.frame) + 20*Proportion,
                                   _status.frame.size.width + 2*20*Proportion,
                                   CMLOrderTVCellStatusHeight*Proportion);
    }*/
    
    

    
    _lineTwo.startingPoint = CGPointMake(CMLOrderTVCellLineLetfMargin*Proportion, CGRectGetMaxY(_status.frame) + CMLOrderTVCellTopMargin*Proportion - 1);
    
    self.cellHeight = CGRectGetMaxY(_status.frame) + CMLOrderTVCellTopMargin*Proportion;
    
}

- (void) showCurrentInvitationView{

    self.showInvitationBlock();
}
@end
