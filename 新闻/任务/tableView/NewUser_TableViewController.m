//
//  NewUser_TableViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewUser_TableViewController.h"
#import "Task_TableViewCell.h"
#import "TaskCellHeaderTitleView.h"

@interface NewUser_TableViewController ()

@end

@implementation NewUser_TableViewController{
    NSArray* m_arrayModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.bounces = NO;
    
    [self.tableView registerClass:[Task_TableViewCell class] forCellReuseIdentifier:@"TaskCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setArray_model:(NSArray *)array_model{
    m_arrayModel = array_model;
    [self.tableView reloadData];
}

-(void)setHeadertitle:(NSString *)Headertitle{
    TaskCellHeaderTitleView* headerView = [[TaskCellHeaderTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
    headerView.title = Headertitle;
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(m_arrayModel){
        return m_arrayModel.count;
    }else{
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Task_TableViewCell* cell = [Task_TableViewCell CellFormTable:tableView];
    TaskCell_model* model = m_arrayModel[indexPath.row];
    
    NSString* readingState = [Login_info share].userInfo_model.is_read_question;
    NSString* wechatState = [Login_info share].userInfo_model.wechat_binding;
    NSString* masterCode = [Login_info share].userInfo_model.mastercode;
    NSString* apprenticeCount = [Login_info share].userInfo_model.appren_count;
    //是否已经阅读过相关阅读
    if([model.title isEqualToString:@"查看常见问题"]){
        if([readingState isEqualToString:@"1"]){
            model.isDone = YES;
        }else{
            model.isDone = NO;
        }
    }
    
    //是否已经微信绑定
    if([model.title isEqualToString:@"绑定微信"]){
        if([wechatState isEqualToString:@"1"]){
            model.isDone = YES;
        }else{
            model.isDone = NO;
        }
    }
    
    //是否已经拜师
    if([model.title isEqualToString:@"输入邀请码"]){
        if(![masterCode isEqualToString:@""]){
            model.isDone = YES;
        }else{
            model.isDone = NO;
        }
    }
    
    //是否已经收徒
    if([model.title isEqualToString:@"首次邀请好友"]){
        if([apprenticeCount integerValue] > 0){
            model.isDone = YES;
        }else{
            model.isDone = NO;
        }
    }
    
    
    cell.taskModel = model;
    cell.type = @"新手任务";
    cell.tag = indexPath.row;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Task_TableViewCell HightForcell];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击 NewUserTabelView");
    
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return false;
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
