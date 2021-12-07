//
//  NSDate+Awesome.m
//  HaiHe
//
//  Created by Davis on 17/3/24.
//  Copyright © 2017年 Davis. All rights reserved.
//

#import "NSDate+XWAdd.h"
#import <objc/runtime.h>

@implementation NSDate (XWAdd)
+ (NSDate *)dateWithString:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

+ (NSDate *)getDate:(NSString *)dateStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [formatter dateFromString:dateStr];
    return date;
}

+ (NSString *)getStringDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
//    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    formatter.dateFormat = @"yyyy年MM月dd日 HH:mm";
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)dateWithInterval:(long)interval {
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:interval];
    return [self getStringDate:confromTimesp];
}

+ (NSString *)getTodayZeroTime {
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [calendar setTimeZone:gmt];
    
    NSDate *date = [NSDate date];
    
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:date];
    
    components.day-=1;
    
    [components setHour:0];
    
    [components setMinute:0];
    
    [components setSecond: 0];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    return [formatter stringFromDate:endDate];
}

- (NSString *)tipString {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [NSDate date];
    double interval = [date timeIntervalSinceDate:self];
    if ([calendar isDateInToday:self]) {
        if (interval < 60 * 60) {
            int i = (int)(interval / 60);
            NSString *str = [NSString stringWithFormat:@"%d分钟未回复", i];
            return str;
        } else {
            return @"超过60分钟未回复";
        }
    } else {
        return @"超过60分钟未回复";
    }
}

- (NSString *)lastQueryDate {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSString *dateStr = [dateFormatter stringFromDate:self];
    return dateStr;
}

- (NSString *)getDateParam {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSString *dateStr = [dateFormatter stringFromDate:self];
    return dateStr;
}

- (NSString *)dateString {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    if ([calendar isDateInToday:self]) {
        NSDate *date = [NSDate date];
        double interval = [date timeIntervalSinceDate:self];
        if (interval < 60) {
            return @"刚刚";
        }
        if (interval < 60 * 60) {
            int i = (int)(interval / 60);
            NSString *str = [NSString stringWithFormat:@"%d分钟前", i];
            return str;
        }
        int hour = (int)(interval/(60 * 60));
        NSString *str = [NSString stringWithFormat:@"%d小时前", hour];
        return str;
    }
    NSMutableString *formatterStr = [NSMutableString stringWithString:@"HH:mm"];
    
    if ([calendar isDateInYesterday:self]) {
        [formatterStr insertString:@"昨天 " atIndex:0];
    } else {
        [formatterStr insertString:@"MM-dd " atIndex:0];
        NSDateComponents *comp = [calendar components:NSCalendarUnitYear fromDate:self toDate:[NSDate date] options:0];
        if (comp.year > 1) {
            [formatterStr insertString:@"yyyy-" atIndex:0];
        }
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatterStr;
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    return [formatter stringFromDate:self];
}

+ (NSString *)weekday:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:date];
    NSInteger weekday = [comps weekday];
    
    NSString *weekStr;
    switch (weekday) {
        case 1:
            weekStr = @"星期日";
            break;
        case 2:
            weekStr = @"星期一";
            break;
        case 3:
            weekStr = @"星期二";
            break;
        case 4:
            weekStr = @"星期三";
            break;
        case 5:
            weekStr = @"星期四";
            break;
        case 6:
            weekStr = @"星期五";
            break;
        case 7:
            weekStr = @"星期六";
            break;
        default:
            break;
    }
    return weekStr;
}

+ (NSString *)weekday1:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:date];
    NSInteger weekday = [comps weekday];
    
    NSString *weekStr;
    switch (weekday) {
        case 1:
            weekStr = @"周日";
            break;
        case 2:
            weekStr = @"周一";
            break;
        case 3:
            weekStr = @"周二";
            break;
        case 4:
            weekStr = @"周三";
            break;
        case 5:
            weekStr = @"周四";
            break;
        case 6:
            weekStr = @"周五";
            break;
        case 7:
            weekStr = @"周六";
            break;
        default:
            break;
    }
    return weekStr;
}

/** 日 */
+ (NSString *)getDay {
    NSInteger day = [self getYMD:@"dd"];
    return [NSString stringWithFormat:@"%02ld", day];
}
/** 月 */
+ (NSString *)getMonth {
    NSInteger month =  [self getYMD:@"MM"];
    return [NSString stringWithFormat:@"%02ld", month];
}
/** 日 */
+ (NSString *)getYear {
    NSInteger year = [self getYMD:@"yyyy"];
    return [NSString stringWithFormat:@"%ld", year];
}

/** 小时 */
+ (NSInteger)getHour {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:date];
    NSInteger hour = [components hour];
    return hour;
}

+ (NSInteger)getMinute {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMinute fromDate:date];
    NSInteger hour = [components minute];
    return hour;
}

+ (NSInteger)getYMD:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    NSInteger ymd = [[formatter stringFromDate:[NSDate date]] integerValue];
    return ymd;
}

+ (NSInteger)getYMD:(NSDate *)date andFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    NSInteger ymd = [[formatter stringFromDate:date] integerValue];
    return ymd;
}

+ (NSString *)getResultDateStringWithDate:(NSDate *)date {
    NSString *str = [NSString stringWithFormat:@"      %02ld月%02ld日，%@",[self getYMD:date andFormat:@"MM"], [self getYMD:date andFormat:@"dd"], [self weekday1:date]];
    return str;
}

+ (NSDate *)dateTomorrow
{
    return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *)dateWithDaysFromNow:(NSInteger)days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateByAddingDays:days];
}

- (NSDate *)dateByAddingDays:(NSInteger)dDays
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:dDays];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

+ (NSDate *)dateYesterday
{
    return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateBySubtractingDays:days];
}

- (NSDate *)dateBySubtractingDays: (NSInteger)dDays
{
    return [self dateByAddingDays: (dDays * -1)];
}
+ (NSString *)dateFormatConversion:(NSString*)oldDate newFormat:(NSString*)newFormat{
    
    NSDate* date = [self dateWithString:oldDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = newFormat;
    NSString *dateStr = [formatter stringFromDate:date];
    
    return dateStr;
}

@end
