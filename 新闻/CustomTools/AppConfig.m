//
//  AppConfig.m
//  新闻
//
//  Created by 范英强 on 16/9/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AppConfig.h"
#import "ChannelName.h"

@implementation AppConfig

static id _instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

+ (void)saveProAndCityInfoWithPro:(NSString *)pro city:(NSString *)city
{
    [[NSUserDefaults standardUserDefaults] setObject:pro forKey:@"kProvice"];
    [[NSUserDefaults standardUserDefaults] setObject:city forKey:@"kCity"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getProInfo
{
    NSString *provice = [[NSUserDefaults standardUserDefaults] objectForKey:@"kProvice"];
    return provice;
}
+ (NSString *)getCityInfo
{
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:@"kCity"];
    return city;
}

//保存频道信息
-(void)saveChannelName_youLike:(NSArray *)json{
    [[NSUserDefaults standardUserDefaults] setObject:json forKey:@"channel"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSArray *)GetChannelNameYouLike{
    NSArray* json = [[NSUserDefaults standardUserDefaults] objectForKey:@"channel"];
    return json;
}

//保存新闻信息
-(void)saveUrlNews:(id)str{
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"UrlModel"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(id)getUrlNews{
    NSString* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"UrlModel"];
    return data;
}

//保存搜索关键字
-(void)saveSearchWord:(NSArray*)array{
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"SearchWord"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSArray*)GetSearchWord{
    NSArray* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"SearchWord"];
    
    //将数组倒序
    NSArray* data_tmp = [[data reverseObjectEnumerator] allObjects];
    
    return data_tmp;
}

-(void)addSearchWord:(NSString*)searchWord{
    NSArray* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"SearchWord"];
    
    NSMutableArray* array = [[NSMutableArray alloc] initWithArray:data];
    
    //去重
    BOOL isHave = false;
    for (NSString* str in array) {
        if([str isEqualToString:searchWord]){
            isHave = YES;
            break;
        }
    }
    if(!isHave){
        [array addObject:searchWord];
        if(array.count == 11){//不能超过10条记录
            [array removeObjectAtIndex:0];
        }
    }
    
    [self saveSearchWord:array];
}

-(void)removeSearchWord:(NSString*)searchWord{
    NSArray* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"SearchWord"];

    NSMutableArray* array = [[NSMutableArray alloc] initWithArray:data];
    [array removeObject:searchWord];
    
    [self saveSearchWord:array];
}

-(void)removeSearchWordByIndex:(NSInteger)index{
    NSArray* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"SearchWord"];
    
    NSMutableArray* array = [[NSMutableArray alloc] initWithArray:data];
    [array removeObjectAtIndex:index];
    
    [self saveSearchWord:array];
}

-(void)removeSearchWordAll{
    NSArray* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"SearchWord"];
    
    NSMutableArray* array = [[NSMutableArray alloc] initWithArray:data];
    [array removeAllObjects];
    
    [self saveSearchWord:array];
}

//新闻详细页面 阅读字体
-(void)saveFontSize:(NSInteger)size{
    NSNumber* number = [NSNumber numberWithInteger:size];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"FontSize"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger)GetFontSize{
    NSNumber* number = [[NSUserDefaults standardUserDefaults] objectForKey:@"FontSize"];
    if(number == nil){
        return 1;
    }
    return [number integerValue];
}

//用户信息
-(void)saveUserInfo:(NSDictionary *)dic{
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"userInfo"];//内的值 不允许有nil值
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(NSDictionary*)GetUserInfo{
    NSDictionary* dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    return dic;
}

-(void)clearUserInfo{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)saveUserAcount:(NSString*)acount{
    [[NSUserDefaults standardUserDefaults] setObject:acount forKey:@"acount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString*)getUserAcount{
    NSString* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"acount"];
    return data;
}

//任务信息
-(void)saveTaskType:(NSInteger)type{
    NSNumber* number = [NSNumber numberWithInteger:type];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"taskInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSInteger)getTaskType:(NSInteger)type{
    NSNumber* number = [[NSUserDefaults standardUserDefaults] objectForKey:@"taskInfo"];
    return [number integerValue];
}

