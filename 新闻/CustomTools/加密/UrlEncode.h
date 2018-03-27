//
//  NSString+URL.h
//  新闻
//
//  Created by chenjinzhi on 2018/2/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlEncode :NSObject

/**
 *  URLEncode
 */
- (NSString *)URLEncodedString:(NSString*)string;

/**
 *  URLDecode
 */
-(NSString *)URLDecodedString:(NSString*)string;

@end
