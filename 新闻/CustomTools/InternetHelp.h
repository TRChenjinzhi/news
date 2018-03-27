//
//  InternetHelp.h
//  新闻
//
//  Created by chenjinzhi on 2018/2/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InternetHelp : NSObject

+(void)AutoLogin;
+(void)wechat_blindingWithOpenId:(NSString*)OpenId;
+(void)SendTaskId:(NSString*)taskId AndType:(NSInteger)type;
+(void)BaiShi_API:(NSString*)code Sucess:(void(^)(NSDictionary* dic))success Fail:(void(^)(NSDictionary* dic))fail;
+(void)GetMaxTaskCount;

@end
