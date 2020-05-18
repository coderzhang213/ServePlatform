//
//  NSDate+CMLExspand.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "NSDate+CMLExspand.h"
#import <UIKit/UIKit.h>

@implementation NSDate (CMLExspand)

+ (NSDate *) getDateDependONFormatterFromString:(NSString *) string{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:s"];
    
    NSDate *date = [formatter dateFromString:string];
    
    return date;
}

/**输入格式为yyyy-MM-dd 输出日期*/
+ (NSDate *)getDateDependOnFormatterCFromString:(NSString *) string{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [formatter dateFromString:string];
    
    return date;

}

/**输入格式为MM-dd HH:mm 输出日期*/
+ (NSDate *)getDateStringFromDateString:(NSString *)string {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSDate *date = [formatter dateFromString:string];

    return date;
    
}


+ (NSString *)getStringDependOnFormatterCFromDate:(NSDate *) date{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *string=[formatter stringFromDate:date];
    
    return string;


}

+ (NSString*) getStringDependOnFormatterAFromDate:(NSDate*) date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *string=[formatter stringFromDate:date];
    
    return string;
}

/**年份*/
+ (NSString *) getCurrentYear{

    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy"];
    
    NSString *string=[formatter stringFromDate:date];
    
    return string;

}

+ (NSString *) getMonthDays:(NSDate *) date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"dd"];
    
    NSString *string=[formatter stringFromDate:date];
    
    return string;
}

+ (NSDate*) getDateDependOnFormatterBFromString:(NSString *)string{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy:MM:dd HH:mm:s"];
    
    NSDate *date=[formatter dateFromString:string];
    
    return date;
}

+ (NSString*) getStringDependOnFormatterBFromDate:(NSDate*) date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy:MM:dd HH:mm:s"];
    
    NSString *string=[formatter stringFromDate:date];
    
    return string;
    
}

+ (NSString*) getFormatterStringBFromFormatterStringA:(NSString*)string{
    
    NSDateFormatter *formatterA = [[NSDateFormatter alloc] init];
    
    [formatterA setDateFormat:@"yyyy-MM-dd HH:mm:s"];
    
    NSDate *date = [formatterA dateFromString:string];
    
    NSDateFormatter *formatterB = [[NSDateFormatter alloc] init];
    
    [formatterB setDateFormat:@"yyyy:MM:dd HH:mm:s"];
    
    NSString *newString = [formatterB stringFromDate:date];
    
    return newString;
}

+ (NSString*) getFormatterStringAFromFormatterStringB:(NSString*)string{
    
    NSDateFormatter *formatterB = [[NSDateFormatter alloc] init];
    
    [formatterB setDateFormat:@"yyyy:MM:dd HH:mm:s"];
    
    NSDate *date = [formatterB dateFromString:string];
    
    NSDateFormatter *formatterA = [[NSDateFormatter alloc] init];
    
    [formatterA setDateFormat:@"yyyy-MM-dd HH:mm:s"];
    
    NSString *newString = [formatterA stringFromDate:date];
    
    return newString;
}

+ (NSString*) getFormatterStringAFromFormatterStringC:(NSString*)string{
    
    NSDateFormatter *formatterA = [[NSDateFormatter alloc] init];
    
    [formatterA setDateFormat:@"yyyy-MM-dd HH:mm:s"];
    
    NSDate *date = [formatterA dateFromString:string];
    
    NSDateFormatter *formatterB = [[NSDateFormatter alloc] init];
    
    [formatterB setDateFormat:@"yyyy-MM-dd"];
    
    NSString *newString = [formatterB stringFromDate:date];
    
    return newString;
}

//多少天之后，返回MM-dd格式
+ (NSString *) getStringFromDate:(NSDate *)date afterDays:(NSInteger)dayNum
{
    
    NSDate *dateTemp = [date dateByAddingTimeInterval:dayNum*24*3600];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"MM-dd"];
    
    NSString *newString = [formatter stringFromDate:dateTemp];
    
    return newString;
}

