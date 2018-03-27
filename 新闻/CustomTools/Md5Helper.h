//
//  Md5Helper.h
//  新闻
//
//  Created by chenjinzhi on 2018/2/5.
//  Copyright © 2018年 apple. All rights reserved.
//
/*
 开宝箱任务id
 md5(毫秒时间戳+ "_open_box" + userid);
 阅读文章id
 md5(文章id+ "_read"+ userid);
 分享文章id
 md5(文章id+ "_share"+ userid);
 文章评论id
 md5(文章id+ "_comment"+ userid);
 晒收入id
 md5(毫秒时间戳 + "_share_income"+ userid);
 抽奖id
 md5(抽奖的url + 毫秒时间戳 + userid);
 查看常见问题
 md5("read_faq_" + userid);
 绑定微信
 md5("bind_wechat" + userid);
 */

#import <Foundation/Foundation.h>



@interface Md5Helper : NSObject

+(NSString*)Box_taskId:(NSString*)userId;
+(NSString*)Read_taskId:(NSString*)userId AndNewsId:(NSString*)newsId;
+(NSString*)Share_taskId:(NSString*)userId AndNewsId:(NSString*)newsId;
+(NSString*)Reply_taskId:(NSString*)userId AndNewsId:(NSString*)replyId;
+(NSString*)ShowIncome_taskId:(NSString*)userId;
+(NSString*)Choujiang_taskId:(NSString*)userId AndUrl:(NSString*)url;
+(NSString*)Question_taskId:(NSString*)userId;
+(NSString*)Wechat_taskId:(NSString*)userId;

@end
