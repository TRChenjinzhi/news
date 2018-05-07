//
//  Video_detail_tuijian_TableViewController.h
//  新闻
//
//  Created by chenjinzhi on 2018/4/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "video_info_model.h"

@protocol video_tuijian_tableview_protocol
@optional
-(void)goToOtherDetail:(video_info_model*)model;
@end

@interface Video_detail_tuijian_TableViewController : UITableViewController

@property (nonatomic,strong)NSArray* array_model;
@property (nonatomic,weak)id delegate;

@end
