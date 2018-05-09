//
//  Mine_GetApprentice_model.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/16.
//  Copyright © 2018年 apple. All rights reserved.
//
/*
 {
 "user_id":"379860b6a0338a82250f341959b0b9a4",
 "avatar":"",
 "name":"6868_9152722",
 "telephone":"13241690070",
 "slaver_income":1.2,
 "count":3,
 "max":3,
 "ctime":1523948493,
 "last_login_time":1524034771,
 "is_finished_newbie":1
 
 avatar : 头像
 name : 昵称
 telephone : 手机号码
 slaver_income : 提成总收益
 count : 徒弟分布完成金币任务奖励 0 ，1 ，2 ，3 4，5
 max : 3或5
 ctime : 收徒时间 时间戳
 last_login_time : 最后活跃时间
 is_finished_newbie : 新手任务 0:完成 1:完成
 }
 */

#import <Foundation/Foundation.h>

@interface Mine_GetApprentice_model : NSObject

@property (nonatomic,strong)NSString* user_id;
@property (nonatomic,strong)NSString* avatar;
@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSString* telephone;
@property (nonatomic,strong)NSString* slaver_income;
@property (nonatomic,strong)NSString* count;
@property (nonatomic,strong)NSString* max;
@property (nonatomic,strong)NSString* time;
@property (nonatomic,strong)NSString* last_login_time;
@property (nonatomic,strong)NSString* is_finished_newbie;


+(NSArray*)dicToArray:(NSArray*)array_dic;

@end
