//
//  button_del_view.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "button_del_view.h"

@implementation button_del_view

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    self.normal_button = [[UIButton alloc] initWithFrame:CGRectMake(0, 9, self.frame.size.width-9, self.frame.size.height-9)];
    self.normal_button.backgroundColor = RGBA(242, 242, 242, 1);
    [self.normal_button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.normal_button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.normal_button.layer setCornerRadius:4.0f];
    [self addSubview:self.normal_button];
    
    self.del_button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    self.del_button.center = CGPointMake(self.frame.size.width-9, 9);
    [self.del_button setImage:[UIImage imageNamed:@"edit_del"] forState:UIControlStateNormal];
}

-(void)setIsCurrentSelected:(BOOL)isCurrentSelected{
    if(isCurrentSelected){
        [self.normal_button setTitleColor:RGBA(248, 205, 4, 1) forState:UIControlStateNormal];
        [self.normal_button.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    }else{
        [self.normal_button setTitleColor:RGBA(78, 82, 82, 1) forState:UIControlStateNormal];
        [self.normal_button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
    self.isSelectedBtn = isCurrentSelected;
}

-(void)setIsEdit:(BOOL)isEdit{
    if(isEdit){
        [self addSubview:self.del_button];
    }else{
        [self.del_button removeFromSuperview];
    }
}

-(void)setM_frame:(CGRect)m_frame{
    self.frame = m_frame;
    self.normal_button.frame = CGRectMake(0, 9, self.frame.size.width-9, self.frame.size.height-9);
    self.del_button.center = CGPointMake(self.frame.size.width-9, 9);
}

@end
