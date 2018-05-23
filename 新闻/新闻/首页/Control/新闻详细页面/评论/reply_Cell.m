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
    UIView*         m_reply_contentView;
    
    NSMutableArray* m_tap_array; //用来判断点击那个lable
    
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
    UIImageView* icon = [UIImageView new];
    [icon.layer setCornerRadius:kWidth(24)/2];
    icon.layer.masksToBounds = YES;
    m_icon = icon;
    [self addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(kWidth(16));
        make.top.equalTo(self.mas_top).with.offset(kWidth(16));
        make.width.and.height.mas_offset(kWidth(24));
    }];
    
    UIButton* dianZan = [UIButton new];
//    [dianZan setImage:[UIImage imageNamed:@"ic_like"] forState:UIControlStateNormal];
    m_dianzan = dianZan;
    [dianZan addTarget:self action:@selector(dianzan_action:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dianZan];
    [dianZan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-kWidth(16));
        make.top.equalTo(self.mas_top).with.offset(kWidth(22));
        make.width.mas_offset(kWidth(14));
        make.height.mas_offset(kWidth(12));
    }];
    
    UILabel* dianZan_number = [UILabel new];
//    dianZan_number.backgroundColor = [UIColor redColor];
    dianZan_number.textColor = [UIColor colorWithRed:78/255.0 green:82/255.0 blue:82/255.0 alpha:1/1.0];
    dianZan_number.textAlignment = NSTextAlignmentRight;
    dianZan_number.font = kFONT(12);
    [self addSubview:dianZan_number];
    m_dianzan_number = dianZan_number;
    [dianZan_number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(dianZan.mas_left).with.offset(-kWidth(5));
        make.top.equalTo(self.mas_top).with.offset(kWidth(22));
        make.height.mas_offset(kWidth(12));
    }];
    
    UILabel* name = [UILabel new];
    name.textColor =  [UIColor colorWithRed:122/255.0 green:125/255.0 blue:125/255.0 alpha:1/1.0];
    name.textAlignment = NSTextAlignmentLeft;
//    name.backgroundColor = [UIColor redColor];
    name.font = kFONT(13);
    [self addSubview:name];
    m_name = name;
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).with.offset(kWidth(8));
        make.centerY.equalTo(icon.mas_centerY);
        make.height.mas_offset(kWidth(24));
    }];
    
    
    m_tap_array = [NSMutableArray array];
}

-(void)setModel:(reply_model *)model{
    _model = model;
    if(model.myUserModel.user_icon.length <= 0){
        if(model.myUserModel.wechat_icon.length <= 0){
            [m_icon setImage:[UIImage imageNamed:@"list_avatar"]];
        }
        else{
            [m_icon sd_setImageWithURL:[NSURL URLWithString:model.myUserModel.wechat_icon]];
        }
    }
    else{
        [m_icon sd_setImageWithURL:[NSURL URLWithString:model.myUserModel.user_icon]];
    }
    
    m_name.text = model.myUserModel.user_name;
    IsDianZan = [[MyDataBase shareManager] DianZan_IsDianZan:[model.ID integerValue]];//判断是否已经点赞
    [self dianzan_InitState:model];//设置点赞状态
    if([model.thumbs_num integerValue] < 0){
        m_dianzan_number.text = @"0";
    }
    else{
        m_dianzan_number.text = model.thumbs_num;
    }
    
//    m_dianzan_number.text = @"99999";
    
    //内容
//    CGFloat textHight = [LabelHelper GetLabelHight:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]
//                                           AndText:model.comment
//                                          AndWidth:SCREEN_WIDTH-CGRectGetMinX(m_name.frame)-32];
    
    if(m_content_label == nil){
    
//    NSLog(@"str:%@\nhight:%f",model.comment,textHight);
        m_content_label = [UILabel new];
        m_content_label.numberOfLines = 0;
        m_content_label.textColor = [UIColor colorWithRed:78/255.0 green:82/255.0 blue:82/255.0 alpha:1/1.0];
        m_content_label.textAlignment = NSTextAlignmentLeft;
        m_content_label.font = kFONT(14);
        [self addSubview:m_content_label];
        [m_content_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(m_name.mas_left);
            make.right.equalTo(self.mas_right).with.offset(-kWidth(16));
            make.top.equalTo(m_name.mas_bottom).with.offset(kWidth(15));
//            make.height.mas_offset(textHight);
        }];
    }
    else{
        [m_content_label removeFromSuperview];
        m_content_label = [UILabel new];
        m_content_label.numberOfLines = 0;
        m_content_label.textColor = [UIColor colorWithRed:78/255.0 green:82/255.0 blue:82/255.0 alpha:1/1.0];
        m_content_label.textAlignment = NSTextAlignmentLeft;
        m_content_label.font = kFONT(14);
        [self addSubview:m_content_label];
        [m_content_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(m_name.mas_left);
            make.right.equalTo(self.mas_right).with.offset(-kWidth(16));
            make.top.equalTo(m_name.mas_bottom).with.offset(kWidth(15));
//            make.height.mas_offset(textHight);
        }];
    }
    
