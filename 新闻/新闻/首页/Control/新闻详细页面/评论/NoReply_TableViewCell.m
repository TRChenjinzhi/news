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
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kWidth(150))];
        
        //图片
        UIImageView* imgView = [UIImageView new];
        [imgView setImage:[UIImage imageNamed:@"ic_comment_empty"]];
        [view addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_offset(kWidth(90));
            make.top.equalTo(view.mas_top).with.offset(kWidth(19));
            make.centerX.equalTo(view.mas_centerX);
        }];
        
        //文字
        UILabel* label = [UILabel new];
        label.text = @"还没有人评论哦~";
        label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:13];
        label.textColor = [[ThemeManager sharedInstance] GetDialogTextColor];
        label.textAlignment= NSTextAlignmentCenter;
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView.mas_bottom).with.offset(kWidth(12));
            make.left.and.right.equalTo(view);
        }];
        
        [self addSubview:view];
    }
    return self;
}

@end
