//
//  Mine_goldDetail_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_goldDetail_ViewController.h"
#import "Mine_goldDetail_scrollView.h"
#import "Mine_goldDetail_TableViewController.h"
#import "Repply_ChangeToMoney_ViewController.h"
#import "Mine_goldDetail_ViewController.h"
#import "GoldChangeToMoney_ViewController.h"
#import "Mine_goldDetail_cell_model.h"
#import "DateReload_view.h"
#import "Mine_Historty_cash_ViewController.h"


@interface Mine_goldDetail_ViewController ()<UIScrollViewDelegate>

@end

@implementation Mine_goldDetail_ViewController{
    UIView*     m_navibar_view;
    UIView*     m_headerView;
    
    UIView*     m_lable_view;
    UILabel*    m_gold_label;
    UILabel*    m_package_label;
    UITapGestureRecognizer*     m_tap_goldLable;
    UITapGestureRecognizer*     m_tap_packageLable;
    
    NSArray*    m_gold_array;//金币数据
    NSArray*    m_package_array;//钱包数据
    Money_model*    m_moneyModel;
    UIScrollView* m_scrollView;
    UIScrollView*  m_line_scrollView;
    UIView*         m_gold_line;
    UIView*         m_package_line;
    
    Mine_goldDetail_TableViewController*   gold_tvc;
    Mine_goldDetail_TableViewController*   package_tvc;
    NSMutableArray* m_gold_array_all;
    NSMutableArray* m_package_array_all;
    UIView*         m_gold_view;
    UIView*         m_package_view;
    UILabel*        m_goldNumber;
    UILabel*        m_packageNumber;
    NSInteger       m_headerHight;
    
    DateReload_view*    m_reload_gold;
    DateReload_view*    m_reload_package;
    UIActivityIndicatorView*    m_waitting;
    
    //判断滑动方向
    NSInteger       m_selectedIndex;
    CGFloat         m_lastPosition;
    
    NSInteger       m_page_gold;
    NSInteger       m_page_package;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    m_selectedIndex = 0;
    m_lastPosition = 0;
    
    //UI
    [self initNavi];
    [self initHeaderView];
    [self InitTipsView];
    [self initScrollView];
    [self initTableView];
    
    //数据初始化
    m_selectedIndex = self.selectIndex;
    [m_scrollView setContentOffset:CGPointMake(m_selectedIndex*SCREEN_WIDTH, 0)];
    [self ChangeLage:m_selectedIndex];
    
    
    //侧滑退出 与 scrollview 手势冲突
    NSArray *gestureArray = self.navigationController.view.gestureRecognizers;
    for (UIGestureRecognizer *gestureRecognizer in gestureArray) {
        if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
            [m_scrollView.panGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
        }
    }
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
    
//    UIButton* history_button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-56-14, 21, 56, 14)];
//    [history_button setTitle:@"提现记录" forState:UIControlStateNormal];
//    [history_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [history_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
//    [history_button addTarget:self action:@selector(history_changeToMoney) forControlEvents:UIControlEventTouchUpInside];
//    [navibar_view addSubview:history_button];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-80/2, 18, 80, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"收支记录";
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

-(void)initHeaderView{
    m_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_navibar_view.frame), SCREEN_WIDTH, kWidth(148))];
    m_headerView.backgroundColor = RGBA(236, 187, 123, 1);
    [self.view addSubview:m_headerView];
    
    UILabel* total_label = [UILabel new];
    total_label.text = @"累计收入";
    total_label.textColor = RGBA(255, 255, 255, 0.7);
    total_label.textAlignment = NSTextAlignmentCenter;
    total_label.font = kFONT(14);
    [m_headerView addSubview:total_label];
    [total_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(m_headerView);
        make.top.equalTo(m_headerView.mas_top).with.offset(kWidth(20));
        make.width.mas_equalTo(SCREEN_WIDTH/3);
    }];
    
    UILabel* coin_label = [UILabel new];
    coin_label.text = @"当前金币";
    coin_label.textColor = RGBA(255, 255, 255, 0.7);
    coin_label.textAlignment = NSTextAlignmentCenter;
    coin_label.font = kFONT(14);
    [m_headerView addSubview:coin_label];
    [coin_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(total_label.mas_right);
        make.top.equalTo(m_headerView.mas_top).with.offset(kWidth(20));
        make.width.mas_equalTo(SCREEN_WIDTH/3);
    }];
    
    UILabel* money_label = [UILabel new];
    money_label.text = @"当前余额";
    money_label.textColor = RGBA(255, 255, 255, 0.7);
    money_label.textAlignment = NSTextAlignmentCenter;
    money_label.font = kFONT(14);
    [m_headerView addSubview:money_label];
    [money_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(coin_label.mas_right);
        make.top.equalTo(m_headerView.mas_top).with.offset(kWidth(20));
        make.width.mas_equalTo(SCREEN_WIDTH/3);
    }];
    
    UILabel* total_number_label = [UILabel new];
    if([Login_info share].isLogined){
        total_number_label.text = [Login_info share].userMoney_model.total_income;
    }
    else{
        total_number_label.text = @"0.0";
    }
    
    total_number_label.textColor = RGBA(255, 255, 255, 1);
    total_number_label.textAlignment = NSTextAlignmentCenter;
    total_number_label.font = KBFONT(24);
    [m_headerView addSubview:total_number_label];
    [total_number_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(m_headerView);
        make.top.equalTo(total_label.mas_bottom).with.offset(kWidth(10));
        make.width.mas_equalTo(SCREEN_WIDTH/3);
    }];
    
    UILabel* coin_number_label = [UILabel new];
    if([Login_info share].isLogined){
        coin_number_label.text = [Login_info share].userMoney_model.coin;
    }
    else{
        coin_number_label.text = @"0";
    }
    coin_number_label.textColor = RGBA(255, 255, 255, 1);
    coin_number_label.textAlignment = NSTextAlignmentCenter;
    coin_number_label.font = KBFONT(24);
    [m_headerView addSubview:coin_number_label];
    [coin_number_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(total_number_label.mas_right);
        make.top.equalTo(total_label.mas_bottom).with.offset(kWidth(10));
        make.width.mas_equalTo(SCREEN_WIDTH/3);
    }];
    
    UILabel* money_number_label = [UILabel new];
    if([Login_info share].isLogined){
        money_number_label.text = [Login_info share].userMoney_model.cash;
    }
    else{
        money_number_label.text = @"0.0";
    }
    money_number_label.textColor = RGBA(255, 255, 255, 1);
    money_number_label.textAlignment = NSTextAlignmentCenter;
    money_number_label.font = KBFONT(24);
    [m_headerView addSubview:money_number_label];
    [money_number_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(coin_number_label.mas_right);
        make.top.equalTo(total_label.mas_bottom).with.offset(kWidth(10));
        make.width.mas_equalTo(SCREEN_WIDTH/3);
    }];
    
    UIView* white_view = [UIView new];
    white_view.backgroundColor = [UIColor whiteColor];
    [m_headerView addSubview:white_view];
    [white_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(m_headerView.mas_bottom);
        make.left.and.right.equalTo(m_headerView);
        make.height.mas_equalTo(kWidth(30));
    }];
    
    UIButton* changeToMoney_btn = [UIButton new];
