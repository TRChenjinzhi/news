//
//  TabbarViewController.m
//  新闻
//
//  Created by gyh on 15/9/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "TabbarViewController.h"
#import "NavigationController.h"
#import "PhotoViewController.h"
#import "VideoViewController.h"

#import "SCNavTabBarController.h"
#import "TabbarView.h"

#import "TaskViewController.h"
#import "MineViewController.h"
#import "Video_Main_ViewController.h"
#import "TabbarButton.h"
#import "Mine_login_ViewController.h"
#import "Video_ViewController.h"
#import "NewUserTask_model.h"

@interface TabbarViewController ()<UITextViewDelegate>
@property (nonatomic , strong) TabbarView *tabbar;

@end

@implementation TabbarViewController{
    BOOL        m_isReInitTabbar;
    UIView*     m_redPackage_view;
    UIView*   m_redPackage_oldUser;
    UIView*     m_redPackage_newUser_NoShifu;
    UIView*     m_redPackage_newUser_HaveShifu;
    UILabel*    m_textView_placeHolder;
    UITextView* m_textField;
    CGFloat     _transformY;
    CGFloat     _currentKeyboardH;
    
    UIImageView*    m_redPackage_newUser_NoShifu_centerView;
    CGFloat         m_redPackage_newUser_NoShifu_centerView_maxY;
    
    UIView*                 m_deviceInfo_view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabbar];
    
    [self initControl];
    
    [self autoLogin];//用来登陆奖励
    
    
    [self IsShowRedPackage];
//    [self RedPackage_newUser]; //测试弹窗
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleThemeChanged) name:Notice_Theme_Changed object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeSelectIndex:) name:@"频道切换" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ShowReward) name:@"autoLogin-tabbarVC" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(redPackage_oldUser) name:RedPackage_oldUser object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(redPackage_newUser) name:RedPackage_newUser object:nil];
    /* 增加监听（当键盘出现或改变时） */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transformDialog:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BaiShi:) name:@"拜师_TabBarVCL" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDeviceInfo) name:WaringOfNotTheAccount_tips object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)selectIndex:(int)index
{
    [self.tabbar selectIndex:index];
}

-(void)changeSelectIndex:(NSNotification*)noti{
    NSLog(@"频道切换");
    NSNumber* number = noti.object;
    int index =  [number intValue];
//    [self.tabbar ];
//    [self.tabBarController setSelectedIndex:index];
    [self.tabbar selectIndex:index];
}

-(void)initTabbar
{
    IMP_BLOCK_SELF(TabbarViewController);
    TabbarView *tabbar = [[TabbarView alloc]init];
    tabbar.frame = self.tabBar.bounds;
    tabbar.btnSelectBlock = ^(int to){
        block_self.selectedIndex = to;
    };
    [self.tabBar addSubview:tabbar];
    self.tabbar = tabbar;
    
    [self handleThemeChanged];
}

-(void)handleThemeChanged
{
    ThemeManager *defaultManager = [ThemeManager sharedInstance];
    if ([defaultManager.themeName isEqualToString:@"高贵紫"]) {
       [self.tabbar setBackgroundColor:defaultManager.themeColor];
    }else{
        self.tabbar.backgroundColor = [UIColor whiteColor];
    }
    [defaultManager initState];
}

//
-(void)autoLogin{
    if([[Login_info share] GetIsLogined]){
        [InternetHelp AutoLogin];
    }
}

-(void)showDeviceInfo{
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
    title.text          = @"提示";
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
    phoneNumber = [NSString stringWithFormat:@"此设备已和%@****%@账号绑定，继续登录将不会获得金币",[phoneNumber substringToIndex:3],[phoneNumber substringFromIndex:phoneNumber.length-4]];
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
    [know setTitle:@"知道了" forState:UIControlStateNormal];
    [know setTitleColor:RGBA(34, 39, 39, 1) forState:UIControlStateNormal];
    [know setBackgroundColor:RGBA(248, 205, 4, 1)];
    [know.layer setCornerRadius:3.0f];
    [know addTarget:self action:@selector(deviceInfo_action) forControlEvents:UIControlEventTouchUpInside];
    [center_view addSubview:know];
    [know mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tips.mas_bottom).with.offset(kWidth(20));
        make.left.equalTo(center_view.mas_left).with.offset(kWidth(75));
        make.right.equalTo(center_view.mas_right).with.offset(-kWidth(75));
        make.height.mas_offset(kWidth(36));
    }];
}

