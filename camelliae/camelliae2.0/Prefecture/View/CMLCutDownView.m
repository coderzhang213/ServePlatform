//
//  CMLCutDownView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/11.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLCutDownView.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NSDate+CMLExspand.h"
#import "UIColor+SDExspand.h"
#import "BaseResultObj.h"
#import "TimingInfoObj.h"

@interface CMLCutDownView()

@property (nonatomic,strong) NSNumber *targetTime;

@property (nonatomic,strong) NSNumber *status;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) UILabel *DLab;

@property (nonatomic,strong) UILabel *HLab;

@property (nonatomic,strong) UILabel *MLab;

@property (nonatomic,strong) NSTimer *currentTimer;

@property (nonatomic,assign) NSInteger currentS;

@property (nonatomic,assign) NSInteger currentM;

@property (nonatomic,assign) NSInteger currentH;

@property (nonatomic,assign) NSInteger currentD;


@end

@implementation CMLCutDownView

- (instancetype)initWithObj:(BaseResultObj *) obj;{

    self = [super init];
    
    if (self) {
        
        self.targetTime = obj.retData.timingInfo.countDown;
        self.status = obj.retData.timingInfo.status;
        self.title = obj.retData.timingInfo.title;
        
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{

    UILabel *promLab = [[UILabel alloc] init];
    promLab.font = KSystemFontSize14;
    promLab.textColor = [UIColor CMLBlackColor];
    promLab.text =  [NSString stringWithFormat:@"%@",self.title];
    [promLab sizeToFit];
    promLab.frame = CGRectMake(30*Proportion,
                               40*Proportion,
                               promLab.frame.size.width,
                               promLab.frame.size.height);
    [self addSubview:promLab];
    
    
    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDate *targetDate = [NSDate dateWithTimeIntervalSince1970:[self.targetTime integerValue]];
    
    NSTimeInterval  time = [currentDate timeIntervalSinceDate:targetDate];
    
    NSInteger allS= fabs(time);
    
    self.currentD =allS/(1*24*60*60);
    
    NSInteger RS = allS%(1*24*60*60);
    
    self.currentH = RS/(60*60);
    
    NSInteger RRS = RS%(60*60);
    
    self.currentM  = RRS/60;
    
    self.currentS = RRS%60;
    
    
    UIView *DView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(promLab.frame) + 10*Proportion,
                                                            promLab.center.y - 40*Proportion/2.0,
                                                            54*Proportion,
                                                             40*Proportion)];
    DView.backgroundColor = [UIColor CMLGreeenColor];
    [self addSubview:DView];
    
    self.DLab = [[UILabel alloc] init];
    self.DLab.backgroundColor = [UIColor CMLGreeenColor];
    self.DLab.textColor = [UIColor CMLWhiteColor];
    self.DLab.text = [NSString stringWithFormat:@"%02ld",self.currentD];
    self.DLab.font = KSystemBoldFontSize14;
    self.DLab.textAlignment = NSTextAlignmentCenter;
    [self.DLab sizeToFit];
    self.DLab.frame = CGRectMake(54*Proportion/2.0 - self.DLab.frame.size.width/2.0,
                                 40*Proportion/2.0 - self.DLab.frame.size.height/2.0,
                                 self.DLab.frame.size.width,
                                 self.DLab.frame.size.height);
    [DView addSubview:self.DLab];
    
    
    UILabel *DPromLab = [[UILabel alloc] init];
    DPromLab.textColor = [UIColor CMLBlackColor];
    DPromLab.text = @"天";
    DPromLab.font = KSystemFontSize14;
    [DPromLab sizeToFit];
    DPromLab.frame = CGRectMake(CGRectGetMaxX(DView.frame) + 5*Proportion,
                                DView.center.y - DPromLab.frame.size.height/2.0,
                                DPromLab.frame.size.width,
                                DPromLab.frame.size.height);
    [self addSubview:DPromLab];
    
    UIView *HView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(DPromLab.frame) + 5*Proportion,
                                                            promLab.center.y - 40*Proportion/2.0,
                                                            54*Proportion,
                                                             40*Proportion)];
    HView.backgroundColor = [UIColor CMLGreeenColor];
    [self addSubview:HView];
    
    self.HLab = [[UILabel alloc] init];
    self.HLab.backgroundColor = [UIColor CMLGreeenColor];
    self.HLab.textColor = [UIColor CMLWhiteColor];
    self.HLab.font = KSystemBoldFontSize14;
    self.HLab.text = [NSString stringWithFormat:@"%02ld",self.currentH];
    [self.HLab sizeToFit];
    self.HLab.frame = CGRectMake(54*Proportion/2.0 - self.HLab.frame.size.width/2.0,
                                 40*Proportion/2.0 - self.HLab.frame.size.height/2.0,
                                 self.HLab.frame.size.width,
                                 self.HLab.frame.size.height);
    
    [HView addSubview:self.HLab];
    
    UILabel *HPromLab = [[UILabel alloc] init];
    HPromLab.textColor = [UIColor CMLBlackColor];
    HPromLab.text = @"时";
    HPromLab.font = KSystemFontSize14;
    [HPromLab sizeToFit];
    HPromLab.frame = CGRectMake(CGRectGetMaxX(HView.frame) + 5*Proportion,
                                HView.center.y - HPromLab.frame.size.height/2.0,
                                HPromLab.frame.size.width,
                                HPromLab.frame.size.height);
    [self addSubview:HPromLab];
    
    UIView *MView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(HPromLab.frame) + 5*Proportion,
                                                             promLab.center.y - 40*Proportion/2.0,
                                                             54*Proportion,
                                                             40*Proportion)];
    MView.backgroundColor = [UIColor CMLGreeenColor];
    [self addSubview:MView];
    
    self.MLab = [[UILabel alloc] init];
    self.MLab.backgroundColor = [UIColor CMLGreeenColor];
    self.MLab.textColor = [UIColor CMLWhiteColor];
    self.MLab.text = [NSString stringWithFormat:@"%02ld",self.currentM];
    self.MLab.font = KSystemBoldFontSize14;
    [self.MLab sizeToFit];
    self.MLab.frame = CGRectMake(54*Proportion/2.0 - self.MLab.frame.size.width/2.0,
                                 40*Proportion/2.0 - self.MLab.frame.size.height/2.0,
                                 self.MLab.frame.size.width,
                                 self.MLab.frame.size.height);
    [MView addSubview:self.MLab];
    
    UILabel *MPromLab = [[UILabel alloc] init];
    MPromLab.textColor = [UIColor CMLBlackColor];
    MPromLab.text = @"分";
    MPromLab.font = KSystemFontSize14;
    [MPromLab sizeToFit];
    MPromLab.frame = CGRectMake(CGRectGetMaxX(MView.frame) + 5*Proportion,
                                MView.center.y - MPromLab.frame.size.height/2.0,
                                MPromLab.frame.size.width,
                                MPromLab.frame.size.height);
    [self addSubview:MPromLab];
    
    
    if ([self.status intValue] == 1) {
        
        self.viewHeight = CGRectGetMaxY(promLab.frame);
        
        if (!self.currentTimer) {
         
            self.currentTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                 target:self
                                                               selector:@selector(secondsChange)
                                                               userInfo:nil
                                                                repeats:YES];
        }

    }else{
    
        self.viewHeight = 0;
        self.hidden = YES;
    }
    
}

- (void) secondsChange{

    if (self.currentS == 0) {
        
        self.currentS = 59;
        if (self.currentM == 0) {
            
            if (self.currentH == 0) {
                
                if (self.currentD == 0) {
                   
                    [self.currentTimer invalidate];
                    self.currentTimer = nil;

                }else{
                    self.currentM = 59;
                    self.currentH = 23;
                    self.currentD --;
                }
            }else{
            
                self.currentM = 59;
                self.currentH --;
            }
        }else{
        
            self.currentM --;
        }
    }else{
    
        self.currentS --;
    }
        
    [self refreshTime];
}

- (void) refreshTime{

    self.DLab.text = [NSString stringWithFormat:@"%02ld",self.currentD];
    self.HLab.text = [NSString stringWithFormat:@"%02ld",self.currentH];
    self.MLab.text = [NSString stringWithFormat:@"%02ld",self.currentM];
}

- (void) removeTimer{

    [self.currentTimer invalidate];
    self.currentTimer = nil;
}

- (void) startTimer{

    if (!self.currentTimer) {
     
        self.currentTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                             target:self
                                                           selector:@selector(secondsChange)
                                                           userInfo:nil
                                                            repeats:YES];
    }
}
@end
