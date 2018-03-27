//
//  Task_DetailWeb_model.h
//  新闻
//
//  Created by chenjinzhi on 2018/3/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task_DetailWeb_model : NSObject

@property (nonatomic,strong)NSString* newsId;
@property (nonatomic)BOOL isOver;

+(instancetype)share;
-(void)initData;

@end
