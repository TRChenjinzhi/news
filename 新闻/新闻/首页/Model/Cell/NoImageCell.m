//
//  NoImageCell.m
//  新闻
//
//  Created by chenjinzhi on 2017/12/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "NoImageCell.h"
#import "TimeHelper.h"

@implementation NoImageCell{
    NSString*   m_time;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"NoImg";
    NoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (cell == nil) {
        cell = [[NoImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
        imgHight = (imgWidth*2)/3;
        titleToImg_space = 18;
        imgToLabel_space = 10;
        
        cellWidth = SCREEN_WIDTH;
        cellHight = 107;
        
//        NSLog(@"cellWidth-->%ld,cellHight-->%ld",cellWidth,cellHight);        
        
        UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin, SCREEN_WIDTH-margin-margin, 42)];
        title.textAlignment = NSTextAlignmentLeft;
        title.numberOfLines = 2;
        title.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:18.0];
        
        [self addSubview:title];
        self.title = title;
        
        
        UIButton* NoInterest_button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-34-74, cellHight-7-28, 74, 28)];
        [NoInterest_button setTitle:@"不感兴趣" forState:UIControlStateNormal];
        [NoInterest_button setTitleColor:[UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        [NoInterest_button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        NoInterest_button.backgroundColor = [UIColor colorWithRed:255/255.0 green:129/255.0 blue:3/255.0 alpha:1/1.0];
        NoInterest_button.titleLabel.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:14.0];
        [NoInterest_button.layer setCornerRadius:14];//设置圆角
        [NoInterest_button.layer setMasksToBounds:YES];
        [NoInterest_button addTarget:self action:@selector(NoInterestAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:NoInterest_button];
        self.NoInterest = NoInterest_button;
        [self.NoInterest setHidden:YES];//隐藏
        
        
        UIButton* del_button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-margin-10, cellHight-16-10, 10, 10)];
        [del_button setBackgroundImage:[UIImage imageNamed:@"ic_del"] forState:UIControlStateNormal];
        [del_button addTarget:self action:@selector(delAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:del_button];
        self.del = del_button;
        self.del.hidden = YES;
        
    }
    return self;
}

-(void)setModel:(CJZdataModel *)model{
    
    //添加行 间距
    NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:model.title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    self.title.attributedText = text;
    self.title.lineBreakMode = NSLineBreakByTruncatingTail;//因为label设置了属性，导致lineBreakMode失效了，所以要重新设置
    
    if(self.resouce == nil){
        UILabel* rescLb = [[UILabel alloc] init];
        rescLb.textAlignment = NSTextAlignmentLeft;
        rescLb.text = model.source;
        CGSize TextSize = [rescLb.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:10]}];
        CGSize size = CGSizeMake(ceilf(TextSize.width), ceilf(TextSize.height));
        rescLb.frame = CGRectMake(margin, cellHight-16-size.height, size.width, size.height);
        rescLb.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:10];
        [self addSubview:rescLb];
        self.resouce = rescLb;
    }
    else{
        CGSize TextSize = [model.source sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:10]}];
        CGSize size = CGSizeMake(ceilf(TextSize.width), ceilf(TextSize.height));
        self.resouce.frame = CGRectMake(margin, cellHight-16-size.height, size.width, size.height);
        self.resouce.text = model.source;
    }
    
    if(self.imgReply == nil){
        UIImageView* imgView_reply = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_comment_s"]];
        imgView_reply.frame = CGRectMake(CGRectGetMaxX(self.resouce.frame)+8, cellHight-16-11, 10, 11);
        
        [self addSubview:imgView_reply];
        self.imgReply = imgView_reply;
//        self.imgReply.hidden = YES;
    }
    else{
        self.imgReply.frame = CGRectMake(CGRectGetMaxX(self.resouce.frame)+8, cellHight-16-11, 10, 11);
    }
    
    if(self.lbReply == nil){
        UILabel* label_reply = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imgReply.frame)+4, cellHight-16-11, 20, 11)];
        if([model.comment_num integerValue] == 0){
            label_reply.text = @"0";
        }else{
            label_reply.text = [NSString stringWithFormat:@"%ld",[model.comment_num integerValue]];
        }
        label_reply.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:11];
        
        [self addSubview:label_reply];
        self.lbReply = label_reply;
