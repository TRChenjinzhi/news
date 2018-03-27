//
//  Mine_question_TableViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_question_TableViewController.h"
#import "Mine_question_TableViewCell.h"
#import "LabelHelper.h"

@interface Mine_question_TableViewController ()

@end

@implementation Mine_question_TableViewController{
    NSInteger       m_index;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    self.tableView.automaticallyAdjustsScrollViewInsets = false;contentInsetAdjustmentBehavior
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.tableView registerClass:[Mine_question_TableViewCell class] forCellReuseIdentifier:@"Mine_question_cell"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zhankai:) name:@"常见问题展开" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shousuo:) name:@"常见问题收缩" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initReading:(NSInteger)index{
    for(int i=0;i<_array_question.count;i++){
        Mine_question_model* model = _array_question[i];
        if(i == index){
            model.isReading = YES;
        }else{
            model.isReading = NO;
        }
    }
    [self.tableView reloadData];
}

-(void)initHight:(CGFloat)hight AndIndex:(NSInteger)index{
    for(int i=0;i<_array_question.count;i++){
        Mine_question_model* model = _array_question[i];
        if(i == index){
            model.hight = hight;
        }else{
            model.hight = 54.0;
        }
    }
    [self.tableView reloadData];
}

#pragma mark - 通知
-(void)zhankai:(CGFloat)hight{
    [self initHight:hight AndIndex:m_index];
    [self initReading:m_index];
}

-(void)shousuo:(NSNotification*)noti{
    [self initReading:100];
    [self initHight:0 AndIndex:100];//100的原因 是找不到，所有元素还原
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _array_question.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Mine_question_TableViewCell* cell = [Mine_question_TableViewCell cellForTableView:tableView];
    cell.model = _array_question[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Mine_question_model* model = _array_question[indexPath.row];

    return model.hight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Mine_question_model* model = _array_question[indexPath.row];
    CGFloat textHight = [LabelHelper GetLabelHight:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]
                                           AndText:model.answer
                                          AndWidth:SCREEN_WIDTH-16-16];
    BOOL isReading = model.isReading;
    model.isReading = !model.isReading;
    model.hight = 54+textHight;
    [_array_question replaceObjectAtIndex:indexPath.row withObject:model];
    if(isReading){
        [self shousuo:nil];
    }else{
        m_index = indexPath.row;
        [self zhankai:54+textHight+10];
    }
}


@end
