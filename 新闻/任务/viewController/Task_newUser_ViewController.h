//
//  Task_newUser_ViewController.h
//  新闻
//
//  Created by chenjinzhi on 2018/5/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol newUserVC_proctocl
@optional
-(void)goToOtherVC:(NSNumber*)num_index;
@end

@interface Task_newUser_ViewController : UIViewController

@property (nonatomic,weak)id delegate;

@end
