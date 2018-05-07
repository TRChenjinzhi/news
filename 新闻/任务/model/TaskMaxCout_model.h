//
//  TaskMaxCout_model.h
//  新闻
//
//  Created by chenjinzhi on 2018/2/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskMaxCout_model : NSObject

@property (nonatomic,assign)NSInteger  type;//任务类型
@property (nonatomic,assign)NSInteger maxCout;//最大完成次数
@property (nonatomic,assign)NSInteger count;//已完成
@property (nonatomic,assign)NSInteger lastOpenBox_time;//最后一次打开宝箱时间


+(NSArray*)dicToArray:(NSDictionary*)dic;

@end
