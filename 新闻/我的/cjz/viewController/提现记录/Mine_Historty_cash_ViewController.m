//
//  Mine_Historty_cash_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_Historty_cash_ViewController.h"
#import "Mine_goldDetail_TableViewController.h"
#import "Mine_ChangToMoney_cell_model.h"
#import "DateReload_view.h"
#import "Mine_History_cash_detail_ViewController.h"

@interface Mine_Historty_cash_ViewController ()

@end

@implementation Mine_Historty_cash_ViewController{
    UIView*     m_navibar_view;
    Waiting_ViewController* m_waiting;
    UIView*                 m_Nothings_view;
    NSInteger               m_page;
    UIView*                 m_header_view;
    Mine_goldDetail_TableViewController*    m_tableview_ctr;
    NSArray*                m_ChangeToMoney_array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavi];
    [self showWaiting];
    [self DataView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GoToDetail:) name:@"Mine_goldDetail_TVCL_To_Mine_History_cash_VCL" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    title.text = @"提现记录";
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

-(void)showWaiting{
    m_waiting = [[Waiting_ViewController alloc] init];
    m_waiting.view.frame = CGRectMake(0, CGRectGetMaxY(m_navibar_view.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(m_navibar_view.frame));
    [self.view addSubview:m_waiting.view];
}
-(void)hideWaiting{
    [m_waiting.view removeFromSuperview];
}

-(void)NoDataView{
    m_Nothings_view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_navibar_view.frame),
                                                               SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(m_navibar_view.frame))];
    m_Nothings_view.backgroundColor = [UIColor whiteColor];
    UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-90/2, m_Nothings_view.frame.size.height/2-90/2, 90, 90)];
    [imgV setImage:[UIImage imageNamed:@"ic_empty_take"]];
    [m_Nothings_view addSubview:imgV];
    
    UILabel* tips = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imgV.frame)+16, SCREEN_WIDTH, 12)];
    tips.text = @"暂无提现记录";
    tips.textColor = RGBA(216, 216, 216, 1);
    tips.textAlignment = NSTextAlignmentCenter;
    tips.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:12];
    [m_Nothings_view addSubview:tips];
    
    [self.view addSubview:m_Nothings_view];
}

-(void)DataView{
    [self Total_cash_View];
    [self initTableView];
}

-(void)Total_cash_View{
    m_header_view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_navibar_view.frame), SCREEN_WIDTH, kWidth(88))];
    m_header_view.backgroundColor = RGBA(255, 255, 255, 1);
    [self.view addSubview:m_header_view];
    
    //tips
    UILabel* cash_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, SCREEN_WIDTH, kWidth(18))];
    cash_label.text = @"累计提现(元)";
    cash_label.textColor = RGBA(34, 39, 39, 1);
    cash_label.textAlignment = NSTextAlignmentLeft;
    cash_label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:kWidth(12)];
    [m_header_view addSubview:cash_label];
    [cash_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(m_header_view.mas_left).with.offset(kWidth(16));
        make.top.equalTo(m_header_view.mas_top).with.offset(kWidth(20));
        make.height.mas_offset(kWidth(18));
    }];
    
    UILabel* cash_number = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cash_label.frame)+16, SCREEN_WIDTH, kWidth(24))];
    CGFloat number = [[Login_info share].userMoney_model.total_cashed floatValue];
    cash_number.text = [NSString stringWithFormat:@"%.2f",number];
    cash_number.textColor = RGBA(34, 39, 39, 1);
    cash_number.textAlignment = NSTextAlignmentLeft;
    cash_number.font = [UIFont boldSystemFontOfSize:kWidth(24)];
    [m_header_view addSubview:cash_number];
    [cash_number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(m_header_view.mas_left).with.offset(kWidth(16));
        make.top.equalTo(cash_label.mas_bottom).with.offset(kWidth(10));
        make.height.mas_offset(kWidth(24));
    }];
}

