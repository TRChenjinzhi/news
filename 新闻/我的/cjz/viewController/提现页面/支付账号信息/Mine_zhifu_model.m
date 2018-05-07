//
//  Mine_zhifu_model.m
//  新闻
//
//  Created by chenjinzhi on 2018/4/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_zhifu_model.h"

@implementation Mine_zhifu_model

static Mine_zhifu_model* _instance;
+(instancetype)share{
    if(!_instance){
        _instance = [[Mine_zhifu_model alloc] init];
    }
    
    if(!_instance.isGetDataFromLocal){
        NSDictionary* str = [[AppConfig sharedInstance] getZhifuInfo];
        [Mine_zhifu_model dicToModel:str];
    }
    
    return _instance;
}

-(NSString *)wechat_name{
    if(_wechat_name == nil){
        _wechat_name = [NSString string];
    }
    return _wechat_name;
}

-(NSString *)ali_num{
    if(_ali_num == nil){
        _ali_num = [NSString string];
    }
    return _ali_num;
}

-(NSString *)ali_name{
    if(_ali_name == nil){
        _ali_name = [NSString string];
    }
    return _ali_name;
}

+(NSDictionary*)modelToDic:(Mine_zhifu_model*)model{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:model.wechat_name forKey:@"wechat_name"];
    [dic setObject:model.ali_num forKey:@"ali_num"];
    [dic setObject:model.ali_name forKey:@"ali_name"];
    
    return dic;
}
+(void)dicToModel:(NSDictionary*)dic{
    _instance.isGetDataFromLocal = YES;
    _instance.wechat_name = dic[@"wechat_name"];
    _instance.ali_num = dic[@"ali_num"];
    _instance.ali_name = dic[@"ali_name"];
//    if (str == nil) {
//        return ;
//    }
//    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err;
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                        options:NSJSONReadingMutableContainers
//                                                          error:&err];
//    if(err) {
//        NSLog(@"json解析失败：%@",err);
//        return ;
//    }
    
}

@end
