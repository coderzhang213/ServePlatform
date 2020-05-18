//
//  CMLActivityCalendar.m
//  camelliae2.0
//
//  Created by 张越 on 2017/4/10.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLActivityCalendar.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "VCManger.h"
#import "NSDate+CMLExspand.h"
#import "CMLActivityTVCell.h"
#import "DataManager.h"
#import "WebViewLinkVC.h"
#import "ActivityDefaultVC.h"
#import "CMLUserPushActivityDetailVC.h"

#define LeftMargin      20
#define Space           20
#define CellModuleHeight  112

@interface CMLActivityCalendar ()<NavigationBarProtocol,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,NetWorkProtocol>

@property (nonatomic,strong) UILabel *currentMonthLab;

@property (nonatomic,strong) UIView *daysBgView;

@property (nonatomic,strong) UIView *allDaysPromWeekBgView;

@property (nonatomic,strong) UIScrollView *simpleDaysBgView;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,strong) UIView *moveView;

@property (nonatomic,strong) UITableView *mainTableView;

/*****************************************/

@property (nonatomic,assign) int month;

@property (nonatomic,assign) int year;

@property (nonatomic,assign) int day;

@property (nonatomic,assign) int selectMonth;

@property (nonatomic,assign) int selectYear;

@property (nonatomic,assign) int currentTime;

@property (nonatomic,assign) int selectMonthAllDays;

@property (nonatomic,assign) int selectDayperformance;

@property (nonatomic,assign) CGFloat activityHeight;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) NSMutableArray *selectMonthDays;

@property (nonatomic,strong) NSMutableArray *selectMonthDaysPromWeek;

@property (nonatomic,strong) NSMutableDictionary *calulaterDic;

@property (nonatomic,assign) int dateMax;

@property (nonatomic,assign) int dateMin;


@property (nonatomic,strong) NSMutableArray *selectMonthDataArray;


@end

@implementation CMLActivityCalendar

- (NSMutableArray *)selectMonthDataArray{

    if (!_selectMonthDataArray) {
        _selectMonthDataArray = [NSMutableArray array];
    }
    return _selectMonthDataArray;
}

- (NSMutableDictionary *)calulaterDic{

    if (!_calulaterDic) {
        _calulaterDic = [NSMutableDictionary dictionary];
    }
    return _calulaterDic;
}

- (NSMutableArray *)selectMonthDays{

    if (!_selectMonthDays) {
        _selectMonthDays = [NSMutableArray array];
    }
    return _selectMonthDays;
}

- (NSMutableArray *)selectMonthDaysPromWeek{

    if (!_selectMonthDaysPromWeek) {
        _selectMonthDaysPromWeek = [NSMutableArray array];
    }
    return _selectMonthDaysPromWeek;
}

- (void)viewDidLoad{

    [super viewDidLoad];
    
    [CMLMobClick activityCalendarEvent];
    
    
    self.navBar.titleContent = @"活动日历";
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.delegate = self;
    [self.navBar setLeftBarItem];
    self.contentView.backgroundColor = [UIColor CMLYellowColor];

    [self loadData];
    
}

- (void) loadViews{

    [self loadTopCell];
    
    [self loadAllDays];
    
}

- (void) loadData{

    /**当前时间*/
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [NSDate date];
    NSString * str = [formatter stringFromDate:date];
    NSArray * array = [str componentsSeparatedByString:@"-"];
    
    self.currentTime = [[NSString stringWithFormat:@"%d%02d%02d",
                         [[array firstObject] intValue],
                         [array[1] intValue],
                         [[array lastObject] intValue]] intValue];
    
    self.month = [array[1] intValue];
    self.day = [[array lastObject] intValue];
    self.year = [[array firstObject] intValue];
    
    self.selectMonth = self.month;
    self.selectYear = self.year;
    
    [self getActivityCellHeight];
    
    [self getCalulaterData];
    
}


