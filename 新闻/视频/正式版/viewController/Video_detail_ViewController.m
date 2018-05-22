//
//  Video_detail_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/4/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Video_detail_ViewController.h"
#import "MyPlayerView.h"
#import "BadgeButton.h"
#import "Video_detail_tuijian_TableViewController.h"
#import "NoReply_TableViewCell.h"
#import "reply_Cell.h"
#import "collectvModel.h"
#import "ShareSettingView.h"
#import "ShareSetting_view.h"
#import "reply_model.h"

@interface Video_detail_ViewController ()<UITableViewDelegate,UITableViewDataSource,MyPlayerView_ptotocl,shareSetting_protocol,UITextViewDelegate,video_tuijian_tableview_protocol>

@property (nonatomic,strong)MyPlayerView* m_playerView;
@property (nonatomic,strong)UITableView* m_talbeView;
@property (nonatomic,strong)UIView* m_headerView;
@property (nonatomic,strong)Video_detail_tuijian_TableViewController* m_tuijian_TVC;
@property (nonatomic,strong)UIView* statusBar;
@property (nonatomic,strong)ShareSetting_view* share_View;
@property (nonatomic,strong)UIButton* SenderButton;
@property (nonatomic,strong)UIView* inputReply;

@end

@implementation Video_detail_ViewController{
    UIView*             m_tabbar_view;
    UIView*             m_section_headerView;
    BOOL                isShoucang;
    BadgeButton*        m_messageBtn;
    
    CGRect                m_playview_rect;
    
    UITextView*             m_textField;
    UILabel*                m_textView_placeHolder;

    CGFloat                 _transformY;
    CGFloat                 _currentKeyboardH;
    NSInteger               m_page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    [self RememberVideo];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
    /* 增加监听（当键盘出现或改变时） */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transformDialog:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //热点
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutControllerSubViews:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(share_sucess) name:@"视频分享成功" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(share_failed) name:@"视频分享失败" object:nil];
    //热点变化
    CGRect tabbarview_frame = m_tabbar_view.frame;
    if(STATUS_BAR_BIGGER_THAN_20){
        tabbarview_frame = CGRectMake(tabbarview_frame.origin.x, tabbarview_frame.origin.y-20, tabbarview_frame.size.width, tabbarview_frame.size.height);
    }
    m_tabbar_view.frame = tabbarview_frame;
    
    
    if(self.m_playerView.player == nil){
        [self initPlayer];
    }

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self.m_playerView initAll];
}

-(void)dealloc{
    NSLog(@"视频详情页dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI{
    //视频播放器
    [self initPlayer];
    //tabbar
    [self initTabbar];
    //talbeview
    [self initTableView];
    //tableview-headerView
    [self initHeaderView];
}

-(void)initPlayer{
    self.m_playerView = [[MyPlayerView alloc] initWithFrame:CGRectMake(0, StaTusHight, SCREEN_WIDTH, kWidth(202))];
    self.m_playerView.delegate = self;
    self.m_playerView.model = self.model;
    [self.m_playerView.fullScreenButton addTarget:self action:@selector(fullBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.m_playerView.back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.m_playerView.back.alpha = 0.0f;
    [self.m_playerView.m_topView setHidden:YES];//隐私视频上的title
    [self.view addSubview:self.m_playerView];
    [self.m_playerView playAction];
}

-(void)initTabbar{
    //添加底部tab栏
    NSInteger tabHight = 48;
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-tabHight, SCREEN_HEIGHT, tabHight)];
    view.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
    [self.view addSubview:view];
    m_tabbar_view = view;
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [view addSubview:line];
    
    UIButton* share_button = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-34-14, 7, 34, 34)];
    [share_button setImage:[UIImage imageNamed:@"ic_share"] forState:UIControlStateNormal];
    isShoucang = NO;
    [share_button addTarget:self action:@selector(ShareAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:share_button];
    
    UIButton* shoucang_button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(share_button.frame)-26-30, 9, 30, 30)];
    if([[MyDataBase shareManager] Collect_IsCollected:[self.model.ID integerValue]]){//是否点过赞
        [shoucang_button setImage:[UIImage imageNamed:@"ic_collected"] forState:UIControlStateNormal];
        isShoucang = YES;
    }else{
        [shoucang_button setImage:[UIImage imageNamed:@"ic_collect"] forState:UIControlStateNormal];
        isShoucang = NO;
    }
    
    [shoucang_button addTarget:self action:@selector(IsShoucang:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:shoucang_button];
    
    BadgeButton* messge_button = [[BadgeButton alloc] init];
    messge_button.frame = CGRectMake(CGRectGetMinX(shoucang_button.frame)-22-30, 9, 30, 30);
    UIImage* img = [UIImage imageNamed:@"ic_comment"];
    [messge_button setImage:img forState:UIControlStateNormal];
    [messge_button addTarget:self action:@selector(Message) forControlEvents:UIControlEventTouchUpInside];
    [messge_button setCount:0];
    [view addSubview:messge_button];
    
    UIButton* text_button = [[UIButton alloc] initWithFrame:CGRectMake(16, 9, CGRectGetMinX(messge_button.frame)-20-16, 32)];
    [text_button.layer setCornerRadius:16];
    [text_button.layer setMasksToBounds:YES];
    [text_button setTitle:@"说两句..." forState:UIControlStateNormal];
    [text_button setTitleColor:[UIColor colorWithRed:167/255.0 green:169/255.0 blue:169/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    text_button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [text_button setContentEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
    text_button.titleLabel.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:14];
    text_button.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [text_button addTarget:self action:@selector(InputTextAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:text_button];
}

-(void)initTableView{
    self.m_talbeView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.m_playerView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(self.m_playerView.frame)-m_tabbar_view.frame.size.height) style:UITableViewStyleGrouped];
    self.m_talbeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.m_talbeView.delegate = self;
    self.m_talbeView.dataSource = self;
    [self.m_talbeView registerClass:[NoReply_TableViewCell class] forCellReuseIdentifier:@"NullReply"];
    [self.m_talbeView registerClass:[reply_Cell class] forCellReuseIdentifier:@"reply"];
    [self.view addSubview:self.m_talbeView];
    [self.view sendSubviewToBack:self.m_talbeView];
    
    self.m_talbeView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self GetReplyComment:m_page];
    }];
    
    [self GetReplyComment:0];
}

