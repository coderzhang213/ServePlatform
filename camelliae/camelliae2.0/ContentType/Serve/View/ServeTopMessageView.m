//
//  ServeTopMessageView.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/26.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "ServeTopMessageView.h"
#import "BaseResultObj.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "CMLLine.h"
#import "InformationDefaultVC.h"
#import "VCManger.h"
#import "WebViewLinkVC.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"
#import "BrandModuleObj.h"
#import "CMLPicObjInfo.h"
#import "CMLPageControl.h"
#import "CMLCutDownView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "KrVideoPlayerController.h"
#import "CMLCommodityPayMessageVC.h"
#import "VCManger.h"
#import "BrandServeView.h"

#define ServeDefaultVCTitleLeftMargin                    40
#define ServeDefaultVCTitleTopMargin                     30
#define ServeDefaultVCAppointmentPriceBottomMargin       30
#define ServeDefaultVCPriceLeftMargin                    20
#define ServeDefaultVCBottomLineLeftMargin               20
#define ServeDefaultVCPriceBottomMargin                  40
#define ServeDefaultVCAttributeDianHeight                14
#define ServeDefaultVCAttributeLeftSpace                 20
#define ServeDefaultVCAttributeContentTopMargin          20
#define ServeDefaultVCBottomLineTopMargin                40
#define ServeDefaultVCReviewTypeAndNameSpace             30
#define ServeDefaultVCReviewRowHeight                    100



@interface ServeTopMessageView ()<UIScrollViewDelegate>

@property (nonatomic,copy) NSString *telePhoneNum;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) UIScrollView *imagesScrollView;

@property (nonatomic,strong) UILabel *pageLab;

@property (nonatomic,strong) CMLCutDownView *cutDownView;

@property (nonatomic,strong) UILabel *priceLabel;

@property (nonatomic,strong) UILabel *totalPriceLabel;

@property (nonatomic,strong) UIButton *videoBtn;

@property (nonatomic,strong) UIButton *imageBtn;

@property (nonatomic,assign) BOOL isHasVideo;

@property (nonatomic,assign) BOOL isVerb;

@property (nonatomic, strong) KrVideoPlayerController *videoController;

@property (nonatomic,strong) UIImageView *playImg;

@property (nonatomic,strong) UIButton *playBtn;

@property (nonatomic, strong) UILabel *linePriceLabel;

@property (nonatomic, strong) UILabel *memberPrice;

@end


@implementation ServeTopMessageView

- (instancetype)initWith:(BaseResultObj *)obj{

    self = [super init];
    
    if (self) {

        self.backgroundColor = [UIColor whiteColor];
        self.obj = obj;
        [self loadViewWith:obj];
    }
    return self;
}

