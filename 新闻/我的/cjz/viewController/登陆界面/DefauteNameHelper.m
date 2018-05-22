//
//  DefauteNameHelper.m
//  橙子快报
//
//  Created by chenjinzhi on 2018/5/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DefauteNameHelper.h"

@implementation DefauteNameHelper

//当登录时 默认的名称为：橙友+邀请码
+(NSString*)getDefuateName{
    if(![Login_info share].isLogined){
        return nil;
    }
    else{
        NSString* str = [NSString stringWithFormat:@"橙友%@",[Login_info share].userInfo_model.appren];
        return str;
    }
}

@end