-(void)initHeaderView{
    self.m_headerView = [UIView new];
    self.m_headerView.backgroundColor = [UIColor whiteColor];

    //视频 信息
    UIView* playerInfo = [UIView new];
    
    CGFloat height_title = [LabelHelper GetLabelHight:kFONT(16) AndText:self.model.title AndWidth:SCREEN_WIDTH-kWidth(16)-kWidth(16)];
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(kWidth(16), kWidth(16), SCREEN_WIDTH-kWidth(16)-kWidth(16), height_title)];
    title.text = self.model.title;
    title.textColor = RGBA(34, 39, 39, 1);
    title.textAlignment = NSTextAlignmentLeft;
    title.font = kFONT(16);
    title.numberOfLines = 0;
    [playerInfo addSubview:title];
    
    NSString* MyTime = [[TimeHelper share] dataChangeToYYMMDD:self.model.time];
    CGFloat time_width = [LabelHelper GetLabelWidth:kFONT(13) AndText:MyTime];
    UILabel* time = [[UILabel alloc] initWithFrame:CGRectMake(kWidth(16), CGRectGetMaxY(title.frame)+kWidth(15), time_width, kWidth(13))];
    time.text = MyTime;
    time.textColor = RGBA(122, 125, 125, 1);
    time.textAlignment = NSTextAlignmentLeft;
    time.font = kFONT(13);
    time.numberOfLines = 0;
    [playerInfo addSubview:time];
    
    NSInteger count = [self.model.play_count integerValue];
    NSString* playedMessage = @"";
    if(count >= 100000000){
        playedMessage = [NSString stringWithFormat:@"%.1f亿次播放",count/100000000.0f];
    }
    else if(count >= 10000){
        playedMessage = [NSString stringWithFormat:@"%.1f万次播放",count/10000.0f];
    }else{
        playedMessage = [NSString stringWithFormat:@"%ld次播放",count];
    }
    
    CGFloat width_playedCount = [LabelHelper GetLabelWidth:kFONT(13) AndText:playedMessage];
    UILabel* playedCount = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-kWidth(16)-width_playedCount, CGRectGetMaxY(title.frame)+kWidth(15), width_playedCount, kWidth(13))];
    playedCount.text = playedMessage;
    playedCount.textColor = RGBA(122, 125, 125, 1);
    playedCount.textAlignment = NSTextAlignmentLeft;
    playedCount.font = kFONT(13);
    playedCount.numberOfLines = 0;
    [playerInfo addSubview:playedCount];
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(time.frame)+kWidth(16), SCREEN_WIDTH, kWidth(10))];
    line.backgroundColor = RGBA(242, 242, 242, 1);
    [playerInfo addSubview:line];
    
    //相关推荐
    UIView* line_tmp = [[UIView alloc] initWithFrame:CGRectMake(kWidth(16), CGRectGetMaxY(line.frame)+kWidth(16), kWidth(4), kWidth(20))];
    line_tmp.backgroundColor = RGBA(248, 205, 4, 1);
    [playerInfo addSubview:line_tmp];
    
    UILabel* tableview_title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line_tmp.frame)+kWidth(8), CGRectGetMaxY(line.frame)+kWidth(16), kWidth(75), kWidth(18))];
    tableview_title.text = @"相关推荐";
    tableview_title.textColor = RGBA(122, 125, 125, 1);
    tableview_title.textAlignment = NSTextAlignmentLeft;
    tableview_title.font = kFONT(18);
    [playerInfo addSubview:tableview_title];
    
    playerInfo.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(tableview_title.frame));
    
    [self.m_headerView addSubview:playerInfo];
    self.m_headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, playerInfo.frame.size.height);
    
    IMP_BLOCK_SELF(Video_detail_ViewController)
    [InternetHelp Video_detail_tuijian_channelID:self.model.channel Sucess:^(NSDictionary *dic) {
//        NSLog(@"duc-->%@",dic);
        NSArray* array = [video_info_model dicToArray:dic];
        block_self.m_tuijian_TVC = [Video_detail_tuijian_TableViewController new];
        block_self.m_tuijian_TVC.array_model = array;
        block_self.m_tuijian_TVC.delegate = block_self;
        
        UIView* view_tmp = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(block_self.m_headerView.frame), SCREEN_WIDTH, 35+array.count*kWidth(104)+kWidth(62))];
        [view_tmp addSubview:block_self.m_tuijian_TVC.tableView];
        block_self.m_headerView.clipsToBounds = YES;
        [block_self.m_headerView addSubview:view_tmp];
        block_self.m_headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, block_self.m_headerView.frame.size.height+view_tmp.frame.size.height);
        [block_self.m_talbeView reloadData];
    } Fail:^(NSDictionary *dic) {
        if(dic == nil){
            [MyMBProgressHUD ShowMessage:@"网络错误" ToView:block_self.view AndTime:1];
        }else{
            [MyMBProgressHUD ShowMessage:dic[@"msg"] ToView:block_self.view AndTime:1];
        }
    }];
    
}

