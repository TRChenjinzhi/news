//
//  BadgeButton.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BadgeButton.h"

@implementation BadgeButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    self = [super init];
    if(self){
        _badgeLabel = [[UILabel alloc]init];
        _badgeLabel.backgroundColor = [UIColor redColor];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:10];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.clipsToBounds = YES;
        [self addSubview:_badgeLabel];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _badgeLabel = [[UILabel alloc]init];
        _badgeLabel.backgroundColor = [UIColor redColor];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:10];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.clipsToBounds = YES;
        [self addSubview:_badgeLabel];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setsubFrame];
}

-(void)setCount:(NSInteger)count{
    _count = count;
    [self setsubFrame];
}

-(void)setsubFrame{
    NSInteger labelHight = 6;
    NSInteger labelWidth = 6;
    
    //显示 内容
    [self showText];
    
    //badge 的方位
    if (false) {
        labelHight = 8;
        labelWidth = 8;
    }else{
        //只要小红点 所以宽度就固定了
//        labelHight = 10;
//        labelWidth = [_badgeLabel sizeThatFits:CGSizeMake(MAXFLOAT, labelHight)].width + 5;
//        if (labelWidth > 40) {
//            labelWidth = 40;
//        }
//        if (labelWidth < labelHight){
//            labelWidth = labelHight;
//        }
    }

    _badgeLabel.frame = CGRectMake(0, 0, labelWidth, labelHight);
    _badgeLabel.layer.cornerRadius = labelHight/2;
    
    if(self.imageView.image){
        CGPoint center = CGPointMake(CGRectGetMaxX(self.imageView.frame)-labelWidth/2, self.imageView.frame.origin.y+labelHight/2);
        _badgeLabel.center = center;
    }else{
        CGPoint center = CGPointMake(self.bounds.size.width, self.bounds.origin.y);
        _badgeLabel.center = center;
    }
    
}
-(void)showText{
    if(_count <= 0){
        _badgeLabel.hidden = YES;
    }
    else{
        _badgeLabel.hidden = NO;
        
        if(_count < 100){
//            NSString* str = [NSString stringWithFormat:@"%ld",_count];
            NSString* str = [NSString stringWithFormat:@" "];//只要小红点
            _badgeLabel.text = str;
        }else{
//            _badgeLabel.text = @"99+";
            _badgeLabel.text = @" ";
        }
    }
}

@end
