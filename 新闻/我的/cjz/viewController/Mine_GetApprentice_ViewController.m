//
//  Mine_GetApprentice_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_GetApprentice_ViewController.h"
#import "Mine_MyApprentice_TableViewController.h"
#import "Mine_ShowToFriend_ViewController.h"
#import "Mine_apprenceInfo_ViewController.h"
#import "Mine_inviteApprence_ViewController.h"
#import "Mine_GetApprentice_TableViewCell.h"
#import "Mine_login_ViewController.h"

@interface Mine_GetApprentice_ViewController ()<MyApprenceTVCL_GetApprenceVCL_protocl,UITableViewDelegate,UITableViewDataSource>


@end

@implementation Mine_GetApprentice_ViewController{
    UIView*         m_navibar_view;
    NSInteger       m_page;
    
    UIView*         m_No_apprentice_View;
    NSArray*        m_tableview_array_model;
    
    NSArray*        m_array_model;
    UITableView*    m_tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    m_page = 0;
    [self initNavi];
    [self initTabeView];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([Login_info share].isLogined){
        [m_tableview.header beginRefreshing];
        [self.view addSubview:m_tableview];
    }
    else{
        [self initView];
    }
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
    
//    UIButton* history_button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-56-14, 21, 56, 14)];
//    [history_button setTitle:@"提现记录" forState:UIControlStateNormal];
//    [history_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [history_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
//    [history_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [navibar_view addSubview:history_button];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-120/2, 18, 120, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"我的徒弟";
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

-(void)initTabeView{
//    UIView* main_view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_navibar_view.frame)-StaTusHight,
//                                                                 SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(m_navibar_view.frame)+StaTusHight)];
//    main_view.clipsToBounds = YES;
    
//    Mine_MyApprentice_TableViewController* tableView = [[Mine_MyApprentice_TableViewController alloc] init];
//    tableView.array_model = self.array_model;
//    tableView.delegate = self;
//    m_tableView = tableView;
//    [main_view addSubview:tableView.tableView];
    
    m_tableview = [[UITableView alloc] init];
    m_tableview.frame = CGRectMake(0, CGRectGetMaxY(m_navibar_view.frame),
                                   SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(m_navibar_view.frame));
    m_tableview.bounces = YES;
    m_tableview.delegate = self;
    m_tableview.dataSource = self;
    m_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_tableview.estimatedRowHeight = [Mine_GetApprentice_TableViewCell HightForCell];
    
    GYHHeadeRefreshController* headerView = [GYHHeadeRefreshController headerWithRefreshingBlock:^{
        [self GetApprenticeData:0];
    }];
    //头部刷新视图设置
    headerView.lastUpdatedTimeLabel.hidden = YES;
    headerView.stateLabel.hidden = YES;
    m_tableview.header = headerView;
    if([Login_info share].isLogined){
        [headerView beginRefreshing];
        [self.view addSubview:m_tableview];
    }
    else{
        [self initView];
    }
    
    MJRefreshAutoFooter* footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self GetApprenticeData:m_page];
    }];
    m_tableview.footer = footer;
    
    
}

-(void)initView{
    UIView* main_view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_navibar_view.frame),
                                                                 SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(m_navibar_view.frame))];
    m_No_apprentice_View = main_view;
    
    UIImageView* img_view = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-90/2, 181, 90, 90)];
    [img_view setImage:[UIImage imageNamed:@"ic_empty_disciple"]];
    [main_view addSubview:img_view];
    
    UILabel* tips_label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-150/2, CGRectGetMaxY(img_view.frame)+16, 150, 12)];
    tips_label.text = @"竟然没有徒弟~";
    tips_label.textColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0];
    tips_label.textAlignment = NSTextAlignmentCenter;
    tips_label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:12];
    [main_view addSubview:tips_label];
    
    UIButton* GoToGetMoney = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-240/2, CGRectGetMaxY(tips_label.frame)+32, 240, 40)];
    [GoToGetMoney setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    [GoToGetMoney setTitle:@"马上邀请好友" forState:UIControlStateNormal];
    [GoToGetMoney setTitleColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.87/1.0] forState:UIControlStateNormal];
    [GoToGetMoney.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:16]];
    [GoToGetMoney addTarget:self action:@selector(GetFreinds) forControlEvents:UIControlEventTouchUpInside];
    [GoToGetMoney.layer setCornerRadius:20];
    GoToGetMoney.clipsToBounds = YES;
    [main_view addSubview:GoToGetMoney];
    
    [self.view addSubview:main_view];
}