- (void) loadTopCell{

    self.currentMonthLab = [[UILabel alloc] init];
    self.currentMonthLab.font = KSystemBoldFontSize16;
    self.currentMonthLab.textColor = [UIColor CMLBlackColor];
    self.currentMonthLab.text = [NSString stringWithFormat:@"%02d-%d",self.selectMonth,self.selectYear];
    [self.currentMonthLab sizeToFit];
    self.currentMonthLab.frame = CGRectMake(WIDTH/2.0 - self.currentMonthLab.frame.size.width/2.0,
                                            CGRectGetMaxY(self.navBar.frame),
                                            self.currentMonthLab.frame.size.width,
                                            80*Proportion);
    [self.contentView addSubview:self.currentMonthLab];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(LeftMargin*Proportion,
                                                                   CGRectGetMaxY(self.navBar.frame),
                                                                   80*Proportion,
                                                                   80*Proportion)];
    leftBtn.backgroundColor = [UIColor clearColor];
    [leftBtn setBackgroundImage:[UIImage imageNamed:CalendarLeftBtnImg] forState:UIControlStateNormal];
    [self.contentView addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(reduceMonth) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - LeftMargin*Proportion - 80*Proportion,
                                                                   CGRectGetMaxY(self.navBar.frame),
                                                                   80*Proportion,
                                                                   80*Proportion)];
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn setBackgroundImage:[UIImage imageNamed:CalendarRightBtnImg] forState:UIControlStateNormal];
    [self.contentView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(addMonth) forControlEvents:UIControlEventTouchUpInside];
    
    /**全天星期头*/
    self.allDaysPromWeekBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                          CGRectGetMaxY(self.navBar.frame) + 80*Proportion,
                                                                          WIDTH,
                                                                          WIDTH/7.0)];
    self.allDaysPromWeekBgView.backgroundColor = [UIColor CMLYellowColor];
    [self.contentView addSubview:self.allDaysPromWeekBgView];
    

    NSArray *weekAry = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    for (int i = 0; i < weekAry.count; i++) {
        
        UILabel *weekLabel = [[UILabel alloc] init];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        weekLabel.font = KSystemBoldFontSize12;
        weekLabel.textColor = [UIColor CMLBlackColor];
        weekLabel.text = weekAry[i];
        weekLabel.backgroundColor = [UIColor clearColor];
        [weekLabel sizeToFit];
        weekLabel.frame = CGRectMake(LeftMargin*Proportion + (WIDTH - LeftMargin*Proportion*2)/7.0*i,
                                     0,
                                     (WIDTH - LeftMargin*Proportion*2)/7.0,
                                     weekLabel.frame.size.height + 40*Proportion);
        if (i == weekAry.count - 1) {
            
            self.allDaysPromWeekBgView.frame = CGRectMake(0,
                                                          CGRectGetMaxY(self.navBar.frame) + 80*Proportion,
                                                          WIDTH,
                                                          weekLabel.frame.size.height);
        }
        [self.allDaysPromWeekBgView addSubview:weekLabel];
        
    }
    
    
    
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         CGRectGetMaxY(self.allDaysPromWeekBgView.frame),
                                                                         WIDTH,
                                                                         HEIGHT - CGRectGetMaxY(self.allDaysPromWeekBgView.frame))];
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.delegate = self;
    self.mainScrollView.backgroundColor = [UIColor CMLYellowColor];
    [self.contentView addSubview:self.mainScrollView];
    
    /**详细时间展示*/
    self.daysBgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH,
                                                               0,
                                                               WIDTH,
                                                               self.mainScrollView.frame.size.height)];
    self.daysBgView.backgroundColor = [UIColor CMLYellowColor];
    [self.mainScrollView addSubview:self.daysBgView];
    
    
    /**简单时间展示*/
    self.simpleDaysBgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                           CGRectGetMaxY(self.navBar.frame),
                                                                           WIDTH,
                                                                           140*Proportion)];
    self.simpleDaysBgView.showsVerticalScrollIndicator = NO;
    self.simpleDaysBgView.showsHorizontalScrollIndicator = NO;
    self.simpleDaysBgView.backgroundColor = [UIColor CMLYellowColor];
    self.simpleDaysBgView.alpha = 0;
    [self.contentView addSubview:self.simpleDaysBgView];
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       HEIGHT - 200*Proportion,
                                                                       WIDTH,
                                                                       HEIGHT - CGRectGetMaxY(self.simpleDaysBgView.frame))];
    self.mainTableView.backgroundColor = [UIColor CMLWhiteColor];
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    if (@available(iOS 11.0, *)){
        self.mainTableView.estimatedRowHeight = 0;
        self.mainTableView.estimatedSectionHeaderHeight = 0;
        self.mainTableView.estimatedSectionFooterHeight = 0;
    }
    [self.contentView addSubview:self.mainTableView];

    
}

- (void) loadAllDays{

    [self.daysBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    /**时间转化*/
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *string = [NSString stringWithFormat:@"%d-%02d",self.year,self.month];
    NSDate *currentDate = [formatter dateFromString:string];
    
    /**该月第一天**/
    NSDateFormatter * formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy年MM"];
    NSString * str = [formatter1 stringFromDate:currentDate];
    
    NSArray * array = [str componentsSeparatedByString:@"年"];
    NSString *targetDay=[NSString stringWithFormat:@"%@:%@:01",[array firstObject],[array lastObject]];
    NSDateFormatter * targetFormatter =[[NSDateFormatter alloc] init];
    [targetFormatter setDateFormat:@"yyyy:MM:dd"];
    NSDate *targetDate = [targetFormatter dateFromString:targetDay];
    /****/
    
    CGFloat currentLeftMargin = LeftMargin*Proportion;
    CGFloat currentTopMargin = 20*Proportion;
    CGFloat currentWidth = (WIDTH - LeftMargin*Proportion*2)/7.0;
    NSString *weekStr =  [[NSDate getTheWeekOfDate:targetDate] substringFromIndex:2];
    
    
    if ([weekStr isEqualToString:@"日"]) {
        
        currentLeftMargin = LeftMargin*Proportion;
        
    }else if ([weekStr isEqualToString:@"一"]){
        
        currentLeftMargin = LeftMargin*Proportion + currentWidth;
        
    }else if ([weekStr isEqualToString:@"二"]){
        
        currentLeftMargin = LeftMargin*Proportion + currentWidth*2;
        
    }else if ([weekStr isEqualToString:@"三"]){
        
        currentLeftMargin = LeftMargin*Proportion + currentWidth*3;
    }else if ([weekStr isEqualToString:@"四"]){
        
        currentLeftMargin = LeftMargin*Proportion + currentWidth*4;
    }else if ([weekStr isEqualToString:@"五"]){
        
        currentLeftMargin = LeftMargin*Proportion + currentWidth*5;
        
    }else if ([weekStr isEqualToString:@"六"]){
        
        currentLeftMargin = LeftMargin*Proportion + currentWidth*6;
    }
    
    /**月份天数*/
    self.selectMonthAllDays = (int) [NSDate getMonthAllDays:currentDate];
    
    
    for (int i = 1; i <= (int)[NSDate getMonthAllDays:currentDate]; i++) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(currentLeftMargin,
                                                                 currentTopMargin,
                                                                 currentWidth,
                                                                  CellModuleHeight*Proportion)];
        bgView.layer.cornerRadius = 4*Proportion;
        bgView.backgroundColor = [UIColor clearColor];
        [self.daysBgView addSubview:bgView];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      currentWidth,
                                                                      CellModuleHeight*Proportion)];
        button.layer.cornerRadius = 4*Proportion;
        button.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = [NSString stringWithFormat:@"%d",i];
        label.userInteractionEnabled = YES;
        label.font = KSystemFontSize16;
        label.backgroundColor = [UIColor clearColor];
        [label sizeToFit];
        label.frame = CGRectMake(bgView.frame.size.width/2.0 - label.frame.size.width/2.0,
                                 20*Proportion,
                                 label.frame.size.width,
                                 label.frame.size.height);
        [bgView addSubview:label];
        label.textColor = [UIColor CMLBlackColor];
        
        UILabel *performanceLab = [[UILabel alloc] init];
        performanceLab.textColor = [UIColor CMLCalendarBlackColor];
        performanceLab.font = KSystemFontSize10;
        performanceLab.backgroundColor = [UIColor clearColor];
        performanceLab.userInteractionEnabled = YES;
        

        
        if ([self.calulaterDic valueForKey:[NSString stringWithFormat:@"%d%02d%02d",self.year,self.month,i]]) {
            
            
            performanceLab.text = [NSString stringWithFormat:@"%@场",[self.calulaterDic valueForKey:[NSString stringWithFormat:@"%d%02d%02d",self.year,self.month,i]]];
            
        }else{
            performanceLab.text = @"0场";
        }
        [performanceLab sizeToFit];
        performanceLab.frame = CGRectMake(bgView.frame.size.width/2.0 - performanceLab.frame.size.width/2.0,
                                          bgView.frame.size.height - 20*Proportion - performanceLab.frame.size.height,
                                          performanceLab.frame.size.width,
                                          performanceLab.frame.size.height);

        [bgView addSubview:performanceLab];
        
        if ([[NSString stringWithFormat:@"%d%02d%02d",self.year,self.month,i] intValue] == [[NSString stringWithFormat:@"%d%02d%02d",self.selectYear,self.selectMonth,self.day] intValue]) {
            
            bgView.backgroundColor = [UIColor whiteColor];
            performanceLab.textColor = [UIColor CMLBlackColor];
            
        }else if ([[NSString stringWithFormat:@"%d%02d%02d",self.year,self.month,i] intValue] > self.dateMax){
            
            performanceLab.hidden = YES;
            button.userInteractionEnabled = NO;
            
        }
