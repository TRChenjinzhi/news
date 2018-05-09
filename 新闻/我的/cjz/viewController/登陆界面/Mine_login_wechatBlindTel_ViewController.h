//
//  Mine_login_wechatBlindTel_ViewController.h
//  新闻
//
//  Created by chenjinzhi on 2018/4/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Mine_userInfo_model.h"

@protocol  Mine_login_wechatBlindTel_To_Mine_Login_VCL_protocol

@optional
-(void)Logined:(Mine_userInfo_model*)model;
@end

@interface Mine_login_wechatBlindTel_ViewController : UIViewController

@property (nonatomic,strong)NSString* openId;
@property (nonatomic,strong)id delegate;

@end
