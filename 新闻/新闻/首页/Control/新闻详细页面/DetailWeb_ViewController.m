//
//  DetailWeb_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DetailWeb_ViewController.h"

#import "ThemeManager.h"
#import "BadgeButton.h"
#import "BaseEngine.h"
#import "Header_ViewController.h"
#import "reply_Cell.h"
#import "ShareSetting_view.h"
#import "ShareSettingView.h"
#import "collectvModel.h"
#import "NoReply_TableViewCell.h"
#import "reply_model.h"
#import "SectionHeader_ViewController.h"
#import "showImages_ViewController.h"
#import "TaskMaxCout_model.h"
#import "Second_ViewController.h"
#import "MyActivity.h"
#import "Task_reward_model.h"
#import "DateReload_view.h"
#import "ReplyAll_ViewController.h"

#define HideAllDialog @"HideAllDialog"

@interface DetailWeb_ViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,ClickWebImageInterfaceDelegate,SectionHeader_DetailWeb_InterfaceDelegate,shareSetting_protocol,reply_cell_protocol,ReplyAll_VCL_protocol>

//@property (nonatomic,strong)UIWebView* webView;

@property (nonatomic,strong)UITableView* tableView;

@property (nonatomic,strong)Header_ViewController* headerView;

@property (nonatomic,strong)UIView* inputReply;

@property (nonatomic,strong)ShareSetting_view* shareSetting_View;

@property (nonatomic,strong)ShareSetting_view* share_View;

@property (nonatomic,strong)UIButton* SenderButton;//发送按钮

@property (nonatomic, strong)UIProgressView *progressView;//网页进度条

@end

@implementation DetailWeb_ViewController{
    UIView*                 m_tabbar_view;
    BadgeButton*            m_badgeButton;
    ShareSettingView*       m_youshangjiao_shareSettingView;
    ShareSettingView*       m_fenxiang_shareSettingView;
    NSInteger               m_page;
    UITextView*            m_textField;
    UILabel*               m_textView_placeHolder;
    
    SectionHeader_ViewController* m_sectionHeader_VC;
    UIView*                       m_sectionHeader_view;
    CGFloat                       m_sectionHeader_Hight;
    
    BOOL                           m_web_load;//针对返回时 webview空白的时候
    Waiting_ViewController*        m_waitting_VC;
    UIActivityIndicatorView*       m_waitting_view;
    
    BOOL                            m_First_collect;//是否第一次点击收藏按钮
    RuleOfReading*                  m_ruleOfReading;
    
    //新闻高度
    CGSize                          m_headerSize;
    UIView*                       readingAll;
    BOOL                            Is_readingAll;
    NSInteger                       m_scroll_count;
    
    //键盘弹出
    CGFloat                         _currentKeyboardH;
    CGFloat                         _transformY;
    
    //判断scrollview 滚动方向
    CGPoint                         m_start_point;
    CGPoint                         m_end_point;
    
    //
    DateReload_view*                         m_Reloaded_view;
    
    //评论
    reply_model*                    m_otherReply_model;
    NSString*                       m_pre_reply;//回复头  例子： 回复 cjz：
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    m_web_load = NO;
    m_ruleOfReading = [[RuleOfReading alloc] init];
    [self initView];
    [self initSectionHeader];
    [self GetReplyComment:0];
//    [self ShowWaiting];
    [self RememberNews];//记录新闻
    
    self.shareImg = [[UIImageView alloc]init];
    [self.shareImg sd_setImageWithURL:[NSURL URLWithString:self.CJZ_model.images[0]]];
    
    [Task_DetailWeb_model share].newsId = self.CJZ_model.ID;
    [Task_DetailWeb_model share].isOver = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    //监听tableview头部视图的变化
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HeaderNotifi:) name:@"header" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WebviewDidLoad) name:@"webViewDidLoad" object:nil];
    
    //监听分享窗口点击shi jian
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ItemClick:) name:@"分享点击事件" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SendReportToServer:) name:@"举报" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeFont:) name:@"字体改变" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DianZanAction:) name:@"点赞" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReadingWithOther:) name:@"相关阅读点击" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SectionHight:) name:@"sectionHight" object:nil];
    
    
    //注册观察键盘的变化
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transformDialog:) name:UIKeyboardWillChangeFrameNotification object:nil];
    /* 增加监听（当键盘出现或改变时） */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transformDialog:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //收回所有弹出窗口
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TakeBackAllDialog) name:HideAllDialog object:nil];
    
    //监听任务情况
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowRewardWin:) name:@"阅读文章任务完成" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Task_shareNews_Over:) name:@"分享文章任务完成" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(share_failed) name:@"新闻分享失败" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(share_sucess) name:@"新闻分享成功" object:nil];
    
    //热点
//    [[ NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(statusBarFrameWillChange:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil ];
    [[ NSNotificationCenter defaultCenter ] addObserver : self selector : @selector (layoutControllerSubViews:) name : UIApplicationDidChangeStatusBarFrameNotification object : nil ];
    
    
    //热点变化
    CGRect tabbarview_frame = m_tabbar_view.frame;
    if(STATUS_BAR_BIGGER_THAN_20){
        tabbarview_frame = CGRectMake(tabbarview_frame.origin.x, tabbarview_frame.origin.y-20, tabbarview_frame.size.width, tabbarview_frame.size.height);
    }
    m_tabbar_view.frame = tabbarview_frame;
}


-(void)statusBarFrameWillChange:(NSNotification*)noti{
//    NSLog(@"statusBarFrameWillChange");
//    [MBProgressHUD showSuccess:@"statusBarFrameWillChange"];
    
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

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


-(void)initView{
    self.view.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
    UIButton* button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:@"ic_nav_share"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(PageSetting) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
//    UIButton* back_button = [[UIButton alloc] initWithFrame:CGRectMake(16, 20, 16, 16)];
//    [back_button setImage:[UIImage imageNamed:@"ic_nav_back"] forState:UIControlStateNormal];
//    [back_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back_button];
    
    NSInteger barHeight = self.navigationController.navigationBar.frame.size.height;  //顶部NavigationBar高度
    NSInteger statusHeight = UIApplication.sharedApplication.statusBarFrame.size.height; //状态栏高度
    NSLog(@"barHeight=%ld statusHeight=%ld",(long)barHeight,statusHeight);
    
    //进度条初始化
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, statusHeight+barHeight, SCREEN_WIDTH, kWidth(2))];
    self.progressView.progressTintColor = RGBA(255, 129, 3, 1);
    self.progressView.trackTintColor = [UIColor whiteColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];

    //添加新闻内容（tableView） 头：webview+view 评论：cell
    CGRect frame = CGRectMake(0, CGRectGetMaxY(self.progressView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(self.progressView.frame)-48);//48 :底部栏 高度
    UITableView* tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = YES;
    tableView.estimatedRowHeight = 100.0f;
//    tableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    tableView.backgroundColor       = [UIColor whiteColor];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    tableView.separatorStyle        = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[reply_Cell class] forCellReuseIdentifier:@"reply"];
    [tableView registerClass:[NoReply_TableViewCell class] forCellReuseIdentifier:@"NullReply"];
    _reply_array                    = [[NSArray alloc] init];
    
    Header_ViewController* header = [[Header_ViewController alloc] init];
    header.url = _CJZ_model.url;
    header.model = _CJZ_model;
    header.delegate = self;
    header.progressView = self.progressView;
    tableView.tableHeaderView = header.view;
    self.headerView = header;
    [self GetNews];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self GetReplyComment:m_page];
    }];
    
    //添加底部tab栏
    NSInteger tabHight = 48;
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tableView.frame), SCREEN_WIDTH, tabHight)];
    view.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];

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
    if([[MyDataBase shareManager] Collect_IsCollected:[self.CJZ_model.ID integerValue]]){//是否点过赞
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
//    UIEdgeInsets insets = UIEdgeInsetsMake(-10, 0, -10, 0);
//    img = [img resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
//    [messge_button setImage:[UIImage imageNamed:@"ic_comment"] forState:UIControlStateNormal];
    [messge_button setImage:img forState:UIControlStateNormal];
//    [messge_button setImageEdgeInsets:insets];
    [messge_button addTarget:self action:@selector(Message) forControlEvents:UIControlEventTouchUpInside];
    [messge_button setCount:[self.CJZ_model.comment_num integerValue]];
    [view addSubview:messge_button];
    m_badgeButton = messge_button;
    
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
    
    [self.view addSubview:view];
}

