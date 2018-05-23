
// 顶部导航栏
// 视图




#import "SCNavTabBarController.h"
#import "SCNavTabBar.h"
#import "WeatherViewController.h"
#import "SocietyViewController.h"
#import "OtherNewsViewController.h"

#import "ChannelName.h"
#import "UrlModel.h"
#import "Search_ViewController.h"
#import "DateReload_view.h"
#import "CJZdataModel.h"
#import "IndexOfNews.h"
#import "Channel_guanli_ViewController.h"
#import "FloatView.h"
#import "Mine_login_ViewController.h"


@interface SCNavTabBarController () <UIScrollViewDelegate, SCNavTabBarDelegate,Channel_guanli_SCNavTabBar_Delegate>
{
    NSInteger       _currentIndex;
    NSMutableArray  *_titles;
    CGFloat         m_naviHeight;
    
    UIView*         m_logoView;
    UIView*         m_searchView;
    UIButton*       m_boxBtn;
    UIImageView*    m_box_timeTips;
    UILabel*        m_time_label;
    NSInteger         m_timer_count;
    NSTimer*        m_timer;
    
    SCNavTabBar     *_navTabBar;
    UIScrollView    *_mainView;
    
    DateReload_view*         m_reload_view;
    UIActivityIndicatorView* m_waiting;
    NSInteger       m_selected_index;
    
    FloatView*      m_boxView;
    UIView*         m_boxWin;
    BOOL            m_isShowBox;
    BOOL            m_VCL_isShow;
}



@end

@implementation SCNavTabBarController

-(NSMutableArray *)naviItemNames{
    if(!_naviItemNames){
        _naviItemNames = [[NSMutableArray alloc] init];
    }
    return _naviItemNames;
}
-(NSMutableArray *)naviItems{
    if(!_naviItems){
        _naviItems = [[NSMutableArray alloc] init];
    }
    return _naviItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_naviHeight = kWidth(32);
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    //监听夜间模式的改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleThemeChanged) name:Notice_Theme_Changed object:nil];
    
    //监听数据加载情况
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DownloadedData:) name:@"dataLoaded" object:nil]; //成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DownloadedDataFailed) name:@"netFailed" object:nil]; //失败
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(initNavi) name:@"Society_SCNavi_订阅" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showBoxWin:) name:@"InternetHelp_SCNavi_openBox" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(IsShowBox) name:@"TaskVCL_SCNaci_宝箱重置提醒" object:nil];
    
    [self initWaiting];
    
    if([UrlModel Share].url_array.count > 0){
        [self initControl];
        [self initConfig];
        [self viewConfig];
    }else{
        [self initNaviBarItem];
    }
}

-(void)initWaiting{
    m_waiting = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2/-100/2, SCREEN_HEIGHT/2-100/2, SCREEN_WIDTH, SCREEN_WIDTH)];
    m_waiting.center = self.view.center;
//    [m_waiting setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [m_waiting setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [m_waiting setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:m_waiting];
    [m_waiting startAnimating];
}

-(void)initReloadView{
    
    [m_reload_view removeFromSuperview];
    
    DateReload_view* reload_view = [[DateReload_view alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [reload_view.button addTarget:self action:@selector(Button_reload) forControlEvents:UIControlEventTouchUpInside];
    m_reload_view = reload_view;
    
    [self.view addSubview:reload_view];
}

-(void)DownloadedData:(NSNotification*)noti{
    dispatch_async(dispatch_get_main_queue(), ^{
        [m_waiting stopAnimating];
        [self initControl];
        [self initConfig];
        [self viewConfig];
    });
}

-(void)DownloadedDataFailed{
    //从本地获取数据
    NSDictionary* data = [[AppConfig sharedInstance] getUrlNews];
    NSArray* array = [ChannelName JsonToChannel:data[@"list"]];
    
    if(array.count > 0){
        self.naviItems = [NSMutableArray arrayWithArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showView];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_waiting stopAnimating];
            [self initReloadView];
        });
    }
}

