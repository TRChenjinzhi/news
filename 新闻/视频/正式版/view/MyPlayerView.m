//
//  MyPlayerView.m
//  新闻
//
//  Created by chenjinzhi on 2018/4/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyPlayerView.h"

#define Timer_count 8.0f
#define animateTime 0.5f

@implementation MyPlayerView{
    
    UIProgressView* progressView;
    UILabel*            m_title;
    
    //初始
    UIView*             m_buttomView;
    UIButton*           m_center_play;
    UIView*             m_total_time;
    UILabel*            m_total_time_label;

    NSTimer*            autoDismissTimer;// 定时器 自动消失View
    BOOL                isBegainPlay;
    
    CGFloat             m_width;
    CGFloat             m_height;
    id                  m_timeObserver;
    
    UIView*             m_playFailed_view;
    UIView*             m_playWaiting_view;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        m_width = frame.size.width;
        m_height = frame.size.height;
        [self initView];
    }
    return self;
}

-(void)initView{
    
    self.m_imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, m_width, m_height)];
    self.m_imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap_img = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTap)];
    [self.m_imgView addGestureRecognizer:tap_img];
    [self addSubview:self.m_imgView];
    [self.m_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.and.right.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //返回
    self.back = [UIButton new];
    [self.back setImage:[UIImage imageNamed:@"ic_nav_white"] forState:UIControlStateNormal];
    [self.m_imgView addSubview:self.back];
    [self.back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.m_imgView.mas_left).with.offset(kWidth(16));
        make.top.equalTo(self.m_imgView.mas_top).with.offset(kWidth(16));
        make.height.width.mas_equalTo(kWidth(32));
    }];
    
    
    //视屏上方描述文字
    self.m_topView = [UIImageView new];
    [self.m_topView setImage:[UIImage imageNamed:@"text_top"]];
    [self addSubview:self.m_topView];
    [self.m_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.m_imgView.mas_left).with.offset(kWidth(0));
        make.right.equalTo(self.m_imgView.mas_right).with.offset(-kWidth(0));
        make.top.equalTo(self.m_imgView.mas_top).with.offset(kHeight(0));
    }];
    
    UILabel* title = [UILabel new];
    title.textColor = RGBA(255, 255, 255, 1);
    title.textAlignment = NSTextAlignmentLeft;
    title.numberOfLines = 0;
    title.font = kFONT(16);
    [self.m_topView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.m_topView.mas_left).with.offset(kWidth(16+32+10));
        make.right.equalTo(self.m_topView.mas_right).with.offset(-kWidth(16));
        make.top.equalTo(self.m_topView.mas_top).with.offset(kHeight(16));
        make.bottom.equalTo(self.m_topView.mas_bottom).with.offset(-kWidth(16));
    }];
    m_title = title;
    
    
    //中间play按钮
    m_center_play = [[UIButton alloc] initWithFrame:CGRectMake(m_width/2-kWidth(50)/2, m_height/2-kHeight(50)/2, kWidth(50), kHeight(50))];
    [m_center_play setImage:[UIImage imageNamed:@"ic_play"] forState:UIControlStateNormal];
    [m_center_play addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    [self.m_imgView addSubview:m_center_play];
    [m_center_play mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth(50));
        make.height.mas_equalTo(kWidth(50));
        make.center.mas_equalTo(self.m_imgView);
    }];
    
    //时长
    m_total_time = [[UIView alloc] init];
    [m_total_time.layer setCornerRadius:kWidth(22/2)];
    m_total_time.backgroundColor = RGBA(0, 0, 0, 0.4);
    [self.m_imgView addSubview:m_total_time];
    [m_total_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kHeight(22));
        make.width.mas_equalTo(kWidth(48));
        make.bottom.mas_equalTo(self.m_imgView.mas_bottom).with.offset(-kHeight(10));
        make.right.mas_equalTo(self.m_imgView.mas_right).with.offset(-kHeight(16));
    }];
    
    m_total_time_label = [[UILabel alloc] initWithFrame:CGRectMake(kWidth(8),
                                                                   kWidth(4),
                                                                   m_total_time.frame.size.width-kWidth(8)-kWidth(8),
                                                                   m_total_time.frame.size.height-kWidth(4)-kWidth(4))];
    m_total_time_label.textColor = RGBA(255, 255, 255, 1);
    m_total_time_label.textAlignment = NSTextAlignmentCenter;
    m_total_time_label.font = kFONT(10);
    [m_total_time addSubview:m_total_time_label];
    [m_total_time_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(m_total_time).with.insets(UIEdgeInsetsMake(kWidth(4), kWidth(8), kWidth(4), kWidth(8)));
    }];
    
    [self initBottomView];
    m_buttomView.alpha = 0.0f;
}