-(void)initSectionHeader{
    m_sectionHeader_VC = [[SectionHeader_ViewController alloc]init];
    m_sectionHeader_VC.model = self.CJZ_model;
    if(self.channel != nil){ //如果是自定义频道时
        if(self.CJZ_model.origin_channel == nil){
            m_sectionHeader_VC.channel_id = self.CJZ_model.channel;
        }
        else{
            m_sectionHeader_VC.channel_id = self.CJZ_model.origin_channel;
        }
        
    }else{
        m_sectionHeader_VC.channel_id = self.CJZ_model.channel;
    }
    m_sectionHeader_VC.delegate = self;
    m_sectionHeader_Hight = m_sectionHeader_VC.view.frame.size.height;
    
    m_sectionHeader_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, m_sectionHeader_Hight)];
    m_sectionHeader_view.backgroundColor = [UIColor whiteColor];
    m_sectionHeader_view.clipsToBounds = YES;
    [m_sectionHeader_view addSubview:m_sectionHeader_VC.view];
    
}

-(void)ShowWaiting{
    m_waitting_VC = [[Waiting_ViewController alloc]init];
    m_waitting_VC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:m_waitting_VC.view];
}

-(void)HideWaitting{
    [m_waitting_VC.view removeFromSuperview];
}

-(void)RememberNews{
    if(!self.isFromHistory){
        [[MyDataBase shareManager] AddReadingNews:self.CJZ_model];
    }
}

-(void)GetNetFailed{
    [m_Reloaded_view removeFromSuperview];
    DateReload_view* view = [[DateReload_view alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    m_Reloaded_view = view;
    [m_Reloaded_view.button addTarget:self action:@selector(reloadNet) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_Reloaded_view];
}


#pragma mark - 弹出窗口
-(void)PageSetting{
    NSLog(@"右上角分享");
    
    //收回所有窗口
    [[NSNotificationCenter defaultCenter] postNotificationName:HideAllDialog object:nil];

    collectvModel* model = [[collectvModel alloc] init];
    model.name_array = @[@"朋友圈",@"微信好友",@"QQ好友",@"QQ空间",@"复制链接",@"举报",@"字体"];
    model.imgs_array = @[@"ic_friend",@"ic_wechat",@"ic_qq",@"ic_zone",@"ic_link",@"ic_report",@"ic_font"];
    model.lineInstance = 24;
    model.itemInstance = (SCREEN_WIDTH-28-28-48*4)/3;
    model.size = CGSizeMake(48, 60);
    model.itemsOfLine = 4;
    model.edge = UIEdgeInsetsMake(24, 28, 24, 28);//分别为上、左、下、右
    
    ShareSettingView* view = [[ShareSettingView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT+248, SCREEN_WIDTH, 248)];
    view.model = model;
    view.delegate = self;
    view.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
    m_youshangjiao_shareSettingView = view;
    
    ShareSetting_view* share_setting = [ShareSetting_view GetDialogView:view.frame withCusomView:view];
    self.shareSetting_View = share_setting;
    [self.shareSetting_View Show];
}

-(void)InputTextAction{
    NSLog(@"准备评论");
    if(![Login_info share].isLogined){
        [[AlertHelper Share]ShowMe:self And:0.5f And:@"没有登陆"];
        return;
    }
    //收回所有窗口
    [[NSNotificationCenter defaultCenter] postNotificationName:HideAllDialog object:nil];
    
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
    textField.delegate = self;
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
    [inputText_cancel.layer setCornerRadius:15.0f];
    inputText_cancel.layer.masksToBounds = YES;
    [inputText addSubview:inputText_cancel];
    
    //发送
    UIButton* inputText_true = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16-60, CGRectGetMaxY(textField.frame)+10, 60, 30)];
    [inputText_true setTitle:@"发送" forState:UIControlStateNormal];
    [inputText_true setTitleColor:[[ThemeManager sharedInstance] GetDialogTextColor] forState:UIControlStateNormal];
    [inputText_true.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
    [inputText_true addTarget:self action:@selector(DialogTure) forControlEvents:UIControlEventTouchUpInside];
    [inputText_true setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    [inputText_true.layer setCornerRadius:15.0f];
    inputText_true.layer.masksToBounds = YES;
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
//    NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
//    CGFloat height = self.tableView.contentSize.height;
//    NSLog(@"tableview contentSize:%f",height);
//    [self.tableView setContentOffset:CGPointMake(0, height-self.tableView.frame.size.height) animated:NO];


//    [self.tableView scrollToBottom];
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];  //取最后一行数据
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO]; //滚动到最后一行
    
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.tableHeaderView.frame.size.height+m_sectionHeader_Hight-62) animated:YES];
    
}

-(void)IsShoucang:(UIButton*)button{
    if(![Login_info share].isLogined){
        [MyMBProgressHUD ShowMessage:@"未登录!" ToView:[UIApplication sharedApplication].keyWindow AndTime:1.0f];
    }else{
    
    if(isShoucang){
        NSLog(@"取消收藏");
        [button setImage:[UIImage imageNamed:@"ic_collect"] forState:UIControlStateNormal];
        [[MyDataBase shareManager] Collect_UpData:[self.CJZ_model.ID integerValue] AndIsDIanZan:0];
        [self CollectedAction:0];
    }
    else{
        NSLog(@"订阅收藏");
        [button setImage:[UIImage imageNamed:@"ic_collected"] forState:UIControlStateNormal];
        if([[MyDataBase shareManager] Collect_IsHaveId:[self.CJZ_model.ID integerValue]]){//表中是否已经存在该字段
            [[MyDataBase shareManager] Collect_UpData:[self.CJZ_model.ID integerValue] AndIsDIanZan:1];
            [self CollectedAction:1];
        }else{
            [[MyDataBase shareManager] Collect_insertData:[self.CJZ_model.ID integerValue] AndIsDIanZan:1 AndTime:self.CJZ_model.publish_time];
            [self CollectedAction:1];
        }
    }
    isShoucang = !isShoucang;
    }
}

