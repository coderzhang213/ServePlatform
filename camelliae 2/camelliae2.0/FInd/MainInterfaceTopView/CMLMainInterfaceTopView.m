//
//  CMLMainInterfaceTopView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/23.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLMainInterfaceTopView.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "VCManger.h"
#import "CommonImg.h"
#import "CMLSearchVC.h"
#import "CMLActivityCalendar.h"

@interface CMLMainInterfaceTopView ()

@property (nonatomic,strong) UIButton *searchBtn;

@property (nonatomic,strong) UIButton *calendarBtn;

@property (nonatomic,strong) UIImageView *logoImage;

@property (nonatomic,strong) UIView *btnBgView;

@property (nonatomic,strong) NSArray *nameArray;

@property (nonatomic,strong) NSMutableArray *btnArray;

@property (nonatomic,strong) UIView *moveLine;

@end

@implementation CMLMainInterfaceTopView

- (NSMutableArray *)btnArray{
    
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.frame = CGRectMake(0,
                                0,
                                WIDTH,
                                StatusBarHeight + 80*Proportion + 80*Proportion);
        self.backgroundColor = [UIColor CMLWhiteColor];
        [self loadViews];
        self.isUp = NO;
    }
    
    return self;
}

- (void) loadViews{
    
    self.logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NewLogoImg]];
    self.logoImage.clipsToBounds = YES;
    self.logoImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.logoImage sizeToFit];
    self.logoImage.frame = CGRectMake(WIDTH/2.0 - self.logoImage.frame.size.width/2.0,
                                      StatusBarHeight + 80*Proportion/2.0 - self.logoImage.frame.size.height/2.0,
                                      self.logoImage.frame.size.width,
                                      self.logoImage.frame.size.height);
    [self addSubview:self.logoImage];
    
    /**搜索*/
    self.searchBtn = [[UIButton alloc] init];
    [self.searchBtn setImage:[UIImage imageNamed:MainInfaceSearchImg] forState:UIControlStateNormal];
    [self.searchBtn sizeToFit];
    self.searchBtn.frame = CGRectMake(WIDTH - 80*Proportion,
                                      StatusBarHeight,
                                      80*Proportion,
                                      80*Proportion);
    [self.searchBtn addTarget:self action:@selector(enterSearchVC) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.searchBtn];

    /*日历*/
    self.calendarBtn = [[UIButton alloc] init];
    [self.calendarBtn setImage:[UIImage imageNamed:MainInterfaceCalendarImg] forState:UIControlStateNormal];
    [self.calendarBtn sizeToFit];
//    self.calendarBtn.hidden = YES;
    self.calendarBtn.frame = CGRectMake(0,
                                        StatusBarHeight,
                                        80*Proportion,
                                        80*Proportion);
    [self.calendarBtn addTarget:self action:@selector(enterCalendar) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.calendarBtn];
    
    self.nameArray = @[@"推 荐",@"专 题",@"图 集"];

    
    self.btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              StatusBarHeight + 80*Proportion,
                                                              WIDTH,
                                                              80*Proportion)];
    self.btnBgView.backgroundColor = [UIColor CMLWhiteColor];
    [self addSubview:self.btnBgView];
    
    [self refreshNewTypeViews];
    
}


- (void) refreshNewTypeViews{
    
    
    for (int i = 0; i < self.nameArray.count; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/self.nameArray.count*i,
                                                                   0,
                                                                   WIDTH/self.nameArray.count,
                                                                   self.btnBgView.frame.size.height)];
        
        [btn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor CMLNewYellowColor] forState:UIControlStateSelected];
        
        btn.titleLabel.font = KSystemBoldFontSize15;
        [btn setTitle:self.nameArray[i] forState:UIControlStateNormal];
        btn.tag = i + 1;
        [self.btnBgView addSubview:btn];
        [btn addTarget:self action:@selector(SelectClassIndex:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnArray addObject:btn];
        
        
        if (i == 0) {
            btn.titleLabel.font = KSystemRealBoldFontSize15;
            btn.selected = YES;
            _moveLine = [[UIView alloc] init];
            _moveLine.backgroundColor = [UIColor CMLNewYellowColor];
            _moveLine.frame = CGRectMake(btn.center.x - 55*Proportion/2.0,
                                         CGRectGetHeight(self.btnBgView.frame) - 2,
                                         55*Proportion,
                                         2);
            _moveLine.layer.cornerRadius = 1;
            [self.btnBgView addSubview:_moveLine];
        }
    }
    
}

