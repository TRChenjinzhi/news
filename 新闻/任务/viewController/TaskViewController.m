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

@interface TaskViewController ()

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
    
    NSArray* array_count;
    UITableView*        m_DayDayTask_tableview;
    NSMutableArray*     array_model;//测试
    NSMutableArray* DayDayTask_model;//测试
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
    [self initNavi];
    [self initView];
    [self GetMaxTaskCount];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newuserTask_click:) name:@"新手任务点击" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayDayTask_click:) name:@"日常任务点击" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SendTaskType_157:) name:@"任务完成157" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TaskRefresh) name:@"任务状态更新" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TaskRefresh) name:@"用户信息更新" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SendTaskType_157:) name:@"UMShareHelper-TaskViewController-晒收入分享完成" object:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    if(m_isFirst){
        if([Login_info share].isLogined){
            [InternetHelp AutoLogin];
            [self GetMaxTaskCount];
            [NewUserTabelViewControl.tableView reloadData];
            [DayDayTaskTabelViewConrol.tableView reloadData];
        }
    }
    [self IsClicked]; //宝箱倒计时
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
    
    if(0 <= count && count < 2*60*60){
        [self LogoClicked];
    }else{
        m_isClicked_logo = NO;
    }
}

-(void)initTabelView{
    //新手
    [self GetData];
    NSLog(@"logoView-->%f",CGRectGetMaxY(self.titleView.frame));
    UIView* newUserView = [[UIView alloc] initWithFrame:CGRectMake(0, 94, SCREEN_WIDTH, 48+66*array_model.count)];
    newUserView.backgroundColor = [[ThemeManager sharedInstance] GetDialogViewColor];
    NewUser_TableViewController* newUser_tableView = [[NewUser_TableViewController alloc] initWithStyle:UITableViewStylePlain];
    newUser_tableView.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 48+66*array_model.count);
    newUser_tableView.array_model = array_model;
    newUser_tableView.Headertitle = @"新手任务";
    [newUser_tableView.tableView registerClass:[Task_TableViewCell class] forCellReuseIdentifier:@"TaskCell"];
    [newUserView addSubview:newUser_tableView.tableView];
    NewUserTabelViewControl = newUser_tableView;
    [self.MainView addSubview:newUserView];
    m_newuserVCL_view = newUserView;

    
    //中间灰色 分界区域
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(newUserView.frame), SCREEN_WIDTH, 10)];
    view.backgroundColor = [[ThemeManager sharedInstance] GetDialogViewColor];
    [self.MainView addSubview:view];
    m_grayView = view;
    
    //日常任务
    [self GetDayDayTaskData];
    DayDayTask_TableViewController* dayDayTask_TableView = [[DayDayTask_TableViewController alloc] initWithStyle:UITableViewStylePlain];
    UIView* dayDayTaskView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), SCREEN_WIDTH, 30+176+66*DayDayTask_model.count)];
    dayDayTaskView.backgroundColor = [UIColor redColor];

    dayDayTask_TableView.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30+176+66*DayDayTask_model.count);
    dayDayTask_TableView.array_model = DayDayTask_model;
    [dayDayTask_TableView setHeadertitle:@"日常任务" AndDayCount:[[[Login_info share] GetUserInfo].login_times integerValue]];
    [dayDayTask_TableView.tableView registerClass:[Task_TableViewCell class] forCellReuseIdentifier:@"DayDayTaskCell"];
    [dayDayTaskView addSubview:dayDayTask_TableView.tableView];
    DayDayTaskTabelViewConrol = dayDayTask_TableView;
    m_DayDayTask_tableview = dayDayTask_TableView.tableView;
    [self.MainView addSubview:dayDayTaskView];
    m_dayDayVCL_view = dayDayTaskView;
    
    
    [self.MainScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, m_logo_view.frame.size.height+newUserView.frame.size.height+view.frame.size.height+dayDayTaskView.frame.size.height)];
    
    [self.MainScrollView addSubview:self.MainView];
    [self.view addSubview:self.MainScrollView];
    
}

