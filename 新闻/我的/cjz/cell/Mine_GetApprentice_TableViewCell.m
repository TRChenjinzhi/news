//
//  Mine_GetApprentice_TableViewCell.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_GetApprentice_TableViewCell.h"

@implementation Mine_GetApprentice_TableViewCell{
    UIImageView*        m_img;
    UILabel*            m_title;
    UILabel*            m_ShouTutime;
    UILabel*            m_activity_time;
    UILabel*            m_money;

}

+(instancetype)CellForTableView:(UITableView*)tabelView{
    NSString* str_id = @"Mine_GetApprentice_cell";
    Mine_GetApprentice_TableViewCell* cell = [tabelView dequeueReusableCellWithIdentifier:str_id];
    if(!cell){
        cell = [[Mine_GetApprentice_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str_id];
    }
    return cell;
}

+(CGFloat)HightForCell{
    return kWidth(76.0);
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backgroundView.backgroundColor = [[ThemeManager sharedInstance] Mine_MyApprentice_backgroundColor];
    
    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth(16), kWidth(16), kWidth(44), kWidth(44))];
    [img.layer setCornerRadius:kWidth(44)/2];
    img.layer.masksToBounds = YES;
    m_img = img;
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(img.frame)+kWidth(8), kWidth(16), kWidth(150), kWidth(14))];
    title.textAlignment = NSTextAlignmentLeft;
    title.textColor = [[ThemeManager sharedInstance] Mine_MyApprentice_titleColor];
    title.font = [UIFont boldSystemFontOfSize:kWidth(14)];
    m_title = title;
    
    UILabel* time = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(img.frame)+kWidth(8), CGRectGetMaxY(title.frame)+kWidth(6), kWidth(150), kWidth(12))];
    time.textAlignment = NSTextAlignmentLeft;
    time.textColor = [[ThemeManager sharedInstance] Mine_MyApprentice_timeColor];
    time.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:kWidth(12)];
    m_ShouTutime = time;
    
    UILabel* activity_time = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(img.frame)+kWidth(8), CGRectGetMaxY(time.frame)+kWidth(6), kWidth(150), kWidth(12))];
    activity_time.textAlignment = NSTextAlignmentLeft;
    activity_time.textColor = [[ThemeManager sharedInstance] Mine_MyApprentice_timeColor];
    activity_time.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:kWidth(12)];
    m_activity_time = activity_time;
    
    UIImageView* img_next = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-kWidth(16)-kWidth(16), kWidth(24), kWidth(16), kWidth(22))];
    [img_next setImage:[UIImage imageNamed:@"ic_list_next"]];
    
    UILabel* lable_money = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(img_next.frame)-kWidth(4)-kWidth(60), kWidth(76)/2-kWidth(14+2), kWidth(60), kWidth(14))];
    lable_money.textAlignment = NSTextAlignmentRight;
    lable_money.textColor = [[ThemeManager sharedInstance] Mine_MyApprentice_stateColor];
    lable_money.font = kFONT(14);
    m_money = lable_money;
    
    UILabel* lable_money_tips = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(img_next.frame)-kWidth(4)-kWidth(60),CGRectGetMaxY(lable_money.frame)+kWidth(5), kWidth(60), kWidth(14))];
    lable_money_tips.textAlignment = NSTextAlignmentRight;
    lable_money_tips.textColor = RGBA(135, 138, 138, 1);
    lable_money_tips.font = [UIFont systemFontOfSize:font(11)];
    lable_money_tips.text = @"累计贡献";
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, kWidth(76)-1, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1/1.0];
    
    [backgroundView addSubview:img];
    [backgroundView addSubview:title];
    [backgroundView addSubview:time];
    [backgroundView addSubview:m_activity_time];
    [backgroundView addSubview:img_next];
    [backgroundView addSubview:lable_money];
    [backgroundView addSubview:lable_money_tips];
    [backgroundView addSubview:line];
    
    [self addSubview:backgroundView];
}

-(void)setModel:(Mine_GetApprentice_model *)model{
    [m_img sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"list_avatar"]];
    [m_img.layer setCornerRadius:m_img.frame.size.width/2];
    m_title.text = model.name;
    m_ShouTutime.text = [NSString stringWithFormat:@"收徒时间: %@",[[TimeHelper share] GetDateFromString_YYYYMMDD:model.time]];
    m_activity_time.text = [NSString stringWithFormat:@"最后活跃: %@",[[TimeHelper share] GetDateFromString_YYYYMMDD:model.last_login_time]];
    m_money.text = [NSString stringWithFormat:@"%@元",model.slaver_income];

}

@end
