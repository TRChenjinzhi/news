//
//  Login_userMoney.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/25.
//  Copyright © 2018年 apple. All rights reserved.
//
/*
 {
 cash = 0;
 coin = 10;
 "total_cashed" = 0;
 "total_income" = 0;
  "binding_alipay" = 0;
 "withdraw_account" =     {
     "alipay_name" = "";
     "alipay_num" = "";
    };
     "binding_wechat":"0",  //是否绑定微信 0否   1：是
     "withdraw_wechat":{
     "wechat_openid":"",  //微信openid
     "wechat_name":"",    //微信真实姓名
     }
     "is_wechat_withdraw":0,    //是否提现过1元  0：否 1：是
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
@property (nonatomic,strong)NSString* binding_wechat;
@property (nonatomic,strong)NSString* wechat_openid;
@property (nonatomic,strong)NSString* wechat_name;
@property (nonatomic,strong)NSString* is_wechat_withdraw;

@end
