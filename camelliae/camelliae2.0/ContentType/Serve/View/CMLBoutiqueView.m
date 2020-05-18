//
//  CMLBoutiqueView.m
//  camelliae2.0
//
//  Created by 张越 on 2018/4/16.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "CMLBoutiqueView.h"
#import "BaseResultObj.h"
#import "VCManger.h"
#import "UIColor+SDExspand.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "RelateQualityObj.h"
#import "CMLModuleObj.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"
#import "CMLCommodityDetailMessageVC.h"
#import "ServeDefaultVC.h"
#import "VCManger.h"

@interface CMLBoutiqueView()

@property (nonatomic,strong) UIView *goodsBgView;

@property (nonatomic,strong) UIView *serveBgView;

@property (nonatomic,strong) BaseResultObj *obj;

@end

@implementation CMLBoutiqueView

-(instancetype)initWithObj:(BaseResultObj *) obj{
    
    
    self = [super init];
    
    if (self) {
        
        self.obj = obj;
        self.goodsBgView = [[UIView alloc] init];
        self.goodsBgView.backgroundColor = [UIColor CMLWhiteColor];
        [self addSubview:self.goodsBgView];
        
//        self.serveBgView = [[UIView alloc] init];
//        self.serveBgView.backgroundColor = [UIColor CMLWhiteColor];
//        [self addSubview:self.serveBgView];
        
//        if ([self.obj.retData.RelateQuality.goods.dataCount intValue] == 0) {
//
//            self.goodsBgView.frame = CGRectMake(0, 0, 0, 0);
//            self.goodsBgView.hidden = YES;
//        }else{
//
            [self loadGoodsView];
//        }
//
//        if ([self.obj.retData.RelateQuality.project.dataCount intValue] == 0) {
//
//            self.serveBgView.frame = CGRectMake(0, CGRectGetMaxY(self.goodsBgView.frame), 0, 0);
//            self.serveBgView.hidden = YES;
//
//        }else{
//
//            [self loadServeView];
//        }
        
        
         self.currentHeight = CGRectGetMaxY(self.goodsBgView.frame);
    }
    
    return self;
    
}

