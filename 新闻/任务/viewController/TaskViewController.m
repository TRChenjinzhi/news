//
//  TaskViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TaskViewController.h"
#import "NewUser_TableViewController.h"
#import "DayDayTask_TableViewController.h"
#import "Task_TableViewCell.h"
#import "Mine_question_ViewController.h"
#import "Login_info.h"
#import "Mine_login_ViewController.h"
#import "Task_BaiShi_ViewController.h"
#import "Mine_GetApprentice_ViewController.h"
#import "Mine_ShowToFriend_ViewController.h"
#import "SaiIncome_view.h"
#import "Mine_inviteApprence_ViewController.h"
#import "NewUserTask_model.h"
#import "GoldChangeToMoney_ViewController.h"
#import "Mine_choujiang_ViewController.h"
#import "Task_newUser_ViewController.h"

@interface TaskViewController ()<choujiang_protocol>

@property (nonatomic,strong)UIView* titleView;

@property (nonatomic,strong)UIView* boxWind;//宝箱

@property (nonatomic,strong)UIScrollView* MainScrollView;;
@property (nonatomic,strong)UIView* MainView;//放在scrollview的整块view

@end

@implementation TaskViewController{
    NSInteger statusHight;
    NSInteger naviHight;
    NSInteger tabbatHight;
    
    UIView*         m_navibar_view;
    UITapGestureRecognizer*     m_logo_tap;
    UIView*     m_logo_tips;
    UILabel*    m_logo_state_normal;
    UIView*    m_logo_state_time;
    NSTimer*    m_timer;
    NSInteger m_timer_count;
    UILabel*    m_logo_hour_lable;
    UILabel*    m_logo_min_lable;
    UILabel*    m_logo_second_lable;
    BOOL        m_isClicked_logo;
    UIView*     m_logo_view;
    UIView*     m_newUserTaskOver_win;
    UIView*     m_newUserOfGuide_view;
    
    NSArray*            DayDayTaskCount_array;//日常任务完成情况
    NSArray*            userTaskCount_array;//新手任务完成情况
    UITableView*        m_DayDayTask_tableview;
    NSMutableArray*     userTitleArray_model;
    NSMutableArray*     DayDayTaskTitleArray_model;
    NewUser_TableViewController* NewUserTabelViewControl;
    DayDayTask_TableViewController* DayDayTaskTabelViewConrol;
    UIView*                         m_newuserVCL_view;
    UIView*                         m_dayDayVCL_view;
    UIView*                         m_grayView;
    
    BOOL            m_isFirst;
}

-(UIScrollView *)MainScrollView{
    if(!_MainScrollView){
        _MainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, statusHight+56, SCREEN_WIDTH, SCREEN_HEIGHT-statusHight-56-tabbatHight)];
    }
    return _MainScrollView;
}

-(UIView *)MainView{
    if(!_MainView){
        _MainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 954)];
    }
    return _MainView;
}

-(instancetype)init{
    self = [super init];
    if(self){
//        self.title = @"任务";
//        self.tabBarItem.image = [UIImage imageNamed:@"ic_menu_task_default"];
//        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_menu_task_pressed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setupChildViewController:task title:@"任务" imageName:@"ic_menu_task_default" selectedImage:@"ic_menu_task_pressed"];
    m_isFirst = YES;//用来页面刷新,下次进入时
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavi];
    [self initView];
    if([Login_info share].isLogined){
        [self GetMaxTaskCount];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayDayTask_click:) name:@"日常任务点击" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SendTaskType_157:) name:@"任务完成157" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TaskRefresh) name:@"任务状态更新" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TaskRefresh) name:@"用户信息更新" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SendTaskType_157:) name:@"UMShareHelper-TaskViewController-晒收入分享完成" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IsClicked) name:@"SCNavi_TaskVCL_宝箱倒计时" object:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    if(m_isFirst){
        if([Login_info share].isLogined){
            [InternetHelp AutoLogin];
            [self GetMaxTaskCount];
//            [self getNewUserTaskCount];
            
            [self IsClicked]; //宝箱倒计时
            
            
            //由于要隐藏已完成的 首次收徒。 要隐藏 所以减少 scrollview的contentsize
//            if([Login_info share].userInfo_model.mastercode.length > 0){
//                CGSize size = self.MainScrollView.contentSize;
//                [self.MainScrollView setContentSize:CGSizeMake(size.width, size.height-[Task_TableViewCell HightForcell])];
//            }
        }
        else{
            //登陆后再退出登录，要进行数据刷新
            [self GetDayDayTaskData];
            DayDayTaskTabelViewConrol.array_model = DayDayTaskTitleArray_model;
        }
    }
    
    [self IsHideUserTask];//是否隐藏新手任务
    
}

