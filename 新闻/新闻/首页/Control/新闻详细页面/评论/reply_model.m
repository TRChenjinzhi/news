//
//  reply_model.m
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

#import "reply_model.h"

@implementation reply_model

+(NSArray *)dicToArray:(NSDictionary *)dic{
    NSMutableArray* array_model = [[NSMutableArray alloc] init];
    NSArray* array = nil;
    array = dic[@"list"];
    for (NSDictionary* item_dic in array) {
        reply_model* model = [[reply_model alloc]init];
        model.ID = item_dic[@"id"];
//        model.pid= item_dic[@"pid"];
//        model.myUserModel = [reply_userInfo_model dicToModel:item_dic[@"user_info"]];
//        if([model.pid integerValue] != ReplyFirst){
//            model.ToUserModel = [reply_userInfo_model dicToModel:item_dic[@"to_user_info"]];
//        }
        model.comment = item_dic[@"comment"];
        model.thumbs_num = item_dic[@"thumbs_num"];
        model.ctime = item_dic[@"ctime"];
//        model.reply_count = item_dic[@"reply_count"];
        
//        NSMutableArray* mut_array = [NSMutableArray array];
//        if([item_dic containsObjectForKey:@"list"]){
//            NSArray* array_reply = item_dic[@"list"];
//            for (NSDictionary* dic_reply in array_reply) {
//                [mut_array addObject:[reply_model getModelByDic:dic_reply]];
//                NSLog(@"mut_array count = %ld",mut_array.count);
//            }
//            model.array_reply = mut_array;
//        }
        
        model.user_icon = item_dic[@"user_icon"];
        model.user_name = item_dic[@"user_name"];
        model.wechat_icon = item_dic[@"wechat_icon"];
        model.wechat_nickname = item_dic[@"wechat_nickname"];
        
        [array_model addObject:model];
    }
    
    return array_model;
}

/*
 "id":"2",
 "pid":"1",
 "user_info":{
 "user_id":"xxxxx",
 "user_name":"橙友8717165",
 "user_icon":"",
 "wechat_nickname":"守候",
 "wechat_icon":"http://thirdwx.qlogo.cn/mmopen/vi_32/EKagrrV6YQUwH2MKmiczK2ZjQDYlJdoGYD9ylz6hIvUNoxX9ukJ5PoV3cAXroKqEiaY6K6UU6zz76E2sLyQlTGkA/132"
 },
 "to_user_info":{
 "user_id":"xxxxx",
 "user_name":"橙友2755263",
 "user_icon":"",
 "wechat_nickname":"雅雅",
 "wechat_icon":"http://thirdwx.qlogo.cn/mmopen/vi_32/d7icwQNo1kjZV3vnvTbTJ1pTP9tMVpRhIt0BeicZKYuoSzpwBY0sknE5QQSrvBLmmmhEhiaIu01EqFy08gsl2fpRA/132"
 },
 "comment":"你评论得对",
 "ctime":"2018-05-16 10:27:38",
 */
//+(reply_model*)getModelByDic:(NSDictionary*)item_dic{
//    reply_model* model = [[reply_model alloc]init];
//    model.ID = item_dic[@"id"];
//    model.pid= item_dic[@"pid"];
//    model.myUserModel = [reply_userInfo_model dicToModel:item_dic[@"user_info"]];
//    if([model.pid integerValue] != 0){
//        model.ToUserModel = [reply_userInfo_model dicToModel:item_dic[@"to_user_info"]];
//    }
//    model.comment = item_dic[@"comment"];
//    model.ctime = item_dic[@"ctime"];
//
//    return model;
//}

@end