-(void)initTableView{
    Mine_goldDetail_TableViewController* gold_tableview = [[Mine_goldDetail_TableViewController alloc] init];
    gold_tableview.tableName = @"提现记录";
    gold_tableview.tableView.frame = CGRectMake(0, CGRectGetMaxY(m_header_view.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(m_header_view.frame));
    m_tableview_ctr = gold_tableview;
    [self.view addSubview:m_tableview_ctr.tableView];
    
    IMP_BLOCK_SELF(Mine_Historty_cash_ViewController);
    GYHHeadeRefreshController *header = [GYHHeadeRefreshController headerWithRefreshingBlock:^{
        m_page = 0;
        [block_self GetHistoryData_changeToMoney];
    }];
    //头部刷新视图设置
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    m_tableview_ctr.tableView.header = header;
    if([Login_info share].isLogined){
        [header beginRefreshing];
    }
    else{
        [self NoDataView];
    }
    
    m_tableview_ctr.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [block_self GetHistoryData_changeToMoney];
    }];
    
}

#pragma mark - 按钮方法
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 通知
-(void)GoToDetail:(NSNotification*)noti{
    Mine_ChangToMoney_cell_model* model = noti.object;
    Mine_History_cash_detail_ViewController* vc = [Mine_History_cash_detail_ViewController new];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - API
-(void)GetHistoryData_changeToMoney{
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/getWithDrawRecord"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString *argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[[Login_info share]GetUserInfo].user_id]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%ld\"",@"page",m_page]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"size",10]];
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    IMP_BLOCK_SELF(Mine_Historty_cash_ViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if(error || data == nil){
                NSLog(@"网络获取失败");
                //发送失败消息
//                [[AlertHelper Share] ShowMe:self And:2.0 And:@"网络失败"];
                [MyMBProgressHUD ShowMessage:@"网络失败" ToView:self.view AndTime:1.0f];
                [m_tableview_ctr.tableView.header endRefreshing];
                [m_tableview_ctr.tableView.footer endRefreshing];
                return ;
            }
            
            NSLog(@"GetNetData_package从服务器获取到数据");
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* code = dict[@"code"];
            if([code longValue] != 200){
                return;
            }
            NSArray* array_model = [Mine_ChangToMoney_cell_model dicToModelArray:dict];
            NSArray* array_tmp = nil;
            if(array_model.count != 0){
                array_tmp = [[TimeHelper share] sortAllData_mon:array_model];//[array,array]
            }else{
                array_tmp = [NSArray array];
            }
            
            
            if (m_page == 0) {
                m_ChangeToMoney_array = array_tmp;
                m_tableview_ctr.array_cells = m_ChangeToMoney_array;
                if(array_model.count == 0){
                    [m_tableview_ctr.tableView.footer noticeNoMoreData];
                    [block_self NoDataView];
                }
            }else{
                NSMutableArray* mutable_array = [NSMutableArray arrayWithArray:m_ChangeToMoney_array];
                
                NSArray* array = array_tmp;
                if(array.count != 0){ //当数据为空时
                    for (NSArray* item in array_tmp) {
                        [mutable_array addObject:item];
                    }
                }
                m_ChangeToMoney_array = mutable_array;
                m_tableview_ctr.array_cells = m_ChangeToMoney_array;
                [m_tableview_ctr.tableView.footer endRefreshing];
            }
            
            NSArray* array = array_tmp;
            if(array.count == 0){ //当数据为空时
                [m_tableview_ctr.tableView.footer noticeNoMoreData];
                
            }else{
                if(m_page == 0 && array.count < 10){
                    [m_tableview_ctr.tableView.footer removeFromSuperview];
                }
                [m_tableview_ctr.tableView reloadData];
                m_page += 1;
                [m_Nothings_view removeFromSuperview];
                
                if(m_page == 0){
                    if(array_model.count < 10){
                        [m_tableview_ctr.tableView.footer setHidden:YES];
                    }
                }
            }
            [block_self hideWaiting];
            [m_tableview_ctr.tableView.header endRefreshing];
            
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
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