+ (NSString *) getStringFromDate:(NSDate *)date{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"MM-dd"];
    
    NSString *newString = [formatter stringFromDate:date];
    
    return newString;
}

+ (NSString*) getStringDependOnFormatterDFromDate:(NSDate*) date{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"MM-dd HH:mm"];
    
    NSString *string=[formatter stringFromDate:date];
    
    return string;
}

+ (NSString*) getStringDependOnFormatterEFromDate:(NSDate*) date{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"HH:mm"];
    
    NSString *string=[formatter stringFromDate:date];
    
    return string;
}

+ (NSString*) getDayOfTheWeek{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy年MM月dd日#EEEE"];
    
    NSDate * date = [NSDate date];
    
    NSString *firString=[formatter stringFromDate:date];
    
    NSMutableString * secstring = [NSMutableString stringWithString:firString];
    
    NSArray* array=[secstring componentsSeparatedByString:@"#"];
    
    NSString *weak = [array lastObject];
    
    if ([weak isEqualToString:@"Monday"]) {
        
        return @"星期一";
        
    }else if ([weak isEqualToString:@"Tuesday"]){
        
        return @"星期二";
        
    }else if ([weak isEqualToString:@"Wednesday"]){
        
        return @"星期三";
        
    }else if ([weak isEqualToString:@"Thursday"]){
        
        return @"星期四";
        
    }else if ([weak isEqualToString:@"Friday"]){
        
        return @"星期五";
        
    }else if ([weak isEqualToString:@"Saturday"]){
        
        return @"星期六";
        
    }else if ([weak isEqualToString:@"Sunday"]){
        
        return @"星期日";
        
    }
    return @"";
    
}

+ (NSString *)getTheWeekOfDate:(NSDate *)date{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy年MM月dd日#EEEE"];
    
    NSString *firString=[formatter stringFromDate:date];
    
    NSMutableString * secstring = [NSMutableString stringWithString:firString];
    
    NSArray* array=[secstring componentsSeparatedByString:@"#"];
    
    NSString *weak = [array lastObject];
   
    if ([weak isEqualToString:@"Monday"]) {
        
        return @"星期一";
        
    }else if ([weak isEqualToString:@"Tuesday"]){
        
        return @"星期二";
        
    }else if ([weak isEqualToString:@"Wednesday"]){
        
        return @"星期三";
        
    }else if ([weak isEqualToString:@"Thursday"]){
        
        return @"星期四";
        
    }else if ([weak isEqualToString:@"Friday"]){
        
        return @"星期五";
        
    }else if ([weak isEqualToString:@"Saturday"]){
        
        return @"星期六";
        
    }else if ([weak isEqualToString:@"Sunday"]){
        
        return @"星期日";
        
    }
    return weak;
}

+ (NSInteger) getTimeIntervalBetweenDateA:(NSDate*) dateA andDateB:(NSDate*)dateB{
    
    NSTimeInterval  time = [dateA timeIntervalSinceDate:dateB];
    
    NSInteger m= fabs(time);
    
    NSInteger d =m/(1*24*60*60);
    
    return d;
}

+ (NSDate*) getFirstDayOfPresentMonth{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy年MM"];
    
    NSDate * date = [NSDate date];
    
    NSString * str = [formatter stringFromDate:date];
    
    NSArray * array = [str componentsSeparatedByString:@"年"];
    
    NSString *targetDay=[NSString stringWithFormat:@"%@:%@:01",[array firstObject],[array lastObject]];
    
    NSDateFormatter * targetFormatter =[[NSDateFormatter alloc] init];
    
    [targetFormatter setDateFormat:@"yyyy:MM:dd"];
    
    NSDate *targetDate = [targetFormatter dateFromString:targetDay];
    
    return targetDate;
}