-(void)show_NoApprentice_view{
    [self.view addSubview:m_No_apprentice_View];;
}

-(void)hide_NoApprentice_view{
    [m_No_apprentice_View removeFromSuperview];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(m_tableview_array_model){
        return m_tableview_array_model.count;
    }else{
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Mine_GetApprentice_TableViewCell* cell = [Mine_GetApprentice_TableViewCell CellForTableView:tableView];
    cell.model = m_tableview_array_model[indexPath.row];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"我的徒弟 cell click");
    Mine_GetApprentice_model* model = m_tableview_array_model[indexPath.row];
    [self showApprenceInfo:model];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Mine_GetApprentice_TableViewCell HightForCell];
}

#pragma mark - 协议方法
-(void)showApprenceInfo:(Mine_GetApprentice_model *)model{
    Mine_apprenceInfo_ViewController* vc = [[Mine_apprenceInfo_ViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 按钮方法
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)GetFreinds{
    NSLog(@"马上邀请好友");
    if(![Login_info share].isLogined){
        Mine_login_ViewController*vc = [Mine_login_ViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    Mine_inviteApprence_ViewController* vc = [[Mine_inviteApprence_ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 数据获取API
-(void)GetApprenticeData:(NSInteger)type{
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/getSlaveRecord"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[[Login_info share]GetUserInfo].user_id]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%ld\"",@"page",m_page]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"size",10]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":%ld",@"client_type",IOS]];//设备类型 1:android 2；ios
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    IMP_BLOCK_SELF(Mine_GetApprentice_ViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error || data == nil){
                NSLog(@"GetApprenticeData网络获取失败");
                //发送失败消息
//                [[AlertHelper Share] ShowMe:self And:2.0 And:@"网络失败"];
                [MyMBProgressHUD ShowMessage:@"网络失败" ToView:self.view AndTime:1.0f];
                [m_tableview.header endRefreshing];
                [m_tableview.footer endRefreshing];
                return ;
            }
            
            NSLog(@"GetApprenticeData从服务器获取到数据");
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSArray* list_array = dict[@"list"];
            
                NSArray* array_model = [Mine_GetApprentice_model dicToArray:list_array];
                if (type == 0) {
                    m_tableview_array_model = array_model;
                    if(array_model.count == 0){//没有数据
                        [block_self initView];
                        [m_tableview removeFromSuperview];
                        [block_self show_NoApprentice_view];
                    }else{
                        [block_self hide_NoApprentice_view];
                        if(array_model.count < 10){
                            [m_tableview.header endRefreshing];
                            [m_tableview.footer removeFromSuperview];
                            [m_tableview reloadData];
                            return ;
                        }
                        [m_tableview reloadData];
                        m_page++;
                    }
                    [m_tableview.header endRefreshing];
                    
                }else{
                    [block_self hide_NoApprentice_view];
                    NSMutableArray* mutable_array = [NSMutableArray arrayWithArray:m_tableview_array_model];
                    [mutable_array addObjectsFromArray:array_model];
                    m_tableview_array_model = mutable_array;
                    if(array_model.count == 0){//没有更多数据
                        [m_tableview.footer noticeNoMoreData];
                    }else{
                        [m_tableview reloadData];
                        m_page += 1;
                        
                        [m_tableview.footer endRefreshing];
                    }
                    
                }
            
        
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
