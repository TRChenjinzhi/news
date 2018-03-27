//
//  UrlModel.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UrlModel.h"

@implementation UrlModel
static id _instance;

+(instancetype)Share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

@end