-(void)ShareAction{
    NSLog(@"准备分享");
    //收回所有窗口
    [[NSNotificationCenter defaultCenter] postNotificationName:HideAllDialog object:nil];
    
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
    m_fenxiang_shareSettingView = view;
    
    ShareSetting_view* share_setting = [ShareSetting_view GetDialogView:view.frame withCusomView:view];
    self.share_View = share_setting;
    [self.share_View Show];
}

-(void)SetFont{
    NSLog(@"字体窗口");
    //收回所有窗口
    [[NSNotificationCenter defaultCenter] postNotificationName:HideAllDialog object:nil];
    
    collectvModel* model = [[collectvModel alloc] init];
    model.name_array = @[@"小",@"中",@"大"];
    model.itemInstance = (SCREEN_WIDTH-42-32-72*3)/2;
    model.itemsOfLine = 3;
    model.lineInstance = 0;
    model.size = CGSizeMake(72, 40);
    model.edge = UIEdgeInsetsMake(30, 42, 30, 32);//分别为上、左、下、右
    model.IsOnlyTitle = YES;
    model.type = @"字体";
    model.IsOnlyOneSected = YES;
    NSInteger index = [[AppConfig sharedInstance] GetFontSize];
    if(index == MAX_CANON){
        model.array_Selected = @[@NO,@YES,@NO];
    }else{
        NSMutableArray* array_tmp = [NSMutableArray arrayWithObjects:@NO,@NO,@NO, nil];
        [array_tmp replaceObjectAtIndex:index withObject:@YES];
        model.array_Selected = array_tmp;
    }
    
    
    ShareSettingView* view = [[ShareSettingView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT+140, SCREEN_WIDTH, 140)];
    view.model = model;
    view.delegate = self;
    view.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
    m_fenxiang_shareSettingView = view;
    
    ShareSetting_view* share_setting = [ShareSetting_view GetDialogView:view.frame withCusomView:view];
    self.share_View = share_setting;
    [self.share_View Show];
}

-(void)ReportToMe{
    NSLog(@"举报");
    //收回所有窗口
    [[NSNotificationCenter defaultCenter] postNotificationName:HideAllDialog object:nil];
    
    collectvModel* model = [[collectvModel alloc] init];
    model.name_array = @[@"内容质量差",@"重复、旧闻",@"低俗色情",@"与标题不符",@"广告",@"涉嫌违法犯罪"];
    model.itemInstance = (SCREEN_WIDTH-21-21-154*2)/1;
    model.lineInstance = 24;
    model.itemsOfLine = 3;
    model.size = CGSizeMake(154, 40);
    model.edge = UIEdgeInsetsMake(30, 21, 30, 21);//分别为上、左、下、右
    model.IsOnlyTitle = YES;
    model.type = @"举报";
    model.IsOnlyOneSected = YES;
    model.array_Selected = @[@NO,@NO,@NO,@NO,@NO,@NO];
    
    ShareSettingView* view = [[ShareSettingView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT+268, SCREEN_WIDTH, 268)];
    view.model = model;
    view.delegate = self;
    view.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
    m_fenxiang_shareSettingView = view;
    
    ShareSetting_view* share_setting = [ShareSetting_view GetDialogView:view.frame withCusomView:view];
    self.share_View = share_setting;
    [self.share_View Show];
}

#pragma mark - 协议
-(void)showWebImages:(NSArray *)array  AndIndex:(NSInteger)index{
    showImages_ViewController* vc = [[showImages_ViewController alloc] init];
    vc.image_array = array;
    vc.index = index;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)setHeaderFrame{
    
    [self.headerView.webview evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id Result, NSError * error) {
        NSNumber* number = (NSNumber*)Result;
        NSLog(@"height----->%f",[number floatValue]);
        
        self.headerView.webview.frame = CGRectMake(0, 0, SCREEN_WIDTH, [number floatValue]);
        self.headerView.footView.frame = CGRectMake(0, self.headerView.webview.frame.size.height, SCREEN_WIDTH, self.headerView.footView.frame.size.height);
        self.headerView.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.headerView.webview.frame.size.height+self.headerView.footView.frame.size.height);
        
        self.headerView.footView.backgroundColor = RGBA(242, 242, 242, 1);
    
    Header_ViewController* header = self.headerView;
    [self.tableView beginUpdates];
    m_headerSize = CGSizeMake(SCREEN_WIDTH, self.headerView.view.frame.size.height);
    NSLog(@"----hight:%.2f",m_headerSize.height);
    UIView* headerView = header.view;
    CGFloat hight = self.tableView.frame.size.height;
//    CGFloat hight = SCREEN_HEIGHT;
    if(m_headerSize.height > hight*2.3){
       headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, hight*1.8);
        NSLog(@"----hight123:%.2f",headerView.frame.size.height);
    }
 
        if(m_headerSize.height > hight*2.3 && readingAll == nil){
            
            readingAll = [[UIView alloc] initWithFrame:CGRectMake(0, hight*1.8-80, SCREEN_WIDTH, 80)];
            
            UIView* touming = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
            touming.backgroundColor = RGBA(255, 255, 255, 0.7);
            [readingAll addSubview:touming];
            
            UIView* view_button = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 60)];
            view_button.backgroundColor = [UIColor whiteColor];
            [readingAll addSubview:view_button];
            
            UIButton* read_btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-kWidth(240)/2, 60/2-44/2, kWidth(240), 44)];
            [read_btn setTitle:@"点击查看全文" forState:UIControlStateNormal];
            [read_btn.layer setCornerRadius:44/2];
            [read_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [read_btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [read_btn addTarget:self action:@selector(readingAll_action) forControlEvents:UIControlEventTouchUpInside];
            read_btn.backgroundColor = RGBA(248, 205, 4, 1);
            [view_button addSubview:read_btn];
            
            UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 10)];
            line.backgroundColor = RGBA(242, 242, 242, 1);
            [readingAll addSubview:line];
            
            [headerView addSubview:readingAll];
        }
        else{
            
        }
    if(Is_readingAll){
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, m_headerSize.height);
    }
    
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableHeaderView.clipsToBounds = YES;

    [self.tableView endUpdates];
    [self.view layoutIfNeeded];
        
        
        //完成之后
        if(readingAll == nil){ //当没有出现阅读全文时
            Is_readingAll = YES;
        }
        [self WebviewDidLoad];
    }];
}

