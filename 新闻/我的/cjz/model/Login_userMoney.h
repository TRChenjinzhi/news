//
//  Login_userMoney.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/25.
//  Copyright © 2018年 apple. All rights reserved.
//
/*
 {
 "binding_alipay" = 0;
 cash = 0;
 coin = 10;
 "total_cashed" = 0;
 "total_income" = 0;
 "withdraw_account" =     {
     "alipay_name" = "";
     "alipay_num" = "";
 };
 }
 */

#import <Foundation/Foundation.h>

@interface Login_userMoney : NSObject

@property (nonatomic,strong)NSString* coin;
@property (nonatomic,strong)NSString* cash;
@property (nonatomic,strong)NSString* binding_alipay;
@property (nonatomic,strong)NSString* alipay_num;
@property (nonatomic,strong)NSString* alipay_name;
@property (nonatomic,strong)NSString* total_cashed;
@property (nonatomic,strong)NSString* total_income;

@end