-(void)initNavi{
    NSMutableArray* array = [NSMutableArray array];
    NSMutableArray* array_titles = [NSMutableArray array];

    NSLog(@"channel_array count:%ld",[IndexOfNews share].channel_array.count);
    //排序和添加
    for (int i=0; i<[IndexOfNews share].channel_array.count; i++) {
        ChannelName* channel_name = [IndexOfNews share].channel_array[i];
        NSString* now_id = channel_name.ID;
        BOOL isHave = NO;
        SocietyViewController* item = nil;
        for (int j=0; j<_subViewControllers.count; j++) {
            SocietyViewController* vc = _subViewControllers[j];
            NSString* channel_id = vc.channel_id;
            if([now_id isEqualToString:channel_id]){
                isHave = YES;
                item = vc;
                break;
            }else{
                
            }
        }
        
        if(isHave){
            if(item != nil){
                [array addObject:item];
            }
            
        }else{
            item = [[SocietyViewController alloc] init];
            item.channel_id = now_id;
            item.isNewChannel = channel_name.isNewChannel;
            item.title = channel_name.title;
            [array addObject:item];
        }
        
        [array_titles addObject:channel_name.title];
    }
    
    _subViewControllers = array;
    _titles = array_titles;
    [_navTabBar removeFromSuperview];
    _navTabBar = [[SCNavTabBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_logoView.frame), SCREEN_WIDTH-kWidth(40) , m_naviHeight)];
    _navTabBar.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
    _navTabBar.topMargin = kWidth(32)/2-kWidth(16)/2;
    _navTabBar.delegate = self;
    _navTabBar.lineColor = RGBA(255, 129, 3, 1);;
    _navTabBar.itemTitles = _titles;
    [_navTabBar updateDataAgain];
    [self.view addSubview:_navTabBar];
    
    _navTabBar.selectedIndex = [IndexOfNews share].index;
    _mainView.contentSize = CGSizeMake([IndexOfNews share].channel_array.count * SCREEN_WIDTH, 0);

}

-(void)naviSelectedIndex:(NSInteger)index{
    m_selected_index = index;
    _navTabBar.selectedIndex = m_selected_index;
}

-(void)showView{
    [self initControl];
    [self initConfig];
    [self viewConfig];
}

-(void)initControl{
    
//    NSArray *namearray = [NSArray array];
//    namearray = @[@"国内",@"国际",@"娱乐",@"体育",@"科技",@"奇闻趣事",@"生活健康"];
//    NSArray *contentarray = [NSArray array];
//    contentarray = @[@"guonei",@"world",@"huabian",@"tiyu",@"keji",@"qiwen",@"health"];
    
    NSMutableArray *viewArray = [NSMutableArray array];
//    self.naviItems = [[NSMutableArray alloc] initWithArray:(NSMutableArray*)[UrlModel Share].url_array];
    SocietyViewController *oneViewController = [[SocietyViewController alloc] init];
    ChannelName* item = _naviItems[0];
    oneViewController.channel_id = item.ID;
    oneViewController.isNewChannel = item.isNewChannel;
    oneViewController.title = item.title;
    [viewArray addObject:oneViewController];
    
    for(int i = 1; i < _naviItems.count; i++)
    {
        SocietyViewController *otherViewController = [[SocietyViewController alloc] init];
        ChannelName* channelName = _naviItems[i];
        otherViewController.title = channelName.title;
        otherViewController.channel_id = channelName.ID;
        otherViewController.isNewChannel = channelName.isNewChannel;
        [viewArray addObject:otherViewController];
    }
    
    _subViewControllers = [NSArray array];
    _subViewControllers = viewArray;
}

- (void)initConfig
{
    _currentIndex = 1;

    _titles = [[NSMutableArray alloc] initWithCapacity:_subViewControllers.count];

    for (UIViewController *viewController in _subViewControllers)
    {
        [_titles addObject:viewController.title];
    }
}


