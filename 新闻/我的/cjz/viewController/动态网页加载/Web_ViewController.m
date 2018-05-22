//
//  Web_ViewController.m
//  橙子快报
//
//  Created by chenjinzhi on 2018/5/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Web_ViewController.h"

@interface Web_ViewController ()<WKUIDelegate,WKNavigationDelegate>

@end

@implementation Web_ViewController{
    UIView*                 m_navibar_view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavi];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNavi{
    UIView* navibar_view = [[UIView alloc] initWithFrame:CGRectMake(0, StaTusHight, SCREEN_WIDTH, 56)];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, SCREEN_WIDTH, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = self.naviTitle;
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
    WKWebView* webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_navibar_view.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(m_navibar_view.frame))];
    webview.scrollView.bounces = NO;
    webview.UIDelegate = self;
    webview.navigationDelegate = self;
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    [webview loadRequest:request];
    
    [self.view addSubview:webview];
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [MyMBProgressHUD ShowMessage:@"网络失败" ToView:self.view AndTime:1.0f];
}

#pragma mark - 按钮方法
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
