//
//  NSAttributedString+CXACoreTextFrameSize.h
//  CXAHyperlinkLabelDemo
//
//  Created by Chen Xian'an on 1/7/13.
//  Copyright (c) 2013 lazyapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+CXAHyperlinkParser.h"
@interface NSAttributedString (CXACoreTextFrameSize)

- (CGSize)cxa_coreTextFrameSizeWithConstraints:(CGSize)size;


//返回一个超链接富文本
+ (NSAttributedString *)attributedString:(NSArray *__autoreleasing *)outURLs
                               URLRanges:(NSArray *__autoreleasing *)outURLRanges testContent:(NSString *)testContent;
@end
