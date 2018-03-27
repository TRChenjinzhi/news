//
//  Repply_ChangeToMoney_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Repply_ChangeToMoney_ViewController.h"
#import "Repply_ChangeToMoney_view_model.h"
#import "Mine_info_changeToMoney_ViewController.h"

@interface Repply_ChangeToMoney_ViewController ()<IdentifyingCode_delegete>

@end

@implementation Repply_ChangeToMoney_ViewController{
    UIView*         m_navibar_view;
    UIView*         m_tips_view;
    
    NSInteger       m_moneyCount;
    
    UIView*         m_view;
    NSTimer*        m_timer;
    NSInteger       m_timer_count;
    
    UITextField*    m_zhifubao_textfield;
    UITextField*    m_name_textfield;
    UITextField*    m_IdentifyingCode_textfield;
    UITextField*    m_PhoneNumber_textfield;
    
    BOOL isBinding;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavi];
    [self initTips];
    [self initView];
    [self initFootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNavi{
    UIView* navibar_view = [[UIView alloc] initWithFrame:CGRectMake(0, StaTusHight, SCREEN_WIDTH, 56)];
    
    UIButton* back_button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
    [back_button setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [back_button setImage:[UIImage imageNamed:@"ic_nav_back"] forState:UIControlStateNormal];
    [back_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navibar_view addSubview:back_button];
    
    UIButton* history_button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-56-14, 21, 56, 14)];
    [history_button setTitle:@"提现说明" forState:UIControlStateNormal];
    [history_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [history_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
    [history_button addTarget:self action:@selector(info_ChangeToMoney) forControlEvents:UIControlEventTouchUpInside];
    [navibar_view addSubview:history_button];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-80/2, 18, 80, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"申请提现";
    title.font = [UIFont systemFontOfSize:18];
    title.textColor = [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    [navibar_view addSubview:title];
    
    //line
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 56-1, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [navibar_view addSubview:line];
    
    [self.view addSubview:navibar_view];
    m_navibar_view = navibar_view;
}

-(void)initTips{
    UIView* tips_view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_navibar_view.frame), SCREEN_WIDTH, 30)];
    tips_view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    
    UILabel* tips_lable = [[UILabel alloc] initWithFrame:CGRectMake(16, 9, SCREEN_WIDTH-16, 12)];
    tips_lable.text         = @"为保障资金安全，请在提现前验证以下信息";
    tips_lable.textColor    = [UIColor colorWithRed:135/255.0 green:138/255.0 blue:138/255.0 alpha:1/1.0];
    tips_lable.textAlignment= NSTextAlignmentLeft;
    tips_lable.font         = [UIFont systemFontOfSize:12];
    [tips_view addSubview:tips_lable];
    m_tips_view = tips_view;
    
    [self.view addSubview:tips_view];
}