-(void)initNavi{
    UIView* navibar_view = [[UIView alloc] initWithFrame:CGRectMake(0, StaTusHight, SCREEN_WIDTH, 56)];
    
//    UIButton* back_button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
//    [back_button setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
//    [back_button setImage:[UIImage imageNamed:@"ic_nav_back"] forState:UIControlStateNormal];
//    [back_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [navibar_view addSubview:back_button];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-80/2, 18, 80, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"任务列表";
    title.font = [UIFont boldSystemFontOfSize:18];
    title.textColor = [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    [navibar_view addSubview:title];
    
    //line
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 56-1, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [navibar_view addSubview:line];
    
    [self.view addSubview:navibar_view];
    m_navibar_view = navibar_view;
}

-(void)initView{
    statusHight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    naviHight = self.navigationController.navigationBar.frame.size.height;
    tabbatHight = self.tabBarController.tabBar.frame.size.height;
//    self.view.backgroundColor = [[ThemeManager sharedInstance] GetDialogViewColor];
    
    //初始化scrollview
    [self initScrollView];
    
    //初始化logo
    [self initLogo];
    
    //初始化tableView
    [self initTabelView];
    
    
}

-(void)initScrollView{
    self.MainScrollView.backgroundColor = [[ThemeManager sharedInstance] GetDialogViewColor];
    self.MainScrollView.showsVerticalScrollIndicator = NO;
    self.MainScrollView.showsHorizontalScrollIndicator = NO;
    self.MainScrollView.bounces = NO;
    [self.MainScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 954)];
}

-(void)initLogo{
    
    UIView* logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84)];
    logoView.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
    m_logo_view = logoView;
    
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(38, 7, SCREEN_WIDTH-38-38, 70)];
    [imgView setImage:[UIImage imageNamed:@"banner_box_bg"]];
    [logoView addSubview:imgView];
    
    UILabel* label_small = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-72/2, 24, 72, 12)];
    label_small.text = @"开宝箱有惊喜";
    label_small.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:12];
    label_small.textColor = [[ThemeManager sharedInstance] TaskGetTitleSmallLableColor];
    [logoView addSubview:label_small];
    
    m_logo_tips = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-94/2, CGRectGetMaxY(label_small.frame)+8, 94, 18)];
    UILabel* label_big = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 94, 18)];
    label_big.text = @"立即开宝箱";
    label_big.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:18];
    label_big.textColor = [[ThemeManager sharedInstance] TaskGetTitleBigLableColor];
    m_logo_state_normal = label_big;
    [m_logo_tips addSubview:label_big];
    [logoView addSubview:m_logo_tips];
    
    //判断是否倒计时 结束
    [self IsClicked];
    
    //透明的 点击层
    UIView* clickView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84)];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(LogoClick)];
    m_logo_tap = tap;
    [clickView addGestureRecognizer:tap];
    clickView.alpha = 0.3;
    [logoView addSubview:clickView];
    
    [self.MainView addSubview:logoView];
    self.titleView = logoView;
}

-(void)IsClicked{
    if(![Login_info share].isLogined){
        return;
    }
    //获取保存时间点
    NSInteger time_start = [[AppConfig sharedInstance] getBoxTime];
    //获取当前 时间点
    NSInteger time_now = [[NSDate date] timeIntervalSince1970];
    
    //时间差
    NSInteger count = time_now - time_start;
    
    if(0 <= count && count < BoxTime){
        [self LogoClicked];
    }else{
        m_isClicked_logo = NO;
    }
}

-(void)initTabelView{
    //新手
    UIView* newUserView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_logo_view.frame)+kWidth(10), SCREEN_WIDTH, kWidth(128))];
    newUserView.backgroundColor = [UIColor whiteColor];
    m_newuserVCL_view = newUserView;
    [self.MainView addSubview:newUserView];
    
    UIView* shu_line = [[UIView alloc] initWithFrame:CGRectMake(kWidth(16), kWidth(20), kWidth(4), kWidth(20))];
    shu_line.backgroundColor = RGBA(255, 129, 3, 1);
    [newUserView addSubview:shu_line];
//    [shu_line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(newUserView.mas_bottom).with.offset(kWidth(20));
//        make.left.equalTo(newUserView.mas_left).with.offset(kWidth(16));
//        make.width.mas_offset(kWidth(4));
//        make.height.mas_offset(kWidth(20));
//    }];
    
    UILabel* tips = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(shu_line.frame)+kWidth(8), kWidth(20), kWidth(80), kWidth(18))];
    tips.text           = @"新手任务";
    tips.textColor      = RGBA(122, 125, 125, 1);
    tips.textAlignment  = NSTextAlignmentLeft;
    tips.font           = kFONT(18);
    [newUserView addSubview:tips];
//    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(shu_line.mas_right).with.offset(kWidth(8));
//        make.top.equalTo(newUserView.mas_bottom).with.offset(kWidth(20));
//        make.height.mas_offset(kWidth(18));
//    }];
    
    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth(16), newUserView.frame.size.height-kWidth(10)-kWidth(70), SCREEN_WIDTH-kWidth(16)*2, kWidth(70))];
    [img setImage:[UIImage imageNamed:@"banner_bg"]];
    img.userInteractionEnabled = YES;
    [newUserView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(newUserView.mas_left).with.offset(kWidth(16));
        make.right.equalTo(newUserView.mas_right).with.offset(-kWidth(16));
        make.bottom.equalTo(newUserView.mas_bottom).with.offset(-kWidth(10));
        make.height.mas_offset(kWidth(70));
    }];
    
    UIImageView* img_go = [UIImageView new];
    [img_go setImage:[UIImage imageNamed:@"banner_go_s"]];
    [img addSubview:img_go];
    NSArray* array_imgs = @[[UIImage imageNamed:@"banner_go_s"],[UIImage imageNamed:@"banner_go"]];
    img_go.animationImages = array_imgs;
    img_go.animationDuration = 1.0;
    img_go.animationRepeatCount = NSUIntegerMax;
    [img_go startAnimating];
    
    [img_go mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.and.width.mas_offset(kWidth(70));
        make.right.equalTo(img).with.offset(-kWidth(11));
        make.centerY.equalTo(img.mas_centerY);
    }];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToUserTask)];
    [img addGestureRecognizer:tap];
    
