//
//  Video_Main_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Video_Main_ViewController.h"
#import "Header_ViewController.h"
#import "Second_ViewController.h"

@interface Video_Main_ViewController ()<UIWebViewDelegate>

@end

@implementation Video_Main_ViewController{
    UIWebView*          m_web;
    UIActivityIndicatorView* m_waiting;
    BOOL                m_isFirst;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initWaiting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)initView{
    m_web = [[UIWebView alloc] initWithFrame:CGRectMake(0, StaTusHight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    m_web.delegate = self;

    self.edgesForExtendedLayout = UIRectEdgeNone;
//    [m_web setLayoutMargins:UIEdgeInsetsZero];

    [self.view addSubview:m_web];
//    [m_vc.webview loadHTMLString:@"https://cpu.baidu.com/1033/e61d3927" baseURL:[[NSBundle mainBundle] resourceURL]];
//    [m_webview loadHTMLString:@"https://cpu.baidu.com/1033/e61d3927" baseURL:[[NSBundle mainBundle] resourceURL]];
    NSURL* url = [NSURL URLWithString:@"https://cpu.baidu.com/1033/ea61450f?scid=10463"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [m_web loadRequest:request];
    
    [self.view addSubview:m_web];
}

-(void)initWaiting{
    m_waiting = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    m_waiting.center = self.view.center;
    [m_waiting setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    m_waiting.backgroundColor = [UIColor whiteColor];
    [m_waiting startAnimating];
    [self.view addSubview:m_waiting];
}

#pragma mark - webView代理
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [m_waiting stopAnimating];
    m_isFirst = YES;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [m_waiting stopAnimating];
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [button setTitle:@"点我重新加载" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(reloadView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"UIWebViewNavigationType--%ld",navigationType);
    if(navigationType == UIWebViewNavigationTypeOther || navigationType == UIWebViewNavigationTypeLinkClicked){
        NSLog(@"UIWebViewNavigationTypeLinkClicked-----------");
        if(!m_isFirst){ //第一次进入为UIWebViewNavigationTypeOther 类型，之后广告点击 也是UIWebViewNavigationTypeOther类型
            return YES;
        }
        Second_ViewController* vc = [[Second_ViewController alloc] init];
        vc.request = request;
        [self.navigationController pushViewController:vc animated:YES];
        
        // 如果返回NO，代表不允许加载这个请求
        return NO;
    }
    
    return YES;
}

#pragma mark - 按钮方法
-(void)reloadView{
    [self initView];
    [self initWaiting];
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
