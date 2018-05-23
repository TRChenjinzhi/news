//
//  reply_model.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/29.
//  Copyright © 2018年 apple. All rights reserved.
//

/*
 comment = "\U6536\U5f922683066";
 ctime = 1526268163;
 id = 5317;
 "thumbs_num" = 0;
 "user_icon" = "";
 "user_name" = "ce7c_2683066";
 "wechat_icon" = "http://thirdwx.qlogo.cn/mmopen/vi_32/efBHfxblExBj5iadmqNtrnUNKAiawm2xiaF7wib6tM7oJ5ico7XW6LwxhgsVbXF3AAEb7Qk5kjt7pNsYRWEBZqweiaSg/132";
 "wechat_nickname" = "\U5f00\U5fc3\U5c0f\U867e\U7c73";
 */

#import <Foundation/Foundation.h>
#import "reply_userInfo_model.h"

@interface reply_model : NSObject

@property (nonatomic,strong)NSString* ID;
@property (nonatomic,strong)NSString* pid;
@property (nonatomic,strong)reply_userInfo_model* myUserModel;
@property (nonatomic,strong)reply_userInfo_model* ToUserModel;
@property (nonatomic,strong)NSString* comment;
@property (nonatomic,strong)NSString* thumbs_num;
@property (nonatomic,strong)NSString* ctime;
@property (nonatomic,strong)NSString* reply_count;
@property (nonatomic,strong)NSArray*  array_reply;
@property (nonatomic)NSInteger DianZan_type;//是否已经点赞 1:点赞 2.没点赞

//@property (nonatomic,strong)NSString* user_icon;
//@property (nonatomic,strong)NSString* user_name;
//@property (nonatomic,strong)NSString* wechat_icon;
//@property (nonatomic,strong)NSString* wechat_nickname;

+(NSArray*)dicToArray:(NSDictionary*)dic;
+(reply_model*)getModelByDic:(NSDictionary*)item_dic;

@end