//    m_content_label.frame = CGRectMake(CGRectGetMinX(m_name.frame),
//                                       CGRectGetMaxY(m_name.frame)+15,
//                                       SCREEN_WIDTH-CGRectGetMinX(m_name.frame)-32,
//                                       textHight);
    m_content_label.text = model.comment;

//    [m_content_label sizeToFit];
    
    
    //时间
    if(m_time_lable == nil){
        UILabel* time_lable = [UILabel new];
        m_time_lable = time_lable;
        m_time_lable.textColor = [UIColor colorWithRed:122/255.0 green:125/255.0 blue:125/255.0 alpha:1/1.0];
        m_time_lable.textAlignment = NSTextAlignmentLeft;
        m_time_lable.font = kFONT(11);
        [self addSubview:m_time_lable];

        [m_time_lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(m_content_label.mas_left);
            make.top.equalTo(m_content_label.mas_bottom).with.offset(kWidth(10));
            make.height.mas_offset(kWidth(11));
        }];
    }
    else{
        [m_time_lable removeFromSuperview];
        UILabel* time_lable = [UILabel new];
        m_time_lable = time_lable;
        m_time_lable.textColor = [UIColor colorWithRed:122/255.0 green:125/255.0 blue:125/255.0 alpha:1/1.0];
        m_time_lable.textAlignment = NSTextAlignmentLeft;
        m_time_lable.font = kFONT(11);
        [self addSubview:m_time_lable];
        
        [m_time_lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(m_content_label.mas_left);
            make.top.equalTo(m_content_label.mas_bottom).with.offset(kWidth(10));
            make.height.mas_offset(kWidth(11));
        }];
    }
