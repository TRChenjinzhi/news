//
//  NewUserTask_model.m
//  新闻
//
//  Created by chenjinzhi on 2018/4/18.
//  Copyright © 2018年 apple. All rights reserved.
//

/*
 {
 "type":8,    //绑定微信
 "max":1,     //无用
 "count":0,   //无用
 "status":0   //完成状态    0：未完成   1：完成
 }
 */

#import "NewUserTask_model.h"

@implementation NewUserTask_model

+(NSMutableArray *)dicToArray:(NSArray *)array_dic{
    NSMutableArray* array = [NSMutableArray array];
    for (NSDictionary* item_dic in array_dic) {
        NewUserTask_model* model = [[NewUserTask_model alloc]init];
        
        NSNumber* type = item_dic[@"type"];
        model.type = [type integerValue];
        
        NSString* max = item_dic[@"max"];
        model.max = [max integerValue];
        
        NSNumber* count = item_dic[@"count"];
        model.count = [count integerValue];
        
        NSNumber* status_number = item_dic[@"status"];
        model.status = [status_number integerValue];
        
        
        [array addObject:model];
    }
    
    return array;
}

@end
