//
//  ActivityFooterView.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/26.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "ActivityFooterView.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "CommonImg.h"
#import "UIColor+SDExspand.h"
#import "NSString+CMLExspand.h"
#import "NetWorkTask.h"
#import "NetConfig.h"
#import "NetWorkDelegate.h"
#import "BaseResultObj.h"
#import "CMLLine.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "CommemtListVC.h"
#import "VCManger.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"

#define ActivityDefaultVCAppointmentBtnWidth        450

@interface ActivityFooterView ()<NetWorkProtocol>

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) UIButton *appointmentBtn;

@property (nonatomic,strong) UIButton *favBtn;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) UILabel *residueNumLab;

@property (nonatomic,strong) UILabel *isHasTwoTypeLab;

@property (nonatomic,strong) UILabel *tickrtTypeLab;

@property (nonatomic, strong) NSString *isJoin;

@end

@implementation ActivityFooterView

- (instancetype)initWith:(BaseResultObj *)obj withIsJoin:(NSString *)isJoin {

    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.obj = obj;
        self.isJoin = isJoin;
        [self loadViews];
    }
    return self;
}

- (void) loadViews{
    
    if ([self.obj.retData.sysApplyStatus intValue] != 4) {
        
        [self setNormalVCFooterViewBtn];
    }else{
        
        [self setSpecialVCFooterViewBtn];
    }
}

- (instancetype)initUserPushWith:(BaseResultObj *) obj{
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.obj = obj;
        [self loadUserPushView];
    }
    return self;
}

