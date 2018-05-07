//
//  Login_userInfo.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/25.
//  Copyright © 2018年 apple. All rights reserved.
//
 /*userInfo
  {
  "user_id":"5bd4ea124ca816537533ae3cd72d5fef",
  "mastercode":"",
  "master_avatar":"师傅头像",    add
  "master_name":"师傅昵称",      add
  "appren":"0473238",   //收徒码
  "appren_count":"1",   //徒弟数(有效)
  "name":"追逐",        //用户昵称
  "telephone":"13241690070",  //用户注册用的手机号
  "avatar":"http://ad-manager.b0.upaiyun.com/avatar/5bd4ea124ca816537533ae3cd72d5fef.jpg", //用户头像
  "sex":"1",                         //性别   1：男   2：女
  "register_time":1517380036,        //注册时间（时间戳）
  "ip":"182.50.114.2",               //客户端ip(服务器获取)
  "login_times":3,                   //连续登录次数 1，2，3，4，5，6，7
  "is_read_question":"1",            //是否阅读常见问题  0：否   1：是
  "wechat_binding":"1"               //是否绑定微信     0：否  1：是
  
  wechat_icon : "xxxxx" // 微信头像
  
  wechat_nickname : "xxxxx" // 微信昵称
  
  "reg_reward_cash" = 0;            //要显示的金额
  "reg_reward_status" = 1;          //0:新用户 1:老用户
  "device_mult_user":0,            //0:一个用户 1：不是第一个用户
  "device_first_tel":"13241690070"   //用户在此设备首次登陆时候的手机号没号码 缺省空  更换账号时候有值
  }
 */


#import <Foundation/Foundation.h>

@interface Login_userInfo : NSObject

@property (nonatomic,strong)NSString* user_id;
@property (nonatomic,strong)NSString* mastercode;
@property (nonatomic,strong)NSString* master_avatar;
@property (nonatomic,strong)NSString* master_name;
@property (nonatomic,strong)NSString* appren;//邀请码
@property (nonatomic,strong)NSString* appren_count;
@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSString* telephone;
@property (nonatomic,strong)NSString* avatar;
@property (nonatomic,strong)NSString* register_time;
@property (nonatomic,strong)NSString* ip;
@property (nonatomic,strong)NSString* sex;
@property (nonatomic,strong)NSString* is_read_question;//0:未阅读 1:阅读
@property (nonatomic,strong)NSString* wechat_binding;//0:未绑定 1:绑定
@property (nonatomic,strong)NSString* login_times;
@property (nonatomic,strong)NSString* wechat_icon;
@property (nonatomic,strong)NSString* wechat_nickname;
@property (nonatomic,strong)NSString* reg_reward_cash;
@property (nonatomic,strong)NSString* reg_reward_status;
@property (nonatomic,strong)NSString* device_mult_user;
@property (nonatomic,strong)NSString* device_first_tel;

@end
