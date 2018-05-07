//
//  Mine_inviteApprence_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_inviteApprence_ViewController.h"
#import "ShareBridge.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <MessageUI/MessageUI.h>

@interface Mine_inviteApprence_ViewController ()<UIWebViewDelegate,MFMessageComposeViewControllerDelegate,ShareBridge_PhoneMessate_Protocol>

@property (nonatomic,strong)JSContext* jsContext;
@property (nonatomic,strong)ShareBridge *shareBridge;

@end

@implementation Mine_inviteApprence_ViewController{
    UIView*     m_navibar_view;
    NSArray*    _mUrlArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavi];
    [self initView];
    
    _mUrlArray = [NSArray arrayWithObjects:
                  @"javascript:window.ShareBridge.onShare(1)",
                  @"javascript:window.ShareBridge.onShare(2)",
                  @"javascript:window.ShareBridge.onShare(3)",
                  @"javascript:window.ShareBridge.onShare(4)",
                  @"javascript:window.ShareBridge.onShare(5)",
                  nil];
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
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-80/2, 18, 80, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"邀请好友";
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
    UIWebView* webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_navibar_view.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(m_navibar_view.frame))];
    webview.scrollView.bounces = NO;
    webview.delegate = self;
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/shoutu?user_id=%@",[Login_info share].userInfo_model.user_id]]];
    [webview loadRequest:request];
    
    [self.view addSubview:webview];
}

-(void)collectImgOfShare:(NSArray*)array{
    
}

#pragma mark - 按钮方法
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - webview协议
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    // 获取JS上下文运行环境
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.shareBridge = [[ShareBridge alloc] init];
    self.shareBridge.delegate = self;
    // 将NativeAPIs模型注入JS
    self.jsContext[@"ShareBridge"] = self.shareBridge;
    self.shareBridge.jsContext = self.jsContext;
    
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息: %@", exceptionValue);
    };
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

-(void)share:(NSString*)str{
    NSLog(@"%@",str);
}

#pragma mark - shareBridge协议
-(void)sendMessageWithPhoneNumber:(NSString *)phonenumber AndMessage:(NSString *)message{
    //判断当前设备是否有发短信功能
    if(MFMessageComposeViewController.canSendText){
        MFMessageComposeViewController* vc = [MFMessageComposeViewController new];
        vc.recipients = @[phonenumber];
        vc.body = [message stringByAppendingString:[Login_info share].shareInfo_model.shorLink];//短信内容
        vc.messageComposeDelegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        [MyMBProgressHUD ShowMessage:@"不支持短信功能" ToView:self.view AndTime:1.0f];
    }
}

#pragma mark - 短信协议
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:YES completion:nil];
    switch(result) {
        case MessageComposeResultSent:
            //信息传送成功
                NSLog(@"信息传送成功");
                break;
        case MessageComposeResultFailed:
            //信息传送失败
                NSLog(@"信息传送失败");
                break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
                NSLog(@"信息被用户取消传送");
                break;
        default:
                break;
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
