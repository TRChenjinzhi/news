//
//  ChannelName.m
//  新闻
//
//  Created by chenjinzhi on 2017/12/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ChannelName.h"

@implementation ChannelName
/*
 *{"code":200,"msg":"succ","list":[{"id":"1","title":"推荐"},{"id":"2","title":"科技"},{"id":"3","title":"娱乐"},{"id":"4","title":"国际"},{"id":"5","title":"汽车"},{"id":"6","title":"体育"},{"id":"7","title":"社会"},{"id":"8","title":"财经"},{"id":"9","title":"军事"},{"id":"10","title":"健康"},{"id":"11","title":"游戏"},{"id":"12","title":"时尚"}]}
 */
+(NSArray *)JsonToChannel:(NSArray *)array{
    NSMutableArray* array_channel = [[NSMutableArray alloc] init];
    for(int i =0;i<array.count;i++){
        NSDictionary* dic = array[i];
        ChannelName* channel = [[ChannelName alloc] init];
        channel.ID = dic[@"id"];
        channel.title = dic[@"title"];
        
        [array_channel addObject:channel];
    }
    
    return (NSArray*)array_channel;
}

@end
