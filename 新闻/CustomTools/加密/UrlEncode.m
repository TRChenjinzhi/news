//
//  NSString+URL.m
//  新闻
//
//  Created by chenjinzhi on 2018/2/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UrlEncode.h"

@implementation UrlEncode

- (NSString *)URLEncodedString:(NSString*)string
{
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *unencodedString = string;
    NSString *encodedString =@"!*'();:@&=+$,/?%#[]";
//    NSString *encodedString = (NSString *)
//    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                              (CFStringRef)unencodedString,
//                                                              NULL,
//                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
//                                                              kCFStringEncodingUTF8));
    
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:encodedString] invertedSet];
    encodedString = [unencodedString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return encodedString;
}

/**
 *  URLDecode
 */
-(NSString *)URLDecodedString:(NSString*)string
{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *encodedString = string;
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}


@end
