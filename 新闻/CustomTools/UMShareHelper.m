//
//  UMShareHelper.m
//  新闻
//
//  Created by chenjinzhi on 2018/2/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UMShareHelper.h"
#import "Task_reward_model.h"
#import "NewUserTask_model.h"

@implementation UMShareHelper

static id _instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

//网页分享-新闻
+(void)ShareNews:(NSString *)name AndModel:(CJZdataModel*)model AndImg:(UIImage*)img{
    UMShareHelper* shareHelper = [UMShareHelper sharedInstance];
    if([name isEqualToString:WeChat_haoyou]){
        [shareHelper shareWebPageToPlatformType:UMSocialPlatformType_WechatSession AndModel:model AndImg:img];
    }
    if([name isEqualToString:WeChat_pengyoujuan]){
        [shareHelper shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine AndModel:model AndImg:img];
    }
    if([name isEqualToString:QQ_haoyou]){
        [shareHelper shareWebPageToPlatformType:UMSocialPlatformType_QQ AndModel:model AndImg:img];
    }
    if([name isEqualToString:QQ_kongjian]){
        [shareHelper shareWebPageToPlatformType:UMSocialPlatformType_Qzone AndModel:model AndImg:img];
    }
}

//视频分享
+(void)ShareVideo:(NSString *)name AndModel:(video_info_model*)model{
    UMShareHelper* shareHelper = [UMShareHelper sharedInstance];
    if([name isEqualToString:WeChat_haoyou]){
        [shareHelper shareVedioToPlatformType:UMSocialPlatformType_WechatSession AndModel:model];
    }
    if([name isEqualToString:WeChat_pengyoujuan]){
        [shareHelper shareVedioToPlatformType:UMSocialPlatformType_WechatTimeLine AndModel:model];
    }
    if([name isEqualToString:QQ_haoyou]){
        [shareHelper shareVedioToPlatformType:UMSocialPlatformType_QQ AndModel:model];
    }
    if([name isEqualToString:QQ_kongjian]){
        [shareHelper shareVedioToPlatformType:UMSocialPlatformType_Qzone AndModel:model];
    }
}

//图片分享
+(void)SharePNGByName:(NSString *)name AndImg:(UIImage *)img{
    UMShareHelper* shareHelper = [UMShareHelper sharedInstance];
    if([name isEqualToString:WeChat_haoyou]){
        [shareHelper shareImageToPlatformType:UMSocialPlatformType_WechatSession img:img];
    }
    if([name isEqualToString:WeChat_pengyoujuan]){
        [shareHelper shareImageToPlatformType:UMSocialPlatformType_WechatTimeLine img:img];
    }
    if([name isEqualToString:QQ_haoyou]){
        [shareHelper shareImageToPlatformType:UMSocialPlatformType_QQ img:img];
    }
    if([name isEqualToString:QQ_kongjian]){
        [shareHelper shareImageToPlatformType:UMSocialPlatformType_Qzone img:img];
    }
}