- (void) loadViewWith:(BaseResultObj *) obj{
    
    if (obj.retData.videoUrl.length > 0 || [obj.retData.is_video_project intValue] == 1) {
        self.isHasVideo = YES;
    }
     PackDetailInfoObj *costObj = [PackDetailInfoObj getBaseObjFrom:[self.obj.retData.packageInfo.dataList firstObject]];
    
    if ([costObj.is_pre intValue] == 1) {
    
        self.isVerb = YES;
    }else{
        self.isVerb = NO;

    }

    
    UIView *messageBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     WIDTH,
                                                                     1000)];
    messageBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:messageBgView];
    /**image*/
    self.imagesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           WIDTH,
                                                                           500*Proportion)];
    self.imagesScrollView.backgroundColor = [UIColor CMLWhiteColor];
    self.imagesScrollView.delegate = self;
    self.imagesScrollView.pagingEnabled = YES;
    self.imagesScrollView.showsVerticalScrollIndicator = NO;
    self.imagesScrollView.showsHorizontalScrollIndicator = NO;
    self.imagesScrollView.contentSize = CGSizeMake(WIDTH*self.obj.retData.coverPicArr.count, 500*Proportion);
    [self addSubview:self.imagesScrollView];
    
    
    
    for (int i = 0; i < self.obj.retData.coverPicArr.count; i++) {
        
        UIImageView *moduleImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH*i,
                                                                                 0,
                                                                                 WIDTH,
                                                                                 500*Proportion)];
        moduleImage.clipsToBounds = YES;
        moduleImage.contentMode = UIViewContentModeScaleAspectFill;
        moduleImage.userInteractionEnabled = YES;
        moduleImage.backgroundColor = [UIColor CMLPromptGrayColor];
        moduleImage.tag = i;
        [self.imagesScrollView addSubview:moduleImage];
        CMLPicObjInfo *picObj = [CMLPicObjInfo getBaseObjFrom:self.obj.retData.coverPicArr[i]];
        [NetWorkTask setImageView:moduleImage WithURL:picObj.coverPic placeholderImage:nil];
        
        if (self.isHasVideo) {
            
            if (i == 0) {
             
                self.playImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PrefectureImg]];
                [self.playImg sizeToFit];
                self.playImg.userInteractionEnabled = YES;
                self.playImg.frame = CGRectMake(0, 0, self.playImg.frame.size.width, self.playImg.frame.size.height);
                [moduleImage addSubview:self.playImg];
                self.playImg.center = moduleImage.center;
                
                self.playBtn = [[UIButton alloc] initWithFrame:self.playImg.bounds];
                self.playBtn.backgroundColor = [UIColor clearColor];
                [self.playImg addSubview:self.playBtn];
                [self.playBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    
    UIView *endLine = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               self.imagesScrollView.frame.size.height - 1*Proportion,
                                                               WIDTH,
                                                               1*Proportion)];
    endLine.backgroundColor = [UIColor CMLSerachLineGrayColor];
    [self.imagesScrollView addSubview: endLine];
    
    if (self.isHasVideo) {
     
        if (self.obj.retData.coverPicArr.count != 1) {
            
            self.videoBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2.0 - 20*Proportion/2.0 - 70*Proportion,
                                                                       CGRectGetMaxY(self.imagesScrollView.frame) - 20*Proportion - 40*Proportion,
                                                                       70*Proportion,
                                                                       40*Proportion)];
            self.videoBtn.titleLabel.font = KSystemBoldFontSize10;
            [self.videoBtn setTitle:@"视频" forState:UIControlStateNormal];
            [self.videoBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateSelected];
            [self.videoBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
            [self.videoBtn setBackgroundColor:[UIColor CMLWhiteColor]];
            self.videoBtn.layer.cornerRadius = 40*Proportion/2.0;
            self.videoBtn.selected = YES;
            [self addSubview:self.videoBtn];
            [self.videoBtn addTarget:self action:@selector(showVideoImage) forControlEvents:UIControlEventTouchUpInside];
            
            self.imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.videoBtn.frame) + 20*Proportion,
                                                                       CGRectGetMaxY(self.imagesScrollView.frame) - 20*Proportion - 40*Proportion,
                                                                       70*Proportion,
                                                                       40*Proportion)];
            self.imageBtn.titleLabel.font = KSystemBoldFontSize10;
            [self.imageBtn setTitle:@"图片" forState:UIControlStateNormal];
            [self.imageBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateSelected];
            [self.imageBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
            [self.imageBtn setBackgroundColor:[[UIColor CMLBlackColor] colorWithAlphaComponent:0.5]];
            self.imageBtn.layer.cornerRadius = 40*Proportion/2.0;
            [self addSubview:self.imageBtn];
            [self.imageBtn addTarget:self action:@selector(showImage) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
    
    /*服务返利*/
    UILabel *rebateLabel = [[UILabel alloc] init];
    rebateLabel.backgroundColor = [[UIColor CMLDarkOrangeColor] colorWithAlphaComponent:0.8f];
    rebateLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    rebateLabel.textColor = [UIColor CMLWhiteColor];
    rebateLabel.layer.cornerRadius = 24 * Proportion;
    rebateLabel.clipsToBounds = YES;
    rebateLabel.text = [NSString stringWithFormat:@"    分享返￥%@", self.obj.retData.rebateMoney];
    rebateLabel.textAlignment = NSTextAlignmentLeft;
    rebateLabel.hidden = YES;
    [rebateLabel sizeToFit];
    rebateLabel.frame = CGRectMake(WIDTH - CGRectGetWidth(rebateLabel.frame) - 24 * Proportion,
                                   130 * Proportion + StatusBarHeight,
                                   CGRectGetWidth(rebateLabel.frame) + 24 * Proportion * 3,
                                   48 * Proportion);
    [self addSubview:rebateLabel];
    if (self.obj.retData.isEnjoyRebate.length > 0) {
        if ([self.obj.retData.isEnjoyRebate intValue] == 1) {
            if ([self.obj.retData.rebateNum floatValue] != 0) {
                rebateLabel.hidden = NO;
            }else {
                rebateLabel.hidden = YES;
            }
            
        }else {
            rebateLabel.hidden = YES;
        }
    }
    
    
    self.pageLab = [[UILabel alloc] init];
    self.pageLab.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)self.obj.retData.coverPicArr.count];
    self.pageLab.font = KSystemFontSize13;
    self.pageLab.textColor = [UIColor CMLBlackColor];
    self.pageLab.backgroundColor = [UIColor clearColor];
    [self.pageLab sizeToFit];
    self.pageLab.frame = CGRectMake(WIDTH - 30*Proportion - self.pageLab.frame.size.width,
                                    CGRectGetMaxY(self.imagesScrollView.frame) - 28*Proportion - self.pageLab.frame.size.height,
                                    self.pageLab.frame.size.width,
                                    self.pageLab.frame.size.height);
    [self addSubview:self.pageLab];
    
    self.cutDownView = [[CMLCutDownView alloc] initWithTime:costObj.pre_end_time];
    [self addSubview:self.cutDownView];
    __weak typeof(self) weakSelf = self;
    self.cutDownView.timeOver = ^{
      
        [weakSelf performSelector:@selector(refershServeView) withObject:nil afterDelay:0.3f];
    };
    

    if (self.isVerb) {
     
        self.cutDownView.frame = CGRectMake(0,
                                            CGRectGetMaxY(self.imagesScrollView.frame),
                                            WIDTH,
                                            self.cutDownView.viewHeight);
        [self.cutDownView startTimer];
    }else{
        
        self.cutDownView.frame = CGRectMake(0,
                                            CGRectGetMaxY(self.imagesScrollView.frame),
                                            WIDTH,
                                            0);
        self.cutDownView.hidden = YES;
        
    }
    
    /**name*/
    UILabel *nameLbale = [[UILabel alloc] init];
    nameLbale.font = KSystemBoldFontSize16;
    nameLbale.textColor = [UIColor CMLUserBlackColor];
    nameLbale.text = obj.retData.title;
    nameLbale.numberOfLines = 0;
    nameLbale.textAlignment = NSTextAlignmentCenter;
    CGRect nameRect = [nameLbale.text boundingRectWithSize:CGSizeMake(WIDTH - 2*ServeDefaultVCTitleLeftMargin*Proportion, 1000)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:KSystemBoldFontSize17} context:nil];
    nameLbale.frame = CGRectMake(ServeDefaultVCTitleLeftMargin*Proportion,
                                 25*Proportion + CGRectGetMaxY(self.imagesScrollView.frame),
                                 WIDTH - 2*ServeDefaultVCTitleLeftMargin*Proportion,
                                 nameRect.size.height);
    [messageBgView addSubview:nameLbale];
    
    CGFloat tempHeight = 0.0f;
    
    if ([costObj.payMode intValue] == 1) {
    
        UILabel *serveCostLab = [[UILabel alloc] init];
        serveCostLab.textColor = [UIColor CMLUserBlackColor];
        if (costObj.subscription) {
            serveCostLab.text = [NSString stringWithFormat:@"¥%@",costObj.subscription];
        }else {
            serveCostLab.text = @" ";
        }
        
        NSMutableAttributedString *tempStr = [[NSMutableAttributedString alloc] initWithString:serveCostLab.text];
        [tempStr addAttribute:NSFontAttributeName value:KSystemFontSize12 range:NSMakeRange(0, 1)];
        [tempStr addAttribute:NSFontAttributeName value:KSystemRealBoldFontSize21 range:NSMakeRange(1, serveCostLab.text.length - 1)];
        serveCostLab.attributedText = tempStr;
        [serveCostLab sizeToFit];
        serveCostLab.frame = CGRectMake(WIDTH/2.0 - serveCostLab.frame.size.width/2.0,
                                        CGRectGetMaxY(nameLbale.frame) + 30*Proportion,
                                        serveCostLab.frame.size.width,
                                        serveCostLab.frame.size.height);
        [messageBgView addSubview:serveCostLab];
        
        UIImageView *depositImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ServeDepositImg]];
        [depositImg sizeToFit];
        depositImg.backgroundColor = [UIColor CMLWhiteColor];
        depositImg.contentMode = UIViewContentModeScaleAspectFill;
        depositImg.clipsToBounds = YES;
        depositImg.frame = CGRectMake(WIDTH/2.0 -  depositImg.frame.size.width/2.0,
                                      CGRectGetMaxY(serveCostLab.frame) + 7*Proportion,
                                      depositImg.frame.size.width,
                                      depositImg.frame.size.height);
        [messageBgView addSubview:depositImg];
        
        
        if ([costObj.totalAmount intValue] > 0 || costObj.totalAmountStr.length > 0 ) {
            
            /**price*/
            NSDictionary *tempDic = (NSDictionary *)[self.obj.retData.packageInfo.dataList firstObject];
            NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",[tempDic objectForKey:@"totalAmount"]]];
            if (costObj.rangeTotalAmount.length > 0) {
                
                priceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",costObj.rangeTotalAmount]];
            }else{
                
                priceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",costObj.totalAmount]];
                
            }
            self.totalPriceLabel = [[UILabel alloc] init];
            self.totalPriceLabel.textColor = [UIColor CMLPromptGrayColor];
            self.totalPriceLabel.font = KSystemFontSize11;
            self.totalPriceLabel.attributedText = priceStr;
            [self.totalPriceLabel sizeToFit];
            self.totalPriceLabel.frame = CGRectMake(WIDTH/2.0 - self.totalPriceLabel.frame.size.width/2.0,
                                                    23*Proportion + CGRectGetMaxY(depositImg.frame),
                                                    self.totalPriceLabel.frame.size.width,
                                                    self.totalPriceLabel.frame.size.height);
            [messageBgView addSubview:self.totalPriceLabel];
            
            UIImageView *fullAmountImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ServeFullAmountImg]];
            [fullAmountImg sizeToFit];
            fullAmountImg.backgroundColor = [UIColor CMLWhiteColor];
            fullAmountImg.contentMode = UIViewContentModeScaleAspectFill;
            fullAmountImg.clipsToBounds = YES;
            fullAmountImg.frame = CGRectMake(WIDTH/2.0 -  fullAmountImg.frame.size.width/2.0,
                                             CGRectGetMaxY(self.totalPriceLabel.frame) + 4*Proportion,
                                             fullAmountImg.frame.size.width,
                                             fullAmountImg.frame.size.height);
            [messageBgView addSubview:fullAmountImg];
            
            tempHeight = CGRectGetMaxY(fullAmountImg.frame);
            
        }else{
            
            tempHeight = CGRectGetMaxY(depositImg.frame);
            
        }

        
    }else{
        
        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.textColor = [UIColor CMLUserBlackColor];
        self.priceLabel.font = KSystemRealBoldFontSize21;
        if (costObj.totalAmount) {
            self.priceLabel.text = [NSString stringWithFormat:@"¥%@",costObj.totalAmount];
        }else {
            self.priceLabel.text = @" ";
        }
        
        [self.priceLabel sizeToFit];
        self.priceLabel.frame = CGRectMake(WIDTH/2.0 - self.priceLabel.frame.size.width/2.0,
                                           CGRectGetMaxY(nameLbale.frame) + 30*Proportion,
                                           self.priceLabel.frame.size.width,
                                           self.priceLabel.frame.size.height);
        [messageBgView addSubview:self.priceLabel];
        
        if (self.isVerb) {
           
            self.totalPriceLabel = [[UILabel alloc] init];
            self.totalPriceLabel.textColor = [UIColor CMLLineGrayColor];
            self.totalPriceLabel.font = KSystemFontSize11;
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",costObj.pre_totalAmount]];
            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, attri.length)];
            
            [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor CMLLineGrayColor] range:NSMakeRange(0, attri.length)];

            self.totalPriceLabel.attributedText = attri;
            [self.totalPriceLabel sizeToFit];
            self.totalPriceLabel.frame = CGRectMake(WIDTH/2.0 - self.totalPriceLabel.frame.size.width/2.0,
                                                    20*Proportion + CGRectGetMaxY(self.priceLabel.frame),
                                                    self.totalPriceLabel.frame.size.width,
                                                    self.totalPriceLabel.frame.size.height);
            [messageBgView addSubview:self.totalPriceLabel];
            tempHeight = CGRectGetMaxY(self.totalPriceLabel.frame);
            
        }else{
            /*显示折扣价*/
            if ([self.obj.retData.is_discount intValue] == 1) {
                if ([costObj.discount intValue] != 0) {
                    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",costObj.discount];
                    [self.priceLabel sizeToFit];
                    self.priceLabel.frame = CGRectMake(WIDTH/2.0 - self.priceLabel.frame.size.width/2.0,
                                                       CGRectGetMaxY(nameLbale.frame) + 30*Proportion,
                                                       self.priceLabel.frame.size.width,
                                                       self.priceLabel.frame.size.height);
                    /*划线价*/
                    self.linePriceLabel = [[UILabel alloc] init];
                    self.linePriceLabel.text = [NSString stringWithFormat:@"￥%@",self.obj.retData.totalAmountMin];
                    self.linePriceLabel.font = KSystemFontSize12;
                    self.linePriceLabel.textColor = [UIColor CMLPromptGrayColor];
                    NSAttributedString *attstring = [[NSAttributedString alloc] initWithString:self.linePriceLabel.text attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid)}];
                    self.linePriceLabel.attributedText = attstring;
                    [self.linePriceLabel sizeToFit];
                    self.linePriceLabel.frame = CGRectMake(WIDTH/2.0 - self.linePriceLabel.frame.size.width/2.0,
                                                           CGRectGetMaxY(self.priceLabel.frame) + 0*Proportion,
                                                           self.linePriceLabel.frame.size.width,
                                                           self.linePriceLabel.frame.size.height);
                    [self addSubview:self.linePriceLabel];
                    
                    /*会员价标*/
                    self.memberPrice = [[UILabel alloc] init];
                    self.memberPrice.backgroundColor = [UIColor CMLNewLineGrayColor];
                    self.memberPrice.text = @"会员价";
                    self.memberPrice.textAlignment = NSTextAlignmentCenter;
                    self.memberPrice.font = KSystemFontSize10;
                    self.memberPrice.textColor = [UIColor CMLWhiteColor];
                    [self.memberPrice sizeToFit];
                    self.memberPrice.frame = CGRectMake(CGRectGetMaxX(self.priceLabel.frame) + 10 * Proportion,
                                                        CGRectGetMidY(self.priceLabel.frame) - 30*Proportion/2,
                                                        72 * Proportion,
                                                        30 * Proportion);
                    [self addSubview:self.memberPrice];
                    tempHeight = CGRectGetMaxY(self.linePriceLabel.frame);
                }
            }else {
                tempHeight = CGRectGetMaxY(self.priceLabel.frame);
            }
            
        }
    }
    
    /*商品下单返利*/
    UILabel *orderRebateLabel = [[UILabel alloc] init];
    orderRebateLabel.backgroundColor = [[UIColor CMLDarkOrangeColor] colorWithAlphaComponent:0.8f];
    orderRebateLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    orderRebateLabel.textColor = [UIColor CMLWhiteColor];
    orderRebateLabel.layer.cornerRadius = 24 * Proportion;
    orderRebateLabel.clipsToBounds = YES;
    orderRebateLabel.text = [NSString stringWithFormat:@"    下单返￥%@", self.obj.retData.orderRebateMoney];
    orderRebateLabel.textAlignment = NSTextAlignmentLeft;
    orderRebateLabel.hidden = YES;
    [orderRebateLabel sizeToFit];
    orderRebateLabel.frame = CGRectMake(WIDTH - CGRectGetWidth(orderRebateLabel.frame) - 24 * Proportion,
                                        CGRectGetMidY(self.priceLabel.frame) - 48 * Proportion/2,
                                        CGRectGetWidth(orderRebateLabel.frame) + 24 * Proportion * 3,
                                        48 * Proportion);
    [self addSubview:orderRebateLabel];
    
    if ([self.obj.retData.isEnjoyOrderRebate intValue] == 1) {
        if ([self.obj.retData.orderRebateMoney floatValue] != 0) {
            orderRebateLabel.hidden = NO;
        }else {
            orderRebateLabel.hidden = YES;
        }
    }else {
        orderRebateLabel.hidden = YES;
    }
    
    UIImageView *spaceView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                           tempHeight,
                                                                           WIDTH,
                                                                           40*Proportion)];
    
    spaceView.image = [UIImage imageNamed:MailShaDowImg];
    [messageBgView addSubview:spaceView];
    
    /*详情可领取优惠券*/
    if (self.obj.retData.couponsInfo) {
        
        UIView *discountCouponView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                              tempHeight + 40 * Proportion,
                                                                              WIDTH,
                                                                              64 * Proportion)];
        discountCouponView.backgroundColor = [UIColor CMLWhiteColor];
        [self addSubview:discountCouponView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"优惠";
        titleLabel.font = KSystemBoldFontSize15;
        titleLabel.textColor = [UIColor CMLUserBlackColor];
        [titleLabel sizeToFit];
        titleLabel.frame = CGRectMake(40 * Proportion,
                                      CGRectGetHeight(discountCouponView.frame)/2.0 - titleLabel.frame.size.height/2.0,
                                      titleLabel.frame.size.width,
                                      titleLabel.frame.size.height);
        [discountCouponView addSubview:titleLabel];
        
        UILabel *disCouponLabel = [[UILabel alloc] init];
        disCouponLabel.backgroundColor = [UIColor clearColor];
        disCouponLabel.text = self.obj.retData.couponsName;
        disCouponLabel.font = KSystemFontSize15;
        disCouponLabel.textColor = [UIColor CMLYellowD9AB5EColor];
        [disCouponLabel sizeToFit];
        disCouponLabel.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame) + 20 * Proportion,
                                          CGRectGetMidY(titleLabel.frame) - CGRectGetHeight(disCouponLabel.frame)/2.0,
                                          CGRectGetWidth(disCouponLabel.frame),
                                          CGRectGetHeight(disCouponLabel.frame));
        [discountCouponView addSubview:disCouponLabel];
        
        UIButton *enterButton = [[UIButton alloc] init];
        enterButton.backgroundColor = [UIColor clearColor];
        [enterButton setImage:[UIImage imageNamed:CMLEnterDiscountCouponIcon] forState:UIControlStateNormal];
        [enterButton sizeToFit];
        enterButton.frame = CGRectMake(WIDTH - CGRectGetWidth(enterButton.frame) - 20 * Proportion,
                                       CGRectGetMidY(titleLabel.frame) - CGRectGetHeight(enterButton.frame)/2.0,
                                       CGRectGetWidth(enterButton.frame),
                                       CGRectGetHeight(enterButton.frame));
        [discountCouponView addSubview:enterButton];
        tempHeight = CGRectGetMaxY(discountCouponView.frame);
        
        UIImageView *spaceView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                               tempHeight - 20 * Proportion,
                                                                               WIDTH,
                                                                               40*Proportion)];
        
        spaceView.backgroundColor = [UIColor clearColor];
        spaceView.image = [UIImage imageNamed:MailShaDowImg];
        [self addSubview:spaceView];
        [self bringSubviewToFront:discountCouponView];
        
        UIButton *couponBtn = [[UIButton alloc] initWithFrame:discountCouponView.bounds];
        couponBtn.backgroundColor = [UIColor clearColor];
        [discountCouponView addSubview:couponBtn];
        [couponBtn addTarget:self action:@selector(discountCouponClicked) forControlEvents:UIControlEventTouchUpInside];
        
        tempHeight = CGRectGetMinY(spaceView.frame);
    }
    
    /**time*/
    UIView *timeBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  tempHeight + 40*Proportion,
                                                                  WIDTH,
                                                                  100*Proportion)];
    timeBgView.backgroundColor = [UIColor CMLWhiteColor];
    [messageBgView addSubview:timeBgView];
    
    UILabel *timePromLab = [[UILabel alloc] init];
    timePromLab.font = KSystemBoldFontSize13;
    timePromLab.textColor = [UIColor CMLUserBlackColor];
    timePromLab.backgroundColor = [UIColor clearColor];
    timePromLab.text = @"时间：";
    [timePromLab sizeToFit];
    timePromLab.frame = CGRectMake(50*Proportion,
                                   timeBgView.frame.size.height/2.0 - timePromLab.frame.size.height/2.0,
                                   timePromLab.frame.size.width,
                                   timePromLab.frame.size.height);
    [timeBgView addSubview:timePromLab];
    
    
    UILabel *attributeTimeLabel = [[UILabel alloc] init];
    attributeTimeLabel.font = KSystemFontSize13;
    attributeTimeLabel.textColor = [UIColor CMLUserBlackColor];
    attributeTimeLabel.backgroundColor = [UIColor clearColor];
    attributeTimeLabel.text = [NSString stringWithFormat:@"%@",obj.retData.projectDateZone];
    [attributeTimeLabel sizeToFit];
    attributeTimeLabel.frame = CGRectMake(WIDTH - 50*Proportion - attributeTimeLabel.frame.size.width,
                                          timeBgView.frame.size.height/2.0 - attributeTimeLabel.frame.size.height/2.0,
                                          attributeTimeLabel.frame.size.width,
                                          attributeTimeLabel.frame.size.height);
    [timeBgView addSubview:attributeTimeLabel];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(50*Proportion,
                                                                timeBgView.frame.size.height - 1*Proportion,
                                                                WIDTH - 50*Proportion*2,
                                                                1*Proportion)];
    lineView1.backgroundColor = [UIColor CMLPromptGrayColor];
    [timeBgView addSubview:lineView1];
    
    UIView *addressBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     CGRectGetMaxY(timeBgView.frame),
                                                                     WIDTH,
                                                                     100*Proportion)];
    addressBgView.backgroundColor = [UIColor CMLWhiteColor];
    [messageBgView addSubview:addressBgView];
    
    
    UILabel *addressPromLab = [[UILabel alloc] init];
    addressPromLab.font = KSystemBoldFontSize13;
    timePromLab.textColor = [UIColor CMLUserBlackColor];
    addressPromLab.backgroundColor = [UIColor clearColor];
    addressPromLab.text = @"地点：";
    [addressPromLab sizeToFit];
    addressPromLab.frame = CGRectMake(50*Proportion,
                                   addressBgView.frame.size.height/2.0 - addressPromLab.frame.size.height/2.0,
                                   addressPromLab.frame.size.width,
                                   addressPromLab.frame.size.height);
    [addressBgView addSubview:addressPromLab];
    
    
    /**place*/
    UILabel *attributePlaceLabel = [[UILabel alloc] init];
    attributePlaceLabel.font = KSystemFontSize13;
    attributePlaceLabel.textColor = [UIColor CMLUserBlackColor];
    attributePlaceLabel.backgroundColor = [UIColor clearColor];
    attributePlaceLabel.text = [NSString stringWithFormat:@"%@",obj.retData.projectAddress];
    attributePlaceLabel.numberOfLines = 0;
    attributePlaceLabel.textAlignment = NSTextAlignmentRight;
    CGRect placeRect = [attributePlaceLabel.text boundingRectWithSize:CGSizeMake(WIDTH - 50*Proportion - CGRectGetMaxX(addressPromLab.frame) - 20*Proportion, 1000)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:KSystemFontSize13}
                                                              context:nil];
    attributePlaceLabel.frame = CGRectMake(CGRectGetMaxX(addressPromLab.frame) + 20*Proportion,
                                           addressBgView.frame.size.height/2.0 - placeRect.size.height/2.0,
                                           WIDTH - 50*Proportion - CGRectGetMaxX(addressPromLab.frame) - 20*Proportion,
                                           placeRect.size.height);
    [addressBgView addSubview:attributePlaceLabel];
    

    UIButton *enterMapBtn = [[UIButton alloc] init];
    enterMapBtn.backgroundColor = [UIColor clearColor];
    [enterMapBtn sizeToFit];
    enterMapBtn.frame = addressBgView.bounds;
    [addressBgView addSubview:enterMapBtn];
    [enterMapBtn addTarget:self action:@selector(enterBDMap) forControlEvents:UIControlEventTouchUpInside];
    
    /**type*/

    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(50*Proportion,
                                                                addressBgView.frame.size.height - 1*Proportion,
                                                                WIDTH - 50*Proportion*2,
                                                                1*Proportion)];
    lineView.backgroundColor = [UIColor CMLPromptGrayColor];
    [addressBgView addSubview:lineView];
    
    
    /*售后保障等*/
    UIImageView *serveProtect = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ServeProtctImg]];
    serveProtect.contentMode = UIViewContentModeScaleAspectFill;
    serveProtect.userInteractionEnabled = YES;
    [serveProtect sizeToFit];
    CGFloat newHeight = serveProtect.frame.size.height/serveProtect.frame.size.width*WIDTH;
    serveProtect.frame = CGRectMake(0,
                                    CGRectGetMaxY(addressBgView.frame),
                                    WIDTH,
                                    newHeight);
    [messageBgView addSubview:serveProtect];
    
    UIButton *showServeProtectBtn = [[UIButton alloc] initWithFrame:serveProtect.bounds];
    showServeProtectBtn.backgroundColor = [UIColor clearColor];
    [serveProtect addSubview:showServeProtectBtn];
    [showServeProtectBtn addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];

    messageBgView.frame = CGRectMake(0,
                                     0,
                                     WIDTH,
                                     CGRectGetMaxY(serveProtect.frame));
    

    self.currentHeight = messageBgView.frame.size.height;
    
}