-(void)IsHideUserTask{
    if([Login_info share].isLogined){
        //是否已经阅读过相关阅读
        //是否已经微信绑定
        //是否已经收徒
        NSString* readingState = [Login_info share].userInfo_model.is_read_question;
        NSString* wechatState = [Login_info share].userInfo_model.wechat_binding;
        NSString* apprenticeCount = [Login_info share].userInfo_model.appren_count;
        if([readingState isEqualToString:@"1"] &&
           [wechatState isEqualToString:@"1"] &&
           [apprenticeCount integerValue] > 0){

            [m_newuserVCL_view removeFromSuperview];
            [m_grayView removeFromSuperview];
            m_dayDayVCL_view.frame = CGRectMake(0, 94, SCREEN_WIDTH, 30+176+66*DayDayTask_model.count);
            [self.MainScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, m_logo_view.frame.size.height+m_dayDayVCL_view.frame.size.height)];
        }else{
            m_newuserVCL_view.frame = CGRectMake(0, 94, SCREEN_WIDTH, 48+66*array_model.count);
            [self.MainView addSubview:m_grayView];
            [self.MainView addSubview:m_newuserVCL_view];
            m_dayDayVCL_view.frame = CGRectMake(0, CGRectGetMaxY(m_grayView.frame), SCREEN_WIDTH, 30+176+66*DayDayTask_model.count);
            [self.MainScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, m_logo_view.frame.size.height+m_newuserVCL_view.frame.size.height+m_grayView.frame.size.height+m_dayDayVCL_view.frame.size.height)];
        }
        
    }else{
        
    }
}

#pragma mark - 按钮方法
-(void)LogoClick{
    NSLog(@"LogoClick");
    if(![Login_info share].isLogined){
        Mine_login_ViewController* vc = [[Mine_login_ViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        return;
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
        m_timer_count = 2*60*60;
        [[AppConfig sharedInstance] saveBoxTime:time_now];
    }else{
        NSInteger count = time_now - time_start;
        if(count < 2*60*60 ){
            m_timer_count = 2*60*60-count;
        }else{
            m_timer_count = 2*60*60;
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
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 109, 300, 300)];
    [imgView setImage:[UIImage imageNamed:@"box_open"]];
    [view addSubview:imgView];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 -98/2, CGRectGetMaxY(imgView.frame)+16, 98, 14)];
    label.text = @"恭喜您获得金币";
    label.textColor = [[ThemeManager sharedInstance] TaskGetTitleSmallLableColor];
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
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
    closeButton.backgroundColor = [UIColor colorWithRed:248/255.0 green:205/255.0 blue:4/255.0 alpha:1/1.0];
    closeButton.layer.cornerRadius = 18.0;
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
    array_model = [NSMutableArray array];
    NSArray* title = @[@"绑定微信",@"查看常见问题",@"首次邀请好友"];
    NSArray* money = @[@50,@20,@2];
    NSArray* isYuan = @[@0,@0,@1];
    NSArray* isDone = @[@0,@0,@0];
    NSArray* subTitle = @[@"绑定后可直接提现至微信",@"认真阅读平台规则",@"首次邀请好友，额外多奖励2元"];
    for(int i=0;i<title.count;i++){
        TaskCell_model* model = [[TaskCell_model alloc] init];
        model.title = title[i];
        NSNumber* number = money[i];
        model.Money = number.integerValue;
        model.subTitle = subTitle[i];
        NSNumber* number1 = isYuan[i];
        if([number1 integerValue] == 1){
            model.IsYuan = YES;
        }else{
            model.IsYuan = NO;
        }
        NSNumber* number2 = isDone[i];
        if([number2 integerValue] == 1){
            model.isDone = YES;
        }else{
            model.isDone = NO;
        }
        
        [array_model addObject:model];
    }
    [TaskCountHelper share].task_newUser_name_array = array_model;
}

