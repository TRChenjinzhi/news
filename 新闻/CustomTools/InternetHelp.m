//
//  InternetHelp.m
//  新闻
//
//  Created by chenjinzhi on 2018/2/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "InternetHelp.h"
#import "Login_info.h"
#import "Login_userInfo.h"
#import "TaskMaxCout_model.h"
#import "TaskCountHelper.h"
#import "video_channel_model.h"
#import "Task_reward_model.h"
#import "Mine_zhifu_model.h"

@implementation InternetHelp

#pragma mark - 登陆api
+(void)AutoLogin{
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/member/login"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"{";
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[Login_info share].userInfo_model.user_id]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"telephone",[[AppConfig sharedInstance] getUserAcount]]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":%d",@"client_type",2]];//设备类型 1:android 2；ios
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"imei",IDFA]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"unique_id",(NSString*)[MyKeychain queryDataWithService:MyKeychain_server]]];
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
//    IMP_BLOCK_SELF(Mine_login_ViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error){
                NSLog(@"网络获取失败");
                //发送失败消息
//                [MBProgressHUD showError:@"自动登录失败"];
            }
            
            NSLog(@"从服务器获取到数据");
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            [Login_info dicToModel:dict];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"用户信息更新" object:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"autoLogin-tabbarVC" object:nil];
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

+(void)wechat_blindingWithOpenId:(NSString*)OpenId{
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/member/bind"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[Login_info share].userInfo_model.user_id]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"openid",OpenId]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"avatar",[Login_info share].userInfo_model.avatar]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"name",[Login_info share].userInfo_model.name]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"sex",[[Login_info share].userInfo_model.name intValue]]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"city",@"朝阳"]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"province",@"北京"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"client_type",2]];//设备类型 1:android 2；ios
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"channel",@"default"]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"v1_sign",@"318cb2d3d132cf362e305805ed3ed0ed"]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"v1_ver",1001]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"mobileOperator",@"46002"]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"mobileOperatorName",@"中国移动"]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"deviceid",@"ca9e5c58ef7c9432"]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"mac",@"02:00:00:00:00:00"]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"imsi",@"460022101154264"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"imei",IDFA]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"unique_id",(NSString*)[MyKeychain queryDataWithService:MyKeychain_server]]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"net_type",1]];//1:wifi
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"os_version",@"7.1"]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"model",@"A0001"]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"brand",@"oneplus"]];
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    //    IMP_BLOCK_SELF(Mine_login_ViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error){
                NSLog(@"网络获取失败");
                //发送失败消息
                [MBProgressHUD showError:@"微信绑定失败"];
            }
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* number = dict[@"code"];
            if([number integerValue] != 200){
                NSLog(@"微信绑定获取失败");
                [MyMBProgressHUD ShowMessage:dict[@"info"] ToView:[UIApplication sharedApplication].keyWindow AndTime:1.0f];
                return ;
            }else{
                NSLog(@"微信绑定成功");
//                NSString* tips = dict[@"info"];
                [MBProgressHUD showError:@"微信绑定成功!"];
                NSDictionary* data_dic = dict[@"list"];
                [Login_info share].userMoney_model.wechat_openid        = data_dic[@"openid"];
                [Login_info share].userMoney_model.binding_wechat       = data_dic[@"wechat_binding"];
                [Login_info share].userInfo_model.avatar                = data_dic[@"avatar"];
                
                [[TaskCountHelper share] newUserTask_addCountByType:Task_blindWechat];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"任务状态更新" object:nil];
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

+(void)wechat_loginWithOpenId:(NSString*)OpenId{
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/member/login"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"{";

    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"openid",OpenId]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%ld\"",@"client_type",IOS]];//设备类型 1:android 2；ios
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"imei",IDFA]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"unique_id",(NSString*)[MyKeychain queryDataWithService:MyKeychain_server]]];

    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    //    IMP_BLOCK_SELF(Mine_login_ViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error){
                NSLog(@"网络获取失败");
                //发送失败消息
                [MBProgressHUD showError:@"微信绑定失败"];
            }
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* number = dict[@"code"];
            if([number integerValue] != 200){
                if([number integerValue] == Login_wechat_NotBlind){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginVCL微信未绑定" object:nil];
                    return ;
                }
                NSLog(@"微信绑定获取失败");
                [MyMBProgressHUD ShowMessage:dict[@"info"] ToView:[UIApplication sharedApplication].keyWindow AndTime:1.0f];
                return ;
            }else{
                NSLog(@"微信绑定成功");
                //                NSString* tips = dict[@"info"];
                [Login_info dicToModel:dict];
//                NSDictionary* data_dic = dict[@"list"];
//                [Login_info share].userMoney_model.wechat_openid        = data_dic[@"openid"];
//                [Login_info share].userMoney_model.binding_wechat       = data_dic[@"wechat_binding"];
//                [Login_info share].userInfo_model.avatar                = data_dic[@"avatar"];
                
                [[TaskCountHelper share] newUserTask_addCountByType:Task_blindWechat];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginVCL微信登陆成功" object:nil];
            }
            
            
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

