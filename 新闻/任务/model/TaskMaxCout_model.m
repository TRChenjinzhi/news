//
//  TaskMaxCout_model.m
//  新闻
//
//  Created by chenjinzhi on 2018/2/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TaskMaxCout_model.h"

//{"code":200,"msg":"succ","list":[{"type":2,"max":50,"count":0},{"type":3,"max":10,"count":0},{"type":5,"max":1,"count":0},{"type":6,"max":5,"count":0}]}
@implementation TaskMaxCout_model

+(NSArray*)dicToArray:(NSDictionary*)dic{
    NSMutableArray* array = [[NSMutableArray alloc]initWithCapacity:5];
    NSArray* array_dic = dic[@"list"];
    for (NSDictionary* item_dic in array_dic) {
        TaskMaxCout_model* model = [[TaskMaxCout_model alloc]init];
        NSNumber* type = item_dic[@"type"];
        model.type = [type longValue];
        NSNumber* max = item_dic[@"max"];
        model.maxCout = [max longValue];
        NSNumber* count = item_dic[@"count"];
        model.count = [count longValue];
        
        [array addObject:model];
    }
    
    return array;
}

@end
