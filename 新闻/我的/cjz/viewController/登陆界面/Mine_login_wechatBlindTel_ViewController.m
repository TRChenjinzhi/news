//
//  Mine_login_wechatBlindTel_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/4/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_login_wechatBlindTel_ViewController.h"

@interface Mine_login_wechatBlindTel_ViewController ()<IdentifyingCode_delegete>

@end

#define TimeCount 60
@implementation Mine_login_wechatBlindTel_ViewController{
    NSInteger       m_timer_count;
    NSTimer*        m_timer;
    UITextField*    m_password_textfeild;
    UITextField*    m_phoneNumber_textfeild;
    BOOL            m_btn_IsClicked;
    UIButton*       m_login_btn;
    CGFloat         m_login_btn_maxY;
    UIView*         m_line_two;
    
    UIView*         m_navibar_view;
    UIView*         m_deviceInfo_view;
    MBProgressHUD*  waiting;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [IdentifyingCode ShareInstance].delegate = self;//验证码代理
    [self initNavibar];
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
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

-(void)initNavibar{
    UIView* navibar_view = [[UIView alloc] initWithFrame:CGRectMake(0, StaTusHight, SCREEN_WIDTH, 56)];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, SCREEN_WIDTH, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"绑定手机号";
    title.font = [UIFont boldSystemFontOfSize:18];
    title.textColor = [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    [navibar_view addSubview:title];
    
    UIButton* back_button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
    [back_button setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [back_button setImage:[UIImage imageNamed:@"ic_nav_back"] forState:UIControlStateNormal];
    [back_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navibar_view addSubview:back_button];
    
    //line
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 56-1, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [navibar_view addSubview:line];
    
    [self.view addSubview:navibar_view];
    m_navibar_view = navibar_view;
}

-(void)initView{
    
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
        make.top.equalTo(m_navibar_view.mas_bottom).with.offset(kWidth(46));
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
    get_yanzhengma_button.layer.cornerRadius = kWidth(30)/2;
    get_yanzhengma_button.layer.borderWidth = 1;
    get_yanzhengma_button.layer.borderColor = [UIColor colorWithRed:46.0/255 green:46.0/255 blue:46.0/255 alpha:1.1/1].CGColor;
    [get_yanzhengma_button addTarget:self action:@selector(GetYanzhengma:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:get_yanzhengma_button];
    [get_yanzhengma_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(line_one.mas_bottom).with.offset(-kWidth(8));
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
    [login_button setTitle:@"下一步" forState:UIControlStateNormal];
    [login_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [login_button setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    [login_button.titleLabel setFont:kFONT(16)];
    [login_button addTarget:self action:@selector(PhoneNumberLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [login_button.layer setCornerRadius:kWidth(52)/2];
    login_button.clipsToBounds = YES;
    [self.view addSubview:login_button];
    m_login_btn = login_button;
    [login_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line_two.mas_bottom).with.offset(kWidth(48));
        make.right.equalTo(self.view.mas_right).with.offset(-kWidth(20));
        make.left.equalTo(self.view.mas_left).with.offset(kWidth(20));
        make.height.mas_offset(kWidth(52));
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
    if(m_btn_IsClicked){
        return;
    }
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
                });
            }
        }];
    }else{
        m_timer_count = TimeCount;//记时 时间
    }
}

-(void)NotTheTelePhone{
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
    phoneNumber = [NSString stringWithFormat:@"手机号已注册，是否使用该手机号登录？"];
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
    
    UIButton* telephone_login = [UIButton new];
    [telephone_login setTitle:@"登陆" forState:UIControlStateNormal];
    [telephone_login setTitleColor:RGBA(34, 39, 39, 1) forState:UIControlStateNormal];
    [telephone_login setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    [telephone_login.layer setCornerRadius:kWidth(36)/2];
    telephone_login.clipsToBounds = YES;
    [telephone_login addTarget:self action:@selector(telephone_login_action) forControlEvents:UIControlEventTouchUpInside];
    [center_view addSubview:telephone_login];
    [telephone_login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(center_view.mas_bottom).with.offset(-kWidth(20));
        make.right.equalTo(center_view.mas_right).with.offset(-kWidth(25));
        make.height.mas_offset(kWidth(36));
        make.width.mas_offset(kWidth(100));
    }];
    
    UIButton* telephone_cancel = [UIButton new];
    [telephone_cancel setTitle:@"取消" forState:UIControlStateNormal];
    [telephone_cancel setTitleColor:RGBA(167, 169, 169, 1) forState:UIControlStateNormal];
    [telephone_cancel setBackgroundColor:RGBA(242, 242, 242, 1)];
    [telephone_cancel.layer setCornerRadius:3.0f];
    [telephone_cancel addTarget:self action:@selector(telephone_cancel_action) forControlEvents:UIControlEventTouchUpInside];
    [center_view addSubview:telephone_cancel];
    [telephone_cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(center_view.mas_left).with.offset(kWidth(25));
        make.bottom.equalTo(center_view.mas_bottom).with.offset(-kWidth(20));
        make.height.mas_offset(kWidth(36));
        make.width.mas_offset(kWidth(100));
    }];
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
            m_btn_IsClicked = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [bt setTitle:@"重新发送" forState:UIControlStateNormal];
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
                
            });
        }
    }];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)PhoneNumberLoginAction{
    NSLog(@"手机登陆");
    //苹果审核测试账号
    if([m_phoneNumber_textfeild.text isEqualToString:@"13000000000"] && [m_password_textfeild.text isEqualToString:@"112233"]){
        [self SendLoginToServer];
        return;
    }
        //检查手机号码格式是否正确
        if([self CheckPhoneNumber:m_phoneNumber_textfeild.text]){
            [[IdentifyingCode ShareInstance] MakeTureIdentifyingCode:m_password_textfeild.text AndPhoneNumber:m_phoneNumber_textfeild.text];
        }else{
            [[AlertHelper Share] ShowMe:self And:2.0 And:@"手机号码格式不对"];
        }
    
//    [self SendLoginToServer];
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

-(void)telephone_login_action{
    [self TelephoneLoginToServer];
}

-(void)telephone_cancel_action{
    [m_deviceInfo_view removeFromSuperview];
}

#pragma mark - 验证码协议方法
-(void)MakeTureIdentifyingCode_failed{
    NSLog(@"MakeTureIdentifyingCode_failed");
    [MyMBProgressHUD ShowMessage:@"验证码错误!" ToView:self.view AndTime:1.0f];
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
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"openid",self.openId]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"avatar",[Login_info share].userInfo_model.avatar]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"name",[Login_info share].userInfo_model.name]];
//    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"sex",[[Login_info share].userInfo_model.sex intValue]]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"avatar",@"avata"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"name",@"name"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"sex",1]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":%ld",@"client_type",IOS]];//设备类型 1:android 2；ios
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"imei",IDFA]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"unique_id",(NSString*)[MyKeychain queryDataWithService:MyKeychain_server]]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"model",[[DeviveHelper share] getDeviceName]]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"os_version",[UIDevice currentDevice].systemVersion]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"mac",[[DeviveHelper share] getMacAddress]]];
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    IMP_BLOCK_SELF(Mine_login_wechatBlindTel_ViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if(error){
                NSLog(@"网络获取失败");
                //发送失败消息
                [[AlertHelper Share] ShowMe:self And:1.0f And:@"注册失败"];
            }
            if(data == nil){
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
            NSNumber* tmp = dict[@"code"];
            NSInteger code = [tmp integerValue];
            if(code != 200){
                if(code == Login_wechat_notTheTelephone){
//                    [MyMBProgressHUD ShowMessage:@"手机号码已经被绑定" ToView:block_self.view AndTime:1.0f];
                    [self.view endEditing:YES];
                    [self NotTheTelePhone];
                }
                return;
            }
            [Login_info dicToModel:dict];
            Login_userInfo* userInfo = [[Login_info share] GetUserInfo];
            if ([[DefauteNameHelper getDefuateName] isEqualToString:userInfo.name]) {
                if([userInfo.wechat_binding integerValue] == 1){ //当微信绑定了，账号昵称为默认时，使用微信昵称
                    userInfo.name = userInfo.wechat_nickname;
                    [InternetHelp updateUserInfo];
                }
            }
            
            //弹出登陆奖励弹窗
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
            
            [block_self.navigationController popToRootViewControllerAnimated:YES];
            
            //获取任务信息
            [InternetHelp GetMaxTaskCount];
            [[AppConfig sharedInstance] getNewUserTaskInfo];//获取新手任务信息
            
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

-(void)TelephoneLoginToServer{
    
    waiting = [[MBProgressHUD alloc] initWithView:self.view];
    waiting.labelText = @"正在登陆..";
    waiting.progress = 0.4;
    waiting.mode = MBProgressHUDModeIndeterminate;
    waiting.dimBackground = YES;
    [waiting show:YES]; //显示进度框
    [self.view addSubview:waiting];
    [self.view bringSubviewToFront:waiting];
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/member/login"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"telephone",m_phoneNumber_textfeild.text]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":%ld",@"client_type",IOS]];//设备类型 1:android 2；ios
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"imei",IDFA]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"unique_id",(NSString*)[MyKeychain queryDataWithService:MyKeychain_server]]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"model",[[DeviveHelper share] getDeviceName]]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"os_version",[UIDevice currentDevice].systemVersion]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"mac",[[DeviveHelper share] getMacAddress]]];
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    IMP_BLOCK_SELF(Mine_login_wechatBlindTel_ViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if(error){
                NSLog(@"网络获取失败");
                //发送失败消息
                [[AlertHelper Share] ShowMe:self And:1.0f And:@"注册失败"];
            }
            if(data == nil){
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
            Login_userMoney* userMoney = [Login_info share].userMoney_model;
            Login_userInfo* userInfo = [Login_info share].userInfo_model;
            if ([[DefauteNameHelper getDefuateName] isEqualToString:userInfo.name]) {
                if([userInfo.wechat_binding integerValue] == 1){ //当微信绑定了，账号昵称为默认时，使用微信昵称
                    userInfo.name = userInfo.wechat_nickname;
                    [InternetHelp updateUserInfo];
                }
            }
            
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
                [block_self.delegate Logined:model];
            }
            
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
            
            [waiting removeFromSuperview];
            [m_deviceInfo_view removeFromSuperview];
            
            [block_self.navigationController popToRootViewControllerAnimated:YES];
            
            //获取任务信息
            [InternetHelp GetMaxTaskCount];
            [[AppConfig sharedInstance] getNewUserTaskInfo];//获取新手任务信息
            
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

@end