//    [self GetData];
////    NSLog(@"logoView-->%f",CGRectGetMaxY(self.titleView.frame));
//    UIView* newUserView = [[UIView alloc] initWithFrame:CGRectMake(0, 94, SCREEN_WIDTH, 48+66*userTitleArray_model.count)];
//    newUserView.backgroundColor = [[ThemeManager sharedInstance] GetDialogViewColor];
//    NewUser_TableViewController* newUser_tableView = [[NewUser_TableViewController alloc] initWithStyle:UITableViewStylePlain];
//    newUser_tableView.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 48+66*userTitleArray_model.count);
//    newUser_tableView.array_model = userTitleArray_model;
//    newUser_tableView.Headertitle = @"新手任务";
//    [newUser_tableView.tableView registerClass:[Task_TableViewCell class] forCellReuseIdentifier:@"TaskCell"];
//    [newUserView addSubview:newUser_tableView.tableView];
//    NewUserTabelViewControl = newUser_tableView;
//    [self.MainView addSubview:newUserView];
//    m_newuserVCL_view = newUserView;

    
    //中间灰色 分界区域
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(newUserView.frame), SCREEN_WIDTH, 10)];
    view.backgroundColor = [[ThemeManager sharedInstance] GetDialogViewColor];
    [self.MainView addSubview:view];
    m_grayView = view;
    
    //日常任务
    [self GetDayDayTaskData];
    DayDayTask_TableViewController* dayDayTask_TableView = [[DayDayTask_TableViewController alloc] initWithStyle:UITableViewStylePlain];
    UIView* dayDayTaskView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), SCREEN_WIDTH, 30+176+66*DayDayTaskTitleArray_model.count)];
    dayDayTaskView.backgroundColor = [UIColor redColor];
    dayDayTaskView.clipsToBounds = YES;

    dayDayTask_TableView.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30+176+66*DayDayTaskTitleArray_model.count);
    dayDayTask_TableView.array_model = DayDayTaskTitleArray_model;
    if([Login_info share].isLogined){
        [dayDayTask_TableView setHeadertitle:@"日常任务" AndDayCount:[[[Login_info share] GetUserInfo].login_times integerValue]];
    }else{
        [dayDayTask_TableView setHeadertitle:@"日常任务" AndDayCount:0];
    }
    
    [dayDayTask_TableView.tableView registerClass:[Task_TableViewCell class] forCellReuseIdentifier:@"DayDayTaskCell"];
    [dayDayTaskView addSubview:dayDayTask_TableView.tableView];
    DayDayTaskTabelViewConrol = dayDayTask_TableView;
    m_DayDayTask_tableview = dayDayTask_TableView.tableView;
    [self.MainView addSubview:dayDayTaskView];
    self.MainView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(dayDayTaskView.frame));
    m_dayDayVCL_view = dayDayTaskView;
    
    
    [self.MainScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, m_logo_view.frame.size.height+newUserView.frame.size.height+view.frame.size.height+dayDayTaskView.frame.size.height)];
    
    [self.MainScrollView addSubview:self.MainView];
    [self.view addSubview:self.MainScrollView];
    
    [self IsHideUserTask];//是否隐藏新手任务
}

-(void)IsHideUserTask{
    if([Login_info share].isLogined){
        //是否已经阅读过相关阅读
        //是否已经微信绑定
        //是否已经收徒

//        if([[TaskCountHelper share] newUserTask_isOver]){
        if([[Login_info share].userMoney_model.is_wechat_withdraw integerValue] == 1){ // 0：否 1：是
//            return; //测试

                //当完成首次1元提现后 才能隐藏新手任务
                [m_newuserVCL_view removeFromSuperview];
                [m_grayView removeFromSuperview];
                m_dayDayVCL_view.frame = CGRectMake(0, CGRectGetMaxY(m_logo_view.frame)+kWidth(10), SCREEN_WIDTH, 30+176+66*DayDayTaskTitleArray_model.count);
                [self.MainScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, m_logo_view.frame.size.height+m_dayDayVCL_view.frame.size.height)];

            
            [self.view layoutIfNeeded];
        }else{ //没有完成 首次一元任务
            //弹出 “恭喜您完成新手任务”
            if([[TaskCountHelper share] newUserTask_isOver]){
                if(![[AppConfig sharedInstance] getShowWinForFirstDone_newUserTask]){ //是否已经显示过了
                    [[AppConfig sharedInstance] saveShowWinForFirstDone_newUserTask:YES];
                    //显示弹窗-提醒用户可以首次1元提现
                    [self showNewUserWin_Done];
                }
            }
            m_newuserVCL_view.frame = CGRectMake(0, CGRectGetMaxY(m_logo_view.frame)+kWidth(10), SCREEN_WIDTH, kWidth(128));
            [self.MainView addSubview:m_grayView];
            [self.MainView addSubview:m_newuserVCL_view];
            m_dayDayVCL_view.frame = CGRectMake(0, CGRectGetMaxY(m_grayView.frame), SCREEN_WIDTH, 30+176+66*DayDayTaskTitleArray_model.count);
            [self.MainScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, m_logo_view.frame.size.height+m_newuserVCL_view.frame.size.height+m_grayView.frame.size.height+m_dayDayVCL_view.frame.size.height)];
            
            //是否添加新手指导
            if(![[AppConfig sharedInstance] getGuideOfNewUser]){
                [self.MainScrollView setContentOffset:CGPointZero animated:NO];
                [[AppConfig sharedInstance] saveGuideOfNewUser:YES];
                [self showGuideOfNewUserUI];
            }
        }
        
    }else{//未登陆时
        m_newuserVCL_view.frame = CGRectMake(0, CGRectGetMaxY(m_logo_view.frame)+kWidth(10), SCREEN_WIDTH, kWidth(128));
        [self.MainView addSubview:m_grayView];
        [self.MainView addSubview:m_newuserVCL_view];
        m_dayDayVCL_view.frame = CGRectMake(0, CGRectGetMaxY(m_grayView.frame), SCREEN_WIDTH, 30+176+66*DayDayTaskTitleArray_model.count);
        [self.MainScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, m_logo_view.frame.size.height+m_newuserVCL_view.frame.size.height+m_grayView.frame.size.height+m_dayDayVCL_view.frame.size.height)];
    }
}

