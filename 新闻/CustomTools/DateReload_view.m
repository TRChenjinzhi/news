//
//  DateReload_view.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DateReload_view.h"

@implementation DateReload_view

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backgroundView];
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(60, 181, SCREEN_WIDTH-60-60, 40)];
//    [self.button setBackgroundColor:[UIColor colorWithRed:248/255.0 green:205/255.0 blue:4/255.0 alpha:1/1.0]];
    [self.button setTitle:@"点我重新加载" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:16]];
    [self addSubview:self.button];
}

-(void)setTitle:(NSString *)title{
    [self.button setTitle:title forState:UIControlStateNormal];
}

@end
