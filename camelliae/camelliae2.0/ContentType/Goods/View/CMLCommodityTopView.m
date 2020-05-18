//
//  CMLCommodityTopView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/4.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLCommodityTopView.h"
#import "BaseResultObj.h"
#import "UIColor+SDExspand.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NetWorkTask.h"
#import "CMLPicObjInfo.h"
#import "CMLPageControl.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"
#import "CommonImg.h"
#import "CMLCutDownView.h"
#import "VCManger.h"
#import "KrVideoPlayerController.h"
#import "BrandServeView.h"
#import "CMLCanGetCouponView.h"

#define CommodityDetailVCLeftMargin            20
#define CommodityDetailVCNumLabelBottomMargin  40

@interface CMLCommodityTopView()<UIScrollViewDelegate>

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) UIScrollView *imagesScrollView;

@property (nonatomic,strong) UILabel *pageLab;

@property (nonatomic,strong) CMLCutDownView *cutDownView;

@property (nonatomic,strong) UIButton *videoBtn;

@property (nonatomic,strong) UIButton *imageBtn;

@property (nonatomic,assign) BOOL isHasVideo;

@property (nonatomic,assign) BOOL isVerb;

@property (nonatomic, strong) KrVideoPlayerController *videoController;

@property (nonatomic,strong) UILabel *priceLab;

@property (nonatomic,strong) UILabel *totalPriceLabel;

@property (nonatomic, strong) UILabel *linePriceLabel;

@property (nonatomic, strong) UILabel *memberPrice;

@end

@implementation CMLCommodityTopView

