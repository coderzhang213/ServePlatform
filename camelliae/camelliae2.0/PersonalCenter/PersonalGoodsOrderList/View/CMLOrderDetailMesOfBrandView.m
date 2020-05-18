//
//  CMLOrderDetailMesOfBrandView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/12.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLOrderDetailMesOfBrandView.h"
#import "CMLOrderListObj.h"
#import "NetWorkTask.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "CMLMainOrderObj.h"
#import "CMLOrderTransitObj.h"
#import "CMLOrderInfoObj.h"
#import "CMLGoodsOrderObj.h"
#import "CMLServeOrderObj.h"
#import "CMLCommenOrderObj.h"
#import "CMLGoodsAfterSalesVC.h"
#import "VCManger.h"
#import "CMLCommodityDetailMessageVC.h"
#import "ServeDefaultVC.h"
#import "MJExtension.h"
#import "CMLUserPushActivityDetailVC.h"
#import "CMLUserPushGoodsVC.h"
#import "CMLUserPushServeDetailVC.h"

@interface CMLOrderDetailMesOfBrandView ()

@property (nonatomic,strong) UIView *goodsBgView;

@property (nonatomic,strong) UIView *serveBgView;

@property (nonatomic,strong) UIView *totalView;

@property (nonatomic,strong) CMLOrderListObj *obj;

@property (nonatomic,assign) int allNumber;

@property (nonatomic,assign) int allMoney;

@property (nonatomic,strong) NSNumber *deducMoney;

@property (nonatomic,strong) NSNumber *isUserPush;


@end

@implementation CMLOrderDetailMesOfBrandView


- (instancetype)initWith:(CMLOrderListObj *) obj andDeducMoney:(NSNumber *) money{
    
    self.obj = obj;
    self = [super init];
    if (self) {
        
        self.allMoney = 0;
        self.allNumber = 0;
        self.isHasExpress = NO;
        self.deducMoney = money;
        [self loadViews];
    }
    return self;
}

- (instancetype)initWith:(CMLOrderListObj *) obj {
    
    self.obj = obj;
    self = [super init];
    if (self) {
    
        self.allMoney = 0;
        self.allNumber = 0;
        self.isHasExpress = NO;
        [self loadViews];
    }
    return self;
}

- (void) loadViews{
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               WIDTH,
                                                               74*Proportion)];
    topView.backgroundColor = [UIColor CMLWhiteColor];
    [self addSubview:topView];
    
    UILabel *brandPromLab = [[UILabel alloc] init];
    brandPromLab.font = KSystemFontSize12;
    brandPromLab.textColor = [UIColor CMLLineGrayColor];
    brandPromLab.text = @"商品信息";
    [brandPromLab sizeToFit];
    brandPromLab.frame = CGRectMake(30*Proportion,
                                    74*Proportion/2.0 - brandPromLab.frame.size.height/2.0,
                                    brandPromLab.frame.size.width,
                                    brandPromLab.frame.size.height);
    [topView addSubview:brandPromLab];
    
    UILabel *brandStatusLab = [[UILabel alloc] init];
    brandStatusLab.textColor = [UIColor CMLBrownColor];
    brandStatusLab.font = KSystemFontSize12;
    brandStatusLab.text = self.obj.orderInfo.tradingStr;
    [brandStatusLab sizeToFit];
    brandStatusLab.frame = CGRectMake(WIDTH - 30*Proportion - brandStatusLab.frame.size.width,
                                      74*Proportion/2.0 - brandStatusLab.frame.size.height/2.0,
                                      brandStatusLab.frame.size.width,
                                      brandStatusLab.frame.size.height);
    [topView addSubview:brandStatusLab];
    
    UIView *endLine = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion, 73*Proportion, WIDTH - 30*Proportion*2, 1*Proportion)];
    endLine.backgroundColor = [UIColor CMLSerachLineGrayColor];
    [topView addSubview:endLine];
    
    self.serveBgView = [[UIView alloc] init];
    self.serveBgView.backgroundColor = [UIColor CMLWhiteColor];
    [self addSubview:self.serveBgView];
    
    self.goodsBgView = [[UIView alloc] init];
    self.goodsBgView.backgroundColor = [UIColor CMLWhiteColor];
    [self addSubview:self.goodsBgView];
    
    [self loadServeMessage];
    
    [self loadGoodsMessage];
    
    [self loadTotalView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(self.totalView.frame),
                                                                  WIDTH,
                                                                  20*Proportion)];
    bottomView.backgroundColor = [UIColor CMLNewGrayColor];
    [self addSubview:bottomView];
    
    self.curentHeight = CGRectGetMaxY(bottomView.frame);
    
    
}

