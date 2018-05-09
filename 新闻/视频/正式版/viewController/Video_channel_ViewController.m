//
//  Video_channel_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Video_channel_ViewController.h"
#import "video_TableViewCell.h"
#import "collectvModel.h"
#import "ShareSettingView.h"
#import "ShareSetting_view.h"
#import "Tips_ViewController.h"
#import "DateReload_view.h"

@interface Video_channel_ViewController ()<UITableViewDelegate,UITableViewDataSource,video_info_model_To_video_info_VCL_protocol,MyPlayerView_ptotocl,shareSetting_protocol>
{
    UITableView*        m_tableview;
    NSInteger           m_page;
    NSMutableArray*     m_tableview_array;
    NSMutableArray*     m_cash_array;
    
    NSInteger           m_play_index;
    CGRect              rectInTableV;
    CGRect              rectInWindow;
    UIView*             m_superViewOfPlayer;
    
    MyPlayerView*       m_cell_playView;
    Tips_ViewController*tip_vc;
    
    DateReload_view*        m_Reloaded_view;
    
}
@property (nonatomic,strong)MyPlayerView* m_fullScreen_imgView;
@property (nonatomic,strong)MyPlayerView* m_playerView;
@property (nonatomic,strong)UIView* statusBar;
@property (nonatomic,strong)ShareSetting_view* share_View;

@end

@implementation Video_channel_ViewController{
    video_info_model*           m_share_model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    m_play_index = -1;
    [self setUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SaveVideos) name:@"AppDelegate_SocietyViewCtl" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUI{
    m_tableview = [UITableView new];
    m_tableview.delegate = self;
    m_tableview.dataSource = self;
    [m_tableview setSeparatorInset:UIEdgeInsetsZero];
    [m_tableview setLayoutMargins:UIEdgeInsetsZero];
    [m_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    m_tableview.estimatedRowHeight = kWidth(256);
    [m_tableview registerClass:[video_TableViewCell class] forCellReuseIdentifier:@"videl_tableviewCell"];
    [self.view addSubview:m_tableview];
    [m_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT-64-49);
    }];
    
    m_page = 0;
    IMP_BLOCK_SELF(Video_channel_ViewController);
    GYHHeadeRefreshController *header = [GYHHeadeRefreshController headerWithRefreshingBlock:^{
        if(!self.isSearchVC){
            [block_self Request_channelInfo:0];
        }
        else{
            [block_self Request_channelInfo_fromSearch:0];
        }
    }];
    //头部刷新视图设置
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    m_tableview.header = header;
    
//    [header beginRefreshing];
    
    m_tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if(!self.isSearchVC){
            if([self getCashArray]){//获取缓存数据
                [m_tableview reloadData];
                [m_tableview.footer endRefreshing];
                return ;
            }
            [block_self Request_channelInfo:m_page];
        }
        else{
            [block_self Request_channelInfo_fromSearch:m_page];
        }
    }];
    
    //添加缓存数据
    if(!self.isSearchVC){
        [self addTableView_data];
    }else{
        [header beginRefreshing];
    }
}

-(void)SaveVideos{
    //保存50条信息
    
    if(m_tableview_array.count < 50){ //保证保存最新的50信息
        if(m_cash_array.count > 0){
            for (video_info_model* model in m_cash_array) {
                if(m_tableview_array.count >= 50){
                    break;
                }
                [m_tableview_array addObject:model];
            }
        }
    }
    NSMutableArray* array = [video_info_model get50VideosFromArray:m_tableview_array];
    [[AppConfig sharedInstance] saveVideo:self.model.channel_id AndArray:array];
}

-(void)addTableView_data{
    m_page = 1;//当有缓存的时候
    //是否有缓存数据 有：直接赋值 没有：刷新获得数据
    m_cash_array = [NSMutableArray arrayWithArray:[[AppConfig sharedInstance] getVideo:self.model.channel_id]];
    if(m_cash_array.count > 0){
        [self getCashArray];
        [m_tableview reloadData];
        //        [self IsRefresh];
    }else{
        [m_tableview.header beginRefreshing];
    }
}

