//
//  Task_BaiShi_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/2/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Task_BaiShi_ViewController.h"

@interface Task_BaiShi_ViewController ()<UITextFieldDelegate>

@end

@implementation Task_BaiShi_ViewController{
    UIView*         m_navibar_view;
    UITextField*    m_textField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BaiShi:) name:@"拜师" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)initView{
    [self initNavi];
    
    UITextField* input_textfield = [[UITextField alloc]initWithFrame:CGRectMake(38, CGRectGetMaxY(m_navibar_view.frame)+40, SCREEN_WIDTH-38-38, 50)];
    input_textfield.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    input_textfield.placeholder = @"请输入他人给你的邀请码";
    input_textfield.keyboardType = UIKeyboardTypeNumberPad;
    input_textfield.returnKeyType = UIReturnKeyDone;
    input_textfield.delegate = self;
    input_textfield.textAlignment = NSTextAlignmentCenter;
    input_textfield.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:14];
    [self.view addSubview:input_textfield];
    m_textField = input_textfield;
    
    UIButton* commit_button = [[UIButton alloc]initWithFrame:CGRectMake(38, CGRectGetMaxY(input_textfield.frame)+24, SCREEN_WIDTH-38-38, 50)];
    [commit_button setBackgroundColor:[UIColor colorWithRed:248/255.0 green:205/255.0 blue:4/255.0 alpha:1/1.0]];
    [commit_button setTitle:@"提交" forState:UIControlStateNormal];
    [commit_button setTitleColor:[UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    [commit_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:18]];
    [commit_button addTarget:self action:@selector(BaiShiApi) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commit_button];
    
    UILabel* tips = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(commit_button.frame)+32, SCREEN_WIDTH, 12)];
    tips.text = @"输入好友分享的邀请码即可得金币";
    tips.textColor =  [UIColor colorWithRed:167/255.0 green:169/255.0 blue:169/255.0 alpha:1/1.0];
    tips.textAlignment = NSTextAlignmentCenter;
    tips.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:12];
    [self.view addSubview:tips];
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
    title.text = @"输入邀请码";
    title.font = [UIFont boldSystemFontOfSize:20];
    title.textColor = [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    [navibar_view addSubview:title];
    
    //line
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 56-1, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [navibar_view addSubview:line];
    
    [self.view addSubview:navibar_view];
    m_navibar_view = navibar_view;
}

#pragma mark - 按钮方法
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)BaiShiApi{
//    [InternetHelp BaiShi_API:m_textField.text];
}

-(void)BaiShi:(NSNotification*)noti{
    NSNumber* number = noti.object;
    NSInteger index = [number integerValue];
    if(index == 0){
        //失败
        [MBProgressHUD showSuccess:@"拜师失败"];
    }else{
        //成功
        [MBProgressHUD showSuccess:@"拜师成功"];
    }
}

#pragma mark - textField 协议
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self BaiShiApi];
    return YES;
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
