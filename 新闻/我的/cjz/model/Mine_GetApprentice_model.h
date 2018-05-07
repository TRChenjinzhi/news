//
//  Mine_GetApprentice_model.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/16.
//  Copyright © 2018年 apple. All rights reserved.
//
/*
 {
 "user_id":"xxxxxxx",
 "avatar":"http://q.qlogo.cn/qqapp/1105182645/814B08C64ADD12284CA82BA39384B177/100",
 "name":"f4e2_6140732",
 "telephone":"13403773438",
 "slaver_income":0,
 "count":1,
 "ctime":1518314734,
 }
 */

#import <Foundation/Foundation.h>

@interface Mine_GetApprentice_model : NSObject

@property (nonatomic,strong)NSString* user_id;
@property (nonatomic,strong)NSString* avatar;
@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSString* telephone;
@property (nonatomic,strong)NSString* slaver_income;
@property (nonatomic,strong)NSString* count;
@property (nonatomic,strong)NSString* time;
@property (nonatomic,strong)NSString* last_login_time;


+(NSArray*)dicToArray:(NSArray*)array_dic;

@end