//        else if ([[NSString stringWithFormat:@"%d%02d%02d",self.year,self.month,i] intValue] < self.currentTime || [[NSString stringWithFormat:@"%d%02d%02d",self.year,self.month,i] intValue] > self.dateMax){
//
//            performanceLab.hidden = YES;
//            button.userInteractionEnabled = NO;
//
//        }
        
        if ([[NSString stringWithFormat:@"%d%02d%02d",self.year,self.month,i] intValue] == self.currentTime) {
            
            if (self.day != i) {
                
                UIView *dian = [[UIView alloc] initWithFrame:CGRectMake(label.center.x - 12*Proportion/2.0,
                                                                        label.frame.origin.y - 12*Proportion - 13*Proportion,
                                                                        12*Proportion,
                                                                        12*Proportion)];
                dian.layer.cornerRadius = 12*Proportion/2.0;
                dian.backgroundColor = [UIColor whiteColor];
                [button addSubview:dian];

            }            
        }
        
        button.tag = i;
        [bgView addSubview:button];
        [button addTarget:self action:@selector(changeStyle:) forControlEvents:UIControlEventTouchUpInside];
        

        if (i == (int)[NSDate getMonthAllDays:currentDate]) {
         
            self.daysBgView.frame = CGRectMake(self.daysBgView.frame.origin.x,
                                               self.daysBgView.frame.origin.y,
                                               WIDTH,
                                               CGRectGetMaxY(bgView.frame));
            self.mainScrollView.frame = CGRectMake(self.mainScrollView.frame.origin.x,
                                                   self.mainScrollView.frame.origin.y,
                                                   WIDTH,
                                                   self.daysBgView.frame.size.height + 40*Proportion);
            
            self.mainScrollView.contentSize = CGSizeMake(WIDTH*3, self.mainScrollView.frame.size.height);
            self.mainScrollView.contentOffset = CGPointMake(WIDTH, 0);
        }
    
        /**frame*/
        currentLeftMargin += currentWidth;
        if (currentLeftMargin > (WIDTH - 30*Proportion)) {
            
            currentLeftMargin = LeftMargin*Proportion;
            currentTopMargin += (CellModuleHeight + Space)*Proportion;
        }
    }
}

