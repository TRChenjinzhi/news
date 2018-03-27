//
//  DayDayTask_TableViewController.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayDayTask_TableViewController : UITableViewController

@property (nonatomic,strong)NSString* Headertitle;

@property (nonatomic,strong)NSArray* array_model;

@property (nonatomic)BOOL isReadedQuestion;//是否完成过阅读"相关问题"

-(void)setHeadertitle:(NSString *)Headertitle AndDayCount:(NSInteger)DayCount;

@end
