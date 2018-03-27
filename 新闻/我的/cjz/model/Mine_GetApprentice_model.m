//
//  Mine_GetApprentice_model.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/16.
//  Copyright © 2018年 apple. All rights reserved.
//

/*
 {
 "user_id":"xxxxxxx",
 "avatar":"http://q.qlogo.cn/qqapp/1105182645/814B08C64ADD12284CA82BA39384B177/100",
 "name":"f4e2_6140732",
 "telephone":"13403773438",
 "slaver_income":0,
 "count":1,
 "ctime":1518314734,
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
        model.count = dic[@"count"];
        NSNumber* time = dic[@"ctime"];
        model.time = [NSString stringWithFormat:@"%ld",[time integerValue]];
        
        [array_model addObject:model];
    }
    
    return array_model;
}

@end
