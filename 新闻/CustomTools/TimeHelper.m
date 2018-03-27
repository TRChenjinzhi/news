//
//  TimeHelper.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TimeHelper.h"
#import "Mine_goldDetail_cell_model.h"

@implementation TimeHelper
static id _instance;
+(instancetype)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

+(NSString *)showTime:(NSString *)newsTime{
    // 时间字符串
    TimeHelper* timeHelper = [[TimeHelper alloc] init];
    NSString *str_news = newsTime;
    NSString* str_now = [timeHelper getCurrentTime];
    
    // 1.创建一个时间格式化对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // 2.格式化对象的样式/z大小写都行/格式必须严格和字符串时间一样
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    // 3.字符串转换成时间/自动转换0时区/东加西减
    NSDate *news_date = [formatter dateFromString:str_news];
    NSDate *now_date = [formatter dateFromString:str_now];
    
    NSInteger year_news = [timeHelper GetYear:news_date];
    NSInteger year_now = [timeHelper GetYear:now_date];
    NSInteger month_news = [timeHelper GetMonth:news_date];
    NSInteger month_now = [timeHelper GetMonth:now_date];
    NSInteger day_news = [timeHelper GetDay:news_date];
    NSInteger day_now = [timeHelper GetDay:now_date];
    NSInteger hour_news = [timeHelper GetHour:news_date];
    NSInteger hour_now = [timeHelper GetHour:now_date];
    NSInteger min_news = [timeHelper GetMin:news_date];
    NSInteger min_now = [timeHelper GetMin:now_date];
//    NSLog(@"year:%ld,month:%ld,day:%ld,hour:%ld,min:%ld",year_now,month_now,day_now,hour_now,min_now);
    //年
    if(year_now > year_news){
        // 1.创建一个时间格式化对象
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        // 2.设置时间格式化对象的样式
        formatter.dateFormat = @"yyyy年MM月dd日";
        
        NSString* time = [formatter stringFromDate:news_date];
        return time;
    }
    //月
    if(month_now - month_news > 0){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM月dd日";
        NSString* time = @"";
        time = [time stringByAppendingString:[formatter stringFromDate:news_date]];
        return time;
    }
    //日
    if(day_now-day_news == 0){//今天
        //小时
        if(hour_now - hour_news == 0){//一个小时内
            //分
            if(min_now - min_news >= 3){
                NSInteger min_count = min_now - min_news;
                return [NSString stringWithFormat:@"%ld分钟前",min_count];
            }else{//3分钟内
                return @"刚刚";
            }
        }else if(hour_now - hour_news > 0){//多个小时
            NSInteger hour_count = hour_now - hour_news;
            return [NSString stringWithFormat:@"%ld小时前",hour_count];
        }
        
    }
    else if(day_now - day_news == 1){//昨天
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:mm";
        NSString* time = @"昨天 ";
        time = [time stringByAppendingString:[formatter stringFromDate:news_date]];
        return time;
    }
    else{//今年
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM月dd日";
        NSString* time = @"";
        time = [time stringByAppendingString:[formatter stringFromDate:news_date]];
        return time;
    }

//    // 4.获取了时间元素
//    NSDateComponents *cmps = [calendar components:type fromDate:date toDate:now options:0];
//
//    NSLog(@"%ld年%ld月%ld日%ld小时%ld分钟%ld秒钟", cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second);
    
    return nil;
}

