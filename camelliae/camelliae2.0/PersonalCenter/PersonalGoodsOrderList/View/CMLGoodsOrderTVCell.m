//
//  CMLGoodsOrderTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/24.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLGoodsOrderTVCell.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "CMLLine.h"
#import "NetWorkTask.h"
#import "WebViewLinkVC.h"
#import "VCManger.h"
#import "CMLOrderListObj.h"
#import "CMLMainOrderObj.h"
#import "CMLGoodsOrderObj.h"
#import "CMLCommenOrderObj.h"
#import "CMLServeOrderObj.h"
#import "CMLOrderTransitObj.h"
#import "CMLExpressListVC.h"

@interface CMLGoodsOrderTVCell ()

@property (nonatomic,strong) UILabel *orderIdLab;

@property (nonatomic,strong) UILabel *orderStatusLab;

@property (nonatomic,strong) CMLLine *lineOne;

@property (nonatomic,assign) int allMoney;

@property (nonatomic,assign) int allNumber;

@property (nonatomic,strong) UILabel *numLab;

@property (nonatomic,strong) UILabel *moneyLab;

@property (nonatomic,strong) UIView *firstLine;

@property (nonatomic,strong) UIView *endLine;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UIView *serveBgView;

@property (nonatomic,strong) UIView *brandBgView;

@property (nonatomic,strong) UIButton *expressBtn;

@property (nonatomic,assign) BOOL isHasExpress;

@property (nonatomic,strong) CMLOrderListObj *obj;

@end

@implementation CMLGoodsOrderTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.allMoney = 0;
        self.allNumber = 0;
        [self loadViews];
    }
    return self;
}

- (void) loadViews{
    
    _orderIdLab = [[UILabel alloc] init];
    _orderIdLab.font = KSystemFontSize12;
    _orderIdLab.textColor = [UIColor CMLBlackColor];
    [self.contentView addSubview:_orderIdLab];
    
    _orderStatusLab = [[UILabel alloc] init];
    _orderStatusLab.font = KSystemFontSize12;
    _orderStatusLab.textColor = [UIColor CMLBrownColor];
    [self.contentView addSubview:_orderStatusLab];
    
    
    _lineOne = [[CMLLine alloc] init];
    _lineOne.lineWidth =1*Proportion;
    _lineOne.lineLength = [UIScreen mainScreen].bounds.size.width - 2*30*Proportion;
    _lineOne.LineColor = [UIColor CMLNewGrayColor];
    _lineOne.startingPoint = CGPointMake(30*Proportion, 74*Proportion);
    _lineOne.directionOfLine = HorizontalLine;
    [self.contentView addSubview:_lineOne];
    
    self.serveBgView = [[UIView alloc] init];
    self.serveBgView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.serveBgView];
    
    self.brandBgView = [[UIView alloc] init];
    self.brandBgView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.brandBgView];

    self.numLab = [[UILabel alloc] init];
    self.numLab.font = KSystemFontSize12;
    self.numLab.textColor = [UIColor CMLLineGrayColor];
    [self addSubview:self.numLab];
    
    self.moneyLab = [[UILabel alloc] init];
    self.moneyLab.font = KSystemFontSize14;
    self.moneyLab.textColor = [UIColor CMLBlackColor];
    [self addSubview:self.moneyLab];
    
    self.endLine = [[UIView alloc] init];
    self.endLine.backgroundColor = [UIColor CMLNewGrayColor];
    [self addSubview:self.endLine];
    
    
    _expressBtn = [[UIButton alloc] init];
    _expressBtn.titleLabel.font = KSystemFontSize12;
    _expressBtn.layer.borderColor = [UIColor CMLGreeenColor].CGColor;
    _expressBtn.layer.borderWidth = 1;
    _expressBtn.layer.cornerRadius = 6*Proportion;
    [_expressBtn setTitle:@"查看物流" forState:UIControlStateNormal];
    [_expressBtn setTitleColor:[UIColor CMLGreeenColor] forState:UIControlStateNormal];
    [_expressBtn addTarget:self action:@selector(enterExpressDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_expressBtn];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                           30*Proportion + 120*Proportion,
                                                           WIDTH,
                                                           20*Proportion)];
    _bottomView.backgroundColor = [UIColor CMLNewUserGrayColor];
    [self addSubview:_bottomView];
    
}

