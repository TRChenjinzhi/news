//
//  Mine_apprenceInfo_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_apprenceInfo_ViewController.h"
#import "Mine_apprenceInfo_model.h"
#import "Mine_apprenceIncome_TableViewCell.h"

@interface Mine_apprenceInfo_ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation Mine_apprenceInfo_ViewController{
    UIView*         m_navibar_view;
    UIView*         m_apprenceInfo_view;
    UIView*         m_oneGray_view;
    UIView*         m_apprenceCount_view;
    UIView*         m_twoGray_view;
    UIView*         m_apprenceIncome_view;
    UITableView*    m_tableview;
    UILabel*         m_apprenceIncome_NoData_view;
    NSMutableArray* m_array_model;
    UIActivityIndicatorView*    m_waiting;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavi];
    [self initView];
    [self getApprenceIncomeOf15days];
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
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-150/2, 18, 150, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"徒弟详情";
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
    [self apprenceInfo];
    
    UIView* one_view = [self GetGreyView:CGRectMake(0, CGRectGetMaxY(m_apprenceInfo_view.frame), SCREEN_WIDTH, kWidth(30)) AndTitle:@"邀请奖励"];
    [self.view addSubview:one_view];
    m_oneGray_view = one_view;
    
    [self apprenceTaskCount_init];
    
    UIView* two_view = [self GetGreyView:CGRectMake(0, CGRectGetMaxY(m_apprenceCount_view.frame), SCREEN_WIDTH, kWidth(30)) AndTitle:@"贡献明细"];
    [self.view addSubview:two_view];
    m_twoGray_view = two_view;
    
    m_apprenceIncome_view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(two_view.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(two_view.frame))];
    [self.view addSubview:m_apprenceIncome_view];
    
    m_waiting = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(two_view.frame))];
    m_waiting.center = self.view.center;
    [m_waiting setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    m_waiting.backgroundColor = [UIColor whiteColor];
    [m_waiting startAnimating];
    [m_apprenceIncome_view addSubview:m_waiting];
    
    m_tableview = [[UITableView alloc] init];
    m_tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(two_view.frame));
    m_tableview.backgroundColor = [UIColor whiteColor];
    [m_tableview setSeparatorInset:UIEdgeInsetsZero];
    [m_tableview setLayoutMargins:UIEdgeInsetsZero];
    m_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_tableview.delegate = self;
    m_tableview.dataSource = self;
    [m_tableview registerClass:[Mine_apprenceIncome_TableViewCell class] forCellReuseIdentifier:@"Mine_apprenceIncome_cell"];
    
    m_apprenceIncome_NoData_view = [[UILabel alloc] initWithFrame:CGRectMake(0, kWidth(30), SCREEN_WIDTH, kWidth(15))];
    m_apprenceIncome_NoData_view.text = @"没有数据";
    m_apprenceIncome_NoData_view.textColor = RGBA(34, 39, 39, 1);
    m_apprenceIncome_NoData_view.textAlignment = NSTextAlignmentCenter;
    m_apprenceIncome_NoData_view.font = kFONT(14);
}