-(void)setSectionHeaderView{
    UIView* reply_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kWidth(62))];
    reply_view.backgroundColor = [UIColor whiteColor];
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kWidth(10))];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [reply_view addSubview:line];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(kWidth(28), kWidth(25), kWidth(150), kWidth(18))];
    label.font = kFONT(18);
    label.text = @"热门评论";
    label.textColor = [UIColor colorWithRed:122/255.0 green:125/255.0 blue:125/255.0 alpha:1/1.0];
    [reply_view addSubview:label];
    
    UIView* yellow = [[UIView alloc] initWithFrame:CGRectMake(kWidth(16), kWidth(24), kWidth(4), kWidth(20))];
    yellow.backgroundColor = [UIColor colorWithRed:248/255.0 green:205/255.0 blue:4/255.0 alpha:1/1.0];
    [reply_view addSubview:yellow];
    
    //    [self.m_ReadingWithOther_view addSubview:reply_view];
    m_section_headerView = reply_view;
}

-(void)layoutControllerSubViews:(NSNotification*)noti{
    NSLog(@"layoutControllerSubViews");
    NSString* str = [NSString stringWithFormat:@"height:%f",StaTusHight];
    [MBProgressHUD showSuccess:str];
    //    CGRect tableview_frame = self.tableView.frame;
    CGRect tabbarview_frame = m_tabbar_view.frame;
    if(STATUS_BAR_BIGGER_THAN_20){
        tabbarview_frame = CGRectMake(tabbarview_frame.origin.x, tabbarview_frame.origin.y-20, tabbarview_frame.size.width, tabbarview_frame.size.height);
    }else{
        tabbarview_frame = CGRectMake(tabbarview_frame.origin.x, tabbarview_frame.origin.y+20, tabbarview_frame.size.width, tabbarview_frame.size.height);
    }
    m_tabbar_view.frame = tabbarview_frame;
    //    [self.view layoutIfNeeded];
}
-(void)RememberVideo{
    if(!self.isFromHistory){
        [[MyDataBase shareManager] AddReadingVideo:self.model];
    }
}

