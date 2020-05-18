//
//  OwnExchangeTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2017/8/24.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "OwnExchangeTVCell.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "CMLLine.h"
#import "NetWorkTask.h"
#import "WebViewLinkVC.h"
#import "VCManger.h"

#define CMLOrderTVCellTopMargin                   83
#define CMLOrderTVCellPriceTopMargin              10
#define CMLOrderTVCellTopFLeftMargin              30
#define CMLOrderTVCellTopTypeNameLeftMargin       20
#define CMLOrderTVCellLineLetfMargin              20
#define CMLOrderTVCellImageViewHeight             160
#define CMLOrderTVCellStatusHeight                44



@interface OwnExchangeTVCell () 

@property (nonatomic,strong) UILabel *orderIdLab;

@property (nonatomic,strong) UIImageView *mainImageView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *priceLabel;

@property (nonatomic,strong) CMLLine *lineTwo;

@property (nonatomic,strong) CMLLine *lineOne;

@property (nonatomic,strong) UILabel *status;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UIButton *expressBtn;

@property (nonatomic,strong) UIImageView *iconImg;

@end

@implementation OwnExchangeTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadViews];
    }
    return self;
}

- (void) loadViews{
    
    _orderIdLab = [[UILabel alloc] init];
    _orderIdLab.font = KSystemFontSize12;
    _orderIdLab.textColor = [UIColor CMLBlackColor];
    [self.contentView addSubview:_orderIdLab];
    
    _lineOne = [[CMLLine alloc] init];
    _lineOne.lineWidth =1*Proportion;
    _lineOne.lineLength = [UIScreen mainScreen].bounds.size.width - 2*CMLOrderTVCellLineLetfMargin*Proportion;
    _lineOne.startingPoint = CGPointMake(CMLOrderTVCellLineLetfMargin*Proportion, CMLOrderTVCellTopMargin*Proportion);
    _lineOne.LineColor = [UIColor CMLNewGrayColor];
    _lineOne.directionOfLine = HorizontalLine;
    [self.contentView addSubview:_lineOne];
    
    _mainImageView = [[UIImageView alloc] init];
    _mainImageView.backgroundColor = [UIColor CMLPromptGrayColor];
    _mainImageView.layer.cornerRadius = 2;
    _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    _mainImageView.clipsToBounds = YES;
    _mainImageView.frame = CGRectMake(CMLOrderTVCellTopFLeftMargin*Proportion,
                                      CMLOrderTVCellTopMargin*Proportion + 30*Proportion,
                                      CMLOrderTVCellImageViewHeight*Proportion,
                                      CMLOrderTVCellImageViewHeight*Proportion);
    [self.contentView addSubview:_mainImageView];
    
    _iconImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:IntegrationIconImg]];
    [_iconImg sizeToFit];
    _iconImg.frame = CGRectMake(CGRectGetMaxX(_mainImageView.frame) + CMLOrderTVCellLineLetfMargin*Proportion,
                                CGRectGetMaxY(_mainImageView.frame) - _iconImg.frame.size.height,
                                _iconImg.frame.size.width,
                                _iconImg.frame.size.height);
    [self.contentView addSubview:_iconImg];
    
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor CMLUserBlackColor];
    _nameLabel.font = KSystemFontSize14;
    _nameLabel.numberOfLines = 2;
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_nameLabel];
    
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor CMLBrownColor];
    _priceLabel.font = KSystemFontSize14;
    [self.contentView addSubview:_priceLabel];
    
    _lineTwo = [[CMLLine alloc] init];
    _lineTwo.lineWidth =1;
    _lineTwo.lineLength = [UIScreen mainScreen].bounds.size.width - 2*CMLOrderTVCellLineLetfMargin*Proportion;
    _lineTwo.LineColor = [UIColor CMLNewGrayColor];
    _lineTwo.startingPoint = CGPointMake(CMLOrderTVCellLineLetfMargin*Proportion, CGRectGetMaxY(self.mainImageView.frame) + 30*Proportion);
    _lineTwo.directionOfLine = HorizontalLine;
    [self.contentView addSubview:_lineTwo];
    
    _status = [[UILabel alloc] init];
    _status.textColor = [UIColor CMLBlackColor];
    _status.font = KSystemFontSize12;
    _status.layer.borderColor = [UIColor CMLtextInputGrayColor].CGColor;
    _status.layer.borderWidth = 1;
    _status.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_status];
    
    _expressBtn = [[UIButton alloc] init];
    _expressBtn.titleLabel.font = KSystemFontSize12;
    _expressBtn.layer.borderColor = [UIColor CMLGreeenColor].CGColor;
    _expressBtn.layer.borderWidth = 1;
    [_expressBtn setTitleColor:[UIColor CMLGreeenColor] forState:UIControlStateNormal];
    [_expressBtn setTitle:@"查看物流" forState:UIControlStateNormal];
    [_expressBtn addTarget:self action:@selector(enterExpressDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_expressBtn];
    

    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                           CGRectGetMaxY(self.mainImageView.frame) + 30*Proportion + 120*Proportion,
                                                           WIDTH,
                                                           20*Proportion)];
    _bottomView.backgroundColor = [UIColor CMLNewGrayColor];
    [self.contentView addSubview:_bottomView];
    
}