- (void) loadServeMessage{
    
    
    if (self.obj.projectOrderInfo.dataList.count == 0) {
        
        self.serveBgView.frame = CGRectMake(0,
                                            74*Proportion,
                                            WIDTH,
                                            0);
        self.serveBgView.hidden = YES;
    }else{
        
        self.serveBgView.hidden = NO;
        
        self.serveBgView.frame = CGRectMake(0,
                                            74*Proportion,
                                            WIDTH,
                                            (40*Proportion + 54*Proportion + 160*Proportion)*self.obj.projectOrderInfo.dataList.count);
        
        for (int i = 0; i < self.obj.projectOrderInfo.dataList.count; i++) {
            
            CMLServeOrderObj *tempObj = [CMLServeOrderObj getBaseObjFrom:self.obj.projectOrderInfo.dataList[i]];
            
            if ([tempObj.isUserPublish intValue] == 1) {
               
                self.isUserPush = [NSNumber numberWithInt:1];
            }
           
            
            UIView *moduleView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                          (40*Proportion + 54*Proportion + 160*Proportion)*i,
                                                                          WIDTH,
                                                                          40*Proportion + 54*Proportion + 160*Proportion)];
            moduleView.backgroundColor = [UIColor CMLWhiteColor];
            moduleView.userInteractionEnabled = YES;
            [self.serveBgView addSubview:moduleView];
            
            UIImageView *moduleImage = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                                     40*Proportion,
                                                                                     160*Proportion,
                                                                                     160*Proportion)];
            moduleImage.backgroundColor = [UIColor CMLWhiteColor];
            moduleImage.userInteractionEnabled = YES;
            moduleImage.contentMode = UIViewContentModeScaleAspectFill;
            moduleImage.layer.borderWidth = 1*Proportion;
            moduleImage.layer.borderColor = [UIColor CMLSerachLineGrayColor].CGColor;
            moduleImage.clipsToBounds = YES;
            [moduleView addSubview:moduleImage];
            [NetWorkTask setImageView:moduleImage WithURL:tempObj.coverPicThumb placeholderImage:nil];
            
            UIButton *enterDetailBtn = [[UIButton alloc] initWithFrame:moduleImage.bounds];
            enterDetailBtn.backgroundColor = [UIColor clearColor];
            enterDetailBtn.tag = i + 100;
            [enterDetailBtn addTarget:self action:@selector(enterServeVC:) forControlEvents:UIControlEventTouchUpInside];
            [moduleImage addSubview:enterDetailBtn];
            
            UILabel *moduleTitleLab = [[UILabel alloc] init];
            moduleTitleLab.numberOfLines = 2;
            moduleTitleLab.font = KSystemFontSize12;
            moduleTitleLab.text = tempObj.title;
            moduleTitleLab.textAlignment = NSTextAlignmentLeft;
            [moduleTitleLab sizeToFit];
            if (moduleTitleLab.frame.size.width > WIDTH - 30*Proportion - 30*Proportion - 20*Proportion - 160*Proportion) {
                
                moduleTitleLab.frame = CGRectMake(CGRectGetMaxX(moduleImage.frame) + 20*Proportion,
                                                  40*Proportion,
                                                  WIDTH - 30*Proportion - 30*Proportion - 20*Proportion - 160*Proportion,
                                                  moduleTitleLab.frame.size.height*2);
            }else{
                
                moduleTitleLab.frame = CGRectMake(CGRectGetMaxX(moduleImage.frame) + 20*Proportion,
                                                  40*Proportion,
                                                  WIDTH - 30*Proportion - 30*Proportion - 20*Proportion - 160*Proportion,
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
                promLab.textColor = [UIColor CMLWhiteColor];
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
            
            UILabel *numLab = [[UILabel alloc] init];
            numLab.font = KSystemFontSize14;
            numLab.text = [NSString stringWithFormat:@"x %@",tempObj.orderInfo.goodsNum];
            numLab.textColor = [UIColor CMLtextInputGrayColor];
            [numLab sizeToFit];
            numLab.frame = CGRectMake(WIDTH - 30*Proportion - numLab.frame.size.width,
                                      CGRectGetMaxY(moduleImage.frame) - numLab.frame.size.height,
                                      numLab.frame.size.width,
                                      numLab.frame.size.height);
            [moduleView addSubview:numLab];
            
            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                          CGRectGetMaxY(moduleImage.frame),
                                                                          WIDTH,
                                                                          54*Proportion)];
            bottomView.backgroundColor = [UIColor CMLWhiteColor];
            [moduleView addSubview:bottomView];
            
            UIButton *backOutbtn = [[UIButton alloc] initWithFrame:CGRectMake(160*Proportion + 30*Proportion + 20*Proportion,
                                                                              54*Proportion/2.0 - 34*Proportion/2.0,
                                                                              70*Proportion,
                                                                              34*Proportion)];
            backOutbtn.layer.borderWidth = 1*Proportion;
            backOutbtn.layer.borderColor = [UIColor CMLBlackColor].CGColor;
            [backOutbtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
            backOutbtn.layer.cornerRadius = 34*Proportion/2.0;
            backOutbtn.titleLabel.font = KSystemFontSize10;
            backOutbtn.tag = i;
            if ([tempObj.orderInfo.backOutType intValue] == 1) {
                

                [backOutbtn setTitle:@"退款" forState:UIControlStateNormal];
            }else{
                [backOutbtn setTitle:@"售后" forState:UIControlStateNormal];
            }
            [backOutbtn addTarget:self action:@selector(sevresAfterSales:) forControlEvents:UIControlEventTouchUpInside];
            [bottomView addSubview:backOutbtn];
            
            UILabel *statusLab = [[UILabel alloc] init];
            statusLab.font = KSystemBoldFontSize12;
            statusLab.textColor = [UIColor CMLGreeenColor];

            if ([tempObj.orderInfo.backOutStatus intValue] == 1 ) {
                
                if ([tempObj.orderInfo.afterSaleStatus intValue] == 3 ||[tempObj.orderInfo.afterSaleStatus intValue] == 4 ) {
      
                    statusLab.text = tempObj.orderInfo.tradingStr;
                    
                    if ([tempObj.orderInfo.tradingStatus intValue] <= 1) {
                        
                        statusLab.hidden = YES;
                        
                        bottomView.frame = CGRectZero;
                        self.goodsBgView.frame = CGRectMake(0,
                                                            CGRectGetMaxY(self.serveBgView.frame),
                                                            WIDTH,
                                                            (160*Proportion + 40*Proportion + 20*Proportion)*self.obj.goodsOrderInfo.dataList.count);
                    }
                    
                }else{
                    
                    statusLab.text = tempObj.orderInfo.afterSaleStatusStr;
                }
                
                backOutbtn.hidden = YES;
                
            }else{
                
                backOutbtn.hidden = NO;
                statusLab.text = tempObj.orderInfo.tradingStr;
                
            }

            [statusLab sizeToFit];
            statusLab.frame = CGRectMake(WIDTH - 30*Proportion - statusLab.frame.size.width,
                                         bottomView.frame.size.height/2.0 - statusLab.frame.size.height/2.0,
                                         statusLab.frame.size.width,
                                         statusLab.frame.size.height);
            [bottomView addSubview:statusLab];
            
            if ([tempObj.is_video_project intValue] == 1) {
                
                backOutbtn.hidden = YES;
                if ([tempObj.orderInfo.tradingStatus intValue] <= 1) {
                    
                    statusLab.hidden = YES;
                    
                    bottomView.frame = CGRectZero;
                    self.goodsBgView.frame = CGRectMake(0,
                                                        CGRectGetMaxY(self.serveBgView.frame),
                                                        WIDTH,
                                                        (160*Proportion + 40*Proportion + 20*Proportion)*self.obj.goodsOrderInfo.dataList.count);
                }

            }
            
            if ([tempObj.isUserPublish intValue] == 1) {
                
                backOutbtn.hidden = YES;
                if ([tempObj.orderInfo.tradingStatus intValue] <= 1) {
                    
                    statusLab.hidden = YES;
                    
                    bottomView.frame = CGRectZero;
                    self.goodsBgView.frame = CGRectMake(0,
                                                        CGRectGetMaxY(self.serveBgView.frame),
                                                        WIDTH,
                                                        (160*Proportion + 40*Proportion + 20*Proportion)*self.obj.goodsOrderInfo.dataList.count);
                }

            }
            
        }
    }
}

