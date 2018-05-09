//
//  Mine_login_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_login_ViewController.h"
#import "Mine_userInfo_model.h"
#import "Agreement_ViewController.h"
#import "Mine_login_wechatBlindTel_ViewController.h"

#define TimeCount 60
@interface Mine_login_ViewController ()<IdentifyingCode_delegete,Mine_login_wechatBlindTel_To_Mine_Login_VCL_protocol>

@end

@implementation Mine_login_ViewController{
    NSInteger       m_timer_count;
    NSTimer*        m_timer;
    UITextField*    m_password_textfeild;
    UITextField*    m_phoneNumber_textfeild;
    BOOL            m_btn_IsClicked;
    UIButton*       m_login_btn;
    CGFloat         m_login_btn_maxY;
    UIView*         m_line_two;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [IdentifyingCode ShareInstance].delegate = self;//验证码代理
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /* 增加监听（当键盘出现或改变时） */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transformDialog:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Login_wechat_sucess) name:@"LoginVCL微信登陆成功" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Login_wechat_notBlind:) name:@"LoginVCL微信未绑定" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if([Login_info share].isLogined){
        Login_userMoney* userMoney = [[Login_info share] GetUserMoney];
        Login_userInfo* userInfo = [[Login_info share] GetUserInfo];
        
        Mine_userInfo_model* model = [[Mine_userInfo_model alloc] init];
        model.name = userInfo.name;
        model.icon = userInfo.avatar;
        if([userInfo.sex integerValue] == 1){
            model.sex = @"男";
        }else{
            model.sex = @"女";
        }
        
        model.gold  = [userMoney.coin integerValue];
        model.package = [userMoney.cash floatValue];
        model.apprentice = [userMoney.binding_alipay integerValue];
        model.IsLogin = YES;
        
        if(self.delegate != nil){
            [self.delegate makeTureLogin:model];
        }
        
        [[AppConfig sharedInstance] saveUserAcount:[Login_info share].userInfo_model.telephone];
    }
}

-(void)initView{
    
    //退出
    UIButton* cancel_button = [UIButton new];
    [cancel_button setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [cancel_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancel_button];
    [cancel_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(StaTusHight+kWidth(14));
        make.right.equalTo(self.view.mas_right).with.offset(-kWidth(20));
        make.height.and.width.mas_offset(kWidth(16));
    }];
    
    //欢迎登陆标题
    UILabel* title = [UILabel new];
    title.text = @"欢迎登录";
    title.textColor = [UIColor blackColor];
    title.textAlignment = NSTextAlignmentLeft;
    title.font = kFONT(24);
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(kWidth(20));
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(cancel_button.mas_bottom).with.offset(kWidth(20));
    }];
    
    //账号
    UITextField* account_textfield = [[UITextField alloc] initWithFrame:CGRectMake(20, StaTusHight+144, SCREEN_WIDTH-20-20, 48)];
    account_textfield.placeholder = @"输入手机号";
    account_textfield.textColor = [UIColor blackColor];
    account_textfield.font = kFONT(16);
    account_textfield.keyboardType = UIKeyboardTypeNumberPad;
    m_phoneNumber_textfeild = account_textfield;
    [self.view addSubview:account_textfield];
    [account_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(kWidth(20));
        make.right.equalTo(self.view.mas_right).with.offset(-kWidth(20));
        make.top.equalTo(self.view.mas_top).with.offset(kWidth(144)+StaTusHight);
        make.height.mas_offset(kWidth(48));
    }];

    UIView* line_one = [UIView new];
    line_one.backgroundColor = RGBA(242, 242, 242, 1);
    [self.view addSubview:line_one];
    [line_one mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(account_textfield.mas_left);
        make.right.equalTo(account_textfield.mas_right);
        make.top.equalTo(account_textfield.mas_bottom);
        make.height.mas_offset(kWidth(1));
    }];
    
    //验证码
    UITextField* password_textfield = [UITextField new];
    password_textfield.placeholder = @"输入验证码";
    password_textfield.textColor = [UIColor blackColor];
    password_textfield.font = kFONT(16);
    password_textfield.keyboardType = UIKeyboardTypeNumberPad;
    m_password_textfeild = password_textfield;
    [self.view addSubview:password_textfield];
    [password_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line_one.mas_bottom).with.offset(kWidth(30));
        make.left.equalTo(self.view.mas_left).with.offset(kWidth(20));
        make.right.equalTo(self.view.mas_right).with.offset(-kWidth(20));
        make.height.mas_offset(kWidth(48));
    }];
    
    //添加按钮 发送验证吗
    UIButton* get_yanzhengma_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [get_yanzhengma_button setTitle:@"点击获取" forState:UIControlStateNormal];
