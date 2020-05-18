//
//  GoodsAttributeView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/7/11.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "GoodsAttributeView.h"
#import "CommonImg.h"
#import "NetWorkTask.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "GoodsModuleDetailMesObj.h"
#import "GoodsModuleObj.h"
#import "BaseResultObj.h"
#import "CMLLine.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"
#import "PackDetailInfoObj.h"

@interface GoodsAttributeView ()

@property (nonatomic,strong) UIImageView *goodsImage;

@property (nonatomic,strong) UIView *attributeBgView;

@property (nonatomic,strong) UIButton *buybtn;

@property (nonatomic,assign) int buyNum;

@property (nonatomic,strong) UILabel *buyNumLab;

@property (nonatomic,strong) NSMutableArray *attributeAry;

@property (nonatomic,strong) NSMutableArray *attributePackageAry;

@property (nonatomic,strong) NSMutableDictionary *selectDic;

@property (nonatomic,strong) NSMutableDictionary *oldSelectDic;

@property (nonatomic,strong) NSMutableArray *choosableAry;

@property (nonatomic,assign) CGFloat attributeOriginY;

@property (nonatomic,copy) NSString *currentParentUnitId;

@property (nonatomic,copy) NSString *currentGoodsUnitPropertyId;

@property (nonatomic,copy) NSString *packageID;

@property (nonatomic,strong) NSMutableDictionary *attributePackageStrDic;

@property (nonatomic, strong) UILabel *linePriceLabel;

@end

@implementation GoodsAttributeView

- (NSMutableArray *)attributeAry{

    
    if (!_attributeAry) {
        
        _attributeAry = [NSMutableArray array];
    }
    
    return _attributeAry;
}

- (NSMutableArray *)attributePackageAry{

    if (!_attributePackageAry) {
        
        _attributePackageAry = [NSMutableArray array];
    }
    
    return _attributePackageAry;
    
}

- (NSMutableDictionary *)selectDic{

    if (!_selectDic) {
        _selectDic = [NSMutableDictionary dictionary];
    }
    
    return _selectDic;
}

- (NSMutableArray *)choosableAry{

    if (!_choosableAry) {
        
        _choosableAry = [NSMutableArray array];
    }
    
    return _choosableAry;
}

- (NSMutableDictionary *)attributePackageStrDic{


    if (!_attributePackageStrDic) {
        
        _attributePackageStrDic = [NSMutableDictionary dictionary];
    }
    
    return _attributePackageStrDic;
}

- (NSMutableDictionary *)oldSelectDic{

    
    if (!_oldSelectDic) {
        _oldSelectDic = [NSMutableDictionary dictionary];
    }
    
    return _oldSelectDic;
}


- (instancetype) initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        self.buyNum = 1;
        [self loadViews];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [self loadData];
    [self loadAttributesMessage];
    [self loadGoodsImage];
}

- (void) loadGoodsImage{

    UIView *imageBgView = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                   CGRectGetMinY(self.attributeBgView.frame) - 40*Proportion - 10*Proportion,
                                                                   180*Proportion,
                                                                   180*Proportion)];
    imageBgView.backgroundColor = [UIColor CMLWhiteColor];
    [self addSubview:imageBgView];
    
    UIImageView *goodsImage = [[UIImageView alloc] initWithFrame:CGRectMake(10*Proportion, 10*Proportion, 160*Proportion, 160*Proportion)];
    goodsImage.clipsToBounds = YES;
    goodsImage.contentMode = UIViewContentModeScaleAspectFill;
    [NetWorkTask setImageView:goodsImage WithURL:self.obj.retData.coverPicThumb placeholderImage:nil];
    [imageBgView addSubview:goodsImage];
    
}