#pragma mark - 按钮方法
-(void)InputTextAction{
    NSLog(@"准备评论");
    if(![Login_info share].isLogined){
        [[AlertHelper Share]ShowMe:self And:0.5f And:@"没有登陆"];
        return;
    }
    //收回所有窗口
    [self Hide_wid];
    
    //整个窗口（评论输入）
    UIView* inputTextView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //全屏灰色透明
    UIView* inputTextBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    inputTextBackgroundView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4/1.0];
    //给遮罩添加手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [inputTextBackgroundView addGestureRecognizer:tap];
    inputTextBackgroundView.alpha = 0.6;
    [inputTextView addSubview:inputTextBackgroundView];
    
    //输入框视图
    UIView* inputText = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-150, SCREEN_WIDTH, 150)];
    inputText.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    [inputText addGestureRecognizer:tap1];
    
    UITextView* textField = [[UITextView alloc] initWithFrame:CGRectMake(16, 10, SCREEN_WIDTH-16-16, 90)];
    m_textField = textField;
    textField.backgroundColor = [[ThemeManager sharedInstance] GetDialogViewColor];
    //    textField.te = @"我来说两句...";
    textField.delegate = self;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.keyboardType = UIKeyboardTypeDefault;
    //    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.returnKeyType = UIReturnKeyNext;
    textField.keyboardAppearance = UIKeyboardAppearanceDefault;
    [textField becomeFirstResponder];
    textField.textColor = [[ThemeManager sharedInstance] GetDialogTextColor];
    textField.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:14];
    [inputText addSubview:textField];
    
    //textView中添加 placeHolder
    m_textView_placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, 100, 14)];
    m_textView_placeHolder.text = @"说两句...";
    m_textView_placeHolder.textColor = RGBA(167, 169, 169, 1);
    m_textView_placeHolder.textAlignment = NSTextAlignmentLeft;
    m_textView_placeHolder.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:14];
    [textField addSubview:m_textView_placeHolder];
    
    //取消
    UIButton* inputText_cancel = [[UIButton alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(textField.frame)+10, 60, 30)];
    [inputText_cancel setTitle:@"取消" forState:UIControlStateNormal];
    [inputText_cancel setTitleColor:[[ThemeManager sharedInstance] GetDialogTextColor] forState:UIControlStateNormal];
    [inputText_cancel.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
    [inputText_cancel addTarget:self action:@selector(DialogCancel) forControlEvents:UIControlEventTouchUpInside];
    inputText_cancel.backgroundColor = [[ThemeManager sharedInstance] GetDialogViewColor];
    [inputText_cancel.layer setCornerRadius:4.0f];
    [inputText addSubview:inputText_cancel];
    
    //发送
    UIButton* inputText_true = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16-60, CGRectGetMaxY(textField.frame)+10, 60, 30)];
    [inputText_true setTitle:@"发送" forState:UIControlStateNormal];
    [inputText_true setTitleColor:[[ThemeManager sharedInstance] GetDialogTextColor] forState:UIControlStateNormal];
    [inputText_true.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
    [inputText_true addTarget:self action:@selector(DialogTure) forControlEvents:UIControlEventTouchUpInside];
    inputText_true.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1/1.0];
    [inputText_true.layer setCornerRadius:4.0f];
    inputText_true.enabled = NO;
    self.SenderButton = inputText_true;
    [inputText addSubview:inputText_true];
    
    [inputTextView addSubview: inputText];
    self.inputReply = inputTextView;
    [self.view addSubview:self.inputReply];
    
    //    [self.view layoutIfNeeded];
}