-(void)showNews:(CJZdataModel *)model{
    DetailWeb_ViewController* vc = [[DetailWeb_ViewController alloc]init];
    vc.CJZ_model = model;
    vc.channel = self.channel;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)webViewDidLoad:(NSString *)text{
    self.CJZ_model.decr = text;
}

-(void)webViewLoadFailed{
    [self WebviewDidLoad];
    [self GetNetFailed];
}

-(void)readingAll_action{
    Is_readingAll = YES;
    [self setHeaderFrame];
    [readingAll removeFromSuperview];
}

-(void)initSectionFrame:(CGFloat)height{
    m_sectionHeader_Hight = height;
    [self.tableView reloadData];
}

-(void)showGuangGao:(NSURLRequest *)request{
    Second_ViewController* vc = [[Second_ViewController alloc] init];
    vc.request = request;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)reportToSever:(NSNumber *)type{
    [self SendReportToServer:type];
}
-(void)shareSetting_changeFont:(NSNumber *)type{
    [self ChangeFont:type];
}
-(void)shareByName:(NSString *)name{
    [self ItemClick:name];
}

-(void)GoToReplyAll:(reply_model *)model{
    ReplyAll_ViewController* vc = [ReplyAll_ViewController new];
    vc.model = model;
    vc.newsId = self.CJZ_model.ID;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)replyFromMymodel:(reply_model *)myModel{
//    return;//用于第一个版本 不要回复
    [self InputTextAction];
    m_textView_placeHolder.text = @"";
    m_pre_reply = [NSString stringWithFormat:@"回复 %@:\n",myModel.myUserModel.user_name];
    m_textField.text = m_pre_reply;
    m_otherReply_model = myModel;
}

-(void)refreshCell:(reply_model *)model{
//    NSInteger index = [_reply_array indexOfObject:model];
//    [self.tableView reloadRow:index inSection:0 withRowAnimation:nil];
    [self.tableView reloadData];
}

#pragma mark - 按钮方法
-(void)DialogCancel{
    NSLog(@"DialogCancel");
    [self.inputReply removeFromSuperview];
    m_pre_reply = nil;
}

-(void)DialogTure{
    NSLog(@"DialogTure");
    NSString* str_comment = m_textField.text;
    if(m_pre_reply != nil){
        str_comment = [str_comment stringByReplacingOccurrencesOfString:m_pre_reply withString:@""];
    }
    m_pre_reply = nil;
    [self SendReply:str_comment];
    [self.inputReply removeFromSuperview];
    m_otherReply_model = nil;
}

-(void)tapClick:(UITapGestureRecognizer*)tap{
    [self DialogCancel];
    m_otherReply_model = nil;
    m_pre_reply = nil;
}

-(void)reloadNet{
    [self ShowWaiting];
    [self GetNews];
    [self GetReplyComment:0];
    [m_sectionHeader_VC GetDataWithReadingOther];
}

-(void)shareMore{
    if(![Login_info share].isLogined){
        [MyMBProgressHUD ShowMessage:@"未登陆" ToView:self.view AndTime:1.0f];
        return;
    }
    //要分享的内容，加在一个数组里边，初始化UIActivityViewController
    NSString *textToShare = self.CJZ_model.title;
//    UIImageView* img = [[UIImageView alloc] init];
//    [img sd_setImageWithURL:[NSURL URLWithString:[Login_info share].shareInfo_model.img]];
    UIImage *imageToShare = nil;
    if(self.headerView.mUrlArray.count == 0){
        imageToShare = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[Login_info share].shareInfo_model.img]]];
    }else{
        imageToShare = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.headerView.mUrlArray[0]]]];
    }
    NSURL *urlToShare = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.CJZ_model.url]];
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

#pragma mark - tableview代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

        if(_reply_array.count == 0){
            [self.tableView.footer setHidden:YES];
            return 1;
        }
        else{
            [self.tableView.footer setHidden:NO];
            return _reply_array.count;
        }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        if(_reply_array.count == 0){
            NoReply_TableViewCell* cell = [NoReply_TableViewCell cellWithTableView:tableView];
            return cell;
        }
        else{
            reply_Cell* cell = [reply_Cell cellWithTableView:tableView];
            cell.model = _reply_array[indexPath.row];
            cell.delegate = self;
            cell.tag = indexPath.row;

            //点击时 高亮的颜色
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[Color_Image_Helper createImageWithColor:RGBA(255, 85, 0, 0.3)]];
            
            return cell;
        }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

        if(_reply_array.count == 0){
            return 150.0;
        }else{
            reply_model* model = _reply_array[indexPath.row];
            CGFloat hight = [LabelHelper GetLabelHight:kFONT(14) AndText:model.comment AndWidth:SCREEN_WIDTH-kWidth(38)-kWidth(16)];//评论高度
            
            //回复高度
            NSInteger count = 0;
            for (reply_model* item in model.array_reply) {
                //上边距+name+name和content的边距+content
                if(count == 3) break;
                hight += [LabelHelper GetLabelHight:kFONT(14) AndText:item.comment AndWidth:SCREEN_WIDTH-kWidth(46)-kWidth(16)]+kWidth(13)+kWidth(5)+kWidth(12);
                count++;
            }
            if(model.array_reply.count > 0){
                hight += kWidth(16); //这个 16 是灰色回复区域 离 时间 的距离
            }
            
            if(model.array_reply.count > 3){
                hight += kWidth(24);
            }


            return kWidth(100)+hight;
            
//            reply_Cell* cell = [reply_Cell cellWithTableView:tableView];
//            cell.model = model;
//            NSLog(@"cell height-->%f",cell.height);
//            return cell.height;
        }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return m_sectionHeader_view;
