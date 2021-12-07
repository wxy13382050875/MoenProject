//
//  NSDate+Awesome.h
//  HaiHe
//
//  Created by Davis on 17/3/24.
//  Copyright © 2017年 Davis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (XWAdd)
+ (NSDate *)dateWithString:(NSString *)dateString;

+ (NSString *)getStringDate:(NSDate *)date;

- (NSString *)dateString;

- (NSString *)tipString;

- (NSString *)lastQueryDate;

- (NSString *)getDateParam;

+ (NSDate *)getDate:(NSString *)dateStr;

/**
 时间戳转化一定的时间格式

 @param interval 时间戳
 @return 时间字符串
 */
+ (NSString *)dateWithInterval:(long)interval;

/**
 获取凌晨时间用于判断是否今天
 */
+ (NSString *)getTodayZeroTime;

/*
 * 获取周几 
 *  [1 - Sunday]
 *  [2 - Monday]
 *  [3 - Tuerday]
 *  [4 - Wednesday]
 *  [5 - Thursday]
 *  [6 - Friday]
 *  [7 - Saturday]
 */
+ (NSString *)weekday:(NSDate *)date;
/** 返回周一、周二... */
+ (NSString *)weekday1:(NSDate *)date;

+ (NSString *)getResultDateStringWithDate:(NSDate *)date;

/** 日 */
+ (NSString *)getDay;
/** 月 */
+ (NSString *)getMonth;
/** 日 */
+ (NSString *)getYear;

+ (NSInteger)getHour;
+ (NSInteger)getMinute;

+ (NSDate *)dateTomorrow;

+ (NSDate *)dateYesterday;

+ (NSDate *)dateWithDaysFromNow:(NSInteger)days;

+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days;

+ (NSString *)dateFormatConversion:(NSString*)oldDate newFormat:(NSString*)newFormat;
@end
