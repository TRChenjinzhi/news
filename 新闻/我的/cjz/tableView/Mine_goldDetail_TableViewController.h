//
//  Mine_goldDetail_TableViewController.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Money_model.h"

@interface Mine_goldDetail_TableViewController : UITableViewController

@property (nonatomic,strong)NSString* tableName;//区分是金币 还是钱包

@property (nonatomic,strong)NSArray* array_cells;//里面的元素 是array


@end