//    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSLog(@"m_sectionHeader_Hight:%f",m_sectionHeader_Hight);
    return m_sectionHeader_Hight;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_reply_array.count == 0){
        return NO;
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_reply_array.count != 0){
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    reply_model* model = _reply_array[indexPath.row];
    [self replyFromMymodel:model];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"新闻详情页 滑动");
    //判断滑动5次 然后给予奖励
    //任务类型  1:提供开宝箱  2：阅读文章 3：分享文章  4:优质评论 5：晒收入 6：参与抽奖任务 7,查看常见问题 8：微信绑定奖励
    if([Login_info share].isLogined){
            if([[Login_info share].userInfo_model.device_mult_user integerValue] == NotTheDevice){
//                [MyMBProgressHUD ShowMessage:@"非绑定设备，不能执行任务" ToView:self.view AndTime:1.0f];
                return;
            }

        NSString* userId = [Login_info share].userInfo_model.user_id;
//        NSLog(@"新闻详细阅读 offse.y:%f",scrollView.contentOffset.y);
//        NSLog(@"新闻详细高度 height:%f",m_headerSize.height);
//        NSLog(@"新闻详细高度 tableview hight:%f",self.tableView.frame.size.height);
        if(![[MyDataBase shareManager] IsGetIncomeNews:self.CJZ_model.ID]){//防止重复 阅读奖励
            if([[TaskCountHelper share] TaskIsOverByType:Task_reading]){ //当任务次数已经完成后 不再提交任务
                return ;
            }
            BOOL isOk = [m_ruleOfReading AddReadingCountType:Task_reading
                                                   AndTaskId:[Md5Helper Read_taskId:userId AndNewsId:self.CJZ_model.ID]
                                                   AndNewsId:self.CJZ_model.ID
                                               AndScrollview:scrollView
                                                AndTableview:self.tableView
                                               AndHeaderSize:CGSizeMake(SCREEN_WIDTH, m_headerSize.height+m_sectionHeader_view.frame.size.height)
                                                AndIsReadAll:Is_readingAll
                                              AndScrollCount:m_scroll_count];
            if(isOk){
                [InternetHelp SendTaskId:[Md5Helper Read_taskId:userId AndNewsId:self.CJZ_model.ID]
                                 AndType:Task_reading
                                  Sucess:^(NSInteger type, NSDictionary *dic) {
                                      NSString* coin = dic[@"list"][@"reward_coin"];
                                      [[TaskCountHelper share] newUserTask_addCountByType:Task_reading];// 新手任务添加count
                                      [self ShowRewardWin:type AndMoney:coin];
                                      [[MyDataBase shareManager] AddGetIncomeNews:self.CJZ_model.ID];
                                      
                } Fail:^(NSDictionary *dic) {
                    NSLog(@"阅读任务上传失败");
                }];
            }
        }
    }
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    NSLog(@"新闻详情页 scrollViewDidEndScrollingAnimation");
    
}
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
//    NSLog(@"新闻详情页 scrollViewDidZoom");
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    NSLog(@"新闻详情页 scrollViewWillBeginDragging");
    m_start_point = scrollView.contentOffset;
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    NSLog(@"新闻详情页 scrollViewDidEndDragging");
    m_end_point = scrollView.contentOffset;
    
    if(m_end_point.y > m_start_point.y){ //保证只有向下滑动才算一次滚动
        m_scroll_count++;
    }
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
            [self presentViewController:alert_VC animated:YES completion:^{
                
                //隔一会就消失
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }];
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}


#pragma mark - 通知
-(void)WebviewDidLoad{
    [self HideWaitting];
}

//移动UIView(随着键盘移动)
-(void)transformDialog:(NSNotification *)aNSNotification
{
    NSLog(@"DetailWeb_VCL移动");
    //键盘最后的frame
    CGRect keyboardFrame = [aNSNotification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    NSLog(@"DetailWeb_VCL看看这个变化的Y值:%f",height);
    //需要移动的距离
    if (height > 0) {
        _transformY = height-_currentKeyboardH;
        _currentKeyboardH = height;
        //移动
        [UIView animateWithDuration:0.25f animations:^{
            CGRect frame = self.inputReply.frame;
            frame.origin.y -= _transformY;
            self.inputReply.frame = frame;
        }];
    }
}

-(void)keyboardWillHide:(NSNotification *)aNSNotification{
    /* 输入框下移 */
    [UIView animateWithDuration:0.25f animations:^ {
        
        CGRect frame = self.inputReply.frame;
        frame.origin.y = 0;
        self.inputReply.frame = frame;
    }];
    //记得再收键盘后 初始化键盘参数
    _transformY = 0;
    _currentKeyboardH = 0;
}

//键盘回收
-(void)keyboardHide
{
//    for(UIView *view in self.view.subviews)
//    {
//        [view resignFirstResponder];
//    }
    [m_textField resignFirstResponder];
}

//收回所有窗口
-(void)TakeBackAllDialog{
    
    [self.inputReply removeFromSuperview];//收回 写评论的Dialog
    [self.shareSetting_View Hide];//收回 右上角分享Dialog
    [self.share_View Hide];
}
-(void)ItemClick:(NSString *)name{
//    NSString* name = noti.object;
    if([@"朋友圈" isEqualToString:name]){
        NSLog(@"朋友圈");
        [UMShareHelper ShareNews:@"朋友圈" AndModel:self.CJZ_model AndImg:self.shareImg.image];
        [self TakeBackAllDialog];
    }
    if([@"微信好友" isEqualToString:name]){
        NSLog(@"微信好友");
        [UMShareHelper ShareNews:@"微信好友" AndModel:self.CJZ_model AndImg:self.shareImg.image];
        [self TakeBackAllDialog];
    }
    if([@"QQ好友" isEqualToString:name]){
        NSLog(@"QQ好友");
        [UMShareHelper ShareNews:@"QQ好友" AndModel:self.CJZ_model AndImg:self.shareImg.image];
        [self TakeBackAllDialog];
    }
    if([@"QQ空间" isEqualToString:name]){
        NSLog(@"QQ空间");
        [UMShareHelper ShareNews:@"QQ空间" AndModel:self.CJZ_model AndImg:self.shareImg.image];
        [self TakeBackAllDialog];
    }
    if([@"复制链接" isEqualToString:name]){
        NSLog(@"复制链接");
        [self copylinkBtnClick];
    }
    if([@"举报" isEqualToString:name]){
        NSLog(@"举报");
        if(![Login_info share].isLogined){
            [MBProgressHUD showMessage:@"未登录！"];
            return;
        }
        [self ReportToMe];
    }
    if([@"字体" isEqualToString:name]){
        NSLog(@"字体");
        [self SetFont];
    }
    if([@"更多" isEqualToString:name]){
        NSLog(@"更多");
        [self shareMore];
        [self TakeBackAllDialog];
    }
    if([@"夜间模式" isEqualToString:name]){
        NSLog(@"夜间模式");
    }
}
- (void)copylinkBtnClick {
    //收回所有窗口
    [[NSNotificationCenter defaultCenter] postNotificationName:HideAllDialog object:nil];
    
    [MBProgressHUD showSuccess:@"复制成功!"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@ %@&source=link",self.CJZ_model.title,self.CJZ_model.url];
}
// 实例： http://39.104.13.61：8090/api/report?json={"user_id":"YangYiTestNumber1713841009","news_id":0,"type":1}
-(void)SendReportToServer:(NSNumber*)number{
//    NSNumber* number = noti.object;
    NSInteger type = [number integerValue];
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:@"http://younews.3gshow.cn/api/report"];
    // 2.创建一个网络请求
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",@""]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"news_id",_CJZ_model.ID]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%ld\"",@"type",type]];
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务：
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error){
                NSLog(@"举报失败");
                [MBProgressHUD showSuccess:@"举报失败!"];
            }
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* code = dict[@"code"];
            if([code integerValue] == 200){
                NSLog(@"举报提交成功");
                [MBProgressHUD showSuccess:@"举报成功!"];
            }else{
                
            }
            
        });
    }];
    // 5.最后一步，执行任务（resume也是继续执行）:
    [sessionDataTask resume];
    
}

