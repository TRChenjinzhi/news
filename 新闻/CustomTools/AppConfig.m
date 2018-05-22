//
//  AppConfig.m
//  新闻
//
//  Created by 范英强 on 16/9/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AppConfig.h"
#import "ChannelName.h"
#import "NewUserTask_model.h"

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

//保存视频频道信息
-(void)saveUrlVideo:(NSDictionary*)str{
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"video-chanels"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSDictionary*)getUrlVideo{
    NSDictionary* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"video-chanels"];
    return data;
}

//保存搜索关键字
-(void)saveSearchWord:(NSArray*)array AndType:(NSString*)type{
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:[NSString stringWithFormat:@"SearchWord-%@",type]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSArray*)GetSearchWordAndType:(NSString*)type{
    NSArray* data = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"SearchWord-%@",type]];
    
    //将数组倒序
    NSArray* data_tmp = [[data reverseObjectEnumerator] allObjects];
    
    return data_tmp;
}

-(void)addSearchWord:(NSString*)searchWord AndType:(NSString*)type{
    NSArray* data = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"SearchWord-%@",type]];
    
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
    
    [self saveSearchWord:array AndType:type];
}

-(void)removeSearchWord:(NSString*)searchWord AndType:(NSString*)type{
    NSArray* data = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"SearchWord-%@",type]];

    NSMutableArray* array = [[NSMutableArray alloc] initWithArray:data];
    [array removeObject:searchWord];
    
    [self saveSearchWord:array AndType:type];
}

-(void)removeSearchWordByIndex:(NSInteger)index AndType:(NSString*)type{
    NSArray* data = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"SearchWord-%@",type]];
    
    NSMutableArray* array = [[NSMutableArray alloc] initWithArray:data];
    [array removeObjectAtIndex:index];
    
    [self saveSearchWord:array AndType:type];
}

-(void)removeSearchWordAllAndType:(NSString*)type{
    NSArray* data = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"SearchWord-%@",type]];
    
    NSMutableArray* array = [[NSMutableArray alloc] initWithArray:data];
    [array removeAllObjects];
    
    [self saveSearchWord:array AndType:type];
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
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
//
//    NSString* str_dic = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"userInfo"];//内的值 不允许有nil值
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(NSDictionary*)GetUserInfo{
//    NSString* str_dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
//    if(str_dic == nil){
//        return nil;
//    }
    
    NSDictionary* str_dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    if(str_dic == nil){
        return nil;
    }
    
//    NSData *jsonData = [str_dic dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return str_dic;
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
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[NSString stringWithFormat:@"userIcon-%@",[Login_info share].userInfo_model.user_id]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(UIImage*)getUserIcon{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"userIcon-%@",[Login_info share].userInfo_model.user_id]];
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
-(NSArray*)getNewsByChannel_id:(NSString*)channel_id{
    NSArray* array = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"news-%@",channel_id]];
    NSArray *dataarray = [CJZdataModel DicToArrayModel_top50:array];
    NSMutableArray *statusArray = [NSMutableArray arrayWithArray:dataarray];

    return statusArray;
}

//显示的频道
-(void)saveChannel:(NSArray*)array {
    if(array == nil){
        [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:[NSString stringWithFormat:@"channel_normal-%@",[Login_info share].userInfo_model.user_id]];
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
    [[NSUserDefaults standardUserDefaults] setObject:(NSArray*)tmp forKey:[NSString stringWithFormat:@"channel_normal-%@",[Login_info share].userInfo_model.user_id]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSArray*)getChannel{
    NSArray* array = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"channel_normal-%@",[Login_info share].userInfo_model.user_id]];
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
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:[NSString stringWithFormat:@"messageBox-%@",[Login_info share].userInfo_model.user_id]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString*)getMessageDate{
    NSString* date = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"messageBox-%@",[Login_info share].userInfo_model.user_id]];
    if([date isEqualToString:@""]){
        return nil;
    }
    return date;
}

//第一次打开app的红包
-(void)saveRedPackage_first:(NSString*)date{
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"redPack_firstOne"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString*)getRedPackage_first{
    NSString* date = [[NSUserDefaults standardUserDefaults] objectForKey:@"redPack_firstOne"];
    if([date isEqualToString:@" "]){
        return nil;
    }
    return date;
}

//记录提示红包时间
-(void)saveRedPackage:(NSString*)date{
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"redPack_tips"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString*)getRedPackage{
    NSString* date = [[NSUserDefaults standardUserDefaults] objectForKey:@"redPack_tips"];
    if([date isEqualToString:@" "]){
        return nil;
    }
    return date;
}

//红包奖励
-(void)saveRedPackage_money:(NSString*)date{
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:[NSString stringWithFormat:@"redPack_money-%@",[Login_info share].userInfo_model.user_id]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString*)getRedPackage_money{
    NSString* date = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"redPack_money-%@",[Login_info share].userInfo_model.user_id]];
    if([date isEqualToString:@" "]){
        return nil;
    }
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

