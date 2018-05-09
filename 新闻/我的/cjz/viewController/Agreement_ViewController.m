//
//  Agreement_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/2/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Agreement_ViewController.h"
#import "LabelHelper.h"


@interface Agreement_ViewController ()<UIWebViewDelegate>

@end

@implementation Agreement_ViewController{
    UIView*         m_navibar_view;
    NSArray*        m_array_content;
    UIScrollView*   m_scrollview;
    UIWebView*      m_webview;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavi];
//    [self initView];//本地的方式
    [self initWebview];//使用网络
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
    
    //    UIButton* edit_button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-56-14, 21, 56, 14)];
    //    [edit_button setTitle:@"编辑" forState:UIControlStateNormal];
    //    [edit_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [edit_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
    //    [edit_button addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    //    [navibar_view addSubview:edit_button];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-150/2, 18, 150, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"隐私及版权说明";
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

-(void)initWebview{
    UIWebView* webview = [[UIWebView alloc] init];
    m_webview = webview;
    if(!_isTask){
        webview.frame = CGRectMake(0, CGRectGetMaxY(m_navibar_view.frame), SCREEN_WIDTH,
                                   SCREEN_HEIGHT-CGRectGetMaxY(m_navibar_view.frame));
    }else{
        webview.frame = CGRectMake(0, CGRectGetMaxY(m_navibar_view.frame), SCREEN_WIDTH,
                                   SCREEN_HEIGHT-CGRectGetMaxY(m_navibar_view.frame)-30);
    }
    
    webview.scrollView.bounces = NO;
    webview.delegate = self;
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://toutiao.3gshow.cn/protocol.html"]];
//    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://toutiao.3gshow.cn/io.php?id=587779"]];
    [webview loadRequest:request];
    
    [self.view addSubview:webview];
}


#pragma mark - 按钮方法
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - webview协议
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MyMBProgressHUD ShowMessage:@"网络错误" ToView:self.view AndTime:1.0f];
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
