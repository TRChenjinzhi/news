//
//  SearchName_TableViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SearchName_TableViewController.h"
#import "Search_word_TableViewCell.h"

@interface SearchName_TableViewController ()<RemoveSearchWordDelegete>

@end

@implementation SearchName_TableViewController{
    NSArray*        array_word;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//        self.tableView.automaticallyAdjustsScrollViewInsets = false;contentInsetAdjustmentBehavior
    self.extendedLayoutIncludesOpaqueBars = true;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

//    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.tableView registerClass:[Search_word_TableViewCell class] forCellReuseIdentifier:@"search_word_cell"];
    
    array_word = [[AppConfig sharedInstance] GetSearchWordAndType:[NSString stringWithFormat:@"%ld",self.type]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return array_word.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Search_word_TableViewCell* cell = [Search_word_TableViewCell CellForTableView:tableView];
    cell.word = array_word[indexPath.row];
    cell.m_remove_word.tag = indexPath.row;
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 34.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Search_word_TableViewCell HightForCell];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* header_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
    
    UILabel* header_lable = [[UILabel alloc] initWithFrame:CGRectMake(16, 14, 100, 12)];
    header_lable.text = @"最近搜索历史";
    header_lable.textColor = [UIColor colorWithRed:167/255.0 green:169/255.0 blue:169/255.0 alpha:1/1.0];
    header_lable.textAlignment = NSTextAlignmentLeft;
    header_lable.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:12];
    
    [header_view addSubview:header_lable];
    
    return header_view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIButton* foot_lable = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 100, 14)];
    [foot_lable setTitle:@"清空历史记录" forState:UIControlStateNormal];
    [foot_lable setTitleColor:[UIColor colorWithRed:167/255.0 green:169/255.0 blue:169/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    [foot_lable.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [foot_lable.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
    [foot_lable addTarget:self action:@selector(RemoveAllSearchWord) forControlEvents:UIControlEventTouchUpInside];
    return foot_lable;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"search click");
    [self.delegate selectedSearchName:array_word[indexPath.row]];
    
}

#pragma mark 协议方法
-(void)RemoveSearchWord:(NSInteger)index{
    [[AppConfig sharedInstance] removeSearchWordByIndex:index AndType:[NSString stringWithFormat:@"%ld",self.type]];
    array_word = [[AppConfig sharedInstance] GetSearchWordAndType:[NSString stringWithFormat:@"%ld",self.type]];
    [self.tableView reloadData];
}

-(void)RemoveAllSearchWord{
    [[AppConfig sharedInstance] removeSearchWordAllAndType:[NSString stringWithFormat:@"%ld",self.type]];
    array_word = [NSArray array];
    [self.tableView reloadData];
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