//    [get_yanzhengma_button setBackgroundColor:[UIColor blackColor]];
    [get_yanzhengma_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [get_yanzhengma_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:12]];
    get_yanzhengma_button.layer.cornerRadius = 4;
    get_yanzhengma_button.layer.borderWidth = 1;
    get_yanzhengma_button.layer.borderColor = [UIColor colorWithRed:46.0/255 green:46.0/255 blue:46.0/255 alpha:1.1/1].CGColor;
    [get_yanzhengma_button addTarget:self action:@selector(GetYanzhengma:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:get_yanzhengma_button];
    [get_yanzhengma_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line_one.mas_bottom).with.offset(kWidth(30));
        make.right.equalTo(self.view.mas_right).with.offset(-kWidth(20));
        make.height.mas_offset(kWidth(30));
        make.width.mas_offset(kWidth(76));
    }];
    
    [self IsShowBtnTime:get_yanzhengma_button];
    
    UIView* line_two = [UIView new];
    line_two.backgroundColor = RGBA(242, 242, 242, 1);
    [self.view addSubview:line_two];
    m_line_two = line_two;
    [line_two mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(kWidth(20));
        make.right.equalTo(self.view).with.offset(-kWidth(20));
        make.top.equalTo(password_textfield.mas_bottom);
        make.height.mas_offset(kWidth(1));
    }];
    
    //登陆
    UIButton* login_button = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(password_textfield.frame)+48, SCREEN_WIDTH-20-20, 52)];
    [login_button setTitle:@"登录" forState:UIControlStateNormal];
    [login_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [login_button setBackgroundColor:[UIColor colorWithRed:247/255.0 green:195/255.0 blue:72/255.0 alpha:1/1.0]];
    [login_button.titleLabel setFont:kFONT(16)];
    [login_button addTarget:self action:@selector(PhoneNumberLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [login_button.layer setCornerRadius:kWidth(4)];
    [self.view addSubview:login_button];
    m_login_btn = login_button;
    [login_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line_two.mas_bottom).with.offset(kWidth(48));
        make.right.equalTo(self.view.mas_right).with.offset(-kWidth(20));
        make.left.equalTo(self.view.mas_left).with.offset(kWidth(20));
        make.height.mas_offset(kWidth(52));
    }];
    
    //或
    UILabel* or_label = [UILabel new];
    or_label.text               = @"或";
    or_label.textColor          = RGBA(167, 169, 169, 1);
    or_label.textAlignment      = NSTextAlignmentCenter;
    or_label.font               = kFONT(14);
    [self.view addSubview:or_label];
    [or_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(login_button.mas_bottom).with.offset(kWidth(20));
    }];
    
    //微信登陆
    UIButton* wechat_login = [UIButton new];
    [wechat_login setBackgroundImage:[self createImageWithColor:RGBA(255, 255, 255, 1)] forState:UIControlStateNormal];
    [wechat_login setBackgroundImage:[self createImageWithColor:RGBA(28, 193, 92, 1)] forState:UIControlStateHighlighted];
    [wechat_login setImage:[UIImage imageNamed:@"ic_wechat-clicked"] forState:UIControlStateNormal];
    [wechat_login setImage:[UIImage imageNamed:@"ic_wechat_white"] forState:UIControlStateHighlighted];
    [wechat_login setTitle:@"微信登录" forState:UIControlStateNormal];
    [wechat_login setTitle:@"微信登录" forState:UIControlStateHighlighted];
    [wechat_login setTitleColor:RGBA(28, 193, 92, 1) forState:UIControlStateNormal];
    [wechat_login setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateHighlighted];
    [wechat_login.layer setCornerRadius:kWidth(4)];
    [wechat_login.layer setBorderWidth:kWidth(1)];
    [wechat_login.layer setBorderColor:RGBA(28, 193, 92, 1).CGColor];
    [wechat_login.titleLabel setFont:kFONT(16)];
    [wechat_login addTarget:self action:@selector(wechatLogin_action) forControlEvents:UIControlEventTouchUpInside];
    [wechat_login setTitleEdgeInsets:UIEdgeInsetsMake(0, kWidth(10), 0, 0)];
    [self.view addSubview:wechat_login];
    [wechat_login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(or_label.mas_bottom).with.offset(kWidth(20));
        make.left.equalTo(self.view).with.offset(kWidth(20));
        make.right.equalTo(self.view).with.offset(-kWidth(20));
        make.height.mas_offset(kWidth(52));
    }];
    
    //底部 协议提醒
    NSString* str               = @"登录即表示您已同意《有料用户协议》";
    NSString* str_one           = @"《有料用户协议》";
    
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:str];
    one.font = kFONT(12);
    [one setUnderlineStyle:NSUnderlineStyleSingle range:[str rangeOfString:str_one]];
    [one setUnderlineColor:RGBA(248, 205, 4, 1) range:[str rangeOfString:str_one]];
    [one setColor:RGBA(167, 169, 169, 1) range:str.rangeOfAll];
    
    [one setTextHighlightRange:[str rangeOfString:str_one]
                         color:RGBA(248, 205, 4, 1)
               backgroundColor:[UIColor whiteColor]
                     tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                         NSLog(@"超链接点击");
                         Agreement_ViewController* vc = [Agreement_ViewController new];
                         [self.navigationController pushViewController:vc animated:YES];
                     }];
    
    
    YYLabel *label = [YYLabel new];
    label.attributedText = one;
    label.textAlignment = NSTextAlignmentCenter;
    label.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    label.numberOfLines = 0;
    
    
