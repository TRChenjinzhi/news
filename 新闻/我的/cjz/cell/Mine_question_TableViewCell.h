//
//  Mine_question_TableViewCell.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mine_question_model.h"

@interface Mine_question_TableViewCell : UITableViewCell

+(instancetype)cellForTableView:(UITableView*)tableView;
+(CGFloat)HightForCell;

@property (nonatomic,strong)Mine_question_model* model;
@property (nonatomic)BOOL isReading;

@end
