//
//  SocietyViewController.m
//  新闻
//
//  Created by gyh on 15/9/23.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SocietyViewController.h"
#import "testViewController.h"
#import "NewTableViewCell.h"
#import "NewData.h"
#import "TopData.h"
#import "NewDataFrame.h"
#import "CycleBannerView.h"
#import "TopViewController.h"
#import "TabbarView.h"

#import "DataModel.h"
#import "NewsCell.h"
#import "ImagesCell.h"
#import "BigImageCell.h"
#import "TopCell.h"

#import "DetailWebViewController.h"
#import "DataBase.h"
#import "NSDate+gyh.h"

#import "ChannelName.h"
#import "CJZdataModel.h"
#import "NoImageCell.h"
#import "OneImageCell.h"
#import "ThreeImageCell.h"

#import "DetailWeb_ViewController.h"
#import "DateReload_view.h"
#import "IndexOfNews.h"

@interface SocietyViewController ()<UITableViewDelegate,UITableViewDataSource,Noimage_DetailWeb_InterfaceDelegate,OneImage_DetailWeb_InterfaceDelegate,ThreeImage_DetailWeb_InterfaceDelegate>
@property (nonatomic , strong) NSMutableArray *totalArray;
@property (nonatomic , strong) CycleBannerView *bannerView;
@property (nonatomic , strong) NSMutableArray *topArray;
@property (nonatomic , strong) NSMutableArray *titleArray;
@property (nonatomic , strong) NSMutableArray *imagesArray;

@property (nonatomic , strong) UITableView *tableview;
@property (nonatomic , assign) int page;

@end

@implementation SocietyViewController{
    DateReload_view*        m_Reloaded_view;
    BOOL                    m_isFirst;
    Tips_ViewController*    tip_vc;
    NSMutableArray*                m_cash_array;
}

- (NSMutableArray *)totalArray
{
    if (!_totalArray) {
        _totalArray = [NSMutableArray array];
    }
    return _totalArray;
}
- (NSMutableArray *)imagesArray
{
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}
- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
- (NSMutableArray *)topArray
{
    if (!_topArray) {
        _topArray = [NSMutableArray array];
    }
    return _topArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    m_isFirst = YES;
    _page = 1;
    self.view.backgroundColor = UIColor.whiteColor;
    [self initTableView];
//    [self initBannerView]; //头视图
    //请求滚动数据
//    [self initTopNet];//头视图数据
    
    //监听夜间模式的改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleThemeChanged) name:Notice_Theme_Changed object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mynotification) name:@"新闻" object:nil];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetNetFailed) name:@"获取新闻失败" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeleteOne:) name:@"不感兴趣" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SaveNews) name:@"AppDelegate_SocietyViewCtl" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(m_isFirst){
        [self IsRefresh];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)IsRefresh{
    NSNumber* now = [[TimeHelper share] getCurrentTime_number];
    NSNumber* last = [[AppConfig sharedInstance] getTheTime_lastRefresh:self.channel_id];
    if([[TimeHelper share] compareTimes_ori_time:last dest_time:now time:2*60*60]){
        NSLog(@"新闻刷新");
        [self mynotification];
    }
}

- (void)mynotification
{
//    [self.tableview setContentOffset:CGPointZero animated:NO];
    [self.tableview.header beginRefreshing];
}