+(NSString *)showTime_collect:(NSString *)newsTime{
    // 时间字符串
    TimeHelper* timeHelper = [[TimeHelper alloc] init];
    NSString *str_news = newsTime;
    NSString* str_now = [timeHelper getCurrentTime];
    
    // 1.创建一个时间格式化对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // 2.格式化对象的样式/z大小写都行/格式必须严格和字符串时间一样
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    // 3.字符串转换成时间/自动转换0时区/东加西减
    NSDate *news_date = [formatter dateFromString:str_news];
    NSDate *now_date = [formatter dateFromString:str_now];
    
    NSInteger year_news = [timeHelper GetYear:news_date];
    NSInteger year_now = [timeHelper GetYear:now_date];
    NSInteger month_news = [timeHelper GetMonth:news_date];
    NSInteger month_now = [timeHelper GetMonth:now_date];
    NSInteger day_news = [timeHelper GetDay:news_date];
    NSInteger day_now = [timeHelper GetDay:now_date];
    NSInteger hour_news = [timeHelper GetHour:news_date];
    NSInteger hour_now = [timeHelper GetHour:now_date];
    NSInteger min_news = [timeHelper GetMin:news_date];
    NSInteger min_now = [timeHelper GetMin:now_date];
    NSLog(@"year:%ld,month:%ld,day:%ld,hour:%ld,min:%ld",year_now,month_now,day_now,hour_now,min_now);
    //年
    if(year_now > year_news){
        // 1.创建一个时间格式化对象
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        // 2.设置时间格式化对象的样式
        formatter.dateFormat = @"yyyy年MM月dd日";
        
        NSString* time = [formatter stringFromDate:news_date];
        return time;
    }
    //月
    if(month_now - month_news > 0){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM月dd日";
        NSString* time = @"";
        time = [time stringByAppendingString:[formatter stringFromDate:news_date]];
        return time;
    }
    //日
    if(day_now-day_news == 0){//今天
        //小时
//        if(hour_now - hour_news == 0){//一个小时内
//            //分
//            if(min_now - min_news >= 3){
//                NSInteger min_count = min_now - min_news;
//                return [NSString stringWithFormat:@"%ld分钟前",min_count];
//            }else{//3分钟内
//                return @"刚刚";
//            }
//        }else if(hour_now - hour_news > 0){//多个小时
//            NSInteger hour_count = hour_now - hour_news;
//            return [NSString stringWithFormat:@"%ld小时前",hour_count];
//        }
        return @"今天";
        
    }
    else{//昨天
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString* time = @"";
        time = [time stringByAppendingString:[formatter stringFromDate:news_date]];
        return time;
    }
    
    //    // 4.获取了时间元素
    //    NSDateComponents *cmps = [calendar components:type fromDate:date toDate:now options:0];
    //
    //    NSLog(@"%ld年%ld月%ld日%ld小时%ld分钟%ld秒钟", cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second);
    
    return nil;
}

//string转换时间
-(NSString*)GetDateFromString_yyMMDD_HHMMSS:(NSString*)str_time{
    NSTimeInterval interval=[str_time doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}

-(NSString*)GetDateFromString_YYYYMMDD:(NSString*)str_time{
    NSTimeInterval interval=[str_time doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

-(NSString*)GetDateFromString_yyMMDD_HHMM:(NSString*)str_time{
    NSTimeInterval interval=[str_time doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [formatter stringFromDate:date];
}

-(NSString*)GetDateFromString_MMDD:(NSString*)str_time{
    NSTimeInterval interval=[str_time doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd"];
    NSString* str = [formatter stringFromDate:date];
    return str;
}

//获取当地时间
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

//年
-(NSInteger)GetYear:(NSDate*)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:date];
    return [components year];
}
//月
-(NSInteger)GetMonth:(NSDate*)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:date];
    return [components month];
}
//日
-(NSInteger)GetDay:(NSDate*)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:date];
    return [components day];
}
//hour
-(NSInteger)GetHour:(NSDate*)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:date];
    return [components hour];
}
//分
-(NSInteger)GetMin:(NSDate*)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitMinute fromDate:date];
    return [components minute];
}

-(NSString*)dateChangeToString:(NSString*)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM-dd HH:mm";
    NSDate *news_date = [NSDate dateWithTimeIntervalSince1970:[date longLongValue]];
    NSString* time = @"";
    time = [time stringByAppendingString:[formatter stringFromDate:news_date]];
    return time;
}

-(NSString*)dateChangeToString_YYYYMMDDHHMM:(NSString*)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm";
    NSDate *news_date = [NSDate dateWithTimeIntervalSince1970:[date longLongValue]];
    NSString* time = @"";
    time = [time stringByAppendingString:[formatter stringFromDate:news_date]];
    return time;
}

-(NSString*)dateChangeToString_day:(NSString*)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSDate *news_date = [NSDate dateWithTimeIntervalSince1970:[date longLongValue]];
    NSDate* now_date = [NSDate date];
    NSString* time = @"";
    time = [time stringByAppendingString:[formatter stringFromDate:news_date]];
    NSString* time_now = [formatter stringFromDate:now_date];
    
    if([time isEqualToString:time_now]){
        return @"今天";
    }
    return time;
}

