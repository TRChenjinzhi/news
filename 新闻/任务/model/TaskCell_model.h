//
//  TaskCell_model.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskMaxCout_model.h"

@interface TaskCell_model : NSObject

@property (nonatomic,strong)NSString* title;
@property (nonatomic,strong)NSString* subTitle;
@property (nonatomic)NSInteger Money;
@property (nonatomic)BOOL   IsYuan;

@property (nonatomic,strong)TaskMaxCout_model* count_model;

@property (nonatomic)BOOL isDone;

@end
