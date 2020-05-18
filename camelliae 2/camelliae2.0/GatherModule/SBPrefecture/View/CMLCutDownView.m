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

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSNumber *status;

@property (nonatomic,strong) UILabel *DLab;

@property (nonatomic,strong) UILabel *HLab;

@property (nonatomic,strong) UILabel *MLab;

@property (nonatomic,strong) UILabel *SLab;

@property (nonatomic,strong) NSTimer *currentTimer;

@property (nonatomic,assign) NSInteger currentS;

@property (nonatomic,assign) NSInteger currentM;

@property (nonatomic,assign) NSInteger currentH;

@property (nonatomic,assign) NSInteger currentD;

@end

@implementation CMLCutDownView

- (instancetype)initWithTime:(NSNumber *) time{

    self = [super init];
    
    if (self) {
        
        self.targetTime = time;
        self.title = @"预售";
        
        self.backgroundColor = [UIColor CMLNewbgBrownColor];
        self.frame = CGRectMake(0,
                                0,
                                WIDTH,
                                80*Proportion);
        [self loadViewsWithType:1];
    }
    
    return self;
}

- (instancetype)initWithObj:(BaseResultObj *) obj {
    
    self = [super init];
    
    if (self) {
        
        self.targetTime = obj.retData.timingInfo.countDown;
        self.status = obj.retData.timingInfo.status;
        self.title = obj.retData.timingInfo.title;
        self.frame = CGRectMake(0,
                                0,
                                WIDTH,
                                80*Proportion);
//        [self loadViewsWithObj];
        [self loadViewsWithType:2];
    }
    
    return self;
}