-(void)apprenceInfo{
    CGFloat height = kWidth(64.0f);
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_navibar_view.frame), SCREEN_WIDTH, height)];
    view.backgroundColor = [UIColor whiteColor];
    m_apprenceInfo_view = view;
    [self.view addSubview:m_apprenceInfo_view];
    
    UIImageView* icon = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth(16), kWidth(16), height-kWidth(16)-kWidth(16), height-kWidth(16)-kWidth(16))];
    [icon sd_setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholderImage:[UIImage imageNamed:@"user_default"]];
    [icon.layer setCornerRadius:(height-kWidth(16)-kWidth(16))/2];
    [view addSubview:icon];
    
    UILabel* name = [[UILabel alloc] init];
    CGFloat width = [LabelHelper GetLabelWidth:kFONT(14) AndText:self.model.name];
    name.frame = CGRectMake(CGRectGetMaxX(icon.frame)+kWidth(8), kWidth(16), width, kWidth(14));
    name.text = self.model.name;
    name.textColor = RGBA(34, 39, 39, 1);
    name.textAlignment = NSTextAlignmentLeft;
    name.font = kFONT(14);
    [view addSubview:name];
    
    UILabel* telephone = [[UILabel alloc] init];
    NSMutableString* str_telephone = [NSMutableString stringWithString:self.model.telephone];
    [str_telephone replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    str_telephone = [NSMutableString stringWithFormat:@"手机号: %@",str_telephone];
    CGFloat width_telephone = [LabelHelper GetLabelWidth:kFONT(11) AndText:str_telephone];
    telephone.frame = CGRectMake(CGRectGetMaxX(icon.frame)+kWidth(8),CGRectGetMaxY(name.frame)+kWidth(5), width_telephone, kWidth(11));
    telephone.text = str_telephone;
    telephone.textColor = RGBA(135, 138, 138, 1);
    telephone.textAlignment = NSTextAlignmentLeft;
    telephone.font = kFONT(11);
    [view addSubview:telephone];
}

-(UIView*)GetGreyView:(CGRect)frame AndTitle:(NSString*)title{
    UIView* view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = RGBA(242, 242, 242, 1);
    
    UILabel* tip = [[UILabel alloc] initWithFrame:CGRectMake(kWidth(16), kWidth(9), SCREEN_WIDTH-kWidth(16), frame.size.height-kWidth(9)-kWidth(9))];
    tip.text = title;
    tip.textColor = RGBA(34, 39, 39, 1);
    tip.textAlignment = NSTextAlignmentLeft;
    tip.font = kFONT(10);
    [view addSubview:tip];
    
    return view;
}

-(void)apprenceTaskCount_init{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_oneGray_view.frame), SCREEN_WIDTH, kWidth(180))];
    m_apprenceCount_view = view;
    
    for (int i=0; i<3; i++) {
        UIView* tmp_view = [self getCountView:i];
        tmp_view.frame = CGRectMake(0, i*kWidth(60), view.frame.size.width, view.frame.size.height);
        [view addSubview:tmp_view];
    }
    
    [self.view addSubview:view];
}