-(void)GetNetFailed{
    [m_Reloaded_view removeFromSuperview];
    DateReload_view* view = [[DateReload_view alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    m_Reloaded_view = view;
    [m_Reloaded_view.button addTarget:self action:@selector(initTableView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_Reloaded_view];
}

- (void)initTableView
{
    [m_Reloaded_view removeFromSuperview];
    [self.tableview removeFromSuperview];
    
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64-49)];
    tableview.delegate = self;
    tableview.dataSource = self;
    [tableview setSeparatorInset:UIEdgeInsetsZero];
    [tableview setLayoutMargins:UIEdgeInsetsZero];
    tableview.estimatedRowHeight = 184.0f;
    [self.view addSubview:tableview];
    self.tableview = tableview;
    self.tableview.tableFooterView = [[UIView alloc]init];
    
    IMP_BLOCK_SELF(SocietyViewController);
    GYHHeadeRefreshController *header = [GYHHeadeRefreshController headerWithRefreshingBlock:^{
        
        if(!self.isSearchVC){
            if(self.isNewChannel){
                [block_self searchNet:0];
                return ;
            }
            [block_self requestNet:0];
        }else{
            _page = 0;
            [block_self searchNet:0];
        }
        
    }];
    //头部刷新视图设置
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableview.header = header;
    
//    [header beginRefreshing];
    
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if(!self.isSearchVC){
            if([self getCashArray]){
                [block_self.tableview.footer endRefreshing];
                [block_self.tableview reloadData];
            }else{
                if(self.isNewChannel){
                    [block_self searchNet:_page];
                    return ;
                }
                [block_self requestNet:_page];
            }
        }else{
            
            [block_self searchNet:_page];
        }
    }];
    
    
    ThemeManager *manager = [ThemeManager sharedInstance];
    self.tableview.backgroundColor = [manager themeColor];
    
    //是否添加缓存的数据
    if(!self.isSearchVC){ // 搜索界面不添加缓存数据
        [self addTableView_data];
    }
}

-(void)addTableView_data{
    //是否有缓存数据 有：直接赋值 没有：刷新获得数据
    
//    if(self.totalArray.count < 50){ //保证保存最新的50信息
//        if(m_cash_array.count > 0){
//            for (CJZdataModel* model in m_cash_array) {
//                if(self.totalArray.count >= 50){
//                    break;
//                }
//                [self.totalArray addObject:model];
//            }
//        }
//    }
    
    m_cash_array = [NSMutableArray arrayWithArray:[[AppConfig sharedInstance] getNewsByChannel_id:self.channel_id]];
    if(m_cash_array.count > 0){
        [self getCashArray];
        [self.tableview reloadData];
//        [self IsRefresh];
    }else{
        [self.tableview.header beginRefreshing];
    }
}

-(BOOL)getCashArray{
    if(m_cash_array.count >= 8){
        NSLog(@"获取新闻缓存");
        for (int i=0; i<8; i++) {
            [self.totalArray addObject:m_cash_array[0]];
            [m_cash_array removeObjectAtIndex:0];
        }
        return YES;
    }else if(0 < m_cash_array.count && m_cash_array.count < 8){
        NSLog(@"获取新闻缓存");
        for (CJZdataModel* model in m_cash_array.reverseObjectEnumerator) {
            [self.totalArray addObject:model];
            [m_cash_array removeObject:model];
        }
        return YES;
    }else{
        return NO;
    }
}

- (void)initBannerView
{
    CycleBannerView *bannerView = [[CycleBannerView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_WIDTH * 0.55)];
    bannerView.bgImg = [UIImage imageNamed:@"shadow.png"];
    
    IMP_BLOCK_SELF(SocietyViewController);
    bannerView.clickItemBlock = ^(NSInteger index) {
        
        TopData *data = block_self.topArray[index];
        NSString *url1 = [data.url substringFromIndex:4];
        url1 = [url1 substringToIndex:4];
        NSString *url2 = [data.url substringFromIndex:9];
        
        url2 = [NSString stringWithFormat:@"http://c.3g.163.com/photo/api/set/%@/%@.json",url1,url2];
        TopViewController *topVC = [[TopViewController alloc]init];
        topVC.url = url2;
        [block_self.navigationController pushViewController:topVC animated:YES];
    };
//    self.tableview.tableHeaderView = bannerView;
    self.bannerView = bannerView;
}

