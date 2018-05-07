//
//  TaskCountHelper.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TaskCountHelper.h"
#import "TaskMaxCout_model.h"
#import "NewUserTask_model.h"
#import "TaskCell_model.h"

@implementation TaskCountHelper{
    NSArray*    m_taskcountModel_array;
    NSArray*    m_task_dayDay_name_array;
    NSArray*    m_task_newUser_name_array;
}

static TaskCountHelper* _instance;
+(instancetype)share{
    if(_instance == nil){
        _instance = [[TaskCountHelper alloc] init];
    }
    return _instance;
}

-(NSArray*)get_task_newUser_name_array{
    return m_task_newUser_name_array;
}
-(NSArray*)get_task_dayDay_name_array{
    return m_task_dayDay_name_array;
}

-(NSArray*)get_taskcountModel_array{
    return m_taskcountModel_array;
}

-(void)setTaskcountModel_array:(NSArray *)taskcountModel_array{
    m_taskcountModel_array = taskcountModel_array;
}

-(void)setTask_newUser_name_array:(NSArray *)task_newUser_name_array{
    m_task_newUser_name_array = task_newUser_name_array;
}
-(void)setTask_dayDay_name_array:(NSArray *)task_dayDay_name_array{
    m_task_dayDay_name_array = task_dayDay_name_array;
}

-(void)DayDayTask_addCountByType:(NSInteger)type{
    for (TaskMaxCout_model* model in m_task_dayDay_name_array) {
        if(model.type == type){
            if(model.maxCout > model.count){
                model.count++;
                break;
            }
        }
    }
}

-(void)initData{
    m_taskcountModel_array = [NSArray array];
    m_task_dayDay_name_array = [NSArray array];
    m_task_newUser_name_array = [NSArray array];
}

-(BOOL)newUserTask_isOver{
    if(m_task_newUser_name_array == nil){
        NSLog(@"没有新手任务信息");
        return NO;
    }
    for (NewUserTask_model* model in m_task_newUser_name_array) {
        if(model.status == 1 || model.count >= model.max){
            //不做处理
        }
        else{
            return NO;
        }
    }
    
    return YES;
}

-(void)newUserTask_addCountByType:(NSInteger)type{
    for (NewUserTask_model* model in m_task_newUser_name_array) {
        if(model.type == type){
            if(model.max == 1){
                model.count = 1;
                model.status = 1;
                break;
            }
            else{
                model.count++;
                if(model.count >= model.max){
                    model.count = model.max;
                    model.count = 1;
                    model.status = 1;
                    break;
                }
            }
        }
    }
}

@end
