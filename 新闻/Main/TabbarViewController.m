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

@interface TabbarViewController ()<UITextViewDelegate>
@property (nonatomic , strong) TabbarView *tabbar;

@end

@implementation TabbarViewController{
    BOOL        m_isReInitTabbar;
    UIView*     m_redPackage_view;
    UIButton*   m_redPackage_oldUser;
    UIView*     m_redPackage_newUser_NoShifu;
    UIView*     m_redPackage_newUser_HaveShifu;
    UILabel*    m_textView_placeHolder;
    UITextView* m_textField;
    CGFloat     _transformY;
    CGFloat     _currentKeyboardH;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTabbar];
    
    [self initControl];
    
    [self autoLogin];//用来登陆奖励
    
    [self IsShowRedPackage];
//    [self RedPackage_newUser]; //测试弹窗
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleThemeChanged) name:Notice_Theme_Changed object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeSelectIndex:) name:@"频道切换" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ShowReward) name:@"autoLogin-tabbarVC" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RedPackage_newUser) name:@"登陆_TabBarVCL_红包活动_老用户" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RedPackage_oldUser) name:@"登陆_TabBarVCL_红包活动_新用户" object:nil];
    /* 增加监听（当键盘出现或改变时） */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transformDialog:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BaiShi:) name:@"拜师_TabBarVCL" object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
//    for (UIView *child in self.tabBar.subviews) {
//        if([child isKindOfClass:[UIControl class]])
//        {
//            [child removeFromSuperview];
//        }
//    }
}

- (void)selectIndex:(int)index
{
    [self.tabbar selectIndex:index];
}

-(void)changeSelectIndex:(NSNotification*)noti{
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
        [InternetHelp GetMaxTaskCount];
    }
}

-(void)IsShowRedPackage{
    if(![Login_info share].isLogined){
        NSString* str = [[AppConfig sharedInstance] getRedPackage];
        if(str == nil){
            [self showRedPackage_view];
            [[AppConfig sharedInstance] saveRedPackage:@"第一次打开红包"];
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
    Video_Main_ViewController* vc = [[Video_Main_ViewController alloc] init];
    [self setupChildViewController:vc title:@"视频" imageName:@"ic_menu_video_default" selectedImage:@"ic_menu_video_pressed"];
    
//    PhotoViewController *photo = [[PhotoViewController alloc]init];
    TaskViewController* task = [[TaskViewController alloc] init];
    [self setupChildViewController:task title:@"任务" imageName:@"ic_menu_task_default" selectedImage:@"ic_menu_task_pressed"];

//    MeViewController *me = [[MeViewController alloc]init];
    MineViewController* me = [[MineViewController alloc] init];
    [self setupChildViewController:me title:@"我的" imageName:@"ic_menu_home" selectedImage:@"ic_menu_home_pressed"];

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
        [RewardHelper ShowReward:9 AndSelf:self];
    }
}

-(void)RedPackage_newUser{
    NSString* mastercode = [Login_info share].userInfo_model.mastercode;
    if([mastercode isEqualToString:@""]){
        //没拜师
        UIView* redPack_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
        [redPack_view addGestureRecognizer:tap];
        redPack_view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];
        m_redPackage_newUser_NoShifu = redPack_view;
        
        UIImageView* img_btn = [[UIImageView alloc] initWithFrame:CGRectMake(50, SCREEN_HEIGHT/2-kWidth(360)/2, SCREEN_WIDTH-50-50, kWidth(360))];
        [img_btn setImage:[UIImage imageNamed:@"bg_03"]];
        [img_btn sizeToFit];
        img_btn.userInteractionEnabled = YES;
        img_btn.center = redPack_view.center;
        [redPack_view addSubview:img_btn];
        
        UIButton* close_btn = [[UIButton alloc] initWithFrame:CGRectMake(img_btn.frame.size.width-kWidth(15)-kWidth(10), kWidth(10), kWidth(15), kWidth(15))];
        [close_btn setImage:[UIImage imageNamed:@"ic_delete"] forState:UIControlStateNormal];
        [close_btn addTarget:self action:@selector(closeRedPackage_oldUser) forControlEvents:UIControlEventTouchUpInside];
        [img_btn addSubview:close_btn];
        
        CGFloat topHight = 110;
        UILabel* tips = [[UILabel alloc] initWithFrame:CGRectMake(0, topHight, img_btn.frame.size.width, 15)];
        tips.text = @"您有一个红包待领取";
        tips.textColor = RGBA(253, 222, 177, 1);
        tips.textAlignment = NSTextAlignmentCenter;
        tips.font = kFONT(15);
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
        
        UITextView* textField = [[UITextView alloc] initWithFrame:CGRectMake(money_lable.center.x-175/2, CGRectGetMaxY(money_lable.frame)+30, 175, 35)];
        m_textField = textField;
        textField.backgroundColor = [[ThemeManager sharedInstance] GetDialogViewColor];
        //    textField.te = @"我来说两句...";
        textField.delegate = self;
        textField.textAlignment = NSTextAlignmentLeft;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        //    textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.returnKeyType = UIReturnKeyNext;
        textField.keyboardAppearance = UIKeyboardAppearanceDefault;
//        [textField becomeFirstResponder];
        textField.textColor = [[ThemeManager sharedInstance] GetDialogTextColor];
        textField.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:14];
        [textField.layer setCornerRadius:10.0f];
        [img_btn addSubview:textField];
        
        //textView中添加 placeHolder
        m_textView_placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(5, 35/2-10/2, 100, 10)];
        m_textView_placeHolder.text = @"输入邀请码(选填)";
        m_textView_placeHolder.textColor = RGBA(167, 169, 169, 1);
        m_textView_placeHolder.textAlignment = NSTextAlignmentLeft;
        m_textView_placeHolder.font = kFONT(10);
        [textField addSubview:m_textView_placeHolder];
        
        UIButton* sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(money_lable.center.x-175/2,
                                                                       CGRectGetMaxY(textField.frame)+14,
                                                                       175, 35)];
        [sendBtn.layer setCornerRadius:12.0f];
        [sendBtn setImage:[UIImage imageNamed:@"receive_default"] forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(sendBtn_action) forControlEvents:UIControlEventTouchUpInside];
        
        [img_btn addSubview:sendBtn];
        
        UILabel* tips_other = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sendBtn.frame)+8, img_btn.frame.size.width, 10)];
        tips_other.text = @"也可以在个人信息界面绑定邀请码";
        tips_other.textColor = RGBA(253, 222, 177, 1);
        tips_other.textAlignment = NSTextAlignmentCenter;;
        tips_other.font = kFONT(10);
        [img_btn addSubview:tips_other];
        
        [self.view addSubview:redPack_view];
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
        
        [self.view addSubview:redPack_view];
    }
}