- (void) loadSimpleDays{
    
    
    [self.simpleDaysBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    self.moveView = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                             20*Proportion,
                                                             (WIDTH - 30*Proportion*2)/7,
                                                             140*Proportion - 20*Proportion*2)];
    self.moveView.layer.cornerRadius = 4*Proportion;
    self.moveView.backgroundColor = [UIColor whiteColor];
    [self.simpleDaysBgView addSubview:self.moveView];
    
    NSLog(@"***%ld",self.selectMonthDaysPromWeek.count);
    for (int i = 0; i < self.selectMonthDaysPromWeek.count; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30*Proportion + (WIDTH - 30*Proportion*2)/7*i,
                                                                      20*Proportion,
                                                                      (WIDTH - 30*Proportion*2)/7,
                                                                      140*Proportion - 20*Proportion*2)];
        button.tag = i;
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(refreshSelectDayList:) forControlEvents:UIControlEventTouchUpInside];
        [self.simpleDaysBgView addSubview:button];
        
        
        
        UILabel *weekPromLab = [[UILabel alloc] init];
        weekPromLab.font = KSystemFontSize12;
        weekPromLab.text = self.selectMonthDaysPromWeek[i];
        weekPromLab.textColor = [UIColor CMLBlackColor];
        [weekPromLab sizeToFit];
        weekPromLab.frame = CGRectMake((WIDTH - 30*Proportion*2)/7/2.0 - weekPromLab.frame.size.width/2.0,
                                       10*Proportion,
                                       weekPromLab.frame.size.width,
                                       weekPromLab.frame.size.height);
        [button addSubview:weekPromLab];
        
        UILabel *dayPromLab = [[UILabel alloc] init];
        dayPromLab.font = KSystemFontSize16;
        dayPromLab.text = [NSString stringWithFormat:@"%@",self.selectMonthDays[i]];
        dayPromLab.textColor = [UIColor CMLBlackColor];
        [dayPromLab sizeToFit];
        dayPromLab.frame = CGRectMake((WIDTH - 30*Proportion*2)/7/2.0 - dayPromLab.frame.size.width/2.0,
                                      button.frame.size.height - 10*Proportion - dayPromLab.frame.size.height,
                                      dayPromLab.frame.size.width,
                                      dayPromLab.frame.size.height);
        [button addSubview:dayPromLab];
        
        if ([self.selectMonthDays[i] intValue] == self.day) {
            
            self.moveView.center = button.center;
            self.simpleDaysBgView.contentOffset = CGPointMake(button.frame.origin.x - 20*Proportion, 0);
        }
        
        if (i == self.selectMonthDaysPromWeek.count - 1) {
            
            self.simpleDaysBgView.contentSize = CGSizeMake(CGRectGetMaxX(button.frame) + 30*Proportion, self.simpleDaysBgView.frame.size.height);
            
            if (self.simpleDaysBgView.contentSize.width - self.simpleDaysBgView.contentOffset.x < WIDTH) {
                
                self.simpleDaysBgView.contentOffset = CGPointMake(self.simpleDaysBgView.contentSize.width - WIDTH, 0);
            }
        }
    }
}

- (void)addMonth{

    NSArray * array = [self.currentMonthLab.text componentsSeparatedByString:@"-"];
    self.month = [[array firstObject] intValue];
    self.month ++;
   

    
    if ( [[NSString stringWithFormat:@"%d%02d01",self.year,self.month] intValue]> self.dateMax ) {
        
        self.month --;
        
    }else{
    
        if (self.month > 12) {
            
            self.year = [[array lastObject] intValue];
            self.year++;
            self.month = 1;
            self.currentMonthLab.text = [NSString stringWithFormat:@"%02d-%d",self.month,self.year];
        }else{
            
            self.year = [[array lastObject] intValue];
            self.currentMonthLab.text = [NSString stringWithFormat:@"%02d-%d",self.month,self.year];
        }
        
        [self.currentMonthLab sizeToFit];
        self.currentMonthLab.frame = CGRectMake(WIDTH/2.0 - self.currentMonthLab.frame.size.width/2.0,
                                                CGRectGetMaxY(self.navBar.frame),
                                                self.currentMonthLab.frame.size.width,
                                                80*Proportion);
        
        [self loadAllDays];
        
        self.mainTableView.frame = CGRectMake(0,
                                              CGRectGetMaxY(self.mainScrollView.frame),
                                              WIDTH,
                                              HEIGHT - CGRectGetMaxY(self.simpleDaysBgView.frame));
    }
    
}

- (void) reduceMonth{

    NSArray * array = [self.currentMonthLab.text componentsSeparatedByString:@"-"];
    self.month = [[array firstObject] intValue];
    self.month --;
    NSString *timeStr = [NSString stringWithFormat:@"%d%02d01",self.year,self.month];
  
//    self.month < [[[NSString stringWithFormat:@"%d",self.currentTime] substringWithRange:NSMakeRange(4, 2)] intValue] && self.year == [[[NSString stringWithFormat:@"%d",self.currentTime] substringWithRange:NSMakeRange(0, 4)] intValue]
    if ([timeStr intValue] < self.dateMin) {

        self.month ++;
        
    }else{
    
        if (self.month == 0) {
            
            self.year = [[array lastObject] intValue];
            self.year--;
            self.month = 12;
            self.currentMonthLab.text = [NSString stringWithFormat:@"%02d-%d",self.month,self.year];
        }else{
            
            self.year = [[array lastObject] intValue];
            self.currentMonthLab.text = [NSString stringWithFormat:@"%02d-%d",self.month,self.year];
        }
        
        [self.currentMonthLab sizeToFit];
        self.currentMonthLab.frame = CGRectMake(WIDTH/2.0 - self.currentMonthLab.frame.size.width/2.0,
                                                CGRectGetMaxY(self.navBar.frame),
                                                self.currentMonthLab.frame.size.width,
                                                80*Proportion);
        
        [self loadAllDays];
        
        self.mainTableView.frame = CGRectMake(0,
                                              CGRectGetMaxY(self.mainScrollView.frame),
                                              WIDTH,
                                              HEIGHT - CGRectGetMaxY(self.simpleDaysBgView.frame));
        
    }
}

- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if(self.mainTableView){
        
        if ((int)self.mainTableView.frame.origin.y != (int)CGRectGetMaxY(self.simpleDaysBgView.frame)) {
            
            if (self.mainTableView.contentOffset.y > 20) {

                [self calculateSimpleData];
                
                [self showSimpleDays];

            }
            
        }else{
         
            
            if (self.mainTableView.contentOffset.y < -20) {
                
                [self showAllDays];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if (self.mainScrollView) {
     
        if (self.mainScrollView.contentOffset.x == WIDTH*2) {
            
            [self addMonth];
            
        }else if (self.mainScrollView.contentOffset.x == 0){
            
            [self reduceMonth];
        }
        
        [self.mainScrollView setContentOffset:CGPointMake(WIDTH, 0)];
        
    }
    
}

- (void) changeStyle:(UIButton *) button{
    
    self.day = (int)button.tag;
    self.selectMonth = self.month;
    self.selectYear = self.year;
    
    if (![button.backgroundColor isEqual:[UIColor CMLRedColor]]) {
     
        button.superview.backgroundColor = [UIColor CMLWhiteColor];
    }
    
    
    [self calculateSimpleData];
    
    [self showSimpleDays];
    
    [self getCalulaterActivityList];
}

- (void) calculateSimpleData{

    [self.selectMonthDays removeAllObjects];
    
    int startIndex;
    
//    NSString *currentTimeStr = [NSString stringWithFormat:@"%d",self.currentTime];
    
//    if ([[currentTimeStr substringWithRange:NSMakeRange(4, 2)] intValue] == self.selectMonth) {
//
//        startIndex = [[currentTimeStr substringWithRange:NSMakeRange(6, 2)] intValue];
//    }else{
        startIndex = 1;
//    }
    
    int endIndex;
    
    if ([[[NSString stringWithFormat:@"%d",self.dateMax] substringWithRange:NSMakeRange(4, 2)] intValue] == self.selectMonth) {
       
        endIndex = [[[NSString stringWithFormat:@"%d",self.dateMax] substringWithRange:NSMakeRange(6, 2)] intValue];
    }else{
    
        endIndex = self.selectMonthAllDays;
    }
    
    for (int i = startIndex; i <= endIndex; i++) {
        
        [self.selectMonthDays addObject:[NSNumber numberWithInt:i]];
    }
    
    if (startIndex != 1) {
     
        /**时间补位*/
        if (self.selectMonthDays.count > 7 && self.selectMonthDays.count <= 14) {
            
            for (int i = 1; i <= 7; i++) {
                
                if ([[NSString stringWithFormat:@"%d%02d%02d",self.selectYear,self.selectMonth + 1,i] intValue] > self.dateMax) {
                    
                    break;
                }
                [self.selectMonthDays addObject:[NSNumber numberWithInt:i]];
            }
        }else if (self.selectMonthDays.count <= 7){
            
            for (int i = 1; i <= 14; i++) {
                
                if ([[NSString stringWithFormat:@"%d%02d%02d",self.selectYear,self.selectMonth + 1,i] intValue] > self.dateMax) {
                    
                    break;
                }
                
                [self.selectMonthDays addObject:[NSNumber numberWithInt:i]];
            }
        }
    }
    
    if (endIndex != self.selectMonthAllDays) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM"];
        NSString *string;
        
        if (self.selectMonth == 1) {
            
            string = [NSString stringWithFormat:@"%d-12",self.selectYear - 1];
        }else{
        
            string = [NSString stringWithFormat:@"%d-%02d",self.selectYear,self.selectMonth - 1];
        }
        
        NSDate *currentDate = [formatter dateFromString:string];
        
        int upMonthDays = (int) [NSDate getMonthAllDays:currentDate];
        
        /**时间补位*/
        if (self.selectMonthDays.count > 7 && self.selectMonthDays.count <= 14) {
            
            
            for (int i = upMonthDays; i >= (upMonthDays - 7); i--) {
                
                if ([[NSString stringWithFormat:@"%d%02d%02d",self.selectYear,self.selectMonth - 1,i] intValue] < self.currentTime) {
                    
                    break;
                }
                
                [self.selectMonthDays insertObject:[NSNumber numberWithInt:i] atIndex:0];
            }
        }else if (self.selectMonthDays.count <= 7){
            
            for (int i = upMonthDays; i >= (upMonthDays - 14); i--) {
                
                if ([[NSString stringWithFormat:@"%d%02d%02d",self.selectYear,self.selectMonth - 1,i] intValue] < self.currentTime) {
                    
                    break;
                }
                
                [self.selectMonthDays insertObject:[NSNumber numberWithInt:i] atIndex:0];
            }
        }
    }
    
    
    NSString *weekStr;
    
    if (endIndex != self.selectMonthAllDays) {
        
        if (self.selectMonth == 1) {
            
            weekStr = [[NSDate getTheWeekOfDate:[NSDate getDateDependOnFormatterCFromString:[NSString stringWithFormat:@"%d-12-%02d",self.selectYear - 1,[[self.selectMonthDays firstObject] intValue]]]] substringFromIndex:2];;
        }else{
            
            weekStr = [[NSDate getTheWeekOfDate:[NSDate getDateDependOnFormatterCFromString:[NSString stringWithFormat:@"%d-%02d-%02d",self.selectYear,self.selectMonth - 1,[[self.selectMonthDays firstObject] intValue]]]] substringFromIndex:2];
        }
        
    }else{
    
        weekStr = [[NSDate getTheWeekOfDate:[NSDate getDateDependOnFormatterCFromString:[NSString stringWithFormat:@"%d-%02d-%02d",self.selectYear,self.selectMonth,startIndex]]] substringFromIndex:2];
    }
    
    int index;
    if ([weekStr isEqualToString:@"日"]) {
        
        index = 0;
        
    }else if ([weekStr isEqualToString:@"一"]){
        
        index = 1;
        
    }else if ([weekStr isEqualToString:@"二"]){
        
        index = 2;
        
    }else if ([weekStr isEqualToString:@"三"]){
        
        index = 3;
    }else if ([weekStr isEqualToString:@"四"]){
        
        index = 4;
    }else if ([weekStr isEqualToString:@"五"]){
        
        index = 5;
        
    }else{
        
        index = 6;
    }
    
    NSArray *promWeek = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];

    
    [self.selectMonthDaysPromWeek removeAllObjects];
    
    for ( int i = index; i < 50; i++) {
        
        if (self.selectMonthDaysPromWeek.count == self.selectMonthDays.count) {
            
            break;
        }
        int j = i%7;
        [self.selectMonthDaysPromWeek addObject:promWeek[j]];
    }

}

