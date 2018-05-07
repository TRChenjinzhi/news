//
//  Login_info.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/25.
//  Copyright © 2018年 apple. All rights reserved.
//

/*
 {
 "code":200,
 "info":"succ",
 "userinfo":{
     "user_id":"714B08C64ADD12284CA82BA39384B177",
     "mastercode":"",
     "appren":"6259824",
     "name":"江湖行",
     "telephone":"",
     "avatar":"http://q.qlogo.cn/qqapp/1105182645/814B08C64ADD12284CA82BA39384B177/100",
     "register_time":1515479053,
     "ip":"182.50.114.2"
     "sex":"1"
     },
 "shareinfo":{
     "title":"考拉试玩发钱啦，我刚刚又提现100块哦",
     "desc":"发钱啦，教你赚钱，无门槛，不收费。下载立得1元现金",
     "url":"http://api.198pai.com/web/apprentice/uid/10",
     "img":"http://cdnwww.larmor.cn/miguopai/share_icon.png"
 },
 "money":{
     "coin":"0",
     "cash":"0.00",
     "total_cash":"0.00",//总提现
     "total_income":"0.00",//总收入
     "binding_alipay":"0",//是否绑定支付宝
     "withdraw_account":{
 
         "alipay_num":"", //支付宝账号
         "alipay_name":"" //支付宝名称
    }
     "binding_wechat":"0",  //是否绑定微信 0否   1：是
     "withdraw_wechat":{
     "wechat_openid":"",  //微信openid
     "wechat_name":"",    //微信真实姓名
     }
     "is_wechat_withdraw":0,    //是否提现过1元  0：否 1：是
}
 */

#import "Login_info.h"
/*userInfo
appren = 7376768;
"appren_count" = 0;
avatar = "<null>";
ip = "182.50.114.2";
"is_read_question" = 0;
"login_times" = 1;
mastercode = "";
name = "5a5d_15527747037";
"register_time" = 1517467459;
sex = "1";
telephone = 15527747037;
"user_id" = 578604bf65556785ad2bb87f331d3126;
"wechat_binding" = 0;
 
 wechat_icon : "xxxxx" // 微信头像
 
 wechat_nickname : "xxxxx" // 微信昵称
 
 "reg_reward_cash" = 0;//要显示的金额
 "reg_reward_status" = 1;0:新用户 1:老用户
 */

@implementation Login_info

