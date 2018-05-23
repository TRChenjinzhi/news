//
//  Mine_userInfo_view.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Mine_userInfo_view : UIView

@property (nonatomic,strong)NSString* title;
@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSString* icon;
@property (nonatomic)BOOL isImg;//判断是图片还是name
@property (nonatomic)BOOL isNext;// 是否需要 右箭头
@property (nonatomic,strong)UIView* m_view_shifu;

@property (nonatomic,strong)UIView* click_view;

@end
