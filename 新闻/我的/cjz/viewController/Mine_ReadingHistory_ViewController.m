//
//  Mine_ReadingHistory_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_ReadingHistory_ViewController.h"
#import "CJZdataModel.h"
#import "NoImageCell.h"
#import "OneImageCell.h"
#import "ThreeImageCell.h"
#import "DetailWeb_ViewController.h"

@interface Mine_ReadingHistory_ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation Mine_ReadingHistory_ViewController{
    UIView*         m_navibar_view;
    NSArray*        m_array_model;
    UITableView*    m_tableView;
    NSMutableArray* m_header_array;
    UIView*         m_NoResult_view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavi];
    [self NoDataView];
    [self GetData];
    [self initTableView];
    [self initState];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
//    [self GetData];
//    [self initState];
//    [m_tableView reloadData];
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
    
    UIButton* edit_button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-56-14, 21, 56, 14)];
    [edit_button setTitle:@"清空" forState:UIControlStateNormal];
    [edit_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [edit_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
    [edit_button addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    [navibar_view addSubview:edit_button];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-150/2, 18, 150, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"阅读历史";
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

-(void)initTableView{
    m_tableView = [[UITableView alloc] init];
    m_tableView.frame = CGRectMake(0, CGRectGetMaxY(m_navibar_view.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(m_navibar_view.frame));
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.bounces = YES;
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:m_tableView];
}

-(void)NoDataView{
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
}

//是否有数据的状态
-(void)initState{
    if(m_array_model.count == 0){
        [m_tableView removeFromSuperview];
    }
}

#pragma mark - 按钮方法
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clear:(UIButton*)sender{
    NSLog(@"清空");
    [[MyDataBase shareManager] clearTable_ReadingNews];
    m_array_model = [NSArray array];
    [m_tableView reloadData];
    [self initState];
    [self.view addSubview:m_NoResult_view];
    sender.enabled = NO;
}

#pragma mark - 数据库获取数据
-(void)GetData{
    m_array_model = [[MyDataBase shareManager] ReadingNews_GetLastMaxCountData];
    
    if(m_array_model.count == 0){
        [self.view addSubview:m_NoResult_view];
        return;
    }
    //再将 m_array_model 分时间 今天的新闻 ，昨天的新闻 ，2018-03-06
    m_array_model = [[TimeHelper share] sortAllData_day_news:m_array_model];
    
    m_header_array = [NSMutableArray array];
    for (NSArray* tmp in m_array_model) {
        CJZdataModel* model = tmp[0];
        NSString* time = model.publish_time;
        [m_header_array addObject:time];
    }
    
}

#pragma mark - tableview代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return m_array_model.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray* array = m_array_model[section];
    return array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ThemeManager *defaultManager = [ThemeManager sharedInstance];
    NSArray* array = m_array_model[indexPath.section];
    CJZdataModel *Model = array[indexPath.row];
    Model.publish_time = @"";
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
        cell.IsReading = Model.isRreading;
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
        cell.IsReading = Model.isRreading;
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
        cell.IsReading = Model.isRreading;
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray* array = m_array_model[indexPath.section];
    CJZdataModel *newsModel = array[indexPath.row];
    
    CGFloat rowHeight = [NoImageCell heightForRow:newsModel];
    return rowHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray* tmp = m_array_model[indexPath.section];
    CJZdataModel *data = tmp[indexPath.row];
    data.isRreading = YES;
    
    //一个cell刷新
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    DetailWeb_ViewController* vc = [[DetailWeb_ViewController alloc] init];
    vc.CJZ_model = data;
    vc.isFromHistory = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(m_array_model.count == 0){
        return nil;
    }
    if(m_array_model){
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
        
        UILabel* time = [[UILabel alloc] initWithFrame:CGRectMake(16, 9, SCREEN_WIDTH, 12)];
//        NSArray* section_array = m_header_array[section];
//        if(section_array.count == 0){
//            return nil;
//        }
        
        NSString* str_time = m_header_array[section];
        NSString* timeSecond = [[TimeHelper share] dateChangeToTimeSecond:str_time];
        time.text = [[TimeHelper share] dateChangeToString_day:timeSecond];

        time.textColor = [UIColor blackColor];
        time.textAlignment = NSTextAlignmentLeft;
        time.font = [UIFont systemFontOfSize:12];
        
        [view addSubview:time];
        
        return view;
    }else{
        return nil;
    }
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
