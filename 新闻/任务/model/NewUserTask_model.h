//
//  NewUserTask_model.h
//  新闻
//
//  Created by chenjinzhi on 2018/4/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {
 "type":8,    //绑定微信
 "max":1,     //无用
 "count":0,   //无用
 "status":0   //完成状态    0：未完成   1：完成
 }
 */

@interface NewUserTask_model : NSObject

@property (nonatomic,assign)NSInteger type;
@property (nonatomic,assign)NSInteger max;
@property (nonatomic,assign)NSInteger count;
@property (nonatomic,assign)NSInteger status;

+(NSMutableArray*)dicToArray:(NSArray *)array_dic;

@end
