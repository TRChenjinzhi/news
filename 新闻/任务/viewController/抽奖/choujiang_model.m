//
//  choujiang_model.m
//  新闻
//
//  Created by chenjinzhi on 2018/4/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "choujiang_model.h"

@implementation choujiang_model

+(NSArray *)dicToArray:(NSArray *)array{
    NSMutableArray* tmp = [NSMutableArray array];
    for (NSDictionary* dic in array) {
        choujiang_model* model = [[choujiang_model alloc] init];
        model.ID        = [JsonHelper JsonToObject_ToStringByInterger:dic[@"id"]];
        model.number    = [JsonHelper JsonToObject_ToStringByInterger:dic[@"number"]];
        model.url       = [JsonHelper JsonToObject_ToStringByInterger:dic[@"url"]];
        model.keyword   = [JsonHelper JsonToObject_ToStringByInterger:dic[@"keyword"]];
        
        [tmp addObject:model];
    }
    
    return tmp;
}

@end