-(void)showNewUserWin_Done{
    m_newUserTaskOver_win = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    m_newUserTaskOver_win.backgroundColor = RGBA(0, 0, 0, 0.6);
    [[UIApplication sharedApplication].keyWindow addSubview:m_newUserTaskOver_win];
    
    UIView* centerView = [UIView new];
    centerView.backgroundColor = [UIColor whiteColor];
    [centerView.layer setCornerRadius:8.0f];
    centerView.clipsToBounds = YES;
    [m_newUserTaskOver_win addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(m_newUserTaskOver_win);
        make.height.mas_offset(kWidth(234));
        make.left.equalTo(m_newUserTaskOver_win.mas_left).with.offset(kWidth(40));
        make.right.equalTo(m_newUserTaskOver_win.mas_right).with.offset(-kWidth(40));
    }];
    
    //上半边
    UIView* top_view = [UIView new];
    top_view.backgroundColor = RGBA(255, 62, 71, 1);
    [centerView addSubview:top_view];
    [top_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(centerView);
        make.height.mas_offset(kWidth(130));
    }];
    
    UIButton* del_btn = [UIButton new];
    [del_btn setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [del_btn addTarget:self action:@selector(closeWin) forControlEvents:UIControlEventTouchUpInside];
    [top_view addSubview:del_btn];
    [del_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(top_view.mas_top).with.offset(kWidth(10));
        make.right.equalTo(top_view.mas_right).with.offset(-kWidth(10));
        make.height.and.width.mas_offset(kWidth(20));
    }];
    
    UIImageView* imgV = [UIImageView new];
    [imgV setImage:[UIImage imageNamed:@"complete"]];
    [imgV.layer setCornerRadius:kWidth(36)/2];
    imgV.clipsToBounds = YES;
    [top_view addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.and.width.mas_offset(kWidth(36));
        make.top.equalTo(top_view.mas_top).with.offset(kWidth(20));
        make.centerX.equalTo(top_view.mas_centerX);
    }];
    
    UILabel* tips_one = [UILabel new];
    tips_one.text               = @"恭喜您完成新手任务";
    tips_one.textColor          = RGBA(255, 255, 255, 1);
    tips_one.textAlignment      = NSTextAlignmentCenter;
    tips_one.font               = kFONT(18);
    [top_view addSubview:tips_one];
    [tips_one mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(top_view);
        make.top.equalTo(imgV.mas_bottom).with.offset(kWidth(12));
    }];
    
    UILabel* tips_two = [UILabel new];
    tips_two.text               = @"马上去提现吧";
    tips_two.textColor          = RGBA(255, 208, 210, 1);
    tips_two.textAlignment      = NSTextAlignmentCenter;
    tips_two.font               = kFONT(14);
    [top_view addSubview:tips_two];
    [tips_two mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(top_view);
        make.top.equalTo(tips_one.mas_bottom).with.offset(kWidth(10));
    }];
    
    //下半边
    UIView* bottom_view = [UIView new];
    [centerView addSubview:bottom_view];
    [bottom_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(centerView);
        make.height.mas_offset(kWidth(104));
    }];
    
    UIButton* oneYuan_btn = [UIButton new];
    [oneYuan_btn setTitle:@"提现1元到微信" forState:UIControlStateNormal];
    [oneYuan_btn setTitleColor:RGBA(217, 31, 3, 1) forState:UIControlStateNormal];
    [oneYuan_btn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
    [oneYuan_btn.layer setCornerRadius:kWidth(36)/2];
    [oneYuan_btn addTarget:self action:@selector(goToUserTask) forControlEvents:UIControlEventTouchUpInside];
    oneYuan_btn.clipsToBounds = YES;
    [bottom_view addSubview:oneYuan_btn];
    [oneYuan_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(kWidth(36));
        make.top.equalTo(bottom_view.mas_top).with.offset(kWidth(20));
        make.left.equalTo(bottom_view.mas_left).with.offset(kWidth(50));
        make.right.equalTo(bottom_view.mas_right).with.offset(-kWidth(50));
    }];
    
    UILabel* tips_three = [UILabel new];
    tips_three.text             = @"首次1元即可提现";
    tips_three.textColor        = RGBA(158, 151, 151, 1);
    tips_three.textAlignment    = NSTextAlignmentCenter;
    tips_three.font             = kFONT(12);
    [bottom_view addSubview:tips_three];
    [tips_three mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(bottom_view);
        make.top.equalTo(oneYuan_btn.mas_bottom).with.offset(kWidth(16));
    }];
    
}