-(void)ChangeFont:(NSNumber*)number{
    NSLog(@"ChangeFont");
//    NSNumber* number = noti.object;
    NSInteger type = [number integerValue];
    
    //存储用户需要的字体
    [[AppConfig sharedInstance] saveFontSize:type];

    [self.headerView setFont:type];
    switch (type) {
        case 0: //小
//            [self.headerView.webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '80%'"];
//            self.headerView setFontState:(NSInteger)
            break;
        case 1://中
//            [self.headerView.webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];
            break;
        case 2://大
//            [self.headerView.webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '120%'"];
            break;
            
        default:
            break;
    }
    
    
}

-(void)DianZanAction:(NSNotification*)noti{
    if(![Login_info share].isLogined){
        [MyMBProgressHUD ShowMessage:@"未登录!" ToView:self.view AndTime:1.0f];
        return;
    }
    reply_model* model = noti.object;
    NSInteger action = model.DianZan_type;
    action = action == 1 ? 1 : 2;//1：点赞    2：取消点赞

    [InternetHelp DianzanById:model.ID andUser_id:[Login_info share].userInfo_model.user_id AndActionType:action];
}

-(void)SectionHight:(NSNotification*)noti{
    
}
-(void)share_sucess{
    [MyMBProgressHUD ShowMessage:@"分享成功" ToView:self.view AndTime:1.0f];
}
-(void)share_failed{
    [MyMBProgressHUD ShowMessage:@"分享失败" ToView:self.view AndTime:1.0f];
}

-(void)Task_shareNews_Over:(NSNotification*)noti{
    Task_reward_model* model = noti.object;
    [self ShowRewardWin:model.type AndMoney:model.coin];
    [[TaskCountHelper share] newUserTask_addCountByType:Task_shareNews];// 新手任务添加count
}

-(void)ShowRewardWin:(NSInteger)type AndMoney:(NSString*)GetGold{
    if(![Login_info share].isLogined){
//        [MBProgressHUD showError:@"未登陆无法领取奖励"];
        return;
    }
    //任务类型  1:提供开宝箱  2：阅读文章 3：分享文章  4:优质评论 5：晒收入 6：参与抽奖任务 7,查看常见问题 8：微信绑定奖励
//    NSNumber* number = noti.object;
//    NSInteger type = [number integerValue];
    
    [[TaskCountHelper share] DayDayTask_addCountByType:type];//增加完成任务次数
    
    CGFloat reward_width = SCREEN_WIDTH/2;
    UIView* reward_view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-reward_width/2, SCREEN_HEIGHT/2-reward_width/2, reward_width, reward_width)];
    reward_view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];
    [reward_view.layer setCornerRadius:5.0f];
    
    CGFloat img_width = reward_width-kWidth(10)-kWidth(70);
    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(reward_width/2-img_width/2, kWidth(10), img_width, img_width)];
    [img setImage:[UIImage imageNamed:@"toast_finish"]];
    [reward_view addSubview:img];
    
    UILabel* tips = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                              CGRectGetMaxY(img.frame)+10,
                                                              reward_width,
                                                              kWidth(16))];
    tips.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    tips.textAlignment = NSTextAlignmentCenter;
    tips.font = kFONT(14);
    if(type == Task_reading){
//        tips.text = @"认真阅读，金币自来~";
        NSArray* model_array = [[TaskCountHelper share] get_task_dayDay_name_array];
        TaskMaxCout_model* model = nil;
        for (TaskMaxCout_model* item in model_array) {
            if(item.type == Task_reading){
                model = item;
                if(model.count > model.maxCout){
                    return;
                }
            }
        }
        NSString* str = [NSString stringWithFormat:@"阅读奖励 (%ld/%ld)",model.count,model.maxCout];
        NSMutableAttributedString* str_att = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange index_start = [str rangeOfString:@"("];
        NSRange index_end = [str rangeOfString:@"/"];
        str_att = [LabelHelper GetMutableAttributedSting_color:str_att AndIndex:index_start.location+1 AndCount:index_end.location-index_start.location AndColor:RGBA(248, 205, 4, 1)];
        tips.attributedText = str_att;
    }
    if(type == Task_shareNews){
        NSArray* model_array = [[TaskCountHelper share] get_task_dayDay_name_array];
        TaskMaxCout_model* model = nil;
        for (TaskMaxCout_model* item in model_array) {
            if(item.type == Task_shareNews){
                model = item;
                if(model.count > model.maxCout){
                    return;
                }
            }
        }
        NSString* str = [NSString stringWithFormat:@"分享新闻 (%ld/%ld)",model.count,model.maxCout];
        NSMutableAttributedString* str_att = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange index_start = [str rangeOfString:@"("];
        NSRange index_end = [str rangeOfString:@"/"];
        str_att = [LabelHelper GetMutableAttributedSting_color:str_att AndIndex:index_start.location+1 AndCount:index_end.location-index_start.location AndColor:RGBA(248, 205, 4, 1)];
        tips.attributedText = str_att;
//        tips.text = @"新闻分享成功";
//        NSString* taskId = [Md5Helper Share_taskId:[Login_info share].userInfo_model.user_id AndNewsId:self.CJZ_model.ID];
//        [InternetHelp SendTaskId:taskId AndType:3];
    }
    
    [reward_view addSubview:tips];
    
    UILabel* money = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                              CGRectGetMaxY(tips.frame)+10,
                                                              reward_width,
                                                              24)];
    money.text = [NSString stringWithFormat:@"+%@",GetGold];
    money.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    money.textAlignment = NSTextAlignmentCenter;
    money.font = [UIFont boldSystemFontOfSize:24];
    [reward_view addSubview:money];
    
    [self.view addSubview:reward_view];
    
//    [UIView animateWithDuration:1 animations:^{
//        reward_view.alpha = 0.0;
//        [reward_view removeFromSuperview];
//    }];
    [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        reward_view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [reward_view removeFromSuperview];
    }];
}

#pragma mark - 数据API
-(void)GetNews{
//    [self ShowWaiting];
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:_CJZ_model.url];
    // 2.创建一个网络请求
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    
    [self.headerView.webview loadRequest:request];
//    // 3.获得会话对象
//    NSURLSession *session = [NSURLSession sharedSession];
//    // 4.根据会话对象，创建一个Task任务：
//    IMP_BLOCK_SELF(DetailWeb_ViewController);
//    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"详细页面");
//        if(error){
//            NSLog(@"详细页面错误");
//            return ;
//        }
//        /*
//         对从服务器获取到的数据data进行相应的处理：
//         */
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSData *strData = data;
//            NSString *nameStr =  [[NSString alloc]initWithData:strData encoding:NSUTF8StringEncoding];
//            [block_self.headerView.webview loadHTMLString:nameStr baseURL:[[NSBundle mainBundle] resourceURL] ];
//        });
//    }];
    // 5.最后一步，执行任务（resume也是继续执行）:
//    [sessionDataTask resume];
}

