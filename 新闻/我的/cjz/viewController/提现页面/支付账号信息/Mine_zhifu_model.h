//
//  Mine_zhifu_model.h
//  新闻
//
//  Created by chenjinzhi on 2018/4/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mine_zhifu_model : NSObject

@property (nonatomic,strong)NSString* ali_name;
@property (nonatomic,strong)NSString* ali_num;
@property (nonatomic,strong)NSString* wechat_name;

@property (nonatomic)BOOL isGetDataFromLocal;

+(instancetype)share;

+(NSDictionary*)modelToDic:(Mine_zhifu_model*)model;
+(void)dicToModel:(NSDictionary*)dic;

@end
