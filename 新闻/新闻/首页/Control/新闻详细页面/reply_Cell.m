//
//  reply_Cell.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "reply_Cell.h"
#import "LabelHelper.h"

@implementation reply_Cell{
    UIImageView*    m_icon;
    UILabel*        m_name;
    UILabel*        m_dianzan_number;
    UIButton*       m_dianzan;
    UILabel*        m_content;
    NSString*       m_ctime;
    UIButton*       m_reply_button;
    UILabel*        m_time_lable;
    UILabel*        m_content_label;
    UIView*         m_line;
    
    BOOL            IsDianZan;//是否已经点赞
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"reply";
    reply_Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (cell == nil) {
        cell = [[reply_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    UIImageView* icon = [[UIImageView alloc]initWithFrame:CGRectMake(16, 16, 24, 24)];
    [icon.layer setCornerRadius:12];
    icon.layer.masksToBounds = YES;
    m_icon = icon;
    [self addSubview:icon];
    
    UIButton* dianZan = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-17-14, 22, 14, 12)];
//    [dianZan setImage:[UIImage imageNamed:@"ic_like"] forState:UIControlStateNormal];
    m_dianzan = dianZan;
    [dianZan addTarget:self action:@selector(dianzan_action:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dianZan];
    
    UILabel* dianZan_number = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(dianZan.frame)-5-100, 22, 100, 12)];
//    dianZan_number.backgroundColor = [UIColor redColor];
    dianZan_number.textColor = [UIColor colorWithRed:78/255.0 green:82/255.0 blue:82/255.0 alpha:1/1.0];
    dianZan_number.textAlignment = NSTextAlignmentRight;
    dianZan_number.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:12];
    [self addSubview:dianZan_number];
    m_dianzan_number = dianZan_number;
    
    UILabel* name = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+8, 16, 150, 24)];
    name.textColor =  [UIColor colorWithRed:122/255.0 green:125/255.0 blue:125/255.0 alpha:1/1.0];
    name.textAlignment = NSTextAlignmentLeft;
//    name.backgroundColor = [UIColor redColor];
    name.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:13];
    [self addSubview:name];
    m_name = name;
    
    
}

-(void)setModel:(reply_model *)model{
    _model = model;
    [m_icon sd_setImageWithURL:[NSURL URLWithString:model.user_icon]];
    m_name.text = model.user_name;
    IsDianZan = [[MyDataBase shareManager] DianZan_IsDianZan:[model.ID integerValue]];//判断是否已经点赞
    [self dianzan_InitState:model];//设置点赞状态
    m_dianzan_number.text = model.thumbs_num;
//    m_dianzan_number.text = @"99999";
    
    //内容
    CGFloat textHight = [LabelHelper GetLabelHight:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]
                                           AndText:model.comment
                                          AndWidth:SCREEN_WIDTH-CGRectGetMinX(m_name.frame)-32];
    if(m_content_label == nil){
    
    NSLog(@"str:%@\nhight:%f",model.comment,textHight);
    m_content_label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(m_name.frame),
                                                                          CGRectGetMaxY(m_name.frame)+15,
                                                                          SCREEN_WIDTH-CGRectGetMinX(m_name.frame)-32,
                                                                          textHight)];
        [self addSubview:m_content_label];
    }
    
    m_content_label.frame = CGRectMake(CGRectGetMinX(m_name.frame),
                                       CGRectGetMaxY(m_name.frame)+15,
                                       SCREEN_WIDTH-CGRectGetMinX(m_name.frame)-32,
                                       textHight);
    m_content_label.numberOfLines = 0;
    m_content_label.textColor = [UIColor colorWithRed:78/255.0 green:82/255.0 blue:82/255.0 alpha:1/1.0];
    m_content_label.textAlignment = NSTextAlignmentLeft;
    m_content_label.text = model.comment;
    m_content_label.numberOfLines = 0;
    m_content_label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:14];

//    [m_content_label sizeToFit];
    
    
    //时间
    if(m_time_lable == nil){
        UILabel* time_lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(m_content_label.frame),
                                                                        CGRectGetMaxY(m_content_label.frame)+10,
                                                                        90,
                                                                        11)];
        m_time_lable = time_lable;
        [self addSubview:m_time_lable];
    }
    m_time_lable.frame = CGRectMake(CGRectGetMinX(m_content_label.frame),
                                    CGRectGetMaxY(m_content_label.frame)+10,
                                    90,
                                    11);
    m_time_lable.textColor = [UIColor colorWithRed:122/255.0 green:125/255.0 blue:125/255.0 alpha:1/1.0];
    m_time_lable.textAlignment = NSTextAlignmentLeft;
    m_time_lable.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:10];
    NSString* str_time = [[TimeHelper share] GetDateFromString_yyMMDD_HHMMSS:model.ctime];
    m_time_lable.text = [TimeHelper showTime:str_time];
    
    
    //回复TA
    if(m_reply_button == nil){
        UIButton* reply_her = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(m_time_lable.frame)+8,
                                                                         CGRectGetMaxY(m_content_label.frame)+10, 40, 10)];
        m_reply_button = reply_her;