-(void)addHeaderView{
    CGFloat headerHeight = kWidth(50);
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerHeight)];
    
    NSString* keyword = self.keyWords;
    if(keyword.length > 6){
        NSString* start_str = [keyword substringToIndex:2];
        NSString* end_str = [keyword substringFromIndex:keyword.length-2];
        keyword = [NSString stringWithFormat:@"%@..%@",start_str,end_str];
    }
    NSString* tipStr = [NSString stringWithFormat:@"将含%@的内容添加至频道",keyword];
    CGFloat labelWidth = [LabelHelper GetLabelWidth:kFONT(16) AndText:tipStr];
    UILabel* tipLable = [[UILabel alloc] initWithFrame:CGRectMake(16, 20, labelWidth, headerHeight-kWidth(20)-kWidth(20))];
    tipLable.text = keyword;
    tipLable.textColor = RGBA(34, 39, 39, 1);
    tipLable.textAlignment = NSTextAlignmentLeft;
    tipLable.font = kFONT(14);
    NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc] initWithString:tipStr];
    NSRange range = [tipStr rangeOfString:keyword];
    attStr = [LabelHelper GetMutableAttributedSting_color:attStr AndIndex:range.location AndCount:keyword.length AndColor:RGBA(248, 205, 4, 1)];
    tipLable.attributedText = attStr;
    [headerView addSubview:tipLable];
    
    UIButton* addChannelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-kWidth(16)-headerHeight*1.5, kWidth(10), headerHeight*1.5, headerHeight-kWidth(10)-kWidth(10))];
    [addChannelBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addChannelBtn setTitleColor:RGBA(34, 39, 39, 1) forState:UIControlStateNormal];
    [addChannelBtn.titleLabel setFont:kFONT(12)];
    [addChannelBtn.layer setCornerRadius:10.0f];
    [addChannelBtn setBackgroundColor:RGBA(248, 205, 4, 1)];
    [addChannelBtn addTarget:self action:@selector(addChannel:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addChannelBtn];
    
    //判断是否订阅过
    if([[IndexOfNews share] isHaveChannel:self.keyWords]){
        [addChannelBtn setEnabled:NO];
        addChannelBtn.backgroundColor = RGBA(242, 242, 242, 1);
    }else{
        [addChannelBtn setEnabled:YES];
        addChannelBtn.backgroundColor = RGBA(248, 205, 4, 1);
    }
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(16, headerHeight-1, SCREEN_WIDTH-16-16, 1)];
    line.backgroundColor = RGBA(242, 242, 242, 1);
    [headerView addSubview:line];
    
    self.tableview.tableHeaderView = headerView;
    [self.tableview reloadData];
}

