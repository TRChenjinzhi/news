//
//  Task_newUser_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/5/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Task_newUser_ViewController.h"
#import "NewUser_TableViewController.h"
#import "Task_TableViewCell.h"
#import "Mine_question_ViewController.h"
#import "Mine_login_ViewController.h"
#import "Mine_result_changToCash_ViewController.h"

@interface Task_newUser_ViewController ()<UITextFieldDelegate>

@end

@implementation Task_newUser_ViewController{
    UIView*                         m_navibar_view;
    NSMutableArray*                 userTitleArray_model;
    NewUser_TableViewController*    NewUserTabelViewControl;
    UIView*                         m_newuserVCL_view;
    UIButton*                       m_sendBtn;
    UITextField*                    m_name_textField;
    MBProgressHUD*                  waiting;
    
    NSNumber*                       m_number_goToOtherVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavibar];
    [self initView];
    if([Login_info share].isLogined){
        [self getNewUserTaskCount];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newuserTask_click:) name:@"新手任务点击" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TaskRefresh) name:@"任务状态更新" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:m_name_textField];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if(m_number_goToOtherVC != nil){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"频道切换" object:m_number_goToOtherVC];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNavibar{
    UIView* navibar_view = [[UIView alloc] initWithFrame:CGRectMake(0, StaTusHight, SCREEN_WIDTH, 56)];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, SCREEN_WIDTH, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"新手任务";
    title.font = [UIFont boldSystemFontOfSize:18];
    title.textColor = [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    [navibar_view addSubview:title];
    
    UIButton* back_button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
    [back_button setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [back_button setImage:[UIImage imageNamed:@"ic_nav_back"] forState:UIControlStateNormal];
    [back_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navibar_view addSubview:back_button];
    
    //line
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 56-1, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [navibar_view addSubview:line];
    
    [self.view addSubview:navibar_view];
    m_navibar_view = navibar_view;
}

-(void)initView{
    //新手
    [self GetData];
    //    NSLog(@"logoView-->%f",CGRectGetMaxY(self.titleView.frame));
    UIView* newUserView = [[UIView alloc] initWithFrame:CGRectMake(0, 94, SCREEN_WIDTH, 48+66*userTitleArray_model.count)];
    newUserView.backgroundColor = [[ThemeManager sharedInstance] GetDialogViewColor];
    NewUser_TableViewController* newUser_tableView = [[NewUser_TableViewController alloc] initWithStyle:UITableViewStylePlain];
    newUser_tableView.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 48+66*userTitleArray_model.count);
    newUser_tableView.array_model = userTitleArray_model;
    newUser_tableView.Headertitle = @"新手任务";
    [newUser_tableView.tableView registerClass:[Task_TableViewCell class] forCellReuseIdentifier:@"TaskCell"];
    [newUserView addSubview:newUser_tableView.tableView];
    NewUserTabelViewControl = newUser_tableView;
    [self.view addSubview:newUserView];
    m_newuserVCL_view = newUserView;
    [m_newuserVCL_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(m_navibar_view.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_offset(kWidth(48)+kWidth(66)*userTitleArray_model.count);
    }];
    
    
    //中间灰色 分界区域
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(newUserView.frame), SCREEN_WIDTH, kWidth(10))];
    view.backgroundColor = [[ThemeManager sharedInstance] GetDialogViewColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(m_newuserVCL_view.mas_bottom);
        make.height.mas_offset(kWidth(10));
    }];
    
    //一元提现
    UIView* shu_line = [UIView new];
    shu_line.backgroundColor = RGBA(255, 129, 3, 1);
    [self.view addSubview:shu_line];
    [shu_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_bottom).with.offset(kWidth(20));
        make.left.equalTo(self.view.mas_left).with.offset(kWidth(16));
        make.width.mas_offset(kWidth(4));
        make.height.mas_offset(kWidth(20));
    }];
    
    UILabel* tips = [UILabel new];
    tips.text           = @"一元提现";
    tips.textColor      = RGBA(122, 125, 125, 1);
    tips.textAlignment  = NSTextAlignmentLeft;
    tips.font           = kFONT(18);
    [self.view addSubview:tips];
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shu_line.mas_right).with.offset(kWidth(8));
        make.top.equalTo(view.mas_bottom).with.offset(kWidth(20));
        make.height.mas_offset(kWidth(18));
    }];
    
    //输入包 外面包一层view
    UIView* view_textField  = [UIView new];
    view_textField.backgroundColor = RGBA(242, 242, 242, 1);
    [view_textField.layer setCornerRadius:kWidth(40)/2];
    [self.view addSubview:view_textField];
    [view_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(kWidth(60));
        make.right.equalTo(self.view.mas_right).with.offset(-kWidth(60));
        make.height.mas_offset(kWidth(40));
        make.top.equalTo(tips.mas_bottom).with.offset(kWidth(20));
    }];
    
    UITextField* name_textField = [UITextField new];
    name_textField.backgroundColor          = RGBA(242, 242, 242, 1);
    name_textField.placeholder              = @"请输入微信认证的姓名";
    name_textField.textColor                = RGBA(34, 39, 39, 1);
    name_textField.textAlignment            = NSTextAlignmentCenter;
    name_textField.font                     = kFONT(14);
    [view_textField addSubview:name_textField];
    m_name_textField = name_textField;
    [name_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view_textField.mas_left).with.offset(kWidth(10));
        make.right.equalTo(view_textField.mas_right).with.offset(-kWidth(10));
        make.centerX.equalTo(view_textField.mas_centerX);
        make.centerY.equalTo(view_textField.mas_centerY);
    }];
    
    UIButton* changeToMoney = [UIButton new];
    [changeToMoney setTitle:@"1元提现至微信" forState:UIControlStateNormal];
    [changeToMoney setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
    [changeToMoney setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    changeToMoney.clipsToBounds = YES;
    [changeToMoney.layer setCornerRadius:kWidth(40)/2];
    m_sendBtn = changeToMoney;
    [changeToMoney addTarget:self action:@selector(sendMoneyToServer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeToMoney];
    [changeToMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(kWidth(60));
        make.right.equalTo(self.view.mas_right).with.offset(-kWidth(60));
        make.height.mas_offset(kWidth(40));
        make.top.equalTo(view_textField.mas_bottom).with.offset(kWidth(20));
    }];
    
    UILabel* info_label = [UILabel new];
    info_label.text           = @"（完成新手任务即可提现1元到微信，秒到账）";
    info_label.textColor      = RGBA(167, 169, 169, 1);
    info_label.textAlignment  = NSTextAlignmentCenter;
    info_label.font           = kFONT(12);
    [self.view addSubview:info_label];
    [info_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(changeToMoney.mas_bottom).with.offset(kWidth(10));
        make.height.mas_offset(kWidth(12));
    }];
}

