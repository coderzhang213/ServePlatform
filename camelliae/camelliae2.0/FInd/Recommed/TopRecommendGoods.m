//
//  TopRecommendGoods.m
//  camelliae2.0
//
//  Created by 张越 on 2018/9/19.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "TopRecommendGoods.h"
#import "BaseResultObj.h"
#import "CommonFont.h"
#import "CommonImg.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "CMLRecommendCommonModuleObj.h"
#import "ServeDefaultVC.h"
#import "VCManger.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"
#import "CMLCommodityDetailMessageVC.h"
#import "CMLUserPushGoodsVC.h"

#define MainInterfaceLeftMargin              30
#define MainInterfaceSpace                   30
#define MainInterfaceOtherSpace              60
#define MainInterfaceTopMargin               30
#define MainInterfaceServeModelHeight        180
#define MainInterfaceShortTitleTopMargin     20


@interface TopRecommendGoods ()

@property (nonatomic,strong) BaseResultObj *recommenModuleObj;

@end

@implementation TopRecommendGoods

- (instancetype)initWith:(BaseResultObj *)obj{
    
    self = [super init];
    if (self) {
        
        self.recommenModuleObj = obj;
        self.backgroundColor = [UIColor whiteColor];
        
        [self loadViews];
    }
    return self;
}

