//
//  Tips_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Tips_ViewController.h"

@interface Tips_ViewController ()

@end

@implementation Tips_ViewController{
    UILabel* tips;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initView{
    tips = [[UILabel alloc] init];
    tips.backgroundColor = RGBA(0, 0, 0, 0.6);
//    tips.text = self.message;
    tips.textColor = [UIColor whiteColor];
    tips.textAlignment = NSTextAlignmentCenter;
    tips.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:tips];
}

-(void)setMessage:(NSString *)message{
    CGFloat width = [LabelHelper GetLabelWidth:[UIFont systemFontOfSize:14] AndText:message] + 10;
    tips.text = message;
    tips.frame = CGRectMake(SCREEN_WIDTH/2-width/2, 0, width, self.view.frame.size.height);
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