-(void)initBottomView{
    
    m_buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame)-kWidth(30), m_width, kWidth(30))];
    [m_buttomView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"text_bottom"]]];
    [self addSubview:m_buttomView];
    [m_buttomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(self.m_imgView);
        make.height.mas_equalTo(kWidth(30));
    }];
    
    self.left_time = [[UILabel alloc] initWithFrame:CGRectMake(kWidth(16), m_buttomView.frame.size.height-kWidth(8)-kWidth(16), kWidth(36), kWidth(16))];
    self.left_time.textColor = RGBA(255, 255, 255, 1);
    self.left_time.textAlignment = NSTextAlignmentLeft;
    self.left_time.font = kFONT(12);
    [m_buttomView addSubview:self.left_time];
    [self.left_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(m_buttomView).with.offset(kWidth(16));
//        make.bottom.mas_equalTo(m_buttomView).with.offset(-kWidth(8));
        make.centerY.equalTo(m_buttomView.mas_centerY);
        make.width.mas_equalTo(kWidth(36));
        make.height.mas_equalTo(kWidth(16));
    }];
    
    self.fullScreenButton = [[UIButton alloc] initWithFrame:CGRectMake(m_width-kWidth(16)-kWidth(16),
                                                                       m_buttomView.frame.size.height-kWidth(8)-kWidth(16),
                                                                       kWidth(16),
                                                                       kWidth(16))];
    [self.fullScreenButton setImage:[UIImage imageNamed:@"ic_full"] forState:UIControlStateNormal];
    [self.fullScreenButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [m_buttomView addSubview:self.fullScreenButton];
    [self.fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(m_buttomView.mas_right).with.offset(-kWidth(16));
//        make.bottom.mas_equalTo(m_buttomView.mas_bottom);
        make.centerY.equalTo(m_buttomView.mas_centerY);
        make.width.mas_equalTo(kWidth(32));
        make.height.mas_equalTo(kWidth(32));
    }];
    
    self.right_time = [[UILabel alloc] initWithFrame:CGRectMake(m_width-kWidth(16)-kWidth(9)-kWidth(10)-kWidth(36),
                                                                m_buttomView.frame.size.height-kWidth(8)-kWidth(16),
                                                                kWidth(36),
                                                                kWidth(16))];
    self.right_time.textColor = RGBA(255, 255, 255, 1);
    self.right_time.textAlignment = NSTextAlignmentCenter;
    self.right_time.font = kFONT(12);
    [m_buttomView addSubview:self.right_time];
    [self.right_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.fullScreenButton.mas_left).offset(-kWidth(0));
//        make.bottom.mas_equalTo(m_buttomView).offset(-kWidth(8));
        make.centerY.equalTo(m_buttomView.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(kWidth(36));
        make.height.mas_equalTo(kWidth(16));
    }];
    
    //进度条 视图
    self.MyProgressView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.left_time.frame)+kWidth(8),
                                                                   CGRectGetMaxY(self.left_time.frame),
                                                                   m_width-CGRectGetMinX(self.right_time.frame)-CGRectGetMaxX(self.left_time.frame)-kWidth(8+8),
                                                                   kWidth(10))];
//    self.MyProgressView.backgroundColor = RGBA(0, 0, 0, 0.4);
//    self.MyProgressView.backgroundColor = [UIColor redColor];
    [m_buttomView addSubview:self.MyProgressView];
    UITapGestureRecognizer *tapSlider = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSlider:)];
    [self.MyProgressView addGestureRecognizer:tapSlider];
    [self.MyProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.left_time.mas_right).with.offset(kWidth(8));
        make.right.mas_equalTo(self.right_time.mas_left).with.offset(-kWidth(8));
