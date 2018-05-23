//
//  Mine_ChangToMoney_cell_model.h
//  新闻
//
//  Created by chenjinzhi on 2018/3/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mine_ChangToMoney_cell_model : NSObject

@property (nonatomic,strong)NSString* time;
@property (nonatomic,strong)NSString* ID;
@property (nonatomic,strong)NSString* moeny;
@property (nonatomic,strong)NSString* state;
@property (nonatomic,strong)NSString* type;
@property (nonatomic,strong)NSString* withDraw_type;//1是成功0是未提现成功

+(NSArray*)dicToModelArray:(NSDictionary*)dic;

@end
