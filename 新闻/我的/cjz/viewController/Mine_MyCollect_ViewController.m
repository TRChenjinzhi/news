//
//  Mine_MyCollect_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_MyCollect_ViewController.h"
#import "CJZdataModel.h"
#import "NoImageCell.h"
#import "OneImageCell.h"
#import "ThreeImageCell.h"
#import "DetailWeb_ViewController.h"
#import "Video_detail_tuijianTableViewCell.h"
#import "Video_detail_ViewController.h"

@interface Mine_MyCollect_ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray* totalArray;
@property (nonatomic,strong)UITableView* tableview;

@end

@implementation Mine_MyCollect_ViewController{
    UIView*         m_navibar_view;
    UIView*         m_NoResult_view;
    UILabel*        m_title;
    UIActivityIndicatorView* m_waitting_view;
    
    NSInteger       m_page;
    BOOL            m_IsEdit;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavi];
    [self initView];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteNews:) name:@"收藏新闻删除" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    m_title.text = @"我的收藏";
    if([Login_info share].isLogined){
        [self.tableview.header beginRefreshing];
    }
    else{
        [self getDataFailed];
    }
    
}
-(void)initNavi{
    UIView* navibar_view = [[UIView alloc] initWithFrame:CGRectMake(0, StaTusHight, SCREEN_WIDTH, 56)];
    
    UIButton* back_button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
    [back_button setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [back_button setImage:[UIImage imageNamed:@"ic_nav_back"] forState:UIControlStateNormal];
    [back_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navibar_view addSubview:back_button];
    
//    UIButton* edit_button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-56-14, 21, 56, 14)];
//    [edit_button setTitle:@"编辑" forState:UIControlStateNormal];
//    [edit_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [edit_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
//    [edit_button addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
//    [navibar_view addSubview:edit_button];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-150/2, 18, 150, 20)];
    m_title = title;
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"我的收藏";
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

-(void)initView{
    UIView* main_view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_navibar_view.frame),
                                                                 SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(m_navibar_view.frame))];
    m_NoResult_view = main_view;
    UIImageView* img_view = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-90/2, 181, 90, 90)];
    [img_view setImage:[UIImage imageNamed:@"ic_empty_like"]];
    [main_view addSubview:img_view];
    
    UILabel* tips_label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-200/2, CGRectGetMaxY(img_view.frame)+16, 200, 12)];
    tips_label.text = @"这里空空的，什么也没有~";
    tips_label.textColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0];
    tips_label.textAlignment = NSTextAlignmentCenter;
    tips_label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:12];
    [main_view addSubview:tips_label];
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(m_navibar_view.frame),
                                                                  SCREEN_WIDTH,
                                                                  SCREEN_HEIGHT-CGRectGetMaxY(m_navibar_view.frame))];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.bounces = NO;
    [self.tableview setSeparatorInset:UIEdgeInsetsZero];
    [self.tableview setLayoutMargins:UIEdgeInsetsZero];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerClass:[Video_detail_tuijianTableViewCell class] forCellReuseIdentifier:@"Video_detail_tuijianTableViewCell"];
    [self.tableview registerClass:[NoImageCell class] forCellReuseIdentifier:@"NoImg"];
    [self.tableview registerClass:[OneImageCell class] forCellReuseIdentifier:@"OneImg"];
    [self.tableview registerClass:[ThreeImageCell class] forCellReuseIdentifier:@"ThreeImg"];
    GYHHeadeRefreshController* header = [GYHHeadeRefreshController headerWithRefreshingBlock:^{
        m_page = 0;
        [self getData:m_page];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableview.header = header;
    if([Login_info share].isLogined){
        [header beginRefreshing];
    }
    else{
        [self getDataFailed];
    }
    
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getData:m_page];
    }];
    
    [self.view addSubview:self.tableview];
}

-(void)getDataFailed{
    [self.tableview removeFromSuperview];
    [self.view addSubview:m_NoResult_view];
}

-(void)deleteNews:(NSInteger)index{

    CJZdataModel* model  = self.totalArray[index];
    
    [self CollectedAction:0 AndNewsId:model.ID AndNewsIndex:index];
    [self showWaittingView];
    //数据库清除数据
    [[MyDataBase shareManager] Collect_UpData:[model.ID integerValue] AndIsDIanZan:0];
}

-(void)showWaittingView{
    m_waitting_view = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    m_waitting_view.center = self.view.center;
    m_waitting_view.backgroundColor = [UIColor lightGrayColor];
    m_waitting_view.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    [self.view addSubview:m_waitting_view];
    [m_waitting_view startAnimating];
}

-(void)hideWaittingView{
    [m_waitting_view stopAnimating];
}

#pragma mark - 按钮方法
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)edit:(UIButton*)bt{
    NSLog(@"编辑");
    if([bt.titleLabel.text isEqualToString:@"编辑"]){
        [bt setTitle:@"取消" forState:UIControlStateNormal];
    }else{
        [bt setTitle:@"编辑" forState:UIControlStateNormal];
    }
    m_IsEdit = !m_IsEdit;
    [self.tableview reloadData];
}

