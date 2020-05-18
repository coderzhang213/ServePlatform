//
//  CMLStoreRecommendGoodsView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/26.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLStoreRecommendGoodsView.h"
#import "BaseResultObj.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "BaseResultObj.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "CMLRecommendCommonModuleObj.h"
#import "ServeDefaultVC.h"
#import "VCManger.h"
#import "ModuleForGoods.h"
#import "CMLCommodityDetailMessageVC.h"

#define MainInterfaceLeftMargin              30
#define MainInterfaceOtherSpace              40

@interface CMLStoreRecommendGoodsView ()

@property (nonatomic,strong) NSMutableArray *currentArray;

@property (nonatomic,assign) int selectTag;

@property (nonatomic,strong) UIView *btnBgView;

@end

@implementation CMLStoreRecommendGoodsView

- (NSMutableArray *)currentArray{
    
    if (!_currentArray) {
        _currentArray = [NSMutableArray array];
    }
    return _currentArray;
}


- (instancetype)initWithObj:(BaseResultObj *) obj andName:(NSString *) name{
    
    self = [super init];
    
    if (self) {
//        if ([obj.retCode intValue] == 0) {
        
            if ([name isEqualToString:@"精选单品"]) {
                
                self.currentArray = [NSMutableArray arrayWithArray:obj.retData.ModuleForGoods.dataList];
            }else{
                self.currentArray = [NSMutableArray arrayWithArray:obj.retData.NewForGoods.dataList];
            }
        
            [self loadViewsWith:obj and:name];
            
//        }else{
//
//            self.currentHeight = 0;
//            self.hidden = YES;
//        }
    }
    
    return self;
    
}

