//
//  IndexOfNews.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "IndexOfNews.h"
#import "ChannelName.h"

@implementation IndexOfNews

static id _instance;
+(instancetype)share{
    if(!_instance){
        _instance = [[IndexOfNews alloc] init];
    }
    return _instance;
}

-(BOOL)isHaveChannel:(NSString*)title{
    for (ChannelName* channelName in self.channel_array) {
        if([channelName.title isEqualToString:title]){
            return YES;
        }
    }
    return NO;
}

@end
