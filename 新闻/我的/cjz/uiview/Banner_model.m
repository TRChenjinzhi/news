//
//  Banner_model.m
//  橙子快报
//
//  Created by chenjinzhi on 2018/5/18.
//  Copyright © 2018年 apple. All rights reserved.
//
/*
 "id": "2",
 "name": "邀请收徒",
 "ad_url": "http:\/\/ad-manager.b0.upaiyun.com\/ad\/e47b1a4432538a8b629d552183e85b1d.png",
 "url": "http:\/\/younews.3gshow.cn\/api\/shoutu"
 */

#import "Banner_model.h"

@implementation Banner_model

static id _instance;
+(instancetype)share{
    if(!_instance){
        _instance = [Banner_model new];
    }
    return _instance;
}

+(void)arrayToBannerArray:(NSArray*)array{
    [Banner_model share].array = [NSMutableArray array];
    for (NSDictionary* dic in array) {
        [[Banner_model share].array addObject:[Banner_model dicToModel:dic]];
    }
}

+(Banner_model*)dicToModel:(NSDictionary*)dic{
    Banner_model* model = [Banner_model new];
    if([dic containsObjectForKey:@"id"]){
        model.ID        = dic[@"id"];
    }
    if([dic containsObjectForKey:@"name"]){
        model.name        = dic[@"name"];
    }
    if([dic containsObjectForKey:@"ad_url"]){
        model.ad_url        = dic[@"ad_url"];
    }
    if([dic containsObjectForKey:@"url"]){
        model.url        = dic[@"url"];
    }
    
    return model;
}

@end
