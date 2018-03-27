//
//  Mine_login_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_login_ViewController.h"
#import "Mine_userInfo_model.h"

#define TimeCount 60
@interface Mine_login_ViewController ()<IdentifyingCode_delegete>

@end

@implementation Mine_login_ViewController{
    NSInteger       m_timer_count;
    NSTimer*        m_timer;
    UITextField*    m_password_textfeild;
    UITextField*    m_phoneNumber_textfeild;
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

-(void)initView{
    
    //退出
    UIButton* cancel_button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20-16, StaTusHight+14, 16, 16)];
    [cancel_button setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [cancel_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancel_button];
    
    //欢迎登陆标题
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(cancel_button.frame)+20, 200, 33)];
    title.text = @"欢迎登录";
    title.textColor = [UIColor blackColor];
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont boldSystemFontOfSize:24];
    [self.view addSubview:title];
    
    //账号
    UITextField* account_textfield = [[UITextField alloc] initWithFrame:CGRectMake(20, StaTusHight+144, SCREEN_WIDTH-20-20, 48)];
    account_textfield.placeholder = @"输入手机号";
    account_textfield.textColor = [UIColor blackColor];
    account_textfield.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    account_textfield.keyboardType = UIKeyboardTypeNumberPad;
    m_phoneNumber_textfeild = account_textfield;
    [self.view addSubview:account_textfield];
    
    //验证码
    UITextField* password_textfield = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(account_textfield.frame)+30, SCREEN_WIDTH-20-20, 48)];
    password_textfield.placeholder = @"输入验证码";
    password_textfield.textColor = [UIColor blackColor];
    password_textfield.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    password_textfield.keyboardType = UIKeyboardTypeNumberPad;
    m_password_textfeild = password_textfield;
    [self.view addSubview:password_textfield];
    
    //添加按钮 发送验证吗
    UIButton* get_yanzhengma_button = [UIButton buttonWithType:UIButtonTypeCustom];
    get_yanzhengma_button.frame = CGRectMake(SCREEN_WIDTH-20-76, CGRectGetMaxY(password_textfield.frame)-10-30, 76, 30);
    [get_yanzhengma_button setTitle:@"点击获取" forState:UIControlStateNormal];
