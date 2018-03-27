//
//  ShareSetting_view.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShareSetting_view.h"

@implementation ShareSetting_view{
    
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
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Hide) name:@"取消" object:nil];
    
    //灰色 遮罩层
    UIView* dim = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //给遮罩添加手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [dim addGestureRecognizer:tap];
    dim.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4/1.0];
    self.dimView = dim;
    [self addSubview:dim];
    
    //移动层
//    moveView_hight = 248;
//    UIView* move_view = [[UIView alloc] initWithFrame:CGRectMake(0 , SCREEN_HEIGHT+moveView_hight, SCREEN_WIDTH, moveView_hight)];
//    move_view.backgroundColor = [UIColor greenColor];
//    self.moveView = move_view;
    
}

//-(void)setMoveView:(UIView *)moveView{
//    self.moveView.frame = moveView.frame;
//    [self.moveView addSubview:moveView];
//    [self addSubview:self.moveView];
//    moveView_hight = moveView.frame.size.height;
//}


+(ShareSetting_view*)GetDialogView:(CGRect)frame withCusomView:(UIView *)cunstomView{
    ShareSetting_view* dialog = [[ShareSetting_view alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    NSLog(@"frame.or.y-->%f",frame.origin.y);
    dialog.moveView = cunstomView;
    dialog.moveView.frame = frame;
    dialog.moveView_hight = frame.size.height;
    
    [dialog addSubview:dialog.moveView];
    
    return dialog;
    
}

-(void)tapClick:(UITapGestureRecognizer*)tap{
    [self Hide];
}

-(void)Show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.28 animations:^{
        CGRect frame = CGRectMake(0, SCREEN_HEIGHT-_moveView_hight, SCREEN_WIDTH, _moveView_hight);
        self.moveView.frame = frame;
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.28 animations:^{
            _dimView.alpha = .6;
        }completion:^(BOOL finished) {
            
        }];
    }];
}

-(void)Hide{
    [UIView animateWithDuration:.28 animations:^{
        _dimView.alpha = 0;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:.28 animations:^{
            CGRect frame = CGRectMake(0 , SCREEN_HEIGHT+_moveView_hight, SCREEN_WIDTH, _moveView_hight);
            self.moveView.frame = frame;
            [self layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
    }];
}

@end
