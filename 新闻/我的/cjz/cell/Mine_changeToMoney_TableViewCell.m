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
    UIImageView*    m_imgV;
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
    return kWidth(64);
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
    m_imgV = img;
    [self addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(kWidth(16));
        make.top.equalTo(self.mas_top).with.offset(kWidth(16));
        make.height.and.width.mas_offset(kWidth(32));
    }];
    
    m_lable_title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(img.frame)+8, 16, 80, 14)];
    m_lable_title.textColor = RGBA(39, 39, 39, 1);
    m_lable_title.textAlignment = NSTextAlignmentLeft;
    m_lable_title.font = KBFONT(14);
    [self addSubview:m_lable_title];
    [m_lable_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img.mas_right).with.offset(kWidth(8));
        make.top.equalTo(self.mas_top).with.offset(kWidth(16));
        make.height.mas_offset(kWidth(14));
    }];
    
    m_lable_time = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(img.frame)+8, CGRectGetMaxY(m_lable_title.frame)+6, kWidth(150), kWidth(12))];
    m_lable_time.textColor = RGBA(135, 138, 138, 1);
    m_lable_time.textAlignment = NSTextAlignmentLeft;
    m_lable_time.font = kFONT(12);
    [self addSubview:m_lable_time];
    [m_lable_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img.mas_right).with.offset(kWidth(8));
        make.top.equalTo(m_lable_title.mas_bottom).with.offset(kWidth(6));
        make.height.mas_offset(kWidth(12));
    }];
    
    m_lable_money = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-17-70, 16, 70, kWidth(14))];
    m_lable_money.textColor = RGBA(255, 129, 3, 1);
    m_lable_money.textAlignment = NSTextAlignmentRight;
    m_lable_money.font = KBFONT(14);
    [self addSubview:m_lable_money];
    [m_lable_money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-kWidth(16));
        make.top.equalTo(self.mas_top).with.offset(kWidth(16));
        make.height.mas_offset(kWidth(12));
    }];
    
    m_lable_state = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-17-70, CGRectGetMaxY(m_lable_title.frame)+6, 70, kWidth(12))];
    m_lable_state.textColor = RGBA(135, 138, 138, 1);
    m_lable_state.textAlignment = NSTextAlignmentRight;
    m_lable_state.font = kFONT(12);
    [self addSubview:m_lable_state];
    [m_lable_state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-kWidth(16));
        make.top.equalTo(m_lable_title.mas_bottom).with.offset(kWidth(6));
        make.height.mas_offset(kWidth(12));
    }];
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(kWidth(16), kWidth(64)-kWidth(1), SCREEN_WIDTH-kWidth(16)-kWidth(16), kWidth(1))];
    line.backgroundColor = RGBA(242, 242, 242, 1);
    [self addSubview:line];
}

-(void)setModel:(Mine_ChangToMoney_cell_model *)model{
    NSString* title = @"";
    NSInteger type = [model.type integerValue];
    switch (type) {
        case Ali:
            title = @"提现到支付宝";
            break;
        case Wechat:
            title = @"提现到微信";
            break;
        case Phone:
            title = @"提现到话费提现";
            break;
            
        default:
            break;
    }
    
//    m_lable_title.frame = CGRectMake(CGRectGetMaxX(m_imgV.frame)+8, 16, [LabelHelper GetLabelWidth:KBFONT(14) AndText:title], 14);
    m_lable_title.text = title;
    CGFloat money = [model.moeny floatValue];
    m_lable_money.text = [NSString stringWithFormat:@"%.2f元",money];
    m_lable_time.text = [[TimeHelper share] GetDateFromString_yyMMDD_HHMMSS:model.time];
    m_lable_state.text = model.state;
}

@end
