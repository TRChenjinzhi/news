//
//  DayDayTask_sign_gold_model.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DayDayTask_sign_gold_model : NSObject

@property (nonatomic)BOOL HaveLeftLine;
@property (nonatomic)BOOL HaveRightLine;
@property (nonatomic)BOOL IsRedPackage;

@property (nonatomic)NSInteger numberOfGold;
@property (nonatomic)BOOL IsToday;
@property (nonatomic)NSInteger daysCount;

@end
