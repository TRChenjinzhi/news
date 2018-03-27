//
//  TaskCellHeaderTitleView.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskCellHeader_model.h"

@interface TaskCellHeaderTitleView : UIView

@property (nonatomic,strong)NSString* title;

@property (nonatomic,strong)TaskCellHeader_model* subHeaderVIew_model;

@end