-(void)showGuideOfNewUserUI{
    m_newUserOfGuide_view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    m_newUserOfGuide_view.backgroundColor = RGBA(0, 0, 0, 0.6);
    [[UIApplication sharedApplication].keyWindow addSubview:m_newUserOfGuide_view];
    
    UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, statusHight+56+94, kWidth(324), kWidth(224))];
    [imgV setImage:[UIImage imageNamed:@"guide_text"]];
    imgV.userInteractionEnabled = YES;
    [m_newUserOfGuide_view addSubview:imgV];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeGuideOfNewUserUI)];
    [imgV addGestureRecognizer:tap];
}

#pragma mark - 按钮方法
-(void)goToUserTask{
    Task_newUser_ViewController* vc = [Task_newUser_ViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
    [self closeWin];
}
-(void)LogoClick{
    NSLog(@"LogoClick");
    if(![Login_info share].isLogined){
        Mine_login_ViewController* vc = [[Mine_login_ViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    else{
        if([[Login_info share].userInfo_model.device_mult_user integerValue] == NotTheDevice){
            [MyMBProgressHUD ShowMessage:@"非绑定设备，不能执行任务" ToView:self.view AndTime:1.0f];
            return;
        }
    }
    
    NSNotification* noti = [NSNotification notificationWithName:@"" object:[NSNumber numberWithInteger:1]];
    [self SendTaskType_157:noti];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"任务完成157" object:];
}

-(void)LogoClicked{
    if(m_isClicked_logo){
        return;
    }
//    tap.enabled = NO;
    m_logo_tap.enabled = NO;
    //倒计时lable
    [m_logo_state_normal removeFromSuperview];//移除
    m_logo_state_time = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 94, 12)];
    [self CreateTimeLable];
    [m_logo_tips addSubview:m_logo_state_time];//添加倒计时lable
    [self Logo_time_click];
    
    m_isClicked_logo = YES;
}

-(void)CreateTimeLable{
    m_logo_hour_lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 22)];
    m_logo_hour_lable.text = @"02";
    m_logo_hour_lable.textColor = RGBA(249, 41, 64, 1);
    m_logo_hour_lable.backgroundColor = [UIColor whiteColor];
    m_logo_hour_lable.font = [UIFont systemFontOfSize:12];
    m_logo_hour_lable.textAlignment = NSTextAlignmentCenter;
    [m_logo_hour_lable.layer setCornerRadius:4];
    [m_logo_hour_lable.layer setMasksToBounds:YES];
    [m_logo_state_time addSubview:m_logo_hour_lable];
    
    UILabel* hour = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(m_logo_hour_lable.frame)+4, 0, 16, 22)];
    hour.text = @"时";
    hour.textColor = [UIColor whiteColor];
    hour.font = [UIFont systemFontOfSize:12];
    [m_logo_state_time addSubview:hour];
    
    m_logo_min_lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(hour.frame)+4, 0, 20, 22)];
    m_logo_min_lable.text = @"00";
    m_logo_min_lable.textColor = RGBA(249, 41, 64, 1);
    m_logo_min_lable.backgroundColor = [UIColor whiteColor];
    m_logo_min_lable.font = [UIFont systemFontOfSize:12];
    m_logo_min_lable.textAlignment = NSTextAlignmentCenter;
    [m_logo_min_lable.layer setCornerRadius:4];
    [m_logo_min_lable.layer setMasksToBounds:YES];
    [m_logo_state_time addSubview:m_logo_min_lable];
    
    UILabel* min = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(m_logo_min_lable.frame)+4, 0, 16, 22)];
    min.text = @"分";
    min.textColor = [UIColor whiteColor];
    min.font = [UIFont systemFontOfSize:12];
    [m_logo_state_time addSubview:min];
    
    m_logo_second_lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(min.frame)+4, 0, 20, 22)];
    m_logo_second_lable.text = @"00";
    m_logo_second_lable.textColor = RGBA(249, 41, 64, 1);
    m_logo_second_lable.backgroundColor = [UIColor whiteColor];
    m_logo_second_lable.font = [UIFont systemFontOfSize:12];
    m_logo_second_lable.textAlignment = NSTextAlignmentCenter;
    [m_logo_second_lable.layer setCornerRadius:4];
    [m_logo_second_lable.layer setMasksToBounds:YES];
    [m_logo_state_time addSubview:m_logo_second_lable];
    
    UILabel* sec = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(m_logo_second_lable.frame)+4, 0, 20, 22)];
    sec.text = @"秒";
    sec.textColor = [UIColor whiteColor];
    sec.font = [UIFont systemFontOfSize:12];
    [m_logo_state_time addSubview:sec];
}