- (void) loadGoodsView{
    
    
    CGFloat currentHeight = (72 + 210 + 12 + 30 + 16 + 20 + 40)*Proportion;
    
    CGFloat currentX = (WIDTH - 210*Proportion*3)/4;
    CGFloat currentY = 50*Proportion;
    for (int i = 0; i < self.obj.retData.RelateQuality.goods.dataList.count + self.obj.retData.RelateQuality.project.dataList.count; i++) {
        
        if (i < self.obj.retData.RelateQuality.goods.dataList.count) {
           
            CMLModuleObj *currentObj = [CMLModuleObj getBaseObjFrom:self.obj.retData.RelateQuality.goods.dataList[i]];
            
            UIView *modelView = [[UIView alloc] initWithFrame:CGRectMake(currentX, currentY, 210*Proportion, currentHeight)];
            
            [self.goodsBgView addSubview:modelView];
            
            
            UIView *modelBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           210*Proportion,
                                                                           210*Proportion)];
            modelBgView.layer.shadowColor = [UIColor blackColor].CGColor;
            modelBgView.layer.shadowOpacity = 0.05;
            modelBgView.layer.shadowOffset = CGSizeMake(0, 0);
            [modelView addSubview:modelBgView];
            
            
            UIImageView *modelImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                    0,
                                                                                    210*Proportion,
                                                                                    210*Proportion)];
            modelImage.clipsToBounds = YES;
            modelImage.contentMode = UIViewContentModeScaleAspectFill;
            modelImage.backgroundColor = [UIColor CMLWhiteColor];
            modelImage.userInteractionEnabled = YES;
            [modelBgView addSubview:modelImage];
            [NetWorkTask setImageView:modelImage WithURL:currentObj.coverPicThumb placeholderImage:nil];
            
            UILabel *preTag = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 66*Proportion, 40*Proportion)];
            preTag.backgroundColor = [UIColor CMLBlackColor];
            preTag.textColor = [UIColor CMLBrownColor];
            preTag.font = KSystemFontSize11;
            preTag.text = @"预售";
            preTag.textAlignment = NSTextAlignmentCenter;
            [modelImage addSubview:preTag];
            
            if ([currentObj.is_pre intValue]== 1) {
                
                preTag.hidden = NO;
            }else{
                
                preTag.hidden = YES;
            }
            
            
            UILabel *modelLabel = [[UILabel alloc] init];
            modelLabel.text = currentObj.title;
            modelLabel.font = KSystemFontSize10;
            modelLabel.numberOfLines = 0;
            [modelLabel sizeToFit];
            modelLabel.textAlignment = NSTextAlignmentLeft;
            modelLabel.textColor = [UIColor CMLBlackColor];
            modelLabel.backgroundColor = [UIColor clearColor];
            modelLabel.contentMode = UIViewContentModeTop;
            [modelView addSubview:modelLabel];
            
            UILabel *modelPriceLabel = [[UILabel alloc] init];
            modelPriceLabel.font = KSystemBoldFontSize14;
            modelPriceLabel.backgroundColor = [UIColor whiteColor];
            modelPriceLabel.textAlignment = NSTextAlignmentCenter;
            if ([currentObj.is_pre intValue] == 1) {
                
                modelPriceLabel.text = [NSString stringWithFormat:@"￥%@",currentObj.pre_price];
            }else{
                
                modelPriceLabel.text = [NSString stringWithFormat:@"￥%@",currentObj.totalAmountMin];
            }
            
            if ([currentObj.is_deposit intValue] == 1) {
                
                modelPriceLabel.text = [NSString stringWithFormat:@"￥%@",currentObj.deposit_money];
            }
            
            modelPriceLabel.textColor = [UIColor CMLBrownColor];
            [modelPriceLabel sizeToFit];
            
            if (modelLabel.frame.size.width > modelImage.frame.size.width) {
                
                modelLabel.frame = CGRectMake(modelImage.frame.origin.x,
                                              CGRectGetMaxY(modelImage.frame) + 25*Proportion,
                                              modelImage.frame.size.width,
                                              modelLabel.frame.size.height*2);
                
                modelPriceLabel.frame = CGRectMake(0,
                                                   CGRectGetMaxY(modelLabel.frame) + 20*Proportion,
                                                   modelPriceLabel.frame.size.width,
                                                   modelPriceLabel.frame.size.height);
            }else{
                
                modelLabel.frame = CGRectMake(modelImage.frame.origin.x,
                                              CGRectGetMaxY(modelImage.frame) + 25*Proportion,
                                              modelImage.frame.size.width,
                                              modelLabel.frame.size.height);
                
                modelPriceLabel.frame = CGRectMake(0,
                                                   CGRectGetMaxY(modelLabel.frame) + modelLabel.frame.size.height  + 20*Proportion,
                                                   modelPriceLabel.frame.size.width,
                                                   modelPriceLabel.frame.size.height);
            }
            
            
            [modelView addSubview:modelPriceLabel];
            
            if ([currentObj.is_deposit intValue] == 1) {
                
                UILabel *promLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(modelPriceLabel.frame) + 10*Proportion,
                                                                             modelPriceLabel.center.y - 30*Proportion/2.0,
                                                                             50*Proportion,
                                                                             30*Proportion)];
                promLab.font = KSystemFontSize10;
                promLab.backgroundColor = [UIColor CMLBrownColor];
                promLab.textColor = [UIColor CMLWhiteColor];
                promLab.textAlignment = NSTextAlignmentCenter;
                promLab.text = @"订金";
                [modelView addSubview:promLab];
                
            }
            
            modelView.frame = CGRectMake(currentX,
                                         currentY,
                                         210*Proportion,
                                         CGRectGetMaxY(modelPriceLabel.frame));
            
            UIButton *modelBtn = [[UIButton alloc] initWithFrame:modelView.bounds];
            modelBtn.tag = i + 1;
            modelBtn.backgroundColor = [UIColor clearColor];
            [modelView addSubview:modelBtn];
            [modelBtn addTarget:self action:@selector(enterModuleGoodsVC:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            
            if (i%3 == 2) {
                
                currentX = (WIDTH - 210*Proportion*3)/4;
                currentY = currentY + modelView.frame.size.height + 40*Proportion;
                
            }else{
                
                
                currentX += (210*Proportion + (WIDTH - 210*Proportion*3)/4);
            }
            
            if (self.obj.retData.RelateQuality.project.dataList.count == 0) {
             
                if (i == self.obj.retData.RelateQuality.goods.dataList.count - 1) {
                    
                    self.goodsBgView.frame = CGRectMake(0,
                                                        0,
                                                        WIDTH, CGRectGetMaxY(modelView.frame) + 40*Proportion);
                }
                
            }
            
//            if (i == self.obj.retData.RelateQuality.goods.dataList.count - 1) {
//
//                self.goodsBgView.frame = CGRectMake(0, 0, WIDTH, CGRectGetMaxY(modelView.frame) + 40*Proportion);
//            }
            
            
        }else{
            
            CMLModuleObj *currentObj = [CMLModuleObj getBaseObjFrom:self.obj.retData.RelateQuality.project.dataList[i - self.obj.retData.RelateQuality.goods.dataList.count]];
            
            UIView *modelView = [[UIView alloc] initWithFrame:CGRectMake(currentX, currentY, 210*Proportion, currentHeight)];
            [self.goodsBgView addSubview:modelView];
            
            UIImageView *modelImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                    0,
                                                                                    210*Proportion,
                                                                                    210*Proportion)];
            modelImage.clipsToBounds = YES;
            modelImage.contentMode = UIViewContentModeScaleAspectFill;
            modelImage.backgroundColor = [UIColor CMLPromptGrayColor];
            modelImage.userInteractionEnabled = YES;
            [modelView addSubview:modelImage];
            [NetWorkTask setImageView:modelImage WithURL:currentObj.coverPicThumb placeholderImage:nil];
            
            UILabel *preTag = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 66*Proportion, 40*Proportion)];
            preTag.backgroundColor = [UIColor CMLBlackColor];
            preTag.textColor = [UIColor CMLBrownColor];
            preTag.font = KSystemFontSize11;
            preTag.text = @"预售";
            preTag.textAlignment = NSTextAlignmentCenter;
            [modelImage addSubview:preTag];
            
            UILabel *modelLabel = [[UILabel alloc] init];
            modelLabel.text = currentObj.title;
            modelLabel.font = KSystemFontSize10;
            modelLabel.numberOfLines = 0;
            [modelLabel sizeToFit];
            modelLabel.textAlignment = NSTextAlignmentLeft;
            modelLabel.textColor = [UIColor CMLBlackColor];
            modelLabel.backgroundColor = [UIColor whiteColor];
            
            [modelView addSubview:modelLabel];
            
            UILabel *modelPriceLabel = [[UILabel alloc] init];
            modelPriceLabel.font = KSystemBoldFontSize14;
            modelPriceLabel.backgroundColor = [UIColor whiteColor];
            modelPriceLabel.textAlignment = NSTextAlignmentCenter;
            modelPriceLabel.text = [NSString stringWithFormat:@"￥%@",currentObj.price];
            modelPriceLabel.textColor = [UIColor CMLBrownColor];
            [modelPriceLabel sizeToFit];
            
            if (modelLabel.frame.size.width > modelImage.frame.size.width) {
                
                modelLabel.frame = CGRectMake(modelImage.frame.origin.x,
                                              CGRectGetMaxY(modelImage.frame) + 25*Proportion,
                                              modelImage.frame.size.width,
                                              modelLabel.frame.size.height*2);
                
                modelPriceLabel.frame = CGRectMake(modelImage.frame.origin.x,
                                                   CGRectGetMaxY(modelLabel.frame) + 20*Proportion,
                                                   modelPriceLabel.frame.size.width,
                                                   modelPriceLabel.frame.size.height);
            }else{
                
                modelLabel.frame = CGRectMake(modelImage.frame.origin.x,
                                              CGRectGetMaxY(modelImage.frame) + 25*Proportion,
                                              modelImage.frame.size.width,
                                              modelLabel.frame.size.height);
                
                modelPriceLabel.frame = CGRectMake(modelImage.frame.origin.x,
                                                   CGRectGetMaxY(modelLabel.frame) + modelLabel.frame.size.height  + 20*Proportion,
                                                   modelPriceLabel.frame.size.width,
                                                   modelPriceLabel.frame.size.height);
            }
            
            [modelView addSubview:modelPriceLabel];
            
            PackDetailInfoObj *costObj = [PackDetailInfoObj getBaseObjFrom:[currentObj.packageInfo.dataList firstObject]];
            
            if ([costObj.payMode intValue] == 1) {
                
                UILabel *promLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(modelPriceLabel.frame) + 10*Proportion,
                                                                             modelPriceLabel.center.y - 30*Proportion/2.0,
                                                                             50*Proportion,
                                                                             30*Proportion)];
                promLab.font = KSystemFontSize10;
                promLab.backgroundColor = [UIColor CMLNewbgBrownColor];
                promLab.textColor = [UIColor CMLWhiteColor];
                promLab.textAlignment = NSTextAlignmentCenter;
                promLab.text = @"订金";
                [modelView addSubview:promLab];
                
            }
            
            if ([costObj.is_pre intValue] == 1) {
                
                preTag.hidden = NO;
            }else{
                
                preTag.hidden = YES;
            }
            
            modelView.frame = CGRectMake(currentX,
                                         currentY,
                                         210*Proportion,
                                         CGRectGetMaxY(modelPriceLabel.frame));
            
            UIButton *modelBtn = [[UIButton alloc] initWithFrame:modelView.bounds];
            modelBtn.tag = i + 1 - self.obj.retData.RelateQuality.goods.dataList.count;
            modelBtn.backgroundColor = [UIColor clearColor];
            [modelView addSubview:modelBtn];
            [modelBtn addTarget:self action:@selector(enterModuleProjectRecommVC:) forControlEvents:UIControlEventTouchUpInside];
            
            
            if (i%3 == 2) {
                
                currentX = (WIDTH - 210*Proportion*3)/4;
                currentY = currentY + modelView.frame.size.height + 40*Proportion;
                
            }else{
                
                
                currentX += (210*Proportion + (WIDTH - 210*Proportion*3)/4);
            }

            
            if (i == (self.obj.retData.RelateQuality.goods.dataList.count + self.obj.retData.RelateQuality.project.dataList.count) - 1) {
                
                self.goodsBgView.frame = CGRectMake(0,
                                                    0,
                                                    WIDTH, CGRectGetMaxY(modelView.frame) + 40*Proportion);
            }
        }
    }
}

