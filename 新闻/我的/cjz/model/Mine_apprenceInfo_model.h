//
//  Mine_apprenceInfo_model.h
//  新闻
//
//  Created by chenjinzhi on 2018/3/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mine_apprenceInfo_model : NSObject

@property (nonatomic,strong)NSString* income;
@property (nonatomic,strong)NSString* date;

+(NSMutableArray*)dicToArray:(NSDictionary*)dic;

@end