-(void)Logo_time_click{
    //获取保存时间点
    NSInteger time_start = [[AppConfig sharedInstance] getBoxTime];
    //获取当前 时间点
    NSInteger time_now = [[NSDate date] timeIntervalSince1970];
    
    if(time_start == 0){
        m_timer_count = BoxTime;
        [[AppConfig sharedInstance] saveBoxTime:time_now];
    }else{
        NSInteger count = time_now - time_start;
        if(count < BoxTime ){
            m_timer_count = BoxTime-count;
        }else{
            m_timer_count = BoxTime;
            [[AppConfig sharedInstance] saveBoxTime:0];
        }
    }
    
    //直接就开始显示倒计时时间 不用等1秒
    NSInteger hour = m_timer_count/3600;
    NSInteger min = m_timer_count/60;
    if(min >= 60){
        min = min%60;
    }
    NSInteger sec = m_timer_count%60;
    m_logo_hour_lable.text = [NSString stringWithFormat:@"%02ld",hour];
    m_logo_min_lable.text = [NSString stringWithFormat:@"%02ld",min];
    m_logo_second_lable.text = [NSString stringWithFormat:@"%02ld",sec];
    
    m_timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if(m_timer_count <= 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                if(m_timer_count <= 0){
                    m_logo_tap.enabled = YES;
                    [m_logo_state_time removeFromSuperview];
                    [m_logo_tips addSubview:m_logo_state_normal];
                    [m_timer invalidate];
                    
                    //保存时间
                    [[AppConfig sharedInstance] saveBoxTime:0];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskVCL_SCNaci_宝箱重置提醒" object:nil];
                    
                    m_isClicked_logo = NO;
                }
            });
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                m_timer_count--;
                NSInteger hour = m_timer_count/3600;
                NSInteger min = m_timer_count/60;
                if(min >= 60){
                    min = min%60;
                }
                NSInteger sec = m_timer_count%60;
                m_logo_hour_lable.text = [NSString stringWithFormat:@"%02ld",hour];
                m_logo_min_lable.text = [NSString stringWithFormat:@"%02ld",min];
                m_logo_second_lable.text = [NSString stringWithFormat:@"%02ld",sec];
                m_logo_tap.enabled = NO;
                
//                [self.view layoutIfNeeded];
                
            });
        }
    }];
    
    //当手指在屏幕时，nstimer停止运行 参考：https://www.cnblogs.com/6duxz/p/4633741.html
    [[NSRunLoop mainRunLoop] addTimer:m_timer forMode:NSRunLoopCommonModes];
}

-(void)ShowBoxWind:(NSString*)coin{
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 10, 10)];
    view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];
    
    //背景
    UIView* blackground_view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 10, 10)];
    blackground_view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];
    blackground_view.alpha = 0.6;
    
    //图片
    CGFloat img_width = SCREEN_WIDTH-30-30;
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 109, img_width, img_width)];
    [imgView setImage:[UIImage imageNamed:@"box_open"]];
    [view addSubview:imgView];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame)+16, SCREEN_WIDTH, 14)];
    label.text = @"恭喜您获得金币";
    label.textColor = [[ThemeManager sharedInstance] TaskGetTitleSmallLableColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:14];
    [view addSubview:label];
    
    UILabel* number = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)+16, SCREEN_WIDTH, 24)];
    number.text = [NSString stringWithFormat:@"+%@",coin];
    number.textColor = [[ThemeManager sharedInstance] TaskGetTitleBigLableColor];
    number.textAlignment = NSTextAlignmentCenter;
    number.font = [UIFont fontWithName:@"Arial Rounded MT Bold"  size:(24.0)];
    [view addSubview:number];
    
    UIButton* closeButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-120/2, CGRectGetMaxY(number.frame)+16, 120, 36)];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    closeButton.layer.cornerRadius = 18.0;
    closeButton.clipsToBounds = YES;
    [closeButton addTarget:self action:@selector(closeBoxWind) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:closeButton];
    
    [self.view addSubview:view];
    self.boxWind = view;
    
    [UIView animateWithDuration:0.05 animations:^{
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        view.frame = frame;
        [self.view layoutIfNeeded];
    }];
}

