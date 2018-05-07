//
//  DayDayTask_TableViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DayDayTask_TableViewController.h"
#import "Task_TableViewCell.h"
#import "TaskCellHeaderTitleView.h"
#import "TaskCellHeader_model.h"

@interface DayDayTask_TableViewController ()

@end

@implementation DayDayTask_TableViewController{
    NSArray*    m_arrayModel;
    BOOL      m_isReadedQuestion;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[Task_TableViewCell class] forCellReuseIdentifier:@"DayDayTaskCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setHeadertitle:(NSString *)Headertitle AndDayCount:(NSInteger)DayCount{
    TaskCellHeaderTitleView* headerView = [[TaskCellHeaderTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 176)];
    headerView.title = Headertitle;
    TaskCellHeader_model* model = [[TaskCellHeader_model alloc] init];
    model.title = @"连续登录奖励";
    model.subTitle = @"自动领取，奖励勤劳的你";
    model.DaysOfSignIn = DayCount;
    headerView.subHeaderVIew_model = model;
    self.tableView.tableHeaderView = headerView;
}

-(void)setArray_model:(NSArray *)array_model{
    m_arrayModel = array_model;
    [self.tableView reloadData];
}

-(void)setIsReadedQuestion:(BOOL)isReadedQuestion{
    m_isReadedQuestion = isReadedQuestion;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(!m_arrayModel){
        return 0;
    }
    else{
        return m_arrayModel.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!m_arrayModel){
        return nil;
    }
    
    Task_TableViewCell* cell = [Task_TableViewCell CellFormTableForDayDayTask:tableView];
    TaskCell_model* model = m_arrayModel[indexPath.row];
    if(![Login_info share].isLogined){
        model.DayDay_model.count = 0;
    }
    else{
        if([model.title isEqualToString:DayDayTask_FirstShouTu]){
            if([[Login_info share].userInfo_model.appren_count integerValue] >= 1){
                model.isDone = YES;
            }
        }else{
            model.isDone = NO;
        }
    }
    cell.taskModel = model;
    cell.type = @"日常任务";
    cell.tag = model.type;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"DayDayTasktableView cell -->点击");
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"日常任务点击" object:[NSNumber numberWithInteger:indexPath.row]];
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return false;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Task_TableViewCell HightForcell];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