- (instancetype)initWith:(BaseResultObj *)obj{
    
    self = [super init];
    
    if (self) {
       
        self.obj = obj;
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    
    
    if (self.obj.retData.videoUrl.length > 0) {
        self.isHasVideo = YES;
        

    }
    
    if ([self.obj.retData.is_pre intValue] == 1) {
        
        self.isVerb = YES;
    }else{
        self.isVerb = NO;
    }
    
    
    self.imagesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           WIDTH,
                                                                           WIDTH)];
    self.imagesScrollView.backgroundColor = [UIColor CMLWhiteColor];
    self.imagesScrollView.delegate = self;
    self.imagesScrollView.pagingEnabled = YES;
    self.imagesScrollView.showsVerticalScrollIndicator = NO;
    self.imagesScrollView.showsHorizontalScrollIndicator = NO;
    self.imagesScrollView.contentSize = CGSizeMake(WIDTH*self.obj.retData.coverPicArr.count, WIDTH);
    [self addSubview:self.imagesScrollView];
    
    for (int i = 0; i < self.obj.retData.coverPicArr.count; i++) {
        
        UIImageView *moduleImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH*i,
                                                                                 0,
                                                                                 WIDTH,
                                                                                 WIDTH)];
        moduleImage.clipsToBounds = YES;
        moduleImage.userInteractionEnabled = YES;
        moduleImage.contentMode = UIViewContentModeScaleAspectFill;
        moduleImage.backgroundColor = [UIColor CMLPromptGrayColor];
        [self.imagesScrollView addSubview:moduleImage];
        CMLPicObjInfo *picObj = [CMLPicObjInfo getBaseObjFrom:self.obj.retData.coverPicArr[i]];
        [NetWorkTask setImageView:moduleImage WithURL:picObj.coverPic placeholderImage:nil];
        
        if (self.isHasVideo) {
            
            if (i == 0) {
                
                UIImageView *playImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PrefectureImg]];
                [playImg sizeToFit];
                playImg.userInteractionEnabled = YES;
                playImg.frame = CGRectMake(0, 0, playImg.frame.size.width, playImg.frame.size.height);
                [moduleImage addSubview:playImg];
                playImg.center = moduleImage.center;
                
                UIButton *playBtn = [[UIButton alloc] initWithFrame:playImg.bounds];
                playBtn.backgroundColor = [UIColor clearColor];
                [playImg addSubview:playBtn];
                [playBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
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

    /*分享返利*/
    UILabel *rebateLabel = [[UILabel alloc] init];
    rebateLabel.backgroundColor = [[UIColor CMLDarkOrangeColor] colorWithAlphaComponent:0.8f];
    rebateLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    rebateLabel.textColor = [UIColor CMLWhiteColor];
    rebateLabel.layer.cornerRadius = 24 * Proportion;
    rebateLabel.clipsToBounds = YES;
    rebateLabel.hidden = YES;
    rebateLabel.text = [NSString stringWithFormat:@"    分享返￥%@", self.obj.retData.rebateMoney];
    rebateLabel.textAlignment = NSTextAlignmentLeft;
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
    
    self.cutDownView = [[CMLCutDownView alloc] initWithTime:self.obj.retData.pre_end_time];
    [self addSubview:self.cutDownView];
    __weak typeof(self) weakSelf = self;
    self.cutDownView.timeOver = ^{
        
        [weakSelf performSelector:@selector(refershGoodsView) withObject:nil afterDelay:0.3f];
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

    
    
    UILabel *tagLab = [[UILabel alloc] init];
    tagLab.font = KSystemFontSize13;
    tagLab.textColor = [UIColor CMLLightBrownColor];
    tagLab.layer.borderColor = [UIColor CMLLightBrownColor].CGColor;
    tagLab.layer.borderWidth = 1*Proportion;
    tagLab.text = [NSString stringWithFormat:@"%@",self.obj.retData.brandName];
    if (self.obj.retData.brandName.length > 0) {
        tagLab.hidden = NO;
    }else {
        tagLab.hidden = YES;
    }
    tagLab.textAlignment = NSTextAlignmentCenter;
    [tagLab sizeToFit];
    tagLab.frame = CGRectMake(CommodityDetailVCLeftMargin*Proportion,
                              CGRectGetMaxY(self.cutDownView.frame) + 12*Proportion,
                              tagLab.frame.size.width + 20*Proportion,
                              tagLab.frame.size.height + 10*Proportion);
    [self addSubview:tagLab];
    
    UILabel *tagLab2 = [[UILabel alloc] init];
    tagLab2.font = KSystemFontSize13;
    tagLab2.textColor = [UIColor CMLLightBrownColor];
    tagLab2.layer.borderWidth = 1*Proportion;
    tagLab2.layer.borderColor = [UIColor CMLLightBrownColor].CGColor;
    tagLab2.text = @"单品";
    tagLab2.textAlignment = NSTextAlignmentCenter;
    [tagLab2 sizeToFit];
    tagLab2.frame = CGRectMake(CommodityDetailVCLeftMargin*Proportion,
                               CGRectGetMaxY(self.cutDownView.frame) + 12*Proportion,
                               tagLab2.frame.size.width + 20*Proportion,
                               tagLab2.frame.size.height + 10*Proportion);
    [self addSubview:tagLab2];
    
    tagLab.frame = CGRectMake(WIDTH/2.0 - (tagLab2.frame.size.width + tagLab.frame.size.width +20*Proportion)/2.0,
                              CGRectGetMaxY(self.cutDownView.frame) + 12*Proportion,
                              tagLab.frame.size.width,
                              tagLab.frame.size.height);
    tagLab2.frame = CGRectMake(CGRectGetMaxX(tagLab.frame) + 20*Proportion,
                               CGRectGetMaxY(self.cutDownView.frame) + 12*Proportion,
                               tagLab2.frame.size.width,
                               tagLab2.frame.size.height);
    

    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = KSystemBoldFontSize15;
    nameLabel.textColor = [UIColor CMLUserBlackColor];
    nameLabel.text = self.obj.retData.title;
    nameLabel .numberOfLines = 0;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    CGRect nameRect = [nameLabel.text boundingRectWithSize:CGSizeMake(WIDTH - 2*CommodityDetailVCLeftMargin*Proportion ,1000)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:KSystemBoldFontSize15}
                                                   context:nil];
    nameLabel.frame = CGRectMake(CommodityDetailVCLeftMargin*Proportion,
                                 20*Proportion + CGRectGetMaxY(tagLab2.frame),
                                 WIDTH - 2*CommodityDetailVCLeftMargin*Proportion,
                                 nameRect.size.height);
    [self addSubview:nameLabel];
    
    CGFloat currentNameY = CGRectGetMaxY(nameLabel.frame);
    
    /*是否存在订金*/
    if ([self.obj.retData.is_deposit intValue] == 1) {
        
        UILabel *serveCostLab = [[UILabel alloc] init];
        serveCostLab.textColor = [UIColor CMLUserBlackColor];
        serveCostLab.text = [NSString stringWithFormat:@"¥%@",self.obj.retData.deposit_money];/*单品详情价格*/
        NSMutableAttributedString *tempStr = [[NSMutableAttributedString alloc] initWithString:serveCostLab.text];
        [tempStr addAttribute:NSFontAttributeName value:KSystemFontSize12 range:NSMakeRange(0, 1)];
        [tempStr addAttribute:NSFontAttributeName value:KSystemRealBoldFontSize21 range:NSMakeRange(1, serveCostLab.text.length - 1)];
        serveCostLab.attributedText = tempStr;
        [serveCostLab sizeToFit];
        serveCostLab.frame = CGRectMake(WIDTH/2.0 - serveCostLab.frame.size.width/2.0,
                                        currentNameY + 30*Proportion,
                                        serveCostLab.frame.size.width,
                                        serveCostLab.frame.size.height);
        [self addSubview:serveCostLab];
        
        UIImageView *depositImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ServeDepositImg]];/*订金*/
        [depositImg sizeToFit];
        depositImg.backgroundColor = [UIColor CMLWhiteColor];
        depositImg.contentMode = UIViewContentModeScaleAspectFill;
        depositImg.clipsToBounds = YES;
        depositImg.frame = CGRectMake(WIDTH/2.0 -  depositImg.frame.size.width/2.0,
                                      CGRectGetMaxY(serveCostLab.frame) + 7*Proportion,
                                      depositImg.frame.size.width,
                                      depositImg.frame.size.height);
        [self addSubview:depositImg];
        
        
        if ([self.obj.retData.deposit_total intValue] > 0 || self.obj.retData.ios_deposit_total.length > 0) {
            
            
            /**price*/
            NSMutableAttributedString *priceStr;
            
            if (self.obj.retData.ios_deposit_total.length > 0) {
                
                priceStr =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",self.obj.retData.ios_deposit_total]];
            }else{
                
                priceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",self.obj.retData.deposit_total]];
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
            [self addSubview:self.totalPriceLabel];
            
            UIImageView *fullAmountImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ServeFullAmountImg]];/*全款*/
            [fullAmountImg sizeToFit];
            fullAmountImg.backgroundColor = [UIColor CMLWhiteColor];
            fullAmountImg.contentMode = UIViewContentModeScaleAspectFill;
            fullAmountImg.clipsToBounds = YES;
            fullAmountImg.frame = CGRectMake(WIDTH/2.0 -  fullAmountImg.frame.size.width/2.0,
                                             CGRectGetMaxY(self.totalPriceLabel.frame) + 4*Proportion,
                                             fullAmountImg.frame.size.width,
                                             fullAmountImg.frame.size.height);
            [self addSubview:fullAmountImg];
            
            currentNameY = CGRectGetMaxY(fullAmountImg.frame);
            
        }else{
            
            currentNameY = CGRectGetMaxY(depositImg.frame);
            
        }

        /****/
