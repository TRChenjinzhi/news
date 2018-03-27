//
//  FloatView.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FloatView.h"

@implementation FloatView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    
    UIButton* close_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-16, 0, 16, 16)];
    [close_btn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [close_btn setBackgroundColor:RGBA(251, 84, 38, 1)];
    [close_btn.layer setCornerRadius:16/2];
    [self addSubview:close_btn];
    self.close_btn = close_btn;
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 16, self.frame.size.width, self.frame.size.height-16)];
    [btn setImage:[UIImage imageNamed:@"box"] forState:UIControlStateNormal];
    [self addSubview:btn];
    self.box_btn = btn;
    
    //创建动画
    CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
    keyAnimaion.keyPath = @"transform.rotation";
    keyAnimaion.values = @[@(-5 / 180.0 * M_PI),@(5 /180.0 * M_PI),@(-5/ 180.0 * M_PI)];//度数转弧度
    
    keyAnimaion.removedOnCompletion = NO;
    keyAnimaion.fillMode = kCAFillModeForwards;
    keyAnimaion.duration = 0.3;
    keyAnimaion.repeatCount = 3;
    [btn.layer addAnimation:keyAnimaion forKey:nil];

}

@end
