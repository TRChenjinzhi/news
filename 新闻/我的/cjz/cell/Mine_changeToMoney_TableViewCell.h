//
//  Mine_changeToMoney_TableViewCell.h
//  新闻
//
//  Created by chenjinzhi on 2018/3/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mine_ChangToMoney_cell_model.h"

@interface Mine_changeToMoney_TableViewCell : UITableViewCell

+(instancetype)cellForTableView:(UITableView *)tabelView;
+(CGFloat)HightForCell;

@property (nonatomic,strong)Mine_ChangToMoney_cell_model* model;

@end