-(void)initView{
    
    isBinding = NO;
    if([[Login_info share].userMoney_model.binding_alipay isEqualToString:@"1"]){
        isBinding = YES;
    }
    
    Repply_ChangeToMoney_view_model* moneyCount_view = [[Repply_ChangeToMoney_view_model alloc] initWithFrame:CGRectMake(0,
                                                                                                              CGRectGetMaxY(m_tips_view.frame),
                                                                                                              SCREEN_WIDTH  ,
                                                                                                              48)];
    moneyCount_view.title = @"提现金额";
    moneyCount_view.subTitle_text = [NSString stringWithFormat:@"%ld元",m_moneyCount];
    [self.view addSubview:moneyCount_view];
    
    Repply_ChangeToMoney_view_model* repplyWay_view = [[Repply_ChangeToMoney_view_model alloc] initWithFrame:CGRectMake(0,
                                                                                                                        CGRectGetMaxY(moneyCount_view.frame),
                                                                                                                         SCREEN_WIDTH  ,
                                                                                                                         48)];
    repplyWay_view.title = @"提现方式";
    repplyWay_view.subTitle_text = @"支付宝";
    [self.view addSubview:repplyWay_view];
    
    Repply_ChangeToMoney_view_model* IdName_view = [[Repply_ChangeToMoney_view_model alloc] initWithFrame:CGRectMake(0,
                                                                                                                        CGRectGetMaxY(repplyWay_view.frame),
                                                                                                                        SCREEN_WIDTH  ,
                                                                                                                        48)];
    IdName_view.title = @"身份证姓名";
    if(isBinding){
        IdName_view.subTitle_text = [Login_info share].userMoney_model.alipay_name;
    }else{
        IdName_view.subTitle_TextFilePlaceHold_text = @"身份证姓名";
        m_name_textfield = IdName_view.m_textField;
    }
    [self.view addSubview:IdName_view];
    
//    Repply_ChangeToMoney_view_model* IdNumber_view = [[Repply_ChangeToMoney_view_model alloc] initWithFrame:CGRectMake(0,
//                                                                                                                     CGRectGetMaxY(IdName_view.frame),
//                                                                                                                     SCREEN_WIDTH  ,
//                                                                                                                     48)];
//    IdNumber_view.title = @"身份证号码";
//    IdNumber_view.subTitle_TextFilePlaceHold_text = @"身份证号码";
//    [self.view addSubview:IdNumber_view];
    
    Repply_ChangeToMoney_view_model* ZhifubaoNumber_view = [[Repply_ChangeToMoney_view_model alloc] initWithFrame:CGRectMake(0,
                                                                                                                       CGRectGetMaxY(IdName_view.frame),
                                                                                                                       SCREEN_WIDTH  ,
                                                                                                                       48)];
    ZhifubaoNumber_view.title = @"支付宝账号";
    if(isBinding){
        ZhifubaoNumber_view.subTitle_text = [Login_info share].userMoney_model.alipay_num;
    }else{
        ZhifubaoNumber_view.subTitle_TextFilePlaceHold_text = @"请填写";
        m_zhifubao_textfield = ZhifubaoNumber_view.m_textField;
    }
    [self.view addSubview:ZhifubaoNumber_view];
    
    Repply_ChangeToMoney_view_model* phoneNumber_view = [[Repply_ChangeToMoney_view_model alloc] initWithFrame:CGRectMake(0,
                                                                                                                    CGRectGetMaxY(ZhifubaoNumber_view.frame),
                                                                                                                             SCREEN_WIDTH  ,
                                                                                                                             48)];
    phoneNumber_view.title = @"手机号";
    phoneNumber_view.subTitle_text = [Login_info share].userInfo_model.telephone;

    [self.view addSubview:phoneNumber_view];
    
    Repply_ChangeToMoney_view_model* yanzhengma_view = [[Repply_ChangeToMoney_view_model alloc] initWithFrame:CGRectMake(0,
                                                                                                                    CGRectGetMaxY(phoneNumber_view.frame),
                                                                                                                          SCREEN_WIDTH  ,
                                                                                                                          48)];
    yanzhengma_view.title = @"提现验证码";
    yanzhengma_view.subTitle_TextFilePlaceHold_text = @"填写验证码";
    m_IdentifyingCode_textfield = yanzhengma_view.m_textField;
    m_view = yanzhengma_view;
//    [yanzhengma_view.m_textField becomeFirstResponder];
    [self.view addSubview:yanzhengma_view];
    
    Repply_ChangeToMoney_view_model* shouxufei_view = [[Repply_ChangeToMoney_view_model alloc] initWithFrame:CGRectMake(0,
                                                                                                                         CGRectGetMaxY(yanzhengma_view.frame),
                                                                                                                         SCREEN_WIDTH  ,
                                                                                                                         48)];
    shouxufei_view.title = @"提现手续费";
//    shouxufei_view.subTitle_TextFilePlaceHold_text = @"填写验证码";
    shouxufei_view.subTitle_text = @"1元";
    //    [yanzhengma_view.m_textField becomeFirstResponder];
    [self.view addSubview:shouxufei_view];
    
    //总计
    UILabel* total_label = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(shouxufei_view.frame)+16, 50, 14)];
    total_label.text = @"总计";
    total_label.textColor = RGBA(251, 84, 38, 1);
    total_label.textAlignment = NSTextAlignmentLeft;
    total_label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:total_label];
    
    //总计金额
    UILabel* totalMoney_label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16-50, CGRectGetMaxY(shouxufei_view.frame)+16, 50, 14)];
    totalMoney_label.text = [NSString stringWithFormat:@"%ld元",m_moneyCount+1];
    totalMoney_label.textColor = RGBA(251, 84, 38, 1);
    totalMoney_label.textAlignment = NSTextAlignmentRight;
    totalMoney_label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:totalMoney_label];
    
    //line
    UIView* line           = [[UIView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(shouxufei_view.frame)+48-1, SCREEN_WIDTH-16-16, 1)];
    line.backgroundColor   = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [self.view addSubview:line];
    
    //添加按钮 发送验证吗
    UIButton* get_yanzhengma_button = [UIButton buttonWithType:UIButtonTypeCustom];
    get_yanzhengma_button.frame = CGRectMake(SCREEN_WIDTH-16-84, 10, 84, 28);
    [get_yanzhengma_button setTitle:@"点击获取" forState:UIControlStateNormal];
    [get_yanzhengma_button setBackgroundColor:[UIColor blackColor]];
    [get_yanzhengma_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [get_yanzhengma_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:12]];
    [get_yanzhengma_button addTarget:self action:@selector(GetYanzhengma:) forControlEvents:UIControlEventTouchUpInside];
    [yanzhengma_view addSubview:get_yanzhengma_button];
    m_timer_count = 60;

    CGRect frame = yanzhengma_view.m_textField.frame;
    yanzhengma_view.m_textField.frame = CGRectMake(frame.origin.x-84-16, frame.origin.y, frame.size.width, frame.size.height);
    
    //按钮
    UIButton* sender_button = [[UIButton alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(line.frame)+20, SCREEN_WIDTH-16-16, 40)];
    [sender_button setBackgroundColor:[UIColor colorWithRed:248/255.0 green:205/255.0 blue:4/255.0 alpha:1/1.0]];
    [sender_button setTitle:@"提现" forState:UIControlStateNormal];
    [sender_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:16]];
    [sender_button addTarget:self action:@selector(Sender_changeMoney) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sender_button];
    
    if(m_moneyCount+1 > [[Login_info share].userMoney_model.cash floatValue]){
        [sender_button setTitle:@"余额不足" forState:UIControlStateNormal];
        sender_button.enabled = NO;
    }
    
    UILabel* foot_tips      = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(sender_button.frame)+20, SCREEN_WIDTH-16-16, 12)];
    foot_tips.textAlignment = NSTextAlignmentLeft;
    foot_tips.textColor     = [UIColor colorWithRed:195/255.0 green:196/255.0 blue:196/255.0 alpha:1/1.0];
    foot_tips.text          = @"预计明日24:00之前到账，如遇双休日和法定节假日顺延";
    foot_tips.font          = [UIFont systemFontOfSize:12];
    [self.view addSubview:foot_tips];
    
}

