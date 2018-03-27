//
//  reply_model.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "reply_model.h"

@implementation reply_model

+(NSArray *)dicToArray:(NSDictionary *)dic{
    NSMutableArray* array_model = [[NSMutableArray alloc] init];
    NSArray* array = dic[@"list"];
    for (NSDictionary* item_dic in array) {
        reply_model* model = [[reply_model alloc]init];
        model.ID = item_dic[@"id"];
        model.user_name = item_dic[@"user_name"];
        model.user_icon = item_dic[@"user_icon"];
        model.comment = item_dic[@"comment"];
        model.thumbs_num = item_dic[@"thumbs_num"];
        model.ctime = item_dic[@"ctime"];
        
        [array_model addObject:model];
    }
    
    return array_model;
}

@end
