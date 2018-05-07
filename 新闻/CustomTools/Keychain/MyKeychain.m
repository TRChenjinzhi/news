//
//  MyKeychain.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyKeychain.h"

@implementation MyKeychain

+ (NSMutableDictionary *)keyChainQueryDictionaryWithService:(NSString *)service{
    NSMutableDictionary *keyChainQueryDictaionary = [[NSMutableDictionary alloc]init];
    [keyChainQueryDictaionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    [keyChainQueryDictaionary setObject:service forKey:(id)kSecAttrService];
    [keyChainQueryDictaionary setObject:service forKey:(id)kSecAttrAccount];
    return keyChainQueryDictaionary;
}

//添加数据
+ (BOOL)addData:(id)data forService:(NSString *)service{
    NSMutableDictionary *keychainQuery = [self keyChainQueryDictionaryWithService:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    OSStatus status= SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    if (status == noErr) {
        return YES;
    }
    return NO;
}

//搜索数据
+ (id)queryDataWithService:(NSString *)service {
    id result = nil;
    NSMutableDictionary *keyChainQuery = [self keyChainQueryDictionaryWithService:service];
    [keyChainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keyChainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keyChainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            result = [NSKeyedUnarchiver  unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch (NSException *exception) {
            NSLog(@"不存在数据");
        }
        @finally {
            
        }
    }
    if (keyData) {
        CFRelease(keyData);
    }
    return result;
}

//更新数据
+ (BOOL)updateData:(id)data forService:(NSString *)service{
    NSMutableDictionary *searchDictionary = [self keyChainQueryDictionaryWithService:service];
    
    if (!searchDictionary) {
        return NO;
    }
    
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    [updateDictionary setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    OSStatus status = SecItemUpdate((CFDictionaryRef)searchDictionary,
                                    (CFDictionaryRef)updateDictionary);
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

//删除数据
+ (BOOL)deleteDataWithService:(NSString *)service{
    NSMutableDictionary *keyChainDictionary = [self keyChainQueryDictionaryWithService:service];
    OSStatus status = SecItemDelete((CFDictionaryRef)keyChainDictionary);
    if (status == noErr) {
        return YES;
    }
    return NO;
}


@end
