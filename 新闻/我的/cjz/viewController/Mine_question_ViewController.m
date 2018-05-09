//
//  Mine_question_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_question_ViewController.h"
#import "Mine_question_TableViewController.h"
#import "Mine_question_model.h"

#define TimeCount 30
@interface Mine_question_ViewController ()<UIWebViewDelegate>

@end

@implementation Mine_question_ViewController{
    UIView*         m_navibar_view;
    NSArray*        m_question_array;
    NSArray*        m_array_hight;
    UIWebView*      m_webview;
    
    Mine_question_TableViewController* m_tableView;
    NSTimer*        m_timer;
    NSInteger       m_timer_count;
    UILabel*        m_timeLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavi];
//    [self initView];
    [self initWebview];
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
//    [edit_button setTitle:@"常见问题" forState:UIControlStateNormal];
//    [edit_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [edit_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
//    [edit_button addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
//    [navibar_view addSubview:edit_button];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-150/2, 18, 150, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"常见问题";
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
        [self initTime];
    }

    
    webview.scrollView.bounces = NO;
    webview.delegate = self;
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://toutiao.3gshow.cn/help.html"]];
    [webview loadRequest:request];
    
    [self.view addSubview:webview];
}

-(void)initTime{
    m_timer_count = TimeCount;
    
    UILabel* time_label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_webview.frame), SCREEN_WIDTH, 30)];
    time_label.text = [NSString stringWithFormat:@"%d s",TimeCount];
    time_label.textColor = [UIColor blackColor];
    time_label.textAlignment = NSTextAlignmentCenter;
    time_label.font = [UIFont boldSystemFontOfSize:14];
    [self.view addSubview:time_label];
    m_timeLabel = time_label;
    
    //    IMP_BLOCK_SELF(Agreement_ViewController)
    m_timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if(m_timer_count <= 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                m_timeLabel.text = [NSString stringWithFormat:@"任务完成"];
                m_timer_count = TimeCount;
                [m_timer invalidate];
                [m_timeLabel layoutIfNeeded];
                
                //任务类型  1:提供开宝箱  2：阅读文章 3：分享文章  4:优质评论 5：晒收入 6：参与抽奖任务  7：查看常见问题奖励 8：微信绑定奖励
                [[NSNotificationCenter defaultCenter] postNotificationName:@"任务完成157" object:[NSNumber numberWithInteger:Task_readQuestion]];
            });
        }else{
            m_timer_count--;
            dispatch_async(dispatch_get_main_queue(), ^{
                m_timeLabel.text = [NSString stringWithFormat:@"还有 %ld s 完成任务",m_timer_count];
            });
            [m_timeLabel layoutIfNeeded];
        }
    }];
    
    //当手指在屏幕时，nstimer停止运行 参考：https://www.cnblogs.com/6duxz/p/4633741.html
    [[NSRunLoop mainRunLoop] addTimer:m_timer forMode:NSRunLoopCommonModes];
}

-(void)initView{
    
    UIView* mainView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_navibar_view.frame)-StaTusHight,
                                                                SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(m_navibar_view.frame))];
    
    Mine_question_TableViewController* tableView = [[Mine_question_TableViewController alloc] init];
    m_tableView = tableView;
    [self getData];
    tableView.array_question = [[NSMutableArray alloc]initWithArray:m_question_array];
    
    [mainView addSubview:tableView.tableView];
    [self.view addSubview:mainView];
    
}

-(void)getData{
    NSMutableArray* array_question = [[NSMutableArray alloc] init];
    NSArray* array = @[@"考拉头条是什么？",
                       @"金币是什么？",
                       @"为什么阅读了却没有给金币？",
                       @"金币和人民币的兑换比例是怎样的？",
                       @"申请提现后多久可以到账？",
                       @"提现失败了怎么处理？",
                       @"邀请码是什么？如何收徒？",
                       @"收徒有什么好处？",
                       @"如何做到收益暴增？"];
    NSArray* array_content = @[@"考拉头条是一款资讯客户端，主打看新闻能赚钱，在你浏览新闻的同时获得收益。",
                               @"此处的金币是考拉头条里的虚拟货币。当天赚取的所有金币均可在第二天凌晨自动转换成零钱，并累计到你的钱包，可提现至你的现金账户。",
                               @"可能此次阅读被系统判定为无效阅读，比如快速频繁的浏览新闻、文章没有看完或者随意滚动屏幕，请重新正常的浏览新闻，认真阅读，保持平常心。",
                               @"金币和人民币的兑换比例和平台收支情况有关，昨日收益=昨日金币*昨日汇率/1000。也就是说平台收益越好，汇率就越高，同等的金币能兑换的人民币也就越多。",
                               @"一般当日18点前申请后当日可到账，否则次日到账。总的来说1~2日到账，节假日顺延。",
                               @"提现失败后你的钱会重新回到账号，请检查你的账号信息是否有误或者未实名制等，检查后重新申请提现即可。",
                               @"邀请码是考拉头条为每个用户设计的唯一ID，你可以使用你的邀请码去邀请别人一起玩考拉头条。别人填写你的邀请码代表你收徒成功，师徒都可获得相应的奖励，这里需要注意徒弟需要连续三天打开考拉头条才算有效哦。",
                               @"首次收徒你将额外获得现金红包，除了收徒红包之外，你的徒弟也将会获得一个现金红包，此外师傅还可获得徒弟收益的额外提成（不影响徒弟收徒）。",
                               @"想收益暴增，收徒是关键！！！另外坚持每天登录、阅读和分享，定时开启宝箱拿奖励！"];
    m_array_hight = @[@54,@54,@54,@54,@54,@54,@54,@54,@54];
    for(int i=0;i<array.count;i++){
        Mine_question_model* model = [[Mine_question_model alloc] init];
        model.requestion = array[i];
        model.answer = array_content[i];
        NSNumber* number = m_array_hight[i];
        model.hight = [number floatValue];
        [array_question addObject:model];
    }
    m_question_array = array_question;
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
