//
//  CMLShoppingCarTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/7.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLShoppingCarTVCell.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "CMLShoppingCarBrandObj.h"
#import "NetWorkTask.h"
#import "GoodsModuleDetailMesObj.h"
#import "ServeDefaultVC.h"
#import "CMLCommodityDetailMessageVC.h"
#import "VCManger.h"

@interface CMLShoppingCarTVCell()

@property (nonatomic,strong) UIButton  *selectBtn;

@property (nonatomic,strong) UIImageView *currentImage;

@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) UILabel *tagLab;

@property (nonatomic,strong) UILabel *priceLab;

@property (nonatomic,strong) UILabel *pricePromLab;

@property (nonatomic,strong) UIButton *addBtn;

@property (nonatomic,strong) UIButton *reduceBtn;

@property (nonatomic,strong) UILabel *numLab;

@property (nonatomic,strong) UIView *endLine;

@property (nonatomic,strong) CMLShoppingCarBrandObj *obj;

@property (nonatomic, strong) BaseResultObj *baseObj;

@end

@implementation CMLShoppingCarTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self loadViews];
    }
    return self;
}

- (void) loadViews{
    
    self.selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                40*Proportion,
                                                                80*Proportion,
                                                                160*Proportion)];
    self.selectBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:self.selectBtn];
    [self.selectBtn addTarget:self action:@selector(selectCurrentBrand) forControlEvents:UIControlEventTouchUpInside];
    
    self.currentImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.selectBtn.frame),
                                                                      40*Proportion,
                                                                      160*Proportion,
                                                                      160*Proportion)];
    self.currentImage.contentMode = UIViewContentModeScaleAspectFill;
    self.currentImage.clipsToBounds = YES;
    self.currentImage.userInteractionEnabled = YES;
    self.currentImage.layer.borderColor = [UIColor CMLSerachLineGrayColor].CGColor;
    self.currentImage.layer.borderWidth = 1*Proportion;
    self.currentImage.backgroundColor = [UIColor CMLNewGrayColor];
    [self addSubview:self.currentImage];
    
    /**手动扩大点击范围 - 进入详情*/
    UIButton *enterbtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.selectBtn.frame),
                                                                    40*Proportion,
                                                                    self.currentImage.frame.size.width*2,
                                                                    self.currentImage.frame.size.height)];
    enterbtn.backgroundColor = [UIColor clearColor];
    [self addSubview:enterbtn];
    [enterbtn addTarget:self action:@selector(enterDetail) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.font = KSystemBoldFontSize14;
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    self.titleLab.textColor = [UIColor CMLBlackColor];
    [self addSubview:self.titleLab];
    
    self.tagLab = [[UILabel alloc] init];
    self.tagLab.font = KSystemBoldFontSize12;
    self.tagLab.textColor = [UIColor CMLtextInputGrayColor];
    [self addSubview:self.tagLab];
    
    self.priceLab = [[UILabel alloc] init];
    self.priceLab.textColor = [UIColor CMLBrownColor];
    self.priceLab.font = KSystemRealBoldFontSize16;
    [self addSubview:self.priceLab];
    
    self.pricePromLab = [[UILabel alloc] init];
    self.pricePromLab.textColor = [UIColor CMLBrownColor];
    self.pricePromLab.font = KSystemBoldFontSize10;
    [self addSubview:self.pricePromLab];
    
    self.addBtn = [[UIButton alloc] init];
    self.addBtn.backgroundColor = [UIColor clearColor];
    [self.addBtn addTarget:self action:@selector(addNum) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addBtn];
    
    self.reduceBtn = [[UIButton alloc] init];
    self.reduceBtn.backgroundColor = [UIColor clearColor];
    [self.reduceBtn addTarget:self action:@selector(reduceNum) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.reduceBtn];
    
    self.numLab = [[UILabel alloc] init];
    self.numLab.font = KSystemFontSize13;
    self.numLab.textAlignment = NSTextAlignmentCenter;
    self.numLab.textColor = [UIColor CMLBlackColor];
    [self addSubview:self.numLab];
    
    self.endLine = [[UIView alloc] initWithFrame:CGRectMake(80*Proportion,
                                                            238*Proportion ,
                                                            WIDTH - 80*Proportion,
                                                            1*Proportion)];
    self.endLine.backgroundColor = [UIColor CMLSerachLineGrayColor];
    [self addSubview:self.endLine];
    
}