- (void) loadViewsWith:(BaseResultObj *) obj and:(NSString *) name{
    
    
    if (self.currentArray.count == 0 ) {
        
        if ([name isEqualToString:@"最新上架"]) {
            
            UILabel *promName = [[UILabel alloc] init];
            promName.backgroundColor = [UIColor whiteColor];
            promName.text = @"全部单品";
            promName.layer.masksToBounds = YES;
            promName.font =KSystemRealBoldFontSize17;
            [promName sizeToFit];
            promName.frame = CGRectMake(30*Proportion,
                                        30*Proportion,
                                        promName.frame.size.width,
                                        promName.frame.size.height);
            [self addSubview:promName];
            
            self.btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      CGRectGetMaxY(promName.frame),
                                                                      WIDTH,
                                                                      100*Proportion)];
            self.btnBgView.backgroundColor = [UIColor CMLWhiteColor];
            [self addSubview:self.btnBgView];
            
             [self setServeSelectBtnView];
            
            self.currentHeight = CGRectGetMaxY(self.btnBgView.frame) + 30*Proportion;
            
        }else{
            
            self.currentHeight = 0;
            self.hidden = YES;
        }
        
    }else{
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        UILabel *promName = [[UILabel alloc] init];
        promName.backgroundColor = [UIColor whiteColor];
        promName.text = name;
        promName.layer.masksToBounds = YES;
        promName.font =KSystemRealBoldFontSize17;
        [promName sizeToFit];
        promName.frame = CGRectMake(30*Proportion,
                                    0,
                                    promName.frame.size.width,
                                    promName.frame.size.height);
        [bgView addSubview:promName];


        UIScrollView *promScrollView = [[UIScrollView alloc] init];
        promScrollView.showsVerticalScrollIndicator = NO;
        promScrollView.showsHorizontalScrollIndicator = NO;
        [bgView addSubview:promScrollView];
    
    
    for (int i = 0; i < self.currentArray.count; i++) {
        
        
        CMLModuleObj *currentObj = [CMLModuleObj getBaseObjFrom:self.currentArray[i]];
        
        UIView *modelView = [[UIView alloc] init];
        modelView.backgroundColor = [UIColor whiteColor];
        [promScrollView addSubview:modelView];
    
        UIView *modelBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       280*Proportion + 30*Proportion,
                                                                       280*Proportion + 30*Proportion)];
        modelBgView.layer.shadowColor = [UIColor blackColor].CGColor;
        modelBgView.layer.shadowOpacity = 0.05;
        modelBgView.layer.shadowOffset = CGSizeMake(0, 0);
        [modelView addSubview:modelBgView];
        
        UIImageView *modelImage = [[UIImageView alloc] initWithFrame:CGRectMake(15*Proportion,
                                                                                15*Proportion,
                                                                                280*Proportion,
                                                                                280*Proportion)];
        modelImage.clipsToBounds = YES;
        modelImage.contentMode = UIViewContentModeScaleAspectFill;
        modelImage.backgroundColor = [UIColor CMLWhiteColor];
        modelImage.userInteractionEnabled = YES;
        modelImage.layer.cornerRadius = 10*Proportion;
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
        
        UILabel *tagLab = [[UILabel alloc] init];
        tagLab.font = KSystemFontSize10;
        tagLab.textColor = [UIColor CMLLightBrownColor];
        
        if (currentObj.brandName.length > 0) {
            tagLab.text = currentObj.brandName;
            tagLab.textAlignment = NSTextAlignmentCenter;
            tagLab.layer.borderWidth = 1*Proportion;
            tagLab.layer.borderColor = [UIColor CMLLightBrownColor].CGColor;
        }else {
            tagLab.text = @" ";
        }

        
        [tagLab sizeToFit];
        tagLab.frame = CGRectMake(15*Proportion,
                                  CGRectGetMaxY(modelBgView.frame) + 5*Proportion,
                                  tagLab.frame.size.width + 10*Proportion,
                                  tagLab.frame.size.height + 5*Proportion);
        [modelView addSubview:tagLab];
        
        
        UILabel *modelLabel = [[UILabel alloc] init];
        modelLabel.text = currentObj.title;
        modelLabel.font = KSystemBoldFontSize13;
        modelLabel.numberOfLines = 0;
        [modelLabel sizeToFit];
        modelLabel.textAlignment = NSTextAlignmentLeft;
        modelLabel.textColor = [UIColor CMLBlackColor];
        modelLabel.backgroundColor = [UIColor clearColor];
        modelLabel.contentMode = UIViewContentModeTop;
        [modelView addSubview:modelLabel];
        
        UILabel *modelPriceLabel = [[UILabel alloc] init];
        modelPriceLabel.font = KSystemBoldFontSize17;
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
                                          CGRectGetMaxY(tagLab.frame) + 14*Proportion,
                                          modelImage.frame.size.width,
                                          modelLabel.frame.size.height*2);
            
            modelPriceLabel.frame = CGRectMake(15*Proportion,
                                               CGRectGetMaxY(modelLabel.frame) + 20*Proportion,
                                               modelPriceLabel.frame.size.width,
                                               modelPriceLabel.frame.size.height);
        }else{
            
            modelLabel.frame = CGRectMake(modelImage.frame.origin.x,
                                          CGRectGetMaxY(tagLab.frame) + 14*Proportion,
                                          modelImage.frame.size.width,
                                          modelLabel.frame.size.height);
            
            modelPriceLabel.frame = CGRectMake(15*Proportion,
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
            promLab.layer.cornerRadius = 6*Proportion;
            promLab.clipsToBounds = YES;
            promLab.backgroundColor = [UIColor CMLBrownColor];
            promLab.textColor = [UIColor CMLWhiteColor];
            promLab.textAlignment = NSTextAlignmentCenter;
            promLab.text = @"订金";
            [modelView addSubview:promLab];
            
        }
        
        
        modelView.frame = CGRectMake(15*Proportion + (280*Proportion + 30*Proportion)*i,
                                     15*Proportion,
                                     280*Proportion + 15*Proportion*2,
                                     CGRectGetMaxY(modelPriceLabel.frame));
        
        UIButton *modelBtn = [[UIButton alloc] initWithFrame:modelView.bounds];
        modelBtn.tag = i + 1;
        modelBtn.backgroundColor = [UIColor clearColor];
        [modelView addSubview:modelBtn];
        [modelBtn addTarget:self action:@selector(enterModuleProjectRecommVC:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == self.currentArray.count - 1) {
            
            promScrollView.frame = CGRectMake(0,
                                              CGRectGetMaxY(promName.frame),
                                              WIDTH,
                                              CGRectGetMaxY(modelView.frame) + 30*Proportion);
            promScrollView.contentSize = CGSizeMake(CGRectGetMaxX(modelView.frame) + 30*Proportion,
                                                    promScrollView.frame.size.height);
            
            
            CMLLine *bottomLine = [[CMLLine alloc] init];
            bottomLine.startingPoint = CGPointMake(MainInterfaceLeftMargin*Proportion, CGRectGetMaxY(promScrollView.frame) + 30*Proportion);
            bottomLine.lineWidth = 1*Proportion;
            bottomLine.LineColor = [UIColor CMLNewGrayColor];
            bottomLine.lineLength = WIDTH - 2*MainInterfaceLeftMargin*Proportion;
            [bgView addSubview:bottomLine];
            
            if ([name isEqualToString:@"最新上架"]) {
                
                UILabel *promName = [[UILabel alloc] init];
                promName.backgroundColor = [UIColor whiteColor];
                promName.text = @"全部单品";
                promName.layer.masksToBounds = YES;
                promName.font =KSystemRealBoldFontSize17;
                [promName sizeToFit];
                promName.frame = CGRectMake(30*Proportion,
                                            CGRectGetMaxY(promScrollView.frame) + 60*Proportion,
                                            promName.frame.size.width,
                                            promName.frame.size.height);
                [bgView addSubview:promName];
                
                self.btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                          CGRectGetMaxY(promName.frame),
                                                                          WIDTH,
                                                                          100*Proportion)];
                self.btnBgView.backgroundColor = [UIColor CMLWhiteColor];
                [self addSubview:self.btnBgView];
                
                 [self setServeSelectBtnView];
                
                bgView.frame = CGRectMake(0,
                                          0,
                                          WIDTH,
                                          CGRectGetMaxY(self.btnBgView.frame) + 30*Proportion);
                
            }else{
                
                bgView.frame = CGRectMake(0,
                                          0,
                                          WIDTH,
                                          CGRectGetMaxY(promScrollView.frame) + 20*Proportion);
            }
            
            self.currentHeight = bgView.frame.size.height;
           
        }
        
    }
    }
    
}