- (void) setNormalVCFooterViewBtn{
    
    self.residueNumLab = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   0,
                                                                   0)];
    self.residueNumLab.textAlignment = NSTextAlignmentCenter;
    self.residueNumLab.font = KSystemBoldFontSize14;
    self.residueNumLab.textColor = [UIColor CMLBlackColor];
    self.residueNumLab.text = [NSString stringWithFormat:@"剩余席位 %@个",self.obj.retData.residueNum];
    NSLog(@"%@", self.obj.retData.residueNum);
    [self.residueNumLab sizeToFit];
    self.residueNumLab.frame = CGRectMake((WIDTH - ActivityDefaultVCAppointmentBtnWidth*Proportion)/2.0 - self.residueNumLab.frame.size.width/2.0,
                                          UITabBarHeight/2.0 - (10*Proportion/2.0 + self.residueNumLab.frame.size.height),
                                          self.residueNumLab.frame.size.width,
                                          self.residueNumLab.frame.size.height);
    [self addSubview:self.residueNumLab];
    
    PackDetailInfoObj *costObj = [PackDetailInfoObj getBaseObjFrom:[self.obj.retData.packageInfo.dataList lastObject]];
    PackDetailInfoObj *freeObj = [PackDetailInfoObj getBaseObjFrom:[self.obj.retData.packageInfo.dataList firstObject]];
    
    if ([costObj.surplusStock intValue] > 0 && [freeObj.surplusStock intValue] > 0 && self.obj.retData.packageInfo.dataList.count > 1 && [freeObj.totalAmount intValue] == 0 && [costObj.totalAmount intValue] > 0) {
        
        self.isHasTwoTypeLab = [[UILabel alloc] init];
        self.isHasTwoTypeLab.font = KSystemBoldFontSize10;
        self.isHasTwoTypeLab.textColor = [UIColor CMLtextInputGrayColor];
        self.isHasTwoTypeLab.text = @"（含收费）";
        [self.isHasTwoTypeLab sizeToFit];
        self.isHasTwoTypeLab.frame = CGRectMake((WIDTH - ActivityDefaultVCAppointmentBtnWidth*Proportion)/2.0 - self.isHasTwoTypeLab.frame.size.width/2.0,
                                                UITabBarHeight/2.0 + 10*Proportion/2.0,
                                                self.isHasTwoTypeLab.frame.size.width,
                                                self.isHasTwoTypeLab.frame.size.height);
        [self addSubview:self.isHasTwoTypeLab];
        
    }else{
    
//        self.tickrtTypeLab = [[UILabel alloc] init];
//        self.tickrtTypeLab.font = KSystemBoldFontSize10;
//        self.tickrtTypeLab.textColor = [UIColor CMLtextInputGrayColor];
//        self.tickrtTypeLab.text = [NSString stringWithFormat:@"%@",costObj.pre_price];
//        [self.tickrtTypeLab sizeToFit];
//        self.tickrtTypeLab.frame = CGRectMake((WIDTH - ActivityDefaultVCAppointmentBtnWidth*Proportion)/2.0 - self.tickrtTypeLab.frame.size.width/2.0,
//                                                UITabBarHeight/2.0 + 10*Proportion/2.0,
//                                                self.tickrtTypeLab.frame.size.width,
//                                                self.tickrtTypeLab.frame.size.height);
//        [self addSubview:self.tickrtTypeLab];
        
        
        self.residueNumLab.frame = CGRectMake((WIDTH - ActivityDefaultVCAppointmentBtnWidth*Proportion)/2.0 - self.residueNumLab.frame.size.width/2.0,
                                              UITabBarHeight/2.0 - self.residueNumLab.frame.size.height/2.0,
                                              self.residueNumLab.frame.size.width,
                                              self.residueNumLab.frame.size.height);

    }
    
    self.appointmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - ActivityDefaultVCAppointmentBtnWidth*Proportion,
                                                                     0,
                                                                     ActivityDefaultVCAppointmentBtnWidth*Proportion,
                                                                     UITabBarHeight)];
    self.appointmentBtn.backgroundColor = [UIColor CMLGreeenColor];
    self.appointmentBtn.titleLabel.font = KSystemRealBoldFontSize17;
    self.appointmentBtn.titleLabel.textColor = [UIColor CMLWhiteColor];
    [self.appointmentBtn setTitle:@"已经预订" forState:UIControlStateSelected];
    [self.appointmentBtn setTitle:self.obj.retData.sysApplyStatusName forState:UIControlStateNormal];/**/
    [self.appointmentBtn addTarget:self action:@selector(showActivityMes) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.appointmentBtn];
    
    /**预约状态判断*/ /***此处判断「免费票已买时，收费票剩余0 -> 确认btn状态」不合适*/
    /*isAllowApply:是否在可预约期内 1 未截止可以继续预约 2 已截止,不能预约*/
    if ([self.obj.retData.isAllowApply intValue] == 1) {
        
        /*isUserSubscribe:是否已被当前用户预约 1已预约 2未预约（该字段已删除）*
        NSLog(@"%@\n%@", self.obj.retData.memberLimitNum, self.obj.retData);
        NSLog(@"%d", ([self.obj.retData.memberLimitNum intValue] - [self.obj.retData.joinNum intValue]));

        if ([self.obj.retData.isUserSubscribe intValue] == 1) {
            [self.appointmentBtn setTitle:@"继续预订" forState:UIControlStateNormal];

            *是否可以继续预约*
            if ([self.obj.retData.residueNum integerValue] < 1) {

                self.appointmentBtn.backgroundColor = [UIColor CMLPromptGrayColor];
                self.appointmentBtn.userInteractionEnabled = NO;

            }

        }else{
            self.appointmentBtn.selected = NO;

            [self.appointmentBtn setTitle:self.obj.retData.sysApplyStatusName forState:UIControlStateNormal];
            *sysApplyStatus:1: 正常可以预约 2: 预约截止 3: 暂未开放预约 4: 此项目不可预约(不显示按钮) 5: 预留功能(名称动态变) webViewlink*
            if ([self.obj.retData.sysApplyStatus intValue] == 1 || [self.obj.retData.sysApplyStatus intValue] == 5) {
                self.appointmentBtn.userInteractionEnabled = YES;
            }else{
                self.appointmentBtn.userInteractionEnabled = NO;
            }
        }

        for (int i = 0; i < self.obj.retData.packageInfo.dataList.count; i++) {
            PackDetailInfoObj *packDetailInfoObj = [PackDetailInfoObj getBaseObjFrom:self.obj.retData.packageInfo.dataList[i]];

        }*/
        
        
        /*剩余席位是否可以继续预约*/
        if ([self.obj.retData.residueNum integerValue] < 1) {/*无票：灰色、对应状态*/
            
            self.appointmentBtn.backgroundColor = [UIColor CMLPromptGrayColor];
            self.appointmentBtn.userInteractionEnabled = NO;
            [self.appointmentBtn setTitle:self.obj.retData.sysApplyStatusName forState:UIControlStateNormal];
            
        }else {/*有票*/
            /*是否有多种票种*/
            if ([self.obj.retData.packageInfo.dataCount integerValue] > 1) {
                
                for (int i = 0; i < self.obj.retData.packageInfo.dataList.count; i++) {
                    PackDetailInfoObj *packDetailInfoObj = [PackDetailInfoObj getBaseObjFrom:self.obj.retData.packageInfo.dataList[i]];
                    
                    /*如果不是粉色*/
                    if ([self.obj.retData.memberLevelId intValue] != 1) {
                        if ([packDetailInfoObj.isBuy intValue] == 1) {/*已购买*/
                            [self.appointmentBtn setTitle:self.obj.retData.sysApplyStatusName forState:UIControlStateNormal];
                            self.appointmentBtn.selected = YES;
                            self.appointmentBtn.userInteractionEnabled = NO;
                            self.appointmentBtn.backgroundColor = [UIColor CMLPromptGrayColor];
                        }
                    }
                    
                    if ([packDetailInfoObj.totalAmount intValue] == 0) {
                        if ([packDetailInfoObj.surplusStock intValue] == [self.obj.retData.residueNum intValue]) {/*免费剩余席位与总剩余席位相同*/
                            if ([packDetailInfoObj.isBuy intValue] == 1) {/*已购买*/
                                [self.appointmentBtn setTitle:self.obj.retData.sysApplyStatusName forState:UIControlStateNormal];
                                self.appointmentBtn.selected = YES;
                                self.appointmentBtn.userInteractionEnabled = NO;
                                self.appointmentBtn.backgroundColor = [UIColor CMLPromptGrayColor];
                            }
                        }
                    }
                }
                
                [self.appointmentBtn setTitle:self.obj.retData.sysApplyStatusName forState:UIControlStateNormal];
                
            }else {/*只有一种票*/
                PackDetailInfoObj *packDetailInfoObj = [PackDetailInfoObj getBaseObjFrom:self.obj.retData.packageInfo.dataList[0]];
                /*是否购买*/
                if ([packDetailInfoObj.isBuy integerValue] == 1) {
                    /*是否免费==0免费 || 是否不是粉色*/
                    if ([packDetailInfoObj.totalAmount integerValue] == 0 || [self.obj.retData.memberLevelId intValue] != 1) {
                        self.appointmentBtn.selected = YES;
                        self.appointmentBtn.userInteractionEnabled = NO;
                        self.appointmentBtn.backgroundColor = [UIColor CMLPromptGrayColor];
                    }else {
//                        [self.appointmentBtn setTitle:@"继续预订" forState:UIControlStateNormal];
                    }
                }else {
                    self.appointmentBtn.selected = NO;
                    [self.appointmentBtn setTitle:self.obj.retData.sysApplyStatusName forState:UIControlStateNormal];
                    /*sysApplyStatus:1: 正常可以预约 2: 预约截止 3: 暂未开放预约 4: 此项目不可预约(不显示按钮) 5: 预留功能(名称动态变) webViewlink*/
                    if ([self.obj.retData.sysApplyStatus intValue] == 1 || [self.obj.retData.sysApplyStatus intValue] == 5) {
                        self.appointmentBtn.userInteractionEnabled = YES;
                    }else{
                        self.appointmentBtn.userInteractionEnabled = NO;
                        [self.appointmentBtn setTitle:self.obj.retData.sysApplyStatusName forState:UIControlStateNormal];
                        self.appointmentBtn.backgroundColor = [UIColor CMLPromptGrayColor];
                    }
                }
            }
        }
        
    }else{
        self.appointmentBtn.backgroundColor = [UIColor CMLPromptGrayColor];
        self.appointmentBtn.userInteractionEnabled = NO;
        [self.appointmentBtn setTitle:self.obj.retData.sysApplyStatusName forState:UIControlStateNormal];
        
    }
    
    CMLLine *line = [[CMLLine alloc] init];
    line.startingPoint = CGPointMake(0, 0);
    line.lineWidth = 0.5;
    line.LineColor = [UIColor CMLPromptGrayColor];
    line.directionOfLine = HorizontalLine;
    line.lineLength = WIDTH;
    [self addSubview:line];
    
    self.currentHeight = UITabBarHeight;
}

