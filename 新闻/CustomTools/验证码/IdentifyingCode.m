//
//  IdentifyingCode.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "IdentifyingCode.h"
#import <BmobMessageSDK/Bmob.h>

@implementation IdentifyingCode

static id _instance;

+(instancetype)ShareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

+(void)Register:(NSString *)AppKey{
    [Bmob registerWithAppKey:AppKey];
}

-(void)GetIdentifyingCode:(NSString *)PhoneNumber{
    //请求验证码
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:PhoneNumber andTemplate:@"手机注册验证码" resultBlock:^(int msgId, NSError *error) {
        if (error) {
//            self.smsIdTf.text = error.description;
            NSLog(@"%@",error);
            [self.delegate GetIdentifyingCode_failed];
        } else {
            //获得smsID
            NSLog(@"sms ID：%d",msgId);
//            self.smsIdTf.text = [NSString stringWithFormat:@"%d", msgId];
            [self.delegate GetIdentifyingCode_sucess];
        }
    }];
}

-(void)MakeTureIdentifyingCode:(NSString *)IdentifyingCode AndPhoneNumber:(NSString*)PhoneNumber{
    //验证
    [BmobSMS verifySMSCodeInBackgroundWithPhoneNumber:PhoneNumber andSMSCode:IdentifyingCode resultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"%@",@"验证成功，可执行用户请求的操作");
//            self.resultTv.text = @"验证成功，可执行用户请求的操作";
            [self.delegate MakeTureIdentifyingCode_sucess];
        } else {
            NSLog(@"%@",error);
//            self.resultTv.text = [error description];
            [self.delegate MakeTureIdentifyingCode_failed];
        }
    }];
}

@end