//        self.lbReply.hidden = YES;
    }
    else{
        self.lbReply.frame = CGRectMake(CGRectGetMaxX(self.imgReply.frame)+4, cellHight-16-11, 20, 11);
        if([model.comment_num integerValue] == 0){
            self.lbReply.text = @"0";
        }else{
            self.lbReply.text = [NSString stringWithFormat:@"%ld",[model.comment_num integerValue]];
        }
    }
    
    if(self.time == nil){
        UILabel* time_label = [[UILabel alloc] init];
        if([model.comment_num integerValue] > 0){
            time_label.frame = CGRectMake(CGRectGetMaxX(self.lbReply.frame)+10, cellHight-16-11, 70, 11);
            [self.imgReply setHidden:NO];
            [self.lbReply setHidden:NO];
        }
        else{
            time_label.frame = CGRectMake(CGRectGetMaxX(self.resouce.frame)+10, cellHight-16-11, 70, 11);
            [self.imgReply setHidden:YES];
            [self.lbReply setHidden:YES];
        }
        time_label.text = [TimeHelper showTime:model.publish_time];
        time_label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:10];
        
        [self addSubview:time_label];
        self.time = time_label;
    }else{
        if([model.comment_num integerValue] > 0){
            self.time.frame = CGRectMake(CGRectGetMaxX(self.lbReply.frame)+10, cellHight-16-11, 70, 11);
            [self.imgReply setHidden:NO];
            [self.lbReply setHidden:NO];
        }
        else{
            self.time.frame = CGRectMake(CGRectGetMaxX(self.resouce.frame)+10, cellHight-16-11, 70, 11);
            [self.imgReply setHidden:YES];
            [self.lbReply setHidden:YES];
        }
        self.time.text = [TimeHelper showTime:model.publish_time];
    }
    m_time = model.publish_time;
    
    if(self.delete_button == nil){
        UIButton* delete_button = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-16-64, 102/2-32/2, 64, 32)];
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
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(16, cellHight-1, cellWidth-16-16, 1)];
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
            [self.readingHere_btn setTitleColor:RGBA(255, 129, 3, 1) forState:UIControlStateNormal];
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
    [self.delegate NoImage_readHere_action];
}

-(void)setSearchWord:(NSString *)searchWord{
    NSMutableAttributedString* att = [[NSMutableAttributedString alloc] initWithString:self.title.text];
    NSRange range = [self.title.text rangeOfString:searchWord options:NSCaseInsensitiveSearch];
    att = [LabelHelper GetMutableAttributedSting_color:att AndIndex:range.location AndCount:range.length AndColor:RGBA(248, 205, 4, 1)];
    self.title.attributedText = att;
}

#pragma mark - 返回可重用ID
+ (NSString *)idForRow:(CJZdataModel *)Model
{
    if([Model.images[0] isEqualToString:@""]){
        NSLog(@"NoImage---111---");
        return @"NoImg";
    }
    else if([Model.images[1] isEqualToString:@""]){
        return @"OneImg";
    }else if(![Model.images[2] isEqualToString:@""]){
        return @"ThreeImg";
    }
    else{
        NSLog(@"Two img-------");
        return @"OneImg";
    }
}

#pragma mark - 返回行高
+ (CGFloat)heightForRow:(CJZdataModel *)Model
{
    CGFloat m_screenWidth = SCREEN_WIDTH;
    CGFloat imgHeight = (m_screenWidth-16-16-2-2)/3;
    imgHeight = imgHeight * 0.666f;
    
    CGFloat cellHeight = 0.0f;
    if([Model.images[0] isEqualToString:@""]){//NoImage
        
//        return 102.0;
        NSLog(@"NoImage--------");
        cellHeight = 107.0f;
        if(Model.isRreadHere){
            cellHeight += 30;
        }
        return cellHeight;
    }
    else if([Model.images[1] isEqualToString:@""]){//OneImage
//        return 102.0;
        cellHeight = 107.0f;//OneImage
    }
    else if(![Model.images[2] isEqualToString:@""]){//ThreeImage
        cellHeight = 188.0f;
        CGFloat title_hight = [LabelHelper GetLabelHight:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:18.0] AndText:Model.title AndWidth:SCREEN_WIDTH-16-16];
        if(title_hight < 19){
            cellHeight = 188.0f-(42-21);
        }
    }
    else{//TWOImage
        cellHeight = 107.0;
    }
    
    if(Model.isRreadHere){
        cellHeight += 30;
    }
    
    if(SCREEN_WIDTH > 375){//因为照片比 3:2 所以 图片高添加多少，高度添加多少   ---不同版本的适配
        return cellHeight +imgHeight-75.0f;
    }
    return cellHeight;
}

@end