//
//        UILabel *serveCostLab = [[UILabel alloc] init];
//        serveCostLab.textColor = [UIColor CMLBrownColor];
//        serveCostLab.text = [NSString stringWithFormat:@"¥%@（订金）",self.obj.retData.deposit_money];
//        NSMutableAttributedString *tempStr = [[NSMutableAttributedString alloc] initWithString:serveCostLab.text];
//        [tempStr addAttribute:NSFontAttributeName value:KSystemFontSize12 range:NSMakeRange(serveCostLab.text.length - 4, 4)];
//        [tempStr addAttribute:NSFontAttributeName value:KSystemRealBoldFontSize21 range:NSMakeRange(0, serveCostLab.text.length - 4)];
//        serveCostLab.attributedText = tempStr;
//        [serveCostLab sizeToFit];
//        serveCostLab.frame = CGRectMake(WIDTH/2.0 - serveCostLab.frame.size.width/2.0,
//                                        currentNameY + 30*Proportion,
//                                        serveCostLab.frame.size.width,
//                                        serveCostLab.frame.size.height);
//        [self addSubview:serveCostLab];
//
//            /**price*/
//
//        if ([self.obj.retData.deposit_total intValue] > 0 || self.obj.retData.ios_deposit_total.length > 0) {
//
//            NSMutableAttributedString *priceStr;
//
//            if (self.obj.retData.ios_deposit_total.length > 0) {
//
//                priceStr =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"全款：¥%@",self.obj.retData.ios_deposit_total]];
//            }else{
//
//                priceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"全款：¥%@",self.obj.retData.deposit_total]];
//            }
//            self.totalPriceLabel = [[UILabel alloc] init];
//            self.totalPriceLabel.textColor = [UIColor CMLLineGrayColor];
//            self.totalPriceLabel.font = KSystemBoldFontSize13;
//            self.totalPriceLabel.attributedText = priceStr;
//            [self.totalPriceLabel sizeToFit];
//            self.totalPriceLabel.frame = CGRectMake(WIDTH/2.0 - self.totalPriceLabel.frame.size.width/2.0,
//                                                    20*Proportion + CGRectGetMaxY(serveCostLab.frame),
//                                                    self.totalPriceLabel.frame.size.width,
//                                                    self.totalPriceLabel.frame.size.height);
//            [self addSubview:self.totalPriceLabel];
//            currentNameY = CGRectGetMaxY(self.totalPriceLabel.frame);
//        }else{
//
//            currentNameY = CGRectGetMaxY(serveCostLab.frame);
//        }
        
        
    }else{/*不存在订金时*/
        
        if (!self.isVerb) {/*不存在预售*/
            if ([self.obj.retData.is_discount intValue] == 1) {
                if (self.obj.retData.discount_min != 0) {
                    self.priceLab = [[UILabel alloc] init];
                    self.priceLab.text = [NSString stringWithFormat:@"￥%ld", (long)self.obj.retData.discount_min];
                    self.priceLab.font = KSystemBoldFontSize21;
                    self.priceLab.textColor = [UIColor CMLUserBlackColor];
                    [self.priceLab sizeToFit];
                    self.priceLab.frame = CGRectMake(WIDTH/2.0 - self.priceLab.frame.size.width/2.0,
                                                        currentNameY + 30*Proportion,
                                                        self.priceLab.frame.size.width,
                                                        self.priceLab.frame.size.height);
                    [self addSubview:self.priceLab];
                    
                    /*划线价*/
                    self.linePriceLabel = [[UILabel alloc] init];
                    self.linePriceLabel.text = [NSString stringWithFormat:@"￥%@",self.obj.retData.totalAmountMin];
                    self.linePriceLabel.font = KSystemFontSize12;
                    self.linePriceLabel.textColor = [UIColor CMLPromptGrayColor];
                    NSAttributedString *attstring = [[NSAttributedString alloc] initWithString:self.linePriceLabel.text attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid)}];
                    self.linePriceLabel.attributedText = attstring;
                    [self.linePriceLabel sizeToFit];
                    self.linePriceLabel.frame = CGRectMake(WIDTH/2.0 - self.linePriceLabel.frame.size.width/2.0,
                                                            CGRectGetMaxY(self.priceLab.frame) + 0*Proportion,
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
                    self.memberPrice.frame = CGRectMake(CGRectGetMaxX(self.priceLab.frame) + 10 * Proportion,
                                                        CGRectGetMidY(self.priceLab.frame) - 30*Proportion/2,
                                                        72 * Proportion,
                                                        30 * Proportion);
                    [self addSubview:self.memberPrice];
                    currentNameY = CGRectGetMaxY(self.linePriceLabel.frame);
                }
            }else {/*不存在折扣*/
                self.priceLab = [[UILabel alloc] init];
                self.priceLab.text = [NSString stringWithFormat:@"￥%@",self.obj.retData.totalAmountMin];
                self.priceLab.font = KSystemBoldFontSize21;
                self.priceLab.textColor = [UIColor CMLUserBlackColor];
                [self.priceLab sizeToFit];
                self.priceLab.frame = CGRectMake(WIDTH/2.0 - self.priceLab.frame.size.width/2.0,
                                                    currentNameY + 30*Proportion,
                                                    self.priceLab.frame.size.width,
                                                    self.priceLab.frame.size.height);
                [self addSubview:self.priceLab];
                currentNameY = CGRectGetMaxY(self.priceLab.frame);
            }
            
        }else{ /*存在预售*/
            
            self.priceLab = [[UILabel alloc] init];
            self.priceLab.text = [NSString stringWithFormat:@"￥%@",self.obj.retData.pre_price];
            self.priceLab.font = KSystemBoldFontSize21;
            self.priceLab.textColor = [UIColor CMLBrownColor];
            [self.priceLab sizeToFit];
            self.priceLab.frame = CGRectMake(WIDTH/2.0 - self.priceLab.frame.size.width/2.0,
                                                currentNameY + 30*Proportion,
                                                self.priceLab.frame.size.width,
                                                self.priceLab.frame.size.height);
            [self addSubview:self.priceLab];
            
            self.totalPriceLabel = [[UILabel alloc] init];
            self.totalPriceLabel.textColor = [UIColor CMLLineGrayColor];
            self.totalPriceLabel.font = KSystemBoldFontSize13;
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",self.obj.retData.totalAmountMin]];
            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, attri.length)];
            
            [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor CMLLineGrayColor] range:NSMakeRange(0, attri.length)];
            
            self.totalPriceLabel.attributedText = attri;
            [self.totalPriceLabel sizeToFit];
            self.totalPriceLabel.frame = CGRectMake(WIDTH/2.0 - self.totalPriceLabel.frame.size.width/2.0,
                                                    20*Proportion + CGRectGetMaxY(self.priceLab.frame),
                                                    self.totalPriceLabel.frame.size.width,
                                                    self.totalPriceLabel.frame.size.height);
            [self addSubview:self.totalPriceLabel];
            
            currentNameY = CGRectGetMaxY(self.totalPriceLabel.frame);
        }
    }
    
    UIImageView *spaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                currentNameY,
                                                                                WIDTH,
                                                                                40*Proportion)];
    spaceImageView.backgroundColor = [UIColor clearColor];
    spaceImageView.image = [UIImage imageNamed:MailShaDowImg];
    [self addSubview:spaceImageView];

    if (self.obj.retData.couponsInfo) {
        
        /*优惠券*/
        UIView *discountCouponView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                              currentNameY + 40 * Proportion,
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
        currentNameY = CGRectGetMaxY(discountCouponView.frame);
        
        UIImageView *spaceView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                               currentNameY - 20 * Proportion,
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
                                        CGRectGetMidY(self.priceLab.frame) - 48 * Proportion/2,
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
    
    /*服务保障*/
    UIImageView *serveProtect = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ServeProtctImg]];
    serveProtect.contentMode = UIViewContentModeScaleAspectFill;
    serveProtect.userInteractionEnabled = YES;
    [serveProtect sizeToFit];
    CGFloat newHeight = serveProtect.frame.size.height/serveProtect.frame.size.width*WIDTH;
    serveProtect.frame = CGRectMake(0,
                                    currentNameY + 40*Proportion,
                                    WIDTH,
                                    newHeight);
    [self addSubview:serveProtect];
    
    UIButton *showServeProtectBtn = [[UIButton alloc] initWithFrame:serveProtect.bounds];
    showServeProtectBtn.backgroundColor = [UIColor clearColor];
    [serveProtect addSubview:showServeProtectBtn];
    [showServeProtectBtn addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    
    self.currentHeight = CGRectGetMaxY(serveProtect.frame);
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (self.imagesScrollView) {
        
        self.pageLab.text = [NSString stringWithFormat:@"%d/%lu",(int)self.imagesScrollView.contentOffset.x/(int)WIDTH + 1,(unsigned long)self.obj.retData.coverPicArr.count];
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
        self.pageLab.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)self.obj.retData.coverPicArr.count];
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
        self.pageLab.text = [NSString stringWithFormat:@"2/%lu",(unsigned long)self.obj.retData.coverPicArr.count];
        [self.pageLab sizeToFit];
        self.pageLab.frame = CGRectMake(WIDTH - 30*Proportion - self.pageLab.frame.size.width,
                                        CGRectGetMaxY(self.imagesScrollView.frame) - 28*Proportion - self.pageLab.frame.size.height,
                                        self.pageLab.frame.size.width,
                                        self.pageLab.frame.size.height);
        
        
    }
}

