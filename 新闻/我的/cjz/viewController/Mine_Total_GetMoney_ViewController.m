//
//  Mine_Total_GetMoney_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_Total_GetMoney_ViewController.h"

@interface Mine_Total_GetMoney_ViewController ()

@end

@implementation Mine_Total_GetMoney_ViewController{
    UIView*         m_navibar_view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavi];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNavi{
    UIView* navibar_view = [[UIView alloc] initWithFrame:CGRectMake(0, StaTusHight, SCREEN_WIDTH, 56)];
    
    UIButton* back_button = [[UIButton alloc] initWithFrame:CGRectMake(16, 0, 56, 56)];
    [back_button setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [back_button setImage:[UIImage imageNamed:@"ic_nav_back"] forState:UIControlStateNormal];
    [back_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navibar_view addSubview:back_button];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-80/2, 18, 80, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"收入记录";
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
    UIView* main_view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_navibar_view.frame),
                                                                 SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(m_navibar_view.frame))];
    
    UIImageView* img_view = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-90/2, 181, 90, 90)];
    [img_view setImage:[UIImage imageNamed:@"ic_empty_income"]];
    [main_view addSubview:img_view];
    
    UILabel* tips_label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-72/2, CGRectGetMaxY(img_view.frame)+16, 72, 12)];
    tips_label.text = @"暂无收入记录~";
    tips_label.textColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0];
    tips_label.textAlignment = NSTextAlignmentCenter;
    tips_label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:12];
    [main_view addSubview:tips_label];
    
    UIButton* GoToGetMoney = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-240/2, CGRectGetMaxY(tips_label.frame)+32, 240, 40)];
    [GoToGetMoney setBackgroundColor:[UIColor colorWithRed:248/255.0 green:205/255.0 blue:4/255.0 alpha:1/1.0]];
    [GoToGetMoney setTitle:@"马上赚钱" forState:UIControlStateNormal];
    [GoToGetMoney setTitleColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.87/1.0] forState:UIControlStateNormal];
    [GoToGetMoney.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:16]];
    [GoToGetMoney addTarget:self action:@selector(GoToGetMoney_action) forControlEvents:UIControlEventTouchUpInside];
    [main_view addSubview:GoToGetMoney];
    
    [self.view addSubview:main_view];
}

#pragma mark - 按钮方法
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)GoToGetMoney_action{
    NSLog(@"马上赚钱");
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
