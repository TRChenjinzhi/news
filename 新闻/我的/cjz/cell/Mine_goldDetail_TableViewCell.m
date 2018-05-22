//
//  Mine_goldDetail_TableViewCell.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_goldDetail_TableViewCell.h"

@implementation Mine_goldDetail_TableViewCell{
    Mine_goldDetail_cell_model* m_cell_model;
    UILabel*        m_title;
    UILabel*        m_time;
    UILabel*        m_count;
}

+(instancetype)cellForTableView:(UITableView *)tabelView{
    NSString* str_id = @"Mine_goldDetail_cell";
    Mine_goldDetail_TableViewCell* cell = [tabelView dequeueReusableCellWithIdentifier:str_id];
    if(!cell){
        cell = [[Mine_goldDetail_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str_id];
    }
    return cell;
}

+(CGFloat)HightForCell{
    return 48.0;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    //title
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(16, 18, 100, 12)];
    title.textColor = [UIColor colorWithRed:135/255.0 green:138/255.0 blue:138/255.0 alpha:1/1.0];
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:12];
    title.text = m_cell_model.title;
    m_title = title;
    [self addSubview:m_title];
    
    //count
    UILabel* count = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16-50, 16, 50, 16)];
    count.textColor = [UIColor colorWithRed:255/255.0 green:129/255.0 blue:3/255.0 alpha:1/1.0];
    count.textAlignment = NSTextAlignmentRight;
    count.font = [UIFont boldSystemFontOfSize:12];
    count.text = [NSString stringWithFormat:@"%.2f",m_cell_model.count];

    m_count = count;
    [self addSubview:m_count];
    
    //time
    NSInteger width = SCREEN_WIDTH-80-50;
    UILabel* time = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-width/2, 18, width, 12)];
    time.textColor = [UIColor colorWithRed:135/255.0 green:138/255.0 blue:138/255.0 alpha:1/1.0];
    time.textAlignment = NSTextAlignmentCenter;
    time.font = [UIFont systemFontOfSize:12];
    time.text = m_cell_model.time;
    m_time = time;
    [self addSubview:m_time];
    
    //line
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(16, 48-1, SCREEN_WIDTH-16-16, 1)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [self addSubview:line];
}

-(void)setCell_model:(Mine_goldDetail_cell_model *)cell_model{
    m_cell_model = cell_model;
    m_title.text = m_cell_model.title;
    m_time.text = [[TimeHelper share] dateChangeToString_YYYYMMDDHHMM:m_cell_model.time];
//    m_count.text = [NSString stringWithFormat:@"%ld",m_cell_model.count];
    if(cell_model.isGold){
        if(m_cell_model.count >= 0){
            m_count.text = [NSString stringWithFormat:@"+%.0f",m_cell_model.count];
        }else{
            m_count.text = [NSString stringWithFormat:@"%.0f",m_cell_model.count];
        }
        return;
    }
    if(m_cell_model.count >= 0){
        m_count.text = [NSString stringWithFormat:@"+%.2f",m_cell_model.count];
    }else{
        m_count.text = [NSString stringWithFormat:@"%.2f",m_cell_model.count];
    }
}

@end