- (void)viewConfig
{
    [self viewInit];
    
    //首先加载第一个视图
    UIViewController *viewController = (UIViewController *)_subViewControllers[0];
    viewController.view.frame = CGRectMake(0 , 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [_mainView addSubview:viewController.view];
    [self addChildViewController:viewController];
    
    [IndexOfNews share].index = 0;
    
    
    [self IsShowBox];//是否显示宝箱提醒
}

- (void)viewInit
{
    [self initLogoView];
    
    _navTabBar = [[SCNavTabBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_logoView.frame), SCREEN_WIDTH-kWidth(40) , m_naviHeight)];
    _navTabBar.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
    _navTabBar.delegate = self;
    _navTabBar.topMargin = kWidth(32)/2-kWidth(16)/2;
    _navTabBar.lineColor = RGBA(255, 129, 3, 1);;
    _navTabBar.itemTitles = _titles;
    [_navTabBar updateData];
    [self.view addSubview:_navTabBar];
    
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_navTabBar.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_navTabBar.frame))];
    _mainView.delegate = self;
    _mainView.pagingEnabled = YES;
    _mainView.bounces = _mainViewBounces;
    _mainView.showsHorizontalScrollIndicator = NO;
    _mainView.showsVerticalScrollIndicator = NO;
    _mainView.contentSize = CGSizeMake(SCREEN_WIDTH * _subViewControllers.count, 0);
    [self.view addSubview:_mainView];
    
    UIView *linev = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_navTabBar.frame), SCREEN_WIDTH, 1)];
    linev.backgroundColor = [UIColor colorWithRed:216/255.0f green:216/255.0f blue:216/255.0f alpha:1];
    [self.view addSubview:linev];
    
    //搜索
//    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, StaTusHight, kWidth(40), kWidth(44))];
////    btn.backgroundColor = [UIColor greenColor];
//    [btn setImage:[UIImage imageNamed:@"ic_nav_search"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
    
    //频道添加
    UIButton *addChannel = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kWidth(40), CGRectGetMaxY(m_logoView.frame), 40, kWidth(40))];
    //    btn.backgroundColor = [UIColor greenColor];
    [addChannel setImage:[UIImage imageNamed:@"ic_nav_more"] forState:UIControlStateNormal];
    [addChannel addTarget:self action:@selector(EditChannel) forControlEvents:UIControlEventTouchUpInside];
    addChannel.imageEdgeInsets = UIEdgeInsetsMake(0, 0, kWidth(40)-kWidth(14), 0);
    [self.view addSubview:addChannel];
    
}

-(void)initLogoView{
    UIView* logoView = [[UIView alloc] initWithFrame:CGRectMake(0, StaTusHight, SCREEN_WIDTH, kWidth(48))];
    logoView.backgroundColor = [UIColor whiteColor];
    m_logoView = logoView;
    [self.view addSubview:logoView];
    
    UIImageView* img_logo = [UIImageView new];
    [img_logo setImage:[UIImage imageNamed:@"icon_nav_icon"]];
    [logoView addSubview:img_logo];
    [img_logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(kWidth(16));
        make.top.equalTo(self.view.mas_top).offset(StaTusHight+kWidth(14));
        make.width.mas_offset(kWidth(82));
        make.height.mas_offset(kWidth(20));
    }];
    
    UIButton* searchView = [UIButton new];
    m_searchView = searchView;
    searchView.backgroundColor = RGBA(242, 242, 242, 1);
    [searchView addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [searchView.layer setCornerRadius:kWidth(28)/2];
    searchView.layer.masksToBounds = YES;
    [logoView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img_logo.mas_right).offset(kWidth(10));
        make.top.equalTo(logoView.mas_top).offset(kWidth(10));
        make.bottom.equalTo(logoView.mas_bottom).offset(-kWidth(10));
        make.right.equalTo(logoView.mas_right).offset(-kWidth(52));
    }];
    
    UIImageView* img = [UIImageView new];
    [img setImage:[UIImage imageNamed:@"ic_nav_search2"]];
    [searchView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchView.mas_left).offset(kWidth(10));
        make.width.and.height.mas_offset(kWidth(12));
        make.centerY.equalTo(searchView.mas_centerY);
    }];
    
    UILabel* tips = [UILabel new];
    tips.text                   = @"搜索你感兴趣的内容";
    tips.textColor              = RGBA(167, 169, 169, 1);
    tips.textAlignment          = NSTextAlignmentLeft;
    tips.font                   = kFONT(12);
    [searchView addSubview:tips];
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img.mas_right).offset(kWidth(10));
        make.height.mas_offset(kWidth(12));
        make.centerY.equalTo(searchView.mas_centerY);
    }];
}