//    label.backgroundColor = RGBA(167, 169, 169, 1);
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.height.mas_offset(kWidth(30));
    }];
}

-(UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(void)IsShowBtnTime:(UIButton*)bt{
    NSNumber* tmp = [[AppConfig sharedInstance] getIdefyCode];
    double time_get = [tmp doubleValue];
    
    NSNumber* tmp_now = [[TimeHelper share] getCurrentTime_number];
    double time_now = [tmp_now doubleValue];
    
    NSInteger cha = time_now- time_get;
    if(cha < 60){
        m_timer_count = 60-cha;
        m_timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            if(m_timer_count <= 0){
                m_btn_IsClicked = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [bt setTitle:@"重新发送" forState:UIControlStateNormal];
                    m_btn_IsClicked = NO;
                    m_timer_count = TimeCount;
                    [m_timer invalidate];
                    [[AppConfig sharedInstance] saveIdifyCode:[NSNumber numberWithInteger:0]];
                });
            }else{
                m_timer_count--;
                m_btn_IsClicked = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [bt.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:12]];
                    [bt setTitle:[NSString stringWithFormat:@"%ld s",m_timer_count] forState:UIControlStateNormal];
                    m_btn_IsClicked = YES;
                    
                });
            }
        }];
    }else{
        m_timer_count = TimeCount;//记时 时间
    }
}

#pragma mark - 按钮方法
-(void)GetYanzhengma:(UIButton*)bt{
    NSLog(@"获取验证码");
    if(m_btn_IsClicked){
        return;
    }
    [[AppConfig sharedInstance] saveIdifyCode:[[TimeHelper share] getCurrentTime_number]];
    //请求验证码
    [[IdentifyingCode ShareInstance] GetIdentifyingCode:m_phoneNumber_textfeild.text];
    
    [bt setTitle:[NSString stringWithFormat:@"%ld s",m_timer_count] forState:UIControlStateNormal];
    
    m_timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if(m_timer_count <= 0){
            m_btn_IsClicked = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [bt setTitle:@"重新发送" forState:UIControlStateNormal];
                m_btn_IsClicked = YES;
                m_timer_count = TimeCount;
                [m_timer invalidate];
                [[AppConfig sharedInstance] saveIdifyCode:[NSNumber numberWithInteger:0]];
            });
        }else{
            m_timer_count--;
            m_btn_IsClicked = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [bt.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:12]];
                [bt setTitle:[NSString stringWithFormat:@"%ld s",m_timer_count] forState:UIControlStateNormal];
                m_btn_IsClicked = NO;
                
            });
        }
    }];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)PhoneNumberLoginAction{
    NSLog(@"手机登陆");
//    //检查手机号码格式是否正确
//    if([self CheckPhoneNumber:m_phoneNumber_textfeild.text]){
//        [[IdentifyingCode ShareInstance] MakeTureIdentifyingCode:m_password_textfeild.text AndPhoneNumber:m_phoneNumber_textfeild.text];
//    }else{
//        [[AlertHelper Share] ShowMe:self And:2.0 And:@"手机号码格式不对"];
//    }
//
    [self SendLoginToServer];
}

