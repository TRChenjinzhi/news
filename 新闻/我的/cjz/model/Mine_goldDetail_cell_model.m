//
//  Mine_goldDetail_cell.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_goldDetail_cell_model.h"

@implementation Mine_goldDetail_cell_model

+(NSArray*)dicToModelArray:(NSDictionary*)dic{
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:10];
    NSArray* array_tmp = dic[@"list"];
    if(array_tmp == (NSArray*)[NSNull null]){
        array_tmp = [NSArray array];
    }
    for (NSDictionary* dic_item in array_tmp) {
        Mine_goldDetail_cell_model* model = [[Mine_goldDetail_cell_model alloc]init];
        model.title = dic_item[@"title"];
        NSNumber* number = dic_item[@"date"];
        model.time = [NSString stringWithFormat:@"%ld",[number longValue]];
        model.count = [dic_item[@"coin"] floatValue];
        model.isGold = YES;
        
        [array addObject:model];
    }
    
    return array;
}

+(NSArray*)dicToModelArray_package:(NSDictionary*)dic{
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:10];
    NSArray* array_tmp = dic[@"list"];
    if(array_tmp == (NSArray*)[NSNull null]){
        array_tmp = [NSArray array];
    }
    for (NSDictionary* dic_item in array_tmp) {
        Mine_goldDetail_cell_model* model = [[Mine_goldDetail_cell_model alloc]init];
        model.title = dic_item[@"title"];
        NSNumber* number = dic_item[@"date"];
        model.time = [NSString stringWithFormat:@"%ld",[number longValue]];
        model.count = [dic_item[@"cash"] floatValue];
        
        [array addObject:model];
    }
    
    return array;
}

@end