-(void)GetData{
    userTitleArray_model = [TaskData GetNewUserTask_data];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - 按钮方法
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textfield协议
- (void)textFiledEditChanged:(id)notification{
    
//    if (m_name_textField.text.length > 4) {
//        m_name_textField.text = [m_name_textField.text substringToIndex:4];
//        [MyMBProgressHUD ShowMessage:@"最大字数为4" ToView:self.view AndTime:1.0f];
//    }
}

#pragma mark - 通知
-(void)newuserTask_click:(NSNotification*)noti{
    /*
     1. 绑定微信
     2. 查看常见问题（+20金币）xx
     3. 阅读新闻（0/5）
     4. 观看视频（0/5）xx
     5. 朋友圈收徒 xx
     */
    NSNumber* number = noti.object;
    NSInteger index = [number integerValue];
    
    if(![Login_info share].isLogined){//未登陆时
        Mine_login_ViewController* vc = [[Mine_login_ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    else{
        if([[Login_info share].userInfo_model.device_mult_user integerValue] == NotTheDevice){
            [MyMBProgressHUD ShowMessage:@"非绑定设备，不能执行任务" ToView:self.view AndTime:1.0f];
            return;
        }
    }
    switch (index) {
        case Task_blindWechat:
            NSLog(@"绑定微信");
            [UMShareHelper LoginWechat:NewUserTask_blindWechat];
            break;
        case Task_readQuestion:{
            NSLog(@"查看常见问题");
            Mine_question_ViewController* vc = [[Mine_question_ViewController alloc] init];
            vc.isTask = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case Task_apprenitceByPengyouquan:{
            NSLog(@"朋友圈收徒");
            [UMShareHelper ShareName:WeChat_pengyoujuan];
            break;
        }
        case Task_reading:{
            NSLog(@"阅读新闻");
            [self.navigationController popViewControllerAnimated:YES];
            m_number_goToOtherVC = [NSNumber numberWithInt:0];
            break;
        }
        case Task_video:{
            NSLog(@"观看视频");
            [self.navigationController popViewControllerAnimated:YES];
            m_number_goToOtherVC = [NSNumber numberWithInt:1];
            break;
        }
        default:
            break;
    }
    
}

-(void)TaskRefresh{
    [NewUserTabelViewControl.tableView reloadData];
}

//根据正则，过滤特殊字符
- (BOOL)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSRange range = [regex rangeOfFirstMatchInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length)];
//    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
//    return result;
    if(range.location != NSNotFound){
        return YES;
    }
    else{
        return NO;
    }
}



#pragma mark - API
-(void)getNewUserTaskCount{
    //获取新手任务 信息
    [InternetHelp GetNewUserTaskCount_Sucess:^(NSDictionary *dic) {
        
        NSArray* userTaskCount_array = [NewUserTask_model dicToArray:dic[@"list"]];
        [TaskCountHelper share].task_newUser_name_array = userTaskCount_array;
        
        //将数据插入到该任务
        for (NewUserTask_model* item in userTaskCount_array) {
            for (TaskCell_model* model in userTitleArray_model) {
                //@[@"邀请好友",@"阅读新闻",@"绑定分享新闻",@"优质评论",@"晒收入",@"参与抽奖"];
                if(item.type == Task_blindWechat && [model.title isEqualToString:NewUserTask_blindWechat]){
                    model.User_model = item;
                    
                    if(item.max <= item.count){//0：未完成   1：完成
                        model.isDone = YES;
                    }
                    break;
                }
                if(item.type == Task_readQuestion && [model.title isEqualToString:NewUserTask_readQuestion]){
                    model.User_model = item;
                    
                    if(item.max <= item.count){//0：未完成   1：完成
                        model.isDone = YES;
                    }
                    break;
                }
                if(item.type == Task_reading && [model.title isEqualToString:NewUserTask_readNews]){
                    model.User_model = item;
                    
                    if(item.max <= item.count){//0：未完成   1：完成
                        model.isDone = YES;
                    }
                    break;
                }
                if(item.type == Task_video && [model.title isEqualToString:NewUserTask_readVideo]){
                    model.User_model = item;
                    
                    if(item.max <= item.count){//0：未完成   1：完成
                        model.isDone = YES;
                    }
                    break;
                }
                if(item.type == Task_apprenitceByPengyouquan && [model.title isEqualToString:NewUserTask_shareByPengyouquan]){
                    model.User_model = item;
                    
                    if(item.max <= item.count){//0：未完成   1：完成
                        model.isDone = YES;
                    }
                    break;
                }
            }
        }
        
        [self delTask_array:userTitleArray_model];
        
        NewUserTabelViewControl.array_model = userTitleArray_model;
        
//        [self IsHideUserTask];
        
    } Fail:^(NSDictionary *dic) {
        if(dic == nil){
            [MyMBProgressHUD ShowMessage:@"网络错误" ToView:self.view AndTime:1.0f];
        }else{
            [MyMBProgressHUD ShowMessage:dic[@"msg"] ToView:self.view AndTime:1.0f];
        }
    }];
}

//当没有返回该数据类型就删除该任务
-(void)delTask_array:(NSMutableArray*)array{
    for (TaskCell_model* model in userTitleArray_model.reverseObjectEnumerator) {
        if([model.title isEqualToString:NewUserTask_blindWechat] ||
           [model.title isEqualToString:NewUserTask_readNews]){
            if(model.User_model == nil){
                [self deleTask:model];
            }
        }
    }
}

-(void)deleTask:(TaskCell_model*)model{
    [userTitleArray_model removeObject:model];
    [m_newuserVCL_view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(kWidth(48)+kWidth(66)*userTitleArray_model.count);
    }];
    [self.view layoutIfNeeded];
}

-(void)sendMoneyToServer{
    if(![Login_info share].isLogined){
        [MyMBProgressHUD ShowMessage:@"请登录!" ToView:self.view AndTime:1.0f];
        return;
    }
    if(![[TaskCountHelper share] newUserTask_isOver]){
        [MyMBProgressHUD ShowMessage:@"请先完成新手任务" ToView:self.view AndTime:1.0f];
        return;
    }
    if(m_name_textField.text.length <= 0){
        [MyMBProgressHUD ShowMessage:@"请输入真实姓名" ToView:self.view AndTime:1.0f];
        return;
    }
    else{
        if([self filterCharactor:m_name_textField.text withRegex:@"[^\u4e00-\u9fa5]"]){
            NSLog(@"-----有非汉字存在");
            [MyMBProgressHUD ShowMessage:@"只能输入汉字!" ToView:self.view AndTime:1.0f];
            return;
        }
    }
    
    m_sendBtn.enabled = NO;
    
    waiting = [[MBProgressHUD alloc] initWithView:self.view];
    waiting.label.text = @"正在提交..";
    waiting.progress = 0.4;
    waiting.mode = MBProgressHUDModeIndeterminate;
//    waiting.dimBackground = YES;
    [waiting showAnimated:YES]; //显示进度框
    [self.view addSubview:waiting];
    
    [InternetHelp ReplyMoneyByType:Wechat AndMoney:1 Sucess:^(NSDictionary *dic) {
        [waiting removeFromSuperview];
        m_sendBtn.enabled = YES;
        Mine_result_changToCash_ViewController*vc = [Mine_result_changToCash_ViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    Fail:^(NSDictionary *dic) {
        [waiting removeFromSuperview];
        m_sendBtn.enabled = YES;
        if(dic != nil){
            [MyMBProgressHUD ShowMessage:dic[@"info"] ToView:self.view AndTime:1.0f];
        }
        else{
            [MyMBProgressHUD ShowMessage:@"网络错误" ToView:self.view AndTime:1.0f];
        }
        
    }];
}

@end