-(UIView*)getCountView:(int)index{
    CGFloat height = kWidth(60.0f);
    CGFloat ball_width = kWidth(10);
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView* line_up = [[UIView alloc] initWithFrame:CGRectMake(kWidth(16)+ball_width/2 -1, 0, 1, height/2-ball_width)];
    line_up.backgroundColor = RGBA(216, 216, 216, 1);
    
    UIView* ball = [[UIView alloc] initWithFrame:CGRectMake(kWidth(16), CGRectGetMaxY(line_up.frame)+ball_width/2, ball_width, ball_width)];
    ball.backgroundColor = RGBA(216, 216, 216, 1);
    [ball.layer setCornerRadius:ball_width/2];
    
    UIView* line_down = [[UIView alloc] initWithFrame:CGRectMake(kWidth(16)+ball_width/2 -1, CGRectGetMaxY(ball.frame)+ball_width, 1, height/2-ball_width)];
    line_down.backgroundColor = RGBA(216, 216, 216, 1);
    
    NSString* text = @"";
    switch (index) {
        case 0:
            text = @"徒弟首次完成100金币任务";
            break;
        case 1:
            text = @"徒弟第二次完成100金币任务";
            break;
        case 2:
            text = @"徒弟第三次完成100金币任务";
            break;
            
        default:
            break;
    }
    CGFloat message_width = [LabelHelper GetLabelWidth:kFONT(14) AndText:text];
    UILabel* message = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ball.frame)+kWidth(11), height/2-kWidth(12)/2, message_width, kWidth(12))];
    message.text = text;
    message.textColor = RGBA(34, 39, 39, 1);
    message.textAlignment = NSTextAlignmentLeft;
    message.font = kFONT(12);
    
    NSString* text_money = @"";
    switch (index) {
        case 0:
            text_money = @"+0.30元";
            break;
        case 1:
            text_money = @"+0.30元";
            break;
        case 2:
            text_money = @"+0.40元";
            break;
            
        default:
            break;
    }
    CGFloat money_width = [LabelHelper GetLabelWidth:kFONT(14) AndText:text_money];
    UILabel* money = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-kWidth(16)-money_width, height/2-kWidth(12)/2, money_width, kWidth(12))];
    money.text = text_money;
    money.textColor = RGBA(216, 216, 216, 1);
    money.textAlignment = NSTextAlignmentRight;
    money.font = kFONT(12);
    
    [view addSubview:line_up];
    [view addSubview:line_down];
    [view addSubview:ball];
    [view addSubview:message];
    [view addSubview:money];
    
    //RGBA(251, 84, 38, 1)
    int count = [self.model.count intValue];
    if(index == 0){
        [line_up removeFromSuperview];
        if(count >= 1){
            ball.backgroundColor = RGBA(251, 84, 38, 1);
            money.textColor = RGBA(251, 84, 38, 1);
        }
    }
    
    if(index == 1){
        if(count >= 2){
            ball.backgroundColor = RGBA(251, 84, 38, 1);
            money.textColor = RGBA(251, 84, 38, 1);
        }
    }
    
    if(index == 2){
        [line_down removeFromSuperview];
        if(count >= 3){
            ball.backgroundColor = RGBA(251, 84, 38, 1);
            money.textColor = RGBA(251, 84, 38, 1);
        }
    }
    
    return view;
}


#pragma mark - 按钮方法
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableview协议
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(m_array_model == nil){
        return 0;
    }else{
        return m_array_model.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Mine_apprenceIncome_TableViewCell* cell = [Mine_apprenceIncome_TableViewCell cellForTableView:tableView];
    Mine_apprenceInfo_model* model = m_array_model[indexPath.row];
    cell.model = model;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(m_array_model.count >= 15){
        UIView* footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kWidth(30))];
        footView.backgroundColor = RGBA(242, 242, 242, 1);
        
        UILabel* tips = [[UILabel alloc] initWithFrame:CGRectMake(kWidth(16), kWidth(30)/2-kWidth(18)/2, SCREEN_WIDTH, kWidth(15))];
        tips.text = @"- 只显示最近15天的贡献明细 -";
        tips.textColor = RGBA(167, 169, 169, 1);
        tips.textAlignment = NSTextAlignmentLeft;
        tips.font = kFONT(10);
        [footView addSubview:tips];
        
        return footView;
    }else{
        UIView* footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kWidth(30))];
        footView.backgroundColor = [UIColor whiteColor];
        return footView;
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Mine_apprenceIncome_TableViewCell HightForCell];
}


#pragma mark - API

-(void)getApprenceIncomeOf15days{
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/getSlaveDetail"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString *argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",self.model.user_id]];
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
//    IMP_BLOCK_SELF(Mine_apprenceInfo_ViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error){
                NSLog(@"网络获取失败");
                //发送失败消息
                [[AlertHelper Share] ShowMe:self And:1.0 And:@"网络失败"];
                return ;
            }
            
            NSLog(@"getApprenceIncomeOf15days从服务器获取到数据");
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* code = dict[@"code"];
            if([code longValue] != 200){
                return;
            }
            m_array_model = [Mine_apprenceInfo_model dicToArray:dict];
            if(m_array_model.count > 0){
                [m_apprenceIncome_view addSubview:m_tableview];
                [m_tableview reloadData];
            }else{
                //没有数据
                [m_apprenceIncome_view addSubview:m_apprenceIncome_NoData_view];
            }
            [m_waiting stopAnimating];
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
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
