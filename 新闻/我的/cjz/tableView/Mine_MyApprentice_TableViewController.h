//
//  Mine_MyApprentice_TableViewController.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mine_GetApprentice_model.h"

@protocol MyApprenceTVCL_GetApprenceVCL_protocl
-(void)showApprenceInfo:(Mine_GetApprentice_model*)model;
@end

@interface Mine_MyApprentice_TableViewController : UITableViewController

@property (nonatomic,strong)NSArray* array_model;
@property (nonatomic,strong)id delegate;

@end
