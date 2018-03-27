//
//  AlertHelper.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertHelper : NSObject

+(instancetype)Share;

-(void)ShowMe:(UIViewController*)m_self And:(double)time And:(NSString*)message;

@end
