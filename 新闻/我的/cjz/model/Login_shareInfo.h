//
//  Login_shareInfo.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "shareinfo":{
 "title":"考拉试玩发钱啦，我刚刚又提现100块哦",
 "desc":"发钱啦，教你赚钱，无门槛，不收费。下载立得1元现金",
 "url":"http://api.198pai.com/web/apprentice/uid/10",
 "img":"http://cdnwww.larmor.cn/miguopai/share_icon.png"
 },
 */
@interface Login_shareInfo : NSObject

@property (nonatomic,strong)NSString* title;
@property (nonatomic,strong)NSString* desc;
@property (nonatomic,strong)NSString* url;
@property (nonatomic,strong)NSString* img;

@end
