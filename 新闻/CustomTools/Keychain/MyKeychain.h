//
//  MyKeychain.h
//  新闻
//
//  Created by chenjinzhi on 2018/3/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyKeychain : NSObject

+ (BOOL)addData:(id)data forService:(NSString *)service;
+ (id)queryDataWithService:(NSString *)service;
+ (BOOL)updateData:(id)data forService:(NSString *)service;
+ (BOOL)deleteDataWithService:(NSString *)service;

@end