//        [self addSubview:m_reply_button];
    }
    m_reply_button.frame = CGRectMake(CGRectGetMaxX(m_time_lable.frame)+8,
                                      CGRectGetMaxY(m_content_label.frame)+10, 40, 10);
    [m_reply_button setTitle:@"回复TA" forState:UIControlStateNormal];
    [m_reply_button setTitleColor:[UIColor colorWithRed:248/255.0 green:205/255.0 blue:4/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    [m_reply_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:10]];
    [m_reply_button addTarget:self action:@selector(replay_action:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if(m_line == nil){
        m_line = [[UIView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(m_time_lable.frame)+16, SCREEN_WIDTH-16-16, 1)];
        m_line.backgroundColor = RGBA(242, 242, 242, 1);
        [self addSubview:m_line];
    }
    m_line.frame = CGRectMake(16, CGRectGetMaxY(m_time_lable.frame)+16, SCREEN_WIDTH-16-16, 1);
    [self layoutIfNeeded];
}

-(void)setTag:(NSInteger)tag{
    m_reply_button.tag = tag;
}

-(void)replay_action:(UIButton*)bt{
    NSLog(@"回复TA");
}

-(void)dianzan_action:(UIButton*)bt{
    NSLog(@"点赞");
    [self dianzan_SetState:bt];
}

-(void)dianzan_SetState:(UIButton*)bt{
    NSInteger reply_id = [self.model.ID integerValue];
    if([[MyDataBase shareManager] DianZan_IsHaveId:reply_id]){//是否存在该ID的记录
        //存在
        if([[MyDataBase shareManager] DianZan_IsDianZan:reply_id]){ //是否已经点赞
            //点赞
            [[MyDataBase shareManager] DianZan_UpData:reply_id AndIsDIanZan:0];
            [bt setImage:[UIImage imageNamed:@"ic_like"] forState:UIControlStateNormal];
            [self setDianZanNum_type:0];
            self.model.DianZan_type = 0;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"点赞" object:self.model];
        }else{
            //没有点赞
            [[MyDataBase shareManager] DianZan_UpData:reply_id AndIsDIanZan:1];
            [bt setImage:[UIImage imageNamed:@"ic_liked"] forState:UIControlStateNormal];
            [self setDianZanNum_type:1];
            self.model.DianZan_type = 1;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"点赞" object:self.model];
        }
    }else{
        //不存在
        [[MyDataBase shareManager] DianZan_insertData:reply_id AndIsDIanZan:1];
        [bt setImage:[UIImage imageNamed:@"ic_liked"] forState:UIControlStateNormal];
        [self setDianZanNum_type:1];
        self.model.DianZan_type = 1;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"点赞" object:self.model];
    }
}

-(void)dianzan_InitState:(reply_model*)model{
    NSInteger reply_id = [model.ID integerValue];
    if([[MyDataBase shareManager] DianZan_IsHaveId:reply_id]){//是否存在该ID的记录
        //存在
        if([[MyDataBase shareManager] DianZan_IsDianZan:reply_id]){ //是否已经点赞
            [m_dianzan setImage:[UIImage imageNamed:@"ic_liked"] forState:UIControlStateNormal];
        }else{
            //没有点赞
            [m_dianzan setImage:[UIImage imageNamed:@"ic_like"] forState:UIControlStateNormal];
        }
    }else{
        //不存在
        [m_dianzan setImage:[UIImage imageNamed:@"ic_like"] forState:UIControlStateNormal];
    }
}

-(void)setDianZanNum_type:(NSInteger)type{
    NSInteger num = [self.model.thumbs_num integerValue];
    if(type == 0){//取消点赞
        if(IsDianZan){//起始点赞的状态
            num -= 1;
        }
        if(num > 0){
            m_dianzan_number.text = [NSString stringWithFormat:@"%ld",num];
        }else{
            m_dianzan_number.text = [NSString stringWithFormat:@"0"];
        }
    }else{//点赞
        if(!IsDianZan){//起始点赞的状态
            num += 1;
        }
        m_dianzan_number.text = [NSString stringWithFormat:@"%ld",num];
    }
}

@end
