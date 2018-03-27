#import <Foundation/Foundation.h>

@interface FSAES128 : NSObject

+ (NSString *)AES128EncryptStrig:(NSString *)plainText;

+ (NSString *)AES128DecryptString:(NSString *)string;

@end