- (void) enterReviewVC{
    
    if ([self.obj.retData.reviewType intValue] == 1) {
        InformationDefaultVC *vc = [[InformationDefaultVC alloc] initWithObjId:self.obj.retData.reviewObj];
        [[VCManger mainVC] pushVC:vc animate:YES];
    }else{
        
        WebViewLinkVC *vc = [[WebViewLinkVC alloc] init];
        vc.url = self.obj.retData.reviewObj;
        [[VCManger mainVC] pushVC:vc animate:YES];
    }
}

- (void) enterBDMap{
    

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        
        NSString *str1 = [self.obj.retData.projectAddress stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSString *stringURL =[NSString stringWithFormat:@"baidumap://map/geocoder?address=%@",str1];
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];
        
    }else{
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"抱歉，请您先下载百度地图"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
        [alterView show];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (self.imagesScrollView) {
        
        self.pageLab.text = [NSString stringWithFormat:@"%d/%ld",(int)self.imagesScrollView.contentOffset.x/(int)WIDTH + 1,self.obj.retData.coverPicArr.count];
        [self.pageLab sizeToFit];
        self.pageLab.frame = CGRectMake(WIDTH - 30*Proportion - self.pageLab.frame.size.width,
                                        CGRectGetMaxY(self.imagesScrollView.frame) - 28*Proportion - self.pageLab.frame.size.height,
                                        self.pageLab.frame.size.width,
                                        self.pageLab.frame.size.height);
        
        if (self.isHasVideo) {
            
            if ((int)self.imagesScrollView.contentOffset.x/(int)WIDTH + 1 == 1) {
                
                self.videoBtn.selected = YES;
                self.videoBtn.backgroundColor = [UIColor CMLWhiteColor];
                self.imageBtn.selected = NO;
                self.imageBtn.backgroundColor = [[UIColor CMLBlackColor] colorWithAlphaComponent:0.5];
                
                
            }else{
                
                if (!self.imageBtn.selected) {
                    
                    self.imageBtn.selected = YES;
                    self.imageBtn.backgroundColor = [UIColor CMLWhiteColor];
                    self.videoBtn.selected = NO;
                    self.videoBtn.backgroundColor = [[UIColor CMLBlackColor] colorWithAlphaComponent:0.5];
                    
                }
            }
        }
    }
}



