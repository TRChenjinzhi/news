//
//  Mine_inviteApprence_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_inviteApprence_ViewController.h"

@interface Mine_inviteApprence_ViewController ()

@end

@implementation Mine_inviteApprence_ViewController{
    UIView*     m_navibar_view;
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
    
    UIButton* back_button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
    [back_button setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [back_button setImage:[UIImage imageNamed:@"ic_nav_back"] forState:UIControlStateNormal];
    [back_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navibar_view addSubview:back_button];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-80/2, 18, 80, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"邀请收徒";
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
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/shoutu?user_id=%@",[Login_info share].userInfo_model.user_id]]];
    [webview loadRequest:request];
    
    [self.view addSubview:webview];
}

#pragma mark - 按钮方法
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