-(BOOL)getCashArray{
    if(m_tableview_array == nil){
        m_tableview_array = [NSMutableArray array];
    }
    if(m_cash_array.count >= 8){
        NSLog(@"获取视频缓存 >=8");
        for (int i=0; i<8; i++) {
            video_info_model* model = m_cash_array[0];
            [m_tableview_array addObject:model];
            [m_cash_array removeObject:model];
        }
        return YES;
    }else if(0 < m_cash_array.count && m_cash_array.count < 8){
        NSLog(@"获取视频缓存 <8");
        for (video_info_model* model in m_cash_array.reverseObjectEnumerator) {
            [m_tableview_array addObject:model];
            [m_cash_array removeObject:model];
        }
        return YES;
    }
    else{
        return NO;
    }
}

-(void)GetNetFailed{
    [m_Reloaded_view removeFromSuperview];
    DateReload_view* view = [[DateReload_view alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    m_Reloaded_view = view;
    [m_Reloaded_view.button addTarget:self action:@selector(reloadNet) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_Reloaded_view];
}

-(void)reloadNet{
    [m_Reloaded_view removeFromSuperview];
    [m_tableview.header beginRefreshing];
}

#pragma mark - tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(m_tableview_array == nil){
        return 0;
    }else{
        return m_tableview_array.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    video_TableViewCell* cell = [video_TableViewCell CellFormTable:tableView];
    video_info_model* model = m_tableview_array[indexPath.row];
    cell.m_playerView.delegate = self;
    cell.model = model;
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    video_info_model* model = m_tableview_array[indexPath.row];
    CGFloat height = [video_TableViewCell cellForHeight];
    if(model.isRreadHere){
        height += kWidth(30);
    }
    return height;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}


#pragma mark -  协议
-(void)shareAction:(video_info_model*)model{
    NSLog(@"shareAction");
    [self MyShareAction];
    m_share_model = model;
}
-(void)MyShareAction{
    NSLog(@"准备分享");
    //收回所有窗口
    //    [[NSNotificationCenter defaultCenter] postNotificationName:HideAllDialog object:nil];
    
    collectvModel* model = [[collectvModel alloc] init];
    model.name_array = @[@"朋友圈",@"微信好友",@"QQ好友",@"QQ空间",@"复制链接",@"更多"];
    model.imgs_array = @[@"ic_friend",@"ic_wechat",@"ic_qq",@"ic_zone",@"ic_link",@"ic_nav_share"];
    model.lineInstance = 24;
    model.itemInstance = (SCREEN_WIDTH-48-48-48*3)/3;
    model.itemsOfLine = 3;
    model.size = CGSizeMake(48, 60);
    model.edge = UIEdgeInsetsMake(24, 48, 24, 48);//分别为上、左、下、右
    
    ShareSettingView* view = [[ShareSettingView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT+248, SCREEN_WIDTH, 248)];
    view.model = model;
    view.delegate = self;
    view.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
    //    m_fenxiang_shareSettingView = view;
    
    ShareSetting_view* share_setting = [ShareSetting_view GetDialogView:view.frame withCusomView:view];
    self.share_View = share_setting;
    [self.share_View Show];
}
-(void)shareByName:(NSString *)name{
    [self ItemClick:name];
}
-(void)Hide_wid{
    [self.share_View Hide];
}
-(void)ItemClick:(NSString *)name{
    //    NSString* name = noti.object;
    if([WeChat_pengyoujuan isEqualToString:name]){
        NSLog(@"朋友圈");
        [UMShareHelper ShareVideo:WeChat_pengyoujuan AndModel:m_share_model];
        [self Hide_wid];
    }
    if([WeChat_haoyou isEqualToString:name]){
        NSLog(@"微信好友");
        [UMShareHelper ShareVideo:WeChat_haoyou AndModel:m_share_model];
        [self Hide_wid];
    }
    if([QQ_haoyou isEqualToString:name]){
        NSLog(@"QQ好友");
        [UMShareHelper ShareVideo:WeChat_haoyou AndModel:m_share_model];
        [self Hide_wid];
    }
    if([QQ_kongjian isEqualToString:name]){
        NSLog(@"QQ空间");
        [UMShareHelper ShareVideo:QQ_kongjian AndModel:m_share_model];
        [self Hide_wid];
    }
    if([@"复制链接" isEqualToString:name]){
        NSLog(@"复制链接");
        [self copylinkBtnClick];
        [self Hide_wid];
    }
    if([@"举报" isEqualToString:name]){
        NSLog(@"举报");
        if(![Login_info share].isLogined){
            [MBProgressHUD showMessage:@"未登录！"];
            return;
        }
        //        [self ReportToMe];
    }
    if([@"字体" isEqualToString:name]){
        NSLog(@"字体");
        //        [self SetFont];
    }
    if([@"更多" isEqualToString:name]){
        NSLog(@"更多");
//        [self shareMore];
        [self.delegate shareMore:m_share_model];
        [self Hide_wid];
    }
    if([@"夜间模式" isEqualToString:name]){
        NSLog(@"夜间模式");
    }
}

-(void)GoToVideoDetail:(video_info_model*)model{
    NSLog(@"GoToVideoDetail");
    [self.delegate video_channel_GoToDetail:model AndChannel:self.model];
    
    [m_tableview reloadData];
}
-(void)MyPlayerView_videoPlay:(video_info_model*)model AndMyPlayerView:(id)Player_self{
    NSLog(@"videoPlay");
    MyPlayerView* PlayerView_tmp = (MyPlayerView*)Player_self;
    
    //记录是哪cell在播放
    if(m_play_index == -1){
        m_play_index = [m_tableview_array indexOfObject:model];
        m_cell_playView = PlayerView_tmp;
    }else{
        NSInteger index = [m_tableview_array indexOfObject:model];
        if(index == m_play_index){
            return;
        }
//        //一个cell刷新  缺点：单个cell刷新，一个显示cell，一个退出cell，不是同一个cell
//        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:m_play_index inSection:0];
//        [m_tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
        [m_cell_playView initAll];
        m_cell_playView = PlayerView_tmp;
        m_play_index = index;
    }
}

-(void)MyPlayerVIew_PlayOver{
    [self ToCell];
}

-(void)MyPlayer_giveGold:(video_info_model*)model{
    if(![Login_info share].isLogined){
        return;
    }
    else{
        if([[Login_info share].userInfo_model.device_mult_user integerValue] == NotTheDevice){
//            [MyMBProgressHUD ShowMessage:@"非绑定设备，不能执行任务" ToView:self.view AndTime:1.0f];
            return;
        }
    }
    if(![[MyDataBase shareManager] IsGetIncomeNews:model.ID]){//防止重复 阅读奖励
        NSString* task_id = [Md5Helper Video_taskId:[Login_info share].userInfo_model.user_id AndVideoId:model.ID];
        [InternetHelp SendTaskId:task_id AndType:Task_video Sucess:^(NSInteger type, NSDictionary *dic) {
            [RewardHelper ShowReward:type AndSelf:self AndCoin:dic[@"list"][@"reward_coin"]];
            [[MyDataBase shareManager] AddGetIncomeNews:model.ID]; //将视频id存储起来 防止重复
            [[TaskCountHelper share] newUserTask_addCountByType:Task_video];// 新手任务添加count
        } Fail:^(NSDictionary *dic) {
            NSLog(@"视频上传失败");
        }];
    }else{
        NSLog(@"视频重复");
    }
}

-(void)fullScreen:(video_info_model*)model AndView:(MyPlayerView *)playView{
    NSLog(@"fullScreen");
    /*
     * movieView移到window上
     */
    //计算MyPlayer 在整个窗口的位置
    NSInteger index = [m_tableview_array indexOfObject:model];
    NSIndexPath * path = [NSIndexPath indexPathForRow:index inSection:0];
    rectInTableV = [m_tableview rectForRowAtIndexPath:path];
    rectInWindow = [m_tableview convertRect:rectInTableV toView:[m_tableview superview]];
    
    m_superViewOfPlayer = [playView superview];

    [playView removeFromSuperview];
//    [playView.playerLayer removeFromSuperlayer];
    [[UIApplication sharedApplication].keyWindow addSubview:playView];
    
    self.m_fullScreen_imgView = playView;
    [self.m_fullScreen_imgView.back setHidden:NO];
    [self.m_fullScreen_imgView.m_topView setHidden:YES];
    
    self.statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    /*
     * 执行动画
     */
    [UIView animateWithDuration:0.5 animations:^{
        
        self.m_fullScreen_imgView.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.m_fullScreen_imgView.bounds = CGRectMake(0, 0, CGRectGetHeight(self.m_fullScreen_imgView.superview.bounds), CGRectGetWidth(self.m_fullScreen_imgView.superview.bounds));
        self.m_fullScreen_imgView.center = CGPointMake(CGRectGetMidX(self.m_fullScreen_imgView.superview.bounds), CGRectGetMidY(self.m_fullScreen_imgView.superview.bounds));
//        NSLog(@"bounds.x=%f----bounds.y=%f",self.m_fullScreen_imgView.bounds.size.width,self.m_fullScreen_imgView.bounds.size.height);
        [self.m_fullScreen_imgView setNeedsLayout];
        
        self.m_fullScreen_imgView.playerLayer.frame = self.m_fullScreen_imgView.bounds;
//        [self.m_fullScreen_imgView.m_imgView.layer insertSublayer:self.m_fullScreen_imgView.playerLayer atIndex:0];
        
    } completion:^(BOOL finished) {
        [self.statusBar setHidden:YES];
    }];
    
}

-(void)ToCell{
    /*
     * 执行动画
     */
    [UIView animateWithDuration:0.5 animations:^{
        
        self.m_fullScreen_imgView.transform = CGAffineTransformIdentity;
//        self.m_fullScreen_imgView.frame = rectInWindow;

//        [self.m_fullScreen_imgView setNeedsLayout];
        
//        self.m_fullScreen_imgView.playerLayer.frame = self.m_fullScreen_imgView.bounds;
        
        self.m_fullScreen_imgView.frame = CGRectMake(0, 0, rectInWindow.size.width, kWidth(202));
        self.m_fullScreen_imgView.playerLayer.frame = self.m_fullScreen_imgView.bounds;
//        NSLog(@"bounds.x=%f----bounds.y=%f",self.m_fullScreen_imgView.bounds.size.width,self.m_fullScreen_imgView.bounds.size.height);
        [m_superViewOfPlayer addSubview:self.m_fullScreen_imgView];
        //        [self.m_fullScreen_imgView.m_imgView.layer insertSublayer:self.m_fullScreen_imgView.playerLayer atIndex:0];
        
    } completion:^(BOOL finished) {
        [self.statusBar setHidden:NO];
        [self.m_fullScreen_imgView.back setHidden:YES];
        [self.m_fullScreen_imgView.m_topView setHidden:NO];
    }];
}

-(void)backFromFullScreen{
    [self ToCell];
}

-(void)Refresh{
    [m_tableview setContentOffset:CGPointZero animated:NO];
    [m_tableview.header beginRefreshing];
}

- (void)copylinkBtnClick {
    [MBProgressHUD showSuccess:@"复制成功!"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@ %@&source=link",m_share_model.title,m_share_model.url];
}

-(void)shareMore{
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

#pragma mark - API
-(void)Request_channelInfo:(NSInteger)type{
    [InternetHelp Video_info_API_channelID:[self.model.channel_id integerValue] AndPage:m_page Sucess:^(NSDictionary *dic) {
        
        NSMutableArray* array =[NSMutableArray arrayWithArray:[video_info_model dicToArray:dic]];
        //去重
        for (video_info_model* tmp in array.reverseObjectEnumerator) {
            for (video_info_model* tmp_other in m_tableview_array.reverseObjectEnumerator) {
                if([tmp.ID isEqualToString:tmp_other.ID]){
                    [array removeObject:tmp];
                }
            }
        }
        
        if(type == 0){
            if(array.count == 0){
                [m_tableview.header endRefreshing];
                [MyMBProgressHUD ShowMessage:@"没有更多数据" ToView:self.view AndTime:1];
            }else{
                //提示信息
                tip_vc = [[Tips_ViewController alloc] init];
                tip_vc.view.frame = CGRectMake(0, CGRectGetMaxY(m_tableview.frame)-50, SCREEN_WIDTH, 30);
                //            tip_vc.view.backgroundColor = [UIColor redColor];
                tip_vc.message = [NSString stringWithFormat:@"更新%ld条新闻",m_tableview_array.count];
                [self.view addSubview:tip_vc.view];
                [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    tip_vc.view.alpha = 0.0;
                } completion:^(BOOL finished) {
                    [tip_vc.view removeFromSuperview];
                }];
                
                //添加阅读到这里
                if(m_tableview_array.count > 0){
                    video_info_model* model = array[array.count-1];
                    model.isRreadHere = YES;
                    model.getVideoTime = [[TimeHelper share] getCurrentTime_YYYYMMDDHHMMSS];
                    for (video_info_model* item in m_tableview_array) {
                        item.isRreadHere = NO;
                    }
                }
                
                [array addObjectsFromArray:m_tableview_array];
                m_tableview_array = array;
                [m_tableview reloadData];
                m_page++;
                [m_tableview.header endRefreshing];
            }
        }else{
            if(array.count == 0){
                [m_tableview.footer noticeNoMoreData];
            }else{
                [m_tableview_array addObjectsFromArray:array];
                [m_tableview reloadData];
                m_page++;
                [m_tableview.footer endRefreshing];
            }
        }
        
    } Fail:^(NSDictionary *dic) {
        if(dic == nil){
            [MyMBProgressHUD ShowMessage:@"网络错误" ToView:self.view AndTime:1];
        }else{
            [MyMBProgressHUD ShowMessage:dic[@"msg"] ToView:self.view AndTime:1];
        }
        [m_tableview.header endRefreshing];
        [m_tableview.footer endRefreshing];
        
        if(m_tableview_array.count == 0){
            [self GetNetFailed];
        }
    }];
}

-(void)Request_channelInfo_fromSearch:(NSInteger)type{
    [InternetHelp Video_info_API_fromSearch_AndPage:type AndSearchWord:self.searchWord Sucess:^(NSDictionary *dic) {
        NSMutableArray* array =[NSMutableArray arrayWithArray:[video_info_model dicToArray:dic]];
        //去重
        for (video_info_model* tmp in array.reverseObjectEnumerator) {
            for (video_info_model* tmp_other in m_tableview_array.reverseObjectEnumerator) {
                if([tmp.ID isEqualToString:tmp_other.ID]){
                    [array removeObject:tmp];
                }
            }
        }
        
        if(type == 0){
            if(array.count == 0){
                [m_tableview.header endRefreshing];
                [MyMBProgressHUD ShowMessage:@"没有更多数据" ToView:self.view AndTime:1];
            }else{
                //添加阅读到这里
                if(m_tableview_array.count > 0){
                    video_info_model* model = array[array.count-1];
                    model.isRreadHere = YES;
                    model.getVideoTime = [[TimeHelper share] getCurrentTime_YYYYMMDDHHMMSS];
                    for (video_info_model* item in m_tableview_array) {
                        item.isRreadHere = NO;
                    }
                }
                
                [array addObjectsFromArray:m_tableview_array];
                m_tableview_array = array;
                [m_tableview reloadData];
                m_page++;
                [m_tableview.header endRefreshing];
            }
        }else{
            if(array.count == 0){
                [m_tableview.footer noticeNoMoreData];
            }else{
                [m_tableview_array addObjectsFromArray:array];
                [m_tableview reloadData];
                m_page++;
                [m_tableview.footer endRefreshing];
            }
        }
    } Fail:^(NSDictionary *dic) {
        if(dic == nil){
            [MyMBProgressHUD ShowMessage:@"网络错误" ToView:self.view AndTime:1];
        }else{
            [MyMBProgressHUD ShowMessage:dic[@"msg"] ToView:self.view AndTime:1];
        }
        [m_tableview.header endRefreshing];
        [m_tableview.footer endRefreshing];
    }];
}

@end