- (void) loadGoodsMessage{
    
    if (self.obj.goodsOrderInfo.dataList.count == 0) {
        
        self.goodsBgView.frame = CGRectMake(0,
                                            CGRectGetMaxY(self.serveBgView.frame),
                                            WIDTH,
                                            0);
        self.goodsBgView.hidden = YES;
        
    }else{
        
        self.goodsBgView.frame = CGRectMake(0,
                                            CGRectGetMaxY(self.serveBgView.frame),
                                            WIDTH,
                                            (160*Proportion + 40*Proportion + 54*Proportion)*self.obj.goodsOrderInfo.dataList.count);
        self.goodsBgView.hidden = NO;
        
        for (int i = 0; i < self.obj.goodsOrderInfo.dataList.count; i++) {
            
            CMLGoodsOrderObj *tempObj = [CMLGoodsOrderObj getBaseObjFrom:self.obj.goodsOrderInfo.dataList[i]];
            
            if ([tempObj.isUserPublish intValue] == 1) {
                
                self.isUserPush = [NSNumber numberWithInt:1];
            }
            
            if (!self.isHasExpress) {
                
                if ([tempObj.orderInfo.expressStatus intValue] == 1) {
                    
                    self.isHasExpress = YES;
                }
            }
            UIView *moduleView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                          (160*Proportion + 40*Proportion + 54*Proportion)*i,
                                                                          WIDTH,
                                                                          160*Proportion + 40*Proportion + 54*Proportion)];
            moduleView.backgroundColor = [UIColor CMLWhiteColor];
            [self.goodsBgView addSubview:moduleView];
            
            UIImageView *moduleImage = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                                     40*Proportion,
                                                                                     160*Proportion,
                                                                                     160*Proportion)];
            moduleImage.contentMode = UIViewContentModeScaleAspectFill;
            moduleImage.clipsToBounds = YES;
            moduleImage.layer.borderWidth = 1*Proportion;
            moduleImage.layer.borderColor = [UIColor CMLSerachLineGrayColor].CGColor;
            [moduleView addSubview:moduleImage];
            moduleImage.userInteractionEnabled = YES;
            [NetWorkTask setImageView:moduleImage WithURL:tempObj.coverPicThumb placeholderImage:nil];
            UIButton *enterDetailBtn = [[UIButton alloc] initWithFrame:moduleImage.bounds];
            enterDetailBtn.backgroundColor = [UIColor clearColor];
            [moduleImage addSubview:enterDetailBtn];
            enterDetailBtn.tag = i + 100;
            [enterDetailBtn addTarget:self action:@selector(enterGoodsVC:) forControlEvents:UIControlEventTouchUpInside];
           
            
            UILabel *moduleTitleLab = [[UILabel alloc] init];
            moduleTitleLab.numberOfLines = 2;
            moduleTitleLab.font = KSystemFontSize12;
            moduleTitleLab.text = tempObj.brandName;
            moduleTitleLab.textAlignment = NSTextAlignmentLeft;
            [moduleTitleLab sizeToFit];
            if (moduleTitleLab.frame.size.width > WIDTH - 50*Proportion - 30*Proportion - 20*Proportion - 160*Proportion) {
                
                moduleTitleLab.frame = CGRectMake(CGRectGetMaxX(moduleImage.frame) + 20*Proportion,
                                                  40*Proportion,
                                                  WIDTH - 50*Proportion - 30*Proportion - 20*Proportion - 160*Proportion,
                                                  moduleTitleLab.frame.size.height*2);
            }else{
                
                moduleTitleLab.frame = CGRectMake(CGRectGetMaxX(moduleImage.frame) + 20*Proportion,
                                                  40*Proportion,
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
            
            
            UILabel *numLab = [[UILabel alloc] init];
            numLab.font = KSystemFontSize14;
            numLab.text = [NSString stringWithFormat:@"x %@",tempObj.orderInfo.goodsNum];
            numLab.textColor = [UIColor CMLtextInputGrayColor];
            [numLab sizeToFit];
            numLab.frame = CGRectMake(WIDTH - 30*Proportion - numLab.frame.size.width,
                                      CGRectGetMaxY(moduleImage.frame) - numLab.frame.size.height,
                                      numLab.frame.size.width,
                                      numLab.frame.size.height);
            [moduleView addSubview:numLab];
            
            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                          CGRectGetMaxY(moduleImage.frame),
                                                                          WIDTH,
                                                                          54*Proportion)];
            bottomView.backgroundColor = [UIColor CMLWhiteColor];
            [moduleView addSubview:bottomView];

            UIButton *backOutbtn = [[UIButton alloc] initWithFrame:CGRectMake(160*Proportion + 30*Proportion + 20*Proportion,
                                                                              54*Proportion/2.0 - 34*Proportion/2.0,
                                                                              70*Proportion,
                                                                              34*Proportion)];
            backOutbtn.layer.borderWidth = 1*Proportion;
            backOutbtn.layer.borderColor = [UIColor CMLBlackColor].CGColor;
            backOutbtn.layer.cornerRadius = 34*Proportion/2.0;
            [backOutbtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
            backOutbtn.titleLabel.font = KSystemFontSize10;
            backOutbtn.tag = i;
            if ([tempObj.orderInfo.backOutType intValue] == 1) {
                [backOutbtn setTitle:@"退款" forState:UIControlStateNormal];
            }else if([tempObj.orderInfo.backOutType intValue] == 2) {
                [backOutbtn setTitle:@"售后" forState:UIControlStateNormal];
            }
            
            [backOutbtn addTarget:self action:@selector(goodAfterSales:) forControlEvents:UIControlEventTouchUpInside];
            [bottomView addSubview:backOutbtn];

            
            UILabel *statusLab = [[UILabel alloc] init];
            statusLab.font = KSystemBoldFontSize12;
            statusLab.textColor = [UIColor CMLGreeenColor];
            
            
            if ([tempObj.orderInfo.backOutStatus intValue] == 1 ) {
                
                
                if ([tempObj.orderInfo.afterSaleStatus intValue] == 3 ||[tempObj.orderInfo.afterSaleStatus intValue] == 4 ) {
                    
                    statusLab.text = tempObj.orderInfo.tradingStr;
                    
                    if ([tempObj.orderInfo.tradingStatus intValue] <= 1) {
                        
                        statusLab.hidden = YES;
                        bottomView.frame = CGRectZero;
                        self.goodsBgView.frame = CGRectMake(0,
                                                            CGRectGetMaxY(self.serveBgView.frame),
                                                            WIDTH,
                                                            (160*Proportion + 40*Proportion + 20*Proportion)*self.obj.goodsOrderInfo.dataList.count);

                    }
                }else{
                    
                    statusLab.text = tempObj.orderInfo.afterSaleStatusStr;
                }
                 backOutbtn.hidden = YES;
                
            }else{
                statusLab.text = tempObj.orderInfo.tradingStr;
                if ([tempObj.orderInfo.tradingStatus intValue] <= 1) {
                    
                    statusLab.hidden = YES;
                }
                backOutbtn.hidden = NO;
                
            }
            
            [statusLab sizeToFit];
            statusLab.frame = CGRectMake(WIDTH - 30*Proportion - statusLab.frame.size.width,
                                         bottomView.frame.size.height/2.0 - statusLab.frame.size.height/2.0,
                                         statusLab.frame.size.width,
                                         statusLab.frame.size.height);
            [bottomView addSubview:statusLab];
            
            if ([tempObj.isUserPublish intValue] == 1) {
                
                backOutbtn.hidden = YES;
                if ([tempObj.orderInfo.tradingStatus intValue] <= 1) {
                    bottomView.frame = CGRectZero;
                    self.goodsBgView.frame = CGRectMake(0,
                                                        CGRectGetMaxY(self.serveBgView.frame),
                                                        WIDTH,
                                                        (160*Proportion + 40*Proportion + 20 * Proportion)*self.obj.goodsOrderInfo.dataList.count);

                }
            }
        }
    }
}

