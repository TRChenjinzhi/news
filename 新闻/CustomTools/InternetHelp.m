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
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[Login_info share].userInfo_model.user_id]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"avatar",@""]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"name",@"爱我就请打"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"sex",1]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"city",@"朝阳"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"province",@"北京"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"telephone",[[AppConfig sharedInstance] getUserAcount]]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"client_type",2]];//设备类型 1:android 2；ios
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"channel",@"default"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"v1_sign",@"318cb2d3d132cf362e305805ed3ed0ed"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"v1_ver",1001]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"mobileOperator",@"46002"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"mobileOperatorName",@"中国移动"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"deviceid",@"ca9e5c58ef7c9432"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"mac",@"02:00:00:00:00:00"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"imsi",@"460022101154264"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"imei",@"864587029754570"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"net_type",1]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"os_version",@"7.1"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"model",@"A0001"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"brand",@"oneplus"]];
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
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"city",@"朝阳"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"province",@"北京"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"client_type",2]];//设备类型 1:android 2；ios
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"channel",@"default"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"v1_sign",@"318cb2d3d132cf362e305805ed3ed0ed"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"v1_ver",1001]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"mobileOperator",@"46002"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"mobileOperatorName",@"中国移动"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"deviceid",@"ca9e5c58ef7c9432"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"mac",@"02:00:00:00:00:00"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"imsi",@"460022101154264"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"imei",@"864587029754570"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"net_type",1]];//1:wifi
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"os_version",@"7.1"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"model",@"A0001"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"brand",@"oneplus"]];
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
                NSString* tips = dict[@"info"];
                [MBProgressHUD showError:tips];
            }else{
                NSLog(@"微信绑定获取到数据");
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"任务状态更新" object:nil];
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

+(void)SendTaskId:(NSString*)taskId AndType:(NSInteger)type{
    //任务类型  1:提供开宝箱  2：阅读文章 3：分享文章  4:优质评论 5：晒收入 6：参与抽奖任务 7,查看常见问题 8：微信绑定奖励
    
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
//                [MBProgressHUD showError:dict[@"msg"]];
                return;
            }
            
            switch (type) {
                case 1:{//宝箱
                    NSString* coin = dict[@"list"][@"coin"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"InternetHelp_SCNavi_openBox" object:coin];
                    
                    break;
                }
                case 2:{//阅读文章完成
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"阅读文章任务完成" object:[NSNumber numberWithInteger:type]];
                    
                    break;
                }
                case 3:{//分享文章完成
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"分享文章任务完成" object:[NSNumber numberWithInteger:type]];
                    break;
                }
                case 7:{

                    break;
                }
                    
                default:
                    break;
            }
            
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
            [TaskCountHelper share].taskcountModel_array = [[NSArray alloc] initWithArray:array_count];
            
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

@end