- (void) refreshSelectType:(int) inedx{
    
    UIButton *currentBtn = self.btnArray[inedx];
    
    if (!currentBtn.selected) {
        
        for (int i = 0; i < self.btnArray.count; i ++) {
            
            UIButton *tempBtn = self.btnArray[i];
            
            if (i == inedx) {
                
                tempBtn.selected = YES;
                tempBtn.titleLabel.font = KSystemRealBoldFontSize15;
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.moveLine.frame = CGRectMake(tempBtn.center.x - 55*Proportion/2.0,
                                                         CGRectGetHeight(self.btnBgView.frame) - 2,
                                                         55*Proportion,
                                                         2);
                }];
                
            }else{
                tempBtn.titleLabel.font = KSystemBoldFontSize15;
                tempBtn.selected = NO;
            }
        }
    }
}


- (void) SelectClassIndex:(UIButton *) btn{
    
    if (!btn.selected) {
        
        btn.selected = YES;
        
        [self.delegate selectTypeIndex:(int)(btn.tag - 1)];
        
        for (int i = 0; i < self.btnArray.count; i ++) {
            
            UIButton *tempBtn = self.btnArray[i];
            
            if (i == (int)(btn.tag - 1)) {
                
                tempBtn.selected = YES;
                tempBtn.titleLabel.font = KSystemRealBoldFontSize15;
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.moveLine.frame = CGRectMake(tempBtn.center.x - 55*Proportion/2.0,
                                                         CGRectGetHeight(self.btnBgView.frame) - 2,
                                                         55*Proportion,
                                                         2);
                }];
                
            }else{
                
                tempBtn.selected = NO;
                tempBtn.titleLabel.font = KSystemBoldFontSize15;
            }
        }
    }
}

#pragma mark - enterSearchVC
- (void) enterSearchVC{

    CMLSearchVC *vc = [[CMLSearchVC alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];

}

- (void) enterCalendar{
    
    CMLActivityCalendar *vc = [[CMLActivityCalendar alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) moveUp{
    
    
    self.isUp = YES;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
       
        weakSelf.logoImage.center = CGPointMake(weakSelf.logoImage.center.x, weakSelf.logoImage.center.y - StatusBarHeight/2.0);
        weakSelf.searchBtn.center = CGPointMake(weakSelf.searchBtn.center.x, weakSelf.searchBtn.center.y - StatusBarHeight/2.0);
        weakSelf.calendarBtn.center = CGPointMake(weakSelf.calendarBtn.center.x, weakSelf.calendarBtn.center.y - StatusBarHeight/2.0);
        
        weakSelf.frame = CGRectMake(0,
                                    - 80*Proportion,
                                    WIDTH,
                                    StatusBarHeight + 80*Proportion*2);

    }completion:^(BOOL finished) {
        
        weakSelf.logoImage.hidden = YES;
        weakSelf.searchBtn.hidden = YES;
        weakSelf.calendarBtn.hidden = YES;
    }];
}

- (void) moveDown{
    
    self.isUp = NO;
    
    __weak typeof(self) weakSelf = self;
    weakSelf.logoImage.hidden = NO;
    weakSelf.searchBtn.hidden = NO;
    weakSelf.calendarBtn.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{

        weakSelf.logoImage.center = CGPointMake(weakSelf.logoImage.center.x, weakSelf.logoImage.center.y + StatusBarHeight/2.0);
        weakSelf.searchBtn.center = CGPointMake(weakSelf.searchBtn.center.x, weakSelf.searchBtn.center.y + StatusBarHeight/2.0);
        weakSelf.calendarBtn.center = CGPointMake(weakSelf.calendarBtn.center.x, weakSelf.calendarBtn.center.y + StatusBarHeight/2.0);
        
        weakSelf.frame = CGRectMake(0,
                                    0,
                                    WIDTH,
                                    StatusBarHeight + 80*Proportion*2);

    }];
}
@end
