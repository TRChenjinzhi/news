//
//  ThreeImageCell.m
//  新闻
//
//  Created by chenjinzhi on 2017/12/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ThreeImageCell.h"
#import "UIImageView+WebCache.h"
#import "TimeHelper.h"

@implementation ThreeImageCell{
    NSString*   m_time;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ThreeImg";
    ThreeImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (cell == nil) {
        cell = [[ThreeImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        space = 2;
        margin = 16;
        imgWidth = (SCREEN_WIDTH-margin-space-space-margin)/3;
        imgHight = imgWidth*0.66666f;
        titleToImg_space = 18;
        imgToLabel_space = 10;
        
        cellWidth = SCREEN_WIDTH;
        cellHight = 184;
        
//        NSLog(@"cellWidth-->%ld,cellHight-->%ld",cellWidth,cellHight);
        
        
        UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin, SCREEN_WIDTH-margin-margin, 42)];
        title.textAlignment = NSTextAlignmentLeft;
        title.numberOfLines = 2;
        title.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:18.0];
        
        [self addSubview:title];
        self.title = title;
        
        
        UIImageView* img1 = [[UIImageView alloc] initWithFrame:CGRectMake(margin, CGRectGetMaxY(title.frame)+titleToImg_space, imgWidth, imgHight)];
        img1.backgroundColor = [UIColor greenColor];
        [self addSubview:img1];
        self.img1 = img1;
        
        UIImageView* img2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(img1.frame)+space, CGRectGetMaxY(title.frame)+titleToImg_space, imgWidth, imgHight)];
        img2.backgroundColor = [UIColor greenColor];
        [self addSubview:img2];
        self.img2 = img2;
        
        UIImageView* img3 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(img2.frame)+space, CGRectGetMaxY(title.frame)+titleToImg_space, imgWidth, imgHight)];
        img3.backgroundColor = [UIColor greenColor];
        [self addSubview:img3];
        self.img3 = img3;

        
        UIButton* NoInterest_button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-34-74, CGRectGetMaxY(img1.frame)+3, 74, 28)];
        [NoInterest_button setTitle:@"不感兴趣" forState:UIControlStateNormal];
        [NoInterest_button setTitleColor:[UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        [NoInterest_button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        NoInterest_button.backgroundColor = [UIColor colorWithRed:248/255.0 green:205/255.0 blue:4/255.0 alpha:1/1.0];
        NoInterest_button.titleLabel.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:14.0];
        [NoInterest_button.layer setCornerRadius:14];//设置圆角
        [NoInterest_button.layer setMasksToBounds:YES];
        [NoInterest_button addTarget:self action:@selector(NoInterestAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:NoInterest_button];
        self.NoInterest = NoInterest_button;
        [self.NoInterest setHidden:YES];//隐藏
        
        
        UIButton* del_button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-margin-10, CGRectGetMaxY(self.img1.frame)+12, 10, 10)];
        [del_button setBackgroundImage:[UIImage imageNamed:@"ic_del"] forState:UIControlStateNormal];
        [del_button addTarget:self action:@selector(delAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:del_button];
        self.del = del_button;
        self.del.hidden = YES;
        
    }
    return self;
}

-(void)initFrame{
    self.img1.frame = CGRectMake(margin, CGRectGetMaxY(self.title.frame)+titleToImg_space, imgWidth, imgHight);
    self.img2.frame = CGRectMake(CGRectGetMaxX(self.img1.frame)+space, CGRectGetMaxY(self.title.frame)+titleToImg_space,
                                                                      imgWidth, imgHight);
    self.img3.frame = CGRectMake(CGRectGetMaxX(self.img2.frame)+space, CGRectGetMaxY(self.title.frame)+titleToImg_space, imgWidth, imgHight);
    
    self.NoInterest.frame = CGRectMake(SCREEN_WIDTH-34-74, CGRectGetMaxY(self.img1.frame)+3, 74, 28);
    self.del.frame = CGRectMake(SCREEN_WIDTH-margin-10, CGRectGetMaxY(self.img1.frame)+12, 10, 10);
    self.resouce.frame = CGRectMake(margin, CGRectGetMaxY(self.img1.frame)+10, self.resouce.frame.size.width, self.resouce.frame.size.height);
    self.imgReply.frame = CGRectMake(CGRectGetMaxX(self.resouce.frame)+8, CGRectGetMaxY(self.img1.frame)+10, 10, 11);
    self.lbReply.frame = CGRectMake(CGRectGetMaxX(self.imgReply.frame)+4, CGRectGetMaxY(self.img1.frame)+10, 20, 11);
    self.time.frame = CGRectMake(CGRectGetMaxX(self.resouce.frame)+10, CGRectGetMaxY(self.img1.frame)+10, 100, 11);
    self.delete_button.frame = CGRectMake(SCREEN_WIDTH-16-64, 184/2-32/2, 64, 32);
    self.line.frame = CGRectMake(16, CGRectGetMaxY(self.resouce.frame)+14, cellWidth-16-16, 1);
    self.readingHere.frame = CGRectMake(0, CGRectGetMaxY(self.line.frame), SCREEN_WIDTH, 30);
}