-(void)sendBtn_action{
    NSString* text = m_textField.text;
    if(![NullNilHelper dx_isNullOrNilWithObject:text]){
        [InternetHelp BaiShi_API:m_textField.text Sucess:^(NSDictionary *dic) {
            NSDictionary* dic_tmp = dic[@"list"];
            [Login_info share].userInfo_model.mastercode = dic_tmp[@"master_code"];
            [Login_info share].userInfo_model.master_name = dic_tmp[@"master_name"];
            [Login_info share].userInfo_model.master_avatar = dic_tmp[@"master_avatar"];
            
            [MyMBProgressHUD ShowMessage:@"拜师成功" ToView:self.view AndTime:1];
        } Fail:^(NSDictionary *dic) {
            if(dic == nil){
                [MyMBProgressHUD ShowMessage:@"网络错误" ToView:self.view AndTime:1];
            }else{
                NSString* msg = dic[@"msg"];
                [MyMBProgressHUD ShowMessage:msg ToView:self.view AndTime:1];
            }
        }];
    }
}

-(void)closeRedPackage_oldUser{
    [m_redPackage_newUser_NoShifu removeFromSuperview];
    [m_redPackage_newUser_HaveShifu removeFromSuperview];
}

-(void)RedPackage_oldUser{
    NSString* str = [[AppConfig sharedInstance] getUserId:[Login_info share].userInfo_model.user_id];
    if(str == nil){
        UIButton* img_btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [img_btn setImage:[UIImage imageNamed:@"bg_02"] forState:UIControlStateNormal];
        [img_btn addTarget:self action:@selector(switchToLoginView) forControlEvents:UIControlEventTouchUpInside];
        img_btn.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];
        m_redPackage_oldUser = img_btn;
        [self.view addSubview:img_btn];
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
    NSInteger MaxLenth = 6;
    
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

//移动UIView(随着键盘移动)
-(void)transformDialog:(NSNotification *)aNSNotification
{
    NSLog(@"移动");
    //键盘最后的frame
    CGRect keyboardFrame = [aNSNotification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    NSLog(@"看看这个变化的Y值:%f",height);
    //需要移动的距离
    if (height > 0) {
        _transformY = height-_currentKeyboardH;
        _currentKeyboardH = height;
        //移动
        [UIView animateWithDuration:0.25f animations:^{
            CGRect frame = m_redPackage_newUser_NoShifu.frame;
            frame.origin.y -= _transformY;
            m_redPackage_newUser_NoShifu.frame = frame;
        }];
    }
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
-(void)keyboardWillHide:(NSNotification *)aNSNotification{
    /* 输入框下移 */
    [UIView animateWithDuration:0.25f animations:^ {
        
        CGRect frame = m_redPackage_newUser_NoShifu.frame;
        frame.origin.y = 0;
        m_redPackage_newUser_NoShifu.frame = frame;
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

@end