//        make.bottom.mas_equalTo(m_buttomView.mas_bottom).offset(-kWidth(15));
        make.bottom.mas_equalTo(m_buttomView.mas_bottom);
        make.top.equalTo(m_buttomView.mas_top);
    }];
    
    // 底部缓存进度条
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.progressTintColor = [UIColor lightGrayColor];
    progressView.trackTintColor = RGBA(255, 255, 255, 0.4);
    //    [m_buttomView addSubview:progressView];
    [progressView setProgress:0.0 animated:NO];
    [self.MyProgressView addSubview:progressView];
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.MyProgressView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.left.and.right.equalTo(self.MyProgressView);
//        make.top.equalTo(self.MyProgressView.mas_top).offset(kWidth(5));
        make.centerY.equalTo(self.MyProgressView.mas_centerY);
        make.height.mas_offset(kWidth(2));
    }];
 
    // 底部进度条
    self.slider = [UISlider new];
    self.slider.minimumValue = 0.0;
    self.slider.minimumTrackTintColor = RGBA(248, 205, 4, 1);
    self.slider.maximumTrackTintColor = [UIColor clearColor];
    self.slider.value = 0.0;
    [self.slider setThumbImage:[Color_Image_Helper imageResize:[UIImage imageNamed:@"ic_ball"] andResizeTo:CGSizeMake(kWidth(10), kWidth(10))] forState:UIControlStateNormal];
    [self.slider addTarget:self action:@selector(sliderDragValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.slider addTarget:self action:@selector(sliderTapValueChange:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.MyProgressView addSubview:self.slider];
    [self.MyProgressView bringSubviewToFront:self.slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.MyProgressView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.left.and.right.equalTo(self.MyProgressView);
//        make.top.equalTo(self.MyProgressView.mas_top).offset(kWidth(5));
        make.centerY.equalTo(self.MyProgressView.mas_centerY);
        make.height.mas_offset(kWidth(2));
    }];
}


-(void)initPlayer:(video_info_model*)model{
    // 初始化播放器item
    self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:model.url]];
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    // 初始化播放器的Layer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    // layer的frame
    self.playerLayer.frame = self.bounds;
    // layer的填充属性 和UIImageView的填充属性类似
    // AVLayerVideoGravityResizeAspect //等比例填充，直到一个维度到达区域边界
    // AVLayerVideoGravityResizeAspectFill // 等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
    // AVLayerVideoGravityResize //  // 非均匀模式。两个维度完全填充至整个视图区域
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    // 把Layer加到底部View上
    [self.m_imgView.layer insertSublayer:self.playerLayer atIndex:0];
    [self.m_imgView setImage:[Color_Image_Helper createImageWithColor:[UIColor blackColor]]];
    // 监听播放器状态变化
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 监听缓存大小
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //监听是否有缓存 能否播放
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)setModel:(video_info_model *)model{
    
    self.data_model = model;
    [progressView setProgress:0.0 animated:NO];
    self.slider.value = 0.0;
    
    [self.m_imgView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    
    m_total_time_label.text = [self convertToTime:[model.duration floatValue]];
    
//    CGFloat text_hight = [LabelHelper GetLabelHight:kFONT(16) AndText:model.title AndWidth:m_topView.frame.size.width];
//    m_topView.frame = CGRectMake(m_topView.frame.origin.x, m_topView.frame.origin.y, m_topView.frame.size.width, text_hight);
    m_title.text = model.title;
    
    [self initAll];
//    NSLog(@"initAll:%@",model.title);
}

#pragma mark - 按钮
-(void)playAction{
    
    //第一次点击播放
    if(!isBegainPlay){
        [m_total_time setHidden:YES];
        if(self.player == nil){
            if(self.delegate != nil){
                [self.delegate MyPlayerView_videoPlay:self.data_model AndMyPlayerView:self]; //只允许一个视频在播放
            }
            [self initPlayer:self.data_model];
            [self.MyProgressView removeFromSuperview];
            [self.m_imgView addSubview:self.MyProgressView];
            [self.MyProgressView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.m_imgView);
                make.height.mas_equalTo(kWidth(2));
            }];
            [UIView animateWithDuration:animateTime animations:^{
                self.m_topView.alpha = 0.0f;
                m_center_play.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [self.MyProgressView layoutIfNeeded];
            }];
            
            //续播
            if(self.data_model.video_playTime > 0){
                CGFloat scale = self.data_model.video_playTime/[self.data_model.duration floatValue];
                self.slider.value = [self.data_model.duration floatValue] * scale;
                [self.player seekToTime:CMTimeMakeWithSeconds(self.data_model.video_playTime, self.playerItem.currentTime.timescale)];
            }
        }
    }
    isBegainPlay = YES;
    
    if (self.player.rate != 1.0f)
    {
        [m_center_play setImage:[UIImage imageNamed:@"ic_stop"] forState:UIControlStateNormal];
        [self.player play];
    }
    else
    {
        [m_center_play setImage:[UIImage imageNamed:@"ic_play"] forState:UIControlStateNormal];
        [self.player pause];
    }
}