- (void) loadTotalView{
    
    self.totalView = [[UIView alloc] init];
    self.totalView.backgroundColor = [UIColor CMLWhiteColor];
    [self addSubview:self.totalView];
    
    UIView *lineOne = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion, 30*Proportion, WIDTH - 30*Proportion*2, 1*Proportion)];
    lineOne.backgroundColor = [UIColor CMLSerachLineGrayColor];
    [self.totalView addSubview:lineOne];

    
    UILabel *numPromLab = [[UILabel alloc] init];
    numPromLab.font = KSystemBoldFontSize12;
    numPromLab.textColor = [UIColor CMLLineGrayColor];
    numPromLab.text = @"数量：";
    [numPromLab sizeToFit];
    numPromLab.frame = CGRectMake(30*Proportion,
                                  40*Proportion + 30*Proportion,
                                  numPromLab.frame.size.width,
                                  numPromLab.frame.size.height);
    [self.totalView addSubview:numPromLab];
    
    UILabel *numLab = [[UILabel alloc] init];
    numLab.font = KSystemBoldFontSize12;
    numLab.text = [NSString stringWithFormat:@"x %d",self.allNumber];
    numLab.textColor = [UIColor CMLLineGrayColor];
    [numLab sizeToFit];
    numLab.frame = CGRectMake(WIDTH - 30*Proportion - numLab.frame.size.width,
                              numPromLab.center.y - numLab.frame.size.height/2.0,
                              numLab.frame.size.width,
                              numLab.frame.size.height);
    [self.totalView addSubview:numLab];
    
    /***/
    UILabel *frePromLab = [[UILabel alloc] init];
    frePromLab.font = KSystemBoldFontSize12;
    frePromLab.textColor = [UIColor CMLLineGrayColor];
    frePromLab.text = @"运费：";
    [frePromLab sizeToFit];
    frePromLab.frame = CGRectMake(30*Proportion,
                                  CGRectGetMaxY(numPromLab.frame) + 20*Proportion,
                                  frePromLab.frame.size.width,
                                  frePromLab.frame.size.height);
    [self.totalView addSubview:frePromLab];
    
    UILabel *freLab = [[UILabel alloc] init];
    freLab.font = KSystemBoldFontSize12;
    freLab.text = [NSString stringWithFormat:@"¥%d",[self.obj.orderInfo.freightE2 intValue]/100];
    freLab.textColor = [UIColor CMLLineGrayColor];
    [freLab sizeToFit];
    freLab.frame = CGRectMake(WIDTH - 30*Proportion - freLab.frame.size.width,
                              frePromLab.center.y - freLab.frame.size.height/2.0,
                              freLab.frame.size.width,
                              freLab.frame.size.height);
    [self.totalView addSubview:freLab];
    
    /***/

    UILabel *pointsPromLab = [[UILabel alloc] init];
    pointsPromLab.font = KSystemBoldFontSize12;
    pointsPromLab.textColor = [UIColor CMLLineGrayColor];
    pointsPromLab.text = @"赠送积分：";
    [pointsPromLab sizeToFit];
    pointsPromLab.frame = CGRectMake(30*Proportion,
                                  CGRectGetMaxY(frePromLab.frame) + 20*Proportion,
                                  pointsPromLab.frame.size.width,
                                  pointsPromLab.frame.size.height);
    [self.totalView addSubview:pointsPromLab];
    
    UILabel *pointsLab = [[UILabel alloc] init];
    pointsLab.font = KSystemBoldFontSize12;
    pointsLab.text = [NSString stringWithFormat:@"%@",self.obj.orderInfo.point];
    pointsLab.textColor = [UIColor CMLLineGrayColor];
    [pointsLab sizeToFit];
    pointsLab.frame = CGRectMake(WIDTH - 30*Proportion - pointsLab.frame.size.width,
                              pointsPromLab.center.y - pointsLab.frame.size.height/2.0,
                              pointsLab.frame.size.width,
                              pointsLab.frame.size.height);
    [self.totalView addSubview:pointsLab];
    
    
    UILabel *deducPromLab;
    UILabel *deducLab;

    
    if (self.deducMoney) {
        
        if ([self.deducMoney intValue] > 0) {
            
            deducPromLab = [[UILabel alloc] init];
            deducPromLab.font = KSystemBoldFontSize12;
            deducPromLab.textColor = [UIColor CMLLineGrayColor];
            deducPromLab.text = @"抵扣金额：";
            [deducPromLab sizeToFit];
            deducPromLab.frame = CGRectMake(30*Proportion,
                                            CGRectGetMaxY(pointsPromLab.frame) + 20*Proportion,
                                            deducPromLab.frame.size.width,
                                            deducPromLab.frame.size.height);
            [self.totalView addSubview:deducPromLab];
            
            deducLab = [[UILabel alloc] init];
            deducLab.font = KSystemBoldFontSize12;
            deducLab.text = [NSString stringWithFormat:@"%0.2f",[self.deducMoney floatValue]/100];
            deducLab.textColor = [UIColor CMLLineGrayColor];
            [deducLab sizeToFit];
            deducLab.frame = CGRectMake(WIDTH - 30*Proportion - deducLab.frame.size.width,
                                        deducPromLab.center.y - deducLab.frame.size.height/2.0,
                                        deducLab.frame.size.width,
                                        deducLab.frame.size.height);
            [self.totalView addSubview:deducLab];
        }
    }

    
    /***/
    UIView *endView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               CGRectGetMaxY(pointsPromLab.frame) + 30*Proportion,
                                                               WIDTH,
                                                               80*Proportion)];
    endView.backgroundColor = [UIColor CMLWhiteColor];
    [self.totalView addSubview:endView];
    
    if ([self.deducMoney intValue] > 0) {
        
        endView.frame = CGRectMake(0,
                                   CGRectGetMaxY(deducPromLab.frame) + 30*Proportion,
                                   WIDTH,
                                   80*Proportion);
    }
    
    if ([self.isUserPush intValue] == 1) {
        
        pointsLab.hidden = YES;
        pointsPromLab.hidden = YES;
        deducPromLab.hidden = YES;
        deducLab.hidden = YES;
        
        endView.frame = CGRectMake(0,
                                   CGRectGetMaxY(frePromLab.frame) + 20*Proportion,
                                   WIDTH,
                                   80*Proportion);
    }

    UILabel *totalPromLab = [[UILabel alloc] init];
    totalPromLab.font = KSystemBoldFontSize14;
    totalPromLab.textColor = [UIColor CMLBlackColor];
    totalPromLab.text = @"支付总额：";
    [totalPromLab sizeToFit];
    totalPromLab.frame = CGRectMake(30*Proportion,
                                    80*Proportion/2.0 - totalPromLab.frame.size.height/2.0,
                                    totalPromLab.frame.size.width,
                                    totalPromLab.frame.size.height);
    [endView addSubview:totalPromLab];
    
    UILabel *totalLab = [[UILabel alloc] init];
    totalLab.font = KSystemBoldFontSize14;
    totalLab.text = [NSString stringWithFormat:@"¥%0.2f",[self.obj.orderInfo.payAmtE2 floatValue]/100];
    totalLab.textColor = [UIColor CMLBlackColor];
    [totalLab sizeToFit];
    totalLab.frame = CGRectMake(WIDTH - 30*Proportion - totalLab.frame.size.width,
                                totalPromLab.center.y - totalLab.frame.size.height/2.0,
                                totalLab.frame.size.width,
                                totalLab.frame.size.height);
    [endView addSubview:totalLab];
    
    UIView *lineTwo = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion, 0, WIDTH - 30*Proportion*2, 1*Proportion)];
    lineTwo.backgroundColor = [UIColor CMLSerachLineGrayColor];
    [endView addSubview:lineTwo];
    
    self.totalView.frame = CGRectMake(0,
                                      CGRectGetMaxY(self.goodsBgView.frame),
                                      WIDTH,
                                      CGRectGetMaxY(endView.frame));
    
}

