//
//  Video_detail_tuijian_TableViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/4/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Video_detail_tuijian_TableViewController.h"
#import "Video_detail_tuijianTableViewCell.h"
#import "video_channel_model.h"

@interface Video_detail_tuijian_TableViewController ()

@end

@implementation Video_detail_tuijian_TableViewController{
    NSArray*        m_array_model;
    UIView*         m_section_footerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSectionFooterView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[Video_detail_tuijianTableViewCell class] forCellReuseIdentifier:@"Video_detail_tuijianTableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setArray_model:(NSArray *)array_model{
    m_array_model = array_model;
    [self.tableView reloadData];
}

-(void)setSectionFooterView{
    m_section_footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kWidth(46))];
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kWidth(10))];
    line.backgroundColor = RGBA(242, 242, 242, 1);
    [m_section_footerView addSubview:line];
    
    //相关推荐
    UIView* line_tmp = [[UIView alloc] initWithFrame:CGRectMake(kWidth(16), CGRectGetMaxY(line.frame)+kWidth(16), kWidth(4), kWidth(20))];
    line_tmp.backgroundColor = RGBA(248, 205, 4, 1);
    [m_section_footerView addSubview:line_tmp];
    
    UILabel* tableview_title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line_tmp.frame)+kWidth(8), CGRectGetMaxY(line.frame)+kWidth(16), kWidth(75), kWidth(18))];
    tableview_title.text = @"热门评论";
    tableview_title.textColor = RGBA(122, 125, 125, 1);
    tableview_title.textAlignment = NSTextAlignmentLeft;
    tableview_title.font = kFONT(18);
    [m_section_footerView addSubview:tableview_title];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(m_array_model == nil){
        return 0;
    }
    return m_array_model.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Video_detail_tuijianTableViewCell* cell = [Video_detail_tuijianTableViewCell CellFormTable:tableView];
    video_info_model* model = m_array_model[indexPath.row];
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Video_detail_tuijianTableViewCell cellForHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    video_info_model *data = m_array_model[indexPath.row];
    data.isReading = YES;//标题变灰
    //一个cell刷新
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    [self.delegate goToOtherDetail:data];
    [tableView reloadData];

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return m_section_footerView;
}
@end