- (void) showSimpleDays{

    /**早画图*/
    [self loadSimpleDays];
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        weakSelf.mainScrollView.alpha = 0;
        weakSelf.allDaysPromWeekBgView.alpha = 0;
        
        weakSelf.daysBgView.frame = CGRectMake(WIDTH,
                                               - weakSelf.daysBgView.frame.size.height,
                                               WIDTH,
                                               weakSelf.daysBgView.frame.size.height);
        
        weakSelf.simpleDaysBgView.alpha = 1;
        
        weakSelf.mainTableView.frame = CGRectMake(0,
                                                  CGRectGetMaxY(weakSelf.simpleDaysBgView.frame),
                                                  WIDTH,
                                                  HEIGHT - CGRectGetMaxY(weakSelf.simpleDaysBgView.frame));
        
        
    } completion:^(BOOL finished) {

        
    }];


}

- (void) showAllDays{
    
    [self loadAllDays];

    __weak typeof(self) weakSelf = self;

    
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.simpleDaysBgView.alpha = 0;
        weakSelf.mainScrollView.alpha = 1;
        weakSelf.allDaysPromWeekBgView.alpha = 1;
        
        weakSelf.daysBgView.frame = CGRectMake(WIDTH,
                                               0,
                                               WIDTH,
                                               weakSelf.daysBgView.frame.size.height);
        
        weakSelf.mainTableView.frame = CGRectMake(0,
                                                  CGRectGetMaxY(weakSelf.mainScrollView.frame),
                                                  WIDTH,
                                                  HEIGHT - CGRectGetMaxY(weakSelf.simpleDaysBgView.frame));
        

    } completion:^(BOOL finished) {
        
        
    }];
    
}

- (void) refreshSelectDayList:(UIButton *) button{

        self.day = [self.selectMonthDays[button.tag] intValue];
        
        NSString *currentTimeStr = [NSString stringWithFormat:@"%d",self.currentTime];
        self.month = self.selectMonth;
        self.year = self.selectYear;
    
  
    /****************************/
    
    if ([[self.selectMonthDays firstObject] intValue] != 1 && [[currentTimeStr substringWithRange:NSMakeRange(4, 2)] intValue] != 12 && (self.month == [[currentTimeStr substringWithRange:NSMakeRange(4, 2)] intValue] || (self.month == [[currentTimeStr substringWithRange:NSMakeRange(4, 2)] intValue] + 1))) {
        
        
        if (self.day > [[self.selectMonthDays lastObject] intValue] && (self.month == [[currentTimeStr substringWithRange:NSMakeRange(4, 2)] intValue] + 1)) {
            
            self.month --;
            self.selectMonth --;
            
        }else if (self.day <= [[self.selectMonthDays firstObject] intValue] && (self.month == [[currentTimeStr substringWithRange:NSMakeRange(4, 2)] intValue] )){
        
            self.month ++;
            self.selectMonth ++;
        }
    }else if ([[self.selectMonthDays firstObject] intValue] != 1 && [[currentTimeStr substringWithRange:NSMakeRange(4, 2)] intValue] == 12){
    
        if (self.day > [[self.selectMonthDays lastObject] intValue] && (self.year == [[currentTimeStr substringWithRange:NSMakeRange(0, 4)] intValue] + 1)) {
            
            self.month = 12;
            self.selectMonth = 12;
            self.year --;
            self.selectYear --;
            
        }else if (self.day <= [[self.selectMonthDays lastObject] intValue] && (self.year == [[currentTimeStr substringWithRange:NSMakeRange(0, 4)] intValue] )){
            
            self.month = 1;
            self.selectMonth = 1;
            self.year ++;
            self.selectYear ++;
        }
    
    }else if ([[self.selectMonthDays firstObject] intValue] != 1 && [[[NSString stringWithFormat:@"%d",self.dateMax] substringWithRange:NSMakeRange(4, 2)] intValue] != 1 && ((self.month == [[[NSString stringWithFormat:@"%d",self.dateMax] substringWithRange:NSMakeRange(4, 2)] intValue]) || (self.month == [[[NSString stringWithFormat:@"%d",self.dateMax] substringWithRange:NSMakeRange(4, 2)] intValue] - 1))){
    
        if (self.day > [[self.selectMonthDays lastObject] intValue] && (self.month == [[[NSString stringWithFormat:@"%d",self.dateMax] substringWithRange:NSMakeRange(4, 2)] intValue])) {
            
            self.month --;
            self.selectMonth -- ;
            
        }else if(self.day <= [[self.selectMonthDays lastObject] intValue] && (self.month == [[[NSString stringWithFormat:@"%d",self.dateMax] substringWithRange:NSMakeRange(4, 2)] intValue] - 1)){
        
            self.month ++;
            self.selectMonth ++;
        }
    
    }else if ([[self.selectMonthDays firstObject] intValue] != 1 && [[[NSString stringWithFormat:@"%d",self.dateMax] substringWithRange:NSMakeRange(4, 2)] intValue] == 1){
    
        if (self.day > [[self.selectMonthDays lastObject] intValue] && (self.year == [[[NSString stringWithFormat:@"%d",self.dateMax] substringWithRange:NSMakeRange(0, 4)] intValue])) {
            
            self.month = 12;
            self.selectMonth = 12;
            self.year = [[currentTimeStr substringWithRange:NSMakeRange(0, 4)] intValue];
            self.selectYear = [[currentTimeStr substringWithRange:NSMakeRange(0, 4)] intValue];
            
        }else if (self.day <= [[self.selectMonthDays lastObject] intValue] && (self.year == [[currentTimeStr substringWithRange:NSMakeRange(0, 4)] intValue] )){
            
            self.month = 1;
            self.selectMonth = 1;
            self.year = [[[NSString stringWithFormat:@"%d",self.dateMax] substringWithRange:NSMakeRange(0, 4)] intValue];
            self.selectYear = [[[NSString stringWithFormat:@"%d",self.dateMax] substringWithRange:NSMakeRange(0, 4)] intValue];
        }
    }
    /****************************/

    self.currentMonthLab.text = [NSString stringWithFormat:@"%02d-%d",self.month,self.year];
    [self.currentMonthLab sizeToFit];
    self.currentMonthLab.frame = CGRectMake(WIDTH/2.0 - self.currentMonthLab.frame.size.width/2.0,
                                            CGRectGetMaxY(self.navBar.frame),
                                            self.currentMonthLab.frame.size.width,
                                            80*Proportion);
    
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.moveView.center = button.center;
    }];
    
    [self getCalulaterActivityList];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.selectMonthDataArray.count > 0 ) {
        
        return self.selectMonthDataArray.count;
    }else{
    
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (self.selectMonthDataArray.count > 0) {
        
        return self.activityHeight;
    }else{
    
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.selectMonthDataArray.count > 0) {
     
        static NSString *identifier = @"defaultCell";
        CMLActivityTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CMLActivityTVCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (self.selectMonthDataArray.count > 0) {
            if (indexPath.row < self.selectMonthDataArray.count) {
                
                CMLActivityObj *activityObj = [CMLActivityObj getBaseObjFrom:self.selectMonthDataArray[indexPath.row]];
                CMLActivityTVCell *currentCell = (CMLActivityTVCell*)cell;
                currentCell.isShowSubscribe = YES;
                [currentCell refrshActivityCellInActivityVC:activityObj];
            }
        }
        return cell;
        
    }else{
    
        static NSString *identifier = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
            
        CMLActivityObj *activityObj = [CMLActivityObj getBaseObjFrom:self.selectMonthDataArray[indexPath.row]];
        /**判断是否外链接*/
        if ([activityObj.isWebView intValue] == 1) {
            
            WebViewLinkVC *vc = [[WebViewLinkVC alloc] init];
            vc.url = activityObj.webViewLink;
            vc.name = activityObj.title;
            

            [[VCManger mainVC] pushVC:vc animate:YES];
        }else{
            
            if ([activityObj.isUserPublish integerValue] == 1) {
               
                CMLUserPushActivityDetailVC *vc = [[CMLUserPushActivityDetailVC alloc] initWithObjId:activityObj.currentID];
                [[VCManger mainVC] pushVC:vc animate:YES];
            }else{
                
                ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:activityObj.currentID];
                [[VCManger mainVC] pushVC:vc animate:YES];
            }
   
        }

}


