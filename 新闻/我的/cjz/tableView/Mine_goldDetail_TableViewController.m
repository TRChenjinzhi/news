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
    
//    [self initHeaderView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initHeaderView{
    m_headerHight = 120;
    UIView* header_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, m_headerHight)];
    header_view.backgroundColor = [UIColor colorWithRed:248/255.0 green:205/255.0 blue:4/255.0 alpha:1/1.0];
    
    m_headerView = header_view;
    self.tableView.tableHeaderView = m_headerView;
    
    if([m_tableName isEqualToString:@"金币"]){
        [self headerView_gold];
    }
    if([m_tableName isEqualToString:@"钱包"]){
        [self headerView_package];
    }
}

-(void)setTableName:(NSString *)tableName{
    
    m_tableName = tableName;
}

-(void)headerView_gold{
    
    UILabel* gold_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, SCREEN_WIDTH, kWidth(18))];
    gold_label.text = @"我的金币(个)";
    gold_label.textColor = [UIColor blackColor];
    gold_label.textAlignment = NSTextAlignmentCenter;
    gold_label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:kWidth(16)];
    [m_headerView addSubview:gold_label];
    
    UILabel* gold_number = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(gold_label.frame)+16, SCREEN_WIDTH, kWidth(26))];
    gold_number.text = [NSString stringWithFormat:@"%ld",m_moneyModel.gold];
    gold_number.textColor = [UIColor blackColor];
    gold_number.textAlignment = NSTextAlignmentCenter;
    gold_number.font = [UIFont boldSystemFontOfSize:kWidth(24)];
    m_goldNumber = gold_number;
    [m_headerView addSubview:m_goldNumber];
    
//    UILabel* gold_tip = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(gold_number.frame)+11, SCREEN_WIDTH, 24)];
//    gold_tip.text = @"已自动兑换昨日500金币，兑换比例为1000金币=1元";
//    gold_tip.textColor = [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];;
//    gold_tip.textAlignment = NSTextAlignmentCenter;
//    gold_tip.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:10];
//    [m_headerView addSubview:gold_tip];
    
}

-(void)headerView_package{
    UILabel* package_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, SCREEN_WIDTH, kWidth(18))];
    package_label.text = @"我的钱包(元)";
    package_label.textColor = [UIColor blackColor];
    package_label.textAlignment = NSTextAlignmentCenter;
    package_label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:kWidth(16)];
    [m_headerView addSubview:package_label];
    
    UILabel* package_number = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(package_label.frame)+16, SCREEN_WIDTH, kWidth(26))];
    package_number.text = [NSString stringWithFormat:@"%.2f",m_moneyModel.money];
    package_number.textColor = [UIColor blackColor];
    package_number.textAlignment = NSTextAlignmentCenter;
    package_number.font = [UIFont boldSystemFontOfSize:kWidth(24)];
    m_packageNumber = package_number;
    [m_headerView addSubview:m_packageNumber];
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