-(void)Message{
    NSLog(@"点击 message");
    NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.m_talbeView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

-(void)IsShoucang:(UIButton*)button{
    if(![Login_info share].isLogined){
        [[AlertHelper Share]ShowMe:self And:0.5f And:@"没有登陆"];
    }else{

        if(isShoucang){
            NSLog(@"取消收藏");
            [button setImage:[UIImage imageNamed:@"ic_collect"] forState:UIControlStateNormal];
            [[MyDataBase shareManager] Collect_UpData:[self.model.ID integerValue] AndIsDIanZan:0];
            [self CollectedAction:0];
        }
        else{
            NSLog(@"订阅收藏");
            [button setImage:[UIImage imageNamed:@"ic_collected"] forState:UIControlStateNormal];
            if([[MyDataBase shareManager] Collect_IsHaveId:[self.model.ID integerValue]]){//表中是否已经存在该字段
                [[MyDataBase shareManager] Collect_UpData:[self.model.ID integerValue] AndIsDIanZan:1];
                [self CollectedAction:1];
            }else{
                [[MyDataBase shareManager] Collect_insertData:[self.model.ID integerValue] AndIsDIanZan:1 AndTime:self.model.time];
                [self CollectedAction:1];
            }
        }
        isShoucang = !isShoucang;
    }
}

-(void)ShareAction{
    NSLog(@"准备分享");
    //收回所有窗口
//    [[NSNotificationCenter defaultCenter] postNotificationName:HideAllDialog object:nil];
    
    collectvModel* model = [[collectvModel alloc] init];
    model.name_array = @[@"朋友圈",@"微信好友",@"QQ好友",@"QQ空间",@"复制链接",@"更多"];
    model.imgs_array = @[@"ic_friend",@"ic_wechat",@"ic_qq",@"ic_zone",@"ic_link",@"ic_nav_share"];
    model.lineInstance = 24;
    model.itemInstance = (SCREEN_WIDTH-48-48-48*3)/3;
    model.itemsOfLine = 3;
    model.size = CGSizeMake(48, 60);
    model.edge = UIEdgeInsetsMake(24, 48, 24, 48);//分别为上、左、下、右

    ShareSettingView* view = [[ShareSettingView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT+248, SCREEN_WIDTH, 248)];
    view.model = model;
    view.delegate = self;
    view.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
//    m_fenxiang_shareSettingView = view;

    ShareSetting_view* share_setting = [ShareSetting_view GetDialogView:view.frame withCusomView:view];
    self.share_View = share_setting;
    [self.share_View Show];
}

-(void)Hide_wid{
    [self.share_View Hide];
}

-(void)fullBtnAction{
    if(!self.m_playerView.isFullScreen){
        [self fullScreen:self.model AndView:self.m_playerView];
        [self.m_playerView.fullScreenButton setImage:[UIImage imageNamed:@"ic_zoom"] forState:UIControlStateNormal];
    }else{
        [self ToCell];
        [self.m_playerView.fullScreenButton setImage:[UIImage imageNamed:@"ic_full"] forState:UIControlStateNormal];
    }
    
    self.m_playerView.isFullScreen = !self.m_playerView.isFullScreen;
}
-(void)fullScreen:(video_info_model*)model AndView:(MyPlayerView *)playView{
    NSLog(@"fullScreen");
    /*
     * movieView移到window上
     */
    //计算MyPlayer 在整个窗口的位置
    m_playview_rect = self.m_playerView.frame;
    
    [playView removeFromSuperview];
    //    [playView.playerLayer removeFromSuperlayer];
    [[UIApplication sharedApplication].keyWindow addSubview:playView];
    
    self.statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    /*
     * 执行动画
     */
    [UIView animateWithDuration:0.5 animations:^{
        
        self.m_playerView.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.m_playerView.bounds = CGRectMake(0, 0, CGRectGetHeight(self.m_playerView.superview.bounds), CGRectGetWidth(self.m_playerView.superview.bounds));
        self.m_playerView.center = CGPointMake(CGRectGetMidX(self.m_playerView.superview.bounds), CGRectGetMidY(self.m_playerView.superview.bounds));
        //        NSLog(@"bounds.x=%f----bounds.y=%f",self.m_fullScreen_imgView.bounds.size.width,self.m_fullScreen_imgView.bounds.size.height);
        [self.m_playerView setNeedsLayout];
        
        self.m_playerView.playerLayer.frame = self.m_playerView.bounds;
        //        [self.m_fullScreen_imgView.m_imgView.layer insertSublayer:self.m_fullScreen_imgView.playerLayer atIndex:0];
        
    } completion:^(BOOL finished) {
        [self.statusBar setHidden:YES];
        [self.m_playerView.m_topView setHidden:NO];
        [self.m_playerView.back removeTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.m_playerView.back addTarget:self action:@selector(ToCell) forControlEvents:UIControlEventTouchUpInside];
    }];
    
}
-(void)ToCell{
    /*
     * 执行动画
     */
    IMP_BLOCK_SELF(Video_detail_ViewController)
    [UIView animateWithDuration:0.5 animations:^{
        
        block_self.m_playerView.transform = CGAffineTransformIdentity;
        block_self.m_playerView.frame = CGRectMake(0, StaTusHight, SCREEN_WIDTH, kWidth(202));
        block_self.m_playerView.playerLayer.frame = block_self.m_playerView.bounds;
        //        NSLog(@"bounds.x=%f----bounds.y=%f",self.m_fullScreen_imgView.bounds.size.width,self.m_fullScreen_imgView.bounds.size.height);
        [block_self.view addSubview:block_self.m_playerView];
        //        [self.m_fullScreen_imgView.m_imgView.layer insertSublayer:self.m_fullScreen_imgView.playerLayer atIndex:0];
        
    } completion:^(BOOL finished) {
        [self.m_playerView.m_topView setHidden:YES];
        [block_self.statusBar setHidden:NO];
        [block_self.m_playerView.back removeTarget:block_self action:@selector(ToCell) forControlEvents:UIControlEventTouchUpInside];
        [block_self.m_playerView.back addTarget:block_self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }];
}

-(void)DialogCancel{
    NSLog(@"DialogCancel");
    [self.inputReply removeFromSuperview];
}

-(void)DialogTure{
    NSLog(@"DialogTure");
    NSString* str_comment = m_textField.text;
    [self SendReply:str_comment];
    [self.inputReply removeFromSuperview];
}

-(void)tapClick:(UITapGestureRecognizer*)tap{
    [self DialogCancel];
}
//移动UIView(随着键盘移动)
-(void)transformDialog:(NSNotification *)aNSNotification
{
    NSLog(@"Video_detail_VCL移动");
    //键盘最后的frame
    CGRect keyboardFrame = [aNSNotification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    NSLog(@"Video_detail_VCL看看这个变化的Y值:%f",height);
    //需要移动的距离
    if (height > 0) {
        _transformY = height-_currentKeyboardH;
        _currentKeyboardH = height;
        //移动
        IMP_BLOCK_SELF(Video_detail_ViewController)
        [UIView animateWithDuration:0.25f animations:^{
            CGRect frame = block_self.inputReply.frame;
            frame.origin.y -= _transformY;
            block_self.inputReply.frame = frame;
        }];
    }
}

-(void)keyboardWillHide:(NSNotification *)aNSNotification{
    /* 输入框下移 */
    IMP_BLOCK_SELF(Video_detail_ViewController)
    [UIView animateWithDuration:0.25f animations:^ {
        
        CGRect frame = block_self.inputReply.frame;
        frame.origin.y = 0;
        block_self.inputReply.frame = frame;
    }];
    //记得再收键盘后 初始化键盘参数
    _transformY = 0;
    _currentKeyboardH = 0;
}

//键盘回收
-(void)keyboardHide
{
    [m_textField resignFirstResponder];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - talbeview协议
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.reply_array == nil || self.reply_array.count == 0){
        return 1;
    }
    return self.reply_array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.reply_array == nil || self.reply_array.count == 0){
        NoReply_TableViewCell* cell = [NoReply_TableViewCell cellWithTableView:tableView];
        return cell;
    }else{
        reply_Cell* cell = [reply_Cell cellWithTableView:tableView];
        reply_model* model = self.reply_array[indexPath.row];
        cell.model =model;
        return cell;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.m_headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.m_headerView.frame.size.height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.reply_array == nil || self.reply_array.count == 0){
        return 150.0;
    }else{
        reply_model* model = _reply_array[indexPath.row];
        CGFloat hight = [LabelHelper GetLabelHight:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14] AndText:model.comment AndWidth:SCREEN_WIDTH-16-24-8];
        
        return (102.0f+hight);
    }
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

#pragma mark - textField代理
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //    if ([text isEqualToString:@"\n"])  //按会车可以改变
    //    {
    //        return YES;
    //    }
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text]; //得到输入框的内容
    NSInteger MaxLenth = 140;
    
    if (textView)  //判断是否时我们想要限定的那个输入框
    {
        //判断发送按钮 的状态
        if([toBeString length] > 0){
            m_textView_placeHolder.text = @"";
            self.SenderButton.enabled = YES;
            self.SenderButton.backgroundColor = [UIColor colorWithRed:248/255.0 green:205/255.0 blue:4/255.0 alpha:1/1.0];
        }else{
            m_textView_placeHolder.text = @"说两句...";
            self.SenderButton.enabled = NO;
            self.SenderButton.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1/1.0];
        }
        
        if ([toBeString length] > MaxLenth) { //如果输入框内容大于MaxLenth则弹出警告
            textView.text = [toBeString substringToIndex:MaxLenth];
            
            UIAlertController* alert_VC = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"不能超过%ld个字符",MaxLenth] preferredStyle:UIAlertControllerStyleAlert];
            //弹出视图,使用UIViewController的方法
            IMP_BLOCK_SELF(Video_detail_ViewController)
            [self presentViewController:alert_VC animated:YES completion:^{
                
                //隔一会就消失
                [block_self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }];
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}

