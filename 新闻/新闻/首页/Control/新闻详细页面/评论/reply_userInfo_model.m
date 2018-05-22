//
//  reply_userInfo_model.m
//  橙子快报
//
//  Created by chenjinzhi on 2018/5/17.
//  Copyright © 2018年 apple. All rights reserved.
//
/*
 "user_info":{
 "user_id":"xxxxx",
 "user_name":"橙友8717165",
 "user_icon":"",
 "wechat_nickname":"守候",
 "wechat_icon":"http://thirdwx.qlogo.cn/mmopen/vi_32/EKagrrV6YQUwH2MKmiczK2ZjQDYlJdoGYD9ylz6hIvUNoxX9ukJ5PoV3cAXroKqEiaY6K6UU6zz76E2sLyQlTGkA/132"
 }
 */

#import "reply_userInfo_model.h"

@implementation reply_userInfo_model

+(reply_userInfo_model*)dicToModel:(NSDictionary*)dic{
    reply_userInfo_model* model = [reply_userInfo_model new];
    model.user_id           = dic[@"user_id"];
    model.user_name         = dic[@"user_name"];
    model.user_icon         = dic[@"user_icon"];
    model.wechat_nickname   = dic[@"wechat_nickname"];
    model.wechat_icon       = dic[@"wechat_icon"];
    
    return model;
}

@end
