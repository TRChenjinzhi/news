//
//  Md5Helper.m
//  新闻
//
//  Created by chenjinzhi on 2018/2/5.
//  Copyright © 2018年 apple. All rights reserved.
//\

/*

 */

#import "Md5Helper.h"
#import <CommonCrypto/CommonDigest.h>

#define str_box @"_open_box"
#define str_read @"_read"
#define str_share @"_share"
#define str_reply @"_comment"
#define str_showIncome @"_share_income"
#define str_question @"read_faq_"
#define str_wechat @"bind_wechat"
@implementation Md5Helper

+(NSString*)Box_taskId:(NSString*)userId{
//    开宝箱任务id
//    md5(毫秒时间戳+ "_open_box" + userid);
    long long seconds = [[NSDate date] timeIntervalSince1970] * 1000;
    return [Md5Helper md5:[NSString stringWithFormat:@"%lld%@%@",seconds,str_box,userId]];
}
+(NSString*)Read_taskId:(NSString*)userId AndNewsId:(NSString*)newsId{
//    阅读文章id
//    md5(文章id+ "_read"+ userid);
    return [Md5Helper md5:[NSString stringWithFormat:@"%@%@%@",newsId,str_read,userId]];
}
+(NSString*)Share_taskId:(NSString*)userId AndNewsId:(NSString*)newsId{
//    分享文章id
//    md5(文章id+ "_share"+ userid);
    return [Md5Helper md5:[NSString stringWithFormat:@"%@%@%@",newsId,str_share,userId]];
}
+(NSString*)Reply_taskId:(NSString*)userId AndNewsId:(NSString*)replyId{
//    文章评论id
//    md5(文章id+ "_comment"+ userid);
    return [Md5Helper md5:[NSString stringWithFormat:@"%@%@%@",replyId,str_reply,userId]];
}
+(NSString*)ShowIncome_taskId:(NSString*)userId{
//    晒收入id
//    md5(毫秒时间戳 + "_share_income"+ userid);
    long long seconds = [[NSDate date] timeIntervalSince1970] * 1000;
    return [Md5Helper md5:[NSString stringWithFormat:@"%lld%@%@",seconds,str_showIncome,userId]];
}
+(NSString*)Choujiang_taskId:(NSString*)userId AndUrl:(NSString*)url{
//    抽奖id
//    md5(抽奖的url + 毫秒时间戳 + userid);
    long long seconds = [[NSDate date] timeIntervalSince1970] * 1000;
    return [Md5Helper md5:[NSString stringWithFormat:@"%@%lld%@",url,seconds,userId]];
}
+(NSString*)Question_taskId:(NSString*)userId{
//    查看常见问题
//    md5("read_faq_" + userid);
    return [Md5Helper md5:[NSString stringWithFormat:@"%@%@",str_question,userId]];
}
+(NSString*)Wechat_taskId:(NSString*)userId{
//    绑定微信
//    md5("bind_wechat" + userid);
    return [Md5Helper md5:[NSString stringWithFormat:@"%@%@",str_wechat,userId]];
}

+ (NSString *)md5:(NSString *)string{
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    
    return result;
}

@end
