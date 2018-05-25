//
//  Mine_choujiang_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/4/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_choujiang_ViewController.h"
#import "choujiang_model.h"

@interface Mine_choujiang_ViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,strong)UIProgressView* progressView;
@property (nonatomic,strong)NSTimer*    timer;
@end

@implementation Mine_choujiang_ViewController{
    UIView*             m_navibar_view;
    WKWebView*          m_webView;
    NSArray*            m_array_url;
    choujiang_model*    m_choujiang_model;
    BOOL                m_choujiang_isDone;
    UIView*             m_tipsWin_view;
    NSInteger           m_time_count;
    BOOL                m_isGuanggao_url; //是否是广告界面
}

static int UrlIndex = 0;//顺序使用url

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    m_time_count = 0;
    [self showTipsWin];
    [self initNavi];
    [self initWeb];
    [self getUrlByAPI];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(m_choujiang_model != nil){
        if(m_choujiang_isDone){
            NSString* taskId = [Md5Helper Choujiang_taskId:[Login_info share].userInfo_model.user_id AndUrl:m_choujiang_model.url];
            [self.delegate choujiang_result:m_choujiang_isDone AndTaskId:taskId];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showTipsWin{
    //是否弹出过
    //是：跳过
    //否：弹出
//    [[AppConfig sharedInstance] saveChoujiangTips:NO];
    if(![[AppConfig sharedInstance] getChoujiangTips_isShow]){
        
        [[AppConfig sharedInstance] saveChoujiangTips:YES];
        
        m_tipsWin_view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        m_tipsWin_view.backgroundColor  = RGBA(0, 0, 0, 0.6);
        [[UIApplication sharedApplication].keyWindow addSubview:m_tipsWin_view];
        
        UIView* centerView = [UIView new];
        centerView.backgroundColor      = [UIColor whiteColor];
        [m_tipsWin_view addSubview:centerView];
        [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(m_tipsWin_view.mas_left).with.offset(kWidth(32));
            make.right.equalTo(m_tipsWin_view.mas_right).with.offset(-kWidth(32));
            make.height.mas_offset(kWidth(284));
            make.centerY.equalTo(m_tipsWin_view.mas_centerY);
        }];
        
        UILabel* title = [UILabel new];
        title.text          = @"温馨提示";
        title.textColor     = RGBA(34, 39, 39, 1);
        title.textAlignment = NSTextAlignmentCenter;
        title.font          = KBFONT(16);
        [centerView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(centerView);
            make.top.equalTo(centerView.mas_top).with.offset(kWidth(16));
            make.height.mas_offset(kWidth(16));
        }];
        
        UILabel* subTitle = [UILabel new];
        NSString* str = @"在抽奖完成之后，请点击\"免费领取\"或\"马上注册\"之类的按钮5s后才能领取奖励哦";
        NSString* str_one = @"\"免费领取\"";
        NSString* str_two = @"\"马上注册\"";
        NSMutableAttributedString* att  = [[NSMutableAttributedString alloc] initWithString:str];
        att                             = [LabelHelper GetMutableAttributedSting_color:att AndIndex:0 AndCount:str.length AndColor:RGBA(34, 39, 39, 1)];
        att                             = [LabelHelper GetMutableAttributedSting_font:att AndIndex:0 AndCount:str.length AndFontSize:kWidth(14)];
        att                             = [LabelHelper GetMutableAttributedSting_color:att AndIndex:[str rangeOfString:str_one].location AndCount:str_one.length AndColor:RGBA(0, 136, 255, 1)];
        att                             = [LabelHelper GetMutableAttributedSting_color:att AndIndex:[str rangeOfString:str_two].location AndCount:str_two.length AndColor:RGBA(0, 136, 255, 1)];
        subTitle.attributedText = att;
        subTitle.numberOfLines = 0;
        subTitle.textAlignment  = NSTextAlignmentLeft;
        [centerView addSubview:subTitle];
        [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(centerView.mas_left).with.offset(kWidth(16));
            make.right.equalTo(centerView.mas_right).with.offset(-kWidth(16));
            make.top.equalTo(title.mas_bottom).with.offset(kWidth(16));
        }];
        
        UIImageView* imgV   = [UIImageView new];
        [imgV setImage:[UIImage imageNamed:@"choujiangTips"]];
        [centerView addSubview:imgV];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(centerView.mas_left).with.offset(kWidth(16));
            make.right.equalTo(centerView.mas_right).with.offset(-kWidth(16));
            make.top.equalTo(subTitle.mas_bottom).with.offset(kWidth(16));;
            make.height.mas_offset(kWidth(112));
        }];
        
        UIButton* iKnow_btn = [UIButton new];
        [iKnow_btn setTitle:@"我知道了" forState:UIControlStateNormal];
        [iKnow_btn setTitleColor:RGBA(34, 39, 39, 1) forState:UIControlStateNormal];
        [iKnow_btn setBackgroundColor:RGBA(248, 205, 4, 1)];
        [iKnow_btn.titleLabel setFont:kFONT(14)];
        [iKnow_btn addTarget:self action:@selector(iknow_action) forControlEvents:UIControlEventTouchUpInside];
        [iKnow_btn.layer setCornerRadius:3.0f];
        [centerView addSubview:iKnow_btn];
        [iKnow_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(centerView.mas_left).with.offset(kWidth(16));
            make.right.equalTo(centerView.mas_right).with.offset(-kWidth(16));
            make.top.equalTo(imgV.mas_bottom).with.offset(kWidth(16));
            make.height.mas_offset(kWidth(40));
        }];
        
    }
}