-(void)addChannel:(UIButton*)sender{
    [sender setEnabled:NO];
    sender.backgroundColor = RGBA(242, 242, 242, 1);
    //给新频道添加channelId
    //tabbar 重置
    //提示消息
    ChannelName* channelName = [[ChannelName alloc] init];
    channelName.title = self.keyWords;
    channelName.ID = [[TimeHelper share] getCurrentTime_YYYYMMDDHHSS];
    channelName.isNewChannel = YES;
    
    NSArray* tmp = [IndexOfNews share].channel_array;
    NSMutableArray* newChannels = [NSMutableArray arrayWithArray:tmp];
    [newChannels insertObject:channelName atIndex:1];
    [IndexOfNews share].channel_array = newChannels;
    
    [[AlertHelper Share] ShowMe:self And:0.5f And:@"订阅成功"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Society_SCNavi_订阅" object:nil];
    
    //保存频道信息
    [[AppConfig sharedInstance] saveChannel:[IndexOfNews share].channel_array];
    NSLog(@"----count:%ld",[IndexOfNews share].channel_array.count);
}

#pragma mark - tableview协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.totalArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ThemeManager *defaultManager = [ThemeManager sharedInstance];
    
    CJZdataModel *Model = self.totalArray[indexPath.row];
//    CJZdataModel *Model = self.totalArray[indexPath.row];
    
    NSString *ID = [NoImageCell idForRow:Model];
    if([ID isEqualToString:@"NoImg"]){
        NoImageCell* cell = [NoImageCell cellWithTableView:tableView];
        if ([defaultManager.themeName isEqualToString:@"高贵紫"]) {
            cell.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
            cell.title.textColor = [defaultManager GetTitleColor];
        }else{
            cell.backgroundColor = [UIColor whiteColor];
            cell.title.textColor = [UIColor blackColor];
            }
        cell.model = Model;
        cell.del.hidden = NO;
        cell.tag = indexPath.row;
        cell.delegate = self;
        if(Model.isRreading){
            cell.IsReading = YES;
        }
        if(self.isSearchVC){
            cell.searchWord = self.keyWords;
        }
        return cell;
    }
    else if([ID isEqualToString:@"OneImg"]){
        OneImageCell* cell = [OneImageCell cellWithTableView:tableView];
        if ([defaultManager.themeName isEqualToString:@"高贵紫"]) {
            cell.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
            cell.title.textColor = [defaultManager GetTitleColor];
        }else{
            cell.backgroundColor = [defaultManager GetBackgroundColor];
            cell.title.textColor = [defaultManager GetTitleColor];
        }
        cell.model = Model;
        cell.del.hidden = NO;
        cell.tag = indexPath.row;
        cell.delegate = self;
        if(Model.isRreading){
            cell.IsReading = YES;
        }
        if(self.isSearchVC){
            cell.searchWord = self.keyWords;
        }
        return cell;
    }
    else{
        //ThreeImage
        ThreeImageCell* cell = [ThreeImageCell cellWithTableView:tableView];
        if ([defaultManager.themeName isEqualToString:@"高贵紫"]) {
            cell.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
            cell.title.textColor = [defaultManager GetTitleColor];
        }else{
            cell.backgroundColor = [defaultManager GetBackgroundColor];
            cell.title.textColor = [defaultManager GetTitleColor];
        }

        cell.model = Model;
        cell.del.hidden = NO;
        cell.tag = indexPath.row;
        cell.delegate = self;
        if(Model.isRreading){
            cell.IsReading = YES;
        }
        if(self.isSearchVC){
            cell.searchWord = self.keyWords;
        }
        return cell;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CJZdataModel *newsModel = self.totalArray[indexPath.row];
    CGFloat rowHeight = [NoImageCell heightForRow:newsModel];

    return rowHeight;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CJZdataModel *data = self.totalArray[indexPath.row];
    
    if(_isSearchVC){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"搜索-详情页面" object:data];
    }else{
        
        DetailWeb_ViewController* vc = [[DetailWeb_ViewController alloc] init];
        vc.CJZ_model = data;
        vc.channel = self.channel_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //标记阅读与否
    data.isRreading = YES;
    
    //一个cell刷新
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone]; //collection 相同
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}


- (void)handleThemeChanged
{
    ThemeManager *defaultManager = [ThemeManager sharedInstance];
    self.tableview.backgroundColor = [defaultManager themeColor];
    [self.navigationController.navigationBar setBackgroundImage:[defaultManager themedImageWithName:@"navigationBar"] forBarMetrics:UIBarMetricsDefault];
    [self.tableview reloadData];
}

#pragma mark - 协议
-(void)NoImage_readHere_action{
    [self.tableview setContentOffset:CGPointZero animated:NO];
    [self.tableview.header beginRefreshing];
}
-(void)OneImage_readHere_action{
    [self.tableview setContentOffset:CGPointZero animated:NO];
    [self.tableview.header beginRefreshing];
}
-(void)ThreeImage_readHere_action{
    [self.tableview setContentOffset:CGPointZero animated:NO];
    [self.tableview.header beginRefreshing];
}

#pragma mark - 通知
-(void)DeleteOne:(NSNotification*)noti{
    NSNumber* number = noti.object;
    NSInteger index = [number integerValue];
    [self.totalArray removeObjectAtIndex:index];
    [self.tableview reloadData];
}

-(void)SaveNews{
    NSLog(@"channel_id:%@---saveNews",self.channel_id);
    //记录前50条新闻信息
    NSArray* array = [NSArray arrayWithArray:[CJZdataModel ArrayModelToDic_top50:self.totalArray]];
    [[AppConfig sharedInstance] saveNews:array channel_id:self.channel_id];
}

