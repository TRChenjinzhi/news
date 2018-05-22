//
//  Mine_AboutMe_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_AboutMe_ViewController.h"

@interface Mine_AboutMe_ViewController ()

@end

@implementation Mine_AboutMe_ViewController{
    UIView*             m_navibar_view;
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
    
    UIButton* back_button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
    [back_button setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [back_button setImage:[UIImage imageNamed:@"ic_nav_back"] forState:UIControlStateNormal];
    [back_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navibar_view addSubview:back_button];
    
    //    UIButton* edit_button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-56-14, 21, 56, 14)];
    //    [edit_button setTitle:@"编辑" forState:UIControlStateNormal];
    //    [edit_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [edit_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
    //    [edit_button addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    //    [navibar_view addSubview:edit_button];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-150/2, 18, 150, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"关于我们";
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
    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-72/2, CGRectGetMaxY(m_navibar_view.frame)+120, 72, 72)];
    [img setImage:[UIImage imageNamed:@"about-1"]];
    [self.view addSubview:img];
    
    UILabel* APPName_label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame)+24, SCREEN_WIDTH, 20)];
    APPName_label.text = @"橙子快报";
    APPName_label.textColor = [UIColor blackColor];
    APPName_label.textAlignment = NSTextAlignmentCenter;
    APPName_label.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:APPName_label];
    
    UILabel* banben_label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(APPName_label.frame)+12, SCREEN_WIDTH, 14)];
    banben_label.text = @"V1.0.0";
    banben_label.textColor = [UIColor colorWithRed:122/255.0 green:125/255.0 blue:125/255.0 alpha:1/1.0];
    banben_label.textAlignment = NSTextAlignmentCenter;
    banben_label.font = [UIFont fontWithName:@"SourceHanSansCN-Bold" size:14];
    [self.view addSubview:banben_label];
}

#pragma mark - 按钮方法
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
