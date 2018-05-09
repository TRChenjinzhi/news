//
//  Video_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Video_ViewController.h"
#import "SCNavTabBar.h"
#import "Video_channel_ViewController.h"
#import "Video_detail_ViewController.h"
#import "Search_ViewController.h"
#import "DateReload_view.h"

@interface Video_ViewController ()<SCNavTabBarDelegate,UIScrollViewDelegate,video_channel_VCL_To_video_VCL>

@property (nonatomic,strong)SCNavTabBar* navTabBar;
@property (nonatomic,strong)UIScrollView* mainView;

@end

@implementation Video_ViewController{
    NSMutableArray*                m_tabBarTitles_array;
    NSMutableArray*         m_subView_array;
    NSArray*                m_channel_model_array;
    NSInteger               m_currentIndex;
    BOOL                    isLoaded;
    
    DateReload_view*        m_Reloaded_view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    m_subView_array = [NSMutableArray array];
    m_tabBarTitles_array = [NSMutableArray array];
    m_channel_model_array = [NSArray array];
    [self setUI];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self setUI];
    NSLog(@"scrollview origin.y=%f",_mainView.frame.origin.y);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUI{
//    m_tabBarTitles_array = @[@"视频1",@"视频2",@"视频3",@"视频4",@"视频5",@"视频6",@"视频7",@"视频8",@"视频9"];
//    [self initSubview];
//    [self initTabBar];
//    [self initScrollview];
    if(!isLoaded){
        IMP_BLOCK_SELF(Video_ViewController)
        [InternetHelp Video_channel_API_Sucess:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                m_channel_model_array = [video_channel_model dicToArray:dic];
                //保存视频频道信息
                [[AppConfig sharedInstance] saveUrlVideo:dic];
                [block_self initSubview];
                [block_self initTabBar];
                [block_self initScrollview];
                
                [m_Reloaded_view removeFromSuperview];
            });
        } Fail:^(NSDictionary *dic) {
            NSDictionary* dic_tmp = [[AppConfig sharedInstance] getUrlVideo];
            m_channel_model_array = [video_channel_model dicToArray:dic_tmp];
            if(m_channel_model_array.count > 0){
                [block_self initSubview];
                [block_self initTabBar];
                [block_self initScrollview];
            }
            else{
                [self GetNetFailed];
            }
        }];
        isLoaded = YES;
    }
}

-(void)initSubview{
    for (int i=0;i<m_channel_model_array.count;i++) {
        video_channel_model* model = m_channel_model_array[i];
        Video_channel_ViewController* vc = [[Video_channel_ViewController alloc] init];
        vc.delegate = self;
        vc.model = model;
        vc.view.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        vc.view.backgroundColor = i%2 ? [UIColor redColor] : [UIColor blackColor];
        [m_subView_array addObject:vc];
        [m_tabBarTitles_array addObject:model.title];
    }
}

-(void)initTabBar{
    _navTabBar = [[SCNavTabBar alloc] initWithFrame:CGRectMake(kWidth(40), StaTusHight, SCREEN_WIDTH-kWidth(40) , kWidth(44))];
    _navTabBar.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
//    _navTabBar.backgroundColor = [UIColor blueColor];
    _navTabBar.delegate = self;
    _navTabBar.lineColor = RGBA(248, 205, 4, 1);
    _navTabBar.itemTitles = m_tabBarTitles_array;
    [_navTabBar updateData];
    [self.view addSubview:_navTabBar];
    
    //搜索
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, StaTusHight, 40, kWidth(44))];
    //    btn.backgroundColor = [UIColor greenColor];
    [btn setImage:[UIImage imageNamed:@"ic_nav_search"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
//    [self.view layoutIfNeeded];
}

-(void)searchClick{
    Search_ViewController* vc = [[Search_ViewController alloc] init];
    vc.type = SearchType_video;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)initScrollview{
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_navTabBar.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_navTabBar.frame))];
    _mainView.delegate = self;
    _mainView.pagingEnabled = YES;
    _mainView.bounces = NO;
    _mainView.showsHorizontalScrollIndicator = NO;
    _mainView.showsVerticalScrollIndicator = NO;
    _mainView.clipsToBounds = YES;
    _mainView.contentSize = CGSizeMake(SCREEN_WIDTH * m_subView_array.count, 0);
    [self.view addSubview:_mainView];
    [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_navTabBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT-64);
    }];
    
    //加载第一个界面
    Video_channel_ViewController* vc = m_subView_array[0];
    [_mainView addSubview:vc.view];
    
    m_currentIndex = 1;
    
    [self.view layoutIfNeeded];
}