-(void)playerInFullScreen{
    if (self.player.rate == 1.0f) //如果在播放就暂停
    {
        [m_center_play setImage:[UIImage imageNamed:@"ic_play"] forState:UIControlStateNormal];
        [self.player pause];
    }
}

- (void)imgTap
{
    if(!isBegainPlay){
        return;
    }
    // 和即时搜索一样，删除之前未执行的操作
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoDismissView:) object:nil];
    
    // 这里点击会隐藏对应的View，那么之前的定时还开着，如果不关掉，就会可能重复
    [autoDismissTimer invalidate];
    autoDismissTimer = nil;
    autoDismissTimer = [NSTimer timerWithTimeInterval:Timer_count target:self selector:@selector(autoDismissView:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:autoDismissTimer forMode:NSDefaultRunLoopMode];
    
    if (m_buttomView.alpha == 1)
    {
        [self.MyProgressView removeFromSuperview];
        [self.m_imgView addSubview:self.MyProgressView];
        [self.MyProgressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.equalTo(self.m_imgView);
            make.height.mas_equalTo(kWidth(2));
        }];
//        [self.MyProgressView layoutIfNeeded];
        [UIView animateWithDuration:animateTime animations:^{
            
            self.back.alpha = 0;
            m_buttomView.alpha = 0;
            self.m_topView.alpha = 0;
            m_center_play.alpha = 0;
        } completion:^(BOOL finished) {
            [self.MyProgressView layoutIfNeeded];
        }];
        
    }
    else if (m_buttomView.alpha == 0)
    {
        [self.MyProgressView removeFromSuperview];
        [m_buttomView addSubview:self.MyProgressView];
        [self.MyProgressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.left_time.mas_right).with.offset(kWidth(8));
            make.right.mas_equalTo(self.right_time.mas_left).with.offset(-kWidth(8));
            //        make.bottom.mas_equalTo(m_buttomView.mas_bottom).offset(-kWidth(15));
            make.bottom.mas_equalTo(m_buttomView.mas_bottom).offset(0);
            make.height.mas_equalTo(kWidth(30));
        }];
//        [self.MyProgressView layoutIfNeeded];
        [UIView animateWithDuration:animateTime animations:^{
            self.back.alpha = 1.0f;
            m_buttomView.alpha = 1.0f;
            self.m_topView.alpha = 1.0f;
            m_center_play.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [self.MyProgressView layoutIfNeeded];
        }];
    }
    
}

