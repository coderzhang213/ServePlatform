//
//  CMLStoreRecommendServeView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/26.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLStoreRecommendServeView.h"
#import "BaseResultObj.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "BaseResultObj.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "CMLRecommendCommonModuleObj.h"
#import "ServeDefaultVC.h"
#import "VCManger.h"
#import "ModuleForProject.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"

#define MainInterfaceLeftMargin              30
#define MainInterfaceOtherSpace              30

@interface CMLStoreRecommendServeView ()


@property (nonatomic,strong) NSMutableArray *currentArray;

@property (nonatomic,strong) UIView *btnBgView;

@property (nonatomic,assign) int selectTag;

@end

@implementation CMLStoreRecommendServeView

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
        
            if ([name isEqualToString:@"精选服务"]) {
                self.currentArray = [NSMutableArray arrayWithArray:obj.retData.ModuleForProject.dataList];
            }else{
                self.currentArray = [NSMutableArray arrayWithArray:obj.retData.NewForProject.dataList];
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
            promName.text = @"全部服务";
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
            
             self.currentHeight = CGRectGetMaxY(self.btnBgView.frame);
            
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
                                30*Proportion,
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
        modelView.backgroundColor = [UIColor CMLWhiteColor];
        [promScrollView addSubview:modelView];
        modelView.layer.shadowColor = [UIColor blackColor].CGColor;
        modelView.layer.shadowOpacity = 0.05;
        modelView.layer.shadowOffset = CGSizeMake(0, 0);
        
        UIImageView *modelImage = [[UIImageView alloc] initWithFrame:CGRectMake(20*Proportion,
                                                                                20*Proportion,
                                                                                510*Proportion,
                                                                                340*Proportion)];
        modelImage.clipsToBounds = YES;
        modelImage.contentMode = UIViewContentModeScaleAspectFill;
        modelImage.backgroundColor = [UIColor CMLPromptGrayColor];
        modelImage.userInteractionEnabled = YES;
        modelImage.layer.cornerRadius = 10*Proportion;
        [modelView addSubview:modelImage];
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
        tagLab.text = currentObj.sponsor;
        tagLab.textAlignment = NSTextAlignmentCenter;
        tagLab.layer.borderWidth = 1*Proportion;
        tagLab.layer.borderColor = [UIColor CMLLightBrownColor].CGColor;
        [tagLab sizeToFit];
        tagLab.frame = CGRectMake(20*Proportion,
                                  CGRectGetMaxY(modelImage.frame) + 20*Proportion,
                                  tagLab.frame.size.width + 10*Proportion,
                                  tagLab.frame.size.height + 5*Proportion);
        [modelView addSubview:tagLab];
        
        UILabel *tagLab1 = [[UILabel alloc] init];
        tagLab1.font = KSystemFontSize10;
        tagLab1.textColor = [UIColor CMLLightBrownColor];
        tagLab1.text = currentObj.parentTypeName;
        tagLab1.textAlignment = NSTextAlignmentCenter;
        tagLab1.layer.borderWidth = 1*Proportion;
        tagLab1.layer.borderColor = [UIColor CMLLightBrownColor].CGColor;
        [tagLab1 sizeToFit];
        tagLab1.frame = CGRectMake(CGRectGetMaxX(tagLab.frame) + 20*Proportion,
                                  CGRectGetMaxY(modelImage.frame) + 20*Proportion,
                                  tagLab1.frame.size.width + 10*Proportion,
                                  tagLab1.frame.size.height + 5*Proportion);
        [modelView addSubview:tagLab1];
        
        UILabel *modelLabel = [[UILabel alloc] init];
        modelLabel.text = currentObj.title;
        modelLabel.font = KSystemBoldFontSize15;
        modelLabel.numberOfLines = 0;
        [modelLabel sizeToFit];
        modelLabel.textAlignment = NSTextAlignmentLeft;
        modelLabel.textColor = [UIColor CMLBlackColor];
        modelLabel.backgroundColor = [UIColor whiteColor];

        [modelView addSubview:modelLabel];
        
        UILabel *modelPriceLabel = [[UILabel alloc] init];
        modelPriceLabel.font = KSystemRealBoldFontSize18;
        modelPriceLabel.backgroundColor = [UIColor whiteColor];
        modelPriceLabel.textAlignment = NSTextAlignmentCenter;
        modelPriceLabel.text = [NSString stringWithFormat:@"￥%@",currentObj.price];
        modelPriceLabel.textColor = [UIColor CMLBrownColor];
        [modelPriceLabel sizeToFit];
        
        if (modelLabel.frame.size.width > modelImage.frame.size.width) {
          
            modelLabel.frame = CGRectMake(modelImage.frame.origin.x,
                                          CGRectGetMaxY(tagLab1.frame) + 14*Proportion,
                                          modelImage.frame.size.width,
                                          modelLabel.frame.size.height*2);
            
            modelPriceLabel.frame = CGRectMake(modelImage.frame.origin.x,
                                               CGRectGetMaxY(modelLabel.frame) + 20*Proportion,
                                               modelPriceLabel.frame.size.width,
                                               modelPriceLabel.frame.size.height);
        }else{
            
            modelLabel.frame = CGRectMake(modelImage.frame.origin.x,
                                          CGRectGetMaxY(tagLab1.frame) + 14*Proportion,
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
            promLab.layer.cornerRadius = 6*Proportion;
            promLab.clipsToBounds = YES;
            promLab.backgroundColor = [UIColor CMLBrownColor];
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
        
        modelView.frame = CGRectMake(30*Proportion + (550*Proportion + 30*Proportion)*i,
                                     30*Proportion,
                                     550*Proportion,
                                     CGRectGetMaxY(modelPriceLabel.frame) +30*Proportion);
        
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
            bottomLine.startingPoint = CGPointMake(MainInterfaceLeftMargin*Proportion, CGRectGetMaxY(promScrollView.frame) + 1*Proportion);
            bottomLine.lineWidth = 1*Proportion;
            bottomLine.LineColor = [UIColor CMLNewGrayColor];
            bottomLine.lineLength = WIDTH - 2*MainInterfaceLeftMargin*Proportion;
            [bgView addSubview:bottomLine];
            
            
            if ([name isEqualToString:@"最新上架"]) {
                
                UILabel *promName = [[UILabel alloc] init];
                promName.backgroundColor = [UIColor whiteColor];
                promName.text = @"全部服务";
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
                                          CGRectGetMaxY(self.btnBgView.frame) + 10*Proportion);
                
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
    
    ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:obj.currentID];
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
    [self.delegate priceVerbWithSign:self.selectTag];
}
@end