-(void)searchClick
{
//    WeatherViewController *vc = [[WeatherViewController alloc]init];
    
    Search_ViewController* vc = [[Search_ViewController alloc] init];
    vc.type = SearchType_news;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)EditChannel{
    Channel_guanli_ViewController* vc = [[Channel_guanli_ViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)IsShowBox{
//    if(![Login_info share].isLogined){
//        return;
//    }
    
    //获取保存时间点
    NSInteger time_start = [[AppConfig sharedInstance] getBoxTime];
    //获取当前 时间点
    NSInteger time_now = [[NSDate date] timeIntervalSince1970];
    
    //时间差
    NSInteger count = time_now - time_start;
    
    if(count > BoxTime){
        if(m_boxView != nil){ //当隐藏时
            [m_boxView setHidden:NO];
            return;
        }
        //显示宝箱
        if(m_boxBtn == nil){ //防止广播多次
            [m_box_timeTips removeFromSuperview];
            m_box_timeTips = nil;
            
            UIButton* boxBtn = [UIButton new];
            [boxBtn addTarget:self action:@selector(boxOpenBtn_action) forControlEvents:UIControlEventTouchUpInside];
            m_boxBtn = boxBtn;
            UIImage* img_box = [UIImage animatedImageWithImages:@[[UIImage imageNamed:@"ic_nav_box_change"],[UIImage imageNamed:@"ic_nav_box"]] duration:0.5f];
            [boxBtn setImage:img_box forState:UIControlStateNormal];
            [m_logoView addSubview:boxBtn];
            [boxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.and.height.mas_offset(kWidth(24));
                make.right.equalTo(m_logoView.mas_right).offset(-kWidth(16));
                make.centerY.equalTo(m_logoView.mas_centerY);
            }];
            
            [m_searchView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(m_boxBtn.mas_left).offset(-kWidth(10));
            }];
        }
        
//        UITabBarController *tabBarVC = [[UITabBarController alloc] init];//(这儿取你当前tabBarVC的实例)
//        CGFloat tabBarHeight = tabBarVC.tabBar.frame.size.height;
//        m_boxView = [[FloatView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80-10, SCREEN_HEIGHT-90-tabBarHeight*2-10, 80, 90)];
//        [m_boxView.close_btn addTarget:self action:@selector(boxClosebtn_action) forControlEvents:UIControlEventTouchUpInside];
//        [m_boxView.box_btn addTarget:self action:@selector(boxOpenBtn_action) forControlEvents:UIControlEventTouchUpInside];
//        [[UIApplication sharedApplication].keyWindow addSubview:m_boxView];
//        if(!m_VCL_isShow){
//            [m_boxView setHidden:YES];
//        }
        
    }else{
        //显示倒计时
        [m_boxBtn removeFromSuperview];
        m_boxBtn = nil;
        
        [self initBoxTimeTips];
        
    }
}

-(void)initBoxTimeTips{
    if(m_box_timeTips != nil){
        return;
    }
    m_box_timeTips = [UIImageView new];
    [m_box_timeTips setImage:[UIImage imageNamed:@"countdown"]];
    [m_logoView addSubview:m_box_timeTips];
    [m_box_timeTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(m_logoView.mas_right).offset(-kWidth(16));
        make.height.mas_offset(kWidth(25));
        make.width.mas_offset(kWidth(60));
        make.centerY.equalTo(m_logoView.mas_centerY);
    }];
    
    UILabel* time_label = [UILabel new];
    m_time_label = time_label;
    time_label.text                 = @"";
    time_label.textColor            = RGBA(255, 255, 255, 1);
    time_label.textAlignment        = NSTextAlignmentRight;
    time_label.font                 = kFONT(10);
    [m_box_timeTips addSubview:time_label];
    [time_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(m_box_timeTips.mas_right).offset(-kWidth(5));
        make.height.mas_offset(kWidth(11));
//        make.width.mas_offset(kWidth(26));
        make.centerY.equalTo(m_box_timeTips.mas_centerY);
    }];
    
    [m_searchView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(m_logoView.mas_right).offset(-kWidth(82));
    }];
    
    [self Label_time_show];
}

