//
//  MyPlayerView.h
//  新闻
//
//  Created by chenjinzhi on 2018/4/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "video_info_model.h"
#import <AVFoundation/AVFoundation.h>

@protocol MyPlayerView_ptotocl

@optional
-(void)MyPlayerView_videoPlay:(video_info_model*)model AndMyPlayerView:(id)Player_self;
-(void)MyPlayerVIew_PlayOver;
-(void)MyPlayer_giveGold:(video_info_model*)model;
@end

@interface MyPlayerView : UIView

@property (nonatomic,weak)id delegate;

@property (nonatomic,strong)video_info_model* model;//传入的数据
@property (nonatomic,strong)video_info_model* data_model;//数据改写

@property (nonatomic,strong) AVPlayer* player; // 播放器
@property (nonatomic,strong) AVPlayerItem* playerItem; // 播放器属性对象
@property (nonatomic,strong) AVPlayerLayer* playerLayer; // 播放器需要的layer

@property (nonatomic,strong)UILabel*  left_time;
@property (nonatomic,strong)UILabel*  right_time;
@property (nonatomic,assign)BOOL isDragSlider; // 是否拖动Slider
@property (nonatomic,strong)UIView* MyProgressView;
@property (nonatomic,strong)UISlider *slider;

@property (nonatomic,strong)UIImageView* m_topView;//视频文字

@property (nonatomic,strong)UIImageView* m_imgView;

@property (nonatomic,strong)UIButton* fullScreenButton;
@property (nonatomic)BOOL isFullScreen;// 是否全屏

@property (nonatomic,strong)UIButton* back;//返回

-(void)playerInFullScreen;
-(void)initView;
-(void)playAction;
-(void)initAll;

@end
