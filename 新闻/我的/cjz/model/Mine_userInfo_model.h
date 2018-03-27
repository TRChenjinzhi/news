//
//  Mine_userInfo_model.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mine_userInfo_model : NSObject

@property (nonatomic,strong)NSString* icon;
@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSString* sex;

@property (nonatomic)NSInteger gold;
@property (nonatomic)CGFloat package;
@property (nonatomic)NSInteger apprentice;

@property (nonatomic)BOOL IsLogin;

@end
