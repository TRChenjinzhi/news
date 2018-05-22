//
//  Second_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/2/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Second_ViewController.h"

@interface Second_ViewController ()<UIScrollViewDelegate,WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,strong)UIProgressView* progressView;

@end

@implementation Second_ViewController{
    UIView*             m_navibar_view;
    WKWebView*          m_web;
    UIActivityIndicatorView* m_waiting;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavi];
    [self initView];
//    [self initWaiting];
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
    
    //进度条初始化
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_navibar_view.frame), [[UIScreen mainScreen] bounds].size.width, kWidth(2))];
    self.progressView.progressTintColor = RGBA(255, 129, 3, 1);
    self.progressView.trackTintColor = [UIColor whiteColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    
    m_web = [[WKWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.progressView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(self.progressView.frame))];
    m_web.UIDelegate = self;
    m_web.navigationDelegate = self;
    
    [m_web addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = m_web.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    }
}

#pragma mark - webView代理
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
//    [webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [button setTitle:@"点我重新加载" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(reloadView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    if(navigationAction.navigationType == UIWebViewNavigationTypeLinkClicked){
        Second_ViewController* vc = [[Second_ViewController alloc] init];
        vc.request = navigationAction.request;
        [self.navigationController pushViewController:vc animated:YES];
        
        // 如果返回NO，代表不允许加载这个请求
//        return NO;
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
//    return YES;
    decisionHandler(WKNavigationActionPolicyAllow);
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