-(NSString*)dateChangeToString_mon:(NSString*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM";
    NSDate *news_date = [NSDate dateWithTimeIntervalSince1970:[date longLongValue]];
    NSDate* now_date = [NSDate date];
    NSString* time = @"";
    time = [time stringByAppendingString:[formatter stringFromDate:news_date]];
    NSString* time_now = [formatter stringFromDate:now_date];
    
    if([time isEqualToString:time_now]){
        return @"本月";
    }
    return time;
}

//整理同一天的数据
-(NSArray*)sortDataWithDay:(NSArray*)array{
    //取第一条数据
    //找到与第一条数据同一天的所有数据
    //返回该该一天所有数据
    
    if(array.count == 0){
        return nil;
    }
    
    NSMutableArray* sorted_array = [[NSMutableArray alloc]init];
    
    Mine_goldDetail_cell_model* model = array[0];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *new_date = [NSDate dateWithTimeIntervalSince1970:[model.time doubleValue]];
    
    [sorted_array addObject:model];
    
//    NSInteger index = 0;
    if(array.count == 1){
        return sorted_array;
    }
    for (int i=1;i<array.count;i++) {
        Mine_goldDetail_cell_model* item = array[i];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"yyyy-MM-dd";
        NSDate *old_date = [NSDate dateWithTimeIntervalSince1970:[item.time doubleValue]];
        TimeHelper* timeHelper = [[TimeHelper alloc] init];
        if([timeHelper GetYear:new_date] == [timeHelper GetYear:old_date] &&
           [timeHelper GetMonth:new_date] == [timeHelper GetMonth:old_date] &&
           [timeHelper GetDay:new_date] == [timeHelper GetDay:old_date]){
            
            [sorted_array addObject:item];
        }
    }
    
    return sorted_array;
    
}

//整理所有数据
-(NSArray*)sortAllData_day:(NSArray*)array{
    NSMutableArray* array_all = [[NSMutableArray alloc]init];
    
    while (true) {
        NSArray* array_tmp = [self sortDataWithDay:array];//一天内的数据
        if(array_tmp == nil){
            array_tmp = [[NSArray alloc] init];
        }
        //去掉已经整理好的数据
        NSMutableArray* arr_sort = [NSMutableArray arrayWithArray:array];
        [arr_sort removeObjectsInArray:array_tmp];
        array = arr_sort;
        [array_all addObject:array_tmp];
        if(array.count == 0){
            break;
        }
    }
    
    return array_all;
}

-(NSArray*)sortAllData_mon:(NSArray*)array{
    NSMutableArray* array_all = [[NSMutableArray alloc]init];
    
    while (true) {
        NSArray* array_tmp = [self sortDataWithMon:array];//一天内的数据
        if(array_tmp == nil){
            array_tmp = [[NSArray alloc] init];
        }
        //去掉已经整理好的数据
        NSMutableArray* arr_sort = [NSMutableArray arrayWithArray:array];
        [arr_sort removeObjectsInArray:array_tmp];
        array = arr_sort;
        [array_all addObject:array_tmp];
        if(array.count == 0){
            break;
        }
    }
    
    return array_all;
}

//整理同一月的数据
-(NSArray*)sortDataWithMon:(NSArray*)array{
    //取第一条数据
    //找到与第一条数据同一月的所有数据
    //返回该该一月所有数据
    
    if(array.count == 0){
        return nil;
    }
    
    NSMutableArray* sorted_array = [[NSMutableArray alloc]init];
    
    Mine_goldDetail_cell_model* model = array[0];
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *new_date = [NSDate dateWithTimeIntervalSince1970:[model.time doubleValue]];
    
    [sorted_array addObject:model];
    
    //    NSInteger index = 0;
    if(array.count == 1){
        return sorted_array;
    }
    for (int i=1;i<array.count;i++) {
        Mine_goldDetail_cell_model* item = array[i];
        //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //        formatter.dateFormat = @"yyyy-MM-dd";
        NSDate *old_date = [NSDate dateWithTimeIntervalSince1970:[item.time doubleValue]];
        TimeHelper* timeHelper = [[TimeHelper alloc] init];
        if([timeHelper GetYear:new_date] == [timeHelper GetYear:old_date] &&
           [timeHelper GetMonth:new_date] == [timeHelper GetMonth:old_date]){
            
            [sorted_array addObject:item];
        }
    }
    
    return sorted_array;
    
}