-(void)closeBoxWind{
    [self.boxWind removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)GetData{
    userTitleArray_model = [TaskData GetNewUserTask_data];
}

-(void)GetDayDayTaskData{

    DayDayTaskTitleArray_model = [TaskData GetDayDayTask_data];
}

-(void)closeWin{
    [m_newUserTaskOver_win removeFromSuperview];
}


-(void)closeGuideOfNewUserUI{
    NSLog(@"退出新手指导");
    [m_newUserOfGuide_view removeFromSuperview];
}

#pragma mark - 通知
-(void)dayDayTask_click:(NSNotification*)noti{
    /*
     1. 签到
     2. 首次收徒
     3. 收徒
     4. 阅读文章
     5. 分享文章
     6. 观看视频
     7. 优质评论（按点赞数奖励）
     8. 晒收入
     9. 参与抽奖
     10. 摇一摇
     */
    
    if(![Login_info share].isLogined){//未登陆时
        Mine_login_ViewController* vc = [[Mine_login_ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    else{
        if([[Login_info share].userInfo_model.device_mult_user integerValue] == NotTheDevice){
            [MyMBProgressHUD ShowMessage:@"非绑定设备，不能执行任务" ToView:self.view AndTime:1.0f];
            return;
        }
    }
    NSNumber* number = noti.object;
    NSInteger index = [number integerValue];
    switch (index) {
        case Task_FirstShouTu:
        {
            NSLog(@"首次收徒");
            Mine_inviteApprence_ViewController* vc = [[Mine_inviteApprence_ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case Task_ShouTu:{
            NSLog(@"收徒");
            Mine_inviteApprence_ViewController* vc = [[Mine_inviteApprence_ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case Task_reading:{
            NSLog(@"阅读新闻");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"频道切换" object: [NSNumber numberWithInt:0]];
            break;
        }
        case Task_shareNews:{
            NSLog(@"分享文章");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"频道切换" object: [NSNumber numberWithInt:0]];
            break;
        }
        case Task_video:{
            NSLog(@"观看视频");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"频道切换" object: [NSNumber numberWithInt:1]];
            break;
        }
        case Task_reply:{
            NSLog(@"优质评论");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"频道切换" object: [NSNumber numberWithInt:0]];
            break;
        }
        case Task_showIncome:{
            NSLog(@"晒收入");
            [self SaiIncome];
            break;
        }
        case Task_chouJiang:{
            NSLog(@"参与抽奖");
            Mine_choujiang_ViewController* vc = [[Mine_choujiang_ViewController alloc] init];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }

        default:
            break;
    }
}

-(void)TaskRefresh{
    [NewUserTabelViewControl.tableView reloadData];
    
    [DayDayTaskTabelViewConrol setHeadertitle:@"日常任务" AndDayCount:[[[Login_info share] GetUserInfo].login_times integerValue]];
    [DayDayTaskTabelViewConrol.tableView reloadData];
    
//    [self IsHideUserTask];//是否隐藏新手任务
}

-(void)SaiIncome{
    SaiIncome_view* sai_view = [[SaiIncome_view alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:sai_view];
}

#pragma mark - 协议
-(void)choujiang_result:(BOOL)isDone AndTaskId:(NSString*)taskId{
    if(isDone){
        [InternetHelp SendTaskId:taskId AndType:Task_chouJiang Sucess:^(NSInteger type, NSDictionary *dic) {
            NSString* coin = dic[@"list"][@"reward_coin"];
            [RewardHelper ShowReward:Task_chouJiang AndSelf:self AndCoin:coin];
            DayDayTaskTabelViewConrol.array_model = DayDayTaskTitleArray_model;
        } Fail:^(NSDictionary *dic) {
            [MyMBProgressHUD ShowMessage:@"抽奖上传失败!" ToView:self.view AndTime:1.0f];
        }];
    }
}


#pragma mark - 获取task_id
-(NSString*)GetTaskId:(NSInteger)type{
    //任务类型  1:提供开宝箱  2：阅读文章 3：分享文章  4:优质评论 5：晒收入 6：参与抽奖任务 7,查看常见问题 8：微信绑定奖励 9.视频任务 10.摇一摇 11.朋友圈收徒
    switch (type) {
        case Task_box:{
            return [Md5Helper Box_taskId:[[Login_info share]GetUserInfo].user_id];
            break;
        }
        case Task_reading:{
            //阅读文章
            break;
        }
        case 3:{
            //分享文章
            break;
        }
        case 4:{
            //优质评论
            break;
        }
        case Task_showIncome:{
            return [Md5Helper ShowIncome_taskId:[[Login_info share]GetUserInfo].user_id];
            break;
        }
        case Task_chouJiang:{
            //参与抽奖任务
            break;
        }
        case Task_readQuestion:{
            return [Md5Helper Question_taskId:[[Login_info share]GetUserInfo].user_id];
            break;
        }
        case Task_blindWechat:{
            return [Md5Helper Wechat_taskId:[[Login_info share]GetUserInfo].user_id];
            break;
        }
        case Task_yaoyiyao:{
            
            break;
        }
            
        default:
            break;
    }
    
    return nil;
}

#pragma mark - 任务API
-(void)SendTaskType_157:(NSNotification*)noti{
    //任务类型  1:提供开宝箱  2：阅读文章 3：分享文章  4:优质评论 5：晒收入 6：参与抽奖任务 7,查看常见问题 8：微信绑定奖励
    NSNumber* number = noti.object;
    NSInteger type = [number integerValue];
    NSString* taskId = @"";
    taskId = [self GetTaskId:type];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/task"]];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[[Login_info share]GetUserInfo].user_id]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%ld\"",@"type",type]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"task_id",taskId]];
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    IMP_BLOCK_SELF(TaskViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error || data == nil){
                NSLog(@"SendTaskType_157网络获取失败");
                //发送失败消息
                [MBProgressHUD showError:@"网络出错"];
                if(type == 1){ //网络出错时，箱子倒计时重置
                    [m_logo_state_time removeFromSuperview];
                    [m_logo_tips addSubview:m_logo_state_normal];
                    [[AppConfig sharedInstance] saveBoxTime:0];
                }
                return ;
            }
            NSLog(@"SendTaskType_157从服务器获取到数据");
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* number = dict[@"code"];
            NSInteger code = [number integerValue];
            if(code != 200){
                NSLog(@"%@",dict[@"message"]);
                if(type == 1){
//                    [MBProgressHUD showError:@"2小时内不能重复打开宝箱"];
                    [MyMBProgressHUD ShowMessage:@"2小时内不能重复打开宝箱" ToView:block_self.view AndTime:1];
                }
                return;
            }
            NSString* coin = dict[@"list"][@"coin"];
//            NSInteger myCoin = [[[Login_info share] GetUserMoney].coin integerValue];
            NSString* myRewardCoin = dict[@"list"][@"reward_coin"];
            [[Login_info share] GetUserMoney].coin = coin;
            switch (type) {
                case Task_box:{
//                    [MBProgressHUD showSuccess:@""];
                    [self LogoClicked];//开始倒计时
                    [block_self ShowBoxWind:[NSString stringWithFormat:@"%@",myRewardCoin]];
                    break;
                }
                case Task_showIncome:{
//                    [MBProgressHUD showSuccess:@"晒收入 任务完成"];
                    [RewardHelper ShowReward:Task_showIncome AndSelf:self AndCoin:myRewardCoin];
                    break;
                }
                case Task_readQuestion:{
                    [MBProgressHUD showSuccess:@"查看常见问题 任务完成"];
                    [[TaskCountHelper share] newUserTask_addCountByType:Task_readQuestion];
                    [self TaskRefresh];
                    
                    break;
                }
                    
                default:
                    break;
            }
            
            [block_self GetMaxTaskCount];//重新获取
            
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

//获取每次任务允许完成最大次数
-(void)GetMaxTaskCount{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/taskStatus"]];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[[Login_info share]GetUserInfo].user_id]];
//    args = [args stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%ld\"",@"type",type]];
    //    args = [args stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"size",10]];
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
//        IMP_BLOCK_SELF(TaskViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

            if(error || data == nil){
                NSLog(@"GetMaxTaskCount网络获取失败");
                //发送失败消息
//                [MBProgressHUD showError:@"网络错误"];
                [MyMBProgressHUD ShowMessage:@"网络错误" ToView:self.view AndTime:1.0f];
                return ;
            }
            NSLog(@"GetMaxTaskCount从服务器获取到数据");
            
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* number = dict[@"code"];
            NSInteger code = [number integerValue];
            if(code != 200){
                return;
            }
            DayDayTaskCount_array = [TaskMaxCout_model dicToArray:dict];
            [TaskCountHelper share].taskcountModel_array = DayDayTaskCount_array;
            
            //同步宝箱时间
            [self synchronousBoxTime:DayDayTaskCount_array];
            
            
            
            //将数据插入到该任务
            for (TaskMaxCout_model* item in DayDayTaskCount_array) {
                for (TaskCell_model* model in DayDayTaskTitleArray_model) {
                    /*
                     日常任务：1.签到 2.首次收徒 3.收徒 4.阅读文章 5.分享文章 6.观看视频 7.优质评论（按点赞数奖励）8.晒收入 9.参与抽奖 10.摇一摇得金币
                     */
                    if([model.title isEqualToString:DayDayTask_FirstShouTu]){
                        model.type = Task_FirstShouTu;
                    }
                    if([model.title isEqualToString:DayDayTask_ShouTu]){
                        model.type = Task_ShouTu;
                    }
                    if([model.title isEqualToString:DayDayTask_GoodReply]){
                        model.type = Task_reply;
                    }

                    if(item.type == Task_reading && [model.title isEqualToString:DayDayTask_readNews]){
                        model.DayDay_model = item;
                        model.type = Task_reading;
                        
                        if(item.maxCout <= item.count){
                            model.isDone = YES;
                        }
                        break;
                    }
                    if(item.type == Task_shareNews && [model.title isEqualToString:DayDayTask_shareNews]){
                        model.DayDay_model = item;
                        model.type = Task_shareNews;
                        
                        if(item.maxCout <= item.count){
                            model.isDone = YES;
                        }
                        break;
                    }
                    if(item.type == Task_video && [model.title isEqualToString:DayDayTask_readVideo]){
                        model.DayDay_model = item;
                        model.type = Task_video;
                        
                        if(item.maxCout <= item.count){
                            model.isDone = YES;
                        }
                        break;
                    }
                    if(item.type == Task_showIncome && [model.title isEqualToString:DayDayTask_showIncome]){
                        model.DayDay_model = item;
                        model.type = Task_showIncome;
                        
                        if(item.maxCout <= item.count){
                            model.isDone = YES;
                        }
                        break;
                    }
                    if(item.type == Task_chouJiang && [model.title isEqualToString:DayDayTask_choujiang]){
                        model.DayDay_model = item;
                        model.type = Task_chouJiang;
                        
                        if(item.maxCout <= item.count){
                            model.isDone = YES;
                        }
                        break;
                    }
                }
            }
            
            if([[Login_info share].userInfo_model.appren_count integerValue] > 0){
                for (TaskCell_model* model in DayDayTaskTitleArray_model) {
                    if([model.title isEqualToString:DayDayTask_FirstShouTu]){
                        [DayDayTaskTitleArray_model removeObject:model];
                        self.MainScrollView.contentSize = CGSizeMake(self.MainScrollView.contentSize.width, self.MainScrollView.contentSize.height-[Task_TableViewCell HightForcell]);
                        break;
                    }
                }
            }
            
            DayDayTaskTabelViewConrol.array_model = DayDayTaskTitleArray_model;
            
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}



//同步服务器宝箱时间
-(void)synchronousBoxTime:(NSArray*)array{
    for (TaskMaxCout_model* model in array) {
        if(model.type == 1){
            NSInteger boxTime = model.lastOpenBox_time;
            NSInteger boxTime_local = [[AppConfig sharedInstance] getBoxTime];
            if(boxTime != boxTime_local){
                //恢复宝箱初始状态
                m_logo_tap.enabled = YES;
                [m_logo_state_time removeFromSuperview];
                [m_logo_tips addSubview:m_logo_state_normal];
                [m_timer invalidate];
                //保存时间
                [[AppConfig sharedInstance] saveBoxTime:boxTime];
                m_isClicked_logo = NO;
                
                //开始判断宝箱状态
                [self IsClicked];
            }
        }
    }
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
