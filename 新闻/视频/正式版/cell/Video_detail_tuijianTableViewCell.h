//
//  Video_detail_tuijianTableViewCell.h
//  新闻
//
//  Created by chenjinzhi on 2018/4/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "video_info_model.h"

@interface Video_detail_tuijianTableViewCell : UITableViewCell

@property (nonatomic,strong)video_info_model* model;

+(instancetype)CellFormTable:(UITableView *)tableView;
+(CGFloat)cellForHeight;

@end
