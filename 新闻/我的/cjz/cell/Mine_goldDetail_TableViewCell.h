//
//  Mine_goldDetail_TableViewCell.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mine_goldDetail_cell_model.h"

@interface Mine_goldDetail_TableViewCell : UITableViewCell

+(instancetype)cellForTableView:(UITableView *)tabelView;
+(CGFloat)HightForCell;

@property (nonatomic,strong)Mine_goldDetail_cell_model* cell_model;

@end
