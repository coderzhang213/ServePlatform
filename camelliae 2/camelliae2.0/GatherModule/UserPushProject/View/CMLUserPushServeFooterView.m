//
//  CMLUserPushServeFooterView.m
//  camelliae2.0
//
//  Created by 张越 on 2018/11/17.
//  Copyright © 2018 张越. All rights reserved.
//

#import "CMLUserPushServeFooterView.h"
#import "BaseResultObj.h"
#import "VCManger.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "CommonNumber.h"
#import "CommemtListVC.h"
#import "PackageInfoObj.h"
#import "NSString+CMLExspand.h"
#import "ShoppingCarVC.h"
#import "PackDetailInfoObj.h"
#import "CMLMobClick.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"

#define ServeDefaultVCAppointmentBtnWidth       424

@interface CMLUserPushServeFooterView ()<NetWorkProtocol>

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) UIButton *appointmentBtn;

@property (nonatomic,strong) UILabel *priceLab;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,assign) BOOL isGoods;

@end

@implementation CMLUserPushServeFooterView


- (instancetype)initWith:(BaseResultObj *)obj{
    
    if (self = [super init]) {
        
        self.obj = obj;
        
        [self loadViews];
    }
    return self;
}

- (instancetype)initWith:(BaseResultObj *) obj andGoods:(BOOL) isGoods{
    
    
    if (self = [super init]) {
        self.isGoods = isGoods;
        self.obj = obj;
        self.backgroundColor = [UIColor CMLWhiteColor];
        
        [self loadViews];
    }
    return self;
}


- (void) loadViews{
    
    
    [self setVCFooterViewBtn];
    
}

