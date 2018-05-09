//
//  Mine_GetApprentice_model.m
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
 }
 */

#import "Mine_GetApprentice_model.h"

@implementation Mine_GetApprentice_model

+(NSArray*)dicToArray:(NSArray*)array_dic{
    NSMutableArray* array_model = [[NSMutableArray alloc] initWithCapacity:10];;
    for (NSDictionary* dic in array_dic) {
        Mine_GetApprentice_model* model = [[Mine_GetApprentice_model alloc] init];
        model.user_id = dic[@"user_id"];
        model.avatar = dic[@"avatar"];
        model.name = dic[@"name"];
        model.telephone = dic[@"telephone"];
        NSNumber* income = dic[@"slaver_income"];
        model.slaver_income = [NSString stringWithFormat:@"%ld",[income integerValue]];
        model.count = [JsonHelper JsonToObject_ToStringByInterger:dic[@"count"]];
        model.max   = [JsonHelper JsonToObject_ToStringByInterger:dic[@"max"]];
        NSNumber* time = dic[@"ctime"];
        model.time = [NSString stringWithFormat:@"%ld",[time integerValue]];
        model.last_login_time = [JsonHelper JsonToObject_ToStringByInterger:dic[@"last_login_time"]];
        model.is_finished_newbie = [JsonHelper JsonToObject_ToStringByInterger:dic[@"is_finished_newbie"]];
        
        [array_model addObject:model];
    }
    
    return array_model;
}

@end