- (void) getActivityCellHeight{
    
    CMLActivityTVCell *cell = [[CMLActivityTVCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:@"cell2"];
    [cell refrshActivityCellInActivityVC:nil];
    self.activityHeight = cell.cellheight;
}

- (void) setCurrentTableViewHeaderView{

    UIView *tableViewHeader = [[UIView alloc] init];
    tableViewHeader.backgroundColor = [UIColor whiteColor];
    UILabel *bigPromLab = [[UILabel alloc] init];
    bigPromLab.font = KSystemFontSize16;
    
    if (self.currentTime > [[NSString stringWithFormat:@"%d%02d%02d",self.year,self.month,self.day] intValue]) {
     
        bigPromLab.text = @"往 期 活 动";
        
    }else{
        
        bigPromLab.text = @"当 日 活 动";
    }
    
    bigPromLab.textColor = [UIColor CMLBlackColor];
    [bigPromLab sizeToFit];
    bigPromLab.frame = CGRectMake(30*Proportion,
                                  40*Proportion,
                                  bigPromLab.frame.size.width,
                                  bigPromLab.frame.size.height);
    [tableViewHeader addSubview:bigPromLab];
    
    UILabel *smallPromLab = [[UILabel alloc] init];
    smallPromLab.font = KSystemFontSize10;
    if (self.currentTime > [[NSString stringWithFormat:@"%d%02d%02d",self.year,self.month,self.day] intValue]) {
        
        smallPromLab.text = @"更多精彩瞬间与你分享";
        
    }else{
        
        smallPromLab.text = @"更多精彩活动等你点亮";
    }
    
    smallPromLab.textColor = [UIColor CMLtextInputGrayColor];
    [smallPromLab sizeToFit];
    smallPromLab.frame = CGRectMake(30*Proportion,
                                    CGRectGetMaxY(bigPromLab.frame) + 10*Proportion,
                                    smallPromLab.frame.size.width,
                                    smallPromLab.frame.size.height);
    [tableViewHeader addSubview:smallPromLab];
    
    UILabel *performanceLab = [[UILabel alloc] init];
    performanceLab.font = KSystemFontSize12;
    performanceLab.textColor = [UIColor CMLBrownColor];
    performanceLab.text = [NSString stringWithFormat:@"%@场",[self.calulaterDic valueForKey:[NSString stringWithFormat:@"%d%02d%02d",self.year,self.month,self.day]]];
    performanceLab.textAlignment = NSTextAlignmentCenter;
    performanceLab.layer.borderColor = [UIColor CMLBrownColor].CGColor;
    performanceLab.layer.borderWidth = 2*Proportion;
    [performanceLab sizeToFit];
    performanceLab.frame = CGRectMake(WIDTH - 20*Proportion - performanceLab.frame.size.width - 30*Proportion,
                                      CGRectGetMaxY(bigPromLab.frame) + 5*Proportion - (performanceLab.frame.size.height +10*Proportion*2)/2.0,
                                      performanceLab.frame.size.width + 10*Proportion*2,
                                      performanceLab.frame.size.height + 10*Proportion*2);
    [tableViewHeader addSubview:performanceLab];
    
    tableViewHeader.frame = CGRectMake(0,
                                       0,
                                       WIDTH,
                                       CGRectGetMaxY(smallPromLab.frame) + 20*Proportion);
    self.mainTableView.tableHeaderView = tableViewHeader;
    
    if (self.selectMonthDataArray.count == 0) {
        
        self.mainTableView.tableHeaderView = [[UIView alloc] init];
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - CGRectGetMaxY(self.navBar.frame) - 140*Proportion)];
        footerView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *promImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NOCalendarActivityImg]];
        [promImage sizeToFit];
        promImage.frame = CGRectMake(WIDTH/2.0 - promImage.frame.size.width/2.0, footerView.frame.size.height/2.0 - promImage.frame.size.height/2.0, promImage.frame.size.width, promImage.frame.size.height);
        [footerView addSubview:promImage];
        
        UILabel *promLab = [[UILabel alloc] init];
        promLab.textColor = [UIColor CMLtextInputGrayColor];
        promLab.text = @"今天不妨休息一下，看看其他的日期吧";
        promLab.font = KSystemFontSize14;
        promLab.textAlignment = NSTextAlignmentCenter;
        promLab.backgroundColor = [UIColor whiteColor];
        [promLab sizeToFit];
        promLab.frame = CGRectMake(promImage.center.x - promLab.frame.size.width/2.0,
                                   CGRectGetMaxY(promImage.frame) + 20*Proportion,
                                   promLab.frame.size.width,
                                   promLab.frame.size.height);
        [footerView addSubview:promLab];
        
        self.mainTableView.tableFooterView = footerView;
    }else{
    
        self.mainTableView.tableFooterView = [[UIView alloc] init];
    }
}