+ (NSDate*) getLastDayOfPresentMonth{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy年MM"];
    
    NSDate * date = [NSDate date];
    
    NSString * str = [formatter stringFromDate:date];
    
    NSArray * array = [str componentsSeparatedByString:@"年"];
    
    NSInteger year = [[array firstObject] integerValue];
    
    NSInteger month = [[array lastObject] integerValue];
    
    
    if ((month==/* DISABLES CODE */ (1))&&(month==3)&&(month==5)&&(month==7)&&(month==8)&&(month==10)&&(month==12)) {
        NSString *targetDay=[NSString stringWithFormat:@"%@:%@:31",[array firstObject],[array lastObject]];
        
        NSDateFormatter * targetFormatter =[[NSDateFormatter alloc] init];
        
        [targetFormatter setDateFormat:@"yyyy:MM:dd"];
        
        NSDate *targetDate = [targetFormatter dateFromString:targetDay];
        
        return targetDate;
        
    }else if (month==2){
        
        if ((year%4==0)&&(year%100==0||year%400==0)) {
            NSString *targetDay=[NSString stringWithFormat:@"%@:%@:29",[array firstObject],[array lastObject]];
            
            NSDateFormatter * targetFormatter =[[NSDateFormatter alloc] init];
            
            [targetFormatter setDateFormat:@"yyyy:MM:dd"];
            
            NSDate *targetDate = [targetFormatter dateFromString:targetDay];
            
            return targetDate;
        }else{
            NSString *targetDay=[NSString stringWithFormat:@"%@:%@:28",[array firstObject],[array lastObject]];
            
            NSDateFormatter * targetFormatter =[[NSDateFormatter alloc] init];
            
            [targetFormatter setDateFormat:@"yyyy:MM:dd"];
            
            NSDate *targetDate = [targetFormatter dateFromString:targetDay];
            
            return targetDate;
            
            
        }
    }else{
        
        NSString *targetDay=[NSString stringWithFormat:@"%@:%@:30",[array firstObject],[array lastObject]];
        
        NSDateFormatter * targetFormatter =[[NSDateFormatter alloc] init];
        
        [targetFormatter setDateFormat:@"yyyy:MM:dd"];
        
        NSDate *targetDate = [targetFormatter dateFromString:targetDay];
        
        return targetDate;
    }
    return nil;
}

+ (NSInteger) getCurrentMonthDays{

    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy年MM"];
    
    NSDate * date = [NSDate date];
    
    NSString * str = [formatter stringFromDate:date];
    
    NSArray * array = [str componentsSeparatedByString:@"年"];
    
    NSInteger year = [[array firstObject] integerValue];
    
    NSInteger month = [[array lastObject] integerValue];
    
    
    if ((month==/* DISABLES CODE */ (1))||(month==3)||(month==5)||(month==7)||(month==8)||(month==10)||(month==12)) {
        
        return 31;
        
    }else if (month==2){
        
        if ((year%4==0)&&(year%100==0||year%400==0)) {
            
            return 29;
        }else{
            
            return 28;
            
            
        }
    }else{
        
        return 30;
    }
    return 30;
}

+ (NSInteger) getMonthAllDays:(NSDate *) date{

    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy年MM"];
    
    NSString * str = [formatter stringFromDate:date];
    
    NSArray * array = [str componentsSeparatedByString:@"年"];
    
    NSInteger year = [[array firstObject] integerValue];
    
    NSInteger month = [[array lastObject] integerValue];
    
    
    if (month==2){
        
        if ((year%4==0)&&(year%100==0||year%400==0)) {
            
            return 29;
        }else{
            
            return 28;
            
            
        }
    }else if(month == 4){
        
        return 30;
    }else if(month == 6){
        
        return 30;
    }else if(month == 9){
        
        return 30;
    }else if(month == 11){
        
        return 30;
    }else{
    
        return 31;
    }
    return 30;
}

/*是否今天*/
- (BOOL)isToday {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    NSString *nowString = [formatter stringFromDate:[NSDate date]];
    NSString *selfString = [formatter stringFromDate:self];
    
    return nowString == selfString;
    
}

/*是否昨天*/
- (BOOL)isYestoday {
    
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    NSDate *selfDate = [self dateWithYMD];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return components.day = 1;
}

- (NSDate *)dateWithYMD {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *selfString = [formatter stringFromDate:self];
    return [formatter dateFromString:selfString];
    
}

@end