- (void)refreshCurrentCellWith:(CMLShoppingCarBrandObj *)obj withBaseObj:(BaseResultObj *)baseObj {
    
    self.obj = obj;
    self.baseObj = baseObj;
    
    [NetWorkTask setImageView:self.currentImage WithURL:obj.projectInfo.coverPic placeholderImage:nil];
    
    self.titleLab.frame = CGRectZero;
    self.titleLab.text = obj.projectInfo.title;
    [self.titleLab sizeToFit];
    if (self.titleLab.frame.size.width > WIDTH - 80*Proportion - 160*Proportion - 20*Proportion - 30*Proportion) {
        
        self.titleLab.numberOfLines = 2;
        self.titleLab.frame = CGRectMake(CGRectGetMaxX(self.currentImage.frame) + 20*Proportion,
                                         40*Proportion,
                                         WIDTH - 80*Proportion - 160*Proportion - 20*Proportion - 30*Proportion,
                                         self.titleLab.frame.size.height*2);
    }else{
        
        self.titleLab.numberOfLines = 1;
        self.titleLab.frame = CGRectMake(CGRectGetMaxX(self.currentImage.frame) + 20*Proportion,
                                         40*Proportion,
                                         WIDTH - 80*Proportion - 160*Proportion - 20*Proportion - 30*Proportion,
                                         self.titleLab.frame.size.height);
    }
    
    if ([obj.objType intValue] == 3) {
        
        self.tagLab.hidden = YES;
        
        if ([obj.packageInfo.payMode intValue] == 1) {
            
            self.priceLab.text = [NSString stringWithFormat:@"¥%@",obj.packageInfo.subscription];
            [self.priceLab sizeToFit];
            self.priceLab.frame = CGRectMake(CGRectGetMaxX(self.currentImage.frame) + 20*Proportion,
                                             CGRectGetMaxY(self.currentImage.frame) - self.priceLab.frame.size.height,
                                             self.priceLab.frame.size.width,
                                             self.priceLab.frame.size.height);
            
            self.pricePromLab.hidden = NO;
            self.pricePromLab.text = @"（订金）";
            [self.pricePromLab sizeToFit];
            self.pricePromLab.frame = CGRectMake(CGRectGetMaxX(self.priceLab.frame),
                                                 self.priceLab.center.y - self.pricePromLab.frame.size.height/2.0,
                                                 self.pricePromLab.frame.size.width,
                                                 self.pricePromLab.frame.size.height);
            
        }else{
            
            self.pricePromLab.hidden = YES;
            self.priceLab.text = [NSString stringWithFormat:@"¥%@",obj.packageInfo.totalAmount];
            [self.priceLab sizeToFit];
            self.priceLab.frame = CGRectMake(CGRectGetMaxX(self.currentImage.frame) + 20*Proportion,
                                             CGRectGetMaxY(self.currentImage.frame) - self.priceLab.frame.size.height,
                                             self.priceLab.frame.size.width,
                                             self.priceLab.frame.size.height);
            /*存在折扣*/
            [self isEnjoyDiscount];
            
        }
        
        if ([obj.projectInfo.sysOrderStatus intValue] == 1) {
            
            self.selectBtn.userInteractionEnabled = YES;
            self.addBtn.userInteractionEnabled = YES;
            self.reduceBtn.userInteractionEnabled = YES;
            [self.selectBtn setImage:[UIImage imageNamed:MailCarBrandNoSelectImg] forState:UIControlStateNormal];
            [self.selectBtn setImage:[UIImage imageNamed:MailCarBrandSelectedImg] forState:UIControlStateSelected];
            
            if (self.isSelect) {
                
                self.selectBtn.selected = YES;
            }else{
                
                self.selectBtn.selected = NO;
            }
            
            if ([obj.goodNum intValue] > [obj.packageInfo.surplusStock intValue]) {
                
                if ([obj.packageInfo.surplusStock intValue] == 0) {
                    
                    self.priceLab.text = @"无库存";
                }else{
                    
                    self.priceLab.text = [NSString stringWithFormat:@"仅剩%@",self.obj.packageInfo.surplusStock];
                }
                self.selectBtn.userInteractionEnabled = NO;
                [self.selectBtn setImage:[UIImage imageNamed:MailCarBrandForbridSelectImg] forState:UIControlStateNormal];
            }
            
        }else{
            
            self.pricePromLab.hidden = YES;
            self.selectBtn.userInteractionEnabled = NO;
            self.addBtn.userInteractionEnabled = NO;
            [self.selectBtn setImage:[UIImage imageNamed:MailCarBrandForbridSelectImg] forState:UIControlStateNormal];
            
            self.priceLab.text = obj.projectInfo.sysOrderStatusName;
            [self.priceLab sizeToFit];
            self.priceLab.frame = CGRectMake(CGRectGetMaxX(self.currentImage.frame) + 20*Proportion,
                                             CGRectGetMaxY(self.currentImage.frame) - self.priceLab.frame.size.height,
                                             self.priceLab.frame.size.width,
                                             self.priceLab.frame.size.height);
            /*存在折扣*/
            [self isEnjoyDiscount];
        }
        
        
    }else if ([obj.objType intValue] == 7){
        
        NSMutableString *str = [[NSMutableString alloc] init];
        [str appendString:@"已选："];
        
        for (int j = 0; j < obj.packageInfo.unitsPropertyInfo.count; j++) {
            
            GoodsModuleDetailMesObj *detailObj = [GoodsModuleDetailMesObj getBaseObjFrom:obj.packageInfo.unitsPropertyInfo[j]];
            [str appendString:[NSString stringWithFormat:@"%@ ",detailObj.propertyValue]];
        }
        
        self.tagLab.hidden = NO;
        self.tagLab.text = str;
        [self.tagLab sizeToFit];
        self.tagLab.frame = CGRectMake(CGRectGetMaxX(self.currentImage.frame) + 20*Proportion,
                                       CGRectGetMaxY(self.titleLab.frame) + 10*Proportion,
                                       self.tagLab.frame.size.width,
                                       self.tagLab.frame.size.height);
        
        
        self.priceLab.text = [NSString stringWithFormat:@"¥%@",obj.packageInfo.totalAmount];
        /*订金*/
        if ([obj.projectInfo.is_deposit intValue] == 1) {
            
            self.priceLab.text = [NSString stringWithFormat:@"¥%@",obj.projectInfo.deposit_money];
        }
        
        [self.priceLab sizeToFit];
        self.priceLab.frame = CGRectMake(CGRectGetMaxX(self.currentImage.frame) + 20*Proportion,
                                         CGRectGetMaxY(self.currentImage.frame) - self.priceLab.frame.size.height,
                                         self.priceLab.frame.size.width,
                                         self.priceLab.frame.size.height);
        
        if ([obj.projectInfo.is_deposit intValue] == 1) {
            
            self.pricePromLab.hidden = NO;
            self.pricePromLab.text = @"（订金）";
            [self.pricePromLab sizeToFit];
            self.pricePromLab.frame = CGRectMake(CGRectGetMaxX(self.priceLab.frame),
                                                 self.priceLab.center.y - self.pricePromLab.frame.size.height/2.0,
                                                 self.pricePromLab.frame.size.width,
                                                 self.pricePromLab.frame.size.height);
        }else{
            
            self.pricePromLab.hidden = YES;
            
        }
        
        /*存在折扣*/
        [self isEnjoyDiscount];
        
        
        if ([obj.projectInfo.sysApplyStatus intValue] == 1) {
            
            if (self.NoSelect) {
              
                self.selectBtn.userInteractionEnabled = NO;
                self.addBtn.userInteractionEnabled = NO;
//                self.reduceBtn.userInteractionEnabled = NO;
                [self.selectBtn setImage:[UIImage imageNamed:MailCarBrandForbridSelectImg] forState:UIControlStateNormal];
                
//                self.currentImage.userInteractionEnabled = NO;
                
                if ([obj.packageInfo.surplusStock intValue] == 0) {
                    
                    self.priceLab.text = @"无库存";
                }else{
                    
                    self.priceLab.text = [NSString stringWithFormat:@"仅剩%@",self.obj.packageInfo.surplusStock];
                }
                
                [self.priceLab sizeToFit];
                self.priceLab.frame = CGRectMake(CGRectGetMaxX(self.currentImage.frame) + 20*Proportion,
                                                 CGRectGetMaxY(self.currentImage.frame) - self.priceLab.frame.size.height,
                                                 self.priceLab.frame.size.width,
                                                 self.priceLab.frame.size.height);
                
                /**待测试**/
                
//                if (!self.pricePromLab.hidden) {
//
//                    self.pricePromLab.hidden = YES;
//                }
                /***/
                
            }else{
                
                self.currentImage.userInteractionEnabled = YES;
                self.selectBtn.userInteractionEnabled = YES;
                self.addBtn.userInteractionEnabled = YES;
                self.reduceBtn.userInteractionEnabled = YES;
                [self.selectBtn setImage:[UIImage imageNamed:MailCarBrandNoSelectImg] forState:UIControlStateNormal];
                [self.selectBtn setImage:[UIImage imageNamed:MailCarBrandSelectedImg] forState:UIControlStateSelected];
                
                if (self.isSelect) {
                    
                    self.selectBtn.selected = YES;
                }else{
                    
                    self.selectBtn.selected = NO;
                }
            }

        }else{
            
            /****待测试***/
            
//            if (!self.pricePromLab.hidden) {
//                
//                self.pricePromLab.hidden = YES;
//            }
            /******/
            
//            self.currentImage.userInteractionEnabled = NO;
            self.selectBtn.userInteractionEnabled = NO;
            self.addBtn.userInteractionEnabled = NO;
//            self.reduceBtn.userInteractionEnabled = NO;
            [self.selectBtn setImage:[UIImage imageNamed:MailCarBrandForbridSelectImg] forState:UIControlStateNormal];
            
            self.priceLab.text = obj.projectInfo.sysApplyStatusName;
            [self.priceLab sizeToFit];
            self.priceLab.frame = CGRectMake(CGRectGetMaxX(self.currentImage.frame) + 20*Proportion,
                                             CGRectGetMaxY(self.currentImage.frame) - self.priceLab.frame.size.height,
                                             self.priceLab.frame.size.width,
                                             self.priceLab.frame.size.height);
        }
        
    }
    
    [self.addBtn setBackgroundImage:[UIImage imageNamed:MailCarAddBtnImg] forState:UIControlStateNormal];
    [self.addBtn sizeToFit];
    self.addBtn.frame = CGRectMake(WIDTH - 30*Proportion - self.addBtn.frame.size.width,
                                   CGRectGetMaxY(self.currentImage.frame) - self.addBtn.frame.size.height,
                                   self.addBtn.frame.size.width,
                                   self.addBtn.frame.size.height);
    
    [self.reduceBtn setBackgroundImage:[UIImage imageNamed:MailCarReduceBtnImg] forState:UIControlStateNormal];
    [self.reduceBtn sizeToFit];
    self.reduceBtn.frame = CGRectMake(WIDTH - 30*Proportion - self.addBtn.frame.size.width - self.reduceBtn
                                      .frame.size.width - 74*Proportion,
                                   CGRectGetMaxY(self.currentImage.frame) - self.reduceBtn.frame.size.height,
                                   self.reduceBtn.frame.size.width,
                                   self.reduceBtn.frame.size.height);
    self.numLab.text = [NSString stringWithFormat:@"%@",obj.goodNum];
    [self.numLab sizeToFit];
    self.numLab.frame = CGRectMake(CGRectGetMaxX(self.reduceBtn.frame),
                                   self.reduceBtn.center.y - self.numLab.frame.size.height/2.0,
                                   74*Proportion,
                                   self.numLab.frame.size.height);
    
    if ([self.numLab.text intValue] >= [self.obj.packageInfo.surplusStock intValue]) {
        
        [self.addBtn setBackgroundImage:[UIImage imageNamed:MailForbridAddBtnImg] forState:UIControlStateNormal];
        self.addBtn.userInteractionEnabled = NO;
    }else{
        
        [self.addBtn setBackgroundImage:[UIImage imageNamed:MailCarAddBtnImg] forState:UIControlStateNormal];
        self.addBtn.userInteractionEnabled = YES;
    }
    
    
    if ([obj.objType intValue] == 3 && [obj.projectInfo.is_video_project intValue] == 1) {
        
        self.addBtn.userInteractionEnabled = NO;
        [self.addBtn setBackgroundImage:[UIImage imageNamed:MailForbridAddBtnImg] forState:UIControlStateNormal];
        
    }
    
    if (self.NoSelect) {
        
        self.pricePromLab.hidden = YES;
    }
    
}
- (void) selectCurrentBrand{
    
    self.selectBtn.selected = !self.selectBtn.selected;
    
    [self.delegate changeBrandStatus:self.selectBtn.selected currentBrandID:self.obj.packageId currentCarID:self.obj.carId currentObjID:self.obj.projectInfo.currentID currentObjType:self.obj.objType];

}

