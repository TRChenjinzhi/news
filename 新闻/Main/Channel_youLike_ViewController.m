//
//  Channel_youLike_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Channel_youLike_ViewController.h"
#import "TabbarViewController.h"
#import "ChannelName.h"
#import "Button_color.h"
#import "AppConfig.h"
#import "JsonHelper.h"
#import "UrlModel.h"
#import "ChannelName.h"

@interface Channel_youLike_ViewController ()

@property (nonatomic,strong)UITapGestureRecognizer* m_tap;

@property (nonatomic,strong)NSMutableArray*        array_item;
@property (nonatomic,strong)NSMutableArray*        m_button_array;

@property (nonatomic,strong)NSArray*        names_youLike;

@end

@implementation Channel_youLike_ViewController{
    NSInteger       lineCount;
    BOOL            isGet;
    CAGradientLayer*    m_layer;
    Button_color*       m_GoTo_main;
}

-(NSMutableArray *)m_button_array{
    if(!_m_button_array){
        _m_button_array = [[NSMutableArray alloc] initWithCapacity:30];
    }
    return _m_button_array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowView) name:@"Channel_youLike" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IsGoToMain_enable) name:@"喜爱的频道选择" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    isGet = NO;
//    [self GetColorLayer:self.view.frame];
//    [self.view.layer addSublayer:m_layer];
    [self initView];
//    [self Item_Get];
    [self GetNews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initView{
    //跳过
    UILabel* Jump_label = [[UILabel alloc] initWithFrame:CGRectMake(0, StaTusHight+20, SCREEN_WIDTH-7, 16)];
    Jump_label.text = @"跳过 》";
    Jump_label.textColor = [UIColor colorWithRed:248/255.0 green:205/255.0 blue:4/255.0 alpha:1/1.0];
    Jump_label.textAlignment = NSTextAlignmentRight;
    Jump_label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:16];
    self.m_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GoToMainView)];
    [Jump_label addGestureRecognizer:self.m_tap];
    Jump_label.userInteractionEnabled = YES;
    [self.view addSubview:Jump_label];
}

-(void)ShowView{
    dispatch_async(dispatch_get_main_queue(), ^{
        
    
    lineCount = 0;
    if(!isGet){
        [self GetData];
    }
    
    //title
    UILabel* title_label = [[UILabel alloc] initWithFrame:CGRectMake(0, StaTusHight+120, SCREEN_WIDTH, 28)];
    title_label.text = @"选择你喜欢的频道";
    title_label.textColor =  [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    title_label.textAlignment = NSTextAlignmentCenter;
    title_label.font = [UIFont boldSystemFontOfSize:28];
    [self.view addSubview:title_label];
    
    //scrollView
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title_label.frame)+64,
                                                                              SCREEN_WIDTH,
                                                                              320)];
    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    //按钮
    for(int i=0;i<self.array_item.count;i++){
        NSInteger ori_y = 0;
        
        NSInteger bt_width = 72;
        NSInteger bt_hight = 40;
        NSInteger jiange = (SCREEN_WIDTH-21-21-4*bt_width)/3;
        lineCount = i/4;
        NSInteger margin = 21 + (i%4)*bt_width + (i%4)*jiange;
        NSLog(@"lineCount-->%ld",lineCount);
        Button_color* bt = [[Button_color alloc] initWithFrame:CGRectMake(margin, ori_y+lineCount*24+bt_hight*lineCount, bt_width, bt_hight)];

        ChannelName* channelName = self.array_item[i];
        [bt SetNormalButton:channelName.title];
        bt.isSelected = NO;
        bt.tag = i;
        
        [self.m_button_array addObject:bt];
        
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, bt_hight+lineCount*24+bt_hight*lineCount);
        [scrollView addSubview:bt];
    }
    [self.view addSubview:scrollView];
    
    //进入首页
    Button_color* Goto_Main = [[Button_color alloc] initWithFrame:CGRectMake(16, SCREEN_HEIGHT-40-44, SCREEN_WIDTH-16-16, 44)];
    [Goto_Main SetNormalButton:@"选好了，进入首页》"];
//    [Goto_Main.tap addTarget:self action:@selector(GoToMainView)];
    Goto_Main.title.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:16];
    [Goto_Main removeGestureRecognizer:Goto_Main.tap];//不允许点击
    [self.view addSubview:Goto_Main];
    m_GoTo_main = Goto_Main;
    
        
    });
}

#pragma mark - 按钮方法
-(void)GoToMainView{
    NSLog(@"GoToMainView");
    
    //保存喜爱频道信息
    [[AppConfig sharedInstance] saveChannelName_youLike:_names_youLike];
    
    TabbarViewController* tab_vc = [[TabbarViewController alloc] init];
    tab_vc.array_model = self.array_item;
    tab_vc.selectedIndex = 0;
    [self presentViewController:tab_vc animated:YES completion:nil];
}

-(void)GetNews{
    
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/getChannel"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = [NSString stringWithFormat:@"json={\"%@\":\"%@\"}",@"user_id",@"814B08C64ADD12284CA82BA39384B177"];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    IMP_BLOCK_SELF(Channel_youLike_ViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(error){
            NSLog(@"网络获取失败");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Channel_youLike" object:nil];
        }
        
        NSLog(@"从服务器获取到数据");
        /*
         对从服务器获取到的数据data进行相应的处理.
         */
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        NSArray *dataarray = [ChannelName objectArrayWithKeyValuesArray:dict[@"list"]];
        NSMutableArray *ChannelArray = [NSMutableArray array];
        for (ChannelName *data in dataarray) {
            [ChannelArray addObject:data];
        }
        block_self.array_item = ChannelArray;
        
//        [UrlModel Share].url_array = ChannelArray;
        
//        [[AppConfig sharedInstance] saveUrlNews:responseObject];
        
        isGet = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Channel_youLike" object:nil];
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

-(void)IsGoToMain_enable{
    
    NSMutableArray* names = [[NSMutableArray alloc] initWithCapacity:20];
    for (Button_color* item in self.m_button_array) {
        if(item.isSelected){
            [names addObject:item.title.text];
        }
    }
    _names_youLike = names;
    
    if(names.count > 0){
        m_GoTo_main.isSelected = YES;
        [m_GoTo_main ChangeToSelectedState];
        [m_GoTo_main.title removeGestureRecognizer:m_GoTo_main.tap];
        m_GoTo_main.tap = nil;
        m_GoTo_main.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GoToMainView)];
        [m_GoTo_main addGestureRecognizer:m_GoTo_main.tap];
    }else{
        m_GoTo_main.isSelected = NO;
        [m_GoTo_main ChangeToSelectedState];
        [m_GoTo_main removeGestureRecognizer:m_GoTo_main.tap];
    }
}

-(void)GetData{
    self.m_button_array = [[NSMutableArray alloc] initWithObjects:@"热点",@"娱乐",@"社会",@"网红",@"互联网",@"汽车",@"体育",@"财经",@"军事",@"搞笑",
                                                                    @"美女",@"图片",@"时尚",@"网红",@"NBA",@"房产",@"国际",@"历史",@"萌宠",@"养生",
                                                                    @"星座",@"电影",@"育儿",@"数码控",@"美食咖",@"教育",@"趣闻",@"科技",@"游戏",@"二次元",
                                                                    @"订阅",@"旅游",@"设计",@"人工智能",@"交通",@"歪楼",@"管理",@"创业",nil];
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