#pragma mark - tableview代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.totalArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ThemeManager *defaultManager = [ThemeManager sharedInstance];
//    CJZdataModel *Model = self.totalArray[indexPath.row];

    CJZdataModel *Model = nil;
    NSObject* obj_model = self.totalArray[indexPath.row];
    
    if([obj_model isKindOfClass:[CJZdataModel class]]){
        
        Model = (CJZdataModel*)obj_model;
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
            cell.IsDelete = m_IsEdit;
            cell.m_tag = indexPath.row;
            cell.IsCollect = YES;
            cell.delete_button.tag = indexPath.row;
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
            cell.m_tag = indexPath.row;
            cell.IsDelete = m_IsEdit;
            cell.IsCollect = YES;
            cell.delete_button.tag = indexPath.row;
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
            cell.IsDelete = m_IsEdit;
            cell.m_tag = indexPath.row;
            cell.IsCollect = YES;
            cell.delete_button.tag = indexPath.row;
            return cell;
        }
    }else if([obj_model isKindOfClass:[video_info_model class]]){
        video_info_model* video_model = (video_info_model*)obj_model;
        Video_detail_tuijianTableViewCell* cell = [Video_detail_tuijianTableViewCell CellFormTable:tableView];
        cell.model = video_model;
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CJZdataModel *newsModel = self.totalArray[indexPath.row];
//
//    CGFloat rowHeight = [NoImageCell heightForRow:newsModel];
//    return rowHeight;
    
    NSObject *newsModel = self.totalArray[indexPath.row];
    if([newsModel isKindOfClass:[CJZdataModel class]]){
        CGFloat rowHeight = [NoImageCell heightForRow:(CJZdataModel*)newsModel];
        return rowHeight;
    }else if([newsModel isKindOfClass:[video_info_model class]]){
        return [Video_detail_tuijianTableViewCell cellForHeight];
    }
    
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSObject *obj_model = self.totalArray[indexPath.row];
    if([obj_model isKindOfClass:[CJZdataModel class]]){
//        //新闻
//        ((CJZdataModel*)obj_model).isRreading = YES;
        
        DetailWeb_ViewController* vc = [[DetailWeb_ViewController alloc] init];
        vc.CJZ_model = ((CJZdataModel*)obj_model);
        vc.isFromHistory = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //视频
        ((video_info_model*)obj_model).isReading = YES;
        Video_detail_ViewController* vc = [[Video_detail_ViewController alloc] init];
        vc.model = (video_info_model*)obj_model;
        vc.isFromHistory = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //一个cell刷新
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //在这里实现删除操作
    [self deleteNews:indexPath.row];
    
    //删除数据，和删除动画
    [self.totalArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark - API
-(void)getData:(NSInteger)type{
//http://younews.3gshow.cn/api/getCollect?json={"user_id":"YangYiTestNumber1713841009","page":0,"size":10}
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/getCollect"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[[Login_info share] GetUserInfo].user_id]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%ld\"",@"page",m_page]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"size",10]];
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    IMP_BLOCK_SELF(Mine_MyCollect_ViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if(error || data == nil){
                NSLog(@"网络获取失败");
                [MBProgressHUD showError:@"网络失败"];
                //发送失败消息
                [block_self.tableview.header endRefreshing];
                [block_self.tableview.footer endRefreshing];
                return ;
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"获取新闻失败" object:nil];
            }
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSArray* array_news = dict[@"list"];
            NSArray *dataarray = [video_info_model collectData_ToArray:array_news];
            NSMutableArray *statusArray = [NSMutableArray array];
            for (NSObject *item in dataarray) {
                if([item isKindOfClass:[CJZdataModel class]]){
                    CJZdataModel* data = (CJZdataModel*)item;
                    [statusArray addObject:[self SetData:data]];
                    NSString* time = [[MyDataBase shareManager] Collect_GetTime:[data.ID integerValue]];
                    data.publish_time = time;
                }else{
                    [statusArray addObject:item];
                }
            }
            
            if (type == 0) {
                self.totalArray = statusArray;
                if(statusArray.count == 0){
                    [block_self getDataFailed];
                    return ;
                }
                
            }else{
                [self.totalArray addObjectsFromArray:statusArray];
            }
            
            if(statusArray.count == 0){
                [self.tableview.footer noticeNoMoreData];
            }else{
                [block_self.tableview reloadData];
                m_page += 1;
                
                [block_self.tableview.footer endRefreshing];
            }
            [block_self.tableview.header endRefreshing];
            
            //如果不满10条数据，就隐藏footer
            if(type == 0){
                if(statusArray.count < 10){
                    [block_self.tableview.footer removeFromSuperview];
                }
            }
            
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

-(void)CollectedAction:(NSInteger)action AndNewsId:(NSString*)newsId AndNewsIndex:(NSInteger)index{
    //http://younews.3gshow.cn/api/collect?json={"user_id":"YangYiTestNumber1713841009","news_id":"120","action":1}
    action = action == 1 ? 1 : 2;//1：点赞    2：取消点赞
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/collect"]];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[[Login_info share] GetUserInfo].user_id]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"news_id",newsId]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%ld\"",@"action",action]];//1：点赞    2：取消点赞
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    //    IMP_BLOCK_SELF(DetailWeb_ViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error){
                NSLog(@"网络获取失败");
                //发送失败消息
                [[AlertHelper Share] ShowMe:self And:1.5 And:@"网络错误，请重试"];
                return ;
            }
            [self hideWaittingView];
        });
        
    }];
    [sessionDataTask resume];
}

#pragma mark - 给数据模型 类型
-(CJZdataModel*)SetData:(CJZdataModel*)model{
    model.imgCount = model.images.count;
    return model;
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
