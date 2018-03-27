//
//  MyActivity.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyActivity.h"

NSString *const UIActivityTypeZSCustomMine = @"ZSCustomActivityMine";

@implementation MyActivity

+(UIActivityCategory)activityCategory{
    return UIActivityCategoryShare;
}

- (NSString *)activityType
{
    return UIActivityTypeZSCustomMine;
}

- (NSString *)activityTitle
{
    //国际化
    return NSLocalizedString(@"ZS Custom", @"");
}

-(UIImage *)activityImage{
    return [UIImage imageNamed:@"box"];
}

//指定可以处理的数据类型，如果可以处理则返回YES
-(BOOL)canPerformWithActivityItems:(NSArray *)activityItems{
    return YES;
}

//在用户选择展示在UIActivityViewController中的自定义服务的图标之后，而且也调用了prepareWithActivityItems:,就会调用这个方法执行具体的服务操作
-(void)performActivity{
    NSLog(@"点击之后");
}

@end
