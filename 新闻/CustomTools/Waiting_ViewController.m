//
//  Waiting_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/2/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Waiting_ViewController.h"

@interface Waiting_ViewController ()

@end

@implementation Waiting_ViewController{
    UIActivityIndicatorView*        m_waitting_view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initView{
    m_waitting_view = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    m_waitting_view.center = self.view.center;
    //    [m_waiting setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [m_waitting_view setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:m_waitting_view];
    [m_waitting_view startAnimating];
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