- (void) enterServeVC:(UIButton *) btn{
    
    CMLServeOrderObj *tempObj = [CMLServeOrderObj getBaseObjFrom:self.obj.projectOrderInfo.dataList[btn.tag - 100]];
    
    if ([tempObj.isDeleted intValue] == 1) {
        
        if ([tempObj.isUserPublish intValue] == 1) {
            
            CMLUserPushServeDetailVC *vc = [[CMLUserPushServeDetailVC alloc] initWithObjId:tempObj.currentID];
            [[VCManger mainVC] pushVC:vc animate:YES];
            
        }else{
            
            ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:tempObj.currentID];
            [[VCManger mainVC] pushVC:vc animate:YES];
        }
    }
}

- (void) enterGoodsVC:(UIButton *) btn{
    
     CMLGoodsOrderObj *tempObj = [CMLGoodsOrderObj getBaseObjFrom:self.obj.goodsOrderInfo.dataList[btn.tag - 100]];
    if ([tempObj.isDeleted intValue] == 1) {
        
        if ([tempObj.isUserPublish intValue] == 1) {
            
            CMLUserPushGoodsVC *vc = [[CMLUserPushGoodsVC alloc] initWithObjId:tempObj.currentID];
            [[VCManger mainVC] pushVC:vc animate:YES];
            
        }else{
         
            CMLCommodityDetailMessageVC *vc = [[CMLCommodityDetailMessageVC alloc] initWithObjId:tempObj.currentID];
            [[VCManger mainVC] pushVC:vc animate:YES];
            
        }
    }
}

