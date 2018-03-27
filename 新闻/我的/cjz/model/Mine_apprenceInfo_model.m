//
//  Mine_apprenceInfo_model.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/22.
//  Copyright © 2018年 apple. All rights reserved.
//

/*
 {
 "income":0.01,      //提成额
 "date":1517932800   //日期
 }
 */

#import "Mine_apprenceInfo_model.h"

@implementation Mine_apprenceInfo_model

+(NSMutableArray *)dicToArray:(NSDictionary*)dic{
    NSArray* array_dic = dic[@"list"];
    
    NSMutableArray* array = [NSMutableArray array];
    for (NSDictionary* dic in array_dic) {
        Mine_apprenceInfo_model* model = [[Mine_apprenceInfo_model alloc] init];
        model.income = dic[@"income"];
        NSNumber* date_number = dic[@"date"];
        model.date = [NSString stringWithFormat:@"%ld",[date_number integerValue]];
        
        [array addObject:model];
    }
    
    return array;
}

@end
