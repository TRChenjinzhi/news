//
//  Mine_History_cash_detail_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/5/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_History_cash_detail_ViewController.h"


@interface Mine_History_cash_detail_ViewController ()

@end

@implementation Mine_History_cash_detail_ViewController{
    UIView*             m_navibar_view;
    
    CGFloat             m_margin;
    CGFloat             m_fontSize;
    UIFont*             m_font;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    m_margin    = kWidth(16);
    m_fontSize  = kWidth(16);
    m_font      = kFONT(m_fontSize);
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavibar];
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNavibar{
    UIView* navibar_view = [[UIView alloc] initWithFrame:CGRectMake(0, StaTusHight, SCREEN_WIDTH, 56)];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, SCREEN_WIDTH, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"提现详情";
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

-(void)setUI{
    //申请时间
    UILabel* label_time = [UILabel new];
    label_time.text             = @"申请时间";
    label_time.textColor        = RGBA(167, 169, 169, 1);
    label_time.textAlignment    = NSTextAlignmentLeft;
    label_time.font             = m_font;
    [self.view addSubview:label_time];
    [label_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(m_navibar_view.mas_bottom).with.offset(m_margin);
        make.left.equalTo(self.view.mas_left).with.offset(m_margin);
        make.height.mas_offset(m_fontSize);
    }];
    
    UILabel* label_sub_time = [UILabel new];
    label_sub_time.text             = [[TimeHelper share] dateChangeToString_YYYYMMDDHHMM:self.model.time];
    label_sub_time.textColor        = RGBA(34, 39, 39, 1);
    label_sub_time.textAlignment    = NSTextAlignmentRight;
    label_sub_time.font             = m_font;
    [self.view addSubview:label_sub_time];
    [label_sub_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(m_navibar_view.mas_bottom).with.offset(m_margin);
        make.right.equalTo(self.view.mas_right).with.offset(-m_margin);
        make.height.mas_offset(m_fontSize);
    }];
    
    UIView* line_one = [UIView new];
    line_one.backgroundColor = RGBA(242, 242, 242, 1);
    [self.view addSubview:line_one];
    [line_one mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(m_margin);
        make.right.equalTo(self.view.mas_right).with.offset(-m_margin);;
        make.top.equalTo(label_time.mas_bottom).with.offset(m_margin);
        make.height.mas_offset(kWidth(1));
    }];
    
    //提现金额
    UILabel* label_money = [UILabel new];
    label_money.text             = @"提现金额";
    label_money.textColor        = RGBA(167, 169, 169, 1);
    label_money.textAlignment    = NSTextAlignmentLeft;
    label_money.font             = m_font;
    [self.view addSubview:label_money];
    [label_money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line_one.mas_bottom).with.offset(m_margin);
        make.left.equalTo(self.view.mas_left).with.offset(m_margin);
        make.height.mas_offset(m_fontSize);
    }];
    
    UILabel* label_sub_money = [UILabel new];
    label_sub_money.text             = [NSString stringWithFormat:@"%@元",self.model.moeny];
    label_sub_money.textColor        = RGBA(34, 39, 39, 1);
    label_sub_money.textAlignment    = NSTextAlignmentRight;
    label_sub_money.font             = m_font;
    [self.view addSubview:label_sub_money];
    [label_sub_money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line_one.mas_bottom).with.offset(m_margin);
        make.right.equalTo(self.view.mas_right).with.offset(-m_margin);
        make.height.mas_offset(m_fontSize);
    }];
    
    UIView* line_two = [UIView new];
    line_two.backgroundColor = RGBA(242, 242, 242, 1);
    [self.view addSubview:line_two];
    [line_two mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(m_margin);
        make.right.equalTo(self.view.mas_right).with.offset(-m_margin);;
        make.top.equalTo(label_money.mas_bottom).with.offset(m_margin);
        make.height.mas_offset(kWidth(1));
    }];
    
    //提现方式
    UILabel* label_type = [UILabel new];
    label_type.text             = @"提现方式";
    label_type.textColor        = RGBA(167, 169, 169, 1);
    label_type.textAlignment    = NSTextAlignmentLeft;
    label_type.font             = m_font;
    [self.view addSubview:label_type];
    [label_type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line_two.mas_bottom).with.offset(m_margin);
        make.left.equalTo(self.view.mas_left).with.offset(m_margin);
        make.height.mas_offset(m_fontSize);
    }];
    
    UILabel* label_sub_type = [UILabel new];
    //1.支付宝 2.微信 3.话费
    NSString* title = @"";
    NSInteger type = [self.model.type integerValue];
    switch (type) {
        case Ali:
            title = @"支付宝";
            break;
        case Wechat:
            title = @"微信";
            break;
        case Phone:
            title = @"话费提现";
            break;
            
        default:
            break;
    }
    label_sub_type.text             = title;
    label_sub_type.textColor        = RGBA(34, 39, 39, 1);
    label_sub_type.textAlignment    = NSTextAlignmentRight;
    label_sub_type.font             = m_font;
    [self.view addSubview:label_sub_type];
    [label_sub_type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line_two.mas_bottom).with.offset(m_margin);
        make.right.equalTo(self.view.mas_right).with.offset(-m_margin);
        make.height.mas_offset(m_fontSize);
    }];
    
    UIView* line_three = [UIView new];
    line_three.backgroundColor = RGBA(242, 242, 242, 1);
    [self.view addSubview:line_three];
    [line_three mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(m_margin);
        make.right.equalTo(self.view.mas_right).with.offset(-m_margin);;
        make.top.equalTo(label_type.mas_bottom).with.offset(m_margin);
        make.height.mas_offset(kWidth(1));
    }];
    
    //身份证姓名
    UILabel* label_shenfenzheng = [UILabel new];
    label_shenfenzheng.text             = @"身份证姓名";
    label_shenfenzheng.textColor        = RGBA(167, 169, 169, 1);
    label_shenfenzheng.textAlignment    = NSTextAlignmentLeft;
    label_shenfenzheng.font             = m_font;
    [self.view addSubview:label_shenfenzheng];
    [label_shenfenzheng mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line_three.mas_bottom).with.offset(m_margin);
        make.left.equalTo(self.view.mas_left).with.offset(m_margin);
        make.height.mas_offset(m_fontSize);
    }];
    
    UILabel* label_sub_shenfenzheng = [UILabel new];
    //1.支付宝 2.微信 3.话费
    NSString* title1 = @"";
    NSInteger type1 = [self.model.type integerValue];
    switch (type1) {
        case Ali:
            title1 = [Login_info share].userMoney_model.alipay_name;
            break;
        case Wechat:
            title1 = [Login_info share].userMoney_model.wechat_name;
            break;
        case Phone:
            title1 = @"话费提现";
            break;
            
        default:
            break;
    }
    label_sub_shenfenzheng.text             = title1;
    label_sub_shenfenzheng.textColor        = RGBA(34, 39, 39, 1);
    label_sub_shenfenzheng.textAlignment    = NSTextAlignmentRight;
    label_sub_shenfenzheng.font             = m_font;
    [self.view addSubview:label_sub_shenfenzheng];
    [label_sub_shenfenzheng mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line_three.mas_bottom).with.offset(m_margin);
        make.right.equalTo(self.view.mas_right).with.offset(-m_margin);
        make.height.mas_offset(m_fontSize);
    }];
    
    UIView* line_four = [UIView new];
    line_four.backgroundColor = RGBA(242, 242, 242, 1);
    [self.view addSubview:line_four];
    [line_four mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(m_margin);
        make.right.equalTo(self.view.mas_right).with.offset(-m_margin);;
        make.top.equalTo(label_shenfenzheng.mas_bottom).with.offset(m_margin);
        make.height.mas_offset(kWidth(1));
    }];
    
    //灰色间隔
    UIView* line_jiange = [UIView new];
    line_jiange.backgroundColor = RGBA(242, 242, 242, 1);
    [self.view addSubview:line_jiange];
    [line_jiange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(line_four.mas_bottom);
        make.height.mas_offset(kWidth(10));
    }];
    
    //提现状态
    UILabel* label_status = [UILabel new];
    label_status.text             = @"提现状态";
    label_status.textColor        = RGBA(167, 169, 169, 1);
    label_status.textAlignment    = NSTextAlignmentLeft;
    label_status.font             = m_font;
    [self.view addSubview:label_status];
    [label_status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line_jiange.mas_bottom).with.offset(m_margin);
        make.left.equalTo(self.view.mas_left).with.offset(m_margin);
        make.height.mas_offset(m_fontSize);
    }];
    
    UILabel* label_sub_status = [UILabel new];
    label_sub_status.text             = [NSString stringWithFormat:@"%@",self.model.state];
    label_sub_status.textColor        = RGBA(251, 84, 38, 1);
    label_sub_status.textAlignment    = NSTextAlignmentRight;
    label_sub_status.font             = m_font;
    [self.view addSubview:label_sub_status];
    [label_sub_status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line_jiange.mas_bottom).with.offset(m_margin);
        make.right.equalTo(self.view.mas_right).with.offset(-m_margin);
        make.height.mas_offset(m_fontSize);
    }];
}

#pragma mark - 按钮方法
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
