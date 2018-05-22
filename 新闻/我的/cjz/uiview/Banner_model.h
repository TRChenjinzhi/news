//
//  Banner_model.h
//  橙子快报
//
//  Created by chenjinzhi on 2018/5/18.
//  Copyright © 2018年 apple. All rights reserved.
//

/*
 "id": "2",
 "name": "邀请收徒",
 "ad_url": "http:\/\/ad-manager.b0.upaiyun.com\/ad\/e47b1a4432538a8b629d552183e85b1d.png",
 "url": "http:\/\/younews.3gshow.cn\/api\/shoutu"
 */

#import <Foundation/Foundation.h>

@interface Banner_model : NSObject

@property (nonatomic,strong)NSString* ID;
@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSString* ad_url;
@property (nonatomic,strong)NSString* url;

@property (nonatomic,strong)NSMutableArray* array;

+(instancetype)share;

+(void)arrayToBannerArray:(NSArray*)array;
+(Banner_model*)dicToModel:(NSDictionary*)dic;

@end
