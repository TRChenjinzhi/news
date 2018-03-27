//
//  reply_model.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface reply_model : NSObject

@property (nonatomic,strong)NSString* ID;
@property (nonatomic,strong)NSString* user_name;
@property (nonatomic,strong)NSString* user_icon;
@property (nonatomic,strong)NSString* comment;
@property (nonatomic,strong)NSString* thumbs_num;
@property (nonatomic,strong)NSString* ctime;
@property (nonatomic)NSInteger DianZan_type;//是否已经点赞 1:点赞 2.没点赞

+(NSArray*)dicToArray:(NSDictionary*)dic;

@end
