//
//  AlertHelper.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AlertHelper.h"

@implementation AlertHelper

static id _instance;
+(instancetype)Share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

-(void)ShowMe:(UIViewController*)m_self And:(double)time And:(NSString *)message{
    UIAlertController* alert_VC = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@",message] preferredStyle:UIAlertControllerStyleAlert];
    //弹出视图,使用UIViewController的方法
    [m_self presentViewController:alert_VC animated:YES completion:^{
        [NSThread sleepForTimeInterval:time];
        //隔一会就消失
        [m_self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
}

@end