- (void) refreshCurrentCell:(CMLOrderListObj *) obj{
    
    self.obj = obj;
    self.allMoney = 0;
    self.allNumber = 0;
    self.isHasExpress = NO;
    
    _orderIdLab.text =  [NSString stringWithFormat:@"订单编号：%@",obj.orderInfo.orderId];
    [_orderIdLab sizeToFit];
    _orderIdLab.frame = CGRectMake(30*Proportion,
                                   74*Proportion/2.0 - _orderIdLab.frame.size.height/2.0,
                                   _orderIdLab.frame.size.width,
                                   _orderIdLab.frame.size.height);
    
    _orderStatusLab.text = obj.orderInfo.tradingStr;
    [_orderStatusLab sizeToFit];
    _orderStatusLab.frame = CGRectMake(WIDTH - 30*Proportion - _orderStatusLab.frame.size.width,
                                       74*Proportion/2.0 - _orderStatusLab.frame.size.height/2.0,
                                       _orderStatusLab.frame.size.width,
                                       _orderStatusLab.frame.size.height);
    
    [self loadServeView:obj.projectOrderInfo.dataList];
    
    [self loadGoodsView:obj.goodsOrderInfo.dataList];
    
    
    self.moneyLab.text = [NSString stringWithFormat:@"总计：¥%0.2f",[obj.orderInfo.payAmtE2 floatValue]/100];
    [self.moneyLab sizeToFit];
    self.moneyLab.frame = CGRectMake(WIDTH - 30*Proportion - self.moneyLab.frame.size.width,
                                     CGRectGetMaxY(self.brandBgView.frame) + (100*Proportion/2.0 - self.moneyLab.frame.size.height/2.0),
                                     self.moneyLab.frame.size.width,
                                     self.moneyLab.frame.size.height);
    
    self.numLab.text = [NSString stringWithFormat:@"共%d件商品",self.allNumber];
    [self.numLab sizeToFit];
    self.numLab.frame = CGRectMake(self.moneyLab.frame.origin.x - 20*Proportion - self.numLab.frame.size.width,
                                   CGRectGetMaxY(self.moneyLab.frame) - self.numLab.frame.size.height,
                                   self.numLab.frame.size.width,
                                   self.numLab.frame.size.height);
    
    if (self.isHasExpress) {
        
        _expressBtn.hidden = NO;
        [_expressBtn sizeToFit];
        _expressBtn.frame = CGRectMake(WIDTH - 30*Proportion - (_expressBtn.frame.size.width + 20*Proportion),
                                       CGRectGetMaxY(self.brandBgView.frame) + 100*Proportion + 110*Proportion/2.0 - _expressBtn.frame.size.height/2.0,
                                       _expressBtn.frame.size.width + 20*Proportion,
                                       _expressBtn.frame.size.height);
        _bottomView.frame = CGRectMake(0,
                                       CGRectGetMaxY(self.brandBgView.frame) + 100*Proportion + 110*Proportion,
                                       WIDTH,
                                       20*Proportion);
    }else{
        
        _expressBtn.hidden = YES;
        _bottomView.frame = CGRectMake(0,
                                       CGRectGetMaxY(self.brandBgView.frame) + 100*Proportion,
                                       WIDTH,
                                       20*Proportion);
        
    }
    


    self.currentHeight = CGRectGetMaxY(_bottomView.frame);
    
}

