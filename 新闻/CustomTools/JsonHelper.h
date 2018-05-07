//
//  JsonHelper.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonHelper : NSObject

+(NSString*)JsonToString:(NSDictionary*)dictionary;
+ (NSString *)arrayToJSONString:(NSArray *)array;
+(NSDictionary*)StringToDictionary:(NSString*)string;

+(NSString *)JsonToObject_ToStringByFloat:(NSObject *)obj;
+(NSString *)JsonToObject_ToStringByInterger:(NSObject *)obj;

@end