-(void)Label_time_show{
    //获取保存时间点
    NSInteger time_start = [[AppConfig sharedInstance] getBoxTime];
    //获取当前 时间点
    NSInteger time_now = [[NSDate date] timeIntervalSince1970];
    
    if(time_start == 0){
        m_timer_count = BoxTime;
        [[AppConfig sharedInstance] saveBoxTime:time_now];
    }else{
        NSInteger count = time_now - time_start;
        if(count < BoxTime ){
            m_timer_count = BoxTime-count;
        }else{
            m_timer_count = BoxTime;
            [[AppConfig sharedInstance] saveBoxTime:0];
        }
    }
    
    //直接就开始显示倒计时时间 不用等1秒
//    NSInteger hour = m_timer_count / 3600;
    NSInteger min = m_timer_count / 60;
    if(min >= 60){
        min = min%60;
    }
    NSInteger sec = m_timer_count % 60;
//    m_logo_hour_lable.text = [NSString stringWithFormat:@"%02ld",hour];
//    m_logo_min_lable.text = [NSString stringWithFormat:@"%02ld",min];
//    m_logo_second_lable.text = [NSString stringWithFormat:@"%02ld",sec];
    m_time_label.text = [NSString stringWithFormat:@"%02ld:%02ld",min,sec];
    
    m_timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if(m_timer_count <= 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                if(m_timer_count <= 0){
                    [m_timer invalidate];
                    //保存时间
                    [[AppConfig sharedInstance] saveBoxTime:0];
                    [self IsShowBox];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskVCL_SCNaci_宝箱重置提醒" object:nil];
                }
            });
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                m_timer_count--;
//                NSInteger hour = m_timer_count/3600;
                NSInteger min = m_timer_count/60;
                if(min >= 60){
                    min = min%60;
                }
                NSInteger sec = m_timer_count%60;
                m_time_label.text = [NSString stringWithFormat:@"%02ld:%02ld",min,sec];
                
            });
        }
    }];
    
    //当手指在屏幕时，nstimer停止运行 参考：https://www.cnblogs.com/6duxz/p/4633741.html
    [[NSRunLoop mainRunLoop] addTimer:m_timer forMode:NSRunLoopCommonModes];
}

-(void)boxOpenBtn_action{
    if(![Login_info share].isLogined){
//        [MyMBProgressHUD ShowMessage:@"请登录!" ToView:self.view AndTime:1.0f];
        Mine_login_ViewController* vc = [Mine_login_ViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    //非绑定设备不能执行任务
        if([[Login_info share].userInfo_model.device_mult_user integerValue] == NotTheDevice){
            [MyMBProgressHUD ShowMessage:@"非绑定设备，不能执行任务" ToView:self.view AndTime:1.0f];
            return;
        }

    
    NSString* box_taskId = [Md5Helper Box_taskId:[Login_info share].userInfo_model.user_id];
    [InternetHelp SendTaskId:box_taskId AndType:Task_box Sucess:^(NSInteger type, NSDictionary *dic) {
        if(type == Task_box){
            NSString* coin = dic[@"list"][@"reward_coin"];
            [self showBoxWin:coin];
            [self IsShowBox];
        }
    } Fail:^(NSDictionary *dic) {
        NSLog(@"SCNAv-宝箱任务上传失败");
    }];
    m_isShowBox = YES;
}

-(void)showBoxWin:(NSString*)coin{
    
//    NSString* coin = noti.object;
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 10, 10)];
    view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];
    
    //背景
    UIView* blackground_view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 10, 10)];
    blackground_view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];
    blackground_view.alpha = 0.6;
    
    //图片
    CGFloat img_width = SCREEN_WIDTH-30-30;
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 109, img_width, img_width)];
    [imgView setImage:[UIImage imageNamed:@"box_open"]];
    [view addSubview:imgView];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame)+16, SCREEN_WIDTH, 14)];
    label.text = @"恭喜您获得金币";
    label.textColor = [[ThemeManager sharedInstance] TaskGetTitleSmallLableColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:14];
    [view addSubview:label];
    
    UILabel* number = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)+16, SCREEN_WIDTH, 24)];
    number.text = [NSString stringWithFormat:@"+%@",coin];
    number.textColor = [[ThemeManager sharedInstance] TaskGetTitleBigLableColor];
    number.textAlignment = NSTextAlignmentCenter;
    number.font = [UIFont fontWithName:@"Arial Rounded MT Bold"  size:(24.0)];
    [view addSubview:number];
    
    UIButton* closeButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-120/2, CGRectGetMaxY(number.frame)+16, 120, 36)];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    closeButton.layer.cornerRadius = 18.0;
    closeButton.clipsToBounds = YES;
    [closeButton addTarget:self action:@selector(closeBoxWind) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:closeButton];
    
    [self.view addSubview:view];
    m_boxWin = view;
    
    [UIView animateWithDuration:0.05 animations:^{
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        view.frame = frame;
        [self.view layoutIfNeeded];
    }];
    
    //保存打开宝箱时间
    NSInteger date = [[NSDate date] timeIntervalSince1970];
    [[AppConfig sharedInstance] saveBoxTime:date];
    
    //通知任务界面 宝箱倒计时
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SCNavi_TaskVCL_宝箱倒计时" object:nil];
}