-(void)initFootView{
    
}

-(void)setMoneyCout:(NSInteger)moneyCout{
    m_moneyCount = moneyCout;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        CGPoint point=[[touches anyObject]locationInView:self.view];
    
    
        CALayer *layer=[self.view.layer hitTest:point];
        if (layer == m_PhoneNumber_textfield.layer || layer == m_zhifubao_textfield.layer || layer == m_IdentifyingCode_textfield.layer) {
            
        }else{
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//收起键盘
        }
}

#pragma mark - 按钮方法

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)info_ChangeToMoney{
    Mine_info_changeToMoney_ViewController* vc = [[Mine_info_changeToMoney_ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)GetYanzhengma:(UIButton*)bt{
    NSLog(@"验证码");
    static BOOL IsClicked = YES;
    if(!IsClicked){
        return;
    }
    
    [[IdentifyingCode ShareInstance] GetIdentifyingCode:m_PhoneNumber_textfield.text];
    
    [bt setTitle:[NSString stringWithFormat:@"%ld s",m_timer_count] forState:UIControlStateNormal];
    
    m_timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if(m_timer_count <= 0){
            IsClicked = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [bt setTitle:@"重新发送" forState:UIControlStateNormal];
                IsClicked = YES;
                m_timer_count = 60;
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

-(void)Sender_changeMoney{
    NSLog(@"Sender_changeMoney");
    //验证资料填写格式正确
    if([self IsInfoOk]){
        [IdentifyingCode ShareInstance].delegate = self;
        [[IdentifyingCode ShareInstance] MakeTureIdentifyingCode:m_IdentifyingCode_textfield.text AndPhoneNumber:m_PhoneNumber_textfield.text];
    }
}

//验证账号信息
-(BOOL)IsInfoOk{
    //支付宝账号
    //手机号码
    return YES;
}

#pragma mark - 验证码协议方法
-(void)MakeTureIdentifyingCode_failed{
    NSLog(@"MakeTureIdentifyingCode_failed");
    [MBProgressHUD showError:@"验证码有误"];
}
-(void)MakeTureIdentifyingCode_sucess{
    NSLog(@"MakeTureIdentifyingCode_sucess");
    [self UpData_reply];
}
-(void)GetIdentifyingCode_sucess{
    NSLog(@"GetIdentifyingCode_sucess");
}
-(void)GetIdentifyingCode_failed{
    NSLog(@"GetIdentifyingCode_failed");
}


#pragma mark API
-(void)UpData_reply{
    NSString* account_num = @"";
    NSString* account_name = @"";
    if(isBinding){
        account_num = [Login_info share].userMoney_model.alipay_num;
        account_name = [Login_info share].userMoney_model.alipay_name;
    }else{
        account_num = m_zhifubao_textfield.text;
        account_name = m_name_textfield.text;
    }
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/member/withDraw"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString *argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[[Login_info share]GetUserInfo].user_id]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"type",@"1"]];//0:支付宝 1:微信 2:话费提现
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"binding_alipay",[Login_info share].userMoney_model.binding_alipay]];//0:不绑定 1:绑定
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"money",[NSString stringWithFormat:@"%ld",m_moneyCount]]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"account_num",account_num]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"account_name",account_name]];
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    IMP_BLOCK_SELF(Repply_ChangeToMoney_ViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if(error){
                NSLog(@"网络获取失败");
                //发送失败消息
                [[AlertHelper Share] ShowMe:self And:2.0 And:@"网络失败"];
                return ;
            }
            
            NSLog(@"GetNetData_package从服务器获取到数据");
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* code = dict[@"code"];
            if([code longValue] != 200){
                [MBProgressHUD showSuccess:@"申请失败"];
                return;
            }else{
                [MBProgressHUD showSuccess:@"申请成功"];
                [block_self.navigationController popViewControllerAnimated:YES];
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
