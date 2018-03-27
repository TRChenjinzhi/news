//
//  Mine_info_changeToMoney_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_info_changeToMoney_ViewController.h"

@interface Mine_info_changeToMoney_ViewController ()

@end

@implementation Mine_info_changeToMoney_ViewController{
    UIView*     m_navibar_view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNavi];
    [self initView];
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
    title.text = @"提现说明";
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
    UILabel* tips_label = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(m_navibar_view.frame)+16, SCREEN_WIDTH-16-16, SCREEN_HEIGHT-CGRectGetMaxY(m_navibar_view.frame)-16)];
    NSString* img_str = @"提示:\n\n1.申请提现后一般会在一个工作日内到账，请务必确认提交的支付宝信息正确，否则将无法到账。\n\n2.暂时只支持支付宝，后续会陆续开通微信和手机话费提现。\n\n3.提现申请后会进入客服审核，审核通过后才会到账，请勿重复提现。\n\n4.如果遇到其他问题，请联系客服QQ：\n2220431662";
    NSMutableAttributedString* att_img_str = [[NSMutableAttributedString alloc] initWithString:img_str];
    att_img_str = [LabelHelper GetMutableAttributedSting_bold_font:att_img_str AndIndex:0 AndCount:3 AndFontSize:16];
    att_img_str = [LabelHelper GetMutableAttributedSting_font:att_img_str AndIndex:3 AndCount:img_str.length-3 AndFontSize:14];
    att_img_str = [LabelHelper GetMutableAttributedSting_color:att_img_str AndIndex:0 AndCount:img_str.length AndColor:RGBA(34, 39, 39, 1)];
    att_img_str = [LabelHelper GetMutableAttributedSting_lineSpaceing:att_img_str AndSpaceing:5.0f];
    att_img_str = [LabelHelper GetMutableAttributedSting_wordSpaceing:att_img_str AndSpaceing:0.5f];
    tips_label.attributedText = att_img_str;
    tips_label.textAlignment = NSTextAlignmentLeft;
    tips_label.numberOfLines = 0;
    [tips_label sizeToFit];
    [self.view addSubview:tips_label];

}

#pragma mark 按钮方法
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