- (void) loadServeView:(NSArray *) currentArray{
    
    [self.serveBgView.subviews makeObjectsPerformSelector:@selector( removeFromSuperview)];
    
    if (currentArray.count == 0) {
        
        self.serveBgView.frame = CGRectMake(0,
                                            74*Proportion,
                                            WIDTH,
                                            0);
    }else{
        
        
        self.serveBgView.frame = CGRectMake(0,
                                            74*Proportion,
                                            WIDTH,
                                            60*Proportion + (160*Proportion + 40*Proportion)*currentArray.count);
        
        UIView *typeNameLab = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       WIDTH,
                                                                       60*Proportion)];
        
        [self.serveBgView addSubview:typeNameLab];
        
        UIView *cv = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                              60*Proportion/2.0 - 10*Proportion/2.0,
                                                              10*Proportion,
                                                              10*Proportion)];
        cv.layer.cornerRadius = 10*Proportion/2.0;
        cv.layer.borderWidth = 1*Proportion;
        cv.layer.borderColor = [UIColor CMLLightBrownColor].CGColor;
        [typeNameLab addSubview:cv];
        
        UILabel *nameLab  = [[UILabel alloc] init];
        nameLab.textColor = [UIColor CMLLightBrownColor];
        nameLab.font = KSystemFontSize11;
        nameLab.text = @"服务";
        [nameLab sizeToFit];
        nameLab.frame = CGRectMake(CGRectGetMaxX(cv.frame) + 10*Proportion,
                                   60*Proportion/2.0 - nameLab.frame.size.height/2.0,
                                   nameLab.frame.size.width,
                                   nameLab.frame.size.height);
        [typeNameLab addSubview:nameLab];
        
        for (int i = 0; i < currentArray.count; i++) {
            
            CMLServeOrderObj *tempObj = [CMLServeOrderObj getBaseObjFrom:currentArray[i]];
            UIView *moduleView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                          (160*Proportion + 40*Proportion)*i + 60*Proportion,
                                                                          WIDTH,
                                                                          160*Proportion)];
            moduleView.backgroundColor = [UIColor CMLWhiteColor];
            [self.serveBgView addSubview:moduleView];
            
            UIImageView *moduleImage = [[UIImageView alloc] initWithFrame:CGRectMake(50*Proportion,
                                                                                     0,
                                                                                     160*Proportion,
                                                                                     160*Proportion)];
            moduleImage.contentMode = UIViewContentModeScaleAspectFill;
            moduleImage.clipsToBounds = YES;
            moduleImage.layer.borderWidth = 1*Proportion;
            moduleImage.layer.borderColor = [UIColor CMLSerachLineGrayColor].CGColor;
            [moduleView addSubview:moduleImage];
            [NetWorkTask setImageView:moduleImage WithURL:tempObj.coverPicThumb placeholderImage:nil];
            
            UILabel *moduleTitleLab = [[UILabel alloc] init];
            moduleTitleLab.numberOfLines = 2;
            moduleTitleLab.font = KSystemFontSize12;
            moduleTitleLab.text = tempObj.title;
            moduleTitleLab.textAlignment = NSTextAlignmentLeft;
            [moduleTitleLab sizeToFit];
            if (moduleTitleLab.frame.size.width > WIDTH - 50*Proportion - 30*Proportion - 20*Proportion - 160*Proportion) {
                
                moduleTitleLab.frame = CGRectMake(CGRectGetMaxX(moduleImage.frame) + 20*Proportion,
                                                  0,
                                                  WIDTH - 50*Proportion - 30*Proportion - 20*Proportion - 160*Proportion,
                                                  moduleTitleLab.frame.size.height*2);
            }else{
                
                moduleTitleLab.frame = CGRectMake(CGRectGetMaxX(moduleImage.frame) + 20*Proportion,
                                                  0,
                                                  WIDTH - 50*Proportion - 30*Proportion - 20*Proportion - 160*Proportion,
                                                  moduleTitleLab.frame.size.height);
                
            }
            [moduleView addSubview:moduleTitleLab];
            UILabel *modulePriceLab = [[UILabel alloc] init];
            modulePriceLab.font = KSystemBoldFontSize14;
            modulePriceLab.textColor = [UIColor CMLBrownColor];
            modulePriceLab.text =  [NSString stringWithFormat:@"¥%d",[tempObj.orderInfo.payAmtE2 intValue]/100/[tempObj.orderInfo.goodsNum intValue]];
            
            [modulePriceLab sizeToFit];
            modulePriceLab.frame = CGRectMake(CGRectGetMaxX(moduleImage.frame) + 20*Proportion,
                                              CGRectGetMaxY(moduleImage.frame) - modulePriceLab.frame.size.height,
                                              modulePriceLab.frame.size.width,
                                              modulePriceLab.frame.size.height);
            
            [moduleView addSubview:modulePriceLab];
            
            if ([tempObj.orderInfo.payType intValue] == 1) {
                
                UILabel *promLab = [[UILabel alloc] init];
                promLab.font = KSystemBoldFontSize10;
                promLab.textColor = [UIColor CMLBrownColor];
                promLab.text = @"（订金）";
                [promLab sizeToFit];
                promLab.frame = CGRectMake(CGRectGetMaxX(modulePriceLab.frame) + 5*Proportion,
                                           modulePriceLab.center.y - promLab.frame.size.height/2.0,
                                           promLab.frame.size.width,
                                           promLab.frame.size.height);
                [moduleView addSubview:promLab];
            }
            
            self.allNumber += [tempObj.orderInfo.goodsNum intValue];
            self.allMoney += [tempObj.orderInfo.payAmtE2 intValue]/100;
            UILabel *statusLab = [[UILabel alloc] init];
            statusLab.font = KSystemBoldFontSize12;
            statusLab.textColor = [UIColor CMLGreeenColor];
            
            if ([tempObj.orderInfo.backOutStatus intValue] == 1 ) {
                
                if ([tempObj.orderInfo.afterSaleStatus intValue] == 3 ||[tempObj.orderInfo.afterSaleStatus intValue] == 4 ) {
                    
                    if ([tempObj.orderInfo.tradingStatus intValue] <= 1) {
                        
                        statusLab.hidden = YES;
                    }
                    
                    statusLab.text = tempObj.orderInfo.tradingStr;
                    
                }else{
                    
                    statusLab.text = tempObj.orderInfo.afterSaleStatusStr;
                }
                
                
            }else{

                statusLab.text = tempObj.orderInfo.tradingStr;
                
            }

            
            [statusLab sizeToFit];
            statusLab.frame = CGRectMake(WIDTH - 30*Proportion - statusLab.frame.size.width, CGRectGetMaxY(moduleImage.frame) - statusLab.frame.size.height, statusLab.frame.size.width, statusLab.frame.size.height);
            [moduleView addSubview:statusLab];
            
            UILabel *numLab = [[UILabel alloc] init];
            numLab.font = KSystemFontSize14;
            numLab.text = [NSString stringWithFormat:@"x %@",tempObj.orderInfo.goodsNum];
            numLab.textColor = [UIColor CMLtextInputGrayColor];
            [numLab sizeToFit];
            numLab.frame = CGRectMake(statusLab.frame.origin.x - 10*Proportion - numLab.frame.size.width,
                                      statusLab.center.y - numLab.frame.size.height/2.0,
                                      numLab.frame.size.width,
                                      numLab.frame.size.height);
            [moduleView addSubview:numLab];
            
            UIView *endLine = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                       CGRectGetMaxY(moduleView.frame) + 19*Proportion,
                                                                       WIDTH - 30*Proportion*2,
                                                                       1*Proportion)];
            endLine.backgroundColor = [UIColor CMLNewGrayColor];
            [self.serveBgView addSubview:endLine];
            
        }
        
    }
    
}

