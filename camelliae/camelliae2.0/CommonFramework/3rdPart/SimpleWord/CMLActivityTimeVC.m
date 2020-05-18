//
//  CMLActivityTimeVC.m
//  camelliae2.0
//
//  Created by 张越 on 2018/11/8.
//  Copyright © 2018 张越. All rights reserved.
//

#import "CMLActivityTimeVC.h"
#import "VCManger.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "NSDate+CMLExspand.h"

@interface CMLActivityTimeVC ()<NavigationBarProtocol,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UILabel *startTimeLab;

@property (nonatomic,strong) UILabel *endTimeLab;

@property (nonatomic,strong) UIButton *startTimeBtn;

@property (nonatomic,strong) UIButton *endTimeBtn;

@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic,strong) NSMutableArray *yearArray;

@property (nonatomic,strong) NSMutableArray *monthArray;

@property (nonatomic,strong) NSMutableArray *dayArray;

@property (nonatomic,strong) NSArray *cuuenrtArray;



@property (nonatomic,strong) UIButton *confirmBtn;

/*新增：小时和分钟*/
@property (nonatomic, strong) NSMutableArray *hourArray;

@property (nonatomic, strong) NSMutableArray *minutesArray;

@end

@implementation CMLActivityTimeVC

- (NSMutableArray *)yearArray{
    
    if (!_yearArray) {
        
        _yearArray = [NSMutableArray array];
    }
    return _yearArray;
}

- (NSMutableArray *)monthArray{
    
    if (!_monthArray) {
        _monthArray = [NSMutableArray array];
    }
    return _monthArray;
}

- (NSMutableArray *)dayArray{
    
    if (!_dayArray) {
        
        _dayArray = [NSMutableArray array];
    }
    return _dayArray;
}

- (NSMutableArray *)hourArray {
    
    if (!_hourArray) {
        _hourArray = [NSMutableArray array];
    }
    return _hourArray;
}

