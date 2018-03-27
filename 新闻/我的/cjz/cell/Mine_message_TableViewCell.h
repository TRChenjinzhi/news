//
//  Mine_message_TableViewCell.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mine_message_model.h"

@interface Mine_message_TableViewCell : UITableViewCell

+(instancetype)cellForTableView:(UITableView*)table;
+(CGFloat)hightForCell;

@property (nonatomic,strong)Mine_message_model* model;

@end