//    m_time_lable.frame = CGRectMake(CGRectGetMinX(m_content_label.frame),
//                                    CGRectGetMaxY(m_content_label.frame)+10,
//                                    90,
//                                    11);
    
    NSString* str_time = [[TimeHelper share] GetDateFromString_yyMMDD_HHMMSS:model.ctime];
    m_time_lable.text = [TimeHelper showTime_reply:str_time];
    
    //评论回复区域
    if(model.array_reply.count > 0){
        if(m_reply_contentView != nil){
            [m_reply_contentView removeFromSuperview];
        }
        UIView* contentView = [UIView new];
        contentView.backgroundColor = RGBA(242, 242, 242, 1);
        [self addSubview:contentView];
        m_reply_contentView = contentView;
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(m_time_lable.mas_left);
            make.right.equalTo(self.mas_right).with.offset(-kWidth(16));
            make.top.equalTo(m_time_lable.mas_bottom).with.offset(kWidth(16));
        }];
        
        UILabel* tmp_view1 = nil;
        UILabel* tmp_view2 = nil;
        [m_tap_array removeAllObjects];//每次都要清空一次
        for (int i = 0;i<model.array_reply.count;i++) {
            if(i == 3){ //最多显示3个回复
                break;
            }
            reply_model* item = model.array_reply[i];
            
            UILabel* name_label = [UILabel new];
            if([item.pid integerValue] == 0){
                name_label.text         = [item.myUserModel.user_name stringByAppendingString:@":"];
                name_label.textColor    = RGBA(122, 125, 125, 1);
            }
            else{
                NSString* str_all = @"";
                if(![item.ToUserModel.user_id isEqualToString:model.myUserModel.user_id]){
                    str_all = [NSString stringWithFormat:@"%@ 回复 %@:",item.myUserModel.user_name,item.ToUserModel.user_name];
                }
                else{
                    str_all = [NSString stringWithFormat:@"%@ 回复:",item.myUserModel.user_name];
                }
//                NSString* str_all = [NSString stringWithFormat:@"%@ 回复 %@:",item.myUserModel.user_name,item.ToUserModel.user_name];
                NSString* str_color = @"回复";
                NSMutableAttributedString* att = [[NSMutableAttributedString alloc] initWithString:str_all];
                att = [LabelHelper GetMutableAttributedSting_color:att AndIndex:0 AndCount:str_all.length AndColor:RGBA(122, 125, 125, 1)];
                att = [LabelHelper GetMutableAttributedSting_color:att
                                                          AndIndex:[str_all rangeOfString:str_color].location
                                                          AndCount:str_color.length
                                                          AndColor:RGBA(255, 129, 3, 1)];
                name_label.attributedText = att;
            }
        
            name_label.textAlignment= NSTextAlignmentLeft;
            name_label.font         = kFONT(13);
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyToName:)];
            [name_label addGestureRecognizer:tap];
            name_label.userInteractionEnabled = YES;
            [m_tap_array addObject:tap];
            [contentView addSubview:name_label];
            if(i == 0){
                [name_label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(contentView.mas_top).offset(kWidth(8));
                    make.left.equalTo(contentView.mas_left).offset(kWidth(8));
                    make.right.equalTo(contentView.mas_right).offset(-kWidth(8));
                    make.height.mas_offset(kWidth(13));
                }];
            }
            else if(i == 1){
                [name_label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(tmp_view1.mas_bottom).offset(kWidth(12));
                    make.left.equalTo(contentView.mas_left).offset(kWidth(8));
                    make.right.equalTo(contentView.mas_right).offset(-kWidth(8));
                    make.height.mas_offset(kWidth(13));
                }];
            }
            else if(i == 2){
                [name_label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(tmp_view2.mas_bottom).offset(kWidth(12));
                    make.left.equalTo(contentView.mas_left).offset(kWidth(8));
                    make.right.equalTo(contentView.mas_right).offset(-kWidth(8));
                    make.height.mas_offset(kWidth(13));
                }];
            }
            
            UILabel* content_label = [UILabel new];
            content_label.text         = item.comment;
            content_label.textColor    = RGBA(34, 39, 39, 1);
            content_label.textAlignment= NSTextAlignmentLeft;
            content_label.font         = kFONT(14);
            content_label.numberOfLines= 0;
            [contentView addSubview:content_label];
            
            switch (i) {
                case 0:
                    tmp_view1 = content_label;
                    break;
                case 1:
                    tmp_view2 = content_label;
                    break;
                    
                default:
                    break;
            }
            
            //查看全部
            if([model.reply_count integerValue] > 3){
                if(i == 2){
                    [content_label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(name_label.mas_bottom).offset(kWidth(5));
                        make.left.equalTo(contentView.mas_left).offset(kWidth(8));
                        make.right.equalTo(contentView.mas_right).offset(-kWidth(8));
                    }];

                    UILabel* reply_all_label = [UILabel new];
                    reply_all_label.text         = @"查看全部回复";
                    reply_all_label.textColor    = RGBA(255, 129, 3, 1);
                    reply_all_label.textAlignment= NSTextAlignmentRight;
                    reply_all_label.font         = kFONT(12);
                    reply_all_label.userInteractionEnabled = YES;
                    UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reply_all_action)];
                    [reply_all_label addGestureRecognizer:tap1];
                    [contentView addSubview:reply_all_label];
                    [reply_all_label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(content_label.mas_bottom).offset(kWidth(12));
                        make.right.equalTo(contentView.mas_right).offset(-kWidth(8));
                        make.left.equalTo(contentView.mas_left).offset(kWidth(8));
                        make.height.mas_offset(kWidth(12));
                        make.bottom.equalTo(contentView.mas_bottom).offset(-kWidth(8));
                    }];
                }
                else{
                    [content_label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(name_label.mas_bottom).offset(kWidth(5));
                        make.left.equalTo(contentView.mas_left).offset(kWidth(8));
                        make.right.equalTo(contentView.mas_right).offset(-kWidth(8));
                    }];
                }

            }
            else{
                if(i+1 == model.array_reply.count){
                    [content_label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(name_label.mas_bottom).offset(kWidth(5));
                        make.left.equalTo(contentView.mas_left).offset(kWidth(8));
                        make.right.equalTo(contentView.mas_right).offset(-kWidth(8));
                        make.bottom.equalTo(contentView.mas_bottom).offset(-kWidth(8));
                    }];
                }
                else{
                    [content_label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(name_label.mas_bottom).offset(kWidth(5));
                        make.left.equalTo(contentView.mas_left).offset(kWidth(8));
                        make.right.equalTo(contentView.mas_right).offset(-kWidth(8));
                    }];
                }
            }
        }

    }
    else{
        if(m_reply_contentView != nil){
            [m_reply_contentView removeFromSuperview];
            m_reply_contentView = nil;
        }
    }
    
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
    }
    else{
        [m_line removeFromSuperview];
    }
    m_line = [UIView new];
    m_line.backgroundColor = RGBA(242, 242, 242, 1);
    [self addSubview:m_line];
    if(model.array_reply.count > 0){
        [m_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(m_time_lable.mas_left);
            make.right.equalTo(self.mas_right).with.offset(-kWidth(16));
            make.top.equalTo(m_reply_contentView.mas_bottom).with.offset(kWidth(16));
            make.height.mas_offset(kWidth(1));
        }];
    }
    else{
        [m_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(m_time_lable.mas_left);
            make.right.equalTo(self.mas_right).with.offset(-kWidth(16));
            make.top.equalTo(m_time_lable.mas_bottom).with.offset(kWidth(16));
            make.height.mas_offset(kWidth(1));
        }];
    }
