//
//  Mine_login_ViewController.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Mine_userInfo_model.h"

@protocol LoginInterfaceDelegate <NSObject>
// 让协议方法带参传值
/**传递的值*/
- (void)makeTureLogin:(Mine_userInfo_model*)model;
@end

@interface Mine_login_ViewController : UIViewController

@property (nonatomic,weak)id delegate;

@end