+(void)SendTaskId:(NSString*)taskId AndType:(NSInteger)type  Sucess:(void(^)(NSInteger type,NSDictionary* dic))success Fail:(void(^)(NSDictionary* dic))fail{
    //任务类型  1:提供开宝箱  2：阅读文章 3：分享文章  4:优质评论 5：晒收入 6：参与抽奖任务 7,查看常见问题 8：微信绑定奖励 9.视频任务
    
    //如果不是绑定的手机 则没有金币奖励
    if([[Login_info share].userInfo_model.device_mult_user integerValue] == 1){
        NSLog(@"不能获得奖励");
        return;
    }
    
    //限制发送请求
    if(type != 1){
        for (TaskMaxCout_model* model in [[TaskCountHelper share] get_taskcountModel_array]) {
            if(type == model.type){
                if(model.count == model.maxCout){
                    return;
                }
            }
        }
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/task"]];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[[Login_info share]GetUserInfo].user_id]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%ld\"",@"type",type]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"task_id",taskId]];
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error){
                NSLog(@"SendTaskType网络获取失败");
                //发送失败消息
                //                [MBProgressHUD showError:@"任务提交失败"];
                return ;
            }
            NSLog(@"SendTaskType从服务器获取到数据");
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* number = dict[@"code"];
            NSInteger code = [number integerValue];
            if(code != 200){
                NSLog(@"SendTaskType%@",dict[@"msg"]);
                fail(dict);
//                [MBProgressHUD showError:dict[@"msg"]];
                return;
            }
            
            success(type,dict);
            
//            switch (type) {
//                case 1:{//宝箱
//                    NSString* coin = dict[@"list"][@"reward_coin"];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"InternetHelp_SCNavi_openBox" object:coin];
//
//                    break;
//                }
//                case 2:{//阅读文章完成
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"阅读文章任务完成" object:[NSNumber numberWithInteger:type]];
//
//                    break;
//                }
//                case 3:{//分享文章完成
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"分享文章任务完成" object:[NSNumber numberWithInteger:type]];
//                    break;
//                }
//                case 7:{
//
//                    break;
//                }
//
//                default:
//                    break;
//            }
            
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

+(void)BaiShi_API:(NSString*)code Sucess:(void(^)(NSDictionary* dic))success Fail:(void(^)(NSDictionary* dic))fail{
    //任务类型  1:提供开宝箱  2：阅读文章 3：分享文章  4:优质评论 5：晒收入 6：参与抽奖任务 7,查看常见问题 8：微信绑定奖励
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/member/baishi"]];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[[Login_info share]GetUserInfo].user_id]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"master_code",code]];
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error){
                NSLog(@"BaiShi_API网络获取失败");
                //发送失败消息
                fail(nil);
                return ;
            }
            NSLog(@"BaiShi_API从服务器获取到数据");
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* number = dict[@"code"];
            NSInteger code = [number integerValue];
            if(code != 200){
                fail(dict);
                return;
            }else{
                success(dict);
                
//                [Login_info share].userInfo_model.mastercode = dict[@"list"][@"master_code"];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"拜师_TabBarVCL" object:[NSNumber numberWithInteger:1]];
            }

        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

+(void)GetMaxTaskCount{
    //任务类型  1:提供开宝箱  2：阅读文章 3：分享文章  4:优质评论 5：晒收入 6：参与抽奖任务 7,查看常见问题 8：微信绑定奖励
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/taskStatus"]];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[[Login_info share]GetUserInfo].user_id]];
    //    args = [args stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%ld\"",@"type",type]];
    //    args = [args stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"size",10]];
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    //        IMP_BLOCK_SELF(TaskViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(error){
            NSLog(@"GetMaxTaskCount网络获取失败");
            //发送失败消息
//            [MBProgressHUD showError:@"网络错误"];
            return ;
        }
        NSLog(@"GetMaxTaskCount从服务器获取到数据");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* number = dict[@"code"];
            NSInteger code = [number integerValue];
            if(code != 200){
                return;
            }
            NSArray* array_count = [TaskMaxCout_model dicToArray:dict];
            [TaskCountHelper share].task_dayDay_name_array = [[NSArray alloc] initWithArray:array_count];
            
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