- (void) setVCFooterViewBtn{
    
    self.priceLab = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                              0,
                                                              WIDTH - ServeDefaultVCAppointmentBtnWidth*Proportion,
                                                              UITabBarHeight)];
    self.priceLab.font = KSystemRealBoldFontSize14;
    self.priceLab.backgroundColor = [UIColor CMLWhiteColor];
    self.priceLab.textAlignment = NSTextAlignmentCenter;
    self.priceLab.text = [NSString stringWithFormat:@"¥%@",self.obj.retData.totalAmount];
    [self addSubview:self.priceLab];
    
    
    self.appointmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - ServeDefaultVCAppointmentBtnWidth*Proportion,
                                                                     0,
                                                                     ServeDefaultVCAppointmentBtnWidth*Proportion,
                                                                     UITabBarHeight)];
    self.appointmentBtn.backgroundColor = [UIColor CMLGreeenColor];
    self.appointmentBtn.titleLabel.font = KSystemRealBoldFontSize14;
    [self.appointmentBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [self.appointmentBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
    [self.appointmentBtn addTarget:self action:@selector(appointCUrrentServe) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.appointmentBtn];
    
    
    if (self.isGoods) {
        self.priceLab.text = [NSString stringWithFormat:@"¥%@",self.obj.retData.totalAmountMin];
        if ([self.obj.retData.sysApplyStatus intValue] == 1) {
            
            int allsurplusStock = 0;
            for (int i = 0; i < self.obj.retData.packageInfo.dataList.count; i++) {
                
                PackDetailInfoObj *obj = [PackDetailInfoObj getBaseObjFrom:self.obj.retData.packageInfo.dataList[i]];
                
                allsurplusStock += [obj.surplusStock intValue];
                
            }
            
            if (allsurplusStock == 0) {
                
                UILabel *statusLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 80*Proportion)];
                statusLab.backgroundColor = [UIColor CMLPromptGrayColor];
                statusLab.textAlignment = NSTextAlignmentCenter;
                statusLab.textColor = [UIColor CMLBlackColor];
                statusLab.font = KSystemRealBoldFontSize13;
                statusLab.text = @"无库存";
                [self addSubview:statusLab];
                
                self.appointmentBtn.frame = CGRectMake(self.appointmentBtn.frame.origin.x,
                                                       CGRectGetMaxY(statusLab.frame),
                                                       self.appointmentBtn.frame.size.width,
                                                       self.appointmentBtn.frame.size.height);
                
                self.appointmentBtn.userInteractionEnabled = NO;
                [self.appointmentBtn setTitleColor:[[UIColor CMLWhiteColor] colorWithAlphaComponent:0.4] forState:UIControlStateNormal];
                
                self.priceLab.frame = CGRectMake(0,
                                                 CGRectGetMaxY(statusLab.frame),
                                                 WIDTH - ServeDefaultVCAppointmentBtnWidth*Proportion,
                                                 UITabBarHeight);
                
                self.currentHeight = UITabBarHeight + 80*Proportion;
                
            }else{
                
                self.appointmentBtn.userInteractionEnabled = YES;
                
                self.currentHeight = UITabBarHeight;
                
            }
            
        }else{
            
            UILabel *statusLab = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           WIDTH,
                                                                           80*Proportion)];
            statusLab.backgroundColor = [UIColor CMLPromptGrayColor];
            statusLab.textAlignment = NSTextAlignmentCenter;
            statusLab.textColor = [UIColor CMLBlackColor];
            statusLab.font = KSystemRealBoldFontSize13;
            statusLab.text = self.obj.retData.sysApplyStatusName;
            [self addSubview:statusLab];
            
            self.appointmentBtn.frame = CGRectMake(self.appointmentBtn.frame.origin.x,
                                                   CGRectGetMaxY(statusLab.frame),
                                                   self.appointmentBtn.frame.size.width,
                                                   self.appointmentBtn.frame.size.height);
            
            self.priceLab.frame = CGRectMake(0,
                                             CGRectGetMaxY(statusLab.frame),
                                             WIDTH - ServeDefaultVCAppointmentBtnWidth*Proportion,
                                             UITabBarHeight);
            
            self.appointmentBtn.userInteractionEnabled = NO;
            [self.appointmentBtn setTitleColor:[[UIColor CMLWhiteColor] colorWithAlphaComponent:0.4] forState:UIControlStateNormal];
            
            self.currentHeight = UITabBarHeight + 80*Proportion;
            NSLog(@"%f", self.currentHeight);
            
            
        }
    }else{
        
        
        if ([self.obj.retData.sysOrderStatus intValue] == 1) {
            
            
            PackDetailInfoObj *obj = [PackDetailInfoObj getBaseObjFrom:[self.obj.retData.packageInfo.dataList firstObject]];
            
            if ([obj.surplusStock intValue] > 0) {
                
                self.appointmentBtn.userInteractionEnabled = YES;
                
                self.currentHeight = UITabBarHeight;
                
            }else{
                
                UILabel *statusLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 80*Proportion)];
                statusLab.backgroundColor = [UIColor CMLPromptGrayColor];
                statusLab.textAlignment = NSTextAlignmentCenter;
                statusLab.textColor = [UIColor CMLBlackColor];
                statusLab.font = KSystemRealBoldFontSize13;
                statusLab.text = @"库存不足";
                [self addSubview:statusLab];
                
                self.appointmentBtn.frame = CGRectMake(self.appointmentBtn.frame.origin.x,
                                                       CGRectGetMaxY(statusLab.frame),
                                                       self.appointmentBtn.frame.size.width,
                                                       self.appointmentBtn.frame.size.height);
                
                self.priceLab.frame = CGRectMake(0,
                                                 CGRectGetMaxY(statusLab.frame),
                                                 WIDTH - ServeDefaultVCAppointmentBtnWidth*Proportion,
                                                 UITabBarHeight);
                
                self.appointmentBtn.userInteractionEnabled = NO;
                [self.appointmentBtn setTitleColor:[[UIColor CMLWhiteColor] colorWithAlphaComponent:0.4] forState:UIControlStateNormal];
                self.currentHeight = UITabBarHeight + 80*Proportion;
            }
            
            
        }else{
            
            UILabel *statusLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 80*Proportion)];
            statusLab.backgroundColor = [UIColor CMLPromptGrayColor];
            statusLab.textAlignment = NSTextAlignmentCenter;
            statusLab.textColor = [UIColor CMLBlackColor];
            statusLab.font = KSystemRealBoldFontSize13;
            statusLab.text = self.obj.retData.sysOrderStatusName;
            [self addSubview:statusLab];

            self.appointmentBtn.frame = CGRectMake(self.appointmentBtn.frame.origin.x,
                                                   CGRectGetMaxY(statusLab.frame),
                                                   self.appointmentBtn.frame.size.width,
                                                   self.appointmentBtn.frame.size.height);
            
            self.priceLab.frame = CGRectMake(0,
                                             CGRectGetMaxY(statusLab.frame),
                                             WIDTH - ServeDefaultVCAppointmentBtnWidth*Proportion,
                                             UITabBarHeight);
            
            self.appointmentBtn.userInteractionEnabled = NO;
            [self.appointmentBtn setTitleColor:[[UIColor CMLWhiteColor] colorWithAlphaComponent:0.4] forState:UIControlStateNormal];
            
            self.currentHeight = UITabBarHeight + 80*Proportion;
            
        }
        
        if ([self.obj.retData.is_video_project intValue] == 1 && [self.obj.retData.is_buy intValue] == 1 ) {
            
            self.appointmentBtn.userInteractionEnabled = NO;
            [self.appointmentBtn setTitleColor:[[UIColor CMLWhiteColor] colorWithAlphaComponent:0.4] forState:UIControlStateNormal];
            [self.appointmentBtn setTitle:self.obj.retData.buy_name forState:UIControlStateNormal];
        }
        
    }
    
    CMLLine *topLine = [[CMLLine alloc] init];
    topLine.lineWidth = 1*Proportion;
    topLine.lineLength = WIDTH;
    topLine.LineColor = [UIColor CMLSerachLineGrayColor];
    topLine.startingPoint = CGPointMake(0, 0);
    [self addSubview:topLine];
    
    CMLLine *spaceLine = [[CMLLine alloc] init];
    spaceLine.lineWidth = 1*Proportion;
    spaceLine.lineLength = UITabBarHeight;
    spaceLine.directionOfLine = VerticalLine;
    spaceLine.LineColor = [UIColor CMLSerachLineGrayColor];
    spaceLine.startingPoint = CGPointMake(WIDTH - ServeDefaultVCAppointmentBtnWidth*Proportion*2, 0);
    [self addSubview:spaceLine];
    
}

- (void) appointCUrrentServe{
    
    [CMLMobClick PurchaseImmediately];
    [self.delegate showProjectMessage];
}



@end
