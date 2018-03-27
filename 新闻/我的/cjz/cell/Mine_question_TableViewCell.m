//
//  Mine_question_TableViewCell.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_question_TableViewCell.h"
#import "LabelHelper.h"

@implementation Mine_question_TableViewCell{
    UILabel*        m_title;
    UIImageView*    m_img;
    UIView*         m_line;
    UILabel*        m_answer;
    BOOL            m_click;
}
static float hight = 54.0;
+(instancetype)cellForTableView:(UITableView *)tableView{
    NSString* str_id = @"Mine_question_cell";
    Mine_question_TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:str_id];
    if(!cell){
        cell = [[Mine_question_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str_id];
    }
    return cell;
}

+(CGFloat)HightForCell{
    return hight;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    UIView* blackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 54)];
    blackgroundView.backgroundColor = [UIColor whiteColor];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(16, 21, SCREEN_WIDTH-16-16-16, 14)];
    title.textColor =  [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:14];
    m_title = title;
    [blackgroundView addSubview:title];
    
    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16-16, 19, 16, 16)];
    [img setImage:[UIImage imageNamed:@"ic_list_next"]];
    [blackgroundView addSubview:img];
    m_img = img;
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 54-1, SCREEN_WIDTH, 1)];
    line.backgroundColor =  [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [blackgroundView addSubview:line];
    m_line = line;
    
    [self addSubview:blackgroundView];
}

-(void)setModel:(Mine_question_model *)model{
    m_title.text = model.requestion;
    
    if(model.isReading){
        //内容
        CGFloat textHight = [LabelHelper GetLabelHight:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]
                                               AndText:model.answer
                                              AndWidth:SCREEN_WIDTH-16-16];
        
        UILabel* answer = [[UILabel alloc] initWithFrame:CGRectMake(16, 54, SCREEN_WIDTH-16-16, textHight)];
        answer.textColor = [UIColor colorWithRed:167/255.0 green:169/255.0 blue:169/255.0 alpha:1/1.0];
        answer.numberOfLines = 0;
        answer.textAlignment = NSTextAlignmentLeft;
        answer.text = model.answer;
        answer.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:14];
        m_answer = answer;
        [self addSubview:m_answer];
        m_line.frame = CGRectMake(0, hight+textHight+10-1, SCREEN_WIDTH, 1);
        m_click = YES;
        [m_img setImage:[UIImage imageNamed:@"arrow_down"]];
    }else{
        [m_answer removeFromSuperview];
        m_line.frame = CGRectMake(0, hight-1, SCREEN_WIDTH, 1);
        m_click = NO;
        [m_img setImage:[UIImage imageNamed:@"ic_list_next"]];
    }
}


@end
