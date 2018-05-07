//
//  ZhiFuBtn.m
//  新闻
//
//  Created by chenjinzhi on 2018/4/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZhiFuBtn.h"

@implementation ZhiFuBtn{
    UIImageView*        m_imgV;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initView:frame];
    }
    return self;
}

-(void)initView:(CGRect)frame{
    m_imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [m_imgV setImage:[UIImage imageNamed:@"corner_check"]];
    [m_imgV setContentMode:UIViewContentModeTopRight];
    [self addSubview:m_imgV];
    
    self.m_btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.m_btn.titleLabel setFont:kFONT(14)];
    [self.m_btn.layer setCornerRadius:kWidth(3)];
    [self.m_btn.layer setBorderWidth:kWidth(1)];
    [self addSubview:self.m_btn];
}

-(void)setBtn_text:(NSString *)btn_text{
    [self.m_btn setTitle:btn_text forState:UIControlStateNormal];
}

-(void)setBtn_IsSelected:(BOOL)btn_IsSelected{
    _btn_IsSelected = btn_IsSelected;
    if(btn_IsSelected){
        [self.m_btn setTitleColor:RGBA(251, 84, 38, 1) forState:UIControlStateNormal];
        [self.m_btn.layer setBorderColor:RGBA(251, 84, 38, 1).CGColor];
        [m_imgV setHidden:NO];
    }
    else{
        [self.m_btn setTitleColor:RGBA(34, 39, 39, 1) forState:UIControlStateNormal];
        [self.m_btn.layer setBorderColor:RGBA(34, 39, 39, 1).CGColor];
        [m_imgV setHidden:YES];
    }
}

@end
