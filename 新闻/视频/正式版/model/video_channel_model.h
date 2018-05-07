//
//  videl_channel_model.h
//  新闻
//
//  Created by chenjinzhi on 2018/3/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface video_channel_model : NSObject

@property (nonatomic,strong)NSString* channel_id;
@property (nonatomic,strong)NSString* title;
@property (nonatomic)BOOL isReading;

+(NSArray*)dicToArray:(NSDictionary*)dic;

@end
