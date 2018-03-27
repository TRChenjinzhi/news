//
//  NullNilHelper.m
//  新闻
//
//  Created by chenjinzhi on 2018/2/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NullNilHelper.h"

@implementation NullNilHelper

+ (BOOL)dx_isNullOrNilWithObject:(id)object;
{
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([object isKindOfClass:[NSNumber class]]) {
        if ([object isEqualToNumber:@0]) {
            return YES;
        } else {
            return NO;
        }
    }else if([object isKindOfClass:[NSDictionary class]]){
        if([object isEqualToDictionary:[NSDictionary dictionary]]){
            return YES;
        }else{
            return NO;
        }
    }
    
    return NO;
}
@end