-(void)closeBoxWind{
    [m_boxWin removeFromSuperview];
}

#pragma mark - 按钮方法
-(void)Button_reload{
    [self initWaiting];
    
    [self initNaviBarItem];
}


#pragma mark - Scroll View Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
    _navTabBar.currentItemIndex = _currentIndex;
    [IndexOfNews share].index = _currentIndex;
//    NSLog(@"-scrollViewDidScroll-index2:%ld",[IndexOfNews share].index);

    /** 当scrollview滚动的时候加载下一个视图 --*/
    if(_currentIndex+1 == [IndexOfNews share].channel_array.count){
        return;
    }

    NSInteger next = _currentIndex+1;
    UIViewController *viewController = (UIViewController *)_subViewControllers[next];
    viewController.view.frame = CGRectMake(next * SCREEN_WIDTH, 0, SCREEN_WIDTH, _mainView.frame.size.height);
//    viewController.view.backgroundColor = [UIColor greenColor];
    [_mainView addSubview:viewController.view];
    [self addChildViewController:viewController];
    
    /** 当scrollview滚动的时候加载上一个视图 --*/
    if(_currentIndex-1 < 0){
        return;
    }

    NSInteger pre = _currentIndex - 1;
    UIViewController *viewController1 = (UIViewController *)_subViewControllers[pre];
    viewController1.view.frame = CGRectMake(pre * SCREEN_WIDTH, 0, SCREEN_WIDTH, _mainView.frame.size.height);
    //    viewController.view.backgroundColor = [UIColor greenColor];
    [_mainView addSubview:viewController1.view];
    [self addChildViewController:viewController1];

}




- (void)itemDidSelectedWithIndex:(NSInteger)index withCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex-index>=2 || currentIndex-index<=-2) {
        [_mainView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:NO];
    }else{
        [_mainView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:YES];
    }
    
    [IndexOfNews share].index = index;
    NSLog(@"-itemDidSelectedWithIndex-index1:%ld",[IndexOfNews share].index);
    _currentIndex = index;
    _navTabBar.currentItemIndex = index;
    /** 当scrollview滚动的时候加载当前视图 --*/
    NSInteger next = index;
    UIViewController *viewController = (UIViewController *)_subViewControllers[next];
    viewController.view.frame = CGRectMake(next * SCREEN_WIDTH, 0, SCREEN_WIDTH, _mainView.frame.size.height);
    //    viewController.view.backgroundColor = [UIColor greenColor];
    [_mainView addSubview:viewController.view];
    [self addChildViewController:viewController];
}



-(void)handleThemeChanged
{
    ThemeManager *defaultManager = [ThemeManager sharedInstance];
//    _navTabBar.backgroundColor = [defaultManager themeColor];
    _navTabBar.backgroundColor = [defaultManager GetBackgroundColor];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    m_VCL_isShow = YES;
    if(m_logoView != nil){
        [self IsShowBox];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)initNaviBarItem{
    
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/getChannel"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = @"POST";
//    NSString *args = [NSString stringWithFormat:@"json={\"%@\":\"%@\"}",@"user_id",@"814B08C64ADD12284CA82BA39384B177"];
//    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    IMP_BLOCK_SELF(SCNavTabBarController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(error || data == nil){
            NSLog(@"initNaviBarItem网络获取失败");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"netFailed" object:nil];
            return ;
        }
        
        NSLog(@"initNaviBarItem从服务器获取到数据");
        /*
         对从服务器获取到的数据data进行相应的处理.
         */
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        NSNumber* code = dict[@"code"];
        if([code integerValue] == 200){
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"netFailed" object:nil];
            return ;
        }
        NSArray *dataarray = [ChannelName JsonToChannel:dict[@"list"]];
        
        
        [IndexOfNews share].channel_all = dataarray;//保存导航信息
        //首次 只保留前10条信息
        dataarray = [self channel_check:dataarray];
        
        NSMutableArray *ChannelArray = [NSMutableArray array];
        for (ChannelName *data in dataarray) {
            [block_self.naviItems addObject:data];
            [ChannelArray addObject:data];
        }
        
        [[AppConfig sharedInstance] saveUrlNews:dict];//保存频道信息
        [UrlModel Share].url_array = ChannelArray;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dataLoaded" object:ChannelArray];

    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