#pragma mark 网络请求

- (void)initTopNet
{
    IMP_BLOCK_SELF(SocietyViewController);    
    [[BaseEngine shareEngine] runRequestWithPara:nil path:@"http://c.m.163.com/nc/article/headline/T1348647853363/0-10.html" success:^(id responseObject) {
        
        NSArray *dataarray = [TopData objectArrayWithKeyValuesArray:responseObject[@"T1348647853363"][0][@"ads"]];
        NSMutableArray *statusFrameArray = [NSMutableArray array];
        NSMutableArray *titleArray = [NSMutableArray array];
        NSMutableArray *topArray = [NSMutableArray array];
        for (TopData *data in dataarray) {
            [topArray addObject:data];
            [statusFrameArray addObject:data.imgsrc];
            [titleArray addObject:data.title];
        }
        [block_self.topArray addObjectsFromArray:topArray];
        [block_self.imagesArray addObjectsFromArray:statusFrameArray];
        [block_self.titleArray addObjectsFromArray:titleArray];
        
        block_self.bannerView.aryImg = [block_self.imagesArray copy];
        block_self.bannerView.aryText = [block_self.titleArray copy];
        
    } failure:^(id error) {
        
    }];
}

//测试
-(void)requestNet_test:(int)type
{
    IMP_BLOCK_SELF(SocietyViewController);
//    NSString* url = _channelUrl.url;
    NSString* url = @"";
//    NSString *urlstr = [NSString stringWithFormat:_channelUrl,self.page];
    
    [[BaseEngine shareEngine] runRequestWithPara:nil path:url success:^(id responseObject) {
        
        NSArray *temArray = responseObject;
//        NSArray *arrayM = [CJZdataModel objectArrayWithKeyValuesArray:temArray];
        NSArray *arrayM = [CJZdataModel jsonArrayToModelArray:temArray];
        NSMutableArray *statusArray = [NSMutableArray array];
        for (CJZdataModel *data in arrayM) {
            
            [statusArray addObject:[self SetData:data]];
        }
        
        if (type == 1) {
            block_self.totalArray = statusArray;
        }else{
            [block_self.totalArray addObjectsFromArray:statusArray];
        }
        [block_self.tableview reloadData];
        block_self.page += 20;
        
        [block_self.tableview.header endRefreshing];
        [block_self.tableview.footer endRefreshing];

    } failure:^(id error) {
        if (error) {
            NSLog(@"%@",error);
        }
        [block_self.tableview.header endRefreshing];
        [block_self.tableview.footer endRefreshing];
        
        //发送失败消息
        [[NSNotificationCenter defaultCenter] postNotificationName:@"获取新闻失败" object:nil];

    }];
    
}