-(void)GetReplyComment:(NSInteger)type{
    // 1.创建一个网络路径
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/getComment"]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://dev.3gshow.cn/api/getComment"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[[Login_info share] GetUserInfo].user_id]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":%@",@"news_id",self.CJZ_model.ID]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":%ld",@"page",m_page]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":%d",@"size",10]];
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    IMP_BLOCK_SELF(DetailWeb_ViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if(error || data == nil){
                NSLog(@"GetReplyComment网络获取失败");
                //发送失败消息
                [block_self.tableView.footer endRefreshing];
                return ;
            }
            
            NSLog(@"GetReplyComment网络获取成功");
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
//            NSDictionary *dict = [self getDic];//测试数据
            NSNumber* code = dict[@"code"];
            if([code integerValue] == 200){
            }else{
                //发送失败消息
                [block_self.tableView.footer endRefreshing];
                return ;
            }
            
            NSArray *dataarray = [reply_model dicToArray:dict];
            NSMutableArray *statusArray = [NSMutableArray array];
            
            
            if(type == 0){//头次加载
                _reply_array = dataarray;
                [self.tableView reloadData];
                if(_reply_array.count >= 10){
                    m_page += 1;
                    [self.tableView.footer endRefreshing];
                }
                else{
                    [self.tableView.footer removeFromSuperview];
                }
                
                
            }else{
                [statusArray addObjectsFromArray:_reply_array];
                [statusArray addObjectsFromArray:dataarray];
                if(dataarray.count == 0){
                    [self.tableView.footer noticeNoMoreData]; //之后不要添加 endRefreshing
                }else{
                    m_page += 1;
                    _reply_array = statusArray;
                    [self.tableView reloadData];
                    [self.tableView.footer endRefreshing];
                }
            }
            
            
            
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}
//http://39.104.13.61：8090/api/comment?json={"user_id":"714B08C64ADD12284CA82BA39384B177","news_id":"10","comment":"hehe"}
-(void)SendReply:(NSString*)str_comment{
    NSString* To_userId = @"";
    if(m_otherReply_model != nil){ //当直接评论新闻时，没有userid
        To_userId = m_otherReply_model.myUserModel.user_id;
    }
    NSInteger pid = 0;
    if([m_otherReply_model.pid integerValue] == 0){
        pid = [m_otherReply_model.ID integerValue];
    }
    else{
        pid = [m_otherReply_model.pid integerValue];
    }
    [InternetHelp replyToOterReplyByUserId:[Login_info share].userInfo_model.user_id
                               andToUserId:To_userId
                                 andNewsId:self.CJZ_model.ID
                                    AndPid:pid
                                AndComment:str_comment Sucess:^(NSDictionary *dic) {
                                        [MyMBProgressHUD ShowMessage:@"评论成功" ToView:self.view AndTime:1.0f];
                                        [self GetReplyComment: 0];//刷新
    } Fail:^(NSDictionary *dic) {
        [MyMBProgressHUD ShowMessage:@"网络失败" ToView:self.view AndTime:1.0f];
    }];
    
//    [InternetHelp replyToServer_test:[Login_info share].userInfo_model.user_id andNewsId:self.CJZ_model.ID AndComment:str_comment Sucess:^(NSDictionary *dic) {
//        [MyMBProgressHUD ShowMessage:@"评论成功" ToView:self.view AndTime:1.0f];
//        [self GetReplyComment:0];
//    } Fail:^(NSDictionary *dic) {
//        [MyMBProgressHUD ShowMessage:@"网络失败" ToView:self.view AndTime:1.0f];
//    }];
    
}

-(void)CollectedAction:(NSInteger)action{
//http://39.104.13.61:8090/api/collect?json={"user_id":"YangYiTestNumber1713841009","news_id":"120","action":1}
    action = action == 1 ? 1 : 2;//1：收藏    2：取消收藏
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/collect"]];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[[Login_info share] GetUserInfo].user_id]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"news_id",self.CJZ_model.ID]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%ld\"",@"action",action]];//1：点赞    2：取消点赞
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    IMP_BLOCK_SELF(DetailWeb_ViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error || data == nil){
                NSLog(@"CollectedAction网络获取失败");
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
                    [[MyDataBase shareManager] Collect_UpData:[self.CJZ_model.ID integerValue] AndIsDIanZan:0]; //数据库取消操作
                }else{
                    [[MyDataBase shareManager] Collect_UpData:[self.CJZ_model.ID integerValue] AndIsDIanZan:1]; //数据库取消操作
                }
                
            }
            
        });
        
    }];
    [sessionDataTask resume];
}

/*
 {
 "id": "1",
 "pid": "0",
 "user_info": {
 "user_name": "橙友2755263",
 "user_icon": "",
 "wechat_nickname": "雅雅",
 "wechat_icon": "http://thirdwx.qlogo.cn/mmopen/vi_32/d7icwQNo1kjZV3vnvTbTJ1pTP9tMVpRhIt0BeicZKYuoSzpwBY0sknE5QQSrvBLmmmhEhiaIu01EqFy08gsl2fpRA/132"
 },
 "to_user_info": [
 
 ],
 "comment": "好文章1",
 "thumbs_num": "124",
 "ctime": "2018-05-15 10:26:09",
 "list": [
 */
