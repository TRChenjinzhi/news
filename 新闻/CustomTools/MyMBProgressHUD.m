//
//  MyMBProgressHUD.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyMBProgressHUD.h"

@implementation MyMBProgressHUD

+(void)showMessage:(NSString *)message{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.label.textColor = RGBA(255, 129, 3, 1);
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, SCREEN_HEIGHT);
    
    [hud hideAnimated:YES afterDelay:1.0f];
}
+(void)ShowMessage:(NSString *)message ToView:(UIView *)view AndTime:(unsigned int)time{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(message, @"HUD message title");
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, SCREEN_HEIGHT);
    
    [hud hideAnimated:YES afterDelay:time];
}

+(MBProgressHUD*)ShowWaittingByMessage:(NSString *)message ToView:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Set the label text.
    hud.label.text = NSLocalizedString(message, message);
    
    return hud;
}

@end
