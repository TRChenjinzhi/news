//
//  Button_color.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Button_color.h"

@implementation Button_color{
    UIView*     m_backgroundView;
    NSString*   m_text;
    CAGradientLayer*    m_layer;
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
    self.userInteractionEnabled = YES;
    //view
    UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    m_backgroundView = backgroundView;
    [self addSubview:backgroundView];
    
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:255.0/255 green:181.0/255 blue:70.0/255 alpha:1.0/1].CGColor,
//                             (__bridge id)[UIColor colorWithRed:251.0/255 green:218.0/255 blue:96.0/255 alpha:1.0/1].CGColor];
//    gradientLayer.locations = @[@0, @1];
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(1.0, 0);
//    gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//
//    [m_backgroundView.layer addSublayer:gradientLayer];
    
    [self initLable];
}

-(void)initLable{
    //label
    UILabel* title_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    title_label.userInteractionEnabled = YES;
    title_label.text = @"123123123";
    title_label.textAlignment = NSTextAlignmentCenter;
    self.title = title_label;
    [m_backgroundView addSubview:title_label];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction)];
    [self.title addGestureRecognizer:self.tap];

}

-(void)GetColorLayer:(CGRect)frame{
    if(!m_layer){
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:255.0/255 green:181.0/255 blue:70.0/255 alpha:1.0/1].CGColor,
                                 (__bridge id)[UIColor colorWithRed:251.0/255 green:218.0/255 blue:96.0/255 alpha:1.0/1].CGColor];
        gradientLayer.locations = @[@0, @1];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1.0, 0);
        gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        m_layer = gradientLayer;
        [m_backgroundView.layer addSublayer:gradientLayer];
    }
    
    
}

-(void)setBorderColor:(UIColor *)borderColor{
    m_backgroundView.layer.borderColor = borderColor.CGColor;
    self.title.layer.borderColor = borderColor.CGColor;
}
-(void)setCornerWidth:(CGFloat)cornerWidth{
    m_backgroundView.layer.borderWidth = cornerWidth;
    self.title.layer.borderWidth = cornerWidth;
}
-(void)setCornerRadius:(CGFloat)cornerRadius{
    m_backgroundView.layer.cornerRadius = cornerRadius;
    m_backgroundView.layer.masksToBounds = YES;
    self.title.layer.cornerRadius = cornerRadius;
    self.title.layer.masksToBounds = YES;
}

-(void)SetNormalButton:(NSString*)name{
    m_text = name;
    self.title.text = name;
    self.title.textColor = [UIColor colorWithRed:78/255.0 green:82/255.0 blue:82/255.0 alpha:1/1.0];
    self.title.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:14];
    self.borderColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    self.cornerWidth = 1;
    self.cornerRadius = 21;
    [self.layer layoutIfNeeded];
}
-(void)SetSelectedButton:(NSString*)name{
    self.title.text = name;
    self.title.textColor = [UIColor whiteColor];
    self.title.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:14];
    self.borderColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    self.cornerWidth = 0;
    self.cornerRadius = 21;
}

-(void)buttonAction{
    
    [self.title removeFromSuperview];
    
    if(!self.isSelected){
        [self GetColorLayer:self.frame];
    }else{
        [m_layer removeFromSuperlayer];
        m_layer = nil;
    }
    
    [self initLable];
    
    if(!self.isSelected){
        [self GetColorLayer:self.frame];
        [self SetSelectedButton:self.title.text];
        self.title.text = m_text;
        self.isSelected = YES;
    }else{
        [self SetNormalButton:m_text];
        self.isSelected = NO;
    }
    
    //通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"喜爱的频道选择" object:nil];

}

-(void)ChangeToSelectedState{
    [self.title removeFromSuperview];
    
    if(self.isSelected){
        [self GetColorLayer:self.frame];
    }else{
        [m_layer removeFromSuperlayer];
        m_layer = nil;
    }
    
    [self initLable];
    
    if(self.isSelected){
        [self GetColorLayer:self.frame];
        [self SetSelectedButton:self.title.text];
        self.title.text = m_text;
        self.isSelected = YES;
    }else{
        [self SetNormalButton:m_text];
        self.isSelected = NO;
    }
}

@end