-(BOOL)CheckPhoneNumber:(NSString*)mobileNum{
    if (mobileNum.length != 11)
    {
        [MyMBProgressHUD ShowMessage:@"手机号码格式错误" ToView:self.view AndTime:1.0f];
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    /**
     25     * 大陆地区固话及小灵通
     26     * 区号：010,020,021,022,023,024,025,027,028,029
     27     * 号码：七位或八位
     28     */
    //  NSString * PHS = @"^(0[0-9]{2})\\d{8}$|^(0[0-9]{3}(\\d{7,8}))$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        [MyMBProgressHUD ShowMessage:@"手机号码格式错误" ToView:self.view AndTime:1.0f];
        return NO;
    }
}

-(void)wechatLogin_action{
    NSLog(@"微信登陆");
    [UMShareHelper LoginWechat:Login_wechat];
}

#pragma mark - 验证码协议方法
-(void)MakeTureIdentifyingCode_failed{
    NSLog(@"MakeTureIdentifyingCode_failed");
}
-(void)MakeTureIdentifyingCode_sucess{
    NSLog(@"MakeTureIdentifyingCode_sucess");
    
    [self SendLoginToServer];
}
-(void)GetIdentifyingCode_sucess{
    NSLog(@"GetIdentifyingCode_sucess");
}
-(void)GetIdentifyingCode_failed{
    NSLog(@"GetIdentifyingCode_failed");
}

-(void)Logined:(Mine_userInfo_model *)model{
    if(self.delegate != nil){
        [self.delegate makeTureLogin:model];
    }
}

#pragma mark -键盘监听
//移动UIView(随着键盘移动)
-(void)transformDialog:(NSNotification *)aNSNotification
{
    if(m_login_btn == nil){
        return ;
    }
    NSLog(@"loginView移动");
    //键盘最后的frame
    CGRect keyboardFrame = [aNSNotification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    NSLog(@"loginView看看这个变化的Y值:%f",height);
    //需要移动的距离
    [self setCenterViewFrame:height];
}
-(void)keyboardWillHide:(NSNotification *)aNSNotification{
    if(m_login_btn == nil){
        return ;
    }
    [self setCenterViewFrame:0];
}

-(void)setCenterViewFrame:(CGFloat)height{
    if(m_login_btn_maxY == 0){
        m_login_btn_maxY = CGRectGetMaxY(m_login_btn.frame);
    }
    // 修改下边距约束
    CGFloat centerView_maxY = SCREEN_HEIGHT-m_login_btn_maxY;
    CGFloat height_offset = height - centerView_maxY;
    if(height_offset <= 0){
        height_offset = 0;
    }
    if(height == 0){
        [m_login_btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(m_line_two.mas_bottom).with.offset(kWidth(48));
        }];
    }
    else{
        [m_login_btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(m_line_two.mas_bottom).with.offset(kWidth(48)-height_offset);
        }];
    }
    
    // 更新约束
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 通知