-(void)deviceInfo_action{
    [m_deviceInfo_view removeFromSuperview];
}

-(void)IsShowRedPackage{
    if(![Login_info share].isLogined){
        NSString* str = [[AppConfig sharedInstance] getRedPackage_first];
        if(str == nil){
            [self showRedPackage_view];
            [[AppConfig sharedInstance] saveRedPackage_first:@"第一次打开app"];
        }
    }
}

-(void)showRedPackage_view{
    UIView* redPack_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    redPack_view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];
    m_redPackage_view = redPack_view;
    
    UIButton* img_btn = [[UIButton alloc] initWithFrame:CGRectMake(50, SCREEN_HEIGHT/2-kWidth(360)/2, SCREEN_WIDTH-50-50, kWidth(360))];
    [img_btn setImage:[UIImage imageNamed:@"bg_01"] forState:UIControlStateNormal];
    [img_btn addTarget:self action:@selector(switchToLoginView) forControlEvents:UIControlEventTouchUpInside];
    [redPack_view addSubview:img_btn];
    [img_btn sizeToFit];
    img_btn.center = redPack_view.center;
    img_btn.backgroundColor = [UIColor yellowColor];
    
    UIButton* close_btn = [[UIButton alloc] initWithFrame:CGRectMake(img_btn.frame.size.width-kWidth(15)-kWidth(10), kWidth(10), kWidth(15), kWidth(15))];
    [close_btn setImage:[UIImage imageNamed:@"ic_delete"] forState:UIControlStateNormal];
    [close_btn addTarget:self action:@selector(closeRedPackage) forControlEvents:UIControlEventTouchUpInside];
    [img_btn addSubview:close_btn];
    
    [self.view addSubview:redPack_view];
}