- (void) refreshCurrentCell{
    
    _orderIdLab.text =  [NSString stringWithFormat:@"订单编号：%@",self.orderId];
    [_orderIdLab sizeToFit];
    _orderIdLab.frame = CGRectMake(CMLOrderTVCellTopFLeftMargin*Proportion,
                                   CMLOrderTVCellTopMargin*Proportion/2.0 - _orderIdLab.frame.size.height/2.0,
                                   _orderIdLab.frame.size.width,
                                   _orderIdLab.frame.size.height);
    
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
    
    /**price*/
    
    _priceLabel.text = [NSString stringWithFormat:@"%@",self.price];
    [_priceLabel sizeToFit];
    _priceLabel.frame = CGRectMake(CGRectGetMaxX(_iconImg.frame) + 8*Proportion,
                                   _iconImg.center.y - _priceLabel.frame.size.height/2.0,
                                   _priceLabel.frame.size.width,
                                   _priceLabel.frame.size.height);
    
    
    
    /**status*/
    _status.text = @"兑换成功";
    [_status sizeToFit];
    
    _status.frame = CGRectMake(WIDTH - 2*20*Proportion - _status.frame.size.width - CMLOrderTVCellTopFLeftMargin*Proportion,
                               CGRectGetMaxY(_mainImageView.frame) + 30*Proportion + 120*Proportion/2.0 - CMLOrderTVCellStatusHeight*Proportion/2.0,
                               _status.frame.size.width + 2*20*Proportion,
                               CMLOrderTVCellStatusHeight*Proportion);
    _status.layer.cornerRadius = CMLOrderTVCellStatusHeight*Proportion/2.0;
    
    if ([self.expressStatus intValue] == 1) {
        
        _expressBtn.hidden = NO;
        _expressBtn.frame = CGRectMake(WIDTH - 20*Proportion - _status.frame.size.width*2 - CMLOrderTVCellTopFLeftMargin*Proportion,
                                       CGRectGetMaxY(_mainImageView.frame) + 30*Proportion + 120*Proportion/2.0 - CMLOrderTVCellStatusHeight*Proportion/2.0,
                                       _status.frame.size.width,
                                       CMLOrderTVCellStatusHeight*Proportion);
        _expressBtn.layer.cornerRadius = CMLOrderTVCellStatusHeight*Proportion/2.0;
    }else{
        
        _expressBtn.hidden = YES;
    }
    
    
    self.cellHeight = CGRectGetMaxY(_bottomView.frame);
    
}

- (void) enterExpressDetail{
    
    WebViewLinkVC *vc = [[WebViewLinkVC alloc] init];
    vc.isShare = [NSNumber numberWithInt:2];
    vc.url = self.expressUrl;
    vc.name = @"快递信息";
    [[VCManger mainVC] pushVC:vc animate:YES];
}

@end