+(void)GetNewUserTaskCount_Sucess:(void(^)(NSDictionary* dic))success Fail:(void(^)(NSDictionary* dic))fail{
    //http://younews.3gshow.cn/api/newbie?json={"user_id":"379860b6a0338a82250f341959b0b9a4"}
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/newbie"]];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"";
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init]; //用json传值 ：\n 加密就不会去掉换行符
    [dic setValue:[Login_info share].userInfo_model.user_id forKey:@"user_id"];

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:NULL];
    NSString* str_tmp = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    argument = [MyEntrypt MakeEntryption:str_tmp];
    
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error){
                NSLog(@"GetNewUserTaskCount_Sucess网络获取失败");
                //发送失败消息
                fail(nil);
                return ;
            }
            NSLog(@"GetNewUserTaskCount_Sucess从服务器获取到数据");
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* number = dict[@"code"];
            NSInteger code = [number integerValue];
            if(code != 200){
                fail(dict);
                return;
            }else{
                success(dict);
            }
            
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

+(void)Video_channel_API_Sucess:(void(^)(NSDictionary* dic))success Fail:(void(^)(NSDictionary* dic))fail{
    //http://younews.3gshow.cn/api/getVChannel?json={"user_id":"xxxxxx"}
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/getVChannel"]];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error){
                NSLog(@"Video_API网络获取失败");
                //发送失败消息
                fail(nil);
                return ;
            }
            NSLog(@"Video_API从服务器获取到数据");
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* number = dict[@"code"];
            NSInteger code = [number integerValue];
            if(code != 200){
                fail(dict);
                return;
            }else{
                success(dict);
            }
            
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

+(void)Video_info_API_channelID:(NSInteger)channel AndPage:(NSInteger)page Sucess:(void(^)(NSDictionary* dic))success Fail:(void(^)(NSDictionary* dic))fail{
    // http://younews.3gshow.cn/api/getVideo?json={"user_id":"xxxxxxxxxx","channel":1,"page":0,"size":10,"action":2} "action":1, // 动作  1：上滑   2：下拉
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/getVideo"]];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"";
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init]; //用json传值 ：\n 加密就不会去掉换行符
    [dic setValue:[Login_info share].userInfo_model.user_id forKey:@"user_id"];
    [dic setValue:[NSNumber numberWithInteger:channel] forKey:@"channel"];
    [dic setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [dic setValue:[NSNumber numberWithInteger:10] forKey:@"size"];
    
    NSNumber* action = nil;
    if(page == 0){
        action = [NSNumber numberWithInteger:1];
    }else{
        action = [NSNumber numberWithInteger:2];
    }
    [dic setValue:action forKey:@"action"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:NULL];
    NSString* str_tmp = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    argument = [MyEntrypt MakeEntryption:str_tmp];
    
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error){
                NSLog(@"Video_info_API_channelID网络获取失败");
                //发送失败消息
                fail(nil);
                return ;
            }
            NSLog(@"Video_info_API_channelID从服务器获取到数据");
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* number = dict[@"code"];
            NSInteger code = [number integerValue];
            if(code != 200){
                fail(dict);
                return;
            }else{
                success(dict);
            }
            
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

+(void)Video_info_API_fromSearch_AndPage:(NSInteger)page AndSearchWord:(NSString*)searchWord Sucess:(void(^)(NSDictionary* dic))success Fail:(void(^)(NSDictionary* dic))fail{
    //request 正式环境 http://younews.3gshow.cn/api/getVSearch?json={"user_id":"xxxxxx","page":0,"size":10,"keyword":"春"}
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/getVSearch"]];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"";
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init]; //用json传值 ：\n 加密就不会去掉换行符
    [dic setValue:[Login_info share].userInfo_model.user_id forKey:@"user_id"];
    [dic setValue:searchWord forKey:@"keyword"];
    [dic setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [dic setValue:[NSNumber numberWithInteger:10] forKey:@"size"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:NULL];
    NSString* str_tmp = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    argument = [MyEntrypt MakeEntryption:str_tmp];
    
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error){
                NSLog(@"Video_info_API_channelID网络获取失败");
                //发送失败消息
                fail(nil);
                return ;
            }
            NSLog(@"Video_info_API_channelID从服务器获取到数据");
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* number = dict[@"code"];
            NSInteger code = [number integerValue];
            if(code != 200){
                fail(dict);
                return;
            }else{
                success(dict);
            }
            
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

+(void)Video_detail_tuijian_channelID:(NSString*)channel Sucess:(void(^)(NSDictionary* dic))success Fail:(void(^)(NSDictionary* dic))fail{
    //http://younews.3gshow.cn/api/getRelateVideo?json={"user_id":"xxxxxxxxxx","channel":23,"page":0,"size":5}
    //http://younews.3gshow.cn/api/getRelateVideo
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/getRelateVideo"]];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"";
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init]; //用json传值 ：\n 加密就不会去掉换行符
    [dic setValue:[Login_info share].userInfo_model.user_id forKey:@"user_id"];
    [dic setValue:[NSNumber numberWithInteger:[channel integerValue]] forKey:@"channel"];
    [dic setValue:[NSNumber numberWithInteger:0] forKey:@"page"];
    [dic setValue:[NSNumber numberWithInteger:5] forKey:@"size"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:NULL];
    NSString* str_tmp = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    argument = [MyEntrypt MakeEntryption:str_tmp];
    
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error){
                NSLog(@"Video_detail_tuijian_channelID网络获取失败");
                //发送失败消息
                fail(nil);
                return ;
            }
            NSLog(@"Video_detail_tuijian_channelID从服务器获取到数据");
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* number = dict[@"code"];
            NSInteger code = [number integerValue];
            if(code != 200){
                fail(dict);
                return;
            }else{
                success(dict);
            }
            
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