- (void) addNum{
    
    if ([self.numLab.text intValue] != [self.obj.packageInfo.surplusStock intValue]) {
     
        [self.delegate addBrandID:self.obj.packageId currentCarID:self.obj.carId currentObjID:self.obj.projectInfo.currentID currentObjType:self.obj.objType];
    }
}

- (void) reduceNum{
    
    if ([self.numLab.text intValue] != 1) {
        
        [self.delegate reduceBrandID:self.obj.packageId currentCarID:self.obj.carId currentObjID:self.obj.projectInfo.currentID currentObjType:self.obj.objType];
    }
}

- (void) enterDetail{
    
    if ([self.obj.objType intValue] == 3) {
        
        ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:self.obj.objId];
        [[VCManger mainVC]pushVC:vc animate:YES];
        
    }else if ([self.obj.objType intValue] == 7){
        
        CMLCommodityDetailMessageVC *vc = [[CMLCommodityDetailMessageVC alloc] initWithObjId:self.obj.objId];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }
}

- (void)isEnjoyDiscount {
    
    /*如果存在折扣价*/
    if ([self.baseObj.retData.isEnjoyDiscount intValue] == 1) {
        if (self.obj.projectInfo.is_discount) {
            if ([self.obj.projectInfo.is_discount intValue] == 1) {
                if ([self.obj.packageInfo.discount intValue] != 0) {
                    self.priceLab.text = [NSString stringWithFormat:@"¥%@", self.obj.packageInfo.discount];
                    [self.priceLab sizeToFit];
                    self.priceLab.frame = CGRectMake(CGRectGetMaxX(self.currentImage.frame) + 20*Proportion,
                                                     CGRectGetMaxY(self.currentImage.frame) - self.priceLab.frame.size.height,
                                                     self.priceLab.frame.size.width,
                                                     self.priceLab.frame.size.height);
                }
            }
        }
    }
}

@end
