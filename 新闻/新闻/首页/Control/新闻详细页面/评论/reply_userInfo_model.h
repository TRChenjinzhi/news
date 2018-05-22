//
//  reply_userInfo_model.h
//  橙子快报
//
//  Created by chenjinzhi on 2018/5/17.
//  Copyright © 2018年 apple. All rights reserved.
//

/*
 "user_info":{
 "user_id":"xxxxx",
 "user_name":"橙友8717165",
 "user_icon":"",
 "wechat_nickname":"守候",
 "wechat_icon":"http://thirdwx.qlogo.cn/mmopen/vi_32/EKagrrV6YQUwH2MKmiczK2ZjQDYlJdoGYD9ylz6hIvUNoxX9ukJ5PoV3cAXroKqEiaY6K6UU6zz76E2sLyQlTGkA/132"
 }
 */

#import <Foundation/Foundation.h>

@interface reply_userInfo_model : NSObject

@property (nonatomic,strong)NSString* user_id;
@property (nonatomic,strong)NSString* user_name;
@property (nonatomic,strong)NSString* user_icon;
@property (nonatomic,strong)NSString* wechat_icon;
@property (nonatomic,strong)NSString* wechat_nickname;

+(reply_userInfo_model*)dicToModel:(NSDictionary*)dic;

@end
