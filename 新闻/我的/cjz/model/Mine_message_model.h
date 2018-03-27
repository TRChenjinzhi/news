//
//  Mine_message_model.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/11.
//  Copyright © 2018年 apple. All rights reserved.
//

/*
 {
 "type":1,
 "title":"金币兑换提醒",
 "desc":"恭喜您，已经将昨日赚取的600金币自动兑换成零钱：0.60元。请继续加油哦！",
 "date":1517990294
 }
 */

#import <Foundation/Foundation.h>

@interface Mine_message_model : NSObject

@property (nonatomic,strong)NSString* type;
@property (nonatomic,strong)NSString* title;
@property (nonatomic,strong)NSString* subTitle;
@property (nonatomic,strong)NSString* time;


+(NSArray*)dicToModelArray:(NSDictionary*)dic;
@end
