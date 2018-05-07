//
//  video_info_model.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/28.
//  Copyright © 2018年 apple. All rights reserved.
//
/*
 "list": [{
 "id": "440",
 "type": "23",
 "title": "戒烟老是半途而废？试试这个新方法，以后再也不想抽烟了",
 "cover": "http://publish-pic-cpu.baidu.com/dbf8e335-8ecd-4f0f-8f98-0674d3a5e6d6.jpeg@w_720,h_403",
 "url": "http://vd3.bdstatic.com/mda-ianyftfn5gdbktw9/mda-ianyftfn5gdbktw9.mp4?playlist=["hd ","sc "]",
 "source": "咕噜菇凉",
 "author": "咕噜菇凉",
 "duration": "70",
 "play_count": "36071",
 "publish_time": "2018-01-28 12:45:59"
 }
 */
#import "video_info_model.h"

@implementation video_info_model

+(NSArray*)dicToArray:(NSDictionary*)dic{
    NSMutableArray* array = [NSMutableArray array];
    NSArray* array_tmp = dic[@"list"];
    for (NSDictionary* dic_item in array_tmp) {
        video_info_model* model = [[video_info_model alloc] init];
        model.ID = dic_item[@"id"];
        model.channel = dic_item[@"channel"];
        model.title = dic_item[@"title"];
        model.avatar = dic_item[@"avatar"];
        model.cover = dic_item[@"cover"];
        model.url = dic_item[@"url"];
        model.source = dic_item[@"source"];
        model.author = dic_item[@"author"];
        model.duration = dic_item[@"duration"];
        model.play_count = dic_item[@"play_count"];
        model.time = dic_item[@"publish_time"];
        
        [array addObject:model];
    }
    
    return array;
}

+(NSArray*)collectData_ToArray:(NSArray*)array{
    NSMutableArray* array_tmp = [NSMutableArray array];
    for (NSDictionary* dic_item in array) {
        if([dic_item objectForKey:@"images"]){
            CJZdataModel* model = [[CJZdataModel alloc]init];
            model.ID = dic_item[@"id"];
            model.title = dic_item[@"title"];
            model.channel = dic_item[@"channel"];
            model.images = dic_item[@"images"];
            
            NSNumber* number = [[TimeHelper share] getCurrentTime_number];
            NSString* time = [NSString stringWithFormat:@"%ld",[number longValue]];
            model.publish_time = [[TimeHelper share] GetDateFromString_yyMMDD_HHMMSS:time];
            
            model.source = dic_item[@"source"];
            model.url = dic_item[@"url"];
            model.url = [model.url stringByAppendingString:@"&t=2"]; //加 &t=2 区别收到的新闻为ios端
            model.comment_num = dic_item[@"comment_num"];
            model.collect_count = dic_item[@"collect_count"];
            
            [array_tmp addObject:model];
        }else{
            video_info_model* model = [[video_info_model alloc] init];
            model.ID = dic_item[@"id"];
            model.channel = dic_item[@"channel"];
            model.title = dic_item[@"title"];
            model.avatar = dic_item[@"avatar"];
            model.cover = dic_item[@"cover"];
            model.url = dic_item[@"url"];
            model.source = dic_item[@"source"];
            model.author = dic_item[@"author"];
            model.duration = dic_item[@"duration"];
            model.play_count = dic_item[@"play_count"];
            model.time = dic_item[@"publish_time"];
            
            [array_tmp addObject:model];
        }
    }
    
    return array_tmp;
}

+(NSMutableArray *)get50VideosFromArray:(NSMutableArray *)array{
    NSMutableArray* total = [NSMutableArray array];
    for (video_info_model* model in array) {
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        [dic setValue:model.ID forKey:@"id"];
        [dic setValue:model.channel forKey:@"channel"];
        [dic setValue:model.title forKey:@"title"];
        [dic setValue:model.avatar forKey:@"avatar"];
        [dic setValue:model.cover forKey:@"cover"];
        [dic setValue:model.url forKey:@"url"];
        [dic setValue:model.source forKey:@"source"];
        [dic setValue:model.author forKey:@"author"];
        [dic setValue:model.duration forKey:@"duration"];
        [dic setValue:model.play_count forKey:@"play_count"];
        [dic setValue:model.time forKey:@"publish_time"];
        
        if(total.count < 50){
            [total addObject:dic];
        }
    }
    
    return total;
    
}

@end