-(void)setModel:(CJZdataModel *)model{
    //添加行 间距
    NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:model.title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    self.title.attributedText = text;
    self.title.lineBreakMode = NSLineBreakByTruncatingTail;//因为label设置了属性，导致lineBreakMode失效了，所以要重新设置
    
    [self.img1 sd_setImageWithURL:[NSURL URLWithString:model.images[0]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.img2 sd_setImageWithURL:[NSURL URLWithString:model.images[1]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.img3 sd_setImageWithURL:[NSURL URLWithString:model.images[2]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    //添加 来源 评论 更新时间
    if(self.resouce == nil){
        UILabel* rescLb = [[UILabel alloc] init];
        rescLb.textAlignment = NSTextAlignmentLeft;
        rescLb.text = model.source;
        CGSize TextSize = [rescLb.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:10]}];
        CGSize size = CGSizeMake(ceilf(TextSize.width), ceilf(TextSize.height));
        rescLb.frame = CGRectMake(margin, CGRectGetMaxY(self.img1.frame)+10, size.width, size.height);
        rescLb.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:10];
        [self addSubview:rescLb];
        self.resouce = rescLb;
    }
    else{
        CGSize TextSize = [model.source sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:10]}];
        CGSize size = CGSizeMake(ceilf(TextSize.width), ceilf(TextSize.height));
        self.resouce.frame = CGRectMake(margin, CGRectGetMaxY(self.img1.frame)+10, size.width, size.height);
        self.resouce.text = model.source;
    }
    
    if(self.imgReply == nil){
        UIImageView* imgView_reply = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_comment_s"]];
        imgView_reply.frame = CGRectMake(CGRectGetMaxX(self.resouce.frame)+8, CGRectGetMaxY(self.img1.frame)+10, 10, 11);
        
        [self addSubview:imgView_reply];
        self.imgReply = imgView_reply;
        self.imgReply.hidden = YES;
    }
    
    if(self.lbReply == nil){
        UILabel* label_reply = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imgReply.frame)+4, CGRectGetMaxY(self.img1.frame)+10, 20, 11)];
        
        if([model.comment_num integerValue] == 0){
            label_reply.text = @"0";
        }else{
            label_reply.text = [NSString stringWithFormat:@"%ld",[model.comment_num integerValue]];
        }
        label_reply.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:11];
        
        [self addSubview:label_reply];
        self.lbReply = label_reply;
        self.lbReply.hidden = YES;
    }
    
    if(self.time == nil){
        UILabel* time_label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.resouce.frame)+10, CGRectGetMaxY(self.img1.frame)+10, 100, 11)];
