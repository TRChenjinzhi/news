//
//  Task_TableViewCell.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Task_TableViewCell.h"
#import "LabelHelper.h"

@implementation Task_TableViewCell{
    UIButton*           m_taskDoing;
    UILabel*            m_count_lable;
    UILabel*            m_title;
    UILabel*            m_subTitle;
    UIView*             m_subtitle_view;
    UIImageView*        m_imgV;
    UILabel*            m_money;
    UIView*             m_line;
}

+(instancetype)CellFormTable:(UITableView *)tableView{
    static NSString *ID = @"TaskCell";
    Task_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (cell == nil) {
        cell = [[Task_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

+(instancetype)CellFormTableForDayDayTask:(UITableView *)tableView{
    static NSString *ID = @"DayDayTaskCell";
    Task_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (cell == nil) {
        cell = [[Task_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{

    //去完成
    if(!m_taskDoing){
        UIButton* taskDoing = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16-72, 16, 72, 30)];
        [taskDoing setTitle:@"去完成" forState:UIControlStateNormal];
        [taskDoing.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [taskDoing setTitleColor:[[ThemeManager sharedInstance] TaskGetCellButtonTitleColor] forState:UIControlStateNormal];
        [m_taskDoing setBackgroundImage:[Color_Image_Helper createImageWithColor:RGBA(242, 242, 242, 1)] forState:UIControlStateNormal];
        [taskDoing addTarget:self action:@selector(ButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [taskDoing.layer setCornerRadius:16];
        taskDoing.layer.masksToBounds = YES;
        taskDoing.enabled = NO;
        
        [self addSubview:taskDoing];
        m_taskDoing = taskDoing;
    }
    
    
    //line
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(16, 65, SCREEN_WIDTH-16-16, 1)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [self addSubview:line];
    m_line = line;
}

-(void)setTaskModel:(TaskCell_model *)taskModel{
    //title
    if(!m_title){
        UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 0, 0 )];
        CGRect frame = [taskModel.title sizeWithFont:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(SCREEN_WIDTH, 66)];
        title.frame = CGRectMake(16, 16, frame.size.width, frame.size.height);
        title.text = taskModel.title;
        title.textColor = [[ThemeManager sharedInstance] TaskGetCellTitleColor];

        [self addSubview:title];
        m_title = title;
    }
    else{
        CGRect frame = [taskModel.title sizeWithFont:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(SCREEN_WIDTH, 66)];
        m_title.text = taskModel.title;
        m_title.frame = CGRectMake(16, 16, frame.size.width, frame.size.height);
    }
    
    //money
    if(!m_money){
        if(taskModel.Money > 0){ //没有奖励就不需要 显示金额
            NSString* str_money = nil;
            if(taskModel.IsYuan){ //当奖励为 元 时，添加单位
                str_money = [NSString stringWithFormat:@"+%ld元",taskModel.Money];
            }else{
                str_money = [NSString stringWithFormat:@"+%ld",taskModel.Money];
            }
            CGFloat width = [LabelHelper GetLabelWidth:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:18] AndText:str_money];
            UILabel* money = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(m_title.frame)+kWidth(30), 16, width, 18)];
            
        //    CGRect money_frame = [str_money sizeWithFont:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(SCREEN_WIDTH, 100)];
        //    money.frame = CGRectMake(CGRectGetMaxX(title_view.frame)+20, 16, money_frame.size.width, money_frame.size.height);
            money.text = str_money;
            money.textAlignment = NSTextAlignmentLeft;
            money.textColor = [[ThemeManager sharedInstance] TaskGetCellMoneyColor];
            money.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:18];
            [self addSubview:money];
            m_money = money;
        }
    }
    else{
        if(taskModel.Money <= 0){
            [m_money removeFromSuperview];
        }
        else{
            NSString* str_money = nil;
            if(taskModel.IsYuan){ //当奖励为 元 时，添加单位
                str_money = [NSString stringWithFormat:@"+%ld元",taskModel.Money];
            }else{
                str_money = [NSString stringWithFormat:@"+%ld",taskModel.Money];
            }
            CGFloat width = [LabelHelper GetLabelWidth:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:18] AndText:str_money];
            m_money.frame = CGRectMake(CGRectGetMaxX(m_title.frame)+10, 16, width, 18);
            m_money.text = str_money;
        }
    }
    
    //img
    if(!m_imgV){
        if(taskModel.Money > 0){ //没有奖励就不需要 显示金额
            UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(m_money.frame)+11, 14, 22, 22)];
            [imgView setImage:[UIImage imageNamed:@"ic_gold"]];
            [self addSubview:imgView];
            if(taskModel.IsYuan){ //当奖励为 元 时，隐藏金币图标
                imgView.hidden = YES;
            }else{
                imgView.hidden = NO;
            }
            m_imgV = imgView;
        }
    }
    else{
        if(taskModel.Money <= 0){
            [m_imgV removeFromSuperview];
        }
        else{
            m_imgV.frame = CGRectMake(CGRectGetMaxX(m_money.frame)+11, 14, 22, 22);
        }
    }
    
    //subtitle
    if(!m_subTitle){
        UIView* subtitle_view = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 0, 0 )];
        m_subtitle_view = subtitle_view;
        
        UILabel* subTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0 )];
        CGRect frame1 = [taskModel.subTitle sizeWithFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:10] maxSize:CGSizeMake(SCREEN_WIDTH, 200)];
        subTitle.frame = frame1;
        subTitle.text = taskModel.subTitle;
        subTitle.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:10];
        subTitle.textColor = [[ThemeManager sharedInstance] TaskGetCellSubTitleColor];
        
        subtitle_view.frame = CGRectMake(16, CGRectGetMaxY(m_title.frame)+6, subTitle.frame.size.width, subTitle.frame.size.height);
        [subtitle_view addSubview:subTitle];
        
        [self addSubview:subtitle_view];
        
        m_subTitle = subTitle;
    }
    else{
        CGRect frame1 = [taskModel.subTitle sizeWithFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:10] maxSize:CGSizeMake(SCREEN_WIDTH, 200)];
        m_subTitle.frame = frame1;
        m_subTitle.text = taskModel.subTitle;
        
        m_subtitle_view.frame = CGRectMake(16, CGRectGetMaxY(m_title.frame)+6, m_subTitle.frame.size.width, m_subTitle.frame.size.height);
    }
    
    
    
    //按钮
    if(taskModel.isDone){
        [m_taskDoing setTitle:@"已完成" forState:UIControlStateNormal];
        [m_taskDoing setBackgroundImage:[Color_Image_Helper createImageWithColor:RGBA(242, 242, 242, 1)] forState:UIControlStateNormal];
        [m_taskDoing setTitleColor:[UIColor colorWithRed:167/255.0 green:169/255.0 blue:169/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        m_taskDoing.enabled = NO;
    }else{
        [m_taskDoing setTitle:taskModel.btn_name forState:UIControlStateNormal];
        if([Login_info share].isLogined){
//            [m_taskDoing setTitle:@"去完成" forState:UIControlStateNormal];
            [m_taskDoing setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    //        m_taskDoing.backgroundColor = [[ThemeManager sharedInstance] TaskGetCellButtonColor];
            [m_taskDoing setTitleColor:[[ThemeManager sharedInstance] TaskGetCellButtonTitleColor] forState:UIControlStateNormal];
            m_taskDoing.enabled = YES;
        }
        else{
//            [m_taskDoing setTitle:@"去完成" forState:UIControlStateNormal];
            [m_taskDoing setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
            //        m_taskDoing.backgroundColor = [[ThemeManager sharedInstance] TaskGetCellButtonColor];
            [m_taskDoing setTitleColor:[[ThemeManager sharedInstance] TaskGetCellButtonTitleColor] forState:UIControlStateNormal];
            m_taskDoing.enabled = NO;
        }
    }
    
    if(taskModel.DayDay_model != nil){
        //任务限制次数
        if(!m_count_lable){
            UILabel* count_label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(m_subtitle_view.frame)+20,
                                                                             CGRectGetMinY(m_subtitle_view.frame),
                                                                             30,
                                                                             10)];
//            count_label.backgroundColor = [UIColor yellowColor];
            m_count_lable = count_label;
//            NSString* str = [NSString stringWithFormat:@"%ld/%ld",taskModel.DayDay_model.count,taskModel.DayDay_model.maxCout];
//            count_label.text =
            count_label.textColor = [UIColor colorWithRed:122/255.0 green:125/255.0 blue:125/255.0 alpha:1/1.0];
            count_label.textAlignment = NSTextAlignmentLeft;
            count_label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:10];
//            NSMutableAttributedString* str_att = [[NSMutableAttributedString alloc] initWithString:str];
//            NSRange index = [str rangeOfString:@"/"];
//            str_att = [LabelHelper GetMutableAttributedSting_color:str_att AndIndex:0 AndCount:str.length-index.location-1 AndColor:RGBA(248, 205, 4, 1)];
//            m_count_lable.attributedText = str_att;
            [self addSubview:m_count_lable];
        }
        m_count_lable.frame = CGRectMake(CGRectGetMaxX(m_subtitle_view.frame)+10,
                                         CGRectGetMinY(m_subtitle_view.frame),
                                         30,
                                         10);
        NSString* str = @"";
        if([[TaskCountHelper share] TaskIsOverByType:taskModel.type]){
            str = [NSString stringWithFormat:@"%ld/%ld",taskModel.DayDay_model.maxCout,taskModel.DayDay_model.maxCout];
        }
        else{
            str = [NSString stringWithFormat:@"%ld/%ld",taskModel.DayDay_model.count,taskModel.DayDay_model.maxCout];
        }
        
        NSMutableAttributedString* str_att = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange index = [str rangeOfString:@"/"];
        str_att = [LabelHelper GetMutableAttributedSting_color:str_att AndIndex:0 AndCount:str.length-index.location-1 AndColor:RGBA(248, 205, 4, 1)];
        m_count_lable.attributedText = str_att;
        
        if(taskModel.DayDay_model.maxCout <= taskModel.DayDay_model.count){
            [m_taskDoing setTitle:@"已完成" forState:UIControlStateNormal];
            [m_taskDoing setTitleColor:RGBA(167, 169, 169, 1) forState:UIControlStateNormal];
            [m_taskDoing setBackgroundImage:[Color_Image_Helper createImageWithColor:RGBA(242, 242, 242, 1)] forState:UIControlStateNormal];
            m_taskDoing.enabled = NO;
        }else{
//            m_taskDoing.backgroundColor = [[ThemeManager sharedInstance] TaskGetCellButtonColor];
            [m_taskDoing setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
            [m_taskDoing setTitleColor:[[ThemeManager sharedInstance] TaskGetCellButtonTitleColor] forState:UIControlStateNormal];
            m_taskDoing.enabled = YES;
        }
    }
    
    if(taskModel.User_model != nil){
        //任务限制次数
        if(!m_count_lable){
            if(taskModel.User_model.max > 1){ //目的：一次性任务 不需要显示任务次数
            
                UILabel* count_label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(m_subtitle_view.frame)+10,
                                                                                 CGRectGetMinY(m_subtitle_view.frame),
                                                                                 30,
                                                                                 10)];
                m_count_lable = count_label;
                NSString* str = [NSString stringWithFormat:@"%ld/%ld",taskModel.User_model.count,taskModel.User_model.max];
                if(taskModel.User_model.count >= taskModel.User_model.max){
                    str = [NSString stringWithFormat:@"%ld/%ld",taskModel.User_model.max,taskModel.User_model.max];
                }
                //            count_label.text =
                count_label.textColor = [UIColor colorWithRed:122/255.0 green:125/255.0 blue:125/255.0 alpha:1/1.0];
                count_label.textAlignment = NSTextAlignmentLeft;
                count_label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:10];
                NSMutableAttributedString* str_att = [[NSMutableAttributedString alloc] initWithString:str];
                NSRange index = [str rangeOfString:@"/"];
                str_att = [LabelHelper GetMutableAttributedSting_color:str_att AndIndex:0 AndCount:str.length-index.location-1 AndColor:RGBA(248, 205, 4, 1)];
                m_count_lable.attributedText = str_att;
                [self addSubview:m_count_lable];
            }
        }
        else{
            m_count_lable.frame = CGRectMake(CGRectGetMaxX(m_subtitle_view.frame)+10,
                                             CGRectGetMinY(m_subtitle_view.frame),
                                             30,
                                             10);
            NSString* str = [NSString stringWithFormat:@"%ld/%ld",taskModel.User_model.count,taskModel.User_model.max];
            if(taskModel.User_model.count >= taskModel.User_model.max){
                str = [NSString stringWithFormat:@"%ld/%ld",taskModel.User_model.max,taskModel.User_model.max];
            }
            NSMutableAttributedString* str_att = [[NSMutableAttributedString alloc] initWithString:str];
            NSRange index = [str rangeOfString:@"/"];
            str_att = [LabelHelper GetMutableAttributedSting_color:str_att AndIndex:0 AndCount:str.length-index.location-1 AndColor:RGBA(248, 205, 4, 1)];
            m_count_lable.attributedText = str_att;
        }
        
        if(taskModel.User_model.status == 1 || taskModel.User_model.count >= taskModel.User_model.max){//0:未完成 1:完成
            [m_taskDoing setTitle:@"已完成" forState:UIControlStateNormal];
            [m_taskDoing setTitleColor:RGBA(167, 169, 169, 1) forState:UIControlStateNormal];
            [m_taskDoing setBackgroundImage:[Color_Image_Helper createImageWithColor:RGBA(242, 242, 242, 1)] forState:UIControlStateNormal];
            m_taskDoing.enabled = NO;
        }else{
            //            m_taskDoing.backgroundColor = [[ThemeManager sharedInstance] TaskGetCellButtonColor];
            [m_taskDoing setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
            [m_taskDoing setTitleColor:[[ThemeManager sharedInstance] TaskGetCellButtonTitleColor] forState:UIControlStateNormal];
            m_taskDoing.enabled = YES;
        }
        
    }
}

-(void)setTaskCount:(TaskMaxCout_model *)taskCount{
    NSLog(@"setTaskCount");
}

-(void)ButtonAction:(UIButton*) sender{
    NSLog(@"TaskCell ButtonAction");
    if([self.type isEqualToString:@"新手任务"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"新手任务点击" object:[NSNumber numberWithInteger:self.tag]];
    }
    else if([self.type isEqualToString:@"日常任务"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"日常任务点击" object:[NSNumber numberWithInteger:self.tag]];
    }
}

-(void)setIsHideLine:(BOOL)isHideLine{
    [m_line setHidden:isHideLine];
}

+(CGFloat)HightForcell{
    return 66.0;
}

@end
