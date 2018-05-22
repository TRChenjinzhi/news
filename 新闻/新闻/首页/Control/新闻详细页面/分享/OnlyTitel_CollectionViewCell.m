//
//  OnlyTitel_CollectionViewCell.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "OnlyTitel_CollectionViewCell.h"

@implementation OnlyTitel_CollectionViewCell{
    BOOL            selected;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    selected = NO;
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    title.layer.cornerRadius = 21;
    title.layer.borderWidth = 1;
    title.layer.borderColor =  [UIColor colorWithRed:245/255.0 green:246/255.0 blue:246/255.0 alpha:1/1.0].CGColor;
    title.layer.masksToBounds = YES;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    title.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:18];
    [title setBackgroundColor:[[ThemeManager sharedInstance] GetBackgroundColor]];
    [self addSubview:title];
    self.m_title = title;
    
}

-(void)setIsSelected:(BOOL)isSelected{
    if(!selected){//状态为 NO 时
        if(isSelected){
//            [self.m_title setBackgroundColor:[UIColor colorWithRed:255/255.0 green:212/255.0 blue:57/255.0 alpha:1/1.0]];
            [self.m_title setBackgroundColor:[Color_Image_Helper ImageChangeToColor:[UIImage imageNamed:@"btn"] AndNewSize:self.m_title.frame.size]];
            self.m_title.textColor = RGBA(255, 255, 255, 1);
            selected = isSelected;
        }
    }else{//状态为 yes 时
        if(!isSelected){
            [self.m_title setBackgroundColor:[[ThemeManager sharedInstance] GetBackgroundColor]];
            self.m_title.textColor = RGBA(34, 39, 39, 1);
            selected = isSelected;
        }
    }
}

@end
