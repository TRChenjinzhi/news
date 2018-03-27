//
//  Mine_apprenceIncome_TableViewCell.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_apprenceIncome_TableViewCell.h"

@implementation Mine_apprenceIncome_TableViewCell{
    UILabel*        m_date;
    UILabel*        m_money;
}

+(instancetype)cellForTableView:(UITableView *)tabelView{
    NSString* str_id = @"Mine_apprenceIncome_cell";
    Mine_apprenceIncome_TableViewCell* cell = [tabelView dequeueReusableCellWithIdentifier:str_id];
    if(!cell){
        cell = [[Mine_apprenceIncome_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str_id];
    }
    return cell;
}

+(CGFloat)HightForCell{
    return kWidth(40);
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    CGFloat cellHeight = kWidth(40);
    
    m_date = [[UILabel alloc] initWithFrame:CGRectMake(kWidth(16), cellHeight/2-kWidth(10)/2, kWidth(120), kWidth(10))];
    m_date.textColor = RGBA(135, 138, 138, 1);
    m_date.textAlignment = NSTextAlignmentLeft;
    m_date.font = kFONT(10);
    [self addSubview:m_date];
    
    m_money = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-kWidth(16)-kWidth(100), cellHeight/2-kWidth(10)/2, kWidth(100), kWidth(10))];
    m_money.textColor = RGBA(135, 138, 138, 1);
    m_money.textAlignment = NSTextAlignmentRight;
    m_money.font = kFONT(10);
    [self addSubview:m_money];
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight-1, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGBA(242, 242, 242, 1);
    [self addSubview:line];
}

-(void)setModel:(Mine_apprenceInfo_model *)model{
    m_date.text = [[TimeHelper share] GetDateFromString_YYYYMMDD:model.date];
    m_money.text = [NSString stringWithFormat:@"%@元",model.income];
}

@end
