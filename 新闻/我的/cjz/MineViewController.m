//
//  MineViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MineViewController.h"
#import "Header_view.h"
#import "Mine_model.h"
#import "Mine_TableViewController.h"
#import "Message_ViewController.h"
#import "NavigationController.h"
#import "Mine_message_model.h"
#import "Mine_userInfo_ViewController.h"
#import "GoldChangeToMoney_ViewController.h"
#import "Money_model.h"
#import "Mine_goldDetail_ViewController.h"
#import "Mine_goldDetail_cell_model.h"
#import "Mine_GetApprentice_model.h"
#import "Mine_GetApprentice_ViewController.h"
#import "Mine_MyCollect_ViewController.h"
#import "Mine_question_ViewController.h"
#import "Mine_ReadingHistory_ViewController.h"
#import "Mine_ShowToFriend_ViewController.h"
#import "Mine_login_ViewController.h"
#import "Mine_setting_ViewController.h"
#import "Mine_inviteApprence_ViewController.h"
#import "NewUserTask_model.h"
#import "Mine_choujiang_ViewController.h"

@interface MineViewController ()<LoginInterfaceDelegate,BannerViewDelegate>

@property (nonatomic,strong)Header_view* headerView;

@property (nonatomic,strong)UIScrollView* scrollView;

@property (nonatomic,strong)Mine_TableViewController* m_tableViewController;

@property (nonatomic,strong)NSMutableArray* array_model;
@property (nonatomic,strong)NSMutableArray* array_message_model;//消息的数组
@property (nonatomic,strong)NSMutableArray* array_apprentice_model;//徒弟信息


@property (nonatomic)BOOL IsLogined;


@end

@implementation MineViewController{
    UIView* ToastMessage_view;
    Mine_userInfo_model*    userInfo_model;
    Money_model*            m_money_model;
    
    NSMutableArray*         array_array_cellModel;
    NSArray*                sectionArray;
    
    UITapGestureRecognizer* m_tap_gold;
    UITapGestureRecognizer* m_tap_package;
    UITapGestureRecognizer* m_tap_apprentice;
    UITapGestureRecognizer* m_tap_guanggao;
    
    Header_view*            m_headerView;
    BadgeButton*            m_messageButton;
    
    UIView*                 m_deviceInfo_view;
    
    BOOL                    m_banner_isLoaded;
    UIView*                 m_tabelview_view;
}

-(NSMutableArray *)array_model{
    if(!_array_model){
        _array_model = [[NSMutableArray alloc] initWithCapacity:6];
    }
    return _array_model;
}
-(NSMutableArray *)array_message_model{
    if(!_array_message_model){
        _array_message_model = [[NSMutableArray alloc] initWithCapacity:6];
    }
    return _array_message_model;
}
-(NSMutableArray *)array_apprentice_model{
    if(!_array_apprentice_model){
        _array_apprentice_model = [[NSMutableArray alloc] initWithCapacity:6];
    }
    return _array_apprentice_model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor redColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    [self InitView];
    
    [self autoLogin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden= YES;
    NSLog(@"我的 viewWillAppear");
    
    if([Login_info share].isLogined){ // 更新用户信息
        [InternetHelp AutoLogin];
        [self getMessageData];
        if(m_banner_isLoaded == NO){ //如果没有加载好，每次进入 我的 界面时 就会重新加载一次
            [self loadBanner];
        }
    }
    
    //监听登陆状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginIn) name:@"登陆" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoLogin) name:@"用户信息更新" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goldChangeToMoney:) name:@"Mine_cell_click" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"登陆" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"用户信息更新" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Mine_cell_click" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


-(void)InitView{
    self.navigationController.navigationBar.hidden = YES;
    
    [self initScrollView];
    [self initHeaderView];
    [self initTableView];
}

-(void)initScrollView{
    NSInteger tabbarHight = self.tabBarController.tabBar.frame.size.height;

    UIView* statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, StaTusHight)];
    statusView.backgroundColor = [Color_Image_Helper ImageChangeToColor:[UIImage imageNamed:@"user_bg"] AndNewSize:CGSizeMake(SCREEN_WIDTH, StaTusHight*2)];//由于图片下方有圆弧白色区域 所以加大高度，不显示白色区域
    [self.view addSubview:statusView];
    
    UIScrollView* scrlView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, StaTusHight, SCREEN_WIDTH, SCREEN_HEIGHT-StaTusHight-tabbarHight)];
    scrlView.contentSize = CGSizeMake(SCREEN_WIDTH, 698);
    scrlView.bounces = NO;
    scrlView.userInteractionEnabled = YES;
    scrlView.showsVerticalScrollIndicator = NO;
    scrlView.showsHorizontalScrollIndicator = NO;
    self.scrollView = scrlView;
    [self.view addSubview:self.scrollView];
}