// 监听播放器的变化属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"])
    {
        AVPlayerItemStatus statues = [change[NSKeyValueChangeNewKey] integerValue];
        switch (statues) {
            case AVPlayerItemStatusReadyToPlay:
                
                [m_playFailed_view removeFromSuperview];
                
                // 最大值直接用sec，以前都是
                // CMTimeMake(帧数（slider.value * timeScale）, 帧/sec)
                self.slider.maximumValue = CMTimeGetSeconds(self.playerItem.duration);
                [self initTimer];
                
                // 启动定时器 5秒自动隐藏
                if (!autoDismissTimer)
                {
                    autoDismissTimer = [NSTimer timerWithTimeInterval:Timer_count target:self selector:@selector(autoDismissView:) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:autoDismissTimer forMode:NSDefaultRunLoopMode];
                }
                break;
            case AVPlayerItemStatusUnknown:
                
                break;
            case AVPlayerItemStatusFailed:
                [m_playFailed_view removeFromSuperview];
                [self PlayFailed];
                break;
                
            default:
                break;
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"]) // 监听缓存进度的属性
    {
        // 计算缓存进度
        NSTimeInterval timeInterval = [self availableDuration];
        // 获取总长度
        CMTime duration = self.playerItem.duration;
        
        CGFloat durationTime = CMTimeGetSeconds(duration);
        // 监听到了给进度条赋值
        [progressView setProgress:timeInterval / durationTime animated:NO];
    }
    else if([keyPath isEqualToString:@"playbackBufferEmpty"]){ //是否有缓存可以播放
        [self PlayWaiting];
    }else if([keyPath isEqualToString:@"playbackLikelyToKeepUp"]){
        [m_playWaiting_view removeFromSuperview];
    }
    
}

-(void)PlayFailed{
    if(m_playFailed_view == nil){
        m_playFailed_view = [UIView new];
        m_playFailed_view.backgroundColor = [UIColor blackColor];
        [self addSubview:m_playFailed_view];
        [m_playFailed_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.m_imgView.mas_left).with.offset(kWidth(0));
            make.right.equalTo(self.m_imgView.mas_right).with.offset(-kWidth(0));
            make.top.equalTo(self.m_imgView.mas_top).with.offset(kHeight(0));
            make.bottom.equalTo(self.m_imgView.mas_bottom);
        }];
        
        //视屏上方描述文字
        UIView* title_view = [UIImageView new];
        [m_playFailed_view addSubview:title_view];
        [title_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.m_imgView.mas_left).with.offset(kWidth(0));
            make.right.equalTo(self.m_imgView.mas_right).with.offset(-kWidth(0));
            make.top.equalTo(self.m_imgView.mas_top).with.offset(kHeight(0));
        }];
        
        UILabel* title = [UILabel new];
        title.text = self.data_model.title;
        title.textColor = RGBA(255, 255, 255, 1);
        title.textAlignment = NSTextAlignmentLeft;
        title.numberOfLines = 0;
        title.font = kFONT(16);
        [self.m_topView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.m_topView.mas_left).with.offset(kWidth(16));
            make.right.equalTo(self.m_topView.mas_right).with.offset(-kWidth(16));
            make.top.equalTo(self.m_topView.mas_top).with.offset(kHeight(16));
            make.bottom.equalTo(self.m_topView.mas_bottom).with.offset(-kWidth(16));
        }];
        
        UILabel* tips = [UILabel new];
        tips.text = @"视频加载失败";
        tips.textColor = [UIColor whiteColor];
        tips.textAlignment = NSTextAlignmentCenter;
        tips.font = kFONT(14);
        [m_playFailed_view addSubview:tips];
        [tips mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(m_playFailed_view.mas_left).with.offset(kWidth(0));
            make.right.equalTo(m_playFailed_view.mas_right).with.offset(-kWidth(0));
            make.centerX.equalTo(m_playFailed_view.mas_centerX).with.offset(kWidth(30)+kWidth(17));
            make.top.equalTo(title_view.mas_bottom).with.offset(kWidth(10));
        }];
        
        UIButton* relaod_btn = [UIButton new];
        relaod_btn.backgroundColor = [UIColor blackColor];
        [relaod_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [relaod_btn addTarget:self action:@selector(reloadPlay) forControlEvents:UIControlEventTouchUpInside];
        [relaod_btn setTitle:@"点击重试" forState:UIControlStateNormal];
        [relaod_btn.titleLabel setFont:kFONT(15)];
        [relaod_btn.layer setBorderWidth:1.0];
        [relaod_btn.layer setBorderColor:[UIColor whiteColor].CGColor];
        [relaod_btn.layer setCornerRadius:kWidth(5)];
        [m_playFailed_view addSubview:relaod_btn];
        [relaod_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tips.mas_bottom).with.offset(kWidth(10));
            make.height.mas_equalTo(kWidth(30));
            make.width.mas_equalTo(kWidth(80));
            make.centerY.equalTo(m_playFailed_view.mas_centerY).with.offset(0);
            make.centerX.equalTo(m_playFailed_view.mas_centerX).with.offset(0);
        }];
    }else{
        [self addSubview:m_playFailed_view];
        [self.m_imgView bringSubviewToFront:m_playFailed_view];
        [m_playFailed_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.m_imgView.mas_left).with.offset(kWidth(0));
            make.right.equalTo(self.m_imgView.mas_right).with.offset(-kWidth(0));
            make.top.equalTo(self.m_imgView.mas_top).with.offset(kHeight(0));
            make.bottom.equalTo(self.m_imgView.mas_bottom);
        }];
    }
    
    
}