- (void) setSpecialVCFooterViewBtn{
    
    self.currentHeight = UITabBarHeight;
}

- (void) loadUserPushView{
    
    self.residueNumLab = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   0,
                                                                   0)];
    self.residueNumLab.textAlignment = NSTextAlignmentCenter;
    self.residueNumLab.font = KSystemBoldFontSize12;
    self.residueNumLab.textColor = [UIColor CMLBlackColor];
    self.residueNumLab.text = [NSString stringWithFormat:@"剩余席位 %@个",self.obj.retData.residueNum];
    [self.residueNumLab sizeToFit];
    [self addSubview:self.residueNumLab];
    
    PackDetailInfoObj *costObj = [PackDetailInfoObj getBaseObjFrom:[self.obj.retData.packageInfo.dataList lastObject]];
        
    self.tickrtTypeLab = [[UILabel alloc] init];
    self.tickrtTypeLab.font = KSystemBoldFontSize14;
    self.tickrtTypeLab.textColor = [UIColor CMLBlackColor];
    if ([costObj.totalAmount intValue] == 0) {
      
        self.tickrtTypeLab.text = @"免费";
    }else{
        self.tickrtTypeLab.text = [NSString stringWithFormat:@"￥%@",costObj.totalAmount];
        
    }
    
    [self.tickrtTypeLab sizeToFit];
    self.tickrtTypeLab.frame = CGRectMake((WIDTH - ActivityDefaultVCAppointmentBtnWidth*Proportion)/2.0 - self.tickrtTypeLab.frame.size.width/2.0,
                                          UITabBarHeight/2.0 - (10*Proportion/2.0 + self.residueNumLab.frame.size.height),
                                          self.tickrtTypeLab.frame.size.width,
                                          self.tickrtTypeLab.frame.size.height);
    [self addSubview:self.tickrtTypeLab];
        
        
    self.residueNumLab.frame = CGRectMake((WIDTH - ActivityDefaultVCAppointmentBtnWidth*Proportion)/2.0 - self.residueNumLab.frame.size.width/2.0,
                                          CGRectGetMaxY(self.tickrtTypeLab.frame) + 10*Proportion,
                                          self.residueNumLab.frame.size.width,
                                          self.residueNumLab.frame.size.height);
    
    
    
    self.appointmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - ActivityDefaultVCAppointmentBtnWidth*Proportion,
                                                                     0,
                                                                     ActivityDefaultVCAppointmentBtnWidth*Proportion,
                                                                     UITabBarHeight)];
    self.appointmentBtn.backgroundColor = [UIColor CMLGreeenColor];
    self.appointmentBtn.titleLabel.font = KSystemRealBoldFontSize17;
    self.appointmentBtn.titleLabel.textColor = [UIColor CMLWhiteColor];
    [self.appointmentBtn setTitle:@"已经预约" forState:UIControlStateSelected];
    NSLog(@"%d", self.appointmentBtn.selected);
    [self.appointmentBtn addTarget:self action:@selector(showActivityMes) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.appointmentBtn];
    
    /**预约状态判断*/
    if ([self.obj.retData.isAllowApply intValue] == 1 || [self.isJoin intValue] == 1) {

        /*isUserSubscribe:是否已被当前用户预约 1已预约 2未预约（该字段已删除）*
        if ([self.obj.retData.isUserSubscribe intValue] == 1) {
            self.appointmentBtn.selected = YES;
            self.appointmentBtn.userInteractionEnabled = NO;
        }else{
            self.appointmentBtn.selected = NO;
            
            [self.appointmentBtn setTitle:self.obj.retData.sysApplyStatusName forState:UIControlStateNormal];
            if ([self.obj.retData.sysApplyStatus intValue] == 1 || [self.obj.retData.sysApplyStatus intValue] == 5) {
                self.appointmentBtn.userInteractionEnabled = YES;
            }else{
                self.appointmentBtn.userInteractionEnabled = NO;
            }
        }*/
        
        PackDetailInfoObj *packDetailInfoObj = [PackDetailInfoObj getBaseObjFrom:self.obj.retData.packageInfo.dataList[0]];
        /*是否购买*/
        if ([packDetailInfoObj.isBuy integerValue] == 1) {
            /*是否免费==0免费*/
            self.appointmentBtn.selected = YES;
            self.appointmentBtn.userInteractionEnabled = NO;
            self.appointmentBtn.backgroundColor = [UIColor CMLPromptGrayColor];

        }else {
            self.appointmentBtn.selected = NO;
            [self.appointmentBtn setTitle:self.obj.retData.sysApplyStatusName forState:UIControlStateNormal];
            /*sysApplyStatus:1: 正常可以预约 2: 预约截止 3: 暂未开放预约 4: 此项目不可预约(不显示按钮) 5: 预留功能(名称动态变) webViewlink*/
            if ([self.obj.retData.sysApplyStatus intValue] == 1 || [self.obj.retData.sysApplyStatus intValue] == 5) {
                self.appointmentBtn.userInteractionEnabled = YES;
            }else{
                self.appointmentBtn.userInteractionEnabled = NO;
                [self.appointmentBtn setTitle:self.obj.retData.sysApplyStatusName forState:UIControlStateNormal];
                self.appointmentBtn.backgroundColor = [UIColor CMLPromptGrayColor];
            }
        }

    }else{
        self.appointmentBtn.backgroundColor = [UIColor CMLPromptGrayColor];
        self.appointmentBtn.userInteractionEnabled = NO;
        [self.appointmentBtn setTitle:self.obj.retData.sysApplyStatusName forState:UIControlStateNormal];
        
    }
    
    CMLLine *line = [[CMLLine alloc] init];
    line.startingPoint = CGPointMake(0, 0);
    line.lineWidth = 0.5;
    line.LineColor = [UIColor CMLPromptGrayColor];
    line.directionOfLine = HorizontalLine;
    line.lineLength = WIDTH;
    [self addSubview:line];
    
    self.currentHeight = UITabBarHeight;

}

- (void) confirmAppointment{

    int num = [self.obj.retData.residueNum intValue];
    self.residueNumLab.text = [NSString stringWithFormat:@"剩余席位 %d个",num - 1];
    [self.residueNumLab sizeToFit];
    self.residueNumLab.frame = CGRectMake((WIDTH - ActivityDefaultVCAppointmentBtnWidth*Proportion)/2.0 - self.residueNumLab.frame.size.width/2.0,
                                         self.residueNumLab.frame.origin.y,
                                          self.residueNumLab.frame.size.width,
                                          self.residueNumLab.frame.size.height);
    
    
    self.appointmentBtn.backgroundColor = [UIColor CMLPromptGrayColor];
    self.appointmentBtn.selected = YES;
    self.appointmentBtn.userInteractionEnabled = NO;

}

- (void) showActivityMes{
    
    [self.delegate showActivityMessage];
}

@end
