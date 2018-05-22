//
//  DeviveHelper.h
//  新闻
//
//  Created by chenjinzhi on 2018/5/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviveHelper : NSObject

+(instancetype)share;

-(NSString *)getDeviceName;
- (NSString *)getMacAddress;

@end