- (void) sevresAfterSales:(UIButton *) btn{
    
    CMLServeOrderObj *tempObj = [CMLServeOrderObj getBaseObjFrom:self.obj.projectOrderInfo.dataList[btn.tag]];
    
    if ([btn.titleLabel.text isEqualToString:@"退款"]) {

        CMLGoodsAfterSalesVC *vc = [[CMLGoodsAfterSalesVC alloc] initWith:@"退款"];
        vc.brandType = [NSNumber numberWithInt:3];
        vc.serveOrderObj = tempObj;
        [[VCManger mainVC] pushVC:vc animate:YES];

    }else if ([btn.titleLabel.text isEqualToString:@"售后"]){
    
        CMLGoodsAfterSalesVC *vc = [[CMLGoodsAfterSalesVC alloc] initWith:@"售后申请"];
        vc.brandType = [NSNumber numberWithInt:3];
        vc.serveOrderObj = tempObj;
        [[VCManger mainVC] pushVC:vc animate:YES];
    }

}

- (void) goodAfterSales:(UIButton *) btn{
    
    CMLGoodsOrderObj *tempObj = [CMLGoodsOrderObj getBaseObjFrom:self.obj.goodsOrderInfo.dataList[btn.tag]];
    
    if ([btn.titleLabel.text isEqualToString:@"退款"]) {
        
        CMLGoodsAfterSalesVC *vc = [[CMLGoodsAfterSalesVC alloc] initWith:@"退款"];
        vc.brandType = [NSNumber numberWithInt:7];
        vc.goodsOrderObj = tempObj;
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }else if ([btn.titleLabel.text isEqualToString:@"售后"]){
        
        CMLGoodsAfterSalesVC *vc = [[CMLGoodsAfterSalesVC alloc] initWith:@"售后申请"];
        vc.brandType = [NSNumber numberWithInt:7];
        vc.goodsOrderObj = tempObj;
        [[VCManger mainVC] pushVC:vc animate:YES];
    }
}
@end
