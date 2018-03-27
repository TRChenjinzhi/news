//
//  Task_DetailWeb_model.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Task_DetailWeb_model.h"

@implementation Task_DetailWeb_model

static id _instance;
+(instancetype)share{
    if(!_instance){
        _instance = [[Task_DetailWeb_model alloc] init];
    }
    return _instance;
}

-(void)initData{
    self.newsId = @"";
    self.isOver = NO;
}

@end