- (void) loadData{
    
    [self.attributeAry removeAllObjects];
    [self.attributePackageAry removeAllObjects];
    [self.selectDic removeAllObjects];
    
    /**所有属性*/
    [self.attributeAry addObjectsFromArray:self.obj.retData.goodsUnitsInfo];
    
    /**可选属性字典集合*/
    for (int i = 0; i < self.obj.retData.packageInfo.dataList.count; i++) {
       
        PackDetailInfoObj *detailObj = [PackDetailInfoObj getBaseObjFrom:self.obj.retData.packageInfo.dataList[i]];
        
        NSMutableDictionary *targetDic = [NSMutableDictionary dictionary];
        
        if ([detailObj.surplusStock intValue] > 0) {
            
         
            [targetDic setObject:detailObj.surplusStock forKey:@"surplusStock"];
            [targetDic setObject:detailObj.totalAmountStr forKey:@"price"];
            if ([self.obj.retData.is_deposit intValue] == 1) {
               [targetDic setObject:self.obj.retData.deposit_money forKey:@"price"];
            }
            /*4.2.0享受折扣时直接显示折扣价*/
            if ([self.obj.retData.isEnjoyDiscount intValue] == 1) {
                if ([self.obj.retData.is_discount intValue] == 1) {/*此处不用判断discount = 0*/
                    [targetDic setObject:detailObj.discount forKey:@"discountPrice"];
                }
            }
            
            [targetDic setObject:[NSString stringWithFormat:@"%@",detailObj.currentID] forKey:@"currentID"];
            
            for (int j = 0 ; j < detailObj.unitsPropertyInfo.count; j++) {
                
                GoodsModuleDetailMesObj *goodsDetailObj = [GoodsModuleDetailMesObj getBaseObjFrom:detailObj.unitsPropertyInfo[j]];
                
                [targetDic setObject:[NSString stringWithFormat:@"%@",goodsDetailObj.goodsUnitPropertyId]
                              forKey:[NSString stringWithFormat:@"%@",goodsDetailObj.parentUnitId]];
                
            }
            
            [self.attributePackageAry addObject:targetDic];
        }
    }
    

    for (int i = 0; i < self.attributePackageAry.count; i++) {
        
        NSDictionary *dic = self.attributePackageAry[i];
        
        
        NSMutableString *targetStr = [[NSMutableString alloc] init];
        for (int j = 0; j < self.attributeAry.count; j++) {
            
            GoodsModuleObj *obj = [GoodsModuleObj getBaseObjFrom:self.attributeAry[j]];
            
            NSString *str = [dic valueForKey:[NSString stringWithFormat:@"%@",obj.currentID]];
            
            [targetStr appendString:[NSString stringWithFormat:@"-%@",str]];
            
        }
        
        [self.attributePackageStrDic setObject:[dic valueForKey:@"currentID"] forKey:targetStr];
        
    }
    
    /**默认*/
    for (int i = 0; i < self.attributeAry.count; i++) {
        
        GoodsModuleObj *obj = [GoodsModuleObj getBaseObjFrom:self.attributeAry[i]];
        NSDictionary *dic = [self.attributePackageAry firstObject];
        
        [self.selectDic setObject:[dic valueForKey:[NSString stringWithFormat:@"%@",obj.currentID]]
                           forKey:[NSString stringWithFormat:@"%@",obj.currentID]];
    
        if (i == 0) {
            
            self.currentParentUnitId = [NSString stringWithFormat:@"%@",obj.currentID];
            self.currentGoodsUnitPropertyId = [dic valueForKey:[NSString stringWithFormat:@"%@",obj.currentID]];
            self.packageID = [dic valueForKey:@"currentID"];
            
        }
        
        if (self.attributeAry.count >2 && i <= self.attributeAry.count - 2) {
            
            [self.oldSelectDic setObject:[dic valueForKey:[NSString stringWithFormat:@"%@",obj.currentID]] forKey:[NSString stringWithFormat:@"%@",obj.currentID]];
            
        }
    }
    
   
}

- (void) loadViews{
    
    self.backgroundColor = [UIColor clearColor];
    [self loadAttributeBgView];

}

