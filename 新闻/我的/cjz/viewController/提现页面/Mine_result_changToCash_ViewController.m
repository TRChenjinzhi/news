//
//  Mine_result_changToCash_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/4/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_result_changToCash_ViewController.h"

@interface Mine_result_changToCash_ViewController ()

@end

@implementation Mine_result_changToCash_ViewController{
    UIView*         m_navibar_view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavi];
    [self setUI];
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
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-80/2, 18, 80, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"提现";
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

-(void)setUI{
    UIImageView* imgV = [UIImageView new];
    [imgV setImage:[UIImage imageNamed:@"ic_submit"]];
    [self.view addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(m_navibar_view.mas_bottom).with.offset(kWidth(40));
        make.height.and.width.mas_offset(kWidth(90));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UILabel* tips = [UILabel new];
    tips.text               = @"申请已提交";
    tips.textColor          = RGBA(34, 39, 39, 1);
    tips.textAlignment      = NSTextAlignmentCenter;
    tips.font               = kFONT(16);
    [self.view addSubview:tips];
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgV.mas_bottom).with.offset(kWidth(20));
        make.left.and.right.equalTo(self.view);
    }];
    
    UIButton* submint_ok = [UIButton new];
    [submint_ok setTitle:@"完成" forState:UIControlStateNormal];
    [submint_ok setTitleColor:RGBA(34, 39, 39, 1) forState:UIControlStateNormal];
    [submint_ok setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    [submint_ok.layer setCornerRadius:kWidth(40)/2];
    submint_ok.clipsToBounds = YES;
    [submint_ok addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submint_ok];
    [submint_ok mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tips.mas_bottom).with.offset(kWidth(32));
        make.height.mas_offset(kWidth(40));
        make.width.mas_offset(kWidth(150));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

#pragma mark - 按钮方法
-(void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
