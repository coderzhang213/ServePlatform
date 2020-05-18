//
//  ServeFooterView.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/26.
//  Copyright © 2016年 张越. All rights reserved.
//  服务/

#import "ServeFooterView.h"
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

#define ServeDefaultVCAppointmentBtnWidth       320


@interface ServeFooterView ()<NetWorkProtocol>

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) UIButton *appointmentBtn;

@property (nonatomic,strong) UIButton *addSBCarBtn;

@property (nonatomic,strong) UIButton *enterSBCarVCBtn;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,assign) BOOL isGoods;

@end

@implementation ServeFooterView

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
       
        [self loadViews];
    }
    return self;
}


- (void) loadViews{
    
//    if ([self.obj.retData.sysOrderStatus intValue] != 4) {
    
        [self setVCFooterViewBtn];
        
//    }else{
//
//        self.frame = CGRectMake(0, 0, 0, 0);
//        self.hidden = YES;
//
//    }

}

- (void) setVCFooterViewBtn{
    
    
    self.appointmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - ServeDefaultVCAppointmentBtnWidth*Proportion,
                                                                     0,
                                                                     ServeDefaultVCAppointmentBtnWidth*Proportion,
                                                                     UITabBarHeight)];
    self.appointmentBtn.backgroundColor = [UIColor CMLGreeenColor];
    self.appointmentBtn.titleLabel.font = KSystemRealBoldFontSize17;
    [self.appointmentBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [self.appointmentBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
    [self.appointmentBtn addTarget:self action:@selector(appointCUrrentServe) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.appointmentBtn];
    
    
    
    self.addSBCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - ServeDefaultVCAppointmentBtnWidth*Proportion*2,
                                                                  0,
                                                                  ServeDefaultVCAppointmentBtnWidth*Proportion,
                                                                  UITabBarHeight)];
    self.addSBCarBtn.backgroundColor = [UIColor CMLWhiteColor];
    self.addSBCarBtn.titleLabel.font = KSystemRealBoldFontSize17;
    [self.addSBCarBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [self.addSBCarBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    [self.addSBCarBtn addTarget:self action:@selector(addCar) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addSBCarBtn];
    
    self.enterSBCarVCBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      WIDTH - ServeDefaultVCAppointmentBtnWidth*Proportion*2,
                                                                      UITabBarHeight)];
    [self.enterSBCarVCBtn setImage:[UIImage imageNamed:SBCarImg] forState:UIControlStateNormal];
    self.enterSBCarVCBtn.backgroundColor = [UIColor CMLWhiteColor];
    [self.enterSBCarVCBtn addTarget:self action:@selector(enterSBCarVC) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.enterSBCarVCBtn];
    
    if (self.isGoods) {
        
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
                
                self.enterSBCarVCBtn.frame = CGRectMake(0,
                                                        CGRectGetMaxY(statusLab.frame),
                                                        self.enterSBCarVCBtn.frame.size.width,
                                                        self.enterSBCarVCBtn.frame.size.height);
                self.addSBCarBtn.frame = CGRectMake(self.addSBCarBtn.frame.origin.x,
                                                    CGRectGetMaxY(statusLab.frame),
                                                    self.addSBCarBtn.frame.size.width,
                                                    self.addSBCarBtn.frame.size.height);
                self.appointmentBtn.frame = CGRectMake(self.appointmentBtn.frame.origin.x,
                                                       CGRectGetMaxY(statusLab.frame),
                                                       self.appointmentBtn.frame.size.width,
                                                       self.appointmentBtn.frame.size.height);
                
                self.appointmentBtn.userInteractionEnabled = NO;
                self.addSBCarBtn.userInteractionEnabled = NO;
                [self.appointmentBtn setTitleColor:[[UIColor CMLWhiteColor] colorWithAlphaComponent:0.2] forState:UIControlStateNormal];
                [self.addSBCarBtn setTitleColor:[[UIColor CMLBlackColor] colorWithAlphaComponent:0.2] forState:UIControlStateNormal];
                
                self.currentHeight = UITabBarHeight + 80*Proportion;
                
            }else{
             
                self.appointmentBtn.userInteractionEnabled = YES;
                self.addSBCarBtn.userInteractionEnabled = YES;
                
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
            
            self.enterSBCarVCBtn.frame = CGRectMake(0,
                                                    CGRectGetMaxY(statusLab.frame),
                                                    self.enterSBCarVCBtn.frame.size.width,
                                                    self.enterSBCarVCBtn.frame.size.height);
            self.addSBCarBtn.frame = CGRectMake(self.addSBCarBtn.frame.origin.x,
                                                CGRectGetMaxY(statusLab.frame),
                                                self.addSBCarBtn.frame.size.width,
                                                self.addSBCarBtn.frame.size.height);
            self.appointmentBtn.frame = CGRectMake(self.appointmentBtn.frame.origin.x,
                                                   CGRectGetMaxY(statusLab.frame),
                                                   self.appointmentBtn.frame.size.width,
                                                   self.appointmentBtn.frame.size.height);
            
            self.appointmentBtn.userInteractionEnabled = NO;
            self.addSBCarBtn.userInteractionEnabled = NO;
            [self.appointmentBtn setTitleColor:[[UIColor CMLWhiteColor] colorWithAlphaComponent:0.2] forState:UIControlStateNormal];
            [self.addSBCarBtn setTitleColor:[[UIColor CMLBlackColor] colorWithAlphaComponent:0.2] forState:UIControlStateNormal];
            
            self.currentHeight = UITabBarHeight + 80*Proportion;
            
            
        }
    }else{
        
        
        if ([self.obj.retData.sysOrderStatus intValue] == 1) {
            

            PackDetailInfoObj *obj = [PackDetailInfoObj getBaseObjFrom:[self.obj.retData.packageInfo.dataList firstObject]];
            
            if ([obj.surplusStock intValue] > 0) {
             
                self.appointmentBtn.userInteractionEnabled = YES;
                self.addSBCarBtn.userInteractionEnabled = YES;
                
                self.currentHeight = UITabBarHeight;
                
            }else{
                
                UILabel *statusLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 80*Proportion)];
                statusLab.backgroundColor = [UIColor CMLPromptGrayColor];
                statusLab.textAlignment = NSTextAlignmentCenter;
                statusLab.textColor = [UIColor CMLBlackColor];
                statusLab.font = KSystemRealBoldFontSize13;
                statusLab.text = @"库存不足";
                [self addSubview:statusLab];
                
                self.enterSBCarVCBtn.frame = CGRectMake(0,
                                                        CGRectGetMaxY(statusLab.frame),
                                                        self.enterSBCarVCBtn.frame.size.width,
                                                        self.enterSBCarVCBtn.frame.size.height);
                self.addSBCarBtn.frame = CGRectMake(self.addSBCarBtn.frame.origin.x,
                                                    CGRectGetMaxY(statusLab.frame),
                                                    self.addSBCarBtn.frame.size.width,
                                                    self.addSBCarBtn.frame.size.height);
                self.appointmentBtn.frame = CGRectMake(self.appointmentBtn.frame.origin.x,
                                                       CGRectGetMaxY(statusLab.frame),
                                                       self.appointmentBtn.frame.size.width,
                                                       self.appointmentBtn.frame.size.height);
                
                self.appointmentBtn.userInteractionEnabled = NO;
                self.addSBCarBtn.userInteractionEnabled = NO;
                [self.appointmentBtn setTitleColor:[[UIColor CMLWhiteColor] colorWithAlphaComponent:0.2] forState:UIControlStateNormal];
                [self.addSBCarBtn setTitleColor:[[UIColor CMLBlackColor] colorWithAlphaComponent:0.2] forState:UIControlStateNormal];
                
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
            
            self.enterSBCarVCBtn.frame = CGRectMake(0,
                                                    CGRectGetMaxY(statusLab.frame),
                                                    self.enterSBCarVCBtn.frame.size.width,
                                                    self.enterSBCarVCBtn.frame.size.height);
            self.addSBCarBtn.frame = CGRectMake(self.addSBCarBtn.frame.origin.x,
                                                CGRectGetMaxY(statusLab.frame),
                                                self.addSBCarBtn.frame.size.width,
                                                self.addSBCarBtn.frame.size.height);
            self.appointmentBtn.frame = CGRectMake(self.appointmentBtn.frame.origin.x,
                                                   CGRectGetMaxY(statusLab.frame),
                                                   self.appointmentBtn.frame.size.width,
                                                   self.appointmentBtn.frame.size.height);
          
            self.appointmentBtn.userInteractionEnabled = NO;
            self.addSBCarBtn.userInteractionEnabled = NO;
            [self.appointmentBtn setTitleColor:[[UIColor CMLWhiteColor] colorWithAlphaComponent:0.2] forState:UIControlStateNormal];
            [self.addSBCarBtn setTitleColor:[[UIColor CMLBlackColor] colorWithAlphaComponent:0.2] forState:UIControlStateNormal];
            
            self.currentHeight = UITabBarHeight + 80*Proportion;
            
        }
        
        if ([self.obj.retData.is_video_project intValue] == 1 && [self.obj.retData.is_buy intValue] == 1 ) {
          
            self.appointmentBtn.userInteractionEnabled = NO;
            self.addSBCarBtn.userInteractionEnabled = NO;
            [self.appointmentBtn setTitleColor:[[UIColor CMLWhiteColor] colorWithAlphaComponent:0.2] forState:UIControlStateNormal];
            [self.addSBCarBtn setTitleColor:[[UIColor CMLBlackColor] colorWithAlphaComponent:0.2] forState:UIControlStateNormal];
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
    
    [self.enterSBCarVCBtn addSubview:spaceLine];
    
}

- (void) appointCUrrentServe{

    [CMLMobClick PurchaseImmediately];
    [self.delegate showProjectMessage];
}

- (void) enterSBCarVC{
    
    
    ShoppingCarVC *vc = [[ShoppingCarVC alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

- (void) addCar{
    
    [CMLMobClick AddToCart];
    [self.delegate addSBCar];
}
@end