//开启宝箱 时间
-(void)saveBoxTime:(NSInteger)int_time{
    NSNumber* number = [NSNumber numberWithInteger:int_time];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:[NSString stringWithFormat:@"boxTime-%@",[Login_info share].userInfo_model.user_id]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSInteger)getBoxTime{
    NSNumber* number = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"boxTime-%@",[Login_info share].userInfo_model.user_id]];
    return [number integerValue];
}

//用户头像
-(void)saveUserIcon:(UIImage*)img{
    NSData* data = UIImagePNGRepresentation(img);
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userIcon"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(UIImage*)getUserIcon{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userIcon"];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

//记录频道新闻刷新时间
-(void)saveTheTime_lastRefresh:(NSString*)channel_id{
    NSNumber* time = [[TimeHelper share] getCurrentTime_number];
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:[NSString stringWithFormat:@"channel-%@",channel_id]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSNumber*)getTheTime_lastRefresh:(NSString*)channel_id{
    NSNumber* time = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"channel-%@",channel_id]];
    return time;
}

//新闻数据
-(void)saveNews:(NSArray*)array channel_id:(NSString*)channel_id{
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:[NSString stringWithFormat:@"news-%@",channel_id]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSMutableArray*)getNewsByChannel_id:(NSString*)channel_id{
    NSArray* array = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"news-%@",channel_id]];
    NSArray *dataarray = [CJZdataModel DicToArrayModel_top50:array];
    NSMutableArray *statusArray = [NSMutableArray arrayWithArray:dataarray];

    return statusArray;
}

//显示的频道
-(void)saveChannel:(NSArray*)array {
    if(array == nil){
        [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:@"channel_normal"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    NSMutableArray* tmp = [NSMutableArray array];
    for (ChannelName* item in array) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setObject:item.ID forKey:@"id"];
        [dic setObject:item.title forKey:@"title"];
        NSString* str_bool = @"";
        if(item.isNewChannel){
            str_bool = @"1";
        }else{
            str_bool = @"0";
        }
        [dic setObject:str_bool forKey:@"isNewChannel"];
        [tmp addObject:dic];
    }
    [[NSUserDefaults standardUserDefaults] setObject:(NSArray*)tmp forKey:@"channel_normal"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSArray*)getChannel{
    NSArray* array = [[NSUserDefaults standardUserDefaults] objectForKey:@"channel_normal"];
    NSMutableArray* tmp = [NSMutableArray array];
    for (NSDictionary* dic in array) {
        ChannelName* channel = [[ChannelName alloc] init];
        channel.ID = dic[@"id"];
        channel.title = dic[@"title"];
        NSString* str_bool = dic[@"isNewChannel"];
        if([str_bool isEqualToString:@"1"]){
            channel.isNewChannel = YES;
        }else{
            channel.isNewChannel = NO;
        }
        [tmp addObject:channel];
    }
    return tmp;
}

//保存日期
-(void)saveDate:(NSString*)date{
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"date"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString*)getDate{
    NSString* date = [[NSUserDefaults standardUserDefaults] objectForKey:@"date"];
    return date;
}

//保存打开消息中心的时间
-(void)saveMessageDate:(NSString *)date{
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"messageBox"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString*)getMessageDate{
    NSString* date = [[NSUserDefaults standardUserDefaults] objectForKey:@"messageBox"];
    return date;
}

//记录提示红包时间
-(void)saveRedPackage:(NSString*)date{
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"redPack_tips"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString*)getRedPackage{
    NSString* date = [[NSUserDefaults standardUserDefaults] objectForKey:@"redPack_tips"];
    return date;
}

//记录用户userID
-(void)saveUserId:(NSString*)userId{
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:userId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString*)getUserId:(NSString*)userId{
    NSString* date = [[NSUserDefaults standardUserDefaults] objectForKey:userId];
    return date;
}

@end