- (void) playVideo{
    
    self.imagesScrollView.hidden = YES;
    [self openmovie:self.obj.retData.videoUrl];
    
}

#pragma mark - video

-(void)openmovie:(NSString*) url{
    
    
    self.videoController = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(0,0,WIDTH,WIDTH)];
    __weak typeof(self)weakSelf = self;
    self.videoController.view.backgroundColor = [UIColor whiteColor];
    [self.videoController setDimissCompleteBlock:^{
        weakSelf.videoController = nil;
    }];
    [self.videoController setWillBackOrientationPortrait:^{
        
    }];
    [self.videoController setWillChangeToFullscreenMode:^{
        
    }];
    
    [self.videoController setDimissCompleteBlock:^{
        
       weakSelf.videoController = nil;
        weakSelf.imagesScrollView.hidden = NO;
    }];
    //        [self addSubview:self.videoController.view];  加载到当前 view 上使用简单
    [self.videoController showInWindow]; //video 显示在 window 便于控制
    
    self.videoController.contentURL = [NSURL URLWithString:url];

    
    
}


- (void) refershGoodsView{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refershGoodsView" object:nil];
}


- (void) show{
    
    BrandServeView *serveProjectView = [[BrandServeView alloc] init];
    [self.superview.superview addSubview:serveProjectView];
    [self.superview.superview bringSubviewToFront:serveProjectView];
}

- (void)discountCouponClicked {
    
    [self.delegate showCanGetCouponViewOfCommodityTopViewWith:self.obj];
    
}

@end
