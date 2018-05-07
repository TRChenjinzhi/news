//
//  videl_channel_model.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/28.
//  Copyright © 2018年 apple. All rights reserved.
//
//{"code":200,"msg":"succ","list":[{"id":"23","title":"推荐"},{"id":"24","title":"影视"},{"id":"25","title":"搞笑"},{"id":"26","title":"音乐"},{"id":"27","title":"小品"},{"id":"28","title":"娱乐"},{"id":"29","title":"社会"},{"id":"30","title":"猎奇"},{"id":"31","title":"游戏"},{"id":"32","title":"呆萌"}]}
#import "video_channel_model.h"

@implementation video_channel_model

+(NSArray*)dicToArray:(NSDictionary*)dic{
    NSMutableArray* array = [NSMutableArray array];
    NSArray* tmp = dic[@"list"];
    for (NSDictionary* dic_item in tmp) {
        video_channel_model* model = [[video_channel_model alloc] init];
        model.title = dic_item[@"title"];
        model.channel_id = dic_item[@"id"];
        
        [array addObject:model];
    }
    
    return array;
}

@end
