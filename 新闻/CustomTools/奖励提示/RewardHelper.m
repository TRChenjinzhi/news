//
//  RewardHelper.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RewardHelper.h"
#import "TabbarViewController.h"
#import "Video_detail_ViewController.h"
#import "Video_channel_ViewController.h"
#import "TaskViewController.h"
#import "TaskMaxCout_model.h"

@implementation RewardHelper

+(void)ShowReward:(NSInteger)type AndSelf:(NSObject*)vc AndCoin:(NSString*)coin{
    //任务类型  1:提供开宝箱  2：阅读文章 3：分享文章  4:优质评论 5：晒收入 6：参与抽奖任务 7,查看常见问题 8：微信绑定奖励 9:登陆奖励
    //    NSNumber* number = noti.object;
    //    NSInteger type = [number integerValue];
    
    [[TaskCountHelper share] DayDayTask_addCountByType:type];//增加完成任务次数
    
    CGFloat reward_width = SCREEN_WIDTH/2;
    UIView* reward_view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-reward_width/2, SCREEN_HEIGHT/2-reward_width/2, reward_width, reward_width)];
    reward_view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];
    [reward_view.layer setCornerRadius:5.0f];
    
    CGFloat img_width = reward_width-kWidth(10)-kWidth(70);
    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(reward_width/2-img_width/2, kWidth(10), img_width, img_width)];
    [img setImage:[UIImage imageNamed:@"toast_finish"]];
    [reward_view addSubview:img];
    
    UILabel* tips = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                              CGRectGetMaxY(img.frame)+kWidth(10),
                                                              reward_width,
                                                              kWidth(16))];
    tips.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    tips.textAlignment = NSTextAlignmentCenter;
    tips.font = kFONT(14);
    [reward_view addSubview:tips];
    
    UILabel* money = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                               CGRectGetMaxY(tips.frame)+kWidth(10),
                                                               reward_width,
                                                               kWidth(24))];
    NSInteger times = [[Login_info share].userInfo_model.login_times integerValue];
    
    money.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    money.textAlignment = NSTextAlignmentCenter;
    money.font = [UIFont boldSystemFontOfSize:kWidth(24)];
    [reward_view addSubview:money];
    
    if(type == Task_Login){
        tips.text = @"登录奖励";
        money.text = [NSString stringWithFormat:@"+%ld",5+5*times];
        TabbarViewController* blok_self = (TabbarViewController*)vc;
        [blok_self.view addSubview:reward_view];
    }
    if(type == Task_video){
        NSArray* model_array = [[TaskCountHelper share] get_task_dayDay_name_array];
        TaskMaxCout_model* model = nil;
        for (TaskMaxCout_model* item in model_array) {
            if(item.type == Task_video){
                model = item;
                if(model.count > model.maxCout){
                    return;
                }
            }
        }
        NSString* str = [NSString stringWithFormat:@"视频奖励 (%ld/%ld)",model.count,model.maxCout];
        NSMutableAttributedString* str_att = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange index_start = [str rangeOfString:@"("];
        NSRange index_end = [str rangeOfString:@"/"];
        str_att = [LabelHelper GetMutableAttributedSting_color:str_att AndIndex:index_start.location+1 AndCount:index_end.location-index_start.location AndColor:RGBA(248, 205, 4, 1)];
        tips.attributedText = str_att;
//        tips.text = @"视频奖励";
        money.text = [NSString stringWithFormat:@"+%@",coin];
        if([vc isKindOfClass:[Video_channel_ViewController class]]){
            Video_channel_ViewController* blok_self = (Video_channel_ViewController*)vc;
            [blok_self.view addSubview:reward_view];
        }
        if([vc isKindOfClass:[Video_detail_ViewController class]]){
            Video_detail_ViewController* blok_self = (Video_detail_ViewController*)vc;
            [blok_self.view addSubview:reward_view];
        }
    }
    if(type == Task_chouJiang){
        NSArray* model_array = [[TaskCountHelper share] get_task_dayDay_name_array];
        TaskMaxCout_model* model = nil;
        for (TaskMaxCout_model* item in model_array) {
            if(item.type == Task_chouJiang){
                model = item;
                if(model.count > model.maxCout){
                    return;
                }
            }
        }
        NSString* str = [NSString stringWithFormat:@"抽奖奖励 (%ld/%ld)",model.count,model.maxCout];
        NSMutableAttributedString* str_att = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange index_start = [str rangeOfString:@"("];
        NSRange index_end = [str rangeOfString:@"/"];
        str_att = [LabelHelper GetMutableAttributedSting_color:str_att AndIndex:index_start.location+1 AndCount:index_end.location-index_start.location AndColor:RGBA(248, 205, 4, 1)];
        tips.attributedText = str_att;
        //        tips.text = @"视频奖励";
        money.text = [NSString stringWithFormat:@"+%@",coin];
        if([vc isKindOfClass:[TaskViewController class]]){
            TaskViewController* blok_self = (TaskViewController*)vc;
            [blok_self.view addSubview:reward_view];
        }
    }
    if(type == Task_showIncome){
        NSArray* model_array = [[TaskCountHelper share] get_task_dayDay_name_array];
        TaskMaxCout_model* model = nil;
        for (TaskMaxCout_model* item in model_array) {
            if(item.type == Task_showIncome){
                model = item;
                if(model.count > model.maxCout){
                    return;
                }
            }
        }
        NSString* str = [NSString stringWithFormat:@"晒收入奖励 (%ld/%ld)",model.count,model.maxCout];
        NSMutableAttributedString* str_att = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange index_start = [str rangeOfString:@"("];
        NSRange index_end = [str rangeOfString:@"/"];
        str_att = [LabelHelper GetMutableAttributedSting_color:str_att AndIndex:index_start.location+1 AndCount:index_end.location-index_start.location AndColor:RGBA(248, 205, 4, 1)];
        tips.attributedText = str_att;
        //        tips.text = @"视频奖励";
        money.text = [NSString stringWithFormat:@"+%@",coin];
        if([vc isKindOfClass:[TaskViewController class]]){
            TaskViewController* blok_self = (TaskViewController*)vc;
            [blok_self.view addSubview:reward_view];
        }
    }
    
    
    [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        reward_view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [reward_view removeFromSuperview];
    }];
}

@end