-(void)requestNet:(int)type{
    
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/getNews"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",@""]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"channel",self.channel_id]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"page",_page]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"size",8]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":%ld",@"client_type",IOS]];//设备类型 1:android 2；ios
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    IMP_BLOCK_SELF(SocietyViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        
        if(error || data == nil){
            NSLog(@"requestNet网络获取失败");
            //发送失败消息
            [block_self.tableview.header endRefreshing];
            [block_self.tableview.footer endRefreshing];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"获取新闻失败" object:nil];
            if(block_self.totalArray.count > 0){
                [MyMBProgressHUD ShowMessage:@"网络失败!" ToView:self.view AndTime:1.0f];
            }
            else{
                [block_self GetNetFailed];
            }
            
            return ;
        }
        
        NSLog(@"requestNet从服务器获取到数据");
        /*
         对从服务器获取到的数据data进行相应的处理.
         */
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* code = dict[@"code"];
            if([code integerValue] == 200){
            }else{
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"获取新闻失败" object:nil];
                [block_self GetNetFailed];
                return ;
            }
        NSArray* array_news = dict[@"list"];
        NSMutableArray *dataarray = [CJZdataModel jsonArrayToModelArray:array_news];
        NSMutableArray *statusArray = [NSMutableArray array];
        NSString* newsTime = nil;
        for (CJZdataModel *data in dataarray) {
            [statusArray addObject:[self SetData:data]];
            newsTime = data.publish_time;
        }
            
            //去重
            for (CJZdataModel* tmp in statusArray.reverseObjectEnumerator) {
                for (CJZdataModel* tmp_other in block_self.totalArray.reverseObjectEnumerator) {
                    if([tmp.ID isEqualToString:tmp_other.ID]){
                        NSLog(@"%@",tmp.title);
                        [statusArray removeObject:tmp];
                    }
                }
            }
        
        [[AppConfig sharedInstance] saveTheTime_lastRefresh:self.channel_id];//记录最新刷新时间,间隔2小时 就自动刷新
            
        if (type == 0) {
            if(block_self.totalArray.count == 0){
                block_self.totalArray = statusArray;
                
            }else{
                //提示信息
                tip_vc = [[Tips_ViewController alloc] init];
                tip_vc.view.frame = CGRectMake(0, CGRectGetMinY(block_self.tableview.frame)+kWidth(10), SCREEN_WIDTH, kWidth(30));
//                            tip_vc.view.backgroundColor = [UIColor redColor];
                tip_vc.message = [NSString stringWithFormat:@"更新%ld条新闻",statusArray.count];
                tip_vc.corner = kWidth(30)/2;
                [block_self.view addSubview:tip_vc.view];
                [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    tip_vc.view.alpha = 0.0;
                } completion:^(BOOL finished) {
                    [tip_vc.view removeFromSuperview];
                    tip_vc = nil;
                }];
                
                if(statusArray.count > 0){
                    //添加阅读到这里
                    if(block_self.totalArray.count > 0){
                        if(statusArray.count > 0){
                            CJZdataModel* item_readHere = statusArray[statusArray.count-1];
                            item_readHere.isRreadHere = YES;
                            for (CJZdataModel* model in block_self.totalArray) {
                                model.isRreadHere = NO;
                                [statusArray addObject:model];
                            }
                        }
                    }
                    block_self.totalArray = statusArray;
                }
            }
            
        }else{
            [block_self.totalArray addObjectsFromArray:statusArray];
        }
            
            if(statusArray.count == 0){
//                [block_self.tableview.footer noticeNoMoreData];
                [block_self.tableview.footer endRefreshing];
            }else{
                
                block_self.page += 1;
                
                [block_self.tableview.footer endRefreshing];
            }
            
            [block_self.tableview.footer endRefreshing];
            [block_self.tableview.header endRefreshing];
            [block_self.tableview reloadData];
        

        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