#pragma mark - 协议
-(void)MyPlayerView_videoPlay:(video_info_model *)model AndMyPlayerView:(id)Player_self{
    //不用
}
-(void)MyPlayer_giveGold:(video_info_model*)model{
    if(![Login_info share].isLogined){
        return;
    }
    if([[TaskCountHelper share] TaskIsOverByType:Task_video]){ //当任务次数已经完成后 不再提交任务
        return ;
    }
    if(![[MyDataBase shareManager] IsGetIncomeNews:model.ID]){//防止重复 阅读奖励
        NSString* task_id = [Md5Helper Video_taskId:[Login_info share].userInfo_model.user_id AndVideoId:model.ID];
        IMP_BLOCK_SELF(Video_detail_ViewController)
        [InternetHelp SendTaskId:task_id AndType:Task_video Sucess:^(NSInteger type, NSDictionary *dic) {
            [RewardHelper ShowReward:type AndSelf:block_self AndCoin:dic[@"list"][@"reward_coin"]];
            [[MyDataBase shareManager] AddGetIncomeNews:model.ID]; //将视频id存储起来 防止重复
        } Fail:^(NSDictionary *dic) {
            NSLog(@"视频上传失败");
        }];
    }else{
        NSLog(@"视频重复");
    }
}
-(void)MyPlayerVIew_PlayOver{
    [self ToCell];
}
-(void)reportToSever:(NSNumber *)type{
    
}
-(void)shareSetting_changeFont:(NSNumber *)type{
    
}
-(void)shareByName:(NSString *)name{
    [self ItemClick:name];
}

-(void)ItemClick:(NSString *)name{
//    NSString* name = noti.object;
    if([WeChat_pengyoujuan isEqualToString:name]){
        NSLog(@"朋友圈");
        [UMShareHelper ShareVideo:WeChat_pengyoujuan AndModel:self.model];
        [self Hide_wid];
    }
    if([WeChat_haoyou isEqualToString:name]){
        NSLog(@"微信好友");
        [UMShareHelper ShareVideo:WeChat_haoyou AndModel:self.model];
        [self Hide_wid];
    }
    if([QQ_haoyou isEqualToString:name]){
        NSLog(@"QQ好友");
        [UMShareHelper ShareVideo:QQ_haoyou AndModel:self.model];
        [self Hide_wid];
    }
    if([QQ_kongjian isEqualToString:name]){
        NSLog(@"QQ空间");
        [UMShareHelper ShareVideo:QQ_kongjian AndModel:self.model];
        [self Hide_wid];
    }
    if([@"复制链接" isEqualToString:name]){
        NSLog(@"复制链接");
        [self copylinkBtnClick];
        [self Hide_wid];
    }
    if([@"举报" isEqualToString:name]){
        NSLog(@"举报");
        if(![Login_info share].isLogined){
            [MBProgressHUD showMessage:@"未登录！"];
            return;
        }
//        [self ReportToMe];
    }
    if([@"字体" isEqualToString:name]){
        NSLog(@"字体");
//        [self SetFont];
    }
    if([@"更多" isEqualToString:name]){
        NSLog(@"更多");
        [self shareMore];
        [self Hide_wid];
    }
    if([@"夜间模式" isEqualToString:name]){
        NSLog(@"夜间模式");
    }
}