-(void)initHeaderView{
    Header_view* headerView = [[Header_view alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 314-70-10)];
//    [self GetMoney];
    headerView.number_gold = userInfo_model.gold;
    headerView.number_package = userInfo_model.package;
    headerView.number_apprentice = userInfo_model.apprentice;
    headerView.IsLognin = NO;
    headerView.userInteractionEnabled = YES;
    m_headerView = headerView;
    
    
    [m_headerView.m_tap_gold addTarget:self action:@selector(GoToGold_vc)];
    [m_headerView.m_tap_moneyPackage addTarget:self action:@selector(GoToPackage_vc)];
    [m_headerView.m_tap_apprentice addTarget:self action:@selector(GoToApprentice_vc)];
//    [m_headerView.m_guanggao_clickView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GoToGuanggao)]];
    [m_headerView.m_tap_guanggao addTarget:self action:@selector(GoToGuanggao)];
    
//    userInfo_model = [[Mine_userInfo_model alloc] init];
//    userInfo_model.icon = @"touxiang";
//    userInfo_model.name = @"爱我就请打";
//    userInfo_model.sex = @"男";
//
//    headerView.userInfo_model = userInfo_model;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GoToLogin:)];
    [headerView.loginToDetailLogin addGestureRecognizer:tap];
    
    [headerView.messageButton addTarget:self action:@selector(GoToMessage) forControlEvents:UIControlEventTouchUpInside];
    self.headerView = headerView;
    m_messageButton = headerView.messageButton;
    [self.scrollView addSubview:headerView];
    
    //加载banner
    [self loadBanner];
}

-(void)loadBanner{
    [InternetHelp getBanner_Sucess:^(NSDictionary *dic) {
        NSArray* array = dic[@"list"];
        [Banner_model arrayToBannerArray:array];
        [m_headerView bannerView_bengain];
        m_headerView.bannerView.delegate = self;
        m_banner_isLoaded = YES;
        [self UILayout_refresh];
    } Fail:^(NSDictionary *dic) {
        if(dic != nil){
            NSNumber* code = dic[@"code"];
            if([code integerValue] == Banner_off){
                m_banner_isLoaded = YES;
            }
        }
    }];
}

//添加bannner 重新布局
-(void)UILayout_refresh{
    m_headerView.frame      = CGRectMake(0, 0, SCREEN_WIDTH, 314);
    m_tabelview_view.frame  = CGRectMake(0, CGRectGetMaxY(self.headerView.frame)-StaTusHight, SCREEN_WIDTH, 60*self.array_model.count);
    
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, m_headerView.frame.size.height+60*self.array_model.count)];
}

-(void)initTableView{
    [self GetData];
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame)-StaTusHight, SCREEN_WIDTH, 60*self.array_model.count)];
    m_tabelview_view = view;
    
    Mine_TableViewController* tableViewConrl = [[Mine_TableViewController alloc] init];
    tableViewConrl.model = self.array_model;
    self.m_tableViewController = tableViewConrl;
    [view addSubview:self.m_tableViewController.tableView];
    
    [self.scrollView addSubview:view];
    
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, m_headerView.frame.size.height+60*self.array_model.count)];
}