- (void) loadGoodsView:(NSArray *) currentArray{
    
    [self.brandBgView.subviews makeObjectsPerformSelector:@selector( removeFromSuperview)];
    
    if (currentArray.count == 0) {
        
        self.brandBgView.frame = CGRectMake(0,
                                            CGRectGetMaxY(self.serveBgView.frame),
                                            WIDTH,
                                            0);
    }else{
        
        self.brandBgView.frame = CGRectMake(0,
                                            CGRectGetMaxY(self.serveBgView.frame),
                                            WIDTH,
                                            60*Proportion + (160*Proportion + 40*Proportion)*currentArray.count);
        UIView *typeNameLab = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       WIDTH,
                                                                       60*Proportion)];
        
        [self.brandBgView addSubview:typeNameLab];
        
        UIView *cv = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                              60*Proportion/2.0 - 10*Proportion/2.0,
                                                              10*Proportion,
                                                              10*Proportion)];
        cv.layer.cornerRadius = 10*Proportion/2.0;
        cv.layer.borderWidth = 1*Proportion;
        cv.layer.borderColor = [UIColor CMLLightBrownColor].CGColor;
        [typeNameLab addSubview:cv];
        
        UILabel *nameLab  = [[UILabel alloc] init];
        nameLab.textColor = [UIColor CMLLightBrownColor];
        nameLab.font = KSystemFontSize11;
        nameLab.text = @"单品";
        [nameLab sizeToFit];
        nameLab.frame = CGRectMake(CGRectGetMaxX(cv.frame) + 10*Proportion,
                                   60*Proportion/2.0 - nameLab.frame.size.height/2.0,
                                   nameLab.frame.size.width,
                                   nameLab.frame.size.height);
        [typeNameLab addSubview:nameLab];
        
        
        for (int i = 0; i < currentArray.count; i++) {
            
            CMLGoodsOrderObj *tempObj = [CMLGoodsOrderObj getBaseObjFrom:currentArray[i]];
            
            if (!self.isHasExpress) {
                
                if ([tempObj.orderInfo.expressStatus intValue] == 1) {
                    
                    self.isHasExpress = YES;
                }
            }
            UIView *moduleView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                          (160*Proportion + 40*Proportion)*i + 60*Proportion,
                                                                          WIDTH,
                                                                          160*Proportion)];
            moduleView.backgroundColor = [UIColor CMLWhiteColor];
            [self.brandBgView addSubview:moduleView];
            
            UIImageView *moduleImage = [[UIImageView alloc] initWithFrame:CGRectMake(50*Proportion,
                                                                                     0,
                                                                                     160*Proportion,
                                                                                     160*Proportion)];
            moduleImage.contentMode = UIViewContentModeScaleAspectFill;
            moduleImage.clipsToBounds = YES;
            moduleImage.layer.borderWidth = 1*Proportion;
            moduleImage.layer.borderColor = [UIColor CMLSerachLineGrayColor].CGColor;
            [moduleView addSubview:moduleImage];
            [NetWorkTask setImageView:moduleImage WithURL:tempObj.coverPicThumb placeholderImage:nil];
            
            UILabel *moduleTitleLab = [[UILabel alloc] init];
            moduleTitleLab.numberOfLines = 2;
            moduleTitleLab.font = KSystemFontSize12;
            moduleTitleLab.text = tempObj.brandName;
            moduleTitleLab.textAlignment = NSTextAlignmentLeft;
            [moduleTitleLab sizeToFit];
            if (moduleTitleLab.frame.size.width > WIDTH - 50*Proportion - 30*Proportion - 20*Proportion - 160*Proportion) {
                
                moduleTitleLab.frame = CGRectMake(CGRectGetMaxX(moduleImage.frame) + 20*Proportion,
                                                  0,
                                                  WIDTH - 50*Proportion - 30*Proportion - 20*Proportion - 160*Proportion,
                                                  moduleTitleLab.frame.size.height*2);
            }else{
                
                moduleTitleLab.frame = CGRectMake(CGRectGetMaxX(moduleImage.frame) + 20*Proportion,
                                                  0,
                                                  WIDTH - 50*Proportion - 30*Proportion - 20*Proportion - 160*Proportion,
                                                  moduleTitleLab.frame.size.height);
                
            }
            [moduleView addSubview:moduleTitleLab];
            
            UILabel *packageNameLab = [[UILabel alloc] init];
            packageNameLab.text = [NSString stringWithFormat:@"已选：%@",tempObj.orderInfo.packageName];
            packageNameLab.font = KSystemFontSize10;
            packageNameLab.textColor = [UIColor CMLLineGrayColor];
            [packageNameLab sizeToFit];
            packageNameLab.frame = CGRectMake(CGRectGetMaxX(moduleImage.frame) + 20*Proportion,
                                              CGRectGetMaxY(moduleTitleLab.frame) + 10*Proportion,
                                              packageNameLab.frame.size.width,
                                              packageNameLab.frame.size.height);
            [moduleView addSubview:packageNameLab];
            
            
            
            UILabel *modulePriceLab = [[UILabel alloc] init];
            modulePriceLab.font = KSystemBoldFontSize14;
            modulePriceLab.textColor = [UIColor CMLBrownColor];
            modulePriceLab.text =  [NSString stringWithFormat:@"¥%d",[tempObj.orderInfo.payAmtE2 intValue]/100/[tempObj.orderInfo.goodsNum intValue]];
            [modulePriceLab sizeToFit];
            modulePriceLab.frame = CGRectMake(CGRectGetMaxX(moduleImage.frame) + 20*Proportion,
                                              CGRectGetMaxY(moduleImage.frame) - modulePriceLab.frame.size.height,
                                              modulePriceLab.frame.size.width,
                                              modulePriceLab.frame.size.height);
            
            [moduleView addSubview:modulePriceLab];
            
            if ([tempObj.is_deposit intValue] == 1) {
                
                UILabel *promLab = [[UILabel alloc] init];
                promLab.font = KSystemBoldFontSize10;
                promLab.textColor = [UIColor CMLBrownColor];
                promLab.text = @"（订金）";
                [promLab sizeToFit];
                promLab.frame = CGRectMake(CGRectGetMaxX(modulePriceLab.frame) + 5*Proportion,
                                           modulePriceLab.center.y - promLab.frame.size.height/2.0,
                                           promLab.frame.size.width,
                                           promLab.frame.size.height);
                [moduleView addSubview:promLab];
            }
            
            
            self.allNumber += [tempObj.orderInfo.goodsNum intValue];
            self.allMoney += [tempObj.orderInfo.payAmtE2 intValue]/100;
            
            UILabel *statusLab = [[UILabel alloc] init];
            statusLab.font = KSystemBoldFontSize12;
            statusLab.textColor = [UIColor CMLGreeenColor];
            
            
            if ([tempObj.orderInfo.backOutStatus intValue] == 1 ) {
                
                
                if ([tempObj.orderInfo.afterSaleStatus intValue] == 3 ||[tempObj.orderInfo.afterSaleStatus intValue] == 4 ) {
                    
                    statusLab.text = tempObj.orderInfo.tradingStr;
                    
                    if ([tempObj.orderInfo.tradingStatus intValue] <= 1) {
                        
                        statusLab.hidden = YES;
                    }
                    
                }else{
                    
                    statusLab.text = tempObj.orderInfo.afterSaleStatusStr;
                }
        
                
            }else{
                statusLab.text = tempObj.orderInfo.tradingStr;
                if ([tempObj.orderInfo.tradingStatus intValue] <= 1) {
                    
                    statusLab.hidden = YES;
                }
            
                
            }
            [statusLab sizeToFit];
            statusLab.frame = CGRectMake(WIDTH - 30*Proportion - statusLab.frame.size.width,
                                         CGRectGetMaxY(moduleImage.frame) - statusLab.frame.size.height,
                                         statusLab.frame.size.width,
                                         statusLab.frame.size.height);
            [moduleView addSubview:statusLab];
            
            UILabel *numLab = [[UILabel alloc] init];
            numLab.font = KSystemFontSize14;
            numLab.text = [NSString stringWithFormat:@"x %@",tempObj.orderInfo.goodsNum];
            numLab.textColor = [UIColor CMLtextInputGrayColor];
            [numLab sizeToFit];
            
            if (statusLab.hidden) {
                
                numLab.frame = CGRectMake(WIDTH - 30*Proportion - numLab.frame.size.width,
                                          statusLab.center.y - numLab.frame.size.height/2.0,
                                          numLab.frame.size.width,
                                          numLab.frame.size.height);
                
            }else{
                
                numLab.frame = CGRectMake(statusLab.frame.origin.x - 10*Proportion - numLab.frame.size.width,
                                          statusLab.center.y - numLab.frame.size.height/2.0,
                                          numLab.frame.size.width,
                                          numLab.frame.size.height);
            
            }
            [moduleView addSubview:numLab];
            UIView *endLine = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                       CGRectGetMaxY(moduleView.frame) + 19*Proportion,
                                                                       WIDTH - 30*Proportion*2,
                                                                       1*Proportion)];
            endLine.backgroundColor = [UIColor CMLNewGrayColor];
            [self.brandBgView addSubview:endLine];
            
        }
        
    }
    
    
}

- (void) enterExpressDetail{

    CMLExpressListVC *vc = [[CMLExpressListVC alloc] initWith:self.obj];
    [[VCManger mainVC] pushVC:vc animate:YES];
}
@end
