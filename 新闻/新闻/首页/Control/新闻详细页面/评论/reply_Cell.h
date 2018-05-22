//
//  reply_Cell.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "reply_model.h"

@protocol reply_cell_protocol
@optional
-(void)GoToReplyAll:(reply_model*)model;
-(void)replyFromMymodel:(reply_model*)myModel;
@end

@interface reply_Cell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong)reply_model* model;
@property (nonatomic,weak)id delegate;

@end
