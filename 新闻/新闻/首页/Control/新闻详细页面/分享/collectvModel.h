//
//  collectvModel.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface collectvModel : NSObject

@property (nonatomic,strong)NSArray* name_array;
@property (nonatomic,strong)NSArray* imgs_array;

@property (nonatomic)NSInteger lineInstance;//行间距
@property (nonatomic)NSInteger itemInstance;//item间距
@property (nonatomic)UIEdgeInsets edge;//item距离边框距离
@property (nonatomic)CGSize size;//item大小

@property (nonatomic)NSInteger itemsOfLine;//每行的item数量

@property (nonatomic)BOOL IsOnlyTitle;//只有文字没有图片
@property (nonatomic,strong)NSString* type;//只有文字 的类型
@property (nonatomic,strong)NSArray* array_Selected;//被选中的数组
@property (nonatomic)BOOL IsOnlyOneSected;;//是否单选

@end
