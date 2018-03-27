//
//  collectionCell.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "collectionCell.h"
#import "ThemeManager.h"

@implementation collectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
    imgView.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
    [self addSubview:imgView];
    self.imgView = imgView;
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 48+8, 48, 12)];
    label.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
}

@end