- (void)copylinkBtnClick {
    [MBProgressHUD showSuccess:@"复制成功!"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@ %@&source=link",self.model.title,self.model.url];
}

-(void)shareMore{
    //要分享的内容，加在一个数组里边，初始化UIActivityViewController
    NSString *textToShare = self.model.title;
//    UIImageView* img = [[UIImageView alloc] init];
//    [img sd_setImageWithURL:[NSURL URLWithString:self.model.cover]];
    UIImage *imageToShare = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.cover]]];
    NSURL *urlToShare = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.model.url]];
    NSArray *activityItems = @[urlToShare,textToShare,imageToShare];
    
    //    MyActivity* myActivity = [[MyActivity alloc] init];
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activity.excludedActivityTypes = @[];
    
    // incorrect usage
    // [self.navigationController pushViewController:activity animated:YES];
    
    UIPopoverPresentationController *popover = activity.popoverPresentationController;
    if (popover) {
        popover.sourceView = self.view;
        popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    
    [self presentViewController:activity animated:YES completion:NULL];
}

-(void)goToOtherDetail:(video_info_model *)model{
    
    //跳转之前 先暂停播放
    [self.m_playerView initAll];
//    NSLog(@"video_playTime:%f",self.m_playerView.data_model.video_playTime);
    
    Video_detail_ViewController* vc = [[Video_detail_ViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -  通知
-(void)share_sucess{
    [MyMBProgressHUD ShowMessage:@"分享成功" ToView:self.view AndTime:1.0f];
    [self initPlayer];
}

-(void)share_failed{
    [MyMBProgressHUD ShowMessage:@"分享失败" ToView:self.view AndTime:1.0f];
    [self initPlayer];
}

#pragma mark - API
-(void)CollectedAction:(NSInteger)action{
    //http://39.104.13.61:8090/api/collect?json={"user_id":"YangYiTestNumber1713841009","news_id":"120","action":1}
    action = action == 1 ? 1 : 2;//1：收藏    2：取消收藏
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/collect"]];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[[Login_info share] GetUserInfo].user_id]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"news_id",self.model.ID]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%ld\"",@"action",action]];//1：点赞    2：取消点赞
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    IMP_BLOCK_SELF(Video_detail_ViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error){
                NSLog(@"网络获取失败");
                //发送失败消息
                //                [block_self.tableView.footer endRefreshing];
                [MBProgressHUD showError:@"网络错误"];
                return ;
            }
            //提示信息
            Tips_ViewController* tip_vc = [[Tips_ViewController alloc] init];
            tip_vc.view.frame = CGRectMake(0, CGRectGetMinY(m_tabbar_view.frame)-50, SCREEN_WIDTH, 30);
            //            tip_vc.view.backgroundColor = [UIColor redColor];
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* code = dict[@"code"];
            if([code integerValue] == 200){
                if(action == 1){
                    //                    [MBProgressHUD showSuccess:@"收藏成功"];
                    tip_vc.message = [NSString stringWithFormat:@"收藏成功"];
                }else{
                    //                    [MBProgressHUD showSuccess:@"取消收藏"];
                    tip_vc.message = [NSString stringWithFormat:@"取消收藏"];
                }
                [block_self.view addSubview:tip_vc.view];
                [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    tip_vc.view.alpha = 0.0;
                } completion:^(BOOL finished) {
                    [tip_vc.view removeFromSuperview];
                }];
            }else{
                if(action == 1){
                    [[MyDataBase shareManager] Collect_UpData:[self.model.ID integerValue] AndIsDIanZan:0]; //数据库取消操作
                }else{
                    [[MyDataBase shareManager] Collect_UpData:[self.model.ID integerValue] AndIsDIanZan:1]; //数据库取消操作
                }
                
            }
            
        });
        
    }];
    [sessionDataTask resume];
}