-(void)autoLogin{
    Login_info* loginInfo = [[Login_info share] GetLoginInfo];
    if(loginInfo.isLogined){
        Mine_userInfo_model* model = [[Mine_userInfo_model alloc] init];
        if ([[DefauteNameHelper getDefuateName] isEqualToString:loginInfo.userInfo_model.name]) {
            if([loginInfo.userInfo_model.wechat_binding integerValue] == 1){ //当微信绑定了，账号昵称为默认时，使用微信昵称
                if(loginInfo.userInfo_model.wechat_nickname.length > 0){
                    loginInfo.userInfo_model.name = loginInfo.userInfo_model.wechat_nickname;
                }
            }
        }
        model.name = loginInfo.userInfo_model.name;
        if([loginInfo.userInfo_model.sex integerValue] == 1){
            model.sex = @"男";
        }else{
            model.sex = @"女";
        }
        model.name = loginInfo.userInfo_model.name;
        if(loginInfo.userInfo_model.avatar.length <= 0){ //如果 用户没有头像，但微信绑定了，就使用微信头像。否则都用用户自己头像
            if([loginInfo.userMoney_model.binding_wechat integerValue] == 1){
                model.icon = [Login_info share].userInfo_model.wechat_icon;
            }
            else{
                model.icon = loginInfo.userInfo_model.avatar;
            }
        }
        else{
            model.icon = loginInfo.userInfo_model.avatar;
        }
        model.gold = [loginInfo.userMoney_model.coin integerValue];
        model.package = [loginInfo.userMoney_model.cash floatValue];
        model.apprentice = [loginInfo.userInfo_model.appren_count integerValue];
        model.IsLogin = YES;
        
        //【我的】完成首次提现后，我要提现后面的红色文字改成“提现至微信、支付宝”
        if([[Login_info share].userMoney_model.is_wechat_withdraw integerValue] == 1){
            Mine_model* model = self.array_model[0];
            model.subTitle = @"提现至微信、支付宝";
        }
        else{
            Mine_model* model = self.array_model[0];
            model.subTitle = @"1元提现至微信";
        }
        self.m_tableViewController.model = self.array_model;
        
        [self refreshData:model];
    }
}

-(void)refreshData:(Mine_userInfo_model *)model{
    _IsLogined = YES;
    
    Login_info* loginInfo = [Login_info share];
    if(loginInfo.userInfo_model.avatar.length <= 0){ //如果 用户没有头像，但微信绑定了，就使用微信头像。否则都用用户自己头像
        if([loginInfo.userMoney_model.binding_wechat integerValue] == 1){
            model.icon = [Login_info share].userInfo_model.wechat_icon;
        }
        else{
            model.icon = @"";
        }
    }
    else{
        model.icon = loginInfo.userInfo_model.avatar;
    }
    
    self.headerView.userInfo_model = model;
    userInfo_model = model;
    
    //获取新手任务信息
    [InternetHelp GetNewUserTaskCount_Sucess:^(NSDictionary *dic) {
        [TaskCountHelper share].task_newUser_name_array = [NewUserTask_model dicToArray:dic[@"list"]];
    } Fail:^(NSDictionary *dic) {
        
    }];
}

#pragma mark - 协议方法
-(void)makeTureLogin:(Mine_userInfo_model *)model{
    [self refreshData:model];
}