+(instancetype)dicToModel:(NSDictionary *)dic{
    
    NSMutableDictionary* dic_tmp = [[NSMutableDictionary alloc]init];
    
    NSMutableDictionary* dic_userInfo = [[NSMutableDictionary alloc]initWithDictionary:dic[@"userinfo"]];
    Login_userInfo* userInfo = [[Login_userInfo alloc]init];
    userInfo.user_id = dic_userInfo[@"user_id"];
    userInfo.mastercode = dic_userInfo[@"mastercode"];
    if((NSNull *)userInfo.mastercode == [NSNull null]){
        [dic_userInfo setValue:@"" forKey:@"mastercode"];
        userInfo.mastercode = @"";
    }
    userInfo.master_name = dic_userInfo[@"master_name"];
    userInfo.master_avatar = dic_userInfo[@"master_avatar"];
    userInfo.appren = dic_userInfo[@"appren"];
    userInfo.name = dic_userInfo[@"name"];
    userInfo.telephone = dic_userInfo[@"telephone"];
    userInfo.avatar = dic_userInfo[@"avatar"];
    if((NSNull *)userInfo.avatar == [NSNull null]){
        [dic_userInfo setValue:@"" forKey:@"avatar"];
        userInfo.avatar = @"";
    }
    userInfo.register_time = dic_userInfo[@"register_time"];
    userInfo.ip = dic_userInfo[@"ip"];
    userInfo.sex = dic_userInfo[@"sex"];
    userInfo.is_read_question = dic_userInfo[@"is_read_question"];
    userInfo.wechat_binding = dic_userInfo[@"wechat_binding"];
    userInfo.login_times = dic_userInfo[@"login_times"];
    userInfo.appren_count = dic_userInfo[@"appren_count"];
    userInfo.wechat_icon = dic_userInfo[@"wechat_icon"];
    userInfo.wechat_nickname = dic_userInfo[@"wechat_nickname"];
    NSNumber* cash = dic_userInfo[@"reg_reward_cash"];
    userInfo.reg_reward_cash = [cash stringValue];
    userInfo.reg_reward_status = dic_userInfo[@"reg_reward_status"];
    NSNumber* number_device_mult_user = dic_userInfo[@"device_mult_user"];
    userInfo.device_mult_user = [number_device_mult_user stringValue];
    userInfo.device_first_tel = dic_userInfo[@"device_first_tel"];
    
    NSMutableDictionary* dic_shareInfo = [[NSMutableDictionary alloc]initWithDictionary:dic[@"shareinfo"]];
    Login_shareInfo* shareInfo = [[Login_shareInfo alloc] init];
    shareInfo.title = dic_shareInfo[@"title"];
    shareInfo.desc = dic_shareInfo[@"desc"];
    shareInfo.url = dic_shareInfo[@"url"];
    shareInfo.img = dic_shareInfo[@"img"];
    shareInfo.shorLink = dic_shareInfo[@"shorLink"];

    NSMutableDictionary* dic_userMoney = [[NSMutableDictionary alloc]initWithDictionary:dic[@"money"]];
    Login_userMoney* userMoney = [[Login_userMoney alloc] init];
    userMoney.coin = [JsonHelper JsonToObject_ToStringByInterger:dic_userMoney[@"coin"]];
    userMoney.cash = [JsonHelper JsonToObject_ToStringByFloat:dic_userMoney[@"cash"]];
    userMoney.binding_alipay = dic_userMoney[@"binding_alipay"];
    NSDictionary* dic_withdraw_account = dic_userMoney[@"withdraw_account"];
    userMoney.alipay_num = dic_withdraw_account[@"alipay_num"];
    if((NSNull *)userMoney.alipay_num == [NSNull null]){
        [dic_userMoney setValue:@"" forKey:@"alipay_num"];
        userMoney.alipay_num = @"";
    }
    userMoney.alipay_name = dic_withdraw_account[@"alipay_name"];
    if((NSNull *)userMoney.alipay_name == [NSNull null]){
        [dic_userMoney setValue:@"" forKey:@"alipay_name"];
        userMoney.alipay_name = @"";
    }

    userMoney.binding_wechat = [JsonHelper JsonToObject_ToStringByInterger:dic_userMoney[@"binding_wechat"]];
    NSDictionary* dic_withdraw_wechat = dic_userMoney[@"withdraw_wechat"];
    userMoney.wechat_openid = dic_withdraw_wechat[@"wechat_openid"];
    userMoney.wechat_name = dic_withdraw_wechat[@"wechat_name"];
    userMoney.is_wechat_withdraw = [JsonHelper JsonToObject_ToStringByInterger:dic_userMoney[@"is_wechat_withdraw"]];
    
    userMoney.total_cashed = [JsonHelper JsonToObject_ToStringByFloat:dic_userMoney[@"total_cashed"]];
    userMoney.total_income = [JsonHelper JsonToObject_ToStringByFloat:dic_userMoney[@"total_income"]];
    
    Login_info* login_info = [[Login_info alloc] init];
    login_info.userInfo_model = userInfo;
    login_info.shareInfo_model = shareInfo;
    login_info.userMoney_model = userMoney;
    login_info.isLogined = YES;
    
    [[Login_info share] SaveLoginInfo:login_info];
    
    [dic_tmp setValue:dic_userInfo forKey:@"userinfo"];
    [dic_tmp setValue:dic_shareInfo forKey:@"shareinfo"];
    [dic_tmp setValue:dic_userMoney forKey:@"money"];
    [[AppConfig sharedInstance] saveUserInfo:dic_tmp];//本地存储
    
    return login_info;
}

static id _instance;
+(instancetype)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

-(void)SaveLoginInfo:(Login_info *)info{
    [Login_info share].userInfo_model = info.userInfo_model;
    [Login_info share].shareInfo_model = info.shareInfo_model;
    [Login_info share].userMoney_model = info.userMoney_model;
    [Login_info share].isLogined   = YES;
}

-(Login_info*)GetLoginInfo{
    [self GetLoginInfoFormLocal];
    return [Login_info share];
}

-(Login_userInfo*)GetUserInfo{
    [self GetLoginInfoFormLocal];
    return [Login_info share].userInfo_model;
}

-(Login_shareInfo*)GetShareInfo{
    [self GetLoginInfoFormLocal];
    return [Login_info share].shareInfo_model;
}

-(Login_userMoney*)GetUserMoney{
    [self GetLoginInfoFormLocal];
    return [Login_info share].userMoney_model;
}

-(BOOL)GetIsLogined{
    [self GetLoginInfoFormLocal];
    return [Login_info share].isLogined;
}

-(void)GetLoginInfoFormLocal{
    NSDictionary* dic = [[NSMutableDictionary alloc] initWithDictionary:[[AppConfig sharedInstance] GetUserInfo]];
    if([NullNilHelper dx_isNullOrNilWithObject:dic]){
        Login_userInfo* userInfo = [[Login_userInfo alloc]init];
        userInfo.user_id = @"";
        [Login_info share].userInfo_model = userInfo;
        [Login_info share].isLogined = NO;
    }else{
        [Login_info dicToModel:dic];
        [Login_info share].isLogined = YES;
    }
}

-(Money_model*)GetMoneyModel{
    if(![Login_info share].isLogined){
        [self GetLoginInfoFormLocal];
    }
    
    Money_model* money_model = [[Money_model alloc] init];
    Login_userMoney* model = [[Login_info share] GetUserMoney];
    
    money_model.gold = [model.coin integerValue];
    money_model.money = [model.cash floatValue];
    money_model.apprentice = [model.binding_alipay integerValue];
    
    return money_model;
}

@end