- (NSMutableArray *)minutesArray {
    
    if (!_minutesArray) {
        _minutesArray = [NSMutableArray array];
    }
    return _minutesArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    
    
    [self.navBar setTitleContent:@"活动时间"];
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    [self.navBar setLeftBarItem];
    self.navBar.delegate = self;
    
    self.confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - NavigationBarHeight,
                                                                 StatusBarHeight,
                                                                 NavigationBarHeight,
                                                                 NavigationBarHeight)];
    [self.confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    self.confirmBtn.titleLabel.font = KSystemFontSize14;
    [self.confirmBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    self.confirmBtn.userInteractionEnabled = YES;
    [self.navBar addSubview:self.confirmBtn];
    [self.confirmBtn addTarget:self action:@selector(output) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *startTimeView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 CGRectGetMaxY(self.navBar.frame),
                                                                 WIDTH,
                                                                 110*Proportion)];
    startTimeView.backgroundColor = [UIColor CMLWhiteColor];
    [self.contentView addSubview:startTimeView];
    
    UILabel *startPromLab  = [[UILabel alloc] init];
    startPromLab.font = KSystemFontSize13;
    startPromLab.text = @"活动开始时间";
    [startPromLab sizeToFit];
    startPromLab.frame = CGRectMake(30*Proportion,
                                    startTimeView.frame.size.height/2.0 - startPromLab.frame.size.height/2.0,
                                    startPromLab.frame.size.width,
                                    startPromLab.frame.size.height);
    [startTimeView addSubview:startPromLab];
    
    /*如果有显示上次发布时间*/
    self.startTimeLab = [[UILabel alloc] init];
    if (self.startTime) {
        self.startTimeLab.text = self.startTime;
    }else {
        self.startTime = [NSDate getStringDependOnFormatterAFromDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0]];
        self.startTimeLab.text = self.startTime;
    }
    
    self.startTimeLab.font = KSystemFontSize13;
    [self.startTimeLab sizeToFit];
    self.startTimeLab.frame = CGRectMake(WIDTH -  30*Proportion - 20*Proportion - self.startTimeLab.frame.size.width,
                                         startTimeView.frame.size.height/2.0 - self.startTimeLab.frame.size.height/2.0,
                                         self.startTimeLab.frame.size.width,
                                         self.startTimeLab.frame.size.height);
    [startTimeView addSubview:self.startTimeLab];
    
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    line1.frame = CGRectMake(30*Proportion,
                             CGRectGetHeight(startTimeView.frame) - 1.f,
                             WIDTH - 30*Proportion*2,
                             1.f);
    [startTimeView addSubview:line1];
    
    self.startTimeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   WIDTH,
                                                                   startTimeView.frame.size.height)];
    self.startTimeBtn.backgroundColor = [UIColor clearColor];
    [startTimeView addSubview:self.startTimeBtn];
    [self.startTimeBtn addTarget:self action:@selector(showStartTime) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *endTimeView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               CGRectGetMaxY(startTimeView.frame),
                                                               WIDTH,
                                                               110*Proportion)];
    endTimeView.backgroundColor = [UIColor CMLWhiteColor];
    [self.contentView addSubview:endTimeView];
    
    UILabel *endPromLab  = [[UILabel alloc] init];
    endPromLab.font = KSystemFontSize13;
    endPromLab.text = @"活动结束时间";
    [endPromLab sizeToFit];
    endPromLab.frame = CGRectMake(30*Proportion,
                                  endTimeView.frame.size.height/2.0 - endPromLab.frame.size.height/2.0,
                                  endPromLab.frame.size.width,
                                  endPromLab.frame.size.height);
    [endTimeView addSubview:endPromLab];
    
    /*如果有显示上次发布时间*/
    self.endTimeLab = [[UILabel alloc] init];
    if (self.endTime) {
        self.endTimeLab.text = self.endTime;
    }else {
        self.endTime = [NSDate getStringDependOnFormatterAFromDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0]];
        self.endTimeLab.text = self.endTime;
    }
    
    self.endTimeLab.font = KSystemFontSize13;
    [self.endTimeLab sizeToFit];
    self.endTimeLab.frame = CGRectMake(WIDTH -  30*Proportion - 20*Proportion - self.endTimeLab.frame.size.width,
                                       endTimeView.frame.size.height/2.0 - self.endTimeLab.frame.size.height/2.0,
                                       self.endTimeLab.frame.size.width,
                                       self.endTimeLab.frame.size.height);
    [endTimeView addSubview:self.endTimeLab];
    

    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    line2.frame = CGRectMake(30*Proportion,
                             CGRectGetHeight(endTimeView.frame) - 1.f,
                             WIDTH - 30*Proportion*2,
                             1.f);
    [endTimeView addSubview:line2];
    
    self.endTimeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 WIDTH,
                                                                 110*Proportion)];
    self.endTimeBtn.backgroundColor = [UIColor clearColor];
    [endTimeView addSubview:self.endTimeBtn];
    [self.endTimeBtn addTarget:self action:@selector(showEndTime) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    self.shadowView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    self.shadowView.backgroundColor = [UIColor colorWithRed:0
                                                      green:0
                                                       blue:0
                                                      alpha:0.5];
    self.shadowView.hidden = YES;
    [self.contentView addSubview:self.shadowView];
    

}

- (void) loadData{
    
    
    for (int i = 2018; i < 2030; i++) {
        
        [self.yearArray addObject:[NSNumber numberWithInt:i]];
    }
    
    for (int i = 1; i <= 12; i++) {
        
        [self.monthArray addObject:[NSNumber numberWithInt:i]];
    }
    
    for (int i = 1; i <= 31; i++) {
        
        [self.dayArray addObject:[NSNumber numberWithInt:i]];
    }
    
    for (int i = 0; i < 24; i++) {
        
        [self.hourArray addObject:[NSNumber numberWithInt:i]];
        
    }
    
    for (int i = 0; i < 60; i++) {
        
        [self.minutesArray addObject:[NSNumber numberWithInt:i]];
        
    }
    
}