+(void)ReplyMoneyByType:(NSInteger)type AndMoney:(NSInteger)moneyCount Sucess:(void (^)(NSDictionary *))success Fail:(void (^)(NSDictionary *))fail{
    //提现方式 1：微信 2：支付宝 3： 话费提现
    //http://younews.3gshow.cn/member/withDraw?json={"user_id":"814B08C64ADD12284CA82BA39384B177","account_num":"13241690070","account_name":"义","money":"20","binding_alipay":"0"}
//    http://younews.3gshow.cn/member/withDraw?json={"user_id":"814B08C64ADD12284CA82BA39384B177","wechat_openid":"*********","wechat_name":"","money":"20","binding_wechat":"0"}
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/member/withDraw"]];
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://dev.3gshow.cn/member/withDraw"]];//测试域名
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"";
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init]; //用json传值 ：\n 加密就不会去掉换行符
    if(type == wechat){
        [dic setValue:[NSNumber numberWithInteger:1] forKey:@"type"];
        if([Login_info share].userMoney_model.wechat_name.length > 0){
            [dic setValue:[Login_info share].userInfo_model.user_id forKey:@"user_id"];
            [dic setValue:[Login_info share].userMoney_model.wechat_name forKey:@"wechat_name"];
            [dic setValue:[Login_info share].userMoney_model.wechat_openid forKey:@"wechat_openid"];
            [dic setValue:[Login_info share].userMoney_model.binding_wechat forKey:@"binding_wechat"];
        }
        else{
            [dic setValue:[Login_info share].userInfo_model.user_id forKey:@"user_id"];
            [dic setValue:[Mine_zhifu_model share].wechat_name forKey:@"wechat_name"];
            [dic setValue:[Login_info share].userMoney_model.wechat_openid forKey:@"wechat_openid"];
            [dic setValue:[Login_info share].userMoney_model.binding_wechat forKey:@"binding_wechat"];
        }
    }
    else if(type == ali){
        [dic setValue:[NSNumber numberWithInteger:2] forKey:@"type"];
        if([[Login_info share].userMoney_model.binding_alipay integerValue] == 1){
            [dic setValue:[Login_info share].userInfo_model.user_id forKey:@"user_id"];
            [dic setValue:[Login_info share].userMoney_model.alipay_name forKey:@"account_name"];
            [dic setValue:[Login_info share].userMoney_model.alipay_num forKey:@"account_num"];
            [dic setValue:[Login_info share].userMoney_model.binding_alipay forKey:@"binding_alipay"];
        }
        else{
            [dic setValue:[Login_info share].userInfo_model.user_id forKey:@"user_id"];
            [dic setValue:[Mine_zhifu_model share].ali_name forKey:@"account_name"];
            [dic setValue:[Mine_zhifu_model share].ali_num forKey:@"account_num"];
            [dic setValue:[Login_info share].userMoney_model.binding_alipay forKey:@"binding_alipay"];
        }
    }
    [dic setValue:[NSNumber numberWithInteger:moneyCount] forKey:@"money"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:NULL];
    NSString* str_tmp = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    argument = [MyEntrypt MakeEntryption:str_tmp];
    
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error){
                NSLog(@"Video_detail_tuijian_channelID网络获取失败");
                //发送失败消息
                fail(nil);
                return ;
            }
            NSLog(@"Video_detail_tuijian_channelID从服务器获取到数据");
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSNumber* number = dict[@"code"];
            NSInteger code = [number integerValue];
            if(code != 200){
                fail(dict);
                return;
            }else{
                success(dict);
            }
            
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

+(void)choujiang_API_Sucess:(void (^)(NSArray *))success Fail:(void (^)(NSArray *))fail{
    //http://younews.3gshow.cn/interface/iosClick
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/interface/iosClick"]];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];

    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error){
                NSLog(@"choujiang网络获取失败");
                //发送失败消息
                fail(nil);
                return ;
            }
            NSLog(@"choujiang从服务器获取到数据");
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSArray* array = (NSArray*)jsonObject;
            if(array == nil){
                fail(array);
                return;
            }
            else if(array.count == 0){
                fail(array);
                return;
            }
            else{
                success(array);
            }
            
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

@end