-(void)GetDayDayTaskData{
    DayDayTask_model = [NSMutableArray array];
    NSArray* title = @[@"邀请好友",@"阅读新闻",@"分享文章",@"优质评论",@"晒收入"];
    NSArray* money = @[@1,@10,@10,@10,@20];
    NSArray* isYuan = @[@1,@0,@0,@0,@0];
    NSArray* isDone = @[@0,@0,@0,@0,@0];
    NSArray* subTitle = @[@"每成功邀请一名好友，奖励1元奖金",@"认真阅读，每篇奖励20金币",@"分享文章给好友，每次奖励10金币",
                          @"有见解有趣味的评论会获得额外的奖励",@"晒出自己的收入，每次奖励20金币"];
    for(int i=0;i<title.count;i++){
        TaskCell_model* model = [[TaskCell_model alloc] init];
        model.title = title[i];
        NSNumber* number = money[i];
        model.Money = number.integerValue;
        model.subTitle = subTitle[i];
        NSNumber* number1 = isYuan[i];
        if([number1 integerValue] == 1){
            model.IsYuan = YES;
        }else{
            model.IsYuan = NO;
        }
        NSNumber* number2 = isDone[i];
        if([number2 integerValue] == 1){
            model.isDone = YES;
        }else{
            model.isDone = NO;
        }
        
        [DayDayTask_model addObject:model];
    }
    [TaskCountHelper share].task_dayDay_name_array = DayDayTask_model;
}


