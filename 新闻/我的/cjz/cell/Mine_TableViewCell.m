//
//  Mine_TableViewCell.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_TableViewCell.h"


@implementation Mine_TableViewCell{
    UIImageView* img;
    UILabel* label;
    UIImageView* jiantou;
    UIView* line;
}

+(instancetype)cellForTableView:(UITableView *)tabelView AndId:(NSString *)ID{
    Mine_TableViewCell* cell = [tabelView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[Mine_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

+(CGFloat)HightForCell{
    return 60.0;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;//去除点击效果
    self.selected = NO;//去除选中效果
    if(!img){
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(17.5, 21.5, 17, 17)];
        
        img = imgView;
        [self addSubview:img];
    }
    
    if(!label){
        UILabel* lable_label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(img.frame)+9.5, 22, 150, 16)];
        lable_label.textAlignment = NSTextAlignmentLeft;
        lable_label.font = [UIFont systemFontOfSize:16];
        lable_label.textColor = [[ThemeManager sharedInstance] MineCellLabelColor];
        lable_label.text = @"测试";
        
        label = lable_label;
        [self addSubview:label];
    }
    
    if(!jiantou){
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16-16, 22, 16, 16)];
        [imgView setImage:[UIImage imageNamed:@"ic_list_next"]];
        
        jiantou = imgView;
        [self addSubview:jiantou];
    }
    
    if(!line){
        UIView* line_view = [[UIView alloc] initWithFrame:CGRectMake(16, 59, SCREEN_WIDTH-16-16, 1)];
        line_view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1/1.0];
        
        line = line_view;
        [self addSubview:line];
    }
    
}

-(void)setModel:(Mine_model *)model{
    [img setImage:[UIImage imageNamed:model.title_img]];
    label.text = model.title;
    
//    [self layoutIfNeeded];
}

@end