//    changeToMoney_btn.backgroundColor = RGBA(251, 84, 31, 1);
    [changeToMoney_btn setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    [changeToMoney_btn setTitle:@"我要提现" forState:UIControlStateNormal];
    [changeToMoney_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [changeToMoney_btn.layer setCornerRadius:kWidth(20)];
    changeToMoney_btn.clipsToBounds = YES;
    [changeToMoney_btn addTarget:self action:@selector(replyToCash) forControlEvents:UIControlEventTouchUpInside];
    [m_headerView addSubview:changeToMoney_btn];
    [m_headerView bringSubviewToFront:changeToMoney_btn];
    [changeToMoney_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kWidth(40));
        make.left.equalTo(m_headerView.mas_left).with.offset(kWidth(80));
        make.right.equalTo(m_headerView.mas_right).with.offset(-kWidth(80));
        make.bottom.equalTo(white_view.mas_top).with.offset(kWidth(20));
    }];
}

-(void)InitTipsView{
    //标签
    UIView* label_view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_headerView.frame), SCREEN_WIDTH, 40)];
    label_view.backgroundColor = [UIColor whiteColor];
    m_lable_view = label_view;
    label_view.userInteractionEnabled = YES;
    
    UILabel* gold_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, SCREEN_WIDTH/2, 16)];
    gold_label.userInteractionEnabled = YES;
    gold_label.text = @"金币";
    gold_label.textColor = [UIColor blackColor];
    gold_label.textAlignment = NSTextAlignmentCenter;
    gold_label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:16];
    m_gold_label = gold_label;
    m_tap_goldLable = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollToGold)];
    [m_gold_label addGestureRecognizer:m_tap_goldLable];
    [label_view addSubview:m_gold_label];
    
    //金币下划线
    UIView* gold_line = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2)/3, CGRectGetMaxY(gold_label.frame)+10, (SCREEN_WIDTH/2)/3, 2)];
    gold_line.backgroundColor = RGBA(255, 129, 3, 1);
    m_gold_line = gold_line;
    [label_view addSubview:m_gold_line];
    
    UILabel* package_label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 12, SCREEN_WIDTH/2, 16)];
    package_label.userInteractionEnabled = YES;
    package_label.text = @"钱包";
    package_label.textColor = [UIColor redColor];
    package_label.textAlignment = NSTextAlignmentCenter;
    package_label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:16];
    m_package_label = package_label;
    m_tap_packageLable = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollToPackage)];
    [m_package_label addGestureRecognizer:m_tap_packageLable];
    [label_view addSubview:m_package_label];
    
    //钱包下划线
    UIView* package_line = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+(SCREEN_WIDTH/2)/3, CGRectGetMaxY(gold_label.frame)+10, (SCREEN_WIDTH/2)/3, 2)];
    package_line.backgroundColor = RGBA(255, 129, 3, 1);
    m_package_line = package_line;
    [label_view addSubview:m_package_line];
    
    [self.view addSubview:m_lable_view];
    
}