//网页分享 自带分享信息
+(void)ShareName:(NSString*)name{
    UMShareHelper* shareHelper = [UMShareHelper sharedInstance];
    if([name isEqualToString:WeChat_haoyou]){
        [shareHelper shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
    }
    if([name isEqualToString:WeChat_pengyoujuan]){
        [shareHelper shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
    }
    if([name isEqualToString:QQ_haoyou]){
        [shareHelper shareWebPageToPlatformType:UMSocialPlatformType_QQ];
    }
    if([name isEqualToString:QQ_kongjian]){
        [shareHelper shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
    }
}

+(void)LoginWechat:(NSString *)name{
    UMShareHelper* shareHelper = [UMShareHelper sharedInstance];
    if([name isEqualToString:NewUserTask_blindWechat]){
        [shareHelper getAuthWithUserInfoFromWechat];
    }
    if([name isEqualToString:Login_wechat]){
        [shareHelper getAuthWithUserInfoFromWechat];
    }
}

//
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType AndModel:(CJZdataModel*)model AndImg:(UIImage*)img
{
    //http://toutiao.3gshow.cn/kl.php?id=472041&t=2&m=share&user_id=xxxxxxxxx
    //http://toutiao.3gshow.cn/kl.php?id=476088&t=2 --url
    //wechat、firends、QQ、Qzone、link、others
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    NSString* descr = @"";
    if([model.decr isEqualToString:@""]){
        descr = model.title;
    }else{
        descr = model.decr;
    }
    NSString* url = @"";
    switch (platformType) {
        case UMSocialPlatformType_WechatSession:
            url = [NSString stringWithFormat:@"%@?t=2&m=share&source=wechat",model.url];
            break;
        case UMSocialPlatformType_WechatTimeLine:
            url = [NSString stringWithFormat:@"%@?t=2&m=share&source=firends",model.url];
            break;
        case UMSocialPlatformType_QQ:
            url = [NSString stringWithFormat:@"%@?t=2&m=share&source=QQ",model.url];
            break;
        case UMSocialPlatformType_Qzone:
            url = [NSString stringWithFormat:@"%@?t=2&m=share&source=Qzone",model.url];
            break;
            
        default:
            break;
    }
    //创建网页内容对象
//    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:model.title descr:descr thumImage:img];
    //设置网页地址
    shareObject.webpageUrl = url;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                
                NSString* taskId = [Md5Helper Share_taskId:[Login_info share].userInfo_model.user_id AndNewsId:model.ID];
                
                if([Task_DetailWeb_model share].isOver){//只有完成了阅读奖励的条件才能分享文章
                    if([[TaskCountHelper share] TaskIsOverByType:Task_shareNews]){ //当任务次数已经完成后 不再提交任务
                        return ;
                    }
                    [InternetHelp SendTaskId:taskId AndType:Task_shareNews Sucess:^(NSInteger type, NSDictionary *dic) {
                        Task_reward_model* model = [Task_reward_model new];
                        model.type = type;
                        model.coin = dic[@"list"][@"reward_coin"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"分享文章任务完成" object:model];
                    } Fail:^(NSDictionary *dic) {
                        NSLog(@"分享新闻上传失败");
                    }];
                }
                
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    Login_shareInfo* shareInfo = [Login_info share].shareInfo_model;
    UIImage* img = [UIImage imageNamed:@"AppIcon"];
    
    //创建网页内容对象
    //    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    NSString* url = @"";
    UMShareWebpageObject *shareObject = nil;
    switch (platformType) {
        case UMSocialPlatformType_WechatSession:
            url = [NSString stringWithFormat:@"%@?t=2&m=share&user_id=%@&source=wechat",shareInfo.url,[Login_info share].userInfo_model.user_id];
            shareObject = [UMShareWebpageObject shareObjectWithTitle:shareInfo.title descr:shareInfo.desc thumImage:img];
            break;
        case UMSocialPlatformType_WechatTimeLine:
            url = [NSString stringWithFormat:@"%@?t=2&m=share&user_id=%@&source=firends",shareInfo.url,[Login_info share].userInfo_model.user_id];
            shareObject = [UMShareWebpageObject shareObjectWithTitle:shareInfo.desc descr:@"" thumImage:img];
            break;
        case UMSocialPlatformType_QQ:
            url = [NSString stringWithFormat:@"%@?t=2&m=share&user_id=%@&source=QQ",shareInfo.url,[Login_info share].userInfo_model.user_id];
            shareObject = [UMShareWebpageObject shareObjectWithTitle:shareInfo.title descr:shareInfo.desc thumImage:img];
            break;
        case UMSocialPlatformType_Qzone:
            url = [NSString stringWithFormat:@"%@?t=2&m=share&user_id=%@&source=Qzone",shareInfo.url,[Login_info share].userInfo_model.user_id];
            shareObject = [UMShareWebpageObject shareObjectWithTitle:shareInfo.title descr:shareInfo.desc thumImage:img];
            break;
            
        default:
            break;
    }

    //设置网页地址
    shareObject.webpageUrl = url;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                if(platformType == UMSocialPlatformType_WechatTimeLine){
                        if([[Login_info share].userInfo_model.device_mult_user integerValue] == NotTheDevice){
//                            [MyMBProgressHUD ShowMessage:@"非绑定设备，不能执行任务" ToView:self.view AndTime:1.0f];
                            return;
                        }
                    
                    NSString* taskId = [Md5Helper wechatShareFriend_task:[Login_info share].userInfo_model.user_id];
                    [InternetHelp SendTaskId:taskId AndType:Task_apprenitceByPengyouquan Sucess:^(NSInteger type, NSDictionary *dic) {
                        [[TaskCountHelper share] newUserTask_addCountByType:Task_apprenitceByPengyouquan];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"任务状态更新" object:nil];
                    } Fail:^(NSDictionary *dic) {
                        //当分享朋友圈任务没有完成时
                        NewUserTask_model* model = nil;
                        for (NewUserTask_model* item in [TaskCountHelper share].task_newUser_name_array) {
                            if(item.type == Task_apprenitceByPengyouquan){
                                model = item;
                                break;
                            }
                        }
                        if(model.status == 0){
                            [MyMBProgressHUD ShowMessage:@"朋友圈任务上传失败!" ToView:[UIApplication sharedApplication].keyWindow AndTime:1.0f];
                        }
                    }];
                }
                
//                NSString* taskId = [Md5Helper Share_taskId:[Login_info share].userInfo_model.user_id AndNewsId:model.ID];
//                [InternetHelp SendTaskId:taskId AndType:3];
                
//                UMSocialShareResponse *resp = data;
                //分享结果消息
//                UMSocialLogInfo(@"response message is %@",resp.message);
//                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
//                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
//                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

//登陆信息
- (void)getAuthWithUserInfoFromWechat
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"微信绑定失败");
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            if([Login_info share].isLogined){
                Login_userInfo* model = [Login_info share].userInfo_model;
                model.avatar = resp.iconurl;
                model.name = resp.name;
                if([resp.unionGender isEqualToString:@"男"]){
                    model.sex = @"1";
                }else{
                    model.sex = @"2";
                }
                model.wechat_binding = @"1";
                [Login_info share].userInfo_model = model;
                
                [InternetHelp wechat_blindingWithOpenId:resp.openid];
            }
            else{
                //微信登陆
                Login_userInfo* model = [[Login_userInfo alloc] init];
                model.avatar = resp.iconurl;
                model.name = resp.name;
                if([resp.unionGender isEqualToString:@"男"]){
                    model.sex = @"1";
                }else{
                    model.sex = @"2";
                }
                [Login_info share].userInfo_model = model;
                [InternetHelp wechat_loginWithOpenId:resp.openid];
            }
            
            
        }
    }];
}