-(void)BannerViewSelectedAt:(NSInteger)index{
    Banner_model* model = [Banner_model share].array[index];
    if([model.name isEqualToString:Banner_shoutu]){
        if([Login_info share].isLogined){
            Mine_inviteApprence_ViewController* vc = [Mine_inviteApprence_ViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            [MyMBProgressHUD ShowMessage:@"未登录" ToView:self.view AndTime:1.0f];
        }
    }
    else{
        Web_ViewController* vc = [Web_ViewController new];
        vc.naviTitle = model.name;
        vc.url = model.url;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 广播监听
-(void)LoginIn{
    NSLog(@"进入登陆界面1");
    //登陆注册界面
    Mine_login_ViewController* vc = [[Mine_login_ViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
//    _IsLogined = YES;
//    self.headerView.IsLognin = YES;
//    self.headerView.number_gold = 20;
//    self.headerView.number_package = 2000.0;
//    self.headerView.number_apprentice = 2;
}



#pragma mark - 按钮方法
-(void)GoToMessage{
    NSLog(@"消息界面");
//    [self.navigationController addChildViewController:[[Message_ViewController alloc] init]];
        Message_ViewController* message_vc =[[Message_ViewController alloc] init];
//        [self GetMessageData];
        message_vc.message_arrayModel = self.array_message_model;
        [self.navigationController pushViewController:message_vc animated:YES];

}

-(void)GoToLogin:(UITapGestureRecognizer*)tap{
    NSLog(@"account 详情界面");
    Mine_userInfo_ViewController* userInfo_vc = [[Mine_userInfo_ViewController alloc] init];
    userInfo_vc.userInfo_model = userInfo_model;
    [userInfo_vc.outLogin addTarget:self action:@selector(userOutLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController pushViewController:userInfo_vc animated:YES];
}

-(void)GoToGold_vc{
    NSLog(@"GoToGold_vc");
    
    Mine_goldDetail_ViewController* vc = [[Mine_goldDetail_ViewController alloc] init];
    vc.selectIndex = 0;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)GoToPackage_vc{
    NSLog(@"GoToPackage_vc");

    Mine_goldDetail_ViewController* vc = [[Mine_goldDetail_ViewController alloc] init];
    vc.selectIndex = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)GoToApprentice_vc{
    NSLog(@"GoToApprentice_vc");
    Mine_GetApprentice_ViewController* vc = [[Mine_GetApprentice_ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)GoToGuanggao{
    NSLog(@"GoToGuanggao");
    if(![Login_info share].isLogined){
        Mine_login_ViewController* vc = [[Mine_login_ViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    Mine_inviteApprence_ViewController* vc = [[Mine_inviteApprence_ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)goldChangeToMoney:(NSNotification*)noti{
    Mine_model* model = noti.object;
    if([@"我要提现" isEqualToString:model.title]){
        GoldChangeToMoney_ViewController* vc = [[GoldChangeToMoney_ViewController alloc] init];
        Mine_changeToMoney_model* model = [[Mine_changeToMoney_model alloc] init];
        model.total_cash = [[Login_info share].userMoney_model.total_cashed floatValue];
        model.total_income =  [[Login_info share].userMoney_model.total_income floatValue];
        model.money = [[Login_info share].userMoney_model.cash floatValue];
//        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if([@"邀请收徒" isEqualToString:model.title]){
        if(![Login_info share].isLogined){
            Mine_login_ViewController* vc = [[Mine_login_ViewController alloc] init];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
//        [self getApprenticeData];
        Mine_inviteApprence_ViewController* vc = [[Mine_inviteApprence_ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if([@"我的收藏" isEqualToString:model.title]){
        
        Mine_MyCollect_ViewController* vc = [[Mine_MyCollect_ViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    if([@"阅读历史" isEqualToString:model.title]){
        Mine_ReadingHistory_ViewController* vc = [[Mine_ReadingHistory_ViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    if([@"常见问题" isEqualToString:model.title]){
        Mine_question_ViewController* vc = [[Mine_question_ViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    if([@"系统设置" isEqualToString:model.title]){
        Mine_setting_ViewController* vc = [[Mine_setting_ViewController alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    if([@"联系我们" isEqualToString:model.title]){
        NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", @"689444964",@"159bb595195c65467dc5f9028b9fcef105ee080ee92178d3b1276e987047fa98"];
        NSURL *url = [NSURL URLWithString:urlStr];
        if([[UIApplication sharedApplication] canOpenURL:url]){
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }else{
            NSLog(@"不能跳转");
            //提示信息
            [MyMBProgressHUD ShowMessage:@"无法跳转到QQ" ToView:self.view AndTime:1];
        }
    }
}

#pragma mark - 获取数据
-(void)GetData{
    NSArray* img_str = @[@"ic_list_take",@"ic_list_invite",@"ic_list_collect",@"ic_list_history",@"ic_list_question",@"ic_list_system",@"ic_list_contact"];
    NSArray* lable_str = @[@"我要提现"  ,@"邀请收徒"                  ,@"我的收藏"  ,@"阅读历史",@"常见问题"        ,@"系统设置",@"联系我们"];
    NSArray* sub_str = @[@"1元提现至微信",@"现金奖励加提成，收益暴涨"     ,@""        ,@""       ,@"30s了解橙子快报怎么玩",@""       ,@""];
    for(int i=0;i<img_str.count;i++){
        Mine_model* model = [[Mine_model alloc] init];
        model.title_img = img_str[i];
        model.title = lable_str[i];
        model.subTitle = sub_str[i];
        
        [self.array_model addObject:model];
    }
}

-(void)GetMessageData{
//    NSArray* icon = @[@"ic_reminder",@"ic_post"];
//    NSArray* title = @[@"收入提醒",@"收入公告"];
//    NSArray* subTitle = @[@"您昨日收入金币120个，请继续加油哦!",@"恭喜您又收到徒弟一枚~"];
//    NSArray* time = @[@"2017-12-28 07:00:02",@"2017-12-28 07:00:02"];
//    for(int i=0;i<icon.count;i++){
//        Mine_message_model* model = [[Mine_message_model alloc] init];
//        model.icon = icon[i];
//        model.title = title[i];
//        model.subTitle = subTitle[i];
//        model.time = time[i];
//        
//        [self.array_message_model addObject:model];
//    }
}

-(void)userOutLogin{
    [self showOutLoginAgain];
}

-(void)showOutLoginAgain{
    if(m_deviceInfo_view != nil){
        [[UIApplication sharedApplication].keyWindow addSubview:m_deviceInfo_view];
        return;
    }
    m_deviceInfo_view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    m_deviceInfo_view.backgroundColor = RGBA(0, 0, 0, 0.6);
    [[UIApplication sharedApplication].keyWindow addSubview:m_deviceInfo_view];
    
    UIView* center_view = [UIView new];
    center_view.backgroundColor = RGBA(255, 255, 255, 1);
    [center_view.layer setCornerRadius:3.0f];
    [m_deviceInfo_view addSubview:center_view];
    [center_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(m_deviceInfo_view.mas_left).with.offset(kWidth(45));
        make.right.equalTo(m_deviceInfo_view.mas_right).with.offset(-kWidth(45));
        make.height.mas_offset(kWidth(166));
        make.centerY.equalTo(m_deviceInfo_view.mas_centerY);
    }];
    
    UILabel* title = [UILabel new];
    title.text          = @"注销登录";
    title.textColor     = RGBA(122, 125, 125, 1);
    title.font          = kFONT(14);
    title.textAlignment = NSTextAlignmentCenter;
    [center_view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(center_view.mas_left);
        make.right.equalTo(center_view.mas_right);
        make.top.equalTo(center_view.mas_top);
        make.height.mas_offset(kWidth(56));
    }];
    
    UILabel* tips = [UILabel new];
    NSString* phoneNumber = [Login_info share].userInfo_model.device_first_tel;
    phoneNumber = [NSString stringWithFormat:@"注销后将无法继续愉快的赚钱啦~\n确定注销?"];
    tips.text          = phoneNumber;
    tips.textColor     = RGBA(34, 39, 39, 1);
    tips.font          = kFONT(14);
    tips.textAlignment = NSTextAlignmentLeft;
    tips.numberOfLines = 0;
    
    NSMutableAttributedString* str_att = [[NSMutableAttributedString alloc] initWithString:phoneNumber];
    str_att = [LabelHelper GetMutableAttributedSting_lineSpaceing:str_att AndSpaceing:5.0f];
    tips.attributedText = str_att;
    [center_view addSubview:tips];
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(center_view.mas_left).with.offset(kWidth(14));
        make.right.equalTo(center_view.mas_right).with.offset(-kWidth(14));
        make.top.equalTo(title.mas_bottom);
    }];
    
    UIButton* know = [UIButton new];
    [know setTitle:@"注销" forState:UIControlStateNormal];
    [know setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
    [know setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    [know.titleLabel setFont:kFONT(16)];
    [know.layer setCornerRadius:kWidth(36)/2];
    know.layer.masksToBounds = YES;
    [know addTarget:self action:@selector(deviceInfo_action_true) forControlEvents:UIControlEventTouchUpInside];
    [center_view addSubview:know];
    [know mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tips.mas_bottom).with.offset(kWidth(20));
        make.right.equalTo(center_view.mas_right).with.offset(-kWidth(16));
        make.height.mas_offset(kWidth(36));
        make.width.mas_offset(kWidth(100));
    }];
    
    UIButton* cancel = [UIButton new];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:RGBA(167, 169, 169, 1) forState:UIControlStateNormal];
    [cancel setBackgroundColor:RGBA(242, 242, 242, 1)];
    [know.titleLabel setFont:kFONT(16)];
    [cancel.layer setCornerRadius:kWidth(36)/2];
    cancel.layer.masksToBounds = YES;
    [cancel addTarget:self action:@selector(deviceInfo_action_cancel) forControlEvents:UIControlEventTouchUpInside];
    [center_view addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tips.mas_bottom).with.offset(kWidth(20));
        make.left.equalTo(center_view.mas_left).with.offset(kWidth(16));
        make.height.mas_offset(kWidth(36));
        make.width.mas_offset(kWidth(100));
    }];
}

-(void)deviceInfo_action_true{
    [m_deviceInfo_view removeFromSuperview];
    //新手任务信息
    [[TaskCountHelper share] initData];
    [[AppConfig sharedInstance] clearNewUserTaskInfo];
    [[AppConfig sharedInstance] saveShowWinForFirstDone_newUserTask:NO];
    [[AppConfig sharedInstance] saveGuideOfNewUser:NO];
    
    //message信息
    [[AppConfig sharedInstance] saveMessageDate:@""];
    [[MyDataBase shareManager] clearTable_Message];
    
    //新手红包
    [[AppConfig sharedInstance] saveRedPackage:@" "];
    [[AppConfig sharedInstance] saveRedPackage_money:@" "];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.headerView.IsLognin = NO;
    _IsLogined = NO;
    
    //去除登陆信息
    [[AppConfig sharedInstance] clearUserInfo];
    Login_info* loginInfo = [Login_info share];
    loginInfo.isLogined = NO;//变更登陆状态
    loginInfo.userInfo_model = nil;
    loginInfo.userMoney_model = nil;
    loginInfo.shareInfo_model = nil;
    userInfo_model = [[Mine_userInfo_model alloc]init];
    self.headerView.number_gold = userInfo_model.gold;
    self.headerView.number_package = userInfo_model.package;
    self.headerView.number_apprentice = userInfo_model.apprentice;
    self.headerView.IsLognin = NO;
}
-(void)deviceInfo_action_cancel{
    [m_deviceInfo_view removeFromSuperview];
}

-(void)getGoldDetailData{
    
//    NSMutableArray* array_model = [[NSMutableArray alloc] init];
//    NSArray* title = @[@"阅读文章奖励",@"阅读文章奖励",@"每日签到奖励",@"金币自动兑换"];
//    NSArray* time = @[@"12-25 11:10",@"12-25 11:10",@"12-25 11:10",@"12-25 11:10"];
//    NSArray* count = [NSArray arrayWithObjects:@20,@20,@90,@100, nil];
//    for(int i=0;i<title.count;i++){
//        Mine_goldDetail_cell_model* model = [[Mine_goldDetail_cell_model alloc] init];
//        model.title = title[i];
//        model.time = time[i];
//        NSNumber* number = count[i];
//        model.count = [number integerValue];
//
//        [array_model addObject:model];
//    }
//
//    array_array_cellModel = [NSMutableArray arrayWithObjects:array_model,array_model,array_model, nil];
//    sectionArray = [NSArray arrayWithObjects:@"今天",@"12-24",@"12-24",@"12-24", nil];
}

-(void)getApprenticeData{
//    NSMutableArray* array_model = [[NSMutableArray alloc] init];
//    NSArray* title = @[@"流放之路",@"英雄联盟",@"Dota",@"冲顶都会"];
//    NSArray* time = @[@"12-26 22:19:36",@"12-26 22:19:36",@"12-26 22:19:36",@"12-26 22:19:36"];
//    NSArray* state = @[@"收徒成功",@"收徒成功",@"收徒成功",@"收徒成功"];
//    NSArray* imgUrl = @[@"touxiang",@"touxiang",@"touxiang",@"touxiang"];
//    for(int i=0;i<title.count;i++){
//        Mine_GetApprentice_model* model = [[Mine_GetApprentice_model alloc] init];
//        model.title = title[i];
//        model.time = time[i];
//        model.state = state[i];
//        model.imgUrl = imgUrl[i];
//
//        [array_model addObject:model];
//    }
//
//    self.array_apprentice_model = array_model;
}
-(void)getMessageData{
    //http://39.104.13.61/api/getMesRecord?json={"user_id":"814B08C64ADD12284CA82BA39384B177","page":"0","size":"10"}
    NSString* time = [[AppConfig sharedInstance] getMessageDate];
    if(time == nil){
        time = @"0";
    }
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/getMesRecord"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[[Login_info share]GetUserInfo].user_id]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"time",time]];
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
//    IMP_BLOCK_SELF(MineViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if(error){
                NSLog(@"网络获取失败");
                //发送失败消息
//                [[AlertHelper Share] ShowMe:self And:2.0 And:@"网络失败"];
                return ;
            }
            
            NSLog(@"从服务器获取到数据");
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* code = dict[@"code"];
            if([code integerValue] != 200){
                return;
            }
            NSArray* array_model = [Mine_message_model dicToModelArray:dict];
            
            if(array_model.count == 0){
                [m_messageButton setCount:array_model.count];
            }else{
                [m_messageButton setCount:array_model.count];
            }
            
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