-(void)switchToLoginView{
    Mine_login_ViewController* vc = [[Mine_login_ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [m_redPackage_view removeFromSuperview];
}

-(void)closeRedPackage{
    [m_redPackage_view removeFromSuperview];
}

- (void)initControl
{
    SCNavTabBarController  *new = [[SCNavTabBarController alloc]init];
    new.naviItems = (NSMutableArray*)self.array_model;
    [self setupChildViewController:new title:@"刷新" imageName:@"ic_menu_index" selectedImage:@"ic_menu_refresh"];

//    VideoViewController *video = [[VideoViewController alloc]init];
//    Video_Main_ViewController* vc = [[Video_Main_ViewController alloc] init];
    Video_ViewController* vc = [[Video_ViewController alloc] init];
    [self setupChildViewController:vc title:@"视频" imageName:@"ic_menu_video_default" selectedImage:@"ic_menu_video_pressed"];
    
//    PhotoViewController *photo = [[PhotoViewController alloc]init];
    TaskViewController* task = [[TaskViewController alloc] init];
    [self setupChildViewController:task title:@"任务" imageName:@"ic_menu_task_default" selectedImage:@"ic_menu_task_pressed"];

//    MeViewController *me = [[MeViewController alloc]init];
    MineViewController* me = [[MineViewController alloc] init];
    [self setupChildViewController:me title:@"我的" imageName:@"ic_menu_home" selectedImage:@"ic_menu_home_pressed"];
    
    
    //iphoneX 底部颜色
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.translucent = NO;

}


-(void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImage:(NSString *)selectedImage
{
    
    //设置控制器属性
//    childVc.title = title;
//    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
//    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //包装一个导航控制器
    NavigationController *nav = [[NavigationController alloc]initWithRootViewController:childVc];
    [self addChildViewController:nav];
    
    UITabBarItem* item = [[UITabBarItem alloc]init];
    item.title  = title;
    item.image = [UIImage imageNamed:imageName];
    item.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.tabbar addTabBarButtonWithItem:item];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    static NSInteger m_index = 0;
    for (int i=0; i<tabBar.items.count; i++) {
        UITabBarItem* tmp = tabBar.items[i];
        
        if(tmp == item){
            if(i != 0){//@"刷新"
                [self.tabbar changeTitle:0 AndNewTitle:@"首页"];
                
            }else{
                if(m_index == 0){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"新闻" object:nil]; //点击刷新按钮，刷新新闻
                }
                [self.tabbar changeTitle:0 AndNewTitle:@"刷新"];
            }
            
            [self.tabbar selectIndex:i];
            m_index = i;
            break;
        }
    }
}

#pragma mark - 通知
-(void)ShowReward{
    NSString* date_now = [[TimeHelper share] getCurrentTime_YYYYMMDD];
    NSString* date = [[AppConfig sharedInstance] getDate];
    [[AppConfig sharedInstance] saveDate:date_now];
    if(![date_now isEqualToString:date]){
        [RewardHelper ShowReward:Task_Login AndSelf:self AndCoin:nil];
    }
}

-(void)redPackage_newUser{
    NSLog(@"RedPackage_newUser");
    NSString* str = [[AppConfig sharedInstance] getRedPackage_money];
    if(str != nil){
        NSLog(@"RedPackage_newUser 已经领取");
        return;
    }
    [[AppConfig sharedInstance] saveRedPackage_money:@"已发新手红包"];
    NSString* mastercode = [Login_info share].userInfo_model.mastercode;
    if([mastercode isEqualToString:@""]){
        //没拜师
        UIView* redPack_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
        [redPack_view addGestureRecognizer:tap];
        redPack_view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];
        m_redPackage_newUser_NoShifu = redPack_view;
        
        UIImageView* img_btn = [UIImageView new];
        [img_btn setImage:[UIImage imageNamed:@"bg_03"]];
        [img_btn sizeToFit];
        img_btn.userInteractionEnabled = YES;
        img_btn.center = redPack_view.center;
        [redPack_view addSubview:img_btn];
        m_redPackage_newUser_NoShifu_centerView = img_btn;
        [img_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(redPack_view.mas_left).with.offset(kWidth(50));
            make.right.equalTo(redPack_view.mas_right).with.offset(-kWidth(50));
            make.centerY.equalTo(redPack_view.mas_centerY);
            make.height.mas_offset(kWidth(360));
        }];
        
        UIButton* close_btn = [UIButton new];
        [close_btn setImage:[UIImage imageNamed:@"ic_delete"] forState:UIControlStateNormal];
        [close_btn addTarget:self action:@selector(closeRedPackage_oldUser) forControlEvents:UIControlEventTouchUpInside];
        [img_btn addSubview:close_btn];
        [close_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(img_btn.mas_top).with.offset(kWidth(10));
            make.right.equalTo(img_btn.mas_right).with.offset(-kWidth(10));
            make.width.and.height.mas_offset(kWidth(15));
        }];
        
        CGFloat topHight = 110;
        UILabel* tips = [UILabel new];
        tips.text = @"您有一个红包待领取";
        tips.textColor = RGBA(253, 222, 177, 1);
        tips.textAlignment = NSTextAlignmentCenter;
        tips.font = kFONT(15);
        [img_btn addSubview:tips];
        [tips mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(img_btn.mas_top).with.offset(kWidth(110));
            make.left.and.right.equalTo(img_btn);
            make.height.mas_offset(kWidth(15));
        }];
        
        UILabel* money_lable = [UILabel new];
        NSString* money_text = [NSString stringWithFormat:@"%@元",[Login_info share].userInfo_model.reg_reward_cash];
        money_lable.text = money_text;
        money_lable.textColor = RGBA(247, 215, 85, 1);
        money_lable.textAlignment = NSTextAlignmentCenter;
        money_lable.font = kFONT(60);
        NSMutableAttributedString* att_str = [[NSMutableAttributedString alloc] initWithString:money_text];
        att_str = [LabelHelper GetMutableAttributedSting_font:att_str AndIndex:money_text.length-1 AndCount:1 AndFontSize:20];
        money_lable.attributedText = att_str;
        [img_btn addSubview:money_lable];
        [money_lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tips.mas_bottom).with.offset(kWidth(14));
            make.left.and.right.equalTo(img_btn);
            make.height.mas_offset(kWidth(60));
        }];
        
        UITextView* textField = [UITextView new];
        m_textField = textField;
        textField.backgroundColor = [[ThemeManager sharedInstance] GetDialogViewColor];
        //    textField.te = @"我来说两句...";
        textField.delegate = self;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.scrollEnabled = NO;
        //    textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.returnKeyType = UIReturnKeyNext;
        textField.keyboardAppearance = UIKeyboardAppearanceDefault;
