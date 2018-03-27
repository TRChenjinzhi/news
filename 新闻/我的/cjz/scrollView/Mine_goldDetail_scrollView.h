//
//  Mine_goldDetail_scrollView.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Money_model.h"

@interface Mine_goldDetail_scrollView : UIScrollView

@property (nonatomic,strong)NSArray* array_array_money_model;
@property (nonatomic,strong)NSArray* section_array;
@property (nonatomic,strong)Money_model* money_model;
@property (nonatomic)NSInteger selectIndex;

@end
