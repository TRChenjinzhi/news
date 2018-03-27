//
//  TaskCellHeader_model.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskCellHeader_model : NSObject

@property (nonatomic,strong)NSString* title;
@property (nonatomic,strong)NSString* subTitle;

@property (nonatomic)NSInteger DaysOfSignIn;//连续签到天数

@end
