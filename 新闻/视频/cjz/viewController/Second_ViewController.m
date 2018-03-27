//
//  Second_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/2/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Second_ViewController.h"

@interface Second_ViewController ()<UIScrollViewDelegate,UIWebViewDelegate>

@end

@implementation Second_ViewController{
    UIView*             m_navibar_view;
    UIWebView*          m_web;
    UIActivityIndicatorView* m_waiting;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavi];
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

-(void)initNavi{
    UIView* navibar_view = [[UIView alloc] initWithFrame:CGRectMake(0, StaTusHight, SCREEN_WIDTH, 56)];
    
    UIButton* back_button = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 56, 56)];
//    [back_button setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [back_button setTitle:@"返回" forState:UIControlStateNormal];
    [back_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [back_button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [back_button setImage:[UIImage imageNamed:@"ic_nav_back"] forState:UIControlStateNormal];
    [back_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navibar_view addSubview:back_button];
    
//    UIButton* history_button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-56-14, 21, 56, 14)];
//    [history_button setTitle:@"提现记录" forState:UIControlStateNormal];
//    [history_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [history_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
//    [history_button addTarget:self action:@selector(history_changeToMoney) forControlEvents:UIControlEventTouchUpInside];
//    [navibar_view addSubview:history_button];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(66, 21, 30, 14)];
    title.textAlignment = NSTextAlignmentLeft;
    title.text = @"返回";
    title.font = [UIFont systemFontOfSize:14];
    title.textColor = [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    title.textAlignment = NSTextAlignmentLeft;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
    [title addGestureRecognizer:tap];
    title.userInteractionEnabled = YES;
//    [navibar_view addSubview:title];
    
    //line
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 56-1, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [navibar_view addSubview:line];
    
    [self.view addSubview:navibar_view];
    m_navibar_view = navibar_view;
}

-(void)initView{
    m_web = [[UIWebView alloc] initWithFrame:CGRectMake(0, StaTusHight+56, SCREEN_WIDTH, SCREEN_HEIGHT)];
    m_web.delegate = self;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //    [m_web setLayoutMargins:UIEdgeInsetsZero];
    
    [self.view addSubview:m_web];
    //    [m_vc.webview loadHTMLString:@"https://cpu.baidu.com/1033/e61d3927" baseURL:[[NSBundle mainBundle] resourceURL]];
    //    [m_webview loadHTMLString:@"https://cpu.baidu.com/1033/e61d3927" baseURL:[[NSBundle mainBundle] resourceURL]];
//    NSURL* url = [NSURL URLWithString:@"https://cpu.baidu.com/1033/ea61450f?scid=10463"];
    NSURLRequest* request = self.request;
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
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [m_waiting stopAnimating];
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [button setTitle:@"点我重新加载" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(reloadView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(navigationType == UIWebViewNavigationTypeLinkClicked){
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

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
