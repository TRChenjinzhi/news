//
//  IndexOfNews.h
//  新闻
//
//  Created by chenjinzhi on 2018/3/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexOfNews : NSObject

@property (nonatomic,strong)NSArray* channel_all; //全部频道
@property (nonatomic,strong)NSArray* channel_array;//显示频道
@property (nonatomic,strong)NSArray* channel_more_array;//更多频道
@property (nonatomic,assign)NSInteger index;

+(instancetype)share;
-(BOOL)isHaveChannel:(NSString*)title;

@end