//        [textField becomeFirstResponder];
        textField.textColor = [[ThemeManager sharedInstance] GetDialogTextColor];
        textField.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:14];
        [textField.layer setCornerRadius:6.0f];
        textField.bounces = YES;
        textField.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        [img_btn addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(money_lable.mas_bottom).with.offset(kWidth(30));
            make.width.mas_offset(kWidth(175));
            make.height.mas_offset(kWidth(35));
            make.centerX.equalTo(img_btn);
        }];
        
        //textView中添加 placeHolder
        m_textView_placeHolder = [UILabel new];
        m_textView_placeHolder.text = @"输入邀请码(选填)";
        m_textView_placeHolder.textColor = RGBA(167, 169, 169, 1);
        m_textView_placeHolder.textAlignment = NSTextAlignmentCenter;
        m_textView_placeHolder.font = kFONT(10);
        [textField addSubview:m_textView_placeHolder];
        [m_textView_placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(textField.mas_left).with.offset(kWidth(13));
            make.right.equalTo(textField.mas_right).with.offset(-kWidth(13));
            make.height.mas_offset(kWidth(10));
            make.top.equalTo(textField.mas_top).with.offset(kWidth(14));
        }];
        
        UIButton* sendBtn = [UIButton new];
        [sendBtn.layer setCornerRadius:6.0f];
//        [sendBtn setImage:[UIImage imageNamed:@"receive_default"] forState:UIControlStateNormal];
        CGSize size = CGSizeMake(kWidth(175), kWidth(35));
        [sendBtn setBackgroundColor:[Color_Image_Helper ImageChangeToColor:[UIImage imageNamed:@"receive_default"] AndNewSize:size]];
        sendBtn.clipsToBounds = YES;
        [sendBtn addTarget:self action:@selector(sendBtn_action) forControlEvents:UIControlEventTouchUpInside];
        [img_btn addSubview:sendBtn];
        [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(textField.mas_bottom).with.offset(kWidth(14));
            make.width.mas_offset(kWidth(175));
            make.height.mas_offset(kWidth(35));
            make.centerX.equalTo(img_btn);
        }];
        
        UILabel* tips_other = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sendBtn.frame)+8, img_btn.frame.size.width, 10)];
        tips_other.text = @"也可以在个人信息界面绑定邀请码";
        tips_other.textColor = RGBA(253, 222, 177, 1);
        tips_other.textAlignment = NSTextAlignmentCenter;;
        tips_other.font = kFONT(10);
        [img_btn addSubview:tips_other];
        [tips_other mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sendBtn.mas_bottom).with.offset(kWidth(8));
            make.left.and.right.equalTo(img_btn);
            make.height.mas_offset(kWidth(10));
        }];
        