-(void)initScrollView{
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                              CGRectGetMaxY(m_lable_view.frame),
                                                                              SCREEN_WIDTH,
                                                                              SCREEN_HEIGHT-CGRectGetMaxY(m_lable_view.frame))];
    m_scrollView = scrollView;
//    scrollView.contentInset = UIEdgeInsetsZero;
    scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    scrollView.array_array_money_model = m_array_array_moneyModel;
//    scrollView.money_model = m_moneyModel;
//    scrollView.section_array = m_section_array;
//    scrollView.selectIndex = 0;
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake(2*SCREEN_WIDTH, 0);
    scrollView.delegate = self;
    [self.view addSubview:m_scrollView];
}

-(void)initTableView{
    UIView* gold_view = [[UIView alloc] init];
    m_gold_view = gold_view;
    gold_view.frame = CGRectMake(0, 0, SCREEN_WIDTH, m_scrollView.frame.size.height);
//    [self initGoldHeaderView];
    Mine_goldDetail_TableViewController* gold_tableview = [[Mine_goldDetail_TableViewController alloc] init];
    gold_tableview.tableName = @"金币";
//    gold_tableview.tableView.frame = CGRectMake(0, m_headerHight, SCREEN_WIDTH, m_scrollView.frame.size.height-m_headerHight);
    gold_tableview.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, m_scrollView.frame.size.height-m_headerHight);
    gold_tvc = gold_tableview;
    [gold_view addSubview:gold_tvc.tableView];
    
    IMP_BLOCK_SELF(Mine_goldDetail_ViewController);
    GYHHeadeRefreshController *header = [GYHHeadeRefreshController headerWithRefreshingBlock:^{
        m_page_gold = 0;
        [block_self GetNetData_gold:m_page_gold];
        
    }];
    //头部刷新视图设置
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    gold_tvc.tableView.header = header;
    if([Login_info share].isLogined){
        [header beginRefreshing];
    }
    else{
        [block_self NoResult_gold];
    }
    
    
    gold_tvc.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [block_self GetNetData_gold:m_page_gold];
    }];

    //底部视图
