//
//  NoReply_TableViewCell.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NoReply_TableViewCell.h"
#import "ThemeManager.h"

@implementation NoReply_TableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"NullReply";
    NoReply_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (cell == nil) {
        cell = [[NoReply_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
        
        //图片
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(135, 19, 90, 90)];
        [imgView setImage:[UIImage imageNamed:@"ic_comment_empty"]];
        [view addSubview:imgView];
        
        //文字
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(136, CGRectGetMaxY(imgView.frame)+12, 99, 13)];
        label.text = @"还没有人评论哦~";
        label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:13];
        label.textColor = [[ThemeManager sharedInstance] GetDialogTextColor];
        [view addSubview:label];
        
        [self addSubview:view];
    }
    return self;
}

@end
