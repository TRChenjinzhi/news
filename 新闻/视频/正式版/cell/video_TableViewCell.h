//
//  video_TableViewCell.h
//  新闻
//
//  Created by chenjinzhi on 2018/3/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "video_info_model.h"
#import <AVFoundation/AVFoundation.h>
#import "MyPlayerView.h"

@protocol video_info_model_To_video_info_VCL_protocol

@optional
-(void)shareAction:(video_info_model*)model;
-(void)GoToVideoDetail:(video_info_model*)model;
-(void)fullScreen:(video_info_model*)model AndView:(MyPlayerView*)playView;
-(void)ToCell;
-(void)backFromFullScreen;
-(void)Refresh;
@end

@interface video_TableViewCell : UITableViewCell

 @property (nonatomic,strong)MyPlayerView* m_playerView;
@property (nonatomic,weak)id delegate;
@property (nonatomic,strong)video_info_model* model;//传入的数据

@property (nonatomic,strong)video_info_model* data_model;//数据改写

@property (nonatomic,strong) AVPlayer* player; // 播放器
@property (nonatomic,strong) AVPlayerItem* playerItem; // 播放器属性对象
@property (nonatomic,strong) AVPlayerLayer* playerLayer; // 播放器需要的layer

@property (nonatomic,strong)UILabel*  left_time;
@property (nonatomic,strong)UILabel*  right_time;
@property (nonatomic,assign) BOOL isDragSlider; // 是否拖动Slider
@property (nonatomic,strong) UISlider *slider;

@property (nonatomic,strong)UIView* readingHere;
@property (nonatomic,strong)UIButton* readingHere_btn;

+(instancetype)CellFormTable:(UITableView *)tableView;
+(CGFloat)cellForHeight;

@end
