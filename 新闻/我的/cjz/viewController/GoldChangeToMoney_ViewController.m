//
//  GoldChangeToMoney_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GoldChangeToMoney_ViewController.h"
#import "Repply_ChangeToMoney_ViewController.h"
#import "Mine_Total_GetMoney_ViewController.h"
#import "Mine_Total_ChangeMoney_ViewController.h"
#import "Mine_Historty_cash_ViewController.h"

@interface GoldChangeToMoney_ViewController ()
@property (nonatomic,strong)NSMutableArray*    button_array;
@end

@implementation GoldChangeToMoney_ViewController{
    UIView*     m_navibar_view;
    UIView*     m_header_view;
    UILabel*    m_money_now;
    UILabel*    m_total_getmoney;
    UILabel*    m_total_changeToMoney;
    
    Mine_changeToMoney_model* m_money_model;
    
    UIButton* m_senderToChangeMoney;
    BOOL        IsSelected_button;
    
    NSInteger   selectedMoneyCount;//金额
    
    
}

-(NSMutableArray *)button_array{
    if(!_button_array){
        _button_array = [[NSMutableArray alloc] initWithCapacity:6];
    }
    return _button_array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavi];
    [self initMoneyInfoView];
    [self initDoingView];
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
    title.text = @"我要提现";
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

-(void)initMoneyInfoView{
    UIView* Main_view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_navibar_view.frame), SCREEN_WIDTH, 218)];
    Main_view.backgroundColor = [[ThemeManager sharedInstance] MineChangeToMoneyHeaderBackgroundColor];
    m_header_view = Main_view;
    
    //当前余额
    UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 144)];
//    backgroundView.backgroundColor = [[ThemeManager sharedInstance] MineChangeToMoneyHeaderBackgroundColor];
    
    UILabel* lable_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 12)];
    lable_title.text = @"当前余额(元)";
    lable_title.textColor = [[ThemeManager sharedInstance] MineChangeToMoneyLabelColor];
    lable_title.font = [UIFont systemFontOfSize:12];
    lable_title.textAlignment = NSTextAlignmentCenter;
    [backgroundView addSubview:lable_title];
    
    UILabel* lable_MoneyNow = [[UILabel alloc] initWithFrame:CGRectMake(0 , CGRectGetMaxY(lable_title.frame)+4, SCREEN_WIDTH, 48)];
    lable_MoneyNow.text = [NSString stringWithFormat:@"%.2f",m_money_model.money];
    lable_MoneyNow.textColor = [[ThemeManager sharedInstance] MineChangeToMoneyNumberColor];
    lable_MoneyNow.font = [UIFont boldSystemFontOfSize:40];
    lable_MoneyNow.textAlignment = NSTextAlignmentCenter;
    m_money_now = lable_MoneyNow;
    [backgroundView addSubview:m_money_now];
    
    [Main_view addSubview:backgroundView];
    
    //当前金额细节
    UIView* detail_gold_view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(backgroundView.frame), SCREEN_WIDTH, 64)];
    detail_gold_view.backgroundColor = [[ThemeManager sharedInstance] MineChangeToMoneySubHeaderBackgroundColor];
    
    UILabel* total_getMoney = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, SCREEN_WIDTH/2, 25)];
    total_getMoney.textColor = [[ThemeManager sharedInstance] MineChangeToMoneyNumberColor];

    total_getMoney.text = [NSString stringWithFormat:@"%.2f",m_money_model.total_income];

//    total_getMoney.text = [[Login_info share] GetUserMoney].total_income;
    total_getMoney.font = [UIFont systemFontOfSize:22];
    total_getMoney.textAlignment = NSTextAlignmentCenter;
    m_total_getmoney = total_getMoney;
    [detail_gold_view addSubview:m_total_getmoney];
    
    
    UILabel* total_getMoney_label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(total_getMoney.frame)+2, SCREEN_WIDTH/2, 12)];
    total_getMoney_label.textColor = [[ThemeManager sharedInstance] MineChangeToMoneyLabelColor];
    total_getMoney_label.text = @"累计收入(元)";
    total_getMoney_label.font = [UIFont systemFontOfSize:12];
    total_getMoney_label.textAlignment = NSTextAlignmentCenter;
    [detail_gold_view addSubview:total_getMoney_label];
    
    UILabel* total_changeToMoney = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 12, SCREEN_WIDTH/2, 25)];
    total_changeToMoney.textColor = [[ThemeManager sharedInstance] MineChangeToMoneyNumberColor];

    total_changeToMoney.text = [NSString stringWithFormat:@"%.2f",m_money_model.total_cash];
    
    total_changeToMoney.font = [UIFont systemFontOfSize:22];
    total_changeToMoney.textAlignment = NSTextAlignmentCenter;
    [detail_gold_view addSubview:total_changeToMoney];
    m_total_changeToMoney = total_changeToMoney;
    
    UILabel* total_changeToMoney_label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, CGRectGetMaxY(total_changeToMoney.frame)+2, SCREEN_WIDTH/2, 12)];
    total_changeToMoney_label.textColor = [[ThemeManager sharedInstance] MineChangeToMoneyLabelColor];
    total_changeToMoney_label.text = @"累计提现(元)";
    total_changeToMoney_label.font = [UIFont systemFontOfSize:12];
    total_changeToMoney_label.textAlignment = NSTextAlignmentCenter;
    [detail_gold_view addSubview:total_changeToMoney_label];
    
    [Main_view addSubview:detail_gold_view];
    
    //累计收入 和 累计提现。添加点击层
    UIView* getMoney_clickView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(backgroundView.frame), SCREEN_WIDTH/2, 64)];