-(void)iknow_action{
    [m_tipsWin_view removeFromSuperview];
}

-(void)initNavi{
    UIView* navibar_view = [[UIView alloc] initWithFrame:CGRectMake(0, StaTusHight, SCREEN_WIDTH, 56)];
    
    UIButton* back_button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
    [back_button setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [back_button setImage:[UIImage imageNamed:@"ic_nav_back"] forState:UIControlStateNormal];
    [back_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navibar_view addSubview:back_button];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-150/2, 18, 150, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"参与抽奖";
    title.font = [UIFont boldSystemFontOfSize:20];
    title.textColor = [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    [navibar_view addSubview:title];
    
    //line
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 56-1, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [navibar_view addSubview:line];
    
    [self.view addSubview:navibar_view];
    m_navibar_view = navibar_view;
}

-(void)initWeb{
    //进度条初始化
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width, 2)];
    self.progressView.progressTintColor = RGBA(248, 205, 4, 1);
    self.progressView.trackTintColor = [UIColor whiteColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [m_navibar_view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(m_navibar_view);
        make.height.mas_offset(kWidth(2));
        make.bottom.equalTo(m_navibar_view.mas_bottom);
    }];
    
    m_webView = [WKWebView new];
    m_webView.UIDelegate            = self;
    m_webView.navigationDelegate    = self;
//    NSURL* url = [NSURL URLWithString:@"https://cpu.baidu.com/1033/ea61450f?scid=10463"];
//    NSURLRequest* request = [NSURLRequest requestWithURL:url];
//    [m_web loadRequest:request];
    [self.view addSubview:m_webView];
    [m_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(m_navibar_view.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [m_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)loadWeb{
    if(UrlIndex+1 < m_array_url.count){
        UrlIndex++;
    }
    else{
        UrlIndex = 0;
    }
    NSLog(@"UrlIndex:%d",UrlIndex);
    choujiang_model* model = m_array_url[UrlIndex];
    m_choujiang_model = model;
    NSURL* url = [NSURL URLWithString:model.url];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [m_webView loadRequest:request];
}

#pragma mark - webview协议
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = m_webView.estimatedProgress;
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
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSString* url_now = navigationResponse.response.URL.absoluteString;
    NSRange range = [url_now rangeOfString:m_choujiang_model.keyword];
    if (range.location != NSNotFound) {
        NSLog(@"抽奖完成");
        m_isGuanggao_url = YES;
        
    }
    else{
        NSLog(@"匹配失败");
    }
    
//    return YES;
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}

-(void)repeatShowTime{
    
    if(m_time_count == 3 ){
        m_choujiang_isDone = YES;
        [self.timer invalidate];
        NSLog(@"抽奖奖励 完成");
    }
    else{
        m_time_count++;
    }
    
}

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [m_navibar_view bringSubviewToFront:self.progressView];
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    //加载完成后隐藏progressView
    self.progressView.hidden = YES;
    
    if(m_isGuanggao_url){
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(repeatShowTime) userInfo:nil repeats:YES];
    }
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
    [MyMBProgressHUD showMessage:@"加载失败!"];
    
    if(m_isGuanggao_url){
        m_choujiang_isDone = NO;
    }
}

#pragma mark - 按钮方法
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - API
-(void)getUrlByAPI{
    [InternetHelp choujiang_API_Sucess:^(NSArray *dic) {
        m_array_url = [choujiang_model dicToArray:dic];
        [self loadWeb];
    } Fail:^(NSArray *dic) {
        [MyMBProgressHUD ShowMessage:@"网络错误" ToView:self.view AndTime:1.0f];
    }];
}

@end