-(void)reloadPlay{
    [m_playFailed_view removeFromSuperview];
    [self initAll];
    self.model = self.data_model;
    [self playAction];
}

-(void)PlayWaiting{
    if(m_playWaiting_view == nil){
        m_playWaiting_view = [UIView new];
//        m_playWaiting_view.backgroundColor = RGBA(255, 255, 255, 0.2);
        [self.m_imgView addSubview:m_playWaiting_view];
        [self.m_imgView bringSubviewToFront:m_playWaiting_view];
        [m_playWaiting_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.m_imgView);
            make.height.mas_equalTo(kWidth(60));
            make.width.mas_equalTo(kWidth(60));
        }];
        
        UIActivityIndicatorView* waitingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [m_playWaiting_view addSubview:waitingView];
        [waitingView startAnimating];
        [waitingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(m_playWaiting_view);
            make.height.mas_equalTo(kWidth(30));
            make.width.mas_equalTo(kWidth(30));
        }];
    }else{
        [self.m_imgView addSubview:m_playWaiting_view];
        [self.m_imgView bringSubviewToFront:m_playWaiting_view];
        [m_playWaiting_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.m_imgView);
            make.height.mas_equalTo(kWidth(60));
            make.width.mas_equalTo(kWidth(60));
        }];
    }
    
    
}

-(void)initAll{
    [self.m_imgView sd_setImageWithURL:[NSURL URLWithString:self.data_model.cover]];
    //初始化
    m_playFailed_view = nil;
    m_playWaiting_view = nil;
    
    self.slider.value = 0.0;
    [progressView setProgress:0.0 animated:NO];
    isBegainPlay = NO;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoDismissView:) object:nil];
    [autoDismissTimer invalidate];
    autoDismissTimer = nil;
    
    [self.playerLayer removeFromSuperlayer];

    [self.player removeTimeObserver:m_timeObserver];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    
    //停掉playeritem的网络请求释放掉playerintm 就不会再出现这种问题了
    [self.playerItem cancelPendingSeeks];
    [self.playerItem.asset cancelLoading];
    
    //释放player
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    
    self.player = nil;
    self.playerItem = nil;
    self.playerLayer = nil;

    m_center_play.alpha = 1.0f;
    m_buttomView.alpha = 0.0f;
    self.m_topView.alpha = 1.0f;
    [m_total_time setHidden:NO];
    [m_center_play setImage:[UIImage imageNamed:@"ic_play"] forState:UIControlStateNormal];
}

#pragma mark - slider的更改
// 拖拽的时候调用  这个时候不更新视频进度
- (void)sliderDragValueChange:(UISlider *)slider
{
    NSLog(@"sliderDragValueChange");
    self.isDragSlider = YES;
    self.data_model.isDragSlider = YES;
}
// 点击调用  或者 拖拽完毕的时候调用
- (void)sliderTapValueChange:(UISlider *)slider
{
    NSLog(@"sliderTapValueChange");
    self.data_model.isDragSlider = YES;
    self.isDragSlider = NO;
    // CMTimeMake(帧数（slider.value * timeScale）, 帧/sec)
    // 直接用秒来获取CMTime
    [self.player seekToTime:CMTimeMakeWithSeconds(slider.value, self.playerItem.currentTime.timescale)];
}

// 点击事件的Slider
- (void)touchSlider:(UITapGestureRecognizer *)tap
{
    NSLog(@"touchSlider");
    self.data_model.isDragSlider = YES;
    self.isDragSlider = NO;
    // 根据点击的坐标计算对应的比例
    CGPoint touch = [tap locationInView:self.slider];
    CGFloat scale = touch.x / self.slider.bounds.size.width;
    self.slider.value = CMTimeGetSeconds(self.playerItem.duration) * scale;
    [self.player seekToTime:CMTimeMakeWithSeconds(self.slider.value, self.playerItem.currentTime.timescale)];
    /* indicates the current rate of playback; 0.0 means "stopped", 1.0 means "play at the natural rate of the current item" */
    if (self.player.rate != 1)
    {
        [m_center_play setImage:[UIImage imageNamed:@"ic_play"] forState:UIControlStateNormal];
        
    }else{
        [m_center_play setImage:[UIImage imageNamed:@"ic_stop"] forState:UIControlStateNormal];
        [self.player play];
    }
}

