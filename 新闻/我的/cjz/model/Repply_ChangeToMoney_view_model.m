//
//  Repply_ChangeToMoney_view_model.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Repply_ChangeToMoney_view_model.h"

@implementation Repply_ChangeToMoney_view_model{
    UILabel*        m_title;
    UIView*         m_subTitle_view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    
    self.backgroundColor = [[ThemeManager sharedInstance] Repply_ChangeToMoney_ModelBackgroundColor];
    
    UILabel* title      = [[UILabel alloc] initWithFrame:CGRectMake(16, 17, 100, 14)];
    title.textColor     = [[ThemeManager sharedInstance] Repply_ChangeToMoney_titleColor];
    title.font          = [UIFont systemFontOfSize:14];
    title.textAlignment = NSTextAlignmentLeft;
    m_title = title;
    [self addSubview:m_title];
    
//    UIView* subTitle      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16-100, 16, 100, 14)];
//    subTitle.textColor     = [[ThemeManager sharedInstance] Repply_ChangeToMoney_titleColor];
//    subTitle.font          = [UIFont systemFontOfSize:14];
//    subTitle.textAlignment = NSTextAlignmentRight;
//    m_subTitle_view = subTitle;
//    [self addSubview:m_subTitle_view];
    
    
    UIView* line           = [[UIView alloc] initWithFrame:CGRectMake(16, self.frame.size.height-1, SCREEN_WIDTH-16-16, 1)];
    line.backgroundColor   = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [self addSubview:line];
}

-(void)setTitle:(NSString *)title{
    m_title.text = title;
}

-(void)setSubTitle_text:(NSString *)subTitle_text{
    UILabel* subTitle      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16-100, 16, 100, 14)];
    subTitle.textColor     = [[ThemeManager sharedInstance] Repply_ChangeToMoney_titleColor];
    subTitle.font          = [UIFont systemFontOfSize:14];
    subTitle.textAlignment = NSTextAlignmentRight;
    subTitle.text          = subTitle_text;
    
    _m_label = subTitle;
//    [m_subTitle_view addSubview:subTitle];
    
    [self addSubview:subTitle];
//    [self layoutIfNeeded];
}

-(void)setSubTitle_TextFilePlaceHold_text:(NSString *)subTitle_TextFilePlaceHold_text{
    UITextField* subTitle_textField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16-100, 16, 100, 14)];
    subTitle_textField.textColor    = [[ThemeManager sharedInstance] Repply_ChangeToMoney_titleColor];
    subTitle_textField.textAlignment= NSTextAlignmentRight;
    subTitle_textField.font         = [UIFont systemFontOfSize:14];
    subTitle_textField.placeholder  = subTitle_TextFilePlaceHold_text;
    
    _m_textField = subTitle_textField;
//    [m_subTitle_view addSubview:subTitle_textField];
    
    [self addSubview:subTitle_textField];
//    [self layoutIfNeeded];
}

@end
