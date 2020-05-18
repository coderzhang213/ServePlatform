//
//  CMLStoreBrandHeaderView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/28.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLStoreBrandHeaderView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "BaseResultObj.h"
#import "AllBrandInfoObj.h"
#import "BrandModuleObj.h"
#import "CMLImageObj.h"
#import "NetWorkTask.h"
#import "CMLLine.h"
#import "CMLBrandVC.h"
#import "VCManger.h"
#import "BrandAndServeObj.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"
#import "CMLCommodityDetailMessageVC.h"
#import "VCManger.h"
#import "ServeDefaultVC.h"

@interface CMLStoreBrandHeaderView()

@property (nonatomic,strong) BaseResultObj *obj;

@end

@implementation CMLStoreBrandHeaderView

- (instancetype)initWithObj:(BaseResultObj*) obj{
    
    self = [super init];
    
    if (self) {
        self.obj = obj;
        self.backgroundColor = [UIColor CMLWhiteColor];
        [self loadViewsWith:obj];
    }
    return self;
}

- (void) loadViewsWith:(BaseResultObj *) obj{
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    UILabel *promName = [[UILabel alloc] init];
    promName.backgroundColor = [UIColor whiteColor];
    promName.text = @"今日推荐";
    promName.layer.masksToBounds = YES;
    promName.font =KSystemRealBoldFontSize17;
    [promName sizeToFit];
    promName.frame = CGRectMake(30*Proportion,
                                20*Proportion,
                                promName.frame.size.width,
                                promName.frame.size.height);
    [bgView addSubview:promName];
    
    
    UIScrollView *promScrollView = [[UIScrollView alloc] init];
    promScrollView.showsVerticalScrollIndicator = NO;
    promScrollView.showsHorizontalScrollIndicator = NO;
    [bgView addSubview:promScrollView];
    
    CGFloat HotCurrentLeftMargin = 20*Proportion;
    
    for (int i = 0; i < obj.retData.recommBrandInfo.dataList.count; i++) {
        
        
        BrandModuleObj *currentObj = [BrandModuleObj getBaseObjFrom:obj.retData.recommBrandInfo.dataList[i]];
        
        if ([CMLImageObj getBaseObjFrom:[currentObj.logoPicArr firstObject]]) {
            
        }
        
        CMLImageObj *imageObj = [CMLImageObj getBaseObjFrom:[currentObj.recommLogoPicArr firstObject]];
        UIImageView *modelImage = [[UIImageView alloc] initWithFrame:CGRectMake(HotCurrentLeftMargin,
                                                                                0,
                                                                                200*Proportion*[imageObj.ratio floatValue],
                                                                                200*Proportion)];
        modelImage.clipsToBounds = YES;
        modelImage.contentMode = UIViewContentModeScaleAspectFill;
        modelImage.backgroundColor = [UIColor clearColor];
        modelImage.userInteractionEnabled = YES;
        modelImage.layer.borderColor = [UIColor CMLSerachLineGrayColor].CGColor;
        modelImage.layer.borderWidth = 1*Proportion;
        modelImage.layer.cornerRadius = 10*Proportion;
        [promScrollView addSubview:modelImage];
        [NetWorkTask setImageView:modelImage WithURL:currentObj.recommLogoPic placeholderImage:nil];
        
        HotCurrentLeftMargin = HotCurrentLeftMargin + (modelImage.frame.size.width + 20*Proportion);
        
        UILabel *modelLabel = [[UILabel alloc] init];
        modelLabel.text = currentObj.name;
        modelLabel.font = KSystemRealBoldFontSize14;
        modelLabel.numberOfLines = 0;
        [modelLabel sizeToFit];
        modelLabel.textAlignment = NSTextAlignmentCenter;
        modelLabel.textColor = [UIColor CMLBlackColor];
        modelLabel.backgroundColor = [UIColor clearColor];
        modelLabel.frame = CGRectMake(modelImage.frame.origin.x,
                                      CGRectGetMaxY(modelImage.frame) + 20*Proportion,
                                      modelImage.frame.size.width,
                                      modelLabel.frame.size.height);
        [promScrollView addSubview:modelLabel];
        
        
        UIButton *modelBtn = [[UIButton alloc] initWithFrame:modelImage.bounds];
        modelBtn.tag = i + 1;
        modelBtn.backgroundColor = [UIColor clearColor];
        [modelImage addSubview:modelBtn];
        [modelBtn addTarget:self action:@selector(enterBrandVC:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == obj.retData.recommBrandInfo.dataList.count - 1) {
            
            promScrollView.frame = CGRectMake(0,
                                              CGRectGetMaxY(promName.frame) + 20*Proportion,
                                              WIDTH,
                                              CGRectGetMaxY(modelLabel.frame) + 60*Proportion);
            promScrollView.contentSize = CGSizeMake(CGRectGetMaxX(modelImage.frame) + 20*Proportion,
                                                    promScrollView.frame.size.height);
            
            bgView.frame = CGRectMake(0,
                                      0,
                                      WIDTH,
                                      CGRectGetMaxY(promScrollView.frame)  + 1);
        }
        
    }

    UIView *bgView1 = [[UIView alloc] init];
    bgView1.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView1];
    UILabel *promName1 = [[UILabel alloc] init];
    promName1.backgroundColor = [UIColor whiteColor];
    promName1.text = @"最新入驻";
    promName1.layer.masksToBounds = YES;
    promName1.font =KSystemRealBoldFontSize17;
    [promName1 sizeToFit];
    promName1.frame = CGRectMake(30*Proportion,
                                 0,
                                 promName1.frame.size.width,
                                 promName1.frame.size.height);
    [bgView1 addSubview:promName1];
    
    
    UIScrollView *promScrollView1 = [[UIScrollView alloc] init];
    promScrollView1.showsVerticalScrollIndicator = NO;
    promScrollView1.showsHorizontalScrollIndicator = NO;
    [bgView1 addSubview:promScrollView1];
    
    CGFloat NewCurrentLeftMargin = 20*Proportion;
    
    for (int i = 0; i < obj.retData.timeBrandInfo.dataList.count; i++) {
        
        
        BrandModuleObj *currentObj = [BrandModuleObj getBaseObjFrom:obj.retData.timeBrandInfo.dataList[i]];
        CMLImageObj *imageObj = [CMLImageObj getBaseObjFrom:[currentObj.recommLogoPicArr firstObject]];
        UIImageView *modelImage = [[UIImageView alloc] initWithFrame:CGRectMake(NewCurrentLeftMargin,
                                                                                0,
                                                                                200*Proportion*[imageObj.ratio floatValue],
                                                                                200*Proportion)];
        modelImage.clipsToBounds = YES;
        modelImage.contentMode = UIViewContentModeScaleAspectFill;
        modelImage.backgroundColor = [UIColor clearColor];
        modelImage.layer.cornerRadius = 10*Proportion;
        modelImage.userInteractionEnabled = YES;
        modelImage.layer.borderColor = [UIColor CMLSerachLineGrayColor].CGColor;
        modelImage.layer.borderWidth = 1*Proportion;
        [promScrollView1 addSubview:modelImage];
        [NetWorkTask setImageView:modelImage WithURL:currentObj.recommLogoPic placeholderImage:nil];
        
        NewCurrentLeftMargin = NewCurrentLeftMargin + (modelImage.frame.size.width + 20*Proportion);
        
        UILabel *modelLabel = [[UILabel alloc] init];
        modelLabel.text = currentObj.name;
        modelLabel.font = KSystemRealBoldFontSize14;
        modelLabel.numberOfLines = 0;
        [modelLabel sizeToFit];
        modelLabel.textAlignment = NSTextAlignmentCenter;
        modelLabel.textColor = [UIColor CMLBlackColor];
        modelLabel.backgroundColor = [UIColor clearColor];
        modelLabel.frame = CGRectMake(modelImage.frame.origin.x,
                                      CGRectGetMaxY(modelImage.frame) + 20*Proportion,
                                      modelImage.frame.size.width,
                                      modelLabel.frame.size.height);
        [promScrollView1 addSubview:modelLabel];
        
        
        UIButton *modelBtn = [[UIButton alloc] initWithFrame:modelImage.bounds];
        modelBtn.tag = i + 1;
        modelBtn.backgroundColor = [UIColor clearColor];
        [modelImage addSubview:modelBtn];
        [modelBtn addTarget:self action:@selector(enterTimebrandVC:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == obj.retData.timeBrandInfo.dataList.count - 1) {
            
            promScrollView1.frame = CGRectMake(0,
                                              CGRectGetMaxY(promName1.frame) + 30*Proportion,
                                              WIDTH,
                                              CGRectGetMaxY(modelLabel.frame) + 60*Proportion);
            promScrollView1.contentSize = CGSizeMake(CGRectGetMaxX(modelImage.frame) + 20*Proportion,
                                                    promScrollView1.frame.size.height);
            
            bgView1.frame = CGRectMake(0,
                                      CGRectGetMaxY(bgView.frame),
                                      WIDTH,
                                      CGRectGetMaxY(promScrollView1.frame)  + 1);
        }
        
    }
    
    

    
    int numberOfBrand = (int)obj.retData.bestBrandInfo.dataList.count;
    
    if (numberOfBrand == 0) {
        
        UILabel *promName2 = [[UILabel alloc] init];
        promName2.backgroundColor = [UIColor whiteColor];
        promName2.text = @"全部品牌";
        promName2.layer.masksToBounds = YES;
        promName2.font =KSystemRealBoldFontSize17;
        [promName2 sizeToFit];
        promName2.frame = CGRectMake(30*Proportion,
                                     CGRectGetMaxY(bgView1.frame),
                                     promName2.frame.size.width,
                                     promName2.frame.size.height);
        [self addSubview:promName2];
        
        self.frame = CGRectMake(0,
                                0,
                                WIDTH,
                                CGRectGetMaxY(promName2.frame) + 30*Proportion);
        
        self.currentHeight = CGRectGetMaxY(promName2.frame) + 30*Proportion;
        
    }else{
        
        UILabel *promName2 = [[UILabel alloc] init];
        promName2.backgroundColor = [UIColor whiteColor];
        promName2.text = @"大牌甄选";
        promName2.layer.masksToBounds = YES;
        promName2.font =KSystemRealBoldFontSize17;
        [promName2 sizeToFit];
        promName2.frame = CGRectMake(30*Proportion,
                                     CGRectGetMaxY(bgView1.frame),
                                     promName2.frame.size.width,
                                     promName2.frame.size.height);
        [self addSubview:promName2];
        
        
        if (numberOfBrand > 3) {
            
            numberOfBrand = 3;
        }
        
        for (int i = 0; i < numberOfBrand; i++) {
            
            BrandModuleObj *bestBrandObj = [BrandModuleObj getBaseObjFrom:obj.retData.bestBrandInfo.dataList[i]];
            
            UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                                 CGRectGetMaxY(promName2.frame) + 30*Proportion + ((WIDTH - 30*Proportion*2)/16*9 + 140*Proportion)*i,
                                                                                 WIDTH - 30*Proportion*2,
                                                                                 (WIDTH - 30*Proportion*2)/16*9)];
            bgImage.backgroundColor = [UIColor CMLLineGrayColor];
            bgImage.layer.cornerRadius = 10*Proportion;
            bgImage.contentMode = UIViewContentModeScaleAspectFill;
            bgImage.userInteractionEnabled = YES;
            bgImage.clipsToBounds = YES;
            [self addSubview:bgImage];
            [NetWorkTask setImageView:bgImage WithURL:bestBrandObj.brandListPic placeholderImage:nil];
            
            UIImageView *currentLogoImg = [[UIImageView alloc] initWithFrame:CGRectMake(bgImage.frame.size.width/2.0 - 80*Proportion/2.0,
                                                                                        40*Proportion,
                                                                                        80*Proportion,
                                                                                        80*Proportion)];
            currentLogoImg.layer.cornerRadius = 80*Proportion/2.0;
            currentLogoImg.contentMode = UIViewContentModeScaleAspectFill;
            currentLogoImg.clipsToBounds = YES;
            currentLogoImg.userInteractionEnabled = YES;
            [bgImage addSubview:currentLogoImg];
            [NetWorkTask setImageView:currentLogoImg WithURL:bestBrandObj.logoPic placeholderImage:nil];
            
            UIButton *brandBtn = [[UIButton alloc] initWithFrame:currentLogoImg.bounds];
            brandBtn.backgroundColor = [UIColor clearColor];
            brandBtn.tag = i + 100;
            [currentLogoImg addSubview:brandBtn];
            [brandBtn addTarget:self action:@selector(enterBestBrandVC:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *currentName = [[UILabel alloc] init];
            currentName.backgroundColor = [UIColor clearColor];
            currentName.textColor = [UIColor CMLWhiteColor];
            currentName.text = bestBrandObj.name;
            currentName.font = KSystemRealBoldFontSize20;
            [currentName sizeToFit];
            currentName.frame = CGRectMake(bgImage.frame.size.width/2.0 - currentName.frame.size.width/2.0,
                                           CGRectGetMaxY(currentLogoImg.frame) + 12*Proportion,
                                           currentName.frame.size.width,
                                           currentName.frame.size.height);
            [bgImage addSubview:currentName];
            
            float space = ((WIDTH - 30*Proportion*2) - 204*Proportion*3)/4;
            
            int bestRecommNumber ;
            
            if ([bestBrandObj.bestRecommList.dataCount intValue] > 3) {
                
                bestRecommNumber = 3;
            }else{
                
                bestRecommNumber = [bestBrandObj.bestRecommList.dataCount intValue];
            }
          
            for (int j = 0;  j < bestRecommNumber; j++) {
                
                BrandAndServeObj *brandObj = [BrandAndServeObj getBaseObjFrom:bestBrandObj.bestRecommList.dataList[j]];
                
                UIView *moduleBgView = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion + space + (space + 204*Proportion)*j,
                                                                                CGRectGetMaxY(bgImage.frame) - (312 - 120)*Proportion,
                                                                                204*Proportion,
                                                                                312*Proportion)];
                moduleBgView.backgroundColor = [UIColor CMLWhiteColor];
                moduleBgView.layer.shadowOffset = CGSizeMake(0, 0);
                moduleBgView.layer.shadowColor = [UIColor CMLBlackColor].CGColor;
                moduleBgView.layer.shadowOpacity = 0.3;
                [self addSubview:moduleBgView];

                
                UIImageView *moduleImg = [[UIImageView alloc] initWithFrame:CGRectMake(moduleBgView.frame.size.width/2.0 - 180*Proportion/2.0,
                                                                                       12*Proportion,
                                                                                       180*Proportion,
                                                                                       180*Proportion)];
                moduleImg.contentMode = UIViewContentModeScaleAspectFill;
                moduleImg.userInteractionEnabled =YES;
                moduleImg.clipsToBounds = YES;
                [moduleBgView addSubview:moduleImg];
                [NetWorkTask setImageView:moduleImg WithURL:brandObj.coverPic placeholderImage:nil];
                
                UILabel *moduleTitle = [[UILabel alloc] init];
                moduleTitle.font = KSystemFontSize10;
                moduleTitle.numberOfLines = 2;
                moduleTitle.textColor = [UIColor CMLBlackColor];
                moduleTitle.text = brandObj.title;
                moduleTitle.textAlignment = NSTextAlignmentLeft;
                [moduleTitle sizeToFit];
                if (moduleTitle.frame.size.width > moduleImg.frame.size.width ) {
                    moduleTitle.frame = CGRectMake(12*Proportion,
                                                   CGRectGetMaxY(moduleImg.frame) + 8*Proportion,
                                                   moduleImg.frame.size.width,
                                                   moduleTitle.frame.size.height*2);
                }else{
                    moduleTitle.frame = CGRectMake(12*Proportion,
                                                   CGRectGetMaxY(moduleImg.frame) + 8*Proportion,
                                                   moduleImg.frame.size.width,
                                                   moduleTitle.frame.size.height);
                    
                }
     
                [moduleBgView addSubview:moduleTitle];
                
                UILabel *modulePrice = [[UILabel alloc] init];
                modulePrice.font = KSystemFontSize14;
                modulePrice.textColor = [UIColor CMLBrownColor];
                
                if ([brandObj.rootTypeId intValue] == 7) {
                    
                    modulePrice.text = [NSString stringWithFormat:@"¥%@",brandObj.totalAmountMin];
                    if ([brandObj.is_deposit intValue] == 1) {
                        
                        modulePrice.text = [NSString stringWithFormat:@"¥%@",brandObj.deposit_money];
                    }
                    
                }else{
                    
                    if ([brandObj.isHasPriceInterval intValue] == 1 ) {
                        
                        modulePrice.text = [NSString stringWithFormat:@"￥%@起",brandObj.price];
                        
                        
                    }else{
                        
                        modulePrice.text = [NSString stringWithFormat:@"￥%@",brandObj.price];
                    }
                }
                [modulePrice sizeToFit];
                modulePrice.textAlignment = NSTextAlignmentLeft;
                modulePrice.frame = CGRectMake(12*Proportion,
                                               moduleBgView.frame.size.height - 12*Proportion - modulePrice.frame.size.height,
                                               moduleImg.frame.size.width,
                                               modulePrice.frame.size.height);
                [moduleBgView addSubview:modulePrice];
                
                UIButton *bestRecommBtn = [[UIButton alloc] initWithFrame:moduleBgView.bounds];
                bestRecommBtn.backgroundColor = [UIColor clearColor];
                bestRecommBtn.tag = 10*i + j;
                [moduleBgView addSubview:bestRecommBtn];
                [bestRecommBtn addTarget:self action:@selector(enterBestRecommVC:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            
            if (i == numberOfBrand - 1) {
                
                
                UILabel *promName3 = [[UILabel alloc] init];
                promName3.backgroundColor = [UIColor whiteColor];
                promName3.text = @"全部品牌";
                promName3.layer.masksToBounds = YES;
                promName3.font =KSystemRealBoldFontSize17;
                [promName3 sizeToFit];
                promName3.frame = CGRectMake(30*Proportion,
                                             CGRectGetMaxY(bgImage.frame) + 140*Proportion + 30*Proportion,
                                             promName3.frame.size.width,
                                             promName3.frame.size.height);
                [self addSubview:promName3];
                
                self.frame = CGRectMake(0,
                                        0,
                                        WIDTH,
                                        CGRectGetMaxY(promName3.frame) + 30*Proportion);
                
                self.currentHeight = CGRectGetMaxY(promName3.frame) + 30*Proportion;
            }
        }
    }
}

- (void) enterBrandVC:(UIButton *) btn{
    
    BrandModuleObj *currentObj = [BrandModuleObj getBaseObjFrom:self.obj.retData.recommBrandInfo.dataList[btn.tag - 1]];
    CMLBrandVC *vc = [[CMLBrandVC alloc] initWithImageUrl:currentObj.coverPic andDetailMes:currentObj.desc LogoImageUrl:currentObj.logoPic brandID:currentObj.currentID];
    vc.goodsNum = currentObj.goodsCount;
    vc.serveNum = currentObj.projectCount;
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) enterTimebrandVC:(UIButton *) btn{
    
    BrandModuleObj *currentObj = [BrandModuleObj getBaseObjFrom:self.obj.retData.timeBrandInfo.dataList[btn.tag - 1]];
    CMLBrandVC *vc = [[CMLBrandVC alloc] initWithImageUrl:currentObj.coverPic andDetailMes:currentObj.desc LogoImageUrl:currentObj.logoPic brandID:currentObj.currentID];
    vc.goodsNum = currentObj.goodsCount;
    vc.serveNum = currentObj.projectCount;
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

- (void) enterBestBrandVC:(UIButton *) btn{
    
    BrandModuleObj *bestBrandObj = [BrandModuleObj getBaseObjFrom:self.obj.retData.bestBrandInfo.dataList[(int)btn.tag - 100]];
    CMLBrandVC *vc = [[CMLBrandVC alloc] initWithImageUrl:bestBrandObj.coverPic andDetailMes:bestBrandObj.desc LogoImageUrl:bestBrandObj.logoPic brandID:bestBrandObj.currentID];
    vc.goodsNum = bestBrandObj.goodsCount;
    vc.serveNum = bestBrandObj.projectCount;
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

- (void) enterBestRecommVC:(UIButton *) btn{
    
    
    
    BrandModuleObj *bestBrandObj = [BrandModuleObj getBaseObjFrom:self.obj.retData.bestBrandInfo.dataList[(int)btn.tag/10]];
    
    BrandAndServeObj *brandObj = [BrandAndServeObj getBaseObjFrom:bestBrandObj.bestRecommList.dataList[(int)btn.tag%10]];
    
    if ([brandObj.rootTypeId intValue] == 7) {
       
        CMLCommodityDetailMessageVC *vc =[[CMLCommodityDetailMessageVC alloc] initWithObjId:brandObj.currentID];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }else{
        
        ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:brandObj.currentID];
        [[VCManger mainVC] pushVC:vc animate:YES];
    }
    
}
@end
