//
//  Mine_TableViewCell.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_TableViewCell.h"


@implementation Mine_TableViewCell{
    UIImageView*        img;
    UILabel*            label;
    UIImageView*        jiantou;
    UIView*             line;
    UILabel*            m_subTitle;
}

+(instancetype)cellForTableView:(UITableView *)tabelView AndId:(NSString *)ID{
    Mine_TableViewCell* cell = [tabelView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[Mine_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

+(CGFloat)HightForCell{
    return kWidth(60);
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
        UIImageView* imgView = [UIImageView new];
        img = imgView;
        [self addSubview:img];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(kWidth(16));
            make.width.and.height.mas_offset(kWidth(20));
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    
    if(!label){
        UILabel* lable_label = [UILabel new];
        lable_label.textAlignment = NSTextAlignmentLeft;
        lable_label.font = kFONT(16);
        lable_label.textColor = [[ThemeManager sharedInstance] MineCellLabelColor];
        lable_label.text = @"测试";
        
        label = lable_label;
        [self addSubview:label];
        [lable_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(img.mas_right).with.offset(kWidth(10));
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_offset(kWidth(16));
        }];
    }
    
    if(!jiantou){
        UIImageView* imgView = [UIImageView new];
        [imgView setImage:[UIImage imageNamed:@"ic_list_next"]];
        
        jiantou = imgView;
        [self addSubview:jiantou];
        [jiantou mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-kWidth(16));
            make.width.and.height.mas_offset(kWidth(16));
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    
    if(!m_subTitle){
        m_subTitle = [UILabel new];
        m_subTitle.textAlignment = NSTextAlignmentRight;
        m_subTitle.font = kFONT(14);
        m_subTitle.textColor = RGBA(251, 84, 38, 1);
        m_subTitle.text = @"测试";
        [self addSubview:m_subTitle];
        [m_subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(jiantou.mas_left).with.offset(-kWidth(0));
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_offset(kWidth(14));
        }];
    }
    
    if(!line){
        UIView* line_view = [[UIView alloc] initWithFrame:CGRectMake(kWidth(16), kWidth(60)-kWidth(1), SCREEN_WIDTH-kWidth(16)-kWidth(16), kWidth(1))];
        line_view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1/1.0];
        
        line = line_view;
        [self addSubview:line];
    }
    
}

-(void)setModel:(Mine_model *)model{
    [img setImage:[UIImage imageNamed:model.title_img]];
    label.text = model.title;
    
    m_subTitle.text = model.subTitle;
    
//    [self layoutIfNeeded];
}

@end