//        [self.view addSubview:redPack_view];
        [[UIApplication sharedApplication].keyWindow addSubview:redPack_view];
    }else{
        //已拜师
        UIView* redPack_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        redPack_view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];
        m_redPackage_newUser_HaveShifu = redPack_view;
        
        UIImageView* img_btn = [[UIImageView alloc] initWithFrame:CGRectMake(50, SCREEN_HEIGHT/2-kWidth(360)/2, SCREEN_WIDTH-50-50, kWidth(360))];
        [img_btn setImage:[UIImage imageNamed:@"bg_04"]];
        [img_btn sizeToFit];
        img_btn.userInteractionEnabled = YES;
        img_btn.center = redPack_view.center;
        [redPack_view addSubview:img_btn];
        
        UIButton* close_btn = [[UIButton alloc] initWithFrame:CGRectMake(img_btn.frame.size.width-kWidth(15)-kWidth(10), kWidth(10), kWidth(15), kWidth(15))];
        [close_btn setImage:[UIImage imageNamed:@"ic_delete"] forState:UIControlStateNormal];
        [close_btn addTarget:self action:@selector(closeRedPackage_oldUser) forControlEvents:UIControlEventTouchUpInside];
        [img_btn addSubview:close_btn];
        
        CGFloat topHight = 124;
        UILabel* tips = [[UILabel alloc] initWithFrame:CGRectMake(0, topHight, img_btn.frame.size.width, 15)];
        tips.text = @"恭喜您获得";
        tips.textColor = RGBA(253, 222, 177, 1);
        tips.textAlignment = NSTextAlignmentCenter;
        tips.font = [UIFont systemFontOfSize:15];
        [img_btn addSubview:tips];
        
        UILabel* money_lable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tips.frame)+14, img_btn.frame.size.width, 60)];
        NSString* money_text = [NSString stringWithFormat:@"%@元",[Login_info share].userInfo_model.reg_reward_cash];
        money_lable.text = money_text;
        money_lable.textColor = RGBA(247, 215, 85, 1);
        money_lable.textAlignment = NSTextAlignmentCenter;
        money_lable.font = [UIFont systemFontOfSize:60];
        NSMutableAttributedString* att_str = [[NSMutableAttributedString alloc] initWithString:money_text];
        att_str = [LabelHelper GetMutableAttributedSting_font:att_str AndIndex:money_text.length-1 AndCount:1 AndFontSize:20];
        money_lable.attributedText = att_str;
        [img_btn addSubview:money_lable];
        
        UILabel* tips_two =[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(money_lable.frame)+30, img_btn.frame.size.width, 10)];
        tips_two.text = @"每日完成100金币任务，邀请人会获得奖励";
        tips_two.textColor = RGBA(253, 222, 177, 1);
        tips_two.textAlignment = NSTextAlignmentCenter;
        tips_two.font = [UIFont systemFontOfSize:10];
        [img_btn addSubview:tips_two];
        
        UIButton* sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(money_lable.center.x-175/2,
                                                                       CGRectGetMaxY(tips_two.frame)+20,
                                                                       175, 35)];
        [sendBtn.layer setCornerRadius:12.0f];
        [sendBtn setImage:[UIImage imageNamed:@"receive_default"] forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(closeRedPackage_oldUser) forControlEvents:UIControlEventTouchUpInside];
        
        [img_btn addSubview:sendBtn];
        
        //icon
        UIImageView* icon = [[UIImageView alloc] initWithFrame:CGRectMake(money_lable.center.x-24/2,
                                                                          CGRectGetMaxY(sendBtn.frame)+10,
                                                                          24,
                                                                          24)];
        [icon sd_setImageWithURL:[NSURL URLWithString:[Login_info share].userInfo_model.master_avatar]];
        [icon.layer setCornerRadius:24/2];
        icon.layer.masksToBounds = YES;
        [img_btn addSubview:icon];
        
        CGFloat tips_other_width = [LabelHelper GetLabelWidth:[UIFont systemFontOfSize:10] AndText:@"您的邀请人:"];
        UILabel* tips_other = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(icon.frame)-tips_other_width-6,
                                                                        CGRectGetMinY(icon.frame)+7,
                                                                        tips_other_width,
                                                                        10)];
        tips_other.text = @"您的邀请人:";
        tips_other.textColor = RGBA(255, 255, 255, 1);
        tips_other.textAlignment = NSTextAlignmentRight;;
        tips_other.font = [UIFont systemFontOfSize:10];
        [img_btn addSubview:tips_other];
        
        NSString* str = [Login_info share].userInfo_model.master_name;
        CGFloat master_name_width = [LabelHelper GetLabelWidth:[UIFont systemFontOfSize:10] AndText:str];
        UILabel* master_name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+6,
                                                                        CGRectGetMinY(icon.frame)+7,
                                                                        master_name_width,
                                                                        10)];
        master_name.text = str;
        master_name.textColor = RGBA(247, 215, 85, 1);
        master_name.textAlignment = NSTextAlignmentLeft;;
        master_name.font = [UIFont systemFontOfSize:10];
        [img_btn addSubview:master_name];
        
//        [self.view addSubview:redPack_view];
        [[UIApplication sharedApplication].keyWindow addSubview:redPack_view];
    }
}

-(void)sendBtn_action{
    if(m_textField.text.length > 0){
        [InternetHelp BaiShi_API:m_textField.text Sucess:^(NSDictionary *dic) {
            NSDictionary* dic_tmp = dic[@"list"];
            [Login_info share].userInfo_model.mastercode = dic_tmp[@"master_code"];
            [Login_info share].userInfo_model.master_name = dic_tmp[@"master_name"];
            [Login_info share].userInfo_model.master_avatar = dic_tmp[@"master_avatar"];
            
            [MyMBProgressHUD ShowMessage:@"拜师成功!" ToView:self.view AndTime:1];
            [m_redPackage_newUser_NoShifu removeFromSuperview];
        } Fail:^(NSDictionary *dic) {
            if(dic == nil){
                [MyMBProgressHUD ShowMessage:@"网络错误" ToView:self.view AndTime:1];
            }else{
                NSString* msg = dic[@"msg"];
                [MyMBProgressHUD ShowMessage:msg ToView:self.view AndTime:1];
            }
            [m_redPackage_newUser_NoShifu removeFromSuperview];
        }];
    }
    else{
        [m_redPackage_newUser_NoShifu removeFromSuperview];
    }
}

-(void)closeRedPackage_oldUser{
    [m_redPackage_newUser_NoShifu removeFromSuperview];
    [m_redPackage_newUser_HaveShifu removeFromSuperview];
}