- (void)loadViewsWithObj {
    
    UILabel *promLab = [[UILabel alloc] init];
    promLab.font = KSystemFontSize14;
    promLab.textColor = [UIColor CMLBlackColor];
    promLab.text =  [NSString stringWithFormat:@"%@",self.title];
    promLab.textAlignment = NSTextAlignmentCenter;
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
    self.DLab.text = [NSString stringWithFormat:@"%02ld",(long)self.currentD];
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
    self.HLab.text = [NSString stringWithFormat:@"%02ld",(long)self.currentH];
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
    
    
    if ([self.status intValue] != 1) {
        
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

- (void)loadViewsWithType:(NSInteger)type {

    /*黑色背景标题*/
    UILabel *promLab = [[UILabel alloc] init];
    promLab.font = KSystemFontSize13;
    promLab.backgroundColor = [UIColor CMLBlackColor];
    promLab.textColor = [UIColor CMLBrownColor];
    promLab.text =  [NSString stringWithFormat:@"%@",self.title];
    promLab.textAlignment = NSTextAlignmentCenter;
    [promLab sizeToFit];
    promLab.frame = CGRectMake(30*Proportion,
                               80*Proportion/2.0 - 46*Proportion/2.0,
                               CGRectGetWidth(promLab.frame),
                               46*Proportion);
    [self addSubview:promLab];
    
    NSTimeInterval  time = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:[self.targetTime integerValue]]];
    
    NSInteger m= fabs(time);
    NSInteger allS = m;
    
    self.currentD =allS/(1*24*60*60);
    
    NSInteger RS = allS%(1*24*60*60);
    
    self.currentH = RS/(60*60);
    
    NSInteger RRS = RS%(60*60);
    
    self.currentM  = RRS/60;
    
    self.currentS = RRS%60;
    
    /*秒*/
    self.SLab = [[UILabel alloc] init];
    self.SLab.textAlignment = NSTextAlignmentCenter;
    self.SLab.backgroundColor = [[UIColor CMLWhiteColor] colorWithAlphaComponent:0.5];
    self.SLab.layer.cornerRadius = 6*Proportion;
    self.SLab.textColor = [UIColor CMLBlackColor];
    self.SLab.text = [NSString stringWithFormat:@"%02ld",(long)self.currentS];
    self.SLab.font = KSystemFontSize12;
    [self.SLab sizeToFit];
    self.SLab.frame = CGRectMake(WIDTH - 30*Proportion - 50*Proportion,
                                 self.frame.size.height/2 - 50*Proportion/2,
                                 50*Proportion,
                                 50*Proportion);
    NSLog(@"self.SLab.frame.origin.y = %f", self.SLab.frame.origin.y);
    NSLog(@"%f", self.frame.size.height);
    NSLog(@"%f", self.frame.size.width);
    [self addSubview:self.SLab];
    
    UILabel *spaceLabOne = [[UILabel alloc] init];
    spaceLabOne.backgroundColor = [UIColor clearColor];
    spaceLabOne.textColor = [UIColor CMLBlackColor];
    spaceLabOne.text = @":";
    spaceLabOne.font = KSystemFontSize12;
    [spaceLabOne sizeToFit];
    spaceLabOne.frame =CGRectMake(self.SLab.frame.origin.x - spaceLabOne.frame.size.width - 10*Proportion,
                                  self.frame.size.height/2.0 - spaceLabOne.frame.size.height/2.0,
                                  spaceLabOne.frame.size.width,
                                  spaceLabOne.frame.size.height);
    [self addSubview:spaceLabOne];
    
    /*分*/
    self.MLab = [[UILabel alloc] init];
    self.MLab.backgroundColor = [[UIColor CMLWhiteColor] colorWithAlphaComponent:0.5];
    self.MLab.textColor = [UIColor CMLBlackColor];
    self.MLab.text = [NSString stringWithFormat:@"%02ld",(long)self.currentM];
    self.MLab.font = KSystemFontSize12;
    self.MLab.layer.cornerRadius = 6*Proportion;
    self.MLab.textAlignment = NSTextAlignmentCenter;
    [self.MLab sizeToFit];
    self.MLab.frame = CGRectMake(spaceLabOne.frame.origin.x - 50*Proportion - 5*Proportion,
                                 self.frame.size.height/2.0 - 50*Proportion/2.0,
                                 50*Proportion,
                                 50*Proportion);
    [self addSubview:self.MLab];
    
    UILabel *spaceLabTwo = [[UILabel alloc] init];
    spaceLabTwo.backgroundColor = [UIColor clearColor];
    spaceLabTwo.textColor = [UIColor CMLBlackColor];
    spaceLabTwo.text = @":";
    spaceLabTwo.font = KSystemFontSize12;
    [spaceLabTwo sizeToFit];
    spaceLabTwo.frame =CGRectMake(self.MLab.frame.origin.x - spaceLabTwo.frame.size.width - 10*Proportion,
                                  self.frame.size.height/2.0 - spaceLabTwo.frame.size.height/2.0,
                                  spaceLabTwo.frame.size.width,
                                  spaceLabTwo.frame.size.height);
    [self addSubview:spaceLabTwo];
    
    /*时*/
    self.HLab = [[UILabel alloc] init];
    self.HLab.backgroundColor = [[UIColor CMLWhiteColor] colorWithAlphaComponent:0.5];
    self.HLab.textColor = [UIColor CMLBlackColor];
    self.HLab.font = KSystemFontSize12;
    self.HLab.text = [NSString stringWithFormat:@"%02ld",(long)self.currentH];
    self.HLab.layer.cornerRadius = 6*Proportion;
    self.HLab.textAlignment = NSTextAlignmentCenter;
    [self.HLab sizeToFit];
    self.HLab.frame = CGRectMake(spaceLabTwo.frame.origin.x - 50*Proportion - 5*Proportion,
                                 self.frame.size.height/2.0 - 50*Proportion/2.0,
                                 50*Proportion,
                                 50*Proportion);
    [self addSubview:self.HLab];
    
    UILabel *DPromLab = [[UILabel alloc] init];
    DPromLab.textColor = [UIColor CMLBlackColor];
    DPromLab.backgroundColor = [UIColor clearColor];
    DPromLab.text = @"天";
    DPromLab.font = KSystemFontSize12;
    [DPromLab sizeToFit];
    DPromLab.frame = CGRectMake(self.HLab.frame.origin.x - DPromLab.frame.size.width - 10*Proportion,
                                self.frame.size.height/2.0 - DPromLab.frame.size.height/2.0,
                                DPromLab.frame.size.width,
                                DPromLab.frame.size.height);
    [self addSubview:DPromLab];
    
    /*天*/
    self.DLab = [[UILabel alloc] init];
    self.DLab.backgroundColor = [[UIColor CMLWhiteColor] colorWithAlphaComponent:0.5];
    self.DLab.textColor = [UIColor CMLBlackColor];
    self.DLab.text = [NSString stringWithFormat:@"%02ld",(long)self.currentD];
    self.DLab.font = KSystemFontSize12;
    self.DLab.textAlignment = NSTextAlignmentCenter;
    [self.DLab sizeToFit];
    self.DLab.frame = CGRectMake(DPromLab.frame.origin.x - 50*Proportion - 5*Proportion,
                                 self.frame.size.height/2.0 - 50*Proportion/2.0,
                                 50*Proportion,
                                 50*Proportion);
    [self addSubview:self.DLab];
    
    /*倒计时*/
    UILabel *promLab2 = [[UILabel alloc] init];
    promLab2.font = KSystemBoldFontSize14;
    promLab2.text = @"倒计时：";
    promLab2.textColor = [UIColor CMLBlackColor];
    [promLab2 sizeToFit];
    promLab2.backgroundColor = [UIColor clearColor];
    promLab2.frame = CGRectMake(self.DLab.frame.origin.x - promLab2.frame.size.width,
                                self.frame.size.height/2.0 - promLab2.frame.size.height/2.0,
                                promLab2.frame.size.width,
                                promLab2.frame.size.height);
    [self addSubview:promLab2];
        
    self.viewHeight = 80*Proportion;
    
    if (type == 2) {
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
    
}

- (void) secondsChange{

    if (self.currentS == 0) {
        
        self.currentS = 59;
        if (self.currentM == 0) {
            
            if (self.currentH == 0) {
                
                if (self.currentD == 0) {
                   
                    self.timeOver();
                    [self.currentTimer invalidate];
                    self.currentTimer = nil;
                    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    self.backgroundColor = [UIColor CMLWhiteColor];

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

    self.SLab.text = [NSString stringWithFormat:@"%02ld",(long)self.currentS];
    self.DLab.text = [NSString stringWithFormat:@"%02ld",(long)self.currentD];
    self.HLab.text = [NSString stringWithFormat:@"%02ld",(long)self.currentH];
    self.MLab.text = [NSString stringWithFormat:@"%02ld",(long)self.currentM];
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
