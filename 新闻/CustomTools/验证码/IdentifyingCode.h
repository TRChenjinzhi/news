//
//  IdentifyingCode.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol IdentifyingCode_delegete

@optional
//获取
-(void)GetIdentifyingCode_sucess;
-(void)GetIdentifyingCode_failed;
//验证
-(void)MakeTureIdentifyingCode_sucess;
-(void)MakeTureIdentifyingCode_failed;

@end

@interface IdentifyingCode : NSObject

@property (nonatomic,weak)id delegate;

+(instancetype)ShareInstance;

//注册
+(void)Register:(NSString*)AppKey;

//获取-验证码
-(void)GetIdentifyingCode:(NSString*)PhoneNumber;
//验证-验证码
-(void)MakeTureIdentifyingCode:(NSString*)IdentifyingCode AndPhoneNumber:(NSString*)PhoneNumber;

@end