//    UIView* footView = [[UIView alloc] initWithFrame:CGRectMake(0, m_scrollView.frame.size.height-10-16, SCREEN_WIDTH, 10)];
//
//    UILabel* foot_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
//    foot_label.text = @"- 只显示最近100条数据 -";
//    foot_label.textColor = [UIColor colorWithRed:167/255.0 green:169/255.0 blue:169/255.0 alpha:1/1.0];
//    foot_label.textAlignment = NSTextAlignmentCenter;
//    foot_label.font = [UIFont systemFontOfSize:10];
//    [footView addSubview:foot_label];
//    [gold_view addSubview:footView];
    
    [m_scrollView addSubview:gold_view];
    
    UIView* package_view = [[UIView alloc] init];
    m_package_view = package_view;
    package_view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, m_scrollView.frame.size.height);
//    [self initPackageHeaderView];
    Mine_goldDetail_TableViewController* package_tableview = [[Mine_goldDetail_TableViewController alloc] init];
    package_tableview.tableName = @"钱包";
//    package_tableview.tableView.frame = CGRectMake(0, m_headerHight, SCREEN_WIDTH,
//                                                   SCREEN_HEIGHT-CGRectGetMaxY(m_lable_view.frame)-m_headerHight);
    package_tableview.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH,
                                                   SCREEN_HEIGHT-CGRectGetMaxY(m_lable_view.frame)-m_headerHight);
    package_tvc = package_tableview;
    [package_view addSubview:package_tvc.tableView];
    
    GYHHeadeRefreshController *header_package = [GYHHeadeRefreshController headerWithRefreshingBlock:^{
        m_page_package = 0;
        [block_self GetNetData_package:m_page_package];
        
    }];
    //头部刷新视图设置
    header_package.lastUpdatedTimeLabel.hidden = YES;
    header_package.stateLabel.hidden = YES;
    package_tvc.tableView.header = header_package;
//    [header_package beginRefreshing];
    if([Login_info share].isLogined){
        [header_package beginRefreshing];
    }
    else{
        [block_self NoResult_package];
    }
    
    package_tvc.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [block_self GetNetData_package:m_page_package];
    }];
    //提现按钮
//    UIButton* ChangeTOMoney_button = [[UIButton alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(package_tableview.tableView.frame)+10, SCREEN_WIDTH-16-16, 40)];
//    [ChangeTOMoney_button setTitle:@"申请提现" forState:UIControlStateNormal];
//    [ChangeTOMoney_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [ChangeTOMoney_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:16]];
//    ChangeTOMoney_button.backgroundColor = [UIColor colorWithRed:248/255.0 green:205/255.0 blue:4/255.0 alpha:1/1.0];
//    [ChangeTOMoney_button addTarget:self action:@selector(ChangeToMoney_repply) forControlEvents:UIControlEventTouchUpInside];
//    [package_view addSubview:ChangeTOMoney_button];
    
    [m_scrollView addSubview:package_view];
}

-(void)initGoldHeaderView{
    m_headerHight = 120;
    UIView* header_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, m_headerHight)];
    header_view.backgroundColor = [UIColor colorWithRed:248/255.0 green:205/255.0 blue:4/255.0 alpha:1/1.0];
    
    UILabel* gold_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, SCREEN_WIDTH, kWidth(18))];
    gold_label.text = @"我的金币(个)";
    gold_label.textColor = [UIColor blackColor];
    gold_label.textAlignment = NSTextAlignmentCenter;
    gold_label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:kWidth(16)];
    [header_view addSubview:gold_label];
        
    UILabel* gold_number = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(gold_label.frame)+16, SCREEN_WIDTH, kWidth(26))];
    gold_number.text = [NSString stringWithFormat:@"%@",[[Login_info share] GetUserMoney].coin];
    gold_number.textColor = [UIColor blackColor];
    gold_number.textAlignment = NSTextAlignmentCenter;
    gold_number.font = [UIFont boldSystemFontOfSize:kWidth(24)];
    m_goldNumber = gold_number;
    [header_view addSubview:m_goldNumber];
        
    UILabel* gold_tip = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(gold_number.frame)+11, SCREEN_WIDTH, 24)];
