//
//  Mine_message_model.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_message_model.h"

 /*
 {
 "type":1,
 "title":"金币兑换提醒",
 "desc":"恭喜您，已经将昨日赚取的600金币自动兑换成零钱：0.60元。请继续加油哦！",
 "date":1517990294
 }
 */


@implementation Mine_message_model

+(NSArray*)dicToModelArray:(NSDictionary*)dic{
    NSMutableArray* array_model = [[NSMutableArray alloc]initWithCapacity:10];
    NSArray* array_tmp = dic[@"list"];
    for (NSDictionary* dic_item in array_tmp) {
        Mine_message_model* model = [[Mine_message_model alloc] init];
        NSNumber* type = dic_item[@"type"];
        model.type = [NSString stringWithFormat:@"%ld",[type integerValue]];
        model.title = dic_item[@"title"];
        model.subTitle = dic_item[@"desc"];
        NSNumber* date = dic_item[@"date"];
        model.time = [NSString stringWithFormat:@"%ld",[date integerValue]];
        
        [array_model addObject:model];
    }
    
    return array_model;
}

@end