- (void) enterModuleProjectRecommVC:(UIButton *)button{
    
    CMLModuleObj *obj = [CMLModuleObj getBaseObjFrom:self.currentArray[button.tag - 1]];
    
    CMLCommodityDetailMessageVC *vc =[[CMLCommodityDetailMessageVC alloc] initWithObjId:obj.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) setServeSelectBtnView{
    
    
    [self.btnBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                self.btnBgView.frame.size.height - 1*Proportion,
                                                                WIDTH - 30*Proportion*2,
                                                                1*Proportion)];
    lineView.backgroundColor = [UIColor CMLSerachLineGrayColor];
    [self.btnBgView addSubview:lineView];
    
    NSArray *titleArray = @[@"默认",@"最新",@"价格"];
    
    for (int i = 0; i < 3; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/3.0*i,
                                                                   0,
                                                                   WIDTH/3.0,
                                                                   100*Proportion)];
        btn.tag = i;
        btn.titleLabel.font = KSystemFontSize15;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor CMLDarkOrangeColor] forState:UIControlStateSelected];
        [self.btnBgView addSubview:btn];
        
        
        if (btn.tag < 2) {
            
            if (btn.tag == self.selectTag) {
                
                btn.selected = YES;
                
            }else{
                
                btn.selected = NO;
                
            }
            
            
        }else{
            
            if (btn.tag <= self.selectTag) {
                
                if (self.selectTag == 2) {
                    
                    [btn setImage:[UIImage imageNamed:PriceVerbUpImg] forState:UIControlStateSelected];
                    
                }else if (self.selectTag == 3){
                    
                    [btn setImage:[UIImage imageNamed:PriceVerbDownImg] forState:UIControlStateSelected];
                }
                
                btn.selected = YES;
                
            }else{
                
                btn.selected = NO;
                
                [btn setImage:[UIImage imageNamed:PriceVerbDefaultImg] forState:UIControlStateNormal];
            }
            
            CGSize strSize2 = [btn.currentTitle sizeWithFontCompatible:KSystemFontSize15];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0,
                                                     - btn.currentImage.size.width - 30*Proportion,
                                                     0,
                                                     0)];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0,
                                                     strSize2.width + btn.currentImage.size.width + 30*Proportion,
                                                     0,
                                                     0)];
            
            
        }
        
        [btn addTarget:self action:@selector(changeBtnState:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}

- (void) changeBtnState:(UIButton *) btn{
    
    if (btn.tag < 2) {
        
        self.selectTag = (int)btn.tag;
    }else{
        
        
        if (self.selectTag == 2) {
            
            self.selectTag = 3;
        }else{
            
            self.selectTag = 2;
        }
        
    }
    
    [self setServeSelectBtnView];
    [self.delegate goodsPriceVerbWithSign:self.selectTag];
}

@end
