//
//  video_TableViewCell.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "video_TableViewCell.h"

@implementation video_TableViewCell
{
    //视频来源
    UIImageView*        m_video_icon;
    UILabel*            m_video_resouce;
    UIButton*           m_video_share;
    
    UIView*             m_line;

}

+(instancetype)CellFormTable:(UITableView *)tableView{
    static NSString *ID = @"videl_tableviewCell";
    video_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (cell == nil) {
        cell = [[video_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

+(CGFloat)cellForHeight{
    return kWidth(256);
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    
    self.m_playerView = [[MyPlayerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kWidth(202))];
    [self.m_playerView.fullScreenButton addTarget:self action:@selector(fullscreenActoin) forControlEvents:UIControlEventTouchUpInside];
    [self.m_playerView.back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.m_playerView];
    
    //由于不让在列表界面播放视频
    UIView* coverPaly_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kWidth(202))];
    [self addSubview:coverPaly_view];
    UITapGestureRecognizer* tap_coverView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GoToDetail)];
    [coverPaly_view addGestureRecognizer:tap_coverView];
    
    //视频 作者
    UIView* info_view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.m_playerView.frame), SCREEN_WIDTH, kHeight(44))];
    info_view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GoToDetail)];
    [info_view addGestureRecognizer:tap];
    [self addSubview:info_view];
    
    //作者图标
    m_video_icon = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth(16),
                                                                 kHeight(6),
                                                                 info_view.frame.size.height-kHeight(6)-kHeight(6),
                                                                 info_view.frame.size.height-kHeight(6)-kHeight(6))];
    [m_video_icon.layer setCornerRadius:m_video_icon.frame.size.width/2];
    m_video_icon.layer.masksToBounds = YES;
    m_video_icon.userInteractionEnabled = YES;
    [info_view addSubview:m_video_icon];
    
    //作者名称
    m_video_resouce = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(m_video_icon.frame)+kWidth(10),
                                                                kHeight(15),
                                                                kWidth(100),
                                                                info_view.frame.size.height-kWidth(15)-kWidth(15))];
    m_video_resouce.lineBreakMode = NSLineBreakByTruncatingTail;
    m_video_resouce.textColor = RGBA(122, 125, 125, 1);
    m_video_resouce.textAlignment = NSTextAlignmentLeft;
    m_video_resouce.font = kFONT(14);
    [info_view addSubview:m_video_resouce];
    
    //分享
    m_video_share = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-kWidth(16)-kWidth(40), 0, kWidth(40), info_view.frame.size.height)];
    [m_video_share setImage:[UIImage imageNamed:@"video_more"] forState:UIControlStateNormal];
    [m_video_share setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    [m_video_share addTarget:self action:@selector(shareMore) forControlEvents:UIControlEventTouchUpInside];
    [info_view addSubview:m_video_share];
    
    //分界线
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(info_view.frame), SCREEN_WIDTH, kWidth(10))];
    line.backgroundColor = RGBA(242, 242, 242, 1);
    [self addSubview:line];
    m_line = line;
}

-(void)setModel:(video_info_model *)model{
    
    self.data_model = model;
    
    self.m_playerView.model = model;
    
    if(model.avatar.length > 0){
        [m_video_icon sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"list_avatar"]];
    }
    else{
        [m_video_icon setImage:[UIImage imageNamed:@"list_avatar"]];
    }
    
//    NSLog(@"----avatar:%@",model.avatar);
    m_video_resouce.text = model.source;
    
    if(model.isRreadHere){
        if(self.readingHere == nil){
            UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_line.frame), SCREEN_WIDTH, kWidth(30))];
            view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
            
            self.readingHere_btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kWidth(30))];
            [self.readingHere_btn setTitle:[NSString stringWithFormat:@"%@ 看到这里,点击刷新",[TimeHelper showTime:model.getVideoTime]] forState:UIControlStateNormal];
            [self.readingHere_btn setTitleColor:RGBA(255, 129, 3, 1) forState:UIControlStateNormal];
            [self.readingHere_btn.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:kWidth(16)]];
            [self.readingHere_btn addTarget:self action:@selector(readHere_action) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:self.readingHere_btn];
            
            self.readingHere = view;
            [self addSubview:view];
        }else{
            [self.readingHere setHidden:NO];
            [self.readingHere_btn setTitle:[NSString stringWithFormat:@"%@ 看到这里,点击刷新",[TimeHelper showTime:model.getVideoTime]] forState:UIControlStateNormal];
        }
    }else{
        [self.readingHere setHidden:YES];
    }

}


#pragma mark - 按钮
-(void)shareMore{
    [self.delegate shareAction:self.data_model];
}
-(void)GoToDetail{
    [self.delegate GoToVideoDetail:self.data_model];
}
-(void)fullscreenActoin{
    if(!self.m_playerView.isFullScreen){
        [self.delegate fullScreen:self.data_model AndView:self.m_playerView];
        [self.m_playerView.fullScreenButton setImage:[UIImage imageNamed:@"ic_zoom"] forState:UIControlStateNormal];
    }else{
        [self.delegate ToCell];
        [self.m_playerView.fullScreenButton setImage:[UIImage imageNamed:@"ic_full"] forState:UIControlStateNormal];
    }
    
    self.m_playerView.isFullScreen = !self.m_playerView.isFullScreen;
}

-(void)back{
    [self.delegate backFromFullScreen];
}

-(void)readHere_action{
    NSLog(@"视频点击刷新");
    [self.delegate Refresh];
}

#pragma mark - 时间转换
// sec 转换成指定的格式
- (NSString *)convertToTime:(CGFloat)time
{
    // 初始化格式对象
    NSDateFormatter *fotmmatter = [[NSDateFormatter alloc] init];
    // 根据是否大于1H，进行格式赋值
    if (time >= 3600)
    {
        [fotmmatter setDateFormat:@"HH:mm:ss"];
    }
    else
    {
        [fotmmatter setDateFormat:@"mm:ss"];
    }
    // 秒数转换成NSDate类型
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    // date转字符串
    return [fotmmatter stringFromDate:date];
}

@end