-(void)redPackage_oldUser{
    NSString* str = [[AppConfig sharedInstance] getRedPackage_money];
    if(str != nil){
        return;
    }
    [[AppConfig sharedInstance] saveRedPackage_money:@"已发新手红包"];
    if(YES){
        UIView* redPack_view = [UIView new];
        redPack_view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];
        [self.view addSubview:redPack_view];
        m_redPackage_oldUser = redPack_view;
        [redPack_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        UIButton* img_btn = [UIButton new];
        [img_btn setImage:[UIImage imageNamed:@"bg_02"] forState:UIControlStateNormal];
        [img_btn addTarget:self action:@selector(redPackage_old_action) forControlEvents:UIControlEventTouchUpInside];
        [redPack_view addSubview:img_btn];
        [img_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(redPack_view.mas_left).with.offset(kWidth(50));
            make.right.equalTo(redPack_view.mas_right).with.offset(-kWidth(50));
            make.centerY.equalTo(redPack_view.mas_centerY);
            make.height.mas_offset(kWidth(360));
        }];
        
        UIButton* close_btn = [UIButton new];
        [close_btn setImage:[UIImage imageNamed:@"ic_delete"] forState:UIControlStateNormal];
        [close_btn addTarget:self action:@selector(redPackage_old_action) forControlEvents:UIControlEventTouchUpInside];
        [img_btn addSubview:close_btn];
        [close_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(img_btn.mas_top).with.offset(kWidth(10));
            make.right.equalTo(img_btn.mas_right).with.offset(-kWidth(10));
            make.width.and.height.mas_offset(kWidth(15));
        }];
    }
}

-(void)redPackage_old_action{
    [m_redPackage_oldUser removeFromSuperview];
}

#pragma mark - 点击事情
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    // 触摸对象
//    UITouch *touch = [touches anyObject];
//    // 触摸点
//    CGPoint point = [touch locationInView:m_textField];
//    if(CGRectContainsPoint(m_textField.frame, point)){
//        [m_textField becomeFirstResponder];
//    }else{
//        [self keyboardHide];
//    }
//}

#pragma mark - textField代理
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text]; //得到输入框的内容
    NSInteger MaxLenth = 100;
    
    if (textView)  //判断是否时我们想要限定的那个输入框
    {
        //判断发送按钮 的状态
        if([toBeString length] > 0){
            m_textView_placeHolder.text = @"";
        }else{
            m_textView_placeHolder.text = @"输入邀请码(选填)";
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
-(void)BaiShi:(NSNotification*)noti{
    NSNumber* number = noti.object;
    NSInteger index = [number integerValue];
    if(index == 0){
        //失败
        [MBProgressHUD showError:@"拜师失败"];
    }else{
        //成功
        [MBProgressHUD showSuccess:@"拜师成功"];
        [m_redPackage_newUser_NoShifu removeFromSuperview];
    }
}

#pragma mark - 键盘
//移动UIView(随着键盘移动)
-(void)transformDialog:(NSNotification *)aNSNotification
{
    if(m_redPackage_newUser_NoShifu == nil){
        return ;
    }
    NSLog(@"TabbarVCL移动");
    //键盘最后的frame
    CGRect keyboardFrame = [aNSNotification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    NSLog(@"TabbarVCL看看这个变化的Y值:%f",height);
    //需要移动的距离
    [self setCenterViewFrame:height];
}
-(void)keyboardWillHide:(NSNotification *)aNSNotification{
    if(m_redPackage_newUser_NoShifu == nil){
        return ;
    }
    [self setCenterViewFrame:0];
}

-(void)setCenterViewFrame:(CGFloat)height{
    if(m_redPackage_newUser_NoShifu_centerView_maxY == 0){
        m_redPackage_newUser_NoShifu_centerView_maxY = CGRectGetMaxY(m_redPackage_newUser_NoShifu_centerView.frame);
    }
    // 修改下边距约束
    CGFloat centerView_maxY = SCREEN_HEIGHT-m_redPackage_newUser_NoShifu_centerView_maxY;
    CGFloat height_offset = height - centerView_maxY;
    if(height == 0){
        [m_redPackage_newUser_NoShifu_centerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(m_redPackage_newUser_NoShifu.mas_centerY);
        }];
    }
    else{
        [m_redPackage_newUser_NoShifu_centerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(-height_offset);
        }];
    }
    
    // 更新约束
    [UIView animateWithDuration:0.25f animations:^{
        [m_redPackage_newUser_NoShifu layoutIfNeeded];
    }];
}

//键盘回收
-(void)keyboardHide
{
    [m_textField resignFirstResponder];
}

@end