- (void) showVideoImage{
    
    if (!self.videoBtn.selected) {
        
        self.videoBtn.selected = YES;
        self.videoBtn.backgroundColor = [UIColor CMLWhiteColor];
        self.imageBtn.selected = NO;
        self.imageBtn.backgroundColor = [[UIColor CMLBlackColor] colorWithAlphaComponent:0.5];
        [self.imagesScrollView setContentOffset:CGPointMake(0, 0)];
        self.pageLab.text = [NSString stringWithFormat:@"1/%ld",self.obj.retData.coverPicArr.count];
        [self.pageLab sizeToFit];
        self.pageLab.frame = CGRectMake(WIDTH - 30*Proportion - self.pageLab.frame.size.width,
                                        CGRectGetMaxY(self.imagesScrollView.frame) - 28*Proportion - self.pageLab.frame.size.height,
                                        self.pageLab.frame.size.width,
                                        self.pageLab.frame.size.height);
    }
    
}

- (void) showImage{
    
    if (!self.imageBtn.selected) {
        
        self.imageBtn.selected = YES;
        self.imageBtn.backgroundColor = [UIColor CMLWhiteColor];
        self.videoBtn.selected = NO;
        self.videoBtn.backgroundColor = [[UIColor CMLBlackColor] colorWithAlphaComponent:0.5];
        [self.imagesScrollView setContentOffset:CGPointMake(WIDTH, 0)];
        self.pageLab.text = [NSString stringWithFormat:@"2/%ld",self.obj.retData.coverPicArr.count];
        [self.pageLab sizeToFit];
        self.pageLab.frame = CGRectMake(WIDTH - 30*Proportion - self.pageLab.frame.size.width,
                                        CGRectGetMaxY(self.imagesScrollView.frame) - 28*Proportion - self.pageLab.frame.size.height,
                                        self.pageLab.frame.size.width,
                                        self.pageLab.frame.size.height);

        
    }
}