#pragma mark - 搜索页面使用
//# 实例： http://39.104.13.61/api/getSearch?json={"user_id":"814B08C64ADD12284CA82BA39384B177","keyword":"王菲","page":0,"size":10}
-(void)searchNet:(int)type{
    NSString* keyword = self.keyWords;
    if(self.isNewChannel){
        keyword = self.title;
    }
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/getSearch"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[[Login_info share]GetUserInfo].user_id]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"keyword",keyword]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"page",_page]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"size",10]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":%ld",@"client_type",IOS]];//设备类型 1:android 2；ios
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    IMP_BLOCK_SELF(SocietyViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error){
                NSLog(@"网络获取失败");
                //发送失败消息
                [block_self.tableview.header endRefreshing];
                [block_self.tableview.footer endRefreshing];
                
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"获取新闻失败" object:nil];
                [block_self GetNetFailed];
                return ;
            }
            
            NSLog(@"从服务器获取到数据");
            /*
             对从服务器获取到的数据data进行相应的处理.
             */
            if(!self.isSearchVC){
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
                NSNumber* code = dict[@"code"];
                if([code integerValue] == 200){
                }else{
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"获取新闻失败" object:nil];
                    [block_self GetNetFailed];
                    return ;
                }
                NSArray* array_news = dict[@"list"];
                NSArray *dataarray = [CJZdataModel jsonArrayToModelArray:array_news];
                NSMutableArray *statusArray = [NSMutableArray array];
                NSString* newsTime = nil;
                for (CJZdataModel *data in dataarray) {
                    [statusArray addObject:[self SetData:data]];
                    newsTime = data.publish_time;
                }
                
                [[AppConfig sharedInstance] saveTheTime_lastRefresh:self.channel_id];//记录最新刷新时间,间隔2小时 就自动刷新
                
                if (type == 0) {
                    if(block_self.totalArray.count == 0){
                        block_self.totalArray = statusArray;
                    }else{
                        //提示信息
                        tip_vc = [[Tips_ViewController alloc] init];
                        tip_vc.view.frame = CGRectMake(0, CGRectGetMaxY(block_self.tableview.frame)-50, SCREEN_WIDTH, 30);
                        //            tip_vc.view.backgroundColor = [UIColor redColor];
                        tip_vc.message = [NSString stringWithFormat:@"更新%ld条新闻",statusArray.count];
                        [block_self.view addSubview:tip_vc.view];
                        [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                            tip_vc.view.alpha = 0.0;
                        } completion:^(BOOL finished) {
                            [tip_vc.view removeFromSuperview];
                        }];
                        
                        //添加阅读到这里
                        CJZdataModel* item_readHere = statusArray[statusArray.count-1];
                        item_readHere.isRreadHere = YES;
                        for (CJZdataModel* model in block_self.totalArray) {
                            model.isRreadHere = NO;
                            [statusArray addObject:model];
                        }
                        block_self.totalArray = statusArray;
                    }
                    
                }else{
                    [block_self.totalArray addObjectsFromArray:statusArray];
                }
                
                if(statusArray.count == 0){
                    [block_self.tableview.footer noticeNoMoreData];
                }else{
                    
                    block_self.page += 1;
                    
                    [block_self.tableview.footer endRefreshing];
                }
                
                [block_self.tableview.footer endRefreshing];
                [block_self.tableview.header endRefreshing];
                [block_self.tableview reloadData];
                
                return;
            }
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* code = dict[@"code"];
            if([code integerValue] != 200){
                [block_self NoResult];
                [block_self.tableview.header endRefreshing];
                [block_self.tableview.footer endRefreshing];
                return;
            }
            if(self.isSearchVC){
                NSNumber* subscribe = dict[@"subscribe"];
                if([subscribe integerValue] == 1){ // 可以订阅
                    [self addHeaderView];
                }
            }
            NSArray* array_news = dict[@"list"];
            if([NullNilHelper dx_isNullOrNilWithObject:array_news]){
                [block_self NoResult];
                return ;
            }
            NSArray *dataarray = [CJZdataModel jsonArrayToModelArray:array_news];
            NSMutableArray *statusArray = [NSMutableArray array];
            for (CJZdataModel *data in dataarray) {
                [statusArray addObject:[self SetData:data]];
            }
            
            if (type == 0) {
                block_self.totalArray = statusArray;
                
            }else{
                [block_self.totalArray addObjectsFromArray:statusArray];
            }
            
            if(statusArray.count == 0){
//                [block_self.tableview.footer noticeNoMoreData];
                [block_self.tableview.header endRefreshing];
//                if(type == 0){
//                    [block_self NoResult];
//                }
            }else{
                [block_self.tableview reloadData];
                block_self.page += 1;
                
                [block_self.tableview.footer endRefreshing];
            }
            [block_self.tableview.header endRefreshing];
            
            
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

-(void)NoResult{
    UILabel* tips = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2-16/2, SCREEN_WIDTH, 16)];
    tips.text = @"没有找到该新闻";
    tips.textColor = [UIColor blackColor];
    tips.textAlignment = NSTextAlignmentCenter;
    tips.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:tips];
    
    self.tableview.header = nil;
}

#pragma mark - 给数据模型 类型
-(CJZdataModel*)SetData:(CJZdataModel*)model{
    model.imgCount = model.images.count;
    return model;
}

@end