//    [get_yanzhengma_button setBackgroundColor:[UIColor blackColor]];
    [get_yanzhengma_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [get_yanzhengma_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:12]];
    get_yanzhengma_button.layer.cornerRadius = 4;
    get_yanzhengma_button.layer.borderWidth = 1;
    get_yanzhengma_button.layer.borderColor = [UIColor colorWithRed:46.0/255 green:46.0/255 blue:46.0/255 alpha:1.1/1].CGColor;
    [get_yanzhengma_button addTarget:self action:@selector(GetYanzhengma:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:get_yanzhengma_button];
    
    //登陆
    UIButton* login_button = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(password_textfield.frame)+48, SCREEN_WIDTH-20-20, 52)];
    [login_button setTitle:@"登录" forState:UIControlStateNormal];
    [login_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [login_button setBackgroundColor:[UIColor colorWithRed:247/255.0 green:195/255.0 blue:72/255.0 alpha:1/1.0]];
    [login_button.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
    [login_button addTarget:self action:@selector(wechatAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:login_button];
    m_timer_count = TimeCount;//记时 时间
    //或
//    UILabel* other_lable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(login_button.frame)+32, SCREEN_WIDTH, 17)];
//    other_lable.text = @"或";
//    other_lable.textColor =  [UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1/1.0];
//    other_lable.textAlignment = NSTextAlignmentCenter;
//    other_lable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
//        //line
//    UIView* line_left = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-48-8, 8.5, 48, 1)];
//    line_left.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
//    [other_lable addSubview:line_left];
//        //line
//    UIView* line_right = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+8, 8.5, 48, 1)];
//    line_right.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
//    [other_lable addSubview:line_right];
//
//    [self.view addSubview:other_lable];
//
//    //微信登陆
//    UIView* wechat_view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-48/2, CGRectGetMaxY(other_lable.frame)+20, 48, 48+29)];
//        //img
//    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
//    [img setImage:[UIImage imageNamed:@"ic_wechat"]];
//    [wechat_view addSubview:img];
//        //lable
//    UILabel* tips_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 48+12, 48, 17)];
//    tips_label.text = @"微信登录";
//    tips_label.textColor = [UIColor blackColor];
//    tips_label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
//    [wechat_view addSubview:tips_label];
//
//        //添加点击方法
//    [wechat_view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wechatAction)]];
//
//    [self.view addSubview:wechat_view];
}

#pragma mark - 按钮方法
-(void)GetYanzhengma:(UIButton*)bt{
    
    NSLog(@"获取验证码");
    static BOOL IsClicked = YES;
    if(!IsClicked){
        return;
    }
    
    //请求验证码
    [[IdentifyingCode ShareInstance] GetIdentifyingCode:m_phoneNumber_textfeild.text];
    
    [bt setTitle:[NSString stringWithFormat:@"%ld s",m_timer_count] forState:UIControlStateNormal];
    
    m_timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if(m_timer_count <= 0){
            IsClicked = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [bt setTitle:@"重新发送" forState:UIControlStateNormal];
                IsClicked = YES;
                m_timer_count = TimeCount;
                [m_timer invalidate];
            });
        }else{
            m_timer_count--;
            IsClicked = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [bt.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:12]];
                [bt setTitle:[NSString stringWithFormat:@"%ld s",m_timer_count] forState:UIControlStateNormal];
                IsClicked = NO;
                
            });
        }
    }];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)wechatAction{
    NSLog(@"微信登陆");
    //检查手机号码格式是否正确
    if([self CheckPhoneNumber:m_phoneNumber_textfeild.text]){
        [[IdentifyingCode ShareInstance] MakeTureIdentifyingCode:m_password_textfeild.text AndPhoneNumber:m_phoneNumber_textfeild.text];
    }else{
        [[AlertHelper Share] ShowMe:self And:2.0 And:@"手机号码格式不对"];
    }
}

-(BOOL)CheckPhoneNumber:(NSString*)mobileNum{
    if (mobileNum.length != 11)
    {
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
        return NO;
    }
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
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",m_phoneNumber_textfeild.text]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"avatar",@""]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"name",@"爱我就请打"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"sex",1]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"city",@"朝阳"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"province",@"北京"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"telephone",m_phoneNumber_textfeild.text]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"client_type",2]];//设备类型 1:android 2；ios
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"channel",@"default"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"v1_sign",@"318cb2d3d132cf362e305805ed3ed0ed"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"v1_ver",1001]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"mobileOperator",@"46002"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"mobileOperatorName",@"中国移动"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"deviceid",@"ca9e5c58ef7c9432"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"mac",@"02:00:00:00:00:00"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"imsi",@"460022101154264"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"imei",@"864587029754570"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"net_type",1]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"os_version",@"7.1"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"model",@"A0001"]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"brand",@"oneplus"]];
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
            
            
            if(error){
                NSLog(@"网络获取失败");
                //发送失败消息
                [[AlertHelper Share] ShowMe:self And:1.0f And:@"注册失败"];
            }
            
            NSLog(@"从服务器获取到数据");

            //保存账户
            [[AppConfig sharedInstance] saveUserAcount:m_phoneNumber_textfeild.text];
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
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
            //"reg_reward_cash" = 0;//要显示的金额
            //"reg_reward_status" = 1;0:新用户 1:老用户
            NSString* status = [Login_info share].userInfo_model.reg_reward_status;
            if([status isEqualToString:@"1"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"登陆_TabBarVCL_红包活动_老用户" object:nil];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"登陆_TabBarVCL_红包活动_新用户" object:nil];
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
