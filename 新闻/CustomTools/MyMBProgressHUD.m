//
//  MyMBProgressHUD.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyMBProgressHUD.h"

@implementation MyMBProgressHUD

+(void)ShowMessage:(NSString *)message ToView:(UIView *)view AndTime:(unsigned int)time{
    MBProgressHUD* _HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:_HUD];
    _HUD.labelText = message;
    _HUD.mode = MBProgressHUDModeText;
    
    [_HUD showAnimated:YES whileExecutingBlock:^{
        sleep(time);
        
    }
       completionBlock:^{
           [_HUD removeFromSuperview];
           //                       _HUD = nil;
       }];
}

@end
