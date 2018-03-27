//
//  Mine_setting_TableViewCell.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mine_setting_model.h"

@interface Mine_setting_TableViewCell : UITableViewCell

+(instancetype)cellForTableView:(UITableView*)tableView;
+(CGFloat)HightForCell;

@property (nonatomic,strong)Mine_setting_model* model;

@end