//    m_line.frame = CGRectMake(16, CGRectGetMaxY(m_time_lable.frame)+16, SCREEN_WIDTH-16-16, 1);
    [self layoutIfNeeded];
}

-(void)replyToName:(UITapGestureRecognizer*)tap{
    NSInteger index = [m_tap_array indexOfObject:tap];
    reply_model* model = _model.array_reply[index];
    NSLog(@"%@",model.myUserModel.user_name);
    [self.delegate replyFromMymodel:model];
}

-(void)reply_all_action{
    NSLog(@"查看全部");
    if(self.delegate != nil){
        [self.delegate GoToReplyAll:_model];
    }
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
    if(![Login_info share].isLogined){
        [MyMBProgressHUD ShowMessage:@"未登录!" ToView:[UIApplication sharedApplication].keyWindow AndTime:1.0f];
        return;
    }
    NSInteger action = self.model.DianZan_type;
    action = action == 1 ? 2 : 1;//1：点赞    2：取消点赞
    
    [InternetHelp DianzanById:self.model.ID andUser_id:[Login_info share].userInfo_model.user_id AndActionType:action];
    
    NSInteger reply_id = [self.model.ID integerValue];
    if([[MyDataBase shareManager] DianZan_IsHaveId:reply_id]){//是否存在该ID的记录
        //存在
        if([[MyDataBase shareManager] DianZan_IsDianZan:reply_id]){ //是否已经点赞
            //点赞
            [[MyDataBase shareManager] DianZan_UpData:reply_id AndIsDIanZan:0];
            [bt setImage:[UIImage imageNamed:@"ic_like"] forState:UIControlStateNormal];
            [self setDianZanNum_type:0];
            self.model.DianZan_type = 0;
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"点赞" object:self.model];
        }else{
            //没有点赞
            [[MyDataBase shareManager] DianZan_UpData:reply_id AndIsDIanZan:1];
            [bt setImage:[UIImage imageNamed:@"ic_liked"] forState:UIControlStateNormal];
            [self setDianZanNum_type:1];
            self.model.DianZan_type = 1;
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"点赞" object:self.model];
        }
    }else{
        //不存在
        [[MyDataBase shareManager] DianZan_insertData:reply_id AndIsDIanZan:1];
        [bt setImage:[UIImage imageNamed:@"ic_liked"] forState:UIControlStateNormal];
        [self setDianZanNum_type:1];
        self.model.DianZan_type = 1;
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"点赞" object:self.model];
    }
}

-(void)dianzan_InitState:(reply_model*)model{
    
    NSInteger reply_id = [model.ID integerValue];
    if([[MyDataBase shareManager] DianZan_IsHaveId:reply_id]){//是否存在该ID的记录
        //存在
        if([[MyDataBase shareManager] DianZan_IsDianZan:reply_id]){ //是否已经点赞
            [m_dianzan setImage:[UIImage imageNamed:@"ic_liked"] forState:UIControlStateNormal];
            self.model.DianZan_type = 1;
        }else{
            //没有点赞
            [m_dianzan setImage:[UIImage imageNamed:@"ic_like"] forState:UIControlStateNormal];
            self.model.DianZan_type = 0;
        }
    }else{
        //不存在
        [m_dianzan setImage:[UIImage imageNamed:@"ic_like"] forState:UIControlStateNormal];
        self.model.DianZan_type = 0;
    }
}

-(void)setDianZanNum_type:(NSInteger)type{
    NSInteger num = [_model.thumbs_num integerValue];
    if(type == 0){//取消点赞
        if(IsDianZan){//起始点赞的状态
            num -= 1;
            if(num < 0){
                num = 0;
            }
            IsDianZan = NO;
        }
        if(num > 0){
            m_dianzan_number.text = [NSString stringWithFormat:@"%ld",num];
        }else{
            m_dianzan_number.text = [NSString stringWithFormat:@"0"];
        }
    }else{//点赞
        if(!IsDianZan){//起始点赞的状态
            num += 1;
            IsDianZan = YES;
        }
        m_dianzan_number.text = [NSString stringWithFormat:@"%ld",num];
    }
    _model.thumbs_num = [NSString stringWithFormat:@"%ld",num];
}

@end