//    getMoney_clickView.backgroundColor = [UIColor yellowColor];
    UITapGestureRecognizer* getMoney_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GetMoney_tap)];
    [getMoney_clickView addGestureRecognizer:getMoney_tap];
    [Main_view addSubview:getMoney_clickView];
    
    UIView* changeMoney_clickView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, CGRectGetMaxY(backgroundView.frame), SCREEN_WIDTH/2, 64)];
//    changeMoney_clickView.backgroundColor = [UIColor greenColor];
    UITapGestureRecognizer* ChangeMoney_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ChangeMoney_tap)];
    [changeMoney_clickView addGestureRecognizer:ChangeMoney_tap];
    [Main_view addSubview:changeMoney_clickView];
    
    
    
    //间隔层
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(detail_gold_view.frame), SCREEN_WIDTH, 10)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [Main_view addSubview:line];
    
    [self.view addSubview:Main_view];
    
}

-(void)initDoingView{
    //布置按钮
    [self showThreeButton:CGRectGetMaxY(m_header_view.frame)+40];
    [self showThreeButton:(CGRectGetMaxY(m_header_view.frame)+40+14+40)];
    
    //提现按钮
    UIButton* sender_changToMoney = [[UIButton alloc] initWithFrame:CGRectMake(16, SCREEN_HEIGHT-40-128, SCREEN_WIDTH-16-16, 40)];
    [sender_changToMoney setTitle:@"申请提现" forState:UIControlStateNormal];
    [sender_changToMoney setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sender_changToMoney.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [sender_changToMoney.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:16]];
    [sender_changToMoney addTarget:self action:@selector(SenderToChangeMoney) forControlEvents:UIControlEventTouchUpInside];
    sender_changToMoney.enabled = NO;
    m_senderToChangeMoney = sender_changToMoney;
    [self.view addSubview:m_senderToChangeMoney];
    
}

-(void)setModel:(Mine_changeToMoney_model *)model{
    m_money_model = model;
}

-(void)showThreeButton:(CGFloat)orY{
    for(int i=0;i<3;i++){
        
        NSInteger money = i+1;
        if(orY > CGRectGetMaxY(m_header_view.frame)+40){
            if(i==0){
                money = 10;
            }
            if(i==1){
                money = 20;
            }
            if(i==2){
                money = 50;
            }
        }
        
        CGFloat sizeWidth = (SCREEN_WIDTH-16-16-14-14)/3;
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(16+i*sizeWidth+i*14, orY, sizeWidth, 40)];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:[NSString stringWithFormat:@"%ld元",money*10] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
        [button setTag:money*10];
        [button addTarget:self action:@selector(moneyCount_changToMoney:) forControlEvents:UIControlEventTouchUpInside];
        //设置边框颜色
        button.layer.borderColor = [[UIColor blackColor] CGColor];
        //设置边框宽度
        button.layer.borderWidth = 1.0f;
        //给按钮设置角的弧度
        button.layer.cornerRadius = 4.0f;
        
        [self.view addSubview:button];
        [self.button_array addObject:button];
    }
}

#pragma mark - 按钮方法
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)moneyCount_changToMoney:(UIButton*)bt{
    selectedMoneyCount = bt.tag;
    for (UIButton* item in self.button_array) {
        if(bt.tag == item.tag){
            item.backgroundColor = [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
            [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else{
            item.backgroundColor = [UIColor whiteColor];
            [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    m_senderToChangeMoney.backgroundColor = [UIColor colorWithRed:248/255.0 green:205/255.0 blue:4/255.0 alpha:1/1.0];
    m_senderToChangeMoney.enabled = YES;
}

-(void)SenderToChangeMoney{
    NSLog(@"申请提现");
    Repply_ChangeToMoney_ViewController* vc = [[Repply_ChangeToMoney_ViewController alloc] init];
    vc.moneyCout = selectedMoneyCount;
    [self.navigationController pushViewController:vc animated:YES];
}

//累计收入
-(void)GetMoney_tap{
    return;
//    NSLog(@"累计收入");
//    Mine_Total_GetMoney_ViewController* vc = [[Mine_Total_GetMoney_ViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

//累计提现
-(void)ChangeMoney_tap{
    NSLog(@"累计提现");
    Mine_Historty_cash_ViewController* vc = [[Mine_Historty_cash_ViewController alloc] init];
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
