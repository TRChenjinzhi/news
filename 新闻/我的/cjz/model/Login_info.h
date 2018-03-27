//
//  Login_info.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Login_userInfo.h"
#import "Login_shareInfo.h"
#import "Login_userMoney.h"
#import "Money_model.h"

@interface Login_info : NSObject

@property (nonatomic,strong)Login_userInfo* userInfo_model;
@property (nonatomic,strong)Login_shareInfo* shareInfo_model;
@property (nonatomic,strong)Login_userMoney* userMoney_model;

@property (nonatomic)BOOL    isLogined;

+(instancetype)dicToModel:(NSDictionary*)dic;
+(instancetype)share;

-(void)SaveLoginInfo:(Login_info*)info;
-(Login_info*)GetLoginInfo;
-(Login_userInfo*)GetUserInfo;
-(Login_shareInfo*)GetShareInfo;
-(Login_userMoney*)GetUserMoney;
-(Money_model*)GetMoneyModel;
-(BOOL)GetIsLogined;

@end
