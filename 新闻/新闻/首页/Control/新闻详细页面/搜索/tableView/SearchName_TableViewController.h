//
//  SearchName_TableViewController.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol SearchName_tableView_delegate

@optional
-(void)selectedSearchName:(NSString*)name;

@end

@interface SearchName_TableViewController : UITableViewController

@property (nonatomic,weak)id delegate;

@property (nonatomic)NSInteger type;

@end
