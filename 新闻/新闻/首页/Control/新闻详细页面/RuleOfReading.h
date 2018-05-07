//
//  RuleOfReading.h
//  新闻
//
//  Created by chenjinzhi on 2018/2/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuleOfReading : NSObject

-(BOOL)AddReadingCountType:(NSInteger)type AndTaskId:(NSString*)taskId AndNewsId:(NSString*)newsId AndScrollview:(UIScrollView*)scrollview AndTableview:(UITableView*)tableview AndHeaderSize:(CGSize)headerSize AndIsReadAll:(BOOL)isReadAll  AndScrollCount:(NSInteger)count;

@end