- (void) enterModuleGoodsVC:(UIButton *)button{
    
    CMLModuleObj *obj = [CMLModuleObj getBaseObjFrom:self.obj.retData.RelateQuality.goods.dataList[button.tag - 1]];
    
    CMLCommodityDetailMessageVC *vc =[[CMLCommodityDetailMessageVC alloc] initWithObjId:obj.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

//- (void) loadServeView{
//
//
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion, 20*Proportion, 4*Proportion, 28*Proportion)];
//    lineView.backgroundColor = [UIColor CMLBrownColor];
//    [self.serveBgView addSubview:lineView];
//
//    UILabel *titleLab = [[UILabel alloc] init];
//    titleLab.font = KSystemBoldFontSize14;
//    titleLab.text = @"服务";
//    [titleLab sizeToFit];
//    titleLab.frame = CGRectMake(CGRectGetMaxX(lineView.frame) + 10*Proportion,
//                                lineView.center.y - titleLab.frame.size.height/2.0,
//                                titleLab.frame.size.width,
//                                titleLab.frame.size.height);
//    [self.serveBgView addSubview:titleLab];
//
//
//
//    CGFloat currentX = (WIDTH - 330*Proportion*2)/3;
//    CGFloat currentY = 68*Proportion;
//    for (int i = 0; i < self.obj.retData.RelateQuality.project.dataList.count ; i++) {
//
//        CMLModuleObj *currentObj = [CMLModuleObj getBaseObjFrom:self.obj.retData.RelateQuality.project.dataList[i]];
//
//        UIView *modelView = [[UIView alloc] initWithFrame:CGRectMake(currentX, currentY, 210*Proportion, 0)];
//        [self.serveBgView addSubview:modelView];
//
//        UIImageView *modelImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,
//                                                                                0,
//                                                                                330*Proportion,
//                                                                                220*Proportion)];
//        modelImage.clipsToBounds = YES;
//        modelImage.contentMode = UIViewContentModeScaleAspectFill;
//        modelImage.backgroundColor = [UIColor CMLPromptGrayColor];
//        modelImage.userInteractionEnabled = YES;
//        [modelView addSubview:modelImage];
//        [NetWorkTask setImageView:modelImage WithURL:currentObj.coverPicThumb placeholderImage:nil];
//
//        UILabel *preTag = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 66*Proportion, 40*Proportion)];
//        preTag.backgroundColor = [UIColor CMLBlackColor];
//        preTag.textColor = [UIColor CMLBrownColor];
//        preTag.font = KSystemFontSize11;
//        preTag.text = @"预售";
//        preTag.textAlignment = NSTextAlignmentCenter;
//        [modelImage addSubview:preTag];
//
//        UILabel *modelLabel = [[UILabel alloc] init];
//        modelLabel.text = currentObj.title;
//        modelLabel.font = KSystemBoldFontSize13;
//        modelLabel.numberOfLines = 0;
//        [modelLabel sizeToFit];
//        modelLabel.textAlignment = NSTextAlignmentLeft;
//        modelLabel.textColor = [UIColor CMLBlackColor];
//        modelLabel.backgroundColor = [UIColor whiteColor];
//
//        [modelView addSubview:modelLabel];
//
//        UILabel *modelPriceLabel = [[UILabel alloc] init];
//        modelPriceLabel.font = KSystemRealBoldFontSize18;
//        modelPriceLabel.backgroundColor = [UIColor whiteColor];
//        modelPriceLabel.textAlignment = NSTextAlignmentCenter;
//        modelPriceLabel.text = [NSString stringWithFormat:@"￥%@",currentObj.price];
//        modelPriceLabel.textColor = [UIColor CMLBrownColor];
//        [modelPriceLabel sizeToFit];
//
//        if (modelLabel.frame.size.width > modelImage.frame.size.width) {
//
//            modelLabel.frame = CGRectMake(modelImage.frame.origin.x,
//                                          CGRectGetMaxY(modelImage.frame) + 25*Proportion,
//                                          modelImage.frame.size.width,
//                                          modelLabel.frame.size.height*2);
//
//            modelPriceLabel.frame = CGRectMake(modelImage.frame.origin.x,
//                                               CGRectGetMaxY(modelLabel.frame) + 20*Proportion,
//                                               modelPriceLabel.frame.size.width,
//                                               modelPriceLabel.frame.size.height);
//        }else{
//
//            modelLabel.frame = CGRectMake(modelImage.frame.origin.x,
//                                          CGRectGetMaxY(modelImage.frame) + 25*Proportion,
//                                          modelImage.frame.size.width,
//                                          modelLabel.frame.size.height);
//
//            modelPriceLabel.frame = CGRectMake(modelImage.frame.origin.x,
//                                               CGRectGetMaxY(modelLabel.frame) + modelLabel.frame.size.height  + 20*Proportion,
//                                               modelPriceLabel.frame.size.width,
//                                               modelPriceLabel.frame.size.height);
//        }
//
//        [modelView addSubview:modelPriceLabel];
//
//        PackDetailInfoObj *costObj = [PackDetailInfoObj getBaseObjFrom:[currentObj.packageInfo.dataList firstObject]];
//
//        if ([costObj.payMode intValue] == 1) {
//
//            UILabel *promLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(modelPriceLabel.frame) + 10*Proportion,
//                                                                         modelPriceLabel.center.y - 30*Proportion/2.0,
//                                                                         50*Proportion,
//                                                                         30*Proportion)];
//            promLab.font = KSystemFontSize10;
//            promLab.backgroundColor = [UIColor CMLNewbgBrownColor];
//            promLab.textColor = [UIColor CMLWhiteColor];
//            promLab.textAlignment = NSTextAlignmentCenter;
//            promLab.text = @"订金";
//            [modelView addSubview:promLab];
//
//        }
//
//        if ([costObj.is_pre intValue] == 1) {
//
//            preTag.hidden = NO;
//        }else{
//
//            preTag.hidden = YES;
//        }
//
//        modelView.frame = CGRectMake(currentX,
//                                     currentY,
//                                     330*Proportion,
//                                     CGRectGetMaxY(modelPriceLabel.frame) +30*Proportion);
//
//        UIButton *modelBtn = [[UIButton alloc] initWithFrame:modelView.bounds];
//        modelBtn.tag = i + 1;
//        modelBtn.backgroundColor = [UIColor clearColor];
//        [modelView addSubview:modelBtn];
//        [modelBtn addTarget:self action:@selector(enterModuleProjectRecommVC:) forControlEvents:UIControlEventTouchUpInside];
//
//
//        if (i%2 == 1) {
//            currentX = (WIDTH - 330*Proportion*2)/3;
//            currentY = currentY + modelView.frame.size.height + 30*Proportion;
//        }else{
//
//            currentX += (330*Proportion + (WIDTH - 330*Proportion*2)/3);
//        }
//
//        if (i == self.obj.retData.RelateQuality.project.dataList.count - 1) {
//
//            self.serveBgView.frame = CGRectMake(0, CGRectGetMaxY(self.goodsBgView.frame), WIDTH, CGRectGetMaxY(modelView.frame) + 40*Proportion);
//        }
//    }
//
//}

- (void) enterModuleProjectRecommVC:(UIButton *)button{
    
    CMLModuleObj *obj = [CMLModuleObj getBaseObjFrom:self.obj.retData.RelateQuality.project.dataList[button.tag - 1]];
    
    ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:obj.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}
@end