//    gold_tip.text = @"已自动兑换昨日500金币，兑换比例为1000金币=1元";
    gold_tip.textColor = [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];;
    gold_tip.textAlignment = NSTextAlignmentCenter;
    gold_tip.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:10];
    [header_view addSubview:gold_tip];
    
    [m_gold_view addSubview:header_view];
}

-(void)initPackageHeaderView{
    m_headerHight = 120;
    UIView* header_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, m_headerHight)];
    header_view.backgroundColor = [UIColor colorWithRed:248/255.0 green:205/255.0 blue:4/255.0 alpha:1/1.0];
    
    UILabel* package_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, SCREEN_WIDTH, kWidth(18))];
    package_label.text = @"我的钱包(元)";
    package_label.textColor = [UIColor blackColor];
    package_label.textAlignment = NSTextAlignmentCenter;
    package_label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:kWidth(16)];
    [header_view addSubview:package_label];
    
    UILabel* package_number = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(package_label.frame)+16, SCREEN_WIDTH, kWidth(26))];
    package_number.text = [NSString stringWithFormat:@"%@",[[Login_info share]GetUserMoney].cash];
    package_number.textColor = [UIColor blackColor];
    package_number.textAlignment = NSTextAlignmentCenter;
    package_number.font = [UIFont boldSystemFontOfSize:kWidth(24)];
    m_packageNumber = package_number;
    [header_view addSubview:m_packageNumber];
    
    [m_package_view addSubview:header_view];
}

