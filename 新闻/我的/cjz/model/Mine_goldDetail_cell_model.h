//
//  Mine_goldDetail_cell.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mine_goldDetail_cell_model : NSObject

@property (nonatomic,strong)NSString* title;
@property (nonatomic,strong)NSString* time;
@property (nonatomic)float count;
@property (nonatomic)BOOL isGold;

+(NSArray*)dicToModelArray:(NSDictionary*)dic;
+(NSArray*)dicToModelArray_package:(NSDictionary*)dic;

@end