- (void) getCalulaterData{

    [self startLoading];
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];

    
    if (self.selectMonth <= 3) {
      
            [paramDic setObject:[NSNumber numberWithInt:(int)[[NSDate getDateDependONFormatterFromString:[NSString stringWithFormat:@"%d-%02d-01 00:00:00",self.selectYear - 1, 12 - (3 - self.selectMonth)]] timeIntervalSince1970]] forKey:@"dateMin"];
    }else{
        
            [paramDic setObject:[NSNumber numberWithInt:(int)[[NSDate getDateDependONFormatterFromString:[NSString stringWithFormat:@"%d-%02d-01 00:00:00",self.selectYear,self.selectMonth - 3]] timeIntervalSince1970]] forKey:@"dateMin"];
    }
    [NetWorkTask getRequestWithApiName:ActivityCalendar param:paramDic delegate:delegate];
    self.currentApiName = ActivityCalendar;
}

- (void) getCalulaterActivityList{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paramDic setObject:reqTime forKey:@"reqTime"];
     NSTimeInterval start = [[NSDate getDateDependONFormatterFromString:[NSString stringWithFormat:@"%d-%02d-%02d 00:00:00",self.selectYear,self.selectMonth,self.day]] timeIntervalSince1970];
    [paramDic setObject:[NSNumber numberWithInt:(int)start] forKey:@"dateMin"];
    NSTimeInterval end = [[NSDate getDateDependONFormatterFromString:[NSString stringWithFormat:@"%d-%02d-%02d 23:59:59",self.selectYear,self.selectMonth,self.day]] timeIntervalSince1970];
    [paramDic setObject:[NSNumber numberWithInt:(int)end] forKey:@"dateMax"];
    [paramDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:(int)start],
                                                           [NSNumber numberWithInt:(int)end],
                                                           reqTime,
                                                           [[DataManager lightData] readSkey]]];
    [paramDic setObject:hashToken forKey:@"hashToken"];

    
    [NetWorkTask postResquestWithApiName:ActivityCalendarList paraDic:paramDic delegate:delegate];
    
    self.currentApiName = ActivityCalendarList;
    
    [self startLoading];
    
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    if ([self.currentApiName isEqualToString:ActivityCalendar]) {

        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            self.dateMax = [obj.retData.maxDate intValue];
            self.dateMin = [obj.retData.minDate intValue];
            self.calulaterDic  = [NSMutableDictionary dictionaryWithDictionary:obj.retData.calendarList];
            [self loadViews];
            [self setCurrentTableViewHeaderView];
            
            [self getCalulaterActivityList];
        }
    }else{
        
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        [self.selectMonthDataArray removeAllObjects];
        
        if ([obj.retCode intValue] == 0) {
            
            [self.selectMonthDataArray addObjectsFromArray:obj.retData.dataList];

        }

        [self.mainTableView reloadData];
        [self.mainTableView setContentOffset:CGPointMake(0, 0)];
        [self setCurrentTableViewHeaderView];
        [self stopLoading];
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self.selectMonthDataArray removeAllObjects];
    [self.mainTableView reloadData];
    [self.mainTableView setContentOffset:CGPointMake(0, 0)];
    [self setCurrentTableViewHeaderView];
    [self stopLoading];
}

@end
