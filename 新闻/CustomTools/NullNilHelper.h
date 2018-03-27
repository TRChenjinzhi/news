//
//  NullNilHelper.h
//  新闻
//
//  Created by chenjinzhi on 2018/2/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NullNilHelper : NSObject
/**
 *  判断对象是否为空
 *  PS：nil、NSNil、@""、@0 以上4种返回YES
 *
 *  @return YES 为空  NO 为实例对象
 */
+ (BOOL)dx_isNullOrNilWithObject:(id)object;
@end