-(NSArray*)channel_check:(NSArray*)array{
    //查看存储的频道信息
    //有：将其他频道放在更多频道列表中
    //没有:只保留前10条，其他放在更多频道列表中
//    [[AppConfig sharedInstance] saveChannel:nil];
    NSArray* channel_array = [[AppConfig sharedInstance] getChannel];
    if(channel_array.count == 0){
        NSMutableArray* tmp = [NSMutableArray array];
        NSMutableArray* tmp_more = [NSMutableArray array];
        for(int i=0;i<array.count;i++){
             ChannelName* channel = array[i];
            if(i<10){
                [tmp addObject:channel];
            }else{
                [tmp_more addObject:channel];
            }
        }
        [IndexOfNews share].channel_array = tmp;
        [IndexOfNews share].channel_more_array = tmp_more;
        return tmp;
    }else{
        NSMutableArray* array_tmp = [NSMutableArray array];
        NSMutableArray* array_more = [NSMutableArray array];
        for (ChannelName* item in array) {
            BOOL isHave = NO;
            for (ChannelName* item_tmp in channel_array) {
                
                if([item.ID isEqualToString:item_tmp.ID]){
                    isHave = YES;
                    break;
                }else{
                    //如果是新添加频道，就直接添加到显示频道中
                    if(item_tmp.isNewChannel){
                        BOOL isHaveNewChannel = NO;
                        for (ChannelName* item_tmp1 in array_tmp) { //防止重复添加新频道
                            if([item_tmp1.title isEqualToString:item_tmp.title]){
                                isHaveNewChannel = YES;
                                break;
                            }
                        }
                        if(!isHaveNewChannel){
                            [array_tmp addObject:item_tmp];
                        }
                    }
                }
            }
            if(isHave){
                [array_tmp addObject:item];
            }else{
                [array_more addObject:item];
            }
        }
        
        [IndexOfNews share].channel_array = array_tmp;
        [IndexOfNews share].channel_more_array = array_more;
        return channel_array;
    }
}

//无用函数-test
-(void)initNaviBarItem_test{
    IMP_BLOCK_SELF(SCNavTabBarController);
    [[BaseEngine shareEngine] runRequestWithPara:nil path:@"http://younews.3gshow.cn/api/getChannel?json={\"user_id\":\"814B08C64ADD12284CA82BA39384B177\"}" success:^(id responseObject) {
        
        NSArray *dataarray = [ChannelName objectArrayWithKeyValuesArray:responseObject];
        NSMutableArray *ChannelArray = [[NSMutableArray alloc]initWithCapacity:40];
        NSMutableArray *ChannelNameArray = [[NSMutableArray alloc]initWithCapacity:40];
        for (ChannelName *data in dataarray) {
            [ChannelArray addObject:data];
        }
        
//        dispatch_async(dispatch_get_main_queue(), ^{
            block_self.naviItemNames =ChannelNameArray;
            block_self.naviItems = [[NSMutableArray alloc] initWithArray:ChannelArray];
            NSLog(@"naviitemnames-->%@",block_self.naviItemNames);
            NSLog(@"self naviitems count-->%ld",block_self.naviItems.count);
        [UrlModel Share].url_array = ChannelArray;
        
        [[AppConfig sharedInstance] saveUrlNews:responseObject];
        
        [m_waiting stopAnimating];
            
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dataLoaded" object:ChannelArray];
            
        
//        });
        
    } failure:^(id error) {
        NSLog(@"navi items failed");
        
        [m_waiting stopAnimating];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"netFailed" object:nil];
    }];
}
@end