- (void) loadViews{
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    if (self.recommenModuleObj.retData.moduleGoodsRecomm.dataList.count > 0) {
        
        UILabel *promName = [[UILabel alloc] init];
        promName.backgroundColor = [UIColor whiteColor];
        promName.text = @"甄选单品";
        promName.layer.masksToBounds = YES;
        promName.font =KSystemRealBoldFontSize18;
        [promName sizeToFit];
        promName.frame = CGRectMake(WIDTH/2.0 - promName.frame.size.width/2.0,
                                    62*Proportion,
                                    promName.frame.size.width,
                                    promName.frame.size.height);
        [bgView addSubview:promName];
        
        UILabel *shortTitleLab = [[UILabel alloc] init];
        shortTitleLab.text = @"搜罗全球尖端好货";
        shortTitleLab.font = KSystemBoldFontSize12;
        [shortTitleLab sizeToFit];
        shortTitleLab.frame = CGRectMake(WIDTH/2.0 - shortTitleLab.frame.size.width/2.0,
                                         CGRectGetMaxY(promName.frame) + 30*Proportion,
                                         shortTitleLab.frame.size.width,
                                         shortTitleLab.frame.size.height);
        [bgView addSubview:shortTitleLab];
        
        UIScrollView *promScrollView = [[UIScrollView alloc] init];
        promScrollView.showsVerticalScrollIndicator = NO;
        promScrollView.showsHorizontalScrollIndicator = NO;
        [bgView addSubview:promScrollView];
        
        
        for (int i = 0; i < self.recommenModuleObj.retData.moduleGoodsRecomm.dataList.count; i++) {
            
            
            CMLModuleObj *currentObj = [CMLModuleObj getBaseObjFrom:self.recommenModuleObj.retData.moduleGoodsRecomm.dataList[i]];

            UIImageView *modelImage = [[UIImageView alloc] initWithFrame:CGRectMake((30*Proportion + 381*Proportion)*i + 30*Proportion,
                                                                                    0,
                                                                                    381*Proportion,
                                                                                    381*Proportion)];
            modelImage.clipsToBounds = YES;
            modelImage.contentMode = UIViewContentModeScaleAspectFill;
            modelImage.backgroundColor = [UIColor CMLPromptGrayColor];
            modelImage.userInteractionEnabled = YES;
            modelImage.layer.cornerRadius = 10*Proportion;
            [promScrollView addSubview:modelImage];
            [NetWorkTask setImageView:modelImage WithURL:currentObj.coverPicThumb placeholderImage:nil];
            
            UILabel *preTag = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 66*Proportion, 40*Proportion)];
            preTag.backgroundColor = [UIColor CMLBlackColor];
            preTag.textColor = [UIColor CMLBrownColor];
            preTag.font = KSystemFontSize11;
            preTag.text = @"预售";
            preTag.textAlignment = NSTextAlignmentCenter;
            [modelImage addSubview:preTag];
            
            UILabel *tagLab = [[UILabel alloc] init];
            tagLab.font = KSystemFontSize10;
            tagLab.textColor = [UIColor CMLLightBrownColor];
            tagLab.text = currentObj.brandName;
            tagLab.textAlignment = NSTextAlignmentCenter;
            tagLab.layer.borderWidth = 1*Proportion;
            tagLab.layer.borderColor = [UIColor CMLLightBrownColor].CGColor;
            [tagLab sizeToFit];
            tagLab.frame = CGRectMake(CGRectGetMinX(modelImage.frame),
                                      CGRectGetMaxY(modelImage.frame) + 20*Proportion,
                                      tagLab.frame.size.width + 10*Proportion,
                                      tagLab.frame.size.height + 5*Proportion);
            [promScrollView addSubview:tagLab];
            
            UILabel *modelLabel = [[UILabel alloc] init];
            modelLabel.text = currentObj.title;
            modelLabel.font = KSystemBoldFontSize15;
            modelLabel.numberOfLines = 0;
            [modelLabel sizeToFit];
            modelLabel.textAlignment = NSTextAlignmentLeft;
            modelLabel.textColor = [UIColor CMLBlackColor];
            modelLabel.backgroundColor = [UIColor whiteColor];
            modelLabel.contentMode = UIViewContentModeTop;
            [promScrollView addSubview:modelLabel];
            
            UILabel *modelPriceLabel = [[UILabel alloc] init];
            modelPriceLabel.font = KSystemBoldFontSize18;
            modelPriceLabel.backgroundColor = [UIColor whiteColor];
            modelPriceLabel.textAlignment = NSTextAlignmentCenter;
            
            
            if ([currentObj.is_deposit intValue] == 1) {

                modelPriceLabel.text = [NSString stringWithFormat:@"￥%@",currentObj.deposit_money];
            }else{

                if ([currentObj.is_pre intValue] == 1) {

                    modelPriceLabel.text = [NSString stringWithFormat:@"￥%@",currentObj.pre_price];
                }else{

                    modelPriceLabel.text = [NSString stringWithFormat:@"￥%@",currentObj.totalAmountMin];
                }

            }
            
            modelPriceLabel.textColor = [UIColor CMLBrownColor];
            [modelPriceLabel sizeToFit];
            
            if (modelLabel.frame.size.width > modelImage.frame.size.width) {
                
                modelLabel.frame = CGRectMake(modelImage.frame.origin.x,
                                              CGRectGetMaxY(tagLab.frame) + 13*Proportion,
                                              modelImage.frame.size.width,
                                              modelLabel.frame.size.height*2);
                
                modelPriceLabel.frame = CGRectMake(modelImage.frame.origin.x,
                                                   CGRectGetMaxY(modelLabel.frame) + 20*Proportion,
                                                   modelPriceLabel.frame.size.width,
                                                   modelPriceLabel.frame.size.height);
            }else{
                
                modelLabel.frame = CGRectMake(modelImage.frame.origin.x,
                                              CGRectGetMaxY(tagLab.frame) + 13*Proportion,
                                              modelImage.frame.size.width,
                                              modelLabel.frame.size.height);
                modelPriceLabel.frame = CGRectMake(modelImage.frame.origin.x,
                                                   CGRectGetMaxY(modelLabel.frame) + modelLabel.frame.size.height  + 20*Proportion,
                                                   modelPriceLabel.frame.size.width,
                                                   modelPriceLabel.frame.size.height);
            }
            
            [promScrollView addSubview:modelPriceLabel];
            
            
           if ([currentObj.is_deposit intValue] == 1) {
                
                UILabel *promLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(modelPriceLabel.frame) + 10*Proportion,
                                                                             modelPriceLabel.center.y - 30*Proportion/2.0,
                                                                             50*Proportion,
                                                                             30*Proportion)];
                promLab.font = KSystemFontSize10;
                promLab.backgroundColor = [UIColor CMLBrownColor];
                promLab.layer.cornerRadius = 4*Proportion;
                promLab.clipsToBounds = YES;
                promLab.textColor = [UIColor CMLWhiteColor];
                promLab.textAlignment = NSTextAlignmentCenter;
                promLab.text = @"订金";
                [promScrollView addSubview:promLab];
                
            }
            
            if ([currentObj.is_pre intValue] == 1) {
                
                preTag.hidden = NO;
            }else{
                
                preTag.hidden = YES;
            }
            
            
            UIButton *modelBtn = [[UIButton alloc] initWithFrame:modelImage.bounds];
            modelBtn.tag = i + 1;
            modelBtn.backgroundColor = [UIColor clearColor];
            [modelImage addSubview:modelBtn];
            [modelBtn addTarget:self action:@selector(enterModuleProjectRecommVC:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i == self.recommenModuleObj.retData.moduleGoodsRecomm.dataList.count - 1) {
                promScrollView.frame = CGRectMake(0,
                                                  CGRectGetMaxY(shortTitleLab.frame) + 62*Proportion,
                                                  WIDTH,
                                                  CGRectGetMaxY(modelPriceLabel.frame) + 30*Proportion);
                promScrollView.contentSize = CGSizeMake(CGRectGetMaxX(modelImage.frame) + 30*Proportion,
                                                        promScrollView.frame.size.height);
                
                UIButton *morebtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2.0 - 183*Proportion/2.0, CGRectGetMaxY(promScrollView.frame), 183*Proportion, 60*Proportion)];
                morebtn.backgroundColor = [UIColor CMLBlack010101Color];
                morebtn.titleLabel.font = KSystemBoldFontSize12;
                [morebtn setTitle:@"查看更多" forState:UIControlStateNormal];
                [bgView addSubview:morebtn];
                [morebtn addTarget:self action:@selector(showServeView) forControlEvents:UIControlEventTouchUpInside];
                
                UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                              CGRectGetMaxY(morebtn.frame) + 40*Proportion,
                                                                              WIDTH,
                                                                              20*Proportion)];
                bottomView.backgroundColor = [UIColor CMLNewUserGrayColor];
                [self addSubview:bottomView];
                
                bgView.frame = CGRectMake(0,
                                          0,
                                          WIDTH,
                                          CGRectGetMaxY(bottomView.frame));
                
                
                self.currentHeight = bgView.frame.size.height;

                
            }
            
        }
        
    }else{
        bgView.hidden = YES;
        self.currentHeight = 0;
        
    }
    
}

- (void) enterModuleProjectRecommVC:(UIButton *)button{
    
    CMLModuleObj *obj = [CMLModuleObj getBaseObjFrom:self.recommenModuleObj.retData.moduleGoodsRecomm.dataList[button.tag - 1]];
    
    if ([obj.isUserPublish intValue] == 1) {
        
        CMLUserPushGoodsVC *vc = [[CMLUserPushGoodsVC alloc] initWithObjId:obj.currentID];
        [[VCManger mainVC] pushVC:vc animate:YES];
    }else{
        
        CMLCommodityDetailMessageVC *vc =[[CMLCommodityDetailMessageVC alloc] initWithObjId:obj.currentID];
        [[VCManger mainVC] pushVC:vc animate:YES];
    }

    
}

- (void)showServeView{
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[VCManger homeVC] showCurrentViewController:homeStoreTag];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectStoreGoodss" object:nil];
    
}

@end
