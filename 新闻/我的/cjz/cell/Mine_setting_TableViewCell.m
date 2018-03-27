//
//  Mine_setting_TableViewCell.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_setting_TableViewCell.h"

@implementation Mine_setting_TableViewCell{
    UILabel*        m_title;
    UILabel*        m_subTitle;
    UIImageView*    m_img;
    UIActivityIndicatorView*    m_waiting;
}

+(instancetype)cellForTableView:(UITableView *)tableView{
    NSString* str_id = @"Mine_setting_cell";
    Mine_setting_TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:str_id];
    if(!cell){
        cell = [[Mine_setting_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str_id];
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
    UILabel* title_label = [[UILabel alloc] initWithFrame:CGRectMake(16, 22, 150, 16)];
    title_label.textColor = [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    title_label.textAlignment = NSTextAlignmentLeft;
    title_label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:16];
    m_title = title_label;
    [self addSubview:title_label];
    
    UILabel* subTitle_label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16-90, 22, 90, 16)];
    subTitle_label.textColor = [UIColor colorWithRed:122/255.0 green:125/255.0 blue:125/255.0 alpha:1/1.0];
    subTitle_label.textAlignment = NSTextAlignmentRight;
    subTitle_label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:16];
    m_subTitle = subTitle_label;
    [self addSubview:subTitle_label];
    
    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16-16, 22, 16, 16)];
    [img setImage:[UIImage imageNamed:@"ic_list_next"]];
    m_img = img;
    [self addSubview:img];
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(16, 60-1, SCREEN_WIDTH-16-16, 1)];
    line.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1/1.0];
    [self addSubview:line];
    
    UIActivityIndicatorView* waiting_view = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16-16-30, 16, 30, 30)];
    waiting_view.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    waiting_view.backgroundColor = [UIColor grayColor];
    m_waiting = waiting_view;
}

-(void)setModel:(Mine_setting_model *)model{
    m_title.text = model.title;
    if([model.subTitle isEqualToString:@""]){
        [m_subTitle removeFromSuperview];
    }else{
        if(![model.subTitle isEqualToString:@"正在计算"]){
            [m_img removeFromSuperview];
            m_subTitle.frame = CGRectMake(SCREEN_WIDTH-16-16-90, 22, 90, 16);
            m_subTitle.text = model.subTitle;
        }else{
            [self addSubview:m_waiting];
            [m_waiting startAnimating];
            m_subTitle.frame = CGRectMake(SCREEN_WIDTH-16-16-90-30, 22, 90, 16);
            m_subTitle.text = model.subTitle;
        }
    }
}

@end
