//
//  Task_TableViewCell.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskCell_model.h"
#import "TaskMaxCout_model.h"

@interface Task_TableViewCell : UITableViewCell

@property (nonatomic,strong)TaskCell_model* taskModel;

+(instancetype)CellFormTable:(UITableView*)tableView;
+(instancetype)CellFormTableForDayDayTask:(UITableView*)tableView;
+(CGFloat)HightForcell;

@property (nonatomic,strong)NSString* type;//区分新手任务，日常任务

@property (nonatomic,strong)TaskMaxCout_model* taskCount;


@end