- (void) loadAttributeBgView{

    self.attributeBgView = [[UIView alloc] initWithFrame:self.bounds];
    self.attributeBgView.backgroundColor = [UIColor CMLWhiteColor];
    [self addSubview:self.attributeBgView];
    
    
    self.buybtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                             self.frame.size.height - 90*Proportion,
                                                             WIDTH,
                                                             90*Proportion)];
    self.buybtn.backgroundColor = [UIColor CMLGreeenColor];
    self.buybtn.titleLabel.font = KSystemBoldFontSize16;
    [self.buybtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.buybtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
    [self addSubview:self.buybtn];
    [self.buybtn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) loadAttributesMessage{

   
    self.buyNum = 1;
    [self.attributeBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self loadTopMessage];
    
    CGFloat currentHeight = self.attributeOriginY;
    for (int i = 0; i < self.attributeAry.count; i++) {
        
        GoodsModuleObj *obj = [GoodsModuleObj getBaseObjFrom:self.attributeAry[i]];
        
        UIView *moduleView = [self addAttributeBgViewWithDic:obj];
        moduleView.frame = CGRectMake(0,
                                      currentHeight,
                                      WIDTH,
                                      moduleView.frame.size.height);
        [self.attributeBgView addSubview:moduleView];
        currentHeight += moduleView.frame.size.height;
        
        if (i == self.attributeAry.count - 1) {
            
            UILabel *numberLab = [[UILabel alloc] init];
            numberLab.text = @"数量";
            numberLab.font = KSystemFontSize12;
            [numberLab sizeToFit];
            numberLab.frame = CGRectMake(30*Proportion,
                                         CGRectGetMaxY(moduleView.frame),
                                         numberLab.frame.size.width,
                                         numberLab.frame.size.height);
            [self.attributeBgView addSubview:numberLab];
            
            UIButton *reduceBtn = [[UIButton alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                             CGRectGetMaxY(numberLab.frame) + 20*Proportion,
                                                                             52*Proportion,
                                                                             52*Proportion)];
            reduceBtn.layer.cornerRadius = 10*Proportion;
            reduceBtn.layer.borderColor = [UIColor CMLtextInputGrayColor].CGColor;
            reduceBtn.layer.borderWidth = 2*Proportion;
            [reduceBtn setImage:[UIImage imageNamed:GoodsAttributeViewNumReduceImg] forState:UIControlStateNormal];
            [reduceBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
            [self.attributeBgView addSubview:reduceBtn];
            [reduceBtn addTarget:self action:@selector(reduceBuyNum) forControlEvents:UIControlEventTouchUpInside];
            
            if (!self.packageID) {
                
                reduceBtn.userInteractionEnabled = NO;
            }
            
            UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(reduceBtn.frame) + 81*Proportion,
                                                                          CGRectGetMaxY(numberLab.frame) + 20*Proportion,
                                                                          52*Proportion,
                                                                          52*Proportion)];
            addBtn.layer.cornerRadius = 10*Proportion;
            addBtn.layer.borderColor = [UIColor CMLtextInputGrayColor].CGColor;
            addBtn.layer.borderWidth = 2*Proportion;
            [addBtn setImage:[UIImage imageNamed:GoodsAttributeViewNumAddImg] forState:UIControlStateNormal];
            [addBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
            [self.attributeBgView addSubview:addBtn];
            [addBtn addTarget:self action:@selector(addBuyNumber) forControlEvents:UIControlEventTouchUpInside];
            
            if (!self.packageID) {
                
                addBtn.userInteractionEnabled = NO;
            }
            
            
            self.buyNumLab = [[UILabel alloc] init];
            self.buyNumLab.text = [NSString stringWithFormat:@"%d",self.buyNum];
            self.buyNumLab.textAlignment = NSTextAlignmentCenter;
            self.buyNumLab.font = KSystemFontSize17;
            self.buyNumLab.textColor = [UIColor CMLBlackColor];
            self.buyNumLab.frame = CGRectMake(CGRectGetMaxX(reduceBtn.frame),
                                              CGRectGetMaxY(numberLab.frame) + 20*Proportion,
                                              81*Proportion,
                                              52*Proportion);
            self.buyNumLab.backgroundColor = [UIColor clearColor];
            [self.attributeBgView addSubview:self.buyNumLab];
            
            self.attributeBgView.frame = CGRectMake(0,
                                                    HEIGHT - (CGRectGetMaxY(reduceBtn.frame) + 100*Proportion + 90*Proportion),
                                                    WIDTH,
                                                    CGRectGetMaxY(reduceBtn.frame) + 100*Proportion + 90*Proportion);
            
        }
        
    }
    
}

- (UIView *) addAttributeBgViewWithDic:(GoodsModuleObj *) obj{

    
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor CMLWhiteColor];
    
    UILabel *attributePromLab = [[UILabel alloc] init];
    attributePromLab.textColor  = [UIColor CMLBlackColor];
    attributePromLab.font = KSystemFontSize12;
    attributePromLab.text = obj.unitName;
    [attributePromLab sizeToFit];
    attributePromLab.frame = CGRectMake(30*Proportion,
                                        0,
                                        attributePromLab.frame.size.width,
                                        attributePromLab.frame.size.height);
    [bgView addSubview:attributePromLab];
    
    CGFloat currentLeft = 30*Proportion;
    CGFloat currentBottomMargin = 20*Proportion + CGRectGetMaxY(attributePromLab.frame);
    for (int i = 0; i < obj.propertyInfo.count; i++) {
        
        UIButton *btn = [[UIButton alloc] init];
        GoodsModuleDetailMesObj *detailObj = [GoodsModuleDetailMesObj getBaseObjFrom:obj.propertyInfo[i]];
        
        [btn setTitle:[NSString stringWithFormat:@"%@",detailObj.propertyValue] forState:UIControlStateNormal];
        
        
        btn.layer.cornerRadius = 10*Proportion;
        btn.layer.borderWidth = 1*Proportion;
        btn.titleLabel.font = KSystemFontSize13;
        btn.layer.borderColor = [UIColor CMLtextInputGrayColor].CGColor;
        [btn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
        btn.userInteractionEnabled = NO;
        btn.tag = [detailObj.goodsUnitPropertyId integerValue];
        [btn sizeToFit];
        [btn addTarget:self action:@selector(changeAttribute:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(currentLeft,
                               currentBottomMargin,
                               btn.frame.size.width + 20*Proportion,
                               52*Proportion);
        currentLeft += (CGRectGetWidth(btn.frame) + 30*Proportion);
        if (currentLeft > WIDTH) {
            
            currentLeft = 30*Proportion;
            currentBottomMargin += (30*Proportion + 52*Proportion);
            btn.frame = CGRectMake(currentLeft,
                                   currentBottomMargin,
                                   btn.frame.size.width,
                                   52*Proportion);
            currentLeft += (CGRectGetWidth(btn.frame) + 30*Proportion);
        }

        [bgView addSubview:btn];
        
        if ([detailObj.parentUnitId intValue]  == [self.currentParentUnitId intValue]) {
            
            if ([[self.selectDic valueForKey:[NSString stringWithFormat:@"%@",detailObj.parentUnitId]] integerValue] == [detailObj.goodsUnitPropertyId integerValue]) {
                
                btn.selected = YES;
                btn.userInteractionEnabled = NO;
                btn.backgroundColor = [UIColor CMLBrownColor];
                [btn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
                btn.layer.borderColor = [UIColor CMLBrownColor].CGColor;
                
                
            }else{
            
                for (int j = 0; j < self.attributePackageAry.count; j++) {
                    
                    NSDictionary *dic = self.attributePackageAry[j];
                    
                    if ([[dic valueForKey:[NSString stringWithFormat:@"%@",detailObj.parentUnitId]] intValue] == [detailObj.goodsUnitPropertyId intValue]) {
                        
                        btn.selected = NO;
                        btn.userInteractionEnabled = YES;
                        btn.backgroundColor = [UIColor CMLWhiteColor];
                        [btn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
                        btn.layer.borderColor = [UIColor CMLtextInputGrayColor].CGColor;
                    }
                }
            }
        }else{
        
            if ([[self.selectDic valueForKey:[NSString stringWithFormat:@"%@",detailObj.parentUnitId]] integerValue] == [detailObj.goodsUnitPropertyId integerValue]) {
                
                BOOL isNoSelected = YES;
                for (int j = 0; j < self.attributePackageAry.count; j++) {
                    
                    NSDictionary *dic = self.attributePackageAry[j];
                    
                    if (([[dic valueForKey:[NSString stringWithFormat:@"%@",detailObj.parentUnitId]] intValue] == [detailObj.goodsUnitPropertyId intValue]) && ([[dic valueForKey:self.currentParentUnitId] intValue] == [self.currentGoodsUnitPropertyId intValue])) {
                        
                        btn.selected = YES;
                        btn.userInteractionEnabled = NO;
                        btn.backgroundColor = [UIColor CMLBrownColor];
                        [btn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
                        btn.layer.borderColor = [UIColor CMLBrownColor].CGColor;
                        isNoSelected = NO;
                        break;
                    }
                }
                
                if (isNoSelected) {
                    
                    [self.selectDic removeObjectForKey:[NSString stringWithFormat:@"%@",detailObj.parentUnitId]];
                    [self.oldSelectDic removeObjectForKey:[NSString stringWithFormat:@"%@",detailObj.parentUnitId]];
                    
                    [self loadAttributesMessage];
                }
                
            }else{
                
                for (int j = 0; j < self.attributePackageAry.count; j++) {
                    
                    NSDictionary *dic = self.attributePackageAry[j];
                    
                    if (([[dic valueForKey:[NSString stringWithFormat:@"%@",detailObj.parentUnitId]] intValue] == [detailObj.goodsUnitPropertyId intValue]) && ([[dic valueForKey:self.currentParentUnitId] intValue] == [self.currentGoodsUnitPropertyId intValue])) {
                        
                        btn.selected = NO;
                        btn.userInteractionEnabled = YES;
                        btn.backgroundColor = [UIColor CMLWhiteColor];
                        [btn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
                        btn.layer.borderColor = [UIColor CMLtextInputGrayColor].CGColor;
                        
                        break;
                    }
                }
            }
        }
        
        if (self.oldSelectDic.allKeys.count > 0 ) {
            
            if (![self.oldSelectDic objectForKey:[NSString stringWithFormat:@"%@",obj.currentID]]) {
                
                NSMutableDictionary *temperDic = [NSMutableDictionary dictionaryWithDictionary:self.oldSelectDic];
                [temperDic setObject:[NSString stringWithFormat:@"%@",detailObj.goodsUnitPropertyId ]
                              forKey:[NSString stringWithFormat:@"%@",obj.currentID]];
                
                NSMutableString *targetStr = [[NSMutableString alloc] init];
                for (int j = 0; j < self.attributeAry.count; j++) {
                    
                    GoodsModuleObj *obj = [GoodsModuleObj getBaseObjFrom:self.attributeAry[j]];
                    
                    NSString *str = [temperDic valueForKey:[NSString stringWithFormat:@"%@",obj.currentID]];
                    
                    [targetStr appendString:[NSString stringWithFormat:@"-%@",str]];
                    
                }
 
                if (![self.attributePackageStrDic valueForKey:targetStr]) {
                
                    
                    btn.layer.borderColor = [UIColor CMLtextInputGrayColor].CGColor;
                    [btn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateSelected];
                    [btn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
                    btn.backgroundColor = [UIColor CMLWhiteColor];
                    btn.selected = NO;
                    btn.userInteractionEnabled = NO;
                    
                    
                    if ([[self.selectDic valueForKey:[NSString stringWithFormat:@"%@",obj.currentID]] intValue] == [detailObj.goodsUnitPropertyId intValue]) {
                        
                        [self.selectDic removeObjectForKey:[NSString stringWithFormat:@"%@",obj.currentID]];
                        [self loadAttributesMessage];
                        
                    }
                }
            }
        }

        
        if (i == obj.propertyInfo.count - 1) {
            bgView.tag = [obj.currentID integerValue];
            bgView.frame = CGRectMake(0,
                                      0,
                                      WIDTH,
                                      CGRectGetMaxY(btn.frame) + 70*Proportion);
            
        }
    }
    
    return bgView;
}

- (void) loadTopMessage{
    

    UILabel *priceLab = [[UILabel alloc] init];
    self.linePriceLabel = [[UILabel alloc] init];
    self.linePriceLabel.hidden = YES;
    if (self.packageID) {
     
        for (int i = 0; i < self.attributePackageAry.count; i++) {
            
            NSDictionary *dic = self.attributePackageAry[i];
            
            if ([[dic valueForKey:@"currentID"] intValue] == [self.packageID intValue]) {
                
                if ([self.obj.retData.is_deposit intValue] == 1) {
                    priceLab.text = [NSString stringWithFormat:@"¥ %@（订金）",[dic valueForKey:@"price"]];
                }else{
                    priceLab.text = [NSString stringWithFormat:@"¥ %@",[dic valueForKey:@"price"]];
                    /*4.2.0享受折扣时直接显示折扣价*/
                    if ([self.obj.retData.isEnjoyDiscount intValue] == 1) {
                        if ([self.obj.retData.is_discount intValue] == 1) {
                            if ([[dic valueForKey:@"discountPrice"] floatValue] != 0) {
                                priceLab.text = [NSString stringWithFormat:@"¥ %@",[dic valueForKey:@"discountPrice"]];
                                self.linePriceLabel.hidden = NO;
                            }
                        }
                    }
                }
                break;
            }
        }
    }else{
        priceLab.text = [NSString stringWithFormat:@"¥%@",self.obj.retData.prizeZone];
    }
    
    priceLab.font = KSystemBoldFontSize21;
    priceLab.textColor = [UIColor CMLBrownColor];
    [priceLab sizeToFit];
    priceLab.frame = CGRectMake(30*Proportion + 20*Proportion + 10*Proportion*2 + 160*Proportion,
                                34*Proportion,
                                priceLab.frame.size.width,
                                priceLab.frame.size.height);
    [self.attributeBgView addSubview:priceLab];
    
    /*划线价*/
    self.linePriceLabel.text = [NSString stringWithFormat:@"￥%@",self.obj.retData.totalAmountMin];
    self.linePriceLabel.font = KSystemFontSize12;
    self.linePriceLabel.textColor = [UIColor CMLPromptGrayColor];
    NSAttributedString *attstring = [[NSAttributedString alloc] initWithString:self.linePriceLabel.text attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid)}];
    self.linePriceLabel.attributedText = attstring;
    [self.linePriceLabel sizeToFit];
    self.linePriceLabel.frame = CGRectMake(CGRectGetMaxX(priceLab.frame) + 5 * Proportion,
                                           CGRectGetMidY(priceLab.frame) - self.linePriceLabel.frame.size.height/2,
                                           self.linePriceLabel.frame.size.width,
                                           self.linePriceLabel.frame.size.height);
    [self.attributeBgView addSubview:self.linePriceLabel];
    
    UILabel *surplusStockLab = [[UILabel alloc] init];
    
    if (self.packageID) {
        for (int i = 0; i < self.attributePackageAry.count; i++) {
            
            NSDictionary *dic = self.attributePackageAry[i];
            
            if ([[dic valueForKey:@"currentID"] intValue] == [self.packageID intValue]) {
                
                if ([[dic valueForKey:@"surplusStock"] intValue] <= 3) {
                    
                    surplusStockLab.text = [NSString stringWithFormat:@"仅剩：%@个",[dic valueForKey:@"surplusStock"]];
                }else{
                    
                    surplusStockLab.hidden = YES;
                }
                
                break;
                
            }
        }
    }else{
    
            surplusStockLab.hidden = YES;
    
        
    }

    
    surplusStockLab.font = KSystemFontSize11;
    surplusStockLab.textColor = [UIColor CMLUserBlackColor];
    [surplusStockLab sizeToFit];
    surplusStockLab.frame = CGRectMake(CGRectGetMaxX(priceLab.frame) + 20*Proportion,
                                       CGRectGetMaxY(priceLab.frame) - surplusStockLab.frame.size.height,
                                       surplusStockLab.frame.size.width,
                                       surplusStockLab.frame.size.height);
    [self.attributeBgView addSubview:surplusStockLab];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[UIImage imageNamed:GoodsCloseImg] forState:UIControlStateNormal];
    [closeBtn sizeToFit];
    closeBtn.frame = CGRectMake(WIDTH - 30*Proportion - closeBtn.frame.size.width - 20*Proportion,
                                priceLab.center.y - (closeBtn.frame.size.height + 20*Proportion)/2.0,
                                closeBtn.frame.size.width + 20*Proportion,
                                closeBtn.frame.size.height + 20*Proportion);
    [self.attributeBgView addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];

    UILabel *selectMesLab = [[UILabel alloc] init];
    
    
    NSMutableString *str = [[NSMutableString alloc] initWithString:@"已选："];
    
    for (int i = 0; i < self.attributeAry.count; i++) {
        
        
        
        GoodsModuleObj *obj = [GoodsModuleObj getBaseObjFrom:self.attributeAry[i]];
        
        if ( [self.selectDic valueForKey:[NSString stringWithFormat:@"%@",obj.currentID]] ) {
            
            for (int j = 0; j < obj.propertyInfo.count; j++) {
                
                GoodsModuleDetailMesObj *goodsDetailObj = [GoodsModuleDetailMesObj getBaseObjFrom:obj.propertyInfo[j]];
                
                if ([[self.selectDic valueForKey:[NSString stringWithFormat:@"%@",obj.currentID]] intValue] == [goodsDetailObj.goodsUnitPropertyId intValue]) {
                 
                    [str appendString:[NSString stringWithFormat:@"%@ ",goodsDetailObj.propertyValue]];
                }
            }
        }
    }
    
    selectMesLab.text = str;
    
    selectMesLab.font = KSystemFontSize13;
    selectMesLab.textColor = [UIColor CMLBlackColor];
    [selectMesLab sizeToFit];
    selectMesLab.frame = CGRectMake(30*Proportion + 20*Proportion + 10*Proportion*2 + 160*Proportion,
                                    CGRectGetMaxY(priceLab.frame) + 20*Proportion,
                                    selectMesLab.frame.size.width,
                                    selectMesLab.frame.size.height);
    [self.attributeBgView addSubview:selectMesLab];
    
    CMLLine *line = [[CMLLine alloc] init];
    line.startingPoint = CGPointMake(30*Proportion, CGRectGetMaxY(selectMesLab.frame) + 40*Proportion);
    line.lineWidth = 1*Proportion;
    line.lineLength = WIDTH - 30*Proportion*2;
    line.LineColor = [UIColor CMLtextInputGrayColor];
    [self.attributeBgView addSubview:line];
    
    self.attributeOriginY = CGRectGetMaxY(selectMesLab.frame) + 40*Proportion + 50*Proportion;

}

- (void) changeAttribute:(UIButton *) btn{
    
    if (self.oldSelectDic.allKeys.count == 2) {
        
        if (![self.oldSelectDic valueForKey:[NSString stringWithFormat:@"%ld",btn.superview.tag]]) {
         
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.oldSelectDic.allKeys];
            [array removeObject:self.currentParentUnitId];
            
            [self.oldSelectDic removeObjectForKey:[array firstObject]];
            
            [self.oldSelectDic setObject:[NSString stringWithFormat:@"%ld",(long)btn.tag] forKey:[NSString stringWithFormat:@"%ld",(long)btn.superview.tag]];
            
        }else{
        
            [self.oldSelectDic setObject:[NSString stringWithFormat:@"%ld",(long)btn.tag] forKey:[NSString stringWithFormat:@"%ld",btn.superview.tag]];
        }
       
    }else{
 
        [self.oldSelectDic setObject:[NSString stringWithFormat:@"%ld",(long)btn.tag] forKey:[NSString stringWithFormat:@"%ld",btn.superview.tag]];
    }
    
    self.currentParentUnitId = [NSString stringWithFormat:@"%ld",btn.superview.tag];
    self.currentGoodsUnitPropertyId = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    
    [self.selectDic setObject:[NSString stringWithFormat:@"%ld",(long)btn.tag] forKey:[NSString stringWithFormat:@"%ld",btn.superview.tag]];
    
    
    NSMutableString *targetStr = [[NSMutableString alloc] init];
    for (int i = 0; i < self.attributeAry.count; i++) {
        
        GoodsModuleObj *obj = [GoodsModuleObj getBaseObjFrom:self.attributeAry[i]];
        
        NSString *str = [self.selectDic valueForKey:[NSString stringWithFormat:@"%@",obj.currentID]];
        
        [targetStr appendString:[NSString stringWithFormat:@"-%@",str]];
        
    }
    
    if ([self.attributePackageStrDic valueForKey:targetStr]) {
        self.packageID = [self.attributePackageStrDic valueForKey:targetStr];
    }else{
    
        self.packageID = nil;
    }
    
    [self loadAttributesMessage];
    
}

- (void) close{

    [self.delegate closeGoodsAttributeView];
}

- (void) addBuyNumber{

    
    int maxNum = 0;
    for (int i = 0; i < self.attributePackageAry.count; i++) {
        
        NSDictionary *dic = self.attributePackageAry[i];
        
        if ([[dic valueForKey:@"currentID"] intValue] == [self.packageID intValue]) {
            
            maxNum = [[dic valueForKey:@"surplusStock"] intValue];
            break;
        }
    }
    
    if (self.buyNum == maxNum) {
        
        [self.delegate showErrorMessage:@"该商品库存不足"];
        
    }else{
    
        self.buyNum ++;
        self.buyNumLab.text = [NSString stringWithFormat:@"%d",self.buyNum];
    }

}

- (void) reduceBuyNum{

    if (self.buyNum != 1) {
     
        self.buyNum --;
        self.buyNumLab.text = [NSString stringWithFormat:@"%d",self.buyNum];
    }
}

- (void) buy{

    if (self.packageID) {
        
        [self.delegate selectPackageID:[NSNumber numberWithInt:[self.packageID intValue]] andBuyNum:self.buyNum];
    }else{
    
        [self.delegate showErrorMessage:@"请选择商品属性"];
    }
}
@end
