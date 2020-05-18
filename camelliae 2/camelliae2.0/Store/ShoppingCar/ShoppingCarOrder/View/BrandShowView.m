//
//  BrandShowView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/8.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BrandShowView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "CMLShoppingCarBrandObj.h"
#import "GoodsModuleDetailMesObj.h"

@interface BrandShowView ()

@property (nonatomic,strong) NSMutableArray *targetArray;

@property (nonatomic,assign) int totalMoney;

@property (nonatomic,assign) int points;

@property (nonatomic,assign) int num;

@property (nonatomic,strong) UILabel *ponitsNumlab;

@property (nonatomic, strong) BaseResultObj *carOrderBaseObj;

@end

@implementation BrandShowView

- (NSMutableArray *)targetArray{
    
    if (!_targetArray) {
        _targetArray = [NSMutableArray array];
    }
    return _targetArray;
}

- (instancetype)initWithSource:(NSArray *) sourceArray andSelectArray:(NSArray *) selectArray withBaseObj:(BaseResultObj *)baseObj{
    
    self = [super init];
    
    if (self) {
        self.carOrderBaseObj = baseObj;
        /***数据处理*/
        for (int i = 0; i < sourceArray.count; i++) {
            
            CMLShoppingCarBrandObj *tempObj = [CMLShoppingCarBrandObj getBaseObjFrom:sourceArray[i]];
            
            for (int j = 0; j < selectArray.count; j++) {
                
                if ([tempObj.carId intValue] == [selectArray[j] intValue]) {
                    
                    [self.targetArray addObject:sourceArray[i]];
   
                }
            }
        }

        self.points = 0;
        self.totalMoney = 0;
        self.num = 0;
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    UILabel *promLab = [[UILabel alloc] init];
    promLab.font = KSystemFontSize12;
    promLab.textColor = [UIColor CMLLineGrayColor];
    promLab.text = @"商品信息";
    [promLab sizeToFit];
    promLab.frame = CGRectMake(30*Proportion,
                               30*Proportion,
                               promLab.frame.size.width,
                               promLab.frame.size.height);
    [self addSubview:promLab];
    
    UIView *lineOne = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                               74*Proportion,
                                                               WIDTH - 30*Proportion*2,
                                                               1*Proportion)];
    lineOne.backgroundColor = [UIColor CMLNewGrayColor];
    [self addSubview:lineOne];
    
    CGFloat currentHeight = 75*Proportion;
    for (int i = 0; i < self.targetArray.count; i++) {
        
        CMLShoppingCarBrandObj *obj = [CMLShoppingCarBrandObj getBaseObjFrom:self.targetArray[i]];
        
        UIView *moduleView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      currentHeight + 200*Proportion*i,
                                                                      WIDTH,
                                                                      200*Proportion)];
        moduleView.backgroundColor = [UIColor CMLWhiteColor];
        [self addSubview:moduleView];
        
        UIImageView *moduleImage = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion, 30*Proportion, 160*Proportion, 160*Proportion)];
        moduleImage.backgroundColor = [UIColor CMLNewGrayColor];
        moduleImage.clipsToBounds = YES;
        moduleImage.contentMode = UIViewContentModeScaleAspectFill;
        [moduleView addSubview:moduleImage];
        [NetWorkTask setImageView:moduleImage WithURL:obj.projectInfo.coverPic placeholderImage:nil];
        
        UILabel *nameLab = [[UILabel alloc] init];
        nameLab.font = KSystemBoldFontSize13;
        nameLab.textColor = [UIColor CMLBlackColor];
        nameLab.numberOfLines= 2;
        nameLab.textAlignment = NSTextAlignmentLeft;
        nameLab.text = obj.projectInfo.title;
        [nameLab sizeToFit];
        if (nameLab.frame.size.width > WIDTH - 160*Proportion - 30*Proportion - 20*Proportion - 30*Proportion) {
            
            nameLab.frame = CGRectMake(CGRectGetMaxX(moduleImage.frame) +20*Proportion,
                                       30*Proportion,
                                       WIDTH - 160*Proportion - 30*Proportion - 20*Proportion - 30*Proportion,
                                       nameLab.frame.size.height*2);
        }else{
            
            nameLab.frame = CGRectMake(CGRectGetMaxX(moduleImage.frame) +20*Proportion,
                                       30*Proportion,
                                       WIDTH - 160*Proportion - 30*Proportion - 20*Proportion - 30*Proportion,
                                       nameLab.frame.size.height);
        }
        [moduleView addSubview:nameLab];
        
        UILabel *tagLab = [[UILabel alloc] init];
        tagLab.font = KSystemBoldFontSize10;
        tagLab.textColor = [UIColor CMLtextInputGrayColor];
        [moduleView addSubview:tagLab];
        
        UILabel *priceLab = [[UILabel alloc] init];
        priceLab.textColor = [UIColor CMLBrownColor];
        priceLab.font = KSystemRealBoldFontSize14;
        [moduleView addSubview:priceLab];
        
        UILabel *pricePromLab = [[UILabel alloc] init];
        pricePromLab.textColor = [UIColor CMLBrownColor];
        pricePromLab.font = KSystemBoldFontSize10;
        [moduleView addSubview:pricePromLab];
        
        UILabel *numLab = [[UILabel alloc] init];
        numLab.textColor = [UIColor CMLtextInputGrayColor];
        numLab.font = KSystemFontSize14;
        numLab.text = [NSString stringWithFormat:@"x %@",obj.goodNum];
        [numLab sizeToFit];
        numLab.frame = CGRectMake(WIDTH - 30*Proportion - numLab.frame.size.width,
                                  CGRectGetMaxY(moduleImage.frame) - numLab.frame.size.height,
                                  numLab.frame.size.width,
                                  numLab.frame.size.height);
        [moduleView addSubview:numLab];
        
        self.num += [obj.goodNum intValue];
        
        if ([obj.objType intValue] == 3) {
            
            tagLab.hidden = YES;
            
            if ([obj.packageInfo.payMode intValue] == 1) {
                
                priceLab.text = [NSString stringWithFormat:@"¥%@",obj.packageInfo.subscription];
                [priceLab sizeToFit];
                priceLab.frame = CGRectMake(CGRectGetMaxX(moduleImage.frame) + 20*Proportion,
                                            CGRectGetMaxY(moduleImage.frame) - priceLab.frame.size.height,
                                            priceLab.frame.size.width,
                                            priceLab.frame.size.height);
                pricePromLab.text = @"（订金）";
                [pricePromLab sizeToFit];
                pricePromLab.frame = CGRectMake(CGRectGetMaxX(priceLab.frame),
                                                priceLab.center.y - pricePromLab.frame.size.height/2.0,
                                                pricePromLab.frame.size.width,
                                                pricePromLab.frame.size.height);
                
                self.totalMoney += [obj.goodNum intValue]*[obj.packageInfo.subscription intValue];
                
            }else{
                
                priceLab.text = [NSString stringWithFormat:@"¥%@",obj.packageInfo.totalAmount];
                [priceLab sizeToFit];
                priceLab.frame = CGRectMake(CGRectGetMaxX(moduleImage.frame) + 20*Proportion,
                                                 CGRectGetMaxY(moduleImage.frame) - priceLab.frame.size.height,
                                                 priceLab.frame.size.width,
                                                 priceLab.frame.size.height);
                
                self.totalMoney += [obj.goodNum intValue]*[obj.packageInfo.totalAmount intValue];
                
                /*如果存在折扣价*/
                if ([self.carOrderBaseObj.retData.isEnjoyDiscount intValue] == 1) {
                    if (obj.projectInfo.is_discount) {
                        if ([obj.projectInfo.is_discount intValue] == 1) {
                            if ([obj.packageInfo.discount intValue] != 0) {
                                priceLab.text = [NSString stringWithFormat:@"¥%@",obj.packageInfo.discount];
                                [priceLab sizeToFit];
                                priceLab.frame = CGRectMake(CGRectGetMaxX(moduleImage.frame) + 20*Proportion,
                                                            CGRectGetMaxY(moduleImage.frame) - priceLab.frame.size.height,
                                                            priceLab.frame.size.width,
                                                            priceLab.frame.size.height);
                                
                                self.totalMoney += [obj.goodNum intValue]*[obj.packageInfo.discount intValue] - [obj.goodNum intValue]*[obj.packageInfo.totalAmount intValue];

                            }
                        }
                    }
                }
            }
            
        }else if ([obj.objType intValue] == 7){
            
            NSMutableString *str = [[NSMutableString alloc] init];
            [str appendString:@"已选："];
            
            for (int j = 0; j < obj.packageInfo.unitsPropertyInfo.count; j++) {
                
                GoodsModuleDetailMesObj *detailObj = [GoodsModuleDetailMesObj getBaseObjFrom:obj.packageInfo.unitsPropertyInfo[j]];
                [str appendString:[NSString stringWithFormat:@"%@ ",detailObj.propertyValue]];
            }
            
            tagLab.hidden = NO;
            tagLab.text = str;
            [tagLab sizeToFit];
            tagLab.frame = CGRectMake(CGRectGetMaxX(moduleImage.frame) + 20*Proportion,
                                      CGRectGetMaxY(nameLab.frame) + 10*Proportion,
                                      tagLab.frame.size.width,
                                      tagLab.frame.size.height);
            

            pricePromLab.hidden = YES;
            
            if ([obj.packageInfo.is_pre intValue] == 1) {
               
                priceLab.text = [NSString stringWithFormat:@"¥%@",obj.packageInfo.pre_price];
                
            }else{
                
                priceLab.text = [NSString stringWithFormat:@"¥%@",obj.packageInfo.totalAmount];
            }
            
            [priceLab sizeToFit];
            priceLab.frame = CGRectMake(CGRectGetMaxX(moduleImage.frame) + 20*Proportion,
                                             CGRectGetMaxY(moduleImage.frame) - priceLab.frame.size.height,
                                             priceLab.frame.size.width,
                                             priceLab.frame.size.height);
            
            if ([obj.projectInfo.is_deposit intValue] == 1) {
                
                pricePromLab.hidden = NO;
                priceLab.text = [NSString stringWithFormat:@"¥%@",obj.projectInfo.deposit_money];
                [priceLab sizeToFit];
                priceLab.frame = CGRectMake(CGRectGetMaxX(moduleImage.frame) + 20*Proportion,
                                            CGRectGetMaxY(moduleImage.frame) - priceLab.frame.size.height,
                                            priceLab.frame.size.width,
                                            priceLab.frame.size.height);
                pricePromLab.text = @"（订金）";
                [pricePromLab sizeToFit];
                pricePromLab.frame = CGRectMake(CGRectGetMaxX(priceLab.frame),
                                                priceLab.center.y - pricePromLab.frame.size.height/2.0,
                                                pricePromLab.frame.size.width,
                                                pricePromLab.frame.size.height);
            }
            
            if ([obj.projectInfo.is_deposit intValue] == 1) {
               
                self.totalMoney += [obj.goodNum intValue]*[obj.projectInfo.deposit_money intValue];
               
            }else{
                
                self.totalMoney += [obj.goodNum intValue]*[obj.packageInfo.totalAmount intValue];
                
                /*如果存在折扣价*/
                if ([self.carOrderBaseObj.retData.isEnjoyDiscount intValue] == 1) {
                    if (obj.projectInfo.is_discount) {
                        if ([obj.projectInfo.is_discount intValue] == 1) {
                            if ([obj.packageInfo.discount intValue] != 0) {
                                priceLab.text = [NSString stringWithFormat:@"¥%@",obj.packageInfo.discount];
                                [priceLab sizeToFit];
                                priceLab.frame = CGRectMake(CGRectGetMaxX(moduleImage.frame) + 20*Proportion,
                                                            CGRectGetMaxY(moduleImage.frame) - priceLab.frame.size.height,
                                                            priceLab.frame.size.width,
                                                            priceLab.frame.size.height);
                                
                                self.totalMoney += [obj.goodNum intValue]*[obj.packageInfo.discount intValue] - [obj.goodNum intValue]*[obj.packageInfo.totalAmount intValue];
                            }
                        }
                    }
                }
            }
        }
        
        self.points += [obj.packageInfo.point intValue] * [obj.goodNum intValue];
        
        if (i == self.targetArray.count - 1) {
            
            /***/
            UIView *lineTwo = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                       CGRectGetMaxY(moduleView.frame) + 40*Proportion,
                                                                       WIDTH - 30*Proportion*2,
                                                                       1*Proportion)];
            lineTwo.backgroundColor = [UIColor CMLNewGrayColor];
            [self addSubview:lineTwo];
            
            UIView *moduleTwo = [[UIView alloc] init];
            moduleTwo.backgroundColor = [UIColor clearColor];
            moduleTwo.frame = CGRectMake(0,
                                         CGRectGetMaxY(moduleView.frame) + 40*Proportion,
                                         WIDTH,
                                         80*Proportion);
            [self addSubview:moduleTwo];
            
            UILabel *labTwo = [[UILabel alloc] init];
            labTwo.text = @"数量：";
            labTwo.font = KSystemFontSize13;
            labTwo.textColor = [UIColor CMLLineGrayColor];
            [labTwo sizeToFit];
            labTwo.frame = CGRectMake(30*Proportion, moduleTwo.frame.size.height/2.0 - labTwo.frame.size.height/2.0, labTwo.frame.size.width, labTwo.frame.size.height);
            [moduleTwo addSubview:labTwo];
            
            UILabel *totalNumlab = [[UILabel alloc] init];
            totalNumlab.text = [NSString stringWithFormat:@"x %d",self.num];
            totalNumlab.font = KSystemFontSize13;
            totalNumlab.textColor = [UIColor CMLLineGrayColor];
            [totalNumlab sizeToFit];
            totalNumlab.frame = CGRectMake(WIDTH - 30*Proportion - totalNumlab.frame.size.width,
                                           moduleTwo.frame.size.height/2.0 - totalNumlab.frame.size.height/2.0,
                                           totalNumlab.frame.size.width,
                                           totalNumlab.frame.size.height);
            [moduleTwo addSubview:totalNumlab];
            
            /***/
            UIView *lineThree = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                         CGRectGetMaxY(moduleTwo.frame),
                                                                         WIDTH - 30*Proportion*2,
                                                                         1*Proportion)];
            lineThree.backgroundColor = [UIColor CMLNewGrayColor];
            [self addSubview:lineThree];
            
            UIView *moduleThree = [[UIView alloc] init];
            moduleThree.backgroundColor = [UIColor clearColor];
            moduleThree.frame = CGRectMake(0,
                                         CGRectGetMaxY(moduleTwo.frame),
                                         WIDTH,
                                         80*Proportion);
            [self addSubview:moduleThree];
            
            UILabel *labThree = [[UILabel alloc] init];
            labThree.text = @"运费：";
            labThree.font = KSystemFontSize13;
            labThree.textColor = [UIColor CMLLineGrayColor];
            [labThree sizeToFit];
            labThree.frame = CGRectMake(30*Proportion,
                                        moduleThree.frame.size.height/2.0 - labThree.frame.size.height/2.0,
                                        labThree.frame.size.width,
                                        labThree.frame.size.height);
            [moduleThree addSubview:labThree];
            
            UILabel *freightNumlab = [[UILabel alloc] init];
            freightNumlab.text = @"0";
            freightNumlab.font = KSystemFontSize13;
            freightNumlab.textColor = [UIColor CMLLineGrayColor];
            [freightNumlab sizeToFit];
            freightNumlab.frame = CGRectMake(WIDTH - 30*Proportion - freightNumlab.frame.size.width,
                                           moduleThree.frame.size.height/2.0 - freightNumlab.frame.size.height/2.0,
                                           freightNumlab.frame.size.width,
                                           freightNumlab.frame.size.height);
            [moduleThree addSubview:freightNumlab];
            
            UIView *lineFive = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                         CGRectGetMaxY(moduleThree.frame),
                                                                         WIDTH - 30*Proportion*2,
                                                                         1*Proportion)];
            lineFive.backgroundColor = [UIColor CMLNewGrayColor];
            [self addSubview:lineFive];
            /***/
            UIView *moduleFive = [[UIView alloc] init];
            moduleFive.backgroundColor = [UIColor clearColor];
            moduleFive.frame = CGRectMake(0,
                                           CGRectGetMaxY(moduleThree.frame),
                                           WIDTH,
                                           80*Proportion);
            [self addSubview:moduleFive];
            
            UILabel *labFive = [[UILabel alloc] init];
            labFive.text = @"积分：";
            labFive.font = KSystemFontSize13;
            labFive.textColor = [UIColor CMLLineGrayColor];
            [labFive sizeToFit];
            labFive.frame = CGRectMake(30*Proportion,
                                        moduleFive.frame.size.height/2.0 - labFive.frame.size.height/2.0,
                                        labFive.frame.size.width,
                                        labFive.frame.size.height);
            [moduleFive addSubview:labFive];
            
            self.ponitsNumlab = [[UILabel alloc] init];
            self.ponitsNumlab.text = [NSString stringWithFormat:@"%d",self.points];
            self.ponitsNumlab.font = KSystemFontSize13;
            self.ponitsNumlab.textColor = [UIColor CMLLineGrayColor];
            [self.ponitsNumlab sizeToFit];
            self.ponitsNumlab.frame = CGRectMake(WIDTH - 30*Proportion - self.ponitsNumlab.frame.size.width,
                                             moduleFive.frame.size.height/2.0 - self.ponitsNumlab.frame.size.height/2.0,
                                             self.ponitsNumlab.frame.size.width,
                                             self.ponitsNumlab.frame.size.height);
            [moduleFive addSubview:self.ponitsNumlab];


            /***/
            UIView *lineFour = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                         CGRectGetMaxY(moduleFive.frame),
                                                                         WIDTH - 30*Proportion*2,
                                                                         1*Proportion)];
            lineFour.backgroundColor = [UIColor CMLNewGrayColor];
            [self addSubview:lineFour];
            
            UIView *moduleFour = [[UIView alloc] init];
            moduleFour.backgroundColor = [UIColor clearColor];
            moduleFour.frame = CGRectMake(0,
                                           CGRectGetMaxY(moduleFive.frame),
                                           WIDTH,
                                           100*Proportion);
            [self addSubview:moduleFour];
            
            UILabel *labFour = [[UILabel alloc] init];
            labFour.text = @"总计：";
            labFour.font = KSystemFontSize16;
            labFour.textColor = [UIColor CMLBlackColor];
            [labFour sizeToFit];
            labFour.frame = CGRectMake(30*Proportion,
                                       moduleFour.frame.size.height/2.0 - labFour.frame.size.height/2.0,
                                       labFour.frame.size.width,
                                       labFour.frame.size.height);
            [moduleFour addSubview:labFour];
            
            UILabel *totalMoneylab = [[UILabel alloc] init];
            totalMoneylab.text = [NSString stringWithFormat:@"¥ %d",self.totalMoney];
            totalMoneylab.font = KSystemFontSize16;
            totalMoneylab.textColor = [UIColor CMLBlackColor];
            [totalMoneylab sizeToFit];
            totalMoneylab.frame = CGRectMake(WIDTH - 30*Proportion - totalMoneylab.frame.size.width,
                                             moduleFour.frame.size.height/2.0 - totalMoneylab.frame.size.height/2.0,
                                             totalMoneylab.frame.size.width,
                                             totalMoneylab.frame.size.height);
            [moduleFour addSubview:totalMoneylab];
            
            
            self.tempTotalMoney = self.totalMoney;
            
            self.currentheight = CGRectGetMaxY(moduleFour.frame);
        }
    }
    
}

- (void) refreshPoints:(NSNumber *) point{
    
    self.ponitsNumlab.text = [NSString stringWithFormat:@"%@",point];
    [self.ponitsNumlab sizeToFit];
    self.ponitsNumlab.frame = CGRectMake(self.ponitsNumlab.frame.origin.x,
                                         self.ponitsNumlab.frame.origin.y,
                                         self.ponitsNumlab.frame.size.width,
                                         self.ponitsNumlab.frame.size.height);
}

- (void) refreshOldPoints{
    
    self.ponitsNumlab.text = [NSString stringWithFormat:@"%d",self.points];
    [self.ponitsNumlab sizeToFit];
    self.ponitsNumlab.frame = CGRectMake(self.ponitsNumlab.frame.origin.x,
                                         self.ponitsNumlab.frame.origin.y,
                                         self.ponitsNumlab.frame.size.width,
                                         self.ponitsNumlab.frame.size.height);
}
@end
