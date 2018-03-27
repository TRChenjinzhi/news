//
//  Search_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Search_ViewController.h"
#import "SearchName_TableViewController.h"
#import "DateReload_view.h"
#import "CJZdataModel.h"
#import "SocietyViewController.h"
#import "DetailWeb_ViewController.h"

@interface Search_ViewController ()<SearchName_tableView_delegate,UITextFieldDelegate>

@end

@implementation Search_ViewController{
    UIView*         m_navibar_view;
    
    NSArray*        m_searchWord_history;
    NSArray*        m_searchResult;
    
    UIView*         m_mainView;
    
    UITextField*    m_textfield;
    UIButton*       m_search_button;
    
    SearchName_TableViewController*     m_searchName_tableVIew;
    SocietyViewController*              m_searchResult_VC;
    
    DateReload_view*        m_reload_view;
    UIActivityIndicatorView*m_waiting_view;
    
    NSArray*        m_result_model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNavi];
    [self InitTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GoToDetailVC:) name:@"搜索-详情页面" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)initNavi{
    UIView* navibar_view = [[UIView alloc] initWithFrame:CGRectMake(0, StaTusHight, SCREEN_WIDTH, 56)];
    
    UIButton* back_button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
    [back_button setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [back_button setImage:[UIImage imageNamed:@"ic_nav_back"] forState:UIControlStateNormal];
    [back_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navibar_view addSubview:back_button];
    
    //uitextfield
    
    UIView* input_view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(back_button.frame), 12, 248, 32)];
    input_view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    input_view.layer.cornerRadius = 16;
    
    UIImageView* search_img = [[UIImageView alloc] initWithFrame:CGRectMake(8, 10, 12, 12)];
    [search_img setImage:[UIImage imageNamed:@"ic_nav_search2"]];
    [input_view addSubview:search_img];
    
    UITextField* input_textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(search_img.frame)+4, 9, 248-24-24, 14)];
    input_textField.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:14];
    input_textField.textColor = [UIColor blackColor];
    input_textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    input_textField.returnKeyType = UIReturnKeySearch;
    input_textField.placeholder = @"请输入关键字";
    input_textField.delegate = self;
    m_textfield = input_textField;
    
    [input_view addSubview:input_textField];
    [navibar_view addSubview:input_view];
    
    
    UIButton* search_button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-56-14, 21, 56, 14)];
    [search_button setTitle:@"搜索" forState:UIControlStateNormal];
    [search_button setTitleColor:[UIColor colorWithRed:248/255.0 green:205/255.0 blue:4/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    [search_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
    [search_button addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [navibar_view addSubview:search_button];
    m_search_button = search_button;
    
//    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-150/2, 18, 150, 20)];
//    title.textAlignment = NSTextAlignmentCenter;
//    title.text = @"邀请收徒";
//    title.font = [UIFont boldSystemFontOfSize:20];
//    title.textColor = [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
//    [navibar_view addSubview:title];
    
    //line
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 56-1, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [navibar_view addSubview:line];
    
    [self.view addSubview:navibar_view];
    m_navibar_view = navibar_view;
}

-(void)InitTableView{
    
    //获取本地的关键词记录-未完成
    if([[AppConfig sharedInstance] GetSearchWord] == nil){
//        [[AppConfig sharedInstance] saveSearchWord:@[@"number_ome",@"number_two",@"number_three"]];
    }
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_navibar_view.frame),
                                                            SCREEN_WIDTH,
                                                            SCREEN_HEIGHT-CGRectGetMaxY(m_navibar_view.frame))];
    m_mainView = view;
    
    SearchName_TableViewController* searchName_TVC = [[SearchName_TableViewController alloc] init];
    m_searchName_tableVIew = searchName_TVC;
    m_searchName_tableVIew.delegate = self;
    [view addSubview:m_searchName_tableVIew.tableView];
    [self.view addSubview:view];
    
}

#pragma mark - textField 协议
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self search];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
//    if([textField.text isEqualToString:@""]){
//        [m_searchResult_tableView.tableView removeFromSuperview];
//    }
    
    return YES;
}

#pragma mark - 按钮方法
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)search{
    NSLog(@"search");
    
    if([m_textfield.text isEqualToString:@""]){
        return;
    }
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//收起键盘
    
    //保存搜索关键字
    [[AppConfig sharedInstance] addSearchWord:m_textfield.text];
    
    m_searchResult_VC = [[SocietyViewController alloc] init];

    m_searchResult_VC.isSearchVC = YES;
    m_searchResult_VC.keyWords = m_textfield.text;
    
    [m_mainView addSubview:m_searchResult_VC.view];
}


#pragma mark - 协议方法
-(void)selectedSearchName:(NSString *)name{
    m_textfield.text = name;
    [m_search_button sendActionsForControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 广播方法
-(void)GoToDetailVC:(NSNotification*)noti{
    CJZdataModel* model = noti.object;
    DetailWeb_ViewController* vc = [[DetailWeb_ViewController alloc] init];
    vc.CJZ_model = model;
    [self.navigationController pushViewController:vc animated:YES];
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