#pragma mark - 通知
-(void)newuserTask_click:(NSNotification*)noti{
    //@[@"绑定微信",@"输入邀请码",@"查看常见问题",@"首次邀请好友"];
    NSNumber* number = noti.object;
    NSInteger index = [number integerValue];
    
    if(![Login_info share].isLogined){//未登陆时
        Mine_login_ViewController* vc = [[Mine_login_ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    switch (index) {
        case 0:
            NSLog(@"绑定微信");
            [UMShareHelper LoginWechat:@"微信"];
            break;
        case 1:{
            NSLog(@"查看常见问题");
            Mine_question_ViewController* vc = [[Mine_question_ViewController alloc] init];
            vc.isTask = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:{
            NSLog(@"首次邀请好友");
            NSString* apprenticeCount = [Login_info share].userInfo_model.appren_count;
            NSInteger count = [apprenticeCount integerValue];
            if(count > 0){
                Mine_GetApprentice_ViewController* vc = [[Mine_GetApprentice_ViewController alloc]init];
                vc.array_model = [[NSArray alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                Mine_ShowToFriend_ViewController* vc = [[Mine_ShowToFriend_ViewController alloc]init];
                vc.number = [[Login_info share].userInfo_model.appren integerValue];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        }
        case 3:{
            NSLog(@"输入邀请码");
            Task_BaiShi_ViewController* vc = [[Task_BaiShi_ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
    
}

-(void)dayDayTask_click:(NSNotification*)noti{
    //@[@"邀请好友",@"阅读新闻",@"分享新闻",@"优质评论",@"晒收入",@"参与抽奖"];
    
    if(![Login_info share].isLogined){//未登陆时
        Mine_login_ViewController* vc = [[Mine_login_ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    NSNumber* number = noti.object;
    NSInteger index = [number integerValue];
    switch (index) {
        case 0:
        {
            NSLog(@"邀请好友");
            if(![Login_info share].isLogined){
                Mine_login_ViewController* vc = [[Mine_login_ViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            //        [self getApprenticeData];
            Mine_inviteApprence_ViewController* vc = [[Mine_inviteApprence_ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:
            NSLog(@"阅读新闻");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"频道切换" object: [NSNumber numberWithInt:0]];
            break;
        case 2:{
            NSLog(@"分享文章");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"频道切换" object: [NSNumber numberWithInt:0]];
            break;
        }
        case 3:
            NSLog(@"优质评论");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"频道切换" object: [NSNumber numberWithInt:0]];
            break;
        case 4:
            NSLog(@"晒收入");
            [self SaiIncome];
            break;
        case 5:
            NSLog(@"参与抽奖");
            break;
        default:
            break;
    }
}

-(void)TaskRefresh{
    [NewUserTabelViewControl.tableView reloadData];
    
    [DayDayTaskTabelViewConrol setHeadertitle:@"日常任务" AndDayCount:[[[Login_info share] GetUserInfo].login_times integerValue]];
    [DayDayTaskTabelViewConrol.tableView reloadData];
    
    [self IsHideUserTask];//是否隐藏新手任务
}

-(void)SaiIncome{
    SaiIncome_view* sai_view = [[SaiIncome_view alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:sai_view];
}

#pragma mark - 获取task_id
-(NSString*)GetTaskId:(NSInteger)type{
    //任务类型  1:提供开宝箱  2：阅读文章 3：分享文章  4:优质评论 5：晒收入 6：参与抽奖任务 7,查看常见问题 8：微信绑定奖励
    switch (type) {
        case 1:{
            return [Md5Helper Box_taskId:[[Login_info share]GetUserInfo].user_id];
            break;
        }
        case 2:{
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
        case 5:{
            return [Md5Helper ShowIncome_taskId:[[Login_info share]GetUserInfo].user_id];
            break;
        }
        case 6:{
            //参与抽奖任务
            break;
        }
        case 7:{
            return [Md5Helper Question_taskId:[[Login_info share]GetUserInfo].user_id];
            break;
        }
        case 8:{
            return [Md5Helper Wechat_taskId:[[Login_info share]GetUserInfo].user_id];
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
            if(error){
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
                    [MBProgressHUD showError:@"2小时内不能重复打开宝箱"];
                }
                return;
            }
            NSString* coin = dict[@"list"][@"coin"];
//            NSInteger myCoin = [[[Login_info share] GetUserMoney].coin integerValue];
            NSString* myRewardCoin = dict[@"list"][@"reward_coin"];
            [[Login_info share] GetUserMoney].coin = coin;
            switch (type) {
                case 1:{
//                    [MBProgressHUD showSuccess:@""];
                    [self LogoClicked];//开始倒计时
                    [block_self ShowBoxWind:[NSString stringWithFormat:@"%@",myRewardCoin]];
                    break;
                }
                case 5:{
                    [MBProgressHUD showSuccess:@"晒收入 任务完成"];
                    break;
                }
                case 7:{
                    [MBProgressHUD showSuccess:@"查看常见问题 任务完成"];
                    [Login_info share].userInfo_model.is_read_question = @"1";
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
    //任务类型  1:提供开宝箱  2：阅读文章 3：分享文章  4:优质评论 5：晒收入 6：参与抽奖任务 7,查看常见问题 8：微信绑定奖励
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

            if(error){
                NSLog(@"GetMaxTaskCount网络获取失败");
                //发送失败消息
                [MBProgressHUD showError:@"网络错误"];
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
            array_count = [TaskMaxCout_model dicToArray:dict];
            [TaskCountHelper share].taskcountModel_array = array_count;
            
            //将数据插入到该任务
            for (TaskMaxCout_model* item in array_count) {
                for (TaskCell_model* model in DayDayTask_model) {
                    //@[@"邀请好友",@"阅读新闻",@"绑定分享新闻",@"优质评论",@"晒收入",@"参与抽奖"];
                    if(item.type == 2 && [model.title isEqualToString:@"阅读新闻"]){
                        TaskCell_model* model_tmp = DayDayTask_model[1];
                        model_tmp.count_model = item;
                        
                        if(item.maxCout <= item.count){
                            model_tmp.isDone = YES;
                        }
                        [DayDayTask_model replaceObjectAtIndex:1 withObject:model_tmp];
                        break;
                    }
                    if(item.type == 3 && [model.title isEqualToString:@"分享文章"]){
                        TaskCell_model* model_tmp = DayDayTask_model[2];
                        model_tmp.count_model = item;
                        if(item.maxCout <= item.count){
                            model_tmp.isDone = YES;
                        }
                        [DayDayTask_model replaceObjectAtIndex:2 withObject:model_tmp];
                        break;
                    }
                    if(item.type == 5 && [model.title isEqualToString:@"晒收入"]){
                        TaskCell_model* model_tmp = DayDayTask_model[4];
                        model_tmp.count_model = item;
                        if(item.maxCout <= item.count){
                            model_tmp.isDone = YES;
                        }
                        [DayDayTask_model replaceObjectAtIndex:4 withObject:model_tmp];
                        break;
                    }
                    if(item.type == 6 && [model.title isEqualToString:@"参与抽奖"]){
                        TaskCell_model* model_tmp = DayDayTask_model[5];
                        model_tmp.count_model = item;
                        if(item.maxCout <= item.count){
                            model_tmp.isDone = YES;
                        }
                        [DayDayTask_model replaceObjectAtIndex:5 withObject:model_tmp];
                        break;
                    }
                }
            }
            
            DayDayTaskTabelViewConrol.array_model = DayDayTask_model;
            
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
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
