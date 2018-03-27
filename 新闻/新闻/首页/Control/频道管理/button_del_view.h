//
//  button_del_view.h
//  新闻
//
//  Created by chenjinzhi on 2018/3/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface button_del_view : UIView

@property (nonatomic,strong)UIButton* normal_button;
@property (nonatomic,strong)UIButton* del_button;
@property (nonatomic)BOOL isCurrentSelected;
@property (nonatomic)BOOL isSelectedBtn;//存储isCurrentSelected 值
@property (nonatomic)BOOL isEdit;

@property (nonatomic)CGRect m_frame;

@end