#pragma mark - 按钮方法
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)history_changeToMoney{
    NSLog(@"提现记录");
    Mine_Historty_cash_ViewController* vc = [[Mine_Historty_cash_ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)ChangeToMoney_repply{
    NSLog(@"申请提现");
    GoldChangeToMoney_ViewController* vc = [[GoldChangeToMoney_ViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)scrollToPackage{
    //数据初始化
    m_selectedIndex = 1;
    [m_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    [self ChangeLage:m_selectedIndex];
}

-(void)scrollToGold{
    //数据初始化
    m_selectedIndex = 0;
    [m_scrollView setContentOffset:CGPointMake(0, 0)];
    [self ChangeLage:m_selectedIndex];
}

-(void)replyToCash{
    GoldChangeToMoney_ViewController* vc = [[GoldChangeToMoney_ViewController alloc] init];
    Mine_changeToMoney_model* model = [[Mine_changeToMoney_model alloc] init];
    model.total_cash = [[Login_info share].userMoney_model.total_cashed floatValue];
    model.total_income =  [[Login_info share].userMoney_model.total_income floatValue];
    model.money = [[Login_info share].userMoney_model.cash floatValue];
//    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 标签与scrollView页面的 对应
-(void)ChangeLage:(NSInteger)index{
    if(index == 0){
        m_gold_label.textColor      =    [UIColor blackColor];
        m_package_label.textColor   =    [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:0.5/1.0];
        m_gold_line.hidden = NO;
        m_package_line.hidden = YES;
        
    }else{
        m_gold_label.textColor      =    [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:0.5/1.0];
        m_package_label.textColor   =    [UIColor blackColor];
        m_gold_line.hidden = YES;
        m_package_line.hidden = NO;
    }
    
}

#pragma mark - scrll代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"scrollView-->x:%f",scrollView.contentOffset.x);
    CGFloat currentPosition = scrollView.contentOffset.x;
    if(currentPosition > m_lastPosition){
        //往右滑
        if(currentPosition == SCREEN_WIDTH){
            if(m_selectedIndex == 0){
                [self ChangeLage:1];
                m_selectedIndex = 1;
            }
            
        }
    }
    else{
        //往左滑
        if(currentPosition == 0){
            if(m_selectedIndex == 1){
                [self ChangeLage:0];
                m_selectedIndex = 0;
            }
        }
    }
    
    m_lastPosition = currentPosition;
}

/*
 # url : http://39.104.13.61/api/getCoinRecord?json={"user_id":"814B08C64ADD12284CA82BA39384B177","page":"0","size":"10"}
 {
 "user_id": "814B08C64ADD12284CA82BA39384B177",   #用户唯一标识
 "page":0,   //页码
 "size":10,  //每页显示条数
 }
 */

#pragma mark - 数据获取API
-(void)GetNetData_gold:(NSInteger)type{
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/getCoinRecord"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[[Login_info share]GetUserInfo].user_id]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%ld\"",@"page",m_page_gold]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"size",10]];
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    IMP_BLOCK_SELF(Mine_goldDetail_ViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if(error || data == nil){
                NSLog(@"网络获取失败");
                //发送失败消息
//                [[AlertHelper Share] ShowMe:self And:1.0 And:@"网络失败"];
                [MyMBProgressHUD ShowMessage:@"网络失败" ToView:self.view AndTime:1.0f];
                [gold_tvc.tableView.header endRefreshing];
                [gold_tvc.tableView.footer endRefreshing];
                return ;
            }
            
            NSLog(@"GetNetData_gold从服务器获取到数据");
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* code = dict[@"code"];
            if([code longValue] != 200){
                [gold_tvc.tableView.header endRefreshing];
                return;
            }
            NSArray* array_model = [Mine_goldDetail_cell_model dicToModelArray:dict];
            NSArray* array_tmp = nil;
            
            if(m_gold_array_all == nil){
                m_gold_array_all = [NSMutableArray array];
            }
            
            
            if (type == 0) {
                if(array_model.count != 0){
                    array_tmp = [[TimeHelper share] sortAllData_day:array_model];//[array,array]
                    if(array_model.count < 10){
                        gold_tvc.tableView.footer = nil;
                    }
                }else{
                    array_tmp = [NSArray array];
                }
                m_gold_array = array_tmp;
                gold_tvc.array_cells = m_gold_array;
                m_gold_array_all = [NSMutableArray arrayWithArray:array_model];
                if(array_model.count == 0){
                    [gold_tvc.tableView.footer noticeNoMoreData];
                }
            }else{
                for (Mine_goldDetail_cell_model* model in array_model) {
                    [m_gold_array_all addObject:model];
                }
                array_tmp = [[TimeHelper share] sortAllData_day:m_gold_array_all];
                m_gold_array = array_tmp;
                gold_tvc.array_cells = m_gold_array;
            }
            
//            NSArray* array = array_tmp;
            if(array_model.count == 0){ //当数据为空时
                [gold_tvc.tableView.footer noticeNoMoreData];
                if(type == 0 && m_gold_array.count == 0){
                    [block_self NoResult_gold];
                }
                [gold_tvc.tableView.header endRefreshing];
            }else{
                [gold_tvc.tableView reloadData];
                m_page_gold += 1;
                
                [gold_tvc.tableView.footer endRefreshing];
                [m_reload_gold removeFromSuperview];
            }
            [m_waitting stopAnimating];
            [gold_tvc.tableView.header endRefreshing];
            [gold_tvc.tableView.header endRefreshing];

        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

-(void)GetNetData_package:(NSInteger)type{
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/getCashRecord"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString *argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[[Login_info share]GetUserInfo].user_id]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%ld\"",@"page",type]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%d\"",@"size",10]];
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    IMP_BLOCK_SELF(Mine_goldDetail_ViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if(error || data == nil){
                NSLog(@"网络获取失败");
                //发送失败消息
//                [[AlertHelper Share] ShowMe:self And:2.0 And:@"网络失败"];
                [MyMBProgressHUD ShowMessage:@"网络失败" ToView:self.view AndTime:1.0f];
                [package_tvc.tableView.header endRefreshing];
                [package_tvc.tableView.footer endRefreshing];
                return ;
            }
            
            NSLog(@"GetNetData_package从服务器获取到数据");
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* code = dict[@"code"];
            if([code longValue] != 200){
                [package_tvc.tableView.header endRefreshing];
                [package_tvc.tableView.footer endRefreshing];
                return;
            }
            NSArray* array_model = [Mine_goldDetail_cell_model dicToModelArray_package:dict];
            
            if(m_package_array_all == nil){
                m_package_array_all = [NSMutableArray array];
            }
            
            
            NSArray* array_tmp = nil;
            
            if (type == 0) {
                array_tmp = [[TimeHelper share] sortAllData_day:array_model];//[array,array]
                m_package_array = array_tmp;
                package_tvc.array_cells = m_package_array;
                m_package_array_all = [NSMutableArray arrayWithArray:array_model];
                
            }else{
                for (Mine_goldDetail_cell_model* model in array_model) {//记录所有数据
                    [m_package_array_all addObject:model];
                }
                array_tmp = [[TimeHelper share] sortAllData_day:m_package_array_all];
                m_package_array = array_tmp;
                package_tvc.array_cells = m_package_array;
            }
            
            if(array_model.count == 0){ //当数据为空时
                [package_tvc.tableView.footer noticeNoMoreData];
                
//                [package_tvc.tableView.footer endRefreshing];
                [package_tvc.tableView.header endRefreshing];
                return;
            }else{
                if(type == 0){
            
                    if(array_model.count < 10 && array_model.count > 0){
                        package_tvc.tableView.footer = nil;
                    }
                    else if(array_model.count  == 0 && m_package_array.count == 0){
                        [block_self NoResult_package];
                    }
                }
                [package_tvc.tableView reloadData];
                m_page_package += 1;
                [package_tvc.tableView.footer endRefreshing];
                [m_reload_package removeFromSuperview];
            }
            [m_waitting stopAnimating];
            [package_tvc.tableView.footer endRefreshing];
            [package_tvc.tableView.header endRefreshing];
            
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}


-(void)NoResult_gold{
    
    [gold_tvc.tableView removeFromSuperview];
    UILabel* NoData_label = [UILabel new];
    NoData_label.text               = @"暂时没有数据";
    NoData_label.textColor          = RGBA(34, 39, 39, 1);
    NoData_label.textAlignment      = NSTextAlignmentCenter;
    NoData_label.font               = kFONT(12);
    [m_gold_view addSubview:NoData_label];
    [NoData_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(m_gold_view);
        make.centerY.equalTo(m_gold_view);
    }];
    
}
-(void)NoResult_package{

    
    [package_tvc.tableView removeFromSuperview];
    UILabel* NoData_label = [UILabel new];
    NoData_label.text               = @"暂时没有数据";
    NoData_label.textColor          = RGBA(34, 39, 39, 1);
    NoData_label.textAlignment      = NSTextAlignmentCenter;
    NoData_label.font               = kFONT(12);
    [m_package_view addSubview:NoData_label];
    [NoData_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(m_package_view);
        make.centerY.equalTo(m_package_view);
    }];
    
}
-(void)TVC_gold_reload{
    
    [gold_tvc.tableView.header beginRefreshing];
    UIActivityIndicatorView* waiting = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    waiting.center = m_gold_view.center;
    [waiting setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [waiting setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [waiting setBackgroundColor:[UIColor lightGrayColor]];

    m_waitting = waiting;
    [m_gold_view addSubview:waiting];
    [m_waitting startAnimating];
    
}
-(void)TVC_package_reload{
    [package_tvc.tableView.header beginRefreshing];
    [m_reload_package removeFromSuperview];
    UIActivityIndicatorView* waiting = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    waiting.center = self.view.center;
//    [waiting setActivityIndicatorViewStyle : UIActivityIndicatorViewStyleGray];
    [waiting setActivityIndicatorViewStyle : UIActivityIndicatorViewStyleWhiteLarge];
    [waiting setBackgroundColor:[UIColor lightGrayColor]];
    
    m_waitting = waiting;
    [m_package_view addSubview:waiting];
    [m_waitting startAnimating];
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
