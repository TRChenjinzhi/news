//
//  Mine_message_TableViewCell.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_message_TableViewCell.h"

@implementation Mine_message_TableViewCell{
    UIImageView* icon;
    UILabel* title;
    UILabel* subTitle;
    UILabel* time;
    UIView*  m_line;
}

+(instancetype)cellForTableView:(UITableView *)table{
    NSString* str_id = @"Mine_message_cell";
    Mine_message_TableViewCell* cell = [table dequeueReusableCellWithIdentifier:str_id];
    if(!cell){
        cell = [[Mine_message_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str_id];
    }
    return cell;
}

+(CGFloat)hightForCell{
    return kWidth(57);
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    //icon
    UIImageView* icon_imgV = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth(16), kWidth(16), kWidth(32), kWidth(32))];
    icon = icon_imgV;
    
    //title
    UILabel* title_lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon_imgV.frame)+kWidth(8), kWidth(16), kWidth(150), kWidth(10))];
    title_lable.textColor = [[ThemeManager sharedInstance] MineMessageCellTitleColor];
    title_lable.font = [UIFont boldSystemFontOfSize:kWidth(10)];
    title = title_lable;
    
    //subTitle
    UILabel* subTitle_lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon_imgV.frame)+kWidth(8),
                                                                        CGRectGetMaxY(title_lable.frame)+kWidth(4),
                                                                        SCREEN_WIDTH-CGRectGetMaxX(icon_imgV.frame)-kWidth(8)-kWidth(16),
                                                                        kWidth(12))];
    subTitle_lable.textColor = [[ThemeManager sharedInstance] MineMessageCellSubTileColr];
    subTitle_lable.font = kFONT(10);
    subTitle_lable.textAlignment = NSTextAlignmentLeft;
    subTitle_lable.numberOfLines = 0;
    subTitle = subTitle_lable;
    
    //time
    UILabel* time_lable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-kWidth(120)-kWidth(16), kWidth(18), kWidth(120), kWidth(10))];
    time_lable.textColor = [UIColor colorWithRed:167/255.0 green:169/255.0 blue:169/255.0 alpha:1/1.0];
    time_lable.font = kFONT(8);
    time_lable.textAlignment = NSTextAlignmentRight;
    time = time_lable;
    
    //line
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(kWidth(16), CGRectGetMaxY(subTitle.frame)+kWidth(15)-1, SCREEN_WIDTH-kWidth(16)-kWidth(16), 1)];
    line.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1/1.0];
    [self addSubview:line];
    m_line = line;
    
    [self addSubview:icon];
    [self addSubview:title];
    [self addSubview:subTitle];
    [self addSubview:time];
}

-(void)setModel:(Mine_message_model *)model{
    int index = [model.type intValue];
    //1:金币兑换提醒    2:优质评论提醒   3:收徒成功提醒  4:系统公告
    switch (index) {
        case 1:
            [icon setImage:[UIImage imageNamed:@"ic_reminder"]];
            break;
        case 2:
            [icon setImage:[UIImage imageNamed:@"ic_m_comment"]];
            break;
        case 3:
            [icon setImage:[UIImage imageNamed:@"ic_m_disciple"]];
            break;
        case 4:
            [icon setImage:[UIImage imageNamed:@"ic_post"]];
            break;
            
        default:
            break;
    }
    title.text = model.title;
    CGFloat height = [LabelHelper GetLabelHight:kFONT(10) AndText:model.subTitle AndWidth:subTitle.frame.size.width];
    subTitle.frame = CGRectMake(subTitle.frame.origin.x, subTitle.frame.origin.y, subTitle.frame.size.width, height);
    subTitle.text = model.subTitle;
    time.text = [[TimeHelper share] GetDateFromString_yyMMDD_HHMMSS:model.time];
    m_line.frame = CGRectMake(kWidth(16), CGRectGetMaxY(subTitle.frame)+kWidth(15)-1, SCREEN_WIDTH-kWidth(16)-kWidth(16), 1);
}

@end