-(void)GetReplyComment:(NSInteger)type{
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/getComment"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[[Login_info share] GetUserInfo].user_id]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":%@",@"news_id",self.model.ID]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":%ld",@"page",m_page]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":%d",@"size",10]];
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    IMP_BLOCK_SELF(Video_detail_ViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if(error || data == nil){
                NSLog(@"网络获取失败");
                //发送失败消息
                [block_self.m_talbeView.footer endRefreshing];
                return ;
            }
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* code = dict[@"code"];
            if([code integerValue] == 200){
            }else{
                //发送失败消息
                [block_self.m_talbeView.footer endRefreshing];
                return ;
            }
            
            NSArray *dataarray = [reply_model dicToArray:dict];
            NSMutableArray *statusArray = [NSMutableArray array];
            
            
            if(type == 0){//头次加载
                _reply_array = dataarray;
                [block_self.m_talbeView reloadData];
                if(_reply_array.count != 0){
                    m_page += 1;
                }
                
                [block_self.m_talbeView.footer endRefreshing];
                [block_self.m_talbeView.footer setHidden:YES];
            }else{
                [statusArray addObjectsFromArray:_reply_array];
                [statusArray addObjectsFromArray:dataarray];
                if(dataarray.count == 0){
                    [block_self.m_talbeView.footer noticeNoMoreData]; //之后不要添加 endRefreshing
                }else{
                    m_page += 1;
                    _reply_array = statusArray;
                    [block_self.m_talbeView reloadData];
                    [block_self.m_talbeView.footer endRefreshing];
                }
            }
            
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

-(void)SendReply:(NSString*)str_comment{
//    // 1.创建一个网络路径
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/comment"]];
//    // 2.创建一个网络请求，分别设置请求方法、请求参数
//    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = @"POST";
//    NSString *args = @"json=";
//    NSString* argument = @"";
//    //    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[[Login_info share] GetUserInfo].user_id]];
//    //    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"news_id",self.CJZ_model.ID]];
//    //    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"comment",str_comment]];
//    //    argument = [argument stringByAppendingString:@"}"];
//    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init]; //用json传值 ：\n 加密就不会去掉换行符
//    [dic setValue:[[Login_info share] GetUserInfo].user_id forKey:@"user_id"];
//    [dic setValue:self.model.ID forKey:@"news_id"];
//    [dic setValue:str_comment forKey:@"comment"];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:NULL];
//    NSString* str_tmp = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    argument = [MyEntrypt MakeEntryption:str_tmp];
//    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
//    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
//    // 3.获得会话对象
//    NSURLSession *session = [NSURLSession sharedSession];
//    // 4.根据会话对象，创建一个Task任务
//    IMP_BLOCK_SELF(Video_detail_ViewController);
//    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            
//            if(error){
//                NSLog(@"网络获取失败");
//                //发送失败消息
//                [block_self.m_talbeView.footer endRefreshing];
//                return ;
//            }
//            //提示信息
//            Tips_ViewController* tip_vc = [[Tips_ViewController alloc] init];
//            tip_vc.view.frame = CGRectMake(0, SCREEN_HEIGHT/2-50/2, SCREEN_WIDTH, 50);
//            //            tip_vc.view.backgroundColor = [UIColor grayColor];
//            
//            
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
//            NSNumber* code = dict[@"code"];
//            if([code integerValue] == 200){
//                //                [[AlertHelper Share] ShowMe:self And:0.8 And:@"评论成功"];
//                NSDictionary* dic_tmp = dict[@"list"];
//                reply_model* model = [[reply_model alloc] init];
//                model.ID = dic_tmp[@"id"];
//                model.myUserModel.user_name = [Login_info share].userInfo_model.name;
//                model.myUserModel.user_icon = [Login_info share].userInfo_model.avatar;
//                model.comment = dic_tmp[@"comment"];
//                model.thumbs_num = @"0";
//                NSNumber* number = dic_tmp[@"ctime"];
//                model.ctime = [NSString stringWithFormat:@"%ld",[number integerValue]];
//                
//                NSMutableArray* array_tmp = [NSMutableArray arrayWithArray:_reply_array];
//                [array_tmp insertObject:model atIndex:0];
//                _reply_array = array_tmp;
//                [block_self.m_talbeView reloadData];
//                
//                //                [MBProgressHUD showSuccess:@"评论成功"];
//                //                [self GetReplyComment:0];//重新加载评论
//                tip_vc.message = [NSString stringWithFormat:@"评论成功"];
//                
//            }else{
//                //                [[AlertHelper Share] ShowMe:self And:0.8 And:@"评论失败"];
//                //                [MBProgressHUD showError:@"评论失败"];
//                tip_vc.message = [NSString stringWithFormat:@"评论失败"];
//            }
//            
//            
//            [block_self.view addSubview:tip_vc.view];
//            [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//                tip_vc.view.alpha = 0.0;
//            } completion:^(BOOL finished) {
//                [tip_vc.view removeFromSuperview];
//            }];
//            
//        });
//        
//    }];
//    //5.最后一步，执行任务，(resume也是继续执行)。
//    [sessionDataTask resume];
    
    [InternetHelp replyToServer_test:[Login_info share].userInfo_model.user_id andNewsId:self.model.ID AndComment:str_comment Sucess:^(NSDictionary *dic) {
        [MyMBProgressHUD ShowMessage:@"评论成功" ToView:self.view AndTime:1.0f];
        [self GetReplyComment:0];
    } Fail:^(NSDictionary *dic) {
        [MyMBProgressHUD ShowMessage:@"网络失败" ToView:self.view AndTime:1.0f];
    }];
}

@end