-(void)GetNetFailed{
    [m_Reloaded_view removeFromSuperview];
    DateReload_view* view = [[DateReload_view alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    m_Reloaded_view = view;
    [m_Reloaded_view.button addTarget:self action:@selector(reloadNet) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_Reloaded_view];
}

-(void)reloadNet{
    isLoaded = NO;
    [self setUI];
}

#pragma mark - 协议
-(void)goToFullScreen:(video_info_model *)model{

}
-(void)video_channel_GoToDetail:(video_info_model *)model AndChannel:(video_channel_model*)channel_model{
    Video_detail_ViewController* vc  = [[Video_detail_ViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)shareMore:(video_info_model *)model{
    [self shareMore_InMainView:model];
}

-(void)shareMore_InMainView:(video_info_model*)m_share_model{
    //要分享的内容，加在一个数组里边，初始化UIActivityViewController
    NSString *textToShare = m_share_model.title;
    //    UIImageView* img = [[UIImageView alloc] init];
    //    [img sd_setImageWithURL:[NSURL URLWithString:m_share_model.cover]];
    UIImage *imageToShare = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:m_share_model.cover]]];
    NSURL *urlToShare = [NSURL URLWithString:[NSString stringWithFormat:@"%@",m_share_model.url]];
    NSArray *activityItems = @[urlToShare,textToShare,imageToShare];
    
    //    MyActivity* myActivity = [[MyActivity alloc] init];
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activity.excludedActivityTypes = @[];
    
    UIActivityViewControllerCompletionWithItemsHandler itemsBlock = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        NSLog(@"activityType == %@",activityType);
        if (completed == YES) {
            NSLog(@"原生分享回调 completed");
        }else{
            NSLog(@"原生分享回调 cancel");
        }
    };
    activity.completionWithItemsHandler = itemsBlock;
    
    // incorrect usage
    // [self.navigationController pushViewController:activity animated:YES];
    
    UIPopoverPresentationController *popover = activity.popoverPresentationController;
    if (popover) {
        popover.sourceView = self.view;
        popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    
    [self presentViewController:activity animated:YES completion:NULL];
    //    [self.navigationController pushViewController:activity animated:YES];
}


#pragma mark - Scroll View Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    m_currentIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
    _navTabBar.currentItemIndex = m_currentIndex;
    //    NSLog(@"-scrollViewDidScroll-index2:%ld",[IndexOfNews share].index);
    
    /** 当scrollview滚动的时候加载下一个视图 --*/
    if(m_currentIndex+1 == m_tabBarTitles_array.count){
        return;
    }
    
    NSInteger next = m_currentIndex+1;
    Video_channel_ViewController *viewController = (Video_channel_ViewController *)m_subView_array[next];
//    viewController.view.frame = CGRectMake(next * SCREEN_WIDTH, 0, SCREEN_WIDTH, _mainView.frame.size.height);
    //    viewController.view.backgroundColor = [UIColor greenColor];
    [_mainView addSubview:viewController.view];
//    [self addChildViewController:viewController];
    
    /** 当scrollview滚动的时候加载上一个视图 --*/
    if(m_currentIndex-1 < 0){
        return;
    }
    
    NSInteger pre = m_currentIndex - 1;
    Video_channel_ViewController *viewController1 = (Video_channel_ViewController *)m_subView_array[pre];
//    viewController1.view.frame = CGRectMake(pre * SCREEN_WIDTH, 0, SCREEN_WIDTH, _mainView.frame.size.height);
    //    viewController.view.backgroundColor = [UIColor greenColor];
    [_mainView addSubview:viewController1.view];
//    [self addChildViewController:viewController1];
    
}

- (void)itemDidSelectedWithIndex:(NSInteger)index withCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex-index>=2 || currentIndex-index<=-2) {
        [_mainView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:NO];
    }else{
        [_mainView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:YES];
    }
    
    m_currentIndex = index;
    _navTabBar.currentItemIndex = index;
    /** 当scrollview滚动的时候加载当前视图 --*/
    NSInteger next = index;
    Video_channel_ViewController *viewController = (Video_channel_ViewController *)m_subView_array[next];
//    viewController.view.frame = CGRectMake(next * SCREEN_WIDTH, 0, SCREEN_WIDTH, _mainView.frame.size.height);
    //    viewController.view.backgroundColor = [UIColor greenColor];
    [_mainView addSubview:viewController.view];
//    [self addChildViewController:viewController];
}

@end