- (void) showEndTime{
    
    self.endTimeBtn.selected = YES;
    self.startTimeBtn.selected = NO;
    
    NSString *endTimeString1 = [self.endTime stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSString *endTimeString2 = [endTimeString1 stringByReplacingOccurrencesOfString:@":" withString:@"-"];
    self.cuuenrtArray = [endTimeString2 componentsSeparatedByString:@"-"];
    
    [self shoDate];
}

- (void) didSelectedLeftBarItem{
    
    [[VCManger mainVC] dismissCurrentVC];
    
}

- (void) showStartTime{
    
    self.startTimeBtn.selected = YES;
    self.endTimeBtn.selected = NO;
    
    NSString *startTimeString1 = [self.startTime stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSString *startTimeString2 = [startTimeString1 stringByReplacingOccurrencesOfString:@":" withString:@"-"];
    self.cuuenrtArray = [startTimeString2 componentsSeparatedByString:@"-"];
    
    [self shoDate];
    
}

- (void) shoDate{
    
    /**clear*/
    for (int i = 0; i < self.shadowView.subviews.count; i++) {
        UIView *view = self.shadowView.subviews[i];
        [view removeFromSuperview];
    }
    
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy.MM.dd"];
//        NSString *string=[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[self.attributeDic valueForKey:self.attributeArray[3]] intValue]]];
    
    NSString *str = @"test";
    CGSize strSizez = [str sizeWithFontCompatible:KSystemFontSize15];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0 ,
                                                                              0,
                                                                              650*Proportion,
                                                                              240*Proportion + strSizez.height*3)];
    pickerView.layer.cornerRadius = 4*Proportion;
    pickerView.center = self.shadowView.center;
    // 显示选中框
    pickerView.showsSelectionIndicator=YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    for (int i = 0; i < self.yearArray.count; i++) {
        
        if ([self.yearArray[i] intValue] == [[self.cuuenrtArray firstObject] intValue]) {
            [pickerView selectRow:i inComponent:0 animated:NO];
            break;
        }
    }
    
    for (int i = 0; i < self.monthArray.count; i++) {
        
        if ([self.monthArray[i] intValue] == [self.cuuenrtArray[1] intValue]) {
            [pickerView selectRow:i inComponent:1 animated:NO];
            break;
        }
    }
    
    for (int i = 0; i < self.dayArray.count; i++) {
        
        if ([self.dayArray[i] intValue] == [self.cuuenrtArray[2] intValue]) {
            [pickerView selectRow:i inComponent:2 animated:NO];
            break;
        }
    }
    
    for (int i = 0; i < self.hourArray.count; i++) {
        
        if ([self.hourArray[i] intValue] == [self.cuuenrtArray[3] intValue]) {
            [pickerView selectRow:i inComponent:3 animated:NO];
            break;
        }
    }
    
    for (int i = 0; i < self.minutesArray.count; i++) {
        
        if ([self.minutesArray[i] intValue] == [self.cuuenrtArray[4] intValue]) {
            [pickerView selectRow:i inComponent:4 animated:NO];
            break;
        }
    }
    
    pickerView.backgroundColor = [UIColor whiteColor];
    self.shadowView.hidden = NO;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.8 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        [weakSelf.shadowView addSubview:pickerView];
        
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - pickerView
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 5;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return _yearArray.count;
    }else if (component == 1) {
        return _monthArray.count;
    }else if (component == 2) {
        return _dayArray.count;
    }else if (component == 3) {
        return _hourArray.count;
    }else {
        return _minutesArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
        return [NSString stringWithFormat:@"%@",_yearArray[row]];
    }else if (component == 1) {
        return [NSString stringWithFormat:@"%02d",[_monthArray[row] intValue]];
    }else if (component == 2) {
        return [NSString stringWithFormat:@"%02d",[_dayArray[row] intValue]];
    }else if (component == 3) {
        return [NSString stringWithFormat:@"%02d", [_hourArray[row] intValue]];
    }else {
        return [NSString stringWithFormat:@"%02d", [_minutesArray[row] intValue]];
    }
    
}
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return 628*Proportion/5.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 60*Proportion;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:KSystemFontSize15];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    if (self.startTimeBtn.selected) {
            NSMutableString *tempStr = [[NSMutableString alloc] initWithString:self.startTime];
            if (component == 0) {
                [tempStr replaceCharactersInRange:NSMakeRange(0, 4) withString:[NSString stringWithFormat:@"%@", self.yearArray[row]]];
                
            }else if (component == 1) {
                [tempStr replaceCharactersInRange:NSMakeRange(5, 2) withString:[NSString stringWithFormat:@"%02d", [_monthArray[row] intValue]]];
                
            }else if (component == 2) {
                [tempStr replaceCharactersInRange:NSMakeRange(8, 2) withString:[NSString stringWithFormat:@"%02d", [_dayArray[row] intValue]]];
               
            }else if (component == 3) {
                [tempStr replaceCharactersInRange:NSMakeRange(11, 2) withString:[NSString stringWithFormat:@"%02d", [_hourArray[row] intValue]]];
                
            }else {
                [tempStr replaceCharactersInRange:NSMakeRange(14, 2) withString:[NSString stringWithFormat:@"%02d", [_minutesArray[row] intValue]]];
                
            }
        
        self.startTime = tempStr;
        self.startTimeLab.text = self.startTime;
        [self.startTimeLab sizeToFit];
        self.startTimeLab.frame = CGRectMake(WIDTH -  30*Proportion - 20*Proportion - self.startTimeLab.frame.size.width,
                                             110*Proportion/2.0 - self.startTimeLab.frame.size.height/2.0,
                                             self.startTimeLab.frame.size.width,
                                             self.startTimeLab.frame.size.height);
        
        
    }else{
        
        NSMutableString *tempStr = [[NSMutableString alloc] initWithString:self.endTime];
        if (component == 0) {
            [tempStr replaceCharactersInRange:NSMakeRange(0, 4) withString:[NSString stringWithFormat:@"%@",self.yearArray[row]]];
            
        }else if (component == 1) {
            [tempStr replaceCharactersInRange:NSMakeRange(5, 2) withString:[NSString stringWithFormat:@"%02d",[_monthArray[row] intValue]]];
            
        }else if (component == 2) {
            [tempStr replaceCharactersInRange:NSMakeRange(8, 2) withString:[NSString stringWithFormat:@"%02d", [_dayArray[row] intValue]]];
            
        }else if (component == 3) {
            [tempStr replaceCharactersInRange:NSMakeRange(11, 2) withString:[NSString stringWithFormat:@"%02d", [_hourArray[row] intValue]]];
            
        }else {
            [tempStr replaceCharactersInRange:NSMakeRange(14, 2) withString:[NSString stringWithFormat:@"%02d", [_minutesArray[row] intValue]]];
            
        }
        
        self.endTime = tempStr;
        self.endTimeLab.text = self.endTime;
        [self.endTimeLab sizeToFit];
        self.endTimeLab.frame = CGRectMake(WIDTH -  30*Proportion - 20*Proportion - self.startTimeLab.frame.size.width,
                                             110*Proportion/2.0 - self.startTimeLab.frame.size.height/2.0,
                                             self.endTimeLab.frame.size.width,
                                             self.endTimeLab.frame.size.height);
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.shadowView.hidden = YES;
}

- (void) output{
    
    NSString *startString = [self.startTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
    startString = [startString stringByReplacingOccurrencesOfString:@" " withString:@""];
    startString = [startString stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    NSString *endString = [self.endTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
    endString = [endString stringByReplacingOccurrencesOfString:@" " withString:@""];
    endString = [endString stringByReplacingOccurrencesOfString:@":" withString:@""];

    if ([startString integerValue] > [endString integerValue]) {
        [SVProgressHUD showErrorWithStatus:@"开始时间不能大于结束时间"];
    }else {
        [self.activityTimeDelegate outputActivityTime:self.startTime andEndTime:self.endTime];
        [[VCManger mainVC] dismissCurrentVC];

    }
    
}
@end
