//
//  choujiang_model.h
//  新闻
//
//  Created by chenjinzhi on 2018/4/25.
//  Copyright © 2018年 apple. All rights reserved.
//

/*
 {
 id = 5;
 keyword = "/bridge.do";
 message = "\U4e92\U52a8\U63a8";
 name = "\U4e92\U52a8\U63a8";
 number = 5;
 source = "\U4e92\U52a8\U63a8";
 url = "https://display.intdmp.com/site_login_ijf.htm?app_key=adhub3810493473140c1";
 }
 */

#import <Foundation/Foundation.h>

@interface choujiang_model : NSObject

@property (nonatomic,strong)NSString* ID;
@property (nonatomic,strong)NSString* keyword;
@property (nonatomic,strong)NSString* number;
@property (nonatomic,strong)NSString* url;

+(NSArray*)dicToArray:(NSArray*)array;

@end