//分享图片
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType img:(UIImage*)imge
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = imge;
    [shareObject setShareImage:imge];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
            //晒收入 分享成功
            switch (platformType) {
                case UMSocialPlatformType_WechatSession://微信好友
                    
                    break;
                case UMSocialPlatformType_WechatTimeLine://朋友圈
                    
                    break;
                case UMSocialPlatformType_QQ://qq好友
                    
                    break;
                case UMSocialPlatformType_Qzone://qq空间
                    
                    break;
                    
                default:
                    break;
            }
            
            //任务类型  1:提供开宝箱  2：阅读文章 3：分享文章  4:优质评论 5：晒收入 6：参与抽奖任务 7,查看常见问题 8：微信绑定奖励
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UMShareHelper-TaskViewController-晒收入分享完成" object:[NSNumber numberWithInteger:Task_showIncome]];
        }
    }];
}

- (void)shareVedioToPlatformType:(UMSocialPlatformType)platformType AndModel:(video_info_model*)model
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建视频内容对象
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.cover]];
    UIImage *image = [UIImage imageWithData:data];
    UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:model.title descr:@"" thumImage:image];
    //设置视频网页播放地址
    NSString* url = @"";
    switch (platformType) {
        case UMSocialPlatformType_WechatSession:
            url = [NSString stringWithFormat:@"%@?t=2&m=share&user_id=%@&source=wechat",model.url,[Login_info share].userInfo_model.user_id];
            break;
        case UMSocialPlatformType_WechatTimeLine:
            url = [NSString stringWithFormat:@"%@?t=2&m=share&user_id=%@&source=firends",model.url,[Login_info share].userInfo_model.user_id];
            break;
        case UMSocialPlatformType_QQ:
            url = [NSString stringWithFormat:@"%@?t=2&m=share&user_id=%@&source=QQ",model.url,[Login_info share].userInfo_model.user_id];
            break;
        case UMSocialPlatformType_Qzone:
            url = [NSString stringWithFormat:@"%@?t=2&m=share&user_id=%@&source=Qzone",model.url,[Login_info share].userInfo_model.user_id];
            break;
            
        default:
            break;
    }
    shareObject.videoUrl = model.url;
    //            shareObject.videoStreamUrl = @"这里设置视频数据流地址（如果有的话，而且也要看所分享的平台支不支持）";
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"视频分享成功" object:nil];
        }
    }];
}


@end
