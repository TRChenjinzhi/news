//
//  Mine_goldDetail_TableViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_goldDetail_TableViewController.h"
#import "Mine_goldDetail_TableViewCell.h"
#import "Mine_changeToMoney_TableViewCell.h"
#import "Mine_ChangToMoney_cell_model.h"
#import "Mine_History_cash_detail_ViewController.h"

@interface Mine_goldDetail_TableViewController ()

@end

@implementation Mine_goldDetail_TableViewController{
    NSInteger m_headerHight;
    
    UIView* m_headerView;
    
    UILabel*    m_goldNumber;
    UILabel*    m_packageNumber;
    
    NSString*   m_tableName;
    Money_model*    m_moneyModel;
    
    NSArray*    m_array_cell;
    NSArray*    m_section_array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.bounces = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    self.tableView.automaticallyAdjustsScrollViewInsets = false;contentInsetAdjustmentBehavior
    [self.tableView registerClass:[Mine_goldDetail_TableViewCell class] forCellReuseIdentifier:@"Mine_goldDetail_cell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTableName:(NSString *)tableName{
    
    m_tableName = tableName;
}


-(void)setArray_cells:(NSArray *)array_cells{
    m_array_cell = array_cells;
    
    [self.tableView layoutIfNeeded];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(m_array_cell.count == 0){
        return 0;
    }
    return m_array_cell.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(m_array_cell.count == 0){
        return 0;
    }
    NSArray* array = m_array_cell[section];
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(m_array_cell.count == 0){
        return nil;
    }
    NSArray* section_array = m_array_cell[indexPath.section];
    
    if([m_tableName isEqualToString:@"提现记录"]){
        Mine_changeToMoney_TableViewCell* cell = [[Mine_changeToMoney_TableViewCell alloc] init];
        cell.model = section_array[indexPath.row];
        return cell;
    }
    
    Mine_goldDetail_TableViewCell* cell = [Mine_goldDetail_TableViewCell cellForTableView:tableView];
    cell.cell_model = section_array[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(m_array_cell.count == 0){
        return nil;
    }
    if(m_array_cell){
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
        
        UILabel* time = [[UILabel alloc] initWithFrame:CGRectMake(16, 9, SCREEN_WIDTH, 12)];
        NSArray* section_array = m_array_cell[section];
        if(section_array.count == 0){
            return nil;
        }
        if([m_tableName isEqualToString:@"提现记录"]){
            Mine_ChangToMoney_cell_model* model = section_array[0];
            time.text = [[TimeHelper share] dateChangeToString_mon:model.time];
        }else{
            Mine_goldDetail_cell_model* model = section_array[0];
            time.text = [[TimeHelper share]dateChangeToString_day:model.time];
        }
        time.textColor = [UIColor blackColor];
        time.textAlignment = NSTextAlignmentLeft;
        time.font = [UIFont systemFontOfSize:12];
        
        [view addSubview:time];
        
        return view;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([m_tableName isEqualToString:@"提现记录"]){
        return [Mine_changeToMoney_TableViewCell HightForCell];
    }
    return [Mine_goldDetail_TableViewCell HightForCell];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"金钱详细页面tableView scroll");
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if([m_tableName isEqualToString:@"提现记录"]){
        NSArray* section_array = m_array_cell[indexPath.section];
        Mine_ChangToMoney_cell_model* model = section_array[indexPath.row];
//        Mine_History_cash_detail_ViewController* vc = [Mine_History_cash_detail_ViewController new];
//        vc.model = model;
//        [self.navigationController pushViewController:vc animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Mine_goldDetail_TVCL_To_Mine_History_cash_VCL" object:model];
    }
}

@end