-(NSArray*)sortAllData_day_news:(NSArray*)array{
    NSMutableArray* array_all = [[NSMutableArray alloc]init];
    
    while (true) {
        NSArray* array_tmp = [self sortDataWithday_news:array];//一天内的数据
        if(array_tmp == nil){
            array_tmp = [[NSArray alloc] init];
        }
        //去掉已经整理好的数据
        NSMutableArray* arr_sort = [NSMutableArray arrayWithArray:array];
        [arr_sort removeObjectsInArray:array_tmp];
        array = arr_sort;
        [array_all addObject:array_tmp];
        if(array.count == 0){
            break;
        }
    }
    
    return array_all;
}
-(NSArray*)sortDataWithday_news:(NSArray*)array{
    //取第一条数据
    //找到与第一条数据同一月的所有数据
    //返回该该一月所有数据
    
    if(array.count == 0){
        return nil;
    }
    
    NSMutableArray* sorted_array = [[NSMutableArray alloc]init];
    //先找到最大的日期，从大到小排序
//    NSInteger index = [self GetIndexOfMaxDate:array];
    CJZdataModel* model = array[0];
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    formatter.dateFormat = @"yyyy-MM-dd";
    NSString* shijiancuo = [self dateChangeToTimeSecond:model.publish_time];
    NSDate *new_date = [NSDate dateWithTimeIntervalSince1970:[shijiancuo doubleValue]];
    
    [sorted_array addObject:model];
    
    //    NSInteger index = 0;
    if(array.count == 1){
        return sorted_array;
    }
    for (int i=1;i<array.count;i++) {
        CJZdataModel* item = array[i];
        //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //        formatter.dateFormat = @"yyyy-MM-dd";
        NSString* shijiancuo1 = [self dateChangeToTimeSecond:item.publish_time];
        NSDate *old_date = [NSDate dateWithTimeIntervalSince1970:[shijiancuo1 doubleValue]];
        TimeHelper* timeHelper = [[TimeHelper alloc] init];
        if([timeHelper GetYear:new_date] == [timeHelper GetYear:old_date] &&
           [timeHelper GetMonth:new_date] == [timeHelper GetMonth:old_date] &&
           [timeHelper GetDay:new_date] == [timeHelper GetDay:old_date]){
            
            [sorted_array addObject:item];
        }
    }
    
    return sorted_array;
}


-(NSNumber*)getCurrentTime_number{
    NSDate* date_now = [NSDate date];
    NSTimeInterval second = [date_now timeIntervalSince1970];
    return [NSNumber numberWithDouble:second];
}

-(NSString*)getCurrentTime_YYYYMMDD{
    NSDate* date_now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    return [formatter stringFromDate:date_now];
}

-(NSString*)getCurrentTime_YYYYMMDDHHSS{
    NSDate* date_now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:SS";
    return [formatter stringFromDate:date_now];
}

//比较时间差
-(BOOL)compareTimes_ori_time:(NSNumber*)oriTime dest_time:(NSNumber*)destTime time:(NSInteger)seconds{
    NSInteger ori = [oriTime integerValue];
    NSInteger dest = [destTime integerValue];
    NSInteger shijiancha = dest - ori;
    if(shijiancha >= seconds){
        return YES;
    }else{
        return NO;
    }
}

//日期转时间戳
-(NSString*)dateChangeToTimeSecond:(NSString*)time_date{
    // 1.创建一个时间格式化对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // 2.格式化对象的样式/z大小写都行/格式必须严格和字符串时间一样
    formatter.dateFormat = @"yyyy-MM-dd";
//    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*60*60]];//东8区
    
    // 3.利用时间格式化对象让字符串转换成时间 (自动转换0时区/东加西减)
    NSDate *date = [formatter dateFromString:time_date];
    NSTimeInterval second = [date timeIntervalSince1970];
//    second += 8*60*60;//东8区
    return [NSString stringWithFormat:@"%ld",(long)second];
}

@end
