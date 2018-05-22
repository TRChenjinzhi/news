//
//  InternetHelp.h
//  新闻
//
//  Created by chenjinzhi on 2018/2/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialWechatHandler.h"

@interface InternetHelp : NSObject

+(void)replyToServer_test:(NSString*)user_id andNewsId:(NSString*)newsId AndComment:(NSString*)comment Sucess:(void (^)(NSDictionary *dic))success Fail:(void (^)(NSDictionary *dic))fail;

+(void)getBanner_Sucess:(void(^)(NSArray* dic))success Fail:(void(^)(NSDictionary* dic))fail;
+(void)replyToOterReplyByUserId:(NSString*)user_id andToUserId:(NSString*)ToUserId andNewsId:(NSString*)newsId AndPid:(NSInteger)Pid AndComment:(NSString*)comment Sucess:(void (^)(NSDictionary *dic))success Fail:(void (^)(NSDictionary *dic))fail;
+(void)replyAllByUserId:(NSString*)user_id AndNewsId:(NSString*)newsId AndPid:(NSInteger)pid AndPage:(NSInteger)page AndSize:(NSInteger)size Sucess:(void (^)(NSDictionary *dic))success Fail:(void (^)(NSDictionary *dic))fail;
+(void)DianzanById:(NSString*)comment_id andUser_id:(NSString*)user_id AndActionType:(NSInteger)type;
+(void)AutoLogin;
+(void)updateUserInfo;
+(void)wechat_blindingWithOpenId:(UMSocialUserInfoResponse*)resp;
+(void)wechat_loginWithOpenId:(NSString*)OpenId;
+(void)SendTaskId:(NSString*)taskId AndType:(NSInteger)type  Sucess:(void(^)(NSInteger type,NSDictionary* dic))success Fail:(void(^)(NSDictionary* dic))fail;
+(void)BaiShi_API:(NSString*)code Sucess:(void(^)(NSDictionary* dic))success Fail:(void(^)(NSDictionary* dic))fail;
+(void)GetMaxTaskCount;
+(void)GetNewUserTaskCount_Sucess:(void(^)(NSDictionary* dic))success Fail:(void(^)(NSDictionary* dic))fail;
+(void)Video_channel_API_Sucess:(void(^)(NSDictionary* dic))success Fail:(void(^)(NSDictionary* dic))fail;
+(void)Video_info_API_channelID:(NSInteger)channel AndPage:(NSInteger)page Sucess:(void(^)(NSDictionary* dic))success Fail:(void(^)(NSDictionary* dic))fail;
+(void)Video_info_API_fromSearch_AndPage:(NSInteger)page AndSearchWord:(NSString*)searchWord Sucess:(void(^)(NSDictionary* dic))success Fail:(void(^)(NSDictionary* dic))fail;
+(void)Video_detail_tuijian_channelID:(NSString*)channel Sucess:(void(^)(NSDictionary* dic))success Fail:(void(^)(NSDictionary* dic))fail;
+(void)ReplyMoneyByType:(NSInteger)type AndMoney:(NSInteger)moneyCount Sucess:(void(^)(NSDictionary* dic))success Fail:(void(^)(NSDictionary* dic))fail;
+(void)choujiang_API_Sucess:(void(^)(NSArray* dic))success Fail:(void(^)(NSArray* dic))fail;

@end