- (void) playVideo{
    
    self.imagesScrollView.hidden = YES;
    
    if ([self.obj.retData.all_video_url_suffix intValue] == 0) {
        
        self.imagesScrollView.hidden = NO;
        self.playBtn.hidden = YES;
        self.playImg.hidden = YES;
        
    }

    if ([self.obj.retData.is_video_project intValue] == 1) {
      
        [self openmovie:self.obj.retData.all_video_url];
        
    }else{
        
        [self openmovie:self.obj.retData.videoUrl];
    }
}

#pragma mark - video

-(void)openmovie:(NSString*) url{
    
    if (!self.videoController) {
        
    
 
            if ([self.obj.retData.all_video_url_suffix intValue] == 1) {
                
                self.videoController = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(0,
                                                                                                 0,
                                                                                                 WIDTH,
                                                                                                 500*Proportion)];
            }else{
                
                self.videoController = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(0,
                                                                                                 500*Proportion - 40,
                                                                                                 WIDTH,
                                                                                                 40)];
                self.videoController.videoControl.bottomBar.backgroundColor = [UIColor CMLBlackColor];
                
            }
      

            if ([self.obj.retData.all_video_url_suffix intValue] == 0) {
                
                self.videoController.videoControl.topBar.hidden = YES;
                 self.videoController.videoControl.fullScreenButton.hidden = YES;
            }else{
                
                self.videoController.videoControl.topBar.hidden = NO;
                self.videoController.videoControl.fullScreenButton.hidden = NO;
            }
       
        
        __weak typeof(self)weakSelf = self;
        self.videoController.view.backgroundColor = [UIColor whiteColor];
        
        [self.videoController setDimissCompleteAndBuyBlock:^{
          
            if ([self.obj.retData.is_video_project intValue] == 1 && [self.obj.retData.is_buy intValue] != 1 && [weakSelf.obj.retData.is_free intValue] == 0) {
                
                [weakSelf showBuyVideoView];
            }
        }];

        
        [self.videoController setDimissCompleteBlock:^{
            
  
            weakSelf.imagesScrollView.hidden = NO;
            weakSelf.videoController = nil;
            weakSelf.playBtn.hidden = NO;
            weakSelf.playImg.hidden = NO;
            
            

            
        }];
       
        if ([self.obj.retData.is_video_project intValue] == 1) {
            
            if ([self.obj.retData.is_free intValue] == 1) {
                
                self.videoController.videoShowTime = [NSNumber numberWithInt:0];
                
            }else{
                
                if ([self.obj.retData.is_buy intValue] == 1) {
                    
                    self.videoController.videoShowTime = [NSNumber numberWithInt:0];
                }else{
                    
                    self.videoController.videoShowTime = self.obj.retData.all_video_show_time;
                }

            }
            
        }else{
            

            self.videoController.videoShowTime = [NSNumber numberWithInt:0];
        }

        [self.videoController setWillBackOrientationPortrait:^{
            
        }];
        [self.videoController setWillChangeToFullscreenMode:^{
            
        }];
       
        if ([self.obj.retData.is_video_project integerValue] == 1) {
         
            if ([self.obj.retData.all_video_url_suffix intValue] == 0) {
                [self addSubview:self.videoController.view]; //video 显示在 window 便于控制
            }else{
                [self.videoController showInWindow];
                
            }
        }else{
            
            [self.videoController showInWindow];
        }
        self.videoController.contentURL = [NSURL URLWithString:url];
    
    }
}

