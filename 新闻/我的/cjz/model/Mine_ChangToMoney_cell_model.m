//
//  Mine_ChangToMoney_cell_model.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_ChangToMoney_cell_model.h"

@implementation Mine_ChangToMoney_cell_model

+(NSArray*)dicToModelArray:(NSDictionary*)dic{
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:10];
    NSArray* array_tmp = dic[@"list"];
    if(array_tmp == (NSArray*)[NSNull null]){
        array_tmp = [NSArray array];
    }
    for (NSDictionary* dic_item in array_tmp) {
        Mine_ChangToMoney_cell_model* model = [[Mine_ChangToMoney_cell_model alloc]init];
        NSNumber* number1 = dic_item[@"type"];
        model.type = [NSString stringWithFormat:@"%ld",[number1 longValue]];
        NSNumber* number = dic_item[@"ctime"];
        model.time = [NSString stringWithFormat:@"%ld",[number longValue]];
        
        model.moeny = dic_item[@"money"];
        model.state = dic_item[@"state"];
        model.ID = dic_item[@"id"];
        model.withDraw_type = [JsonHelper JsonToObject_ToStringByInterger:dic_item[@"withDraw_type"]];
        
        [array addObject:model];
    }
    
    return array;
}

@end