-(void)Login_wechat_sucess{
    NSLog(@"Login_wechat_sucess");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)Login_wechat_notBlind:(NSNotification*)noti{
    NSLog(@"Login_wechat_failed");
    NSString* openId = noti.object;
    Mine_login_wechatBlindTel_ViewController* vc = [[Mine_login_wechatBlindTel_ViewController alloc] init];
    vc.openId = openId;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma 点击事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
/*
{
    "user_id": "814B08C64ADD12284CA82BA39384B177",    //用户唯一标识id
    "avatar": "http://q.qlogo.cn/qqapp/1105182645/814B08C64ADD12284CA82BA39384B177/100", //头像
    "name": "江湖行",                                 //昵称   --修改wechaname=>name
    "sex": 1,                                         //性别   1.男 2:女
    "city": "海淀",
    "province": "北京",
    "telephone": ""                                   //手机号
    "client_type": 1,                                 //1代表Android 2:代表ios
    "channel": "default",                             //渠道
    "v1_sign": "318cb2d3d132cf362e305805ed3ed0ed",    //apk签名
    "v1_ver": 1002005,                                //apk版本号
    "mobileOperator": "46002",
    "mobileOperatorName": "中国移动",
    "deviceid": "ca9e5c58ef7c9432",                  //设备id
    "mac": "02:00:00:00:00:00",                      //mac地址
    "imsi": "460022101154264",                       //imsi
    "imei": "864587029754570",                       //imei
    "net_type": 1,                                   //网络类型  1:wifi
    "os_version": "7.1",                             //设备os版本
    "model": "A0001",                                //手机型号
    "brand":"oneplus"                                //手机品牌
}
*/
#pragma mark - 登陆api
-(void)SendLoginToServer{
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/member/login"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"telephone",m_phoneNumber_textfeild.text]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":%ld",@"client_type",IOS]];//设备类型 1:android 2；ios
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"channel",@"default"]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"v1_sign",@"318cb2d3d132cf362e305805ed3ed0ed"]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"v1_ver",1001]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"mobileOperator",@"46002"]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"mobileOperatorName",@"中国移动"]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"deviceid",@"ca9e5c58ef7c9432"]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"mac",@"02:00:00:00:00:00"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"imei",IDFA]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"unique_id",(NSString*)[MyKeychain queryDataWithService:MyKeychain_server]]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"net_type",1]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"os_version",@"7.1"]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"model",@"A0001"]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"brand",@"oneplus"]];
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    IMP_BLOCK_SELF(Mine_login_ViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if(error || data == nil){
                NSLog(@"网络获取失败");
                //发送失败消息
//                [[AlertHelper Share] ShowMe:self And:1.0f And:@"注册失败"];
                [MyMBProgressHUD ShowMessage:@"网络错误" ToView:self.view AndTime:1.0f];
                return ;
            }

            NSLog(@"从服务器获取到数据");

            //保存账户
            [[AppConfig sharedInstance] saveUserAcount:m_phoneNumber_textfeild.text];
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            if(dict == nil){
                [MyMBProgressHUD ShowMessage:@"登陆错误" ToView:self.view AndTime:1.0f];
                return ;
            }
            [Login_info dicToModel:dict];
            Login_userMoney* userMoney = [[Login_info share] GetUserMoney];
            Login_userInfo* userInfo = [[Login_info share] GetUserInfo];
            
            Mine_userInfo_model* model = [[Mine_userInfo_model alloc] init];
            model.name = userInfo.name;
            model.icon = userInfo.avatar;
            if([userInfo.sex integerValue] == 1){
                model.sex = @"男";
            }else{
                model.sex = @"女";
            }
            
            model.gold  = [userMoney.coin integerValue];
            model.package = [userMoney.cash floatValue];
            model.apprentice = [userMoney.binding_alipay integerValue];
            model.IsLogin = YES;
            
            if(block_self.delegate != nil){
                [block_self.delegate makeTureLogin:model];
            }
            [block_self.navigationController popViewControllerAnimated:YES];
            
            //弹出登陆奖励tan chuang
            [[NSNotificationCenter defaultCenter] postNotificationName:@"autoLogin-tabbarVC" object:nil];
            
            //"reg_reward_cash" = 0;//要显示的金额
            //"reg_reward_status" = 1;0:新用户 1:老用户
            
            if([userInfo.device_mult_user integerValue] == TheDevice){
                if([userInfo.reg_reward_status integerValue] == 0){
                    NSLog(@"登陆_TabBarVCL_红包活动_新用户");
                    [[NSNotificationCenter defaultCenter] postNotificationName:RedPackage_newUser object:nil];
                }
                else if([userInfo.reg_reward_status integerValue] == 1){
                    NSLog(@"登陆_TabBarVCL_红包活动_老用户");
                    [[NSNotificationCenter defaultCenter] postNotificationName:RedPackage_oldUser object:nil];
                }
            }
            else{
                NSLog(@"非绑定用户");
                [[NSNotificationCenter defaultCenter] postNotificationName:WaringOfNotTheAccount_tips object:nil];
            }
            
            
            //获取任务信息
            [InternetHelp GetMaxTaskCount];
            [[AppConfig sharedInstance] getNewUserTaskInfo];//获取新手任务信息
            
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