- (void) refershServeView{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refershServeView" object:nil];
}

- (void) showBuyVideoView{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              0,
                                                              WIDTH,
                                                              600*Proportion)];
    bgView.backgroundColor = [UIColor CMLBlackColor];
    [[self.imagesScrollView viewWithTag:0] addSubview:bgView];
    
    UILabel *promLab = [[UILabel alloc] init];
    promLab.textColor = [UIColor CMLWhiteColor];
    promLab.font = KSystemFontSize12;
    if ([self.obj.retData.all_video_url_suffix intValue] == 0) {
      
        promLab.text = @"付费音频，收看完整版请付费购买哦";
        
    }else{
        
        promLab.text = @"付费视频，观看完整版请付费购买哦";
    }
    
    [promLab sizeToFit];
    promLab.frame = CGRectMake(WIDTH/2.0 - promLab.frame.size.width/2.0,
                               600*Proportion/2.0 - 20*Proportion - promLab.frame.size.height,
                               promLab.frame.size.width,
                               promLab.frame.size.height);
    [bgView addSubview:promLab];
    
    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2.0 - 160*Proportion/2.0,
                                                                  CGRectGetMaxY(promLab.frame) + 40*Proportion,
                                                                  100*Proportion + 60*Proportion,
                                                                  30*Proportion)];
    buyBtn.backgroundColor = [UIColor CMLWhiteColor];
    buyBtn.layer.cornerRadius = 30*Proportion/2.0;
    [bgView addSubview:buyBtn];
    [buyBtn setTitle:@"去购买" forState:UIControlStateNormal];
    buyBtn.titleLabel.font = KSystemFontSize12;
    [buyBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    [bgView addSubview:buyBtn];
    [buyBtn addTarget:self action:@selector(showBuyVideo) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) showBuyVideo{
    
    
    if ([self.obj.retData.sysOrderStatus intValue] == 1) {
        
        
        PackDetailInfoObj *obj = [PackDetailInfoObj getBaseObjFrom:[self.obj.retData.packageInfo.dataList firstObject]];
        
        if ([obj.surplusStock intValue] > 0) {

            CMLCommodityPayMessageVC *vc = [[CMLCommodityPayMessageVC alloc] init];
            vc.buyNum = 1;
            vc.obj = self.obj;
            vc.parentType = [NSNumber numberWithInt:3];
            [[VCManger mainVC] pushVC:vc animate:YES];
            
        }else{
            
            [self.delegate showErrorWith:@"库存不足"];
        
            
        }
        
        
    }else{
        
        [self.delegate showErrorWith:self.obj.retData.sysOrderStatusName];

        
    }
    

    
}

- (void) removeVideo{
    
    [self.videoController dismiss];
    self.videoController = nil;
}

- (void) show{
    
    BrandServeView *serveProjectView = [[BrandServeView alloc] init];
    [self.superview.superview addSubview:serveProjectView];
    [self.superview.superview bringSubviewToFront:serveProjectView];
}

- (void)discountCouponClicked {
    
    [self.delegate showCanGetCouponViewOfServeTopMessageViewWith:self.obj];
    
}

@end
