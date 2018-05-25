//
//  MyMBProgressHUD.h
//  新闻
//
//  Created by chenjinzhi on 2018/3/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMBProgressHUD : UIView

+(void)showMessage:(NSString *)message;
+(void)ShowMessage:(NSString*)message ToView:(UIView*)view AndTime:(unsigned int)time;
+(MBProgressHUD*)ShowWaittingByMessage:(NSString *)message ToView:(UIView *)view;

@end
