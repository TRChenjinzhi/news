//
//  MyEntrypt.m
//  新闻
//
//  Created by chenjinzhi on 2018/2/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyEntrypt.h"

@implementation MyEntrypt

+(NSString *)MakeEntryption:(NSString *)str{
    //AES加密+base64
    NSString* str_tmp = [FSAES128 AES128EncryptStrig:str];
    
    //J73FGWm0y+iRxc2dDRCr2A==   helloworld
    
    //url encode
    UrlEncode* url_endcode = [[UrlEncode alloc]init];
    NSString* str_tmp1 = [url_endcode URLEncodedString:str_tmp];
    return str_tmp1;
    
}

@end
