//
//  TaskData.m
//  新闻
//
//  Created by chenjinzhi on 2018/4/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TaskData.h"
#import "TaskCell_model.h"

@implementation TaskData

+(NSMutableArray*)GetNewUserTask_data{
    /*新手任务：
     1. 绑定微信（+50金币）
     2. 查看常见问题（+20金币）
     3. 阅读新闻（0/5）
     4. 观看视频（0/5）
     5. 朋友圈收徒
     */
    NSMutableArray* array = [NSMutableArray array];
    NSArray* title = @[NewUserTask_blindWechat,NewUserTask_readQuestion,NewUserTask_readNews,NewUserTask_readVideo,NewUserTask_shareByPengyouquan];
    NSArray* money = @[@50                    ,@20                     ,@10                 ,@10                  ,@0];
    NSArray* isYuan = @[@0                    ,@0                      ,@0                  ,@0                   ,@0];
    NSArray* isDone = @[@0                    ,@0                      ,@0                  ,@0                   ,@0];
    NSArray* subTitle = @[@"绑定后可直接提现至微信",
                          @"认真阅读平台规则",
                          @"阅读5篇新闻，完成新手任务",
                          @"观看5个视频，完成新手任务",
                          @"分享邀请信息到朋友圈"];
    for(int i=0;i<title.count;i++){
        TaskCell_model* model = [[TaskCell_model alloc] init];
        model.title = title[i];
        NSNumber* number = money[i];
        model.Money = number.integerValue;
        model.subTitle = subTitle[i];
        NSNumber* number1 = isYuan[i];
        if([number1 integerValue] == 1){
            model.IsYuan = YES;
        }else{
            model.IsYuan = NO;
        }
        NSNumber* number2 = isDone[i];
        if([number2 integerValue] == 1){
            model.isDone = YES;
        }else{
            model.isDone = NO;
        }
        
        [array addObject:model];
    }
    
    return array;
}
+(NSMutableArray*)GetDayDayTask_data{
    /*
     日常任务：
     1. 签到
     2. 首次收徒
     3. 收徒
     4. 阅读文章
     5. 分享文章
     6. 观看视频
     7. 优质评论（按点赞数奖励）
     8. 晒收入
     9. 参与抽奖
     10. 摇一摇得金币
     */
    NSMutableArray* array = [NSMutableArray array];
    NSArray* title = @[DayDayTask_FirstShouTu,
                       DayDayTask_ShouTu,
                       DayDayTask_readNews,
                       DayDayTask_shareNews,
                       DayDayTask_readVideo,
                       DayDayTask_GoodReply,
                       DayDayTask_showIncome,
                       DayDayTask_choujiang];
    NSArray* money = @[@3        ,@2    ,@10       ,@10       ,@10      ,@10       ,@20    ,@20];
    NSArray* isYuan = @[@1        ,@1    ,@0        ,@0        ,@0       ,@0        ,@0     ,@0];
    NSArray* isDone = @[@0        ,@0    ,@0        ,@0        ,@0       ,@0        ,@0     ,@0];
    NSArray* subTitle = @[@"首次邀请好友，额外多奖励2元",
                          @"每成功邀请一名好友，奖励2元奖金",
                          @"认真阅读，每篇奖励10金币",
                          @"分享文章给好友，每次奖励10金币",
                          @"观看视频超过30s，每次奖励10金币",
                          @"有见解有趣味的评论会获得额外的奖励",
                          @"晒出自己的收入，每次奖励20金币",
                          @"参与抽奖活动，每次奖励10金币"];
    for(int i=0;i<title.count;i++){
        TaskCell_model* model = [[TaskCell_model alloc] init];
        model.title = title[i];
        NSNumber* number = money[i];
        model.Money = number.integerValue;
        model.subTitle = subTitle[i];
        NSNumber* number1 = isYuan[i];
        if([number1 integerValue] == 1){
            model.IsYuan = YES;
        }else{
            model.IsYuan = NO;
        }
        NSNumber* number2 = isDone[i];
        if([number2 integerValue] == 1){
            model.isDone = YES;
        }else{
            model.isDone = NO;
        }
        
        [array addObject:model];
    }
    
    return array;
}

@end