-(NSDictionary*)getDic{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInteger:200] forKey:@"code"];
    
    NSMutableDictionary* user_dic = [NSMutableDictionary dictionary];
    [user_dic setObject:@"1" forKey:@"id"];
    [user_dic setObject:@"0" forKey:@"pid"];
    
    NSMutableDictionary* myUser_dic = [NSMutableDictionary dictionary];
    [myUser_dic setObject:@"橙友2755263" forKey:@"user_id"];
    [myUser_dic setObject:@"橙友2755263" forKey:@"user_name"];
    [myUser_dic setObject:@"" forKey:@"user_icon"];
    [myUser_dic setObject:@"雅雅" forKey:@"wechat_nickname"];
    [myUser_dic setObject:@"http://thirdwx.qlogo.cn/mmopen/vi_32/d7icwQNo1kjZV3vnvTbTJ1pTP9tMVpRhIt0BeicZKYuoSzpwBY0sknE5QQSrvBLmmmhEhiaIu01EqFy08gsl2fpRA/132" forKey:@"wechat_icon"];
    
    [user_dic setObject:myUser_dic forKey:@"user_info"];
    [user_dic setObject:@[] forKey:@"to_user_info"];
    [user_dic setObject:@"好文章1" forKey:@"comment"];
    [user_dic setObject:@"124" forKey:@"thumbs_num"];
    [user_dic setObject:@"2018-05-15 10:26:09" forKey:@"ctime"];
    
    NSDictionary* dic_one = [self getReplyById:@"2"
                                           pid:@"1"
                                   user_userId:@"xxxxx"
                                 user_userName:@"橙友8717165"
                                 user_userIcon:@""
                               user_wechatName:@"守候"
                               user_wechatIcon:@"http://thirdwx.qlogo.cn/mmopen/vi_32/EKagrrV6YQUwH2MKmiczK2ZjQDYlJdoGYD9ylz6hIvUNoxX9ukJ5PoV3cAXroKqEiaY6K6UU6zz76E2sLyQlTGkA/132"
                                 toUser_userId:@"xxxxx"
                               toUser_userName:@"橙友2755263123"
                               toUser_userIcon:@""
                             toUser_wechatName:@"雅雅"
                             toUser_wechatIcon:@"http://thirdwx.qlogo.cn/mmopen/vi_32/d7icwQNo1kjZV3vnvTbTJ1pTP9tMVpRhIt0BeicZKYuoSzpwBY0sknE5QQSrvBLmmmhEhiaIu01EqFy08gsl2fpRA/132"
                                       comment:@"你评论得对"
                                         ctime:@"2018-05-16 10:27:38"];
    
    NSDictionary* dic_two = [self getReplyById:@"3"
                                           pid:@"1"
                                   user_userId:@"6298_8660072"
                                 user_userName:@"橙友8717165432"
                                 user_userIcon:@""
                               user_wechatName:@"雲朵"
                               user_wechatIcon:@"http://thirdwx.qlogo.cn/mmopen/vi_32/OM8l68sNXEEclibqrneR9LibTY2z2EibfgHwyv4hogCFMI4eMqibIsRibsy4hjicTE5uAiarV5gL0veHMibDz8q98Jib4Vg/132"
                                 toUser_userId:@"xxxxx"
                               toUser_userName:@"橙友8717165"
                               toUser_userIcon:@""
                             toUser_wechatName:@"守候"
                             toUser_wechatIcon:@"http://thirdwx.qlogo.cn/mmopen/vi_32/EKagrrV6YQUwH2MKmiczK2ZjQDYlJdoGYD9ylz6hIvUNoxX9ukJ5PoV3cAXroKqEiaY6K6UU6zz76E2sLyQlTGkA/132"
                                       comment:@"确实对"
                                         ctime:@"2018-05-16 10:27:50"];
    
    NSDictionary* dic_three = [self getReplyById:@"3"
                                           pid:@"1"
                                   user_userId:@"6298_8660072"
                                 user_userName:@"橙友871716333"
                                 user_userIcon:@""
                               user_wechatName:@"雲朵3"
                               user_wechatIcon:@"http://thirdwx.qlogo.cn/mmopen/vi_32/OM8l68sNXEEclibqrneR9LibTY2z2EibfgHwyv4hogCFMI4eMqibIsRibsy4hjicTE5uAiarV5gL0veHMibDz8q98Jib4Vg/132"
                                 toUser_userId:@"xxxxx"
                               toUser_userName:@"橙友8717165"
                               toUser_userIcon:@""
                             toUser_wechatName:@"守候3"
                             toUser_wechatIcon:@"http://thirdwx.qlogo.cn/mmopen/vi_32/EKagrrV6YQUwH2MKmiczK2ZjQDYlJdoGYD9ylz6hIvUNoxX9ukJ5PoV3cAXroKqEiaY6K6UU6zz76E2sLyQlTGkA/132"
                                       comment:@"确实对"
                                         ctime:@"2018-05-16 10:27:52"];
    
    NSArray* array_one = [NSArray arrayWithObjects:dic_one,dic_two,dic_three, nil];
    [user_dic setObject:array_one forKey:@"list"];
    
    NSMutableDictionary* user_dic_two = [NSMutableDictionary dictionary];
    [user_dic_two setObject:@"1" forKey:@"id"];
    [user_dic_two setObject:@"0" forKey:@"pid"];
    
    NSMutableDictionary* myUser_dic_two = [NSMutableDictionary dictionary];
    [myUser_dic_two setObject:@"橙友2755263" forKey:@"user_id"];
    [myUser_dic_two setObject:@"橙友8717163" forKey:@"user_name"];
    [myUser_dic_two setObject:@"" forKey:@"user_icon"];
    [myUser_dic_two setObject:@"123" forKey:@"wechat_nickname"];
    [myUser_dic_two setObject:@"http://thirdwx.qlogo.cn/mmopen/vi_32/d7icwQNo1kjZV3vnvTbTJ1pTP9tMVpRhIt0BeicZKYuoSzpwBY0sknE5QQSrvBLmmmhEhiaIu01EqFy08gsl2fpRA/132" forKey:@"wechat_icon"];
    
    [user_dic_two setObject:myUser_dic_two forKey:@"user_info"];
    [user_dic_two setObject:@[] forKey:@"to_user_info"];
    [user_dic_two setObject:@"好文章2" forKey:@"comment"];
    [user_dic_two setObject:@"120" forKey:@"thumbs_num"];
    [user_dic_two setObject:@"2018-05-16 15:32:00" forKey:@"ctime"];
    
    [user_dic_two setObject:@[] forKey:@"list"];
    
    NSArray* array_two = [NSArray arrayWithObjects:user_dic,user_dic_two, nil];
    [dic setObject:array_two forKey:@"list"];
    return dic;
}

-(NSDictionary*)getReplyById:(NSString*)Id pid:(NSString*)pid
                            user_userId:(NSString*)user_userId
                            user_userName:(NSString*)user_userName
                            user_userIcon:(NSString*)user_userIcon
                            user_wechatName:(NSString*)user_wechatName
                            user_wechatIcon:(NSString*)user_wechatIcon
                            toUser_userId:(NSString*)toUser_userId
                            toUser_userName:(NSString*)toUser_userName
                            toUser_userIcon:(NSString*)toUser_userIcon
                            toUser_wechatName:(NSString*)toUser_wechatName
                            toUser_wechatIcon:(NSString*)toUser_wechatIcon
                            comment:(NSString*)comment
                            ctime:(NSString*)ctime{
                                NSMutableDictionary* dic = [NSMutableDictionary dictionary];
                                
                                [dic setObject:Id forKey:@"id"];
                                [dic setObject:pid forKey:@"pid"];
                                
                                NSMutableDictionary* myUser_dic = [NSMutableDictionary dictionary];
                                [myUser_dic setObject:user_userId forKey:@"user_id"];
                                [myUser_dic setObject:user_userName forKey:@"user_name"];
                                [myUser_dic setObject:user_userId forKey:@"user_icon"];
                                [myUser_dic setObject:user_wechatName forKey:@"wechat_nickname"];
                                [myUser_dic setObject:user_wechatIcon forKey:@"wechat_icon"];
                                
                                NSMutableDictionary* User_dic = [NSMutableDictionary dictionary];
                                [User_dic setObject:toUser_userId forKey:@"user_info"];
                                [User_dic setObject:toUser_userName forKey:@"user_name"];
                                [User_dic setObject:toUser_userIcon forKey:@"user_icon"];
                                [User_dic setObject:toUser_wechatName forKey:@"wechat_nickname"];
                                [User_dic setObject:toUser_wechatIcon forKey:@"wechat_icon"];
                                
                                [dic setObject:myUser_dic forKey:@"user_info"];
                                [dic setObject:User_dic forKey:@"to_user_info"];
                                
                                [dic setObject:comment forKey:@"comment"];
                                [dic setObject:ctime forKey:@"ctime"];
                                return dic;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
