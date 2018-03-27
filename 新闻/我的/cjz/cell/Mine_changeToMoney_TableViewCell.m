//
//  Mine_changeToMoney_TableViewCell.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_changeToMoney_TableViewCell.h"

@implementation Mine_changeToMoney_TableViewCell{
    UILabel*        m_lable_title;
    UILabel*        m_lable_time;
    UILabel*        m_lable_money;
    UILabel*        m_lable_state;
}

+(instancetype)cellForTableView:(UITableView *)tabelView{
    NSString* str_id = @"Mine_changeToMoney_cell";
    Mine_changeToMoney_TableViewCell* cell = [tabelView dequeueReusableCellWithIdentifier:str_id];
    if(!cell){
        cell = [[Mine_changeToMoney_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str_id];
    }
    return cell;
}

+(CGFloat)HightForCell{
    return 64.0;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 32, 32)];
    [img setImage:[UIImage imageNamed:@"ic_take_detail"]];
    [self addSubview:img];
    
    m_lable_title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(img.frame)+8, 16, 80, 14)];
    m_lable_title.textColor = RGBA(39, 39, 39, 1);
    m_lable_title.textAlignment = NSTextAlignmentLeft;
    m_lable_title.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:m_lable_title];
    
    m_lable_time = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(img.frame)+8, CGRectGetMaxY(m_lable_title.frame)+6, 120, 12)];
    m_lable_time.textColor = RGBA(135, 138, 138, 1);
    m_lable_time.textAlignment = NSTextAlignmentLeft;
    m_lable_time.font = [UIFont systemFontOfSize:12];
    [self addSubview:m_lable_time];
    
    m_lable_money = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-17-70, 16, 70, 14)];
    m_lable_money.textColor = RGBA(251, 84, 38, 1);
    m_lable_money.textAlignment = NSTextAlignmentRight;
    m_lable_money.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:m_lable_money];
    
    m_lable_state = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-17-70, CGRectGetMaxY(m_lable_title.frame)+6, 70, 12)];
    m_lable_state.textColor = RGBA(135, 138, 138, 1);
    m_lable_state.textAlignment = NSTextAlignmentRight;
    m_lable_state.font = [UIFont systemFontOfSize:12];
    [self addSubview:m_lable_state];
}

-(void)setModel:(Mine_ChangToMoney_cell_model *)model{
    NSString* title = @"";
    NSInteger type = [model.type integerValue];
    switch (type) {
        case 1:
            title = @"支付宝";
            break;
        case 2:
            title = @"微信";
            break;
        case 3:
            title = @"话费提现";
            break;
            
        default:
            break;
    }
    
    m_lable_title.text = title;
    CGFloat money = [model.moeny floatValue];
    m_lable_money.text = [NSString stringWithFormat:@"%.2f元",money];
    m_lable_time.text = [[TimeHelper share] GetDateFromString_yyMMDD_HHMMSS:model.time];
    m_lable_state.text = model.state;
}

@end
