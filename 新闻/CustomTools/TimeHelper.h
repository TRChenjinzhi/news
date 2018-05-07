//
//  TimeHelper.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeHelper : NSObject

+(NSString*)showTime:(NSString*)newsTime;
+(NSString *)showTime_collect:(NSString *)newsTime;
+(instancetype)share;

-(NSArray*)sortAllData_day:(NSArray*)array;
-(NSArray*)sortAllData_mon:(NSArray*)array;
-(NSArray*)sortAllData_day_news:(NSArray*)array;
-(NSString*)dateChangeToString:(NSString*)date;
-(NSString*)dateChangeToString_YYYYMMDDHHMM:(NSString*)date;
-(NSString*)GetDateFromString_YYYYMMDD:(NSString*)str_time;
-(NSString*)dateChangeToString_day:(NSString*)date;
-(NSString*)dateChangeToString_mon:(NSString*)date;

-(NSString*)GetDateFromString_yyMMDD_HHMMSS:(NSString*)str_time;
-(NSString*)GetDateFromString_yyMMDD_HHMM:(NSString*)str_time;
-(NSString*)GetDateFromString_MMDD:(NSString*)str_time;

-(NSNumber *)getCurrentTime_number;
-(NSString*)getCurrentTime_seconds;
-(NSString*)getCurrentTime_YYYYMMDD;
-(NSString*)getCurrentTime_YYYYMMDDHHSS;
-(NSString*)getCurrentTime_YYYYMMDDHHMMSS;
-(BOOL)compareTimes_ori_time:(NSNumber*)oriTime dest_time:(NSNumber*)destTime time:(NSInteger)seconds;

//日期转时间戳
-(NSString*)dateChangeToTimeSecond:(NSString*)time_date;

//日期转日期
-(NSString*)dataChangeToYYMMDD:(NSString*)time_date;

//时间戳转日期

@end
