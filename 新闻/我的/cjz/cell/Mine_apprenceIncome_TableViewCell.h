//
//  Mine_apprenceIncome_TableViewCell.h
//  新闻
//
//  Created by chenjinzhi on 2018/3/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mine_apprenceInfo_model.h"

@interface Mine_apprenceIncome_TableViewCell : UITableViewCell

+(instancetype)cellForTableView:(UITableView *)tabelView;
+(CGFloat)HightForCell;

@property (nonatomic,strong)Mine_apprenceInfo_model* model;

@end
