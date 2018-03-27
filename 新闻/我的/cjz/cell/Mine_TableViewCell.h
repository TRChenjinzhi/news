//
//  Mine_TableViewCell.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mine_model.h"

@interface Mine_TableViewCell : UITableViewCell

+(CGFloat)HightForCell;
+(instancetype)cellForTableView:(UITableView*)tabelView AndId:(NSString*)ID;

@property (nonatomic,strong)Mine_model* model;

@end