//记录验证码时间
-(void)saveIdifyCode:(NSNumber*)time{
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"idifycode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSNumber*)getIdefyCode{
    NSNumber* date = [[NSUserDefaults standardUserDefaults] objectForKey:@"idifycode"];
    return date;
}

//记录视频信息
-(void)saveVideo:(NSString *)channelId AndArray:(NSArray *)array{
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:[NSString stringWithFormat:@"video-%@",channelId]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSArray *)getVideo:(NSString *)channelId{
    NSArray* array = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"video-%@",channelId]];
    array = [video_info_model collectData_ToArray:array];
    return array;
}

//记录新手任务信息
-(void)saveNewUserTaskInfo{
    NSLog(@"保存用户新手任务信息");
    NSMutableArray* array = [NSMutableArray array];
    for (NewUserTask_model* model in [TaskCountHelper share].get_task_newUser_name_array) {
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        /*
         {
         "type":8,    //绑定微信
         "max":1,     //无用
         "count":0,   //无用
         "status":0   //完成状态    0：未完成   1：完成
         }
         */
        [dic setObject:[NSNumber numberWithInteger:model.type] forKey:@"type"];
        [dic setObject:[NSNumber numberWithInteger:model.max] forKey:@"max"];
        [dic setObject:[NSNumber numberWithInteger:model.count] forKey:@"count"];
        [dic setObject:[NSNumber numberWithInteger:model.status] forKey:@"status"];
        
        [array addObject:dic];
    }
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:[NSString stringWithFormat:@"NewUserTaskInfo-%@",[Login_info share].userInfo_model.user_id]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)getNewUserTaskInfo{
    NSArray* dic = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"NewUserTaskInfo-%@",[Login_info share].userInfo_model.user_id]];
    if(dic == nil || dic.count == 0){
        NSLog(@"获取用户新手任务信息-失败");
        [TaskCountHelper share].task_newUser_name_array = nil;
        [InternetHelp GetNewUserTaskCount_Sucess:^(NSDictionary *dic) {
            NSArray* array = [NewUserTask_model dicToArray:dic[@"list"]];
            [TaskCountHelper share].task_newUser_name_array = array;
            NSLog(@"获取用户新手任务信息");
        } Fail:^(NSDictionary *dic) {
            NSLog(@"获取用户新手任务信息-再次失败");
        }];
        return;
    }
    else{
        NSLog(@"获取用户新手任务信息");
       [TaskCountHelper share].task_newUser_name_array = [NewUserTask_model dicToArray:dic];
    }
}

-(void)clearNewUserTaskInfo{
    NSLog(@"清除用户新手任务信息");
    [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:[NSString stringWithFormat:@"NewUserTaskInfo-%@",[Login_info share].userInfo_model.user_id]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//新手任务完成弹窗
-(void)saveShowWinForFirstDone_newUserTask:(BOOL)isDone{
    [[NSUserDefaults standardUserDefaults] setBool:isDone forKey:[NSString stringWithFormat:@"NewUserTaskInfo_isDone-%@",[Login_info share].userInfo_model.user_id]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)getShowWinForFirstDone_newUserTask{
    BOOL isDone = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"NewUserTaskInfo_isDone-%@",[Login_info share].userInfo_model.user_id]];
    return isDone;
}

//新手任务指导
-(void)saveGuideOfNewUser:(BOOL)isGuide{
    [[NSUserDefaults standardUserDefaults] setBool:isGuide forKey:[NSString stringWithFormat:@"GuideOfNewUser_isDone-%@",[Login_info share].userInfo_model.user_id]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)getGuideOfNewUser{
    BOOL isDone = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"GuideOfNewUser_isDone-%@",[Login_info share].userInfo_model.user_id]];
    return isDone;
}

//支付账号信息
-(void)saveZhifuInfo:(Mine_zhifu_model*)model{
    NSDictionary* dic = [Mine_zhifu_model modelToDic:model];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:[NSString stringWithFormat:@"zhifuInfo-%@",[Login_info share].userInfo_model.user_id]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSDictionary*)getZhifuInfo{
    NSDictionary* str = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"zhifuInfo-%@",[Login_info share].userInfo_model.user_id]];
    return str;
}

//抽奖提示弹窗
-(void)saveChoujiangTips:(BOOL)isShow{
    [[NSUserDefaults standardUserDefaults] setBool:isShow forKey:[NSString stringWithFormat:@"choujiangTips_isDone-%@",[Login_info share].userInfo_model.user_id]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)getChoujiangTips_isShow{
    BOOL isDone = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"choujiangTips_isDone-%@",[Login_info share].userInfo_model.user_id]];
    return isDone;
}

@end