//        time_label.text = model.time;
        time_label.text = [TimeHelper showTime:model.publish_time];
        time_label.textAlignment = NSTextAlignmentLeft;
        time_label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:10];
        
        [self addSubview:time_label];
        self.time = time_label;
    }else{
        self.time.frame=CGRectMake(CGRectGetMaxX(self.resouce.frame)+10, CGRectGetMaxY(self.img1.frame)+10, 100, 11);
        self.time.text = [TimeHelper showTime:model.publish_time];
    }
    m_time = model.publish_time;
    
    if(self.delete_button == nil){
        UIButton* delete_button = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-16-64, 184/2-32/2, 64, 32)];
        [delete_button setBackgroundColor:[UIColor colorWithRed:251/255.0 green:84/255.0 blue:38/255.0 alpha:1/1.0]];
        [delete_button setTitle:@"删除" forState:UIControlStateNormal];
        [delete_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [delete_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
//        [delete_button addTarget:self action:@selector(CollectDele) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:delete_button];
        self.delete_button = delete_button;
        self.delete_button.hidden = YES;
    }
    
    if(self.line == nil){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.time.frame)+16-1, cellWidth-16-16, 1)];
        line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
        [self addSubview:line];
        self.line = line;
    }
    
    if(model.isRreadHere){
        if(self.readingHere == nil){
            UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.line.frame), SCREEN_WIDTH, 30)];
            view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
            
            self.readingHere_btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
            [self.readingHere_btn setTitle:[NSString stringWithFormat:@"%@ 看到这里,点击刷新",[TimeHelper showTime:model.publish_time]] forState:UIControlStateNormal];
            [self.readingHere_btn setTitleColor:RGBA(248, 205, 4, 1) forState:UIControlStateNormal];
            [self.readingHere_btn.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:16]];
            [self.readingHere_btn addTarget:self action:@selector(readHere_action) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:self.readingHere_btn];
            
            self.readingHere = view;
            [self addSubview:view];
        }else{
            [self.readingHere setHidden:NO];
            [self.readingHere_btn setTitle:[NSString stringWithFormat:@"%@ 看到这里,点击刷新",[TimeHelper showTime:model.publish_time]] forState:UIControlStateNormal];
        }
    }else{
        [self.readingHere setHidden:YES];
    }
    
    //开始对以上控件进行一些可能改变的进行设置
    self.resouce.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
    self.resouce.textColor = [[ThemeManager sharedInstance] GetSmallTextColor];
    
    self.lbReply.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
    self.lbReply.textColor = [[ThemeManager sharedInstance] GetSmallTextColor];
    
    self.time.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
    self.time.textColor = [[ThemeManager sharedInstance] GetSmallTextColor];
    
    self.NoInterest.hidden = YES;
    
    //如果只有一行字，所以要调整frame---默认是两行字
    CGFloat title_hight = [LabelHelper GetLabelHight:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:18.0] AndText:model.title AndWidth:SCREEN_WIDTH-16-16];
    if(title_hight <= 21){
        self.title.frame = CGRectMake(margin, margin, SCREEN_WIDTH-margin-margin, 21);
        [self initFrame];
    }else{
        self.title.frame = CGRectMake(margin, margin, SCREEN_WIDTH-margin-margin, 42);
        [self initFrame];
    }

}

-(void)setIsCollect:(BOOL)IsCollect{
    self.time.text = [TimeHelper showTime_collect:m_time];
}

-(void)delAction{
    if([self.NoInterest isHidden]){
        self.NoInterest.hidden = NO;
    }
    else{
        self.NoInterest.hidden = YES;
    }
}

-(void)NoInterestAction{
    NSLog(@"不感兴趣");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"不感兴趣" object:[NSNumber numberWithInteger:self.tag]];
}

-(void)setIsReading:(BOOL)IsReading{
    if(IsReading){
        self.title.textColor = [UIColor colorWithRed:167/255.0 green:169/255.0 blue:169/255.0 alpha:1/1.0];
    }
}

//我的收藏删除
//-(void)CollectDele{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"收藏新闻删除" object:[NSNumber numberWithInteger:self.m_tag]];
//}

-(void)setIsDelete:(BOOL)IsDelete{
    self.delete_button.hidden = !IsDelete;
}

-(void)readHere_action{
    [self.delegate ThreeImage_readHere_action];
}

-(void)setSearchWord:(NSString *)searchWord{
    NSMutableAttributedString* att = [[NSMutableAttributedString alloc] initWithString:self.title.text];
    NSRange range = [self.title.text rangeOfString:searchWord  options:NSCaseInsensitiveSearch];
    att = [LabelHelper GetMutableAttributedSting_color:att AndIndex:range.location AndCount:range.length AndColor:RGBA(248, 205, 4, 1)];
    self.title.attributedText = att;
}

@end
