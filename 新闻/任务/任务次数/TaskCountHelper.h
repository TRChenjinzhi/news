//
//  TaskCountHelper.h
//  新闻
//
//  Created by chenjinzhi on 2018/3/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskCountHelper : NSObject

@property (nonatomic,strong)NSArray* taskcountModel_array;
@property (nonatomic,strong)NSArray* task_newUser_name_array;
@property (nonatomic,strong)NSArray* task_dayDay_name_array;

+(instancetype)share;

-(NSArray*)get_task_newUser_name_array;
-(NSArray*)get_task_dayDay_name_array;
-(NSArray*)get_taskcountModel_array;

-(void)addCountByType:(NSInteger)type;
-(void)initData;

@end