#pragma mark - 自动隐藏bottom和top
- (void)autoDismissView:(NSTimer *)timer
{
    if (self.player.rate == 0)
    {
        // 暂停状态就不隐藏
    }
    else if (self.player.rate == 1)
    {
        if (m_buttomView.alpha == 1)
        {
            [self.MyProgressView removeFromSuperview];
            [self.m_imgView addSubview:self.MyProgressView];
            [self.MyProgressView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.m_imgView);
                make.height.mas_equalTo(kWidth(2));
            }];
            
            [UIView animateWithDuration:1.0 animations:^{
                self.back.alpha = 0;
                m_buttomView.alpha = 0;
                self.m_topView.alpha = 0;
                m_center_play.alpha = 0;
                
            } completion:^(BOOL finished) {
                [self.MyProgressView layoutIfNeeded];
            }];
        }
    }
}

/**
 *  计算缓冲进度
 *
 *  @return 缓冲进度
 */
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [self.playerItem loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start); // 开始的点
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration); // 已缓存的时间点
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

// 调用plaer的对象进行UI更新
- (void)initTimer
{
    // player的定时器
    __weak typeof(self)weakSelf = self;
    // 每秒更新一次UI Slider
    m_timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        //不暂停 直接退出的时候 记录的时间点 会出错
        if(weakSelf.playerItem == nil){
            NSLog(@"weakSelf.playerItem == nil");
            return ;
        }
        // 当前时间
        CGFloat nowTime = CMTimeGetSeconds(weakSelf.playerItem.currentTime);
        // 总时间
        CGFloat duration = CMTimeGetSeconds(weakSelf.playerItem.duration);
        // sec 转换成时间点
        weakSelf.left_time.text = [weakSelf convertToTime:nowTime];
        weakSelf.right_time.text = [weakSelf convertToTime:(duration - nowTime)];
        // 不是拖拽中的话更新UI
        if (!weakSelf.isDragSlider)
        {
            weakSelf.slider.value = CMTimeGetSeconds(weakSelf.playerItem.currentTime);
            
            if(nowTime >= duration){//视频播放结束

                if(!weakSelf.data_model.isDragSlider){ //是否在结束后给予奖励
                    if(weakSelf.delegate && weakSelf.data_model.video_playTime >= Task_video_leastTime){
                        [weakSelf.delegate MyPlayer_giveGold:weakSelf.data_model];
                    }
                }
                weakSelf.data_model.isDragSlider = NO;
                
                [weakSelf initAll];
                weakSelf.data_model.video_playTime = 0.0f;
                
                if(weakSelf.isFullScreen){ //如果全屏 就退出全屏
                    [weakSelf.delegate MyPlayerVIew_PlayOver];
                    weakSelf.isFullScreen = !weakSelf.isFullScreen;
                }
                
                return ;
            }
            weakSelf.data_model.video_playTime = nowTime;
            
//                        NSLog(@"-------nowTime:%.2f------",nowTime);
        }
        
    }];
}

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


-(void)setIsBackHide:(BOOL)isBackHide{
    [self.back setHidden:isBackHide];
    if(isBackHide){
        [m_title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.m_topView.mas_left).with.offset(kWidth(16));
            make.right.equalTo(self.m_topView.mas_right).with.offset(-kWidth(16));
            make.top.equalTo(self.m_topView.mas_top).with.offset(kHeight(16));
            make.bottom.equalTo(self.m_topView.mas_bottom).with.offset(-kWidth(16));
        }];
    }
    else{
        [m_title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.m_topView.mas_left).with.offset(kWidth(16+32+10));
            make.right.equalTo(self.m_topView.mas_right).with.offset(-kWidth(16));
            make.top.equalTo(self.m_topView.mas_top).with.offset(kHeight(16));
            make.bottom.equalTo(self.m_topView.mas_bottom).with.offset(-kWidth(16));
        }];
    }
    [self layoutIfNeeded];
}

@end
