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
#import "ZhiFuBtn.h"
#import "Mine_zhifuInfo_ViewController.h"
#import "Mine_zhifu_model.h"
#import "Mine_result_changToCash_ViewController.h"

@interface GoldChangeToMoney_ViewController ()<Mine_zhifuInfoVCL_protocol>
@property (nonatomic,strong)NSMutableArray*    button_array;
@end

@implementation GoldChangeToMoney_ViewController{
    UIView*     m_navibar_view;
    UIView*     m_header_view;
    UILabel*    m_money_now;
    UILabel*    m_total_getmoney;
    UILabel*    m_total_changeToMoney;
    
    UIButton*       m_wechat_btn;
    UIButton*       m_ali_btn;
    UIView*         m_xiahuaxian_view_wechat;
    UIView*         m_xiahuaxian_view_ali;
    UIImageView*    m_zhifu_icon;
    UILabel*        m_zhifu_tips;
    NSInteger       m_type;
    UIView*         m_firstOne_view;
    UIView*         m_moveView;
    UIView*         m_gray_two_view;
    UILabel*        m_sendTips;
    UIButton*       m_sendBtn;
    NSInteger       m_btn_index;
    ZhiFuBtn*       m_firstOneYuan_btn;
    
    Mine_changeToMoney_model* m_money_model;
    
    UIButton* m_senderToChangeMoney;
    BOOL        IsSelected_button;
    
    NSInteger   selectedMoneyCount;//金额
    NSArray*        m_array_money_wechat;
    NSArray*        m_array_money_ali;
    
    MBProgressHUD*  waiting;
}

-(NSMutableArray *)button_array{
    if(!_button_array){
        _button_array = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _button_array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    m_type = wechat;
    m_btn_index = -1;
    m_array_money_wechat       = @[@"5"    ,@"10"  ,@"30"  ,@"50"  ,@"100" ,@"200"];
    m_array_money_ali          = @[@"30"   ,@"50"  ,@"100" ,@"200" ,@"500" ,@"1000"];
    [self initNavi];
    [self initMoneyInfoView];
    [self initDoingView];
    [self setType:wechat];//微信 or 支付宝
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
    
    UIButton* history_button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-56-14, 21, 56, 14)];
    [history_button setTitle:@"提现记录" forState:UIControlStateNormal];
    [history_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [history_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
    [history_button addTarget:self action:@selector(history_changeToMoney) forControlEvents:UIControlEventTouchUpInside];
    [navibar_view addSubview:history_button];
    
    //line
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 56-1, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [navibar_view addSubview:line];
    
    [self.view addSubview:navibar_view];
    m_navibar_view = navibar_view;
}

-(void)initMoneyInfoView{
    //当前余额
    UIView* money_view = [UIView new];
    [self.view addSubview:money_view];
    [money_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(m_navibar_view.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(kWidth(90));
    }];
    
    UILabel* money_tips = [UILabel new];
    money_tips.text         = @"当前余额(元)";
    money_tips.textColor    = RGBA(34, 39, 39, 1);
    money_tips.textAlignment= NSTextAlignmentLeft;
    money_tips.font         = kFONT(14);
    [money_view addSubview:money_tips];
    [money_tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(money_view.mas_left).with.offset(kWidth(16));
        make.top.equalTo(money_view.mas_top).with.offset(kWidth(20));
        make.height.mas_equalTo(kWidth(14));
    }];
    
    UILabel* money_number_tips = [UILabel new];
    if([Login_info share].isLogined){
        money_number_tips.text         = [Login_info share].userMoney_model.cash;
    }
    else{
        money_number_tips.text         = @"0.00";
    }
    
    money_number_tips.textColor    = RGBA(34, 39, 39, 1);
    money_number_tips.textAlignment= NSTextAlignmentLeft;
    money_number_tips.font         = KBFONT(24);
    m_money_now = money_number_tips;
    [money_view addSubview:money_number_tips];
    [money_number_tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(money_view.mas_left).with.offset(kWidth(16));
        make.top.equalTo(money_tips.mas_bottom).with.offset(kWidth(10));
        make.height.mas_equalTo(kWidth(24));
    }];
    
    //灰色 间隔区
    UIView* gray_one = [UIView new];
    gray_one.backgroundColor = RGBA(242, 242, 242, 1);
    [self.view addSubview:gray_one];
    [gray_one mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(money_view.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(kWidth(10));
    }];
    
    //微信支付宝
    UIButton* wechat_btn = [UIButton new];
    [wechat_btn setTitle:@"微信" forState:UIControlStateNormal];
    [wechat_btn.titleLabel setFont:kFONT(14)];
    [wechat_btn addTarget:self  action:@selector(wechatBtn_action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wechat_btn];
    m_wechat_btn = wechat_btn;
    [wechat_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(gray_one.mas_bottom).with.offset(kWidth(10));
        make.left.equalTo(self.view.mas_left).with.offset(kWidth(16));
        make.width.mas_equalTo(kWidth(40));
        make.height.mas_equalTo(kWidth(30));
    }];
    
    UIButton* ali_btn = [UIButton new];
    [ali_btn setTitle:@"支付宝" forState:UIControlStateNormal];
    [ali_btn.titleLabel setFont:kFONT(14)];
    [ali_btn addTarget:self action:@selector(aliBtn_action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ali_btn];
    m_ali_btn = ali_btn;
    [ali_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(gray_one.mas_bottom).with.offset(kWidth(10));
        make.left.equalTo(wechat_btn.mas_right).with.offset(kWidth(30));
        make.width.mas_equalTo(kWidth(50));
        make.height.mas_equalTo(kWidth(30));
    }];
    
        //下划线
    UIView* xiaHuaXian_line_wechat = [UIView new];
    xiaHuaXian_line_wechat.backgroundColor = RGBA(251, 84, 38, 1);
    [self.view addSubview:xiaHuaXian_line_wechat];
    m_xiahuaxian_view_wechat = xiaHuaXian_line_wechat;
    [xiaHuaXian_line_wechat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wechat_btn.mas_left);
        make.right.equalTo(wechat_btn.mas_right);
        make.top.equalTo(wechat_btn.mas_bottom);
        make.height.mas_equalTo(kWidth(2));
    }];
    
    UIView* xiaHuaXian_line_ali = [UIView new];
    xiaHuaXian_line_ali.backgroundColor = RGBA(251, 84, 38, 1);
    [self.view addSubview:xiaHuaXian_line_ali];
    m_xiahuaxian_view_ali = xiaHuaXian_line_ali;
    [xiaHuaXian_line_ali mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ali_btn.mas_left);
        make.right.equalTo(ali_btn.mas_right);
        make.top.equalTo(ali_btn.mas_bottom);
        make.height.mas_equalTo(kWidth(2));
    }];
    
    UIImageView* imgV_next = [UIImageView new];
    [imgV_next setImage:[UIImage imageNamed:@"ic_list_next_black"]];
    [self.view addSubview:imgV_next];
    [imgV_next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-kWidth(16));
        make.top.equalTo(xiaHuaXian_line_ali.mas_bottom).with.offset(kWidth(22));
        make.width.mas_offset(kWidth(16));
        make.height.mas_offset(kWidth(16));
    }];
    
    //账户信息设置
    UIView* zhifu_view = [UIView new];
    [self.view addSubview:zhifu_view];
    [zhifu_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xiaHuaXian_line_wechat.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(kWidth(60));
    }];
    
    m_zhifu_icon = [UIImageView new];
    [m_zhifu_icon setImage:[UIImage imageNamed:@"ic_WeChat"]];
    [zhifu_view addSubview:m_zhifu_icon];
    [m_zhifu_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zhifu_view.mas_left).with.offset(kWidth(16));
        make.top.equalTo(zhifu_view.mas_top).with.offset(kWidth(18));
        make.width.and.height.mas_equalTo(kWidth(24));
    }];
    
    m_zhifu_tips = [UILabel new];
    m_zhifu_tips.text           = @"您尚未设置微信账号";
    m_zhifu_tips.textColor      = RGBA(34, 39, 39, 1);
    m_zhifu_tips.textAlignment  = NSTextAlignmentLeft;
    m_zhifu_tips.font           = kFONT(14);
    [zhifu_view addSubview:m_zhifu_tips];
    [m_zhifu_tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(m_zhifu_icon.mas_right).with.offset(kWidth(12));
        make.centerY.equalTo(m_zhifu_icon.mas_centerY);
        make.height.mas_equalTo(kWidth(14));
    }];
    
    
    //添加 支付信息点击层
    UIButton* zhifu_info_btn = [UIButton new];
    [zhifu_info_btn addTarget:self action:@selector(goToZhifuInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zhifu_info_btn];
    [zhifu_view bringSubviewToFront:zhifu_info_btn];
    [zhifu_info_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.equalTo(zhifu_view);
    }];
    
    //灰色 间隔区
    UIView* gray_two = [UIView new];
    gray_two.backgroundColor = RGBA(242, 242, 242, 1);
    [self.view addSubview:gray_two];
    m_gray_two_view = gray_two;
    [gray_two mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(zhifu_view.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(kWidth(10));
    }];
    
    //微信首次一元
    m_firstOne_view = [UIView new];
    [self.view addSubview:m_firstOne_view];
    [m_firstOne_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(gray_two.mas_top);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(kWidth(75));
    }];
    
    ZhiFuBtn* wechat_first_btn = [[ZhiFuBtn alloc] initWithFrame:CGRectMake(0, 0, kWidth(100), kWidth(40))];
    wechat_first_btn.btn_text = @"首次1元";
    wechat_first_btn.btn_IsSelected = NO;
    wechat_first_btn.tag = 1;
    m_firstOneYuan_btn = wechat_first_btn;
    [wechat_first_btn.m_btn addTarget:self action:@selector(moneyCount_changToMoney:) forControlEvents:UIControlEventTouchUpInside];
    [self.button_array addObject:wechat_first_btn];
    [m_firstOne_view addSubview:wechat_first_btn];
    [wechat_first_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(m_firstOne_view.mas_left).with.offset(kWidth(16));
        make.top.equalTo(m_firstOne_view.mas_top).with.offset(kWidth(20));
        make.width.mas_equalTo(kWidth(100));
        make.height.mas_equalTo(kWidth(40));
    }];
    
    UIView* line_m_first = [UIView new];
    line_m_first.backgroundColor = RGBA(242, 242, 242, 1);
    [m_firstOne_view addSubview:line_m_first];
    [line_m_first mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(m_firstOne_view.mas_left).with.offset(kWidth(16));
        make.right.equalTo(m_firstOne_view.mas_right).with.offset(-kWidth(16));
        make.bottom.equalTo(m_firstOne_view.mas_bottom).with.offset(-kWidth(1));
        make.height.mas_equalTo(kWidth(1));
    }];
    
    //整个下面区域
    m_moveView = [UIView new];
    [self.view addSubview:m_moveView];
    [m_moveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(m_firstOne_view.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-kWidth(48));
    }];
    
}

-(void)setType:(zhifu_Type)type{
    m_type = type;
    if(type == wechat){
        [m_xiahuaxian_view_wechat setHidden:NO];
        [m_xiahuaxian_view_ali setHidden:YES];
        
        [m_wechat_btn setTitleColor:RGBA(34, 39, 39, 1) forState:UIControlStateNormal];
        [m_ali_btn setTitleColor:RGBA(167, 169, 169, 1) forState:UIControlStateNormal];
        
        if([[Login_info share].userMoney_model.is_wechat_withdraw integerValue] == 1){ //是否首次 提现过1元
            [m_firstOne_view removeFromSuperview];
            m_firstOneYuan_btn.btn_IsSelected = NO;
            [m_moveView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(m_gray_two_view.mas_bottom);
                make.left.and.right.equalTo(self.view);
                make.bottom.equalTo(self.view.mas_bottom).with.offset(-kWidth(48));
            }];
            if([self.button_array containsObject:m_firstOneYuan_btn]){
                [self.button_array removeObject:m_firstOneYuan_btn];//如果有该按钮，就删除它
            }
        }
        else{
            [self.view addSubview:m_firstOne_view];
            if(![self.button_array containsObject:m_firstOneYuan_btn]){
                [self.button_array insertObject:m_firstOneYuan_btn atIndex:0];//如果没有该按钮，就添加它
            }
            [m_firstOne_view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(m_gray_two_view.mas_top);
                make.left.and.right.equalTo(self.view);
                make.height.mas_equalTo(kWidth(75));
            }];
            [m_moveView removeFromSuperview];
            [self.view addSubview:m_moveView];
            [m_moveView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(m_firstOne_view.mas_bottom);
                make.left.and.right.equalTo(self.view);
                make.bottom.equalTo(self.view.mas_bottom).with.offset(-kWidth(48));
            }];
        }
        
        [self.view layoutIfNeeded];
        
        if([[Login_info share].userInfo_model.wechat_binding integerValue] == 1){
            if([Login_info share].userMoney_model.wechat_name.length > 0){
                [m_zhifu_icon setImage:[UIImage imageNamed:@"ic_WeChat2"]];
                m_zhifu_tips.text = @"微信账号已设置";
            }
            else{
                if([Mine_zhifu_model share].wechat_name.length > 0){//进行手动设置信息
                    [m_zhifu_icon setImage:[UIImage imageNamed:@"ic_WeChat2"]];
                    m_zhifu_tips.text = @"微信账号已设置";
                }
                else{
                    [m_zhifu_icon setImage:[UIImage imageNamed:@"ic_WeChat"]];
                    m_zhifu_tips.text = @"您尚未设置微信账号";
                }
            }
            
        }
        else{
            [m_zhifu_icon setImage:[UIImage imageNamed:@"ic_WeChat"]];
            m_zhifu_tips.text = @"您尚未设置微信账号";
        }
    }
    else if(type == ali){
        [m_xiahuaxian_view_wechat setHidden:YES];
        [m_xiahuaxian_view_ali setHidden:NO];
        
        [m_firstOne_view removeFromSuperview];
        m_firstOneYuan_btn.btn_IsSelected = NO;
        if([self.button_array containsObject:m_firstOneYuan_btn]){
            [self.button_array removeObject:m_firstOneYuan_btn];//如果有该按钮，就删除它
        }
        [m_moveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(m_gray_two_view.mas_bottom);
            make.left.and.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-kWidth(48));
        }];
        
        [self.view layoutIfNeeded];
        [m_wechat_btn setTitleColor:RGBA(167, 169, 169, 1) forState:UIControlStateNormal];
        [m_ali_btn setTitleColor:RGBA(34, 39, 39, 1) forState:UIControlStateNormal];
        
        if([[Login_info share].userMoney_model.binding_alipay integerValue] == 1){
            [m_zhifu_icon setImage:[UIImage imageNamed:@"icon_zhi2"]];
            m_zhifu_tips.text = @"支付宝账号已设置";
        }
        else{
            if([Mine_zhifu_model share].ali_name.length > 0 &&
               [Mine_zhifu_model share].ali_num.length > 0){
                [m_zhifu_icon setImage:[UIImage imageNamed:@"icon_zhi2"]];
                m_zhifu_tips.text = @"支付宝账号已设置";
            }
            else{
                [m_zhifu_icon setImage:[UIImage imageNamed:@"icon_zhi"]];
                m_zhifu_tips.text = @"您尚未设置支付宝账号";
            }
        }
    }
    
    // 修改提现金额
    [self changeButtonMoney];
    
    //默认选择按钮
    if(m_btn_index == -1){ //没有选择任何按钮
        [self setBtnSelected:self.button_array[0]];
    }
    else if(m_btn_index == 1){ //选择首次1元
        [self setBtnSelected:self.button_array[0]];
    }
    
    [self changeSendTips];
}

-(void)initDoingView{
    //布置按钮
    [self showThreeButton:kWidth(14)];
    [self showThreeButton:(kWidth(14)+kWidth(14)+kWidth(40))];
    
    //说明
    NSString* str = @"提现须知：\n\
1. 申请提现后会在1~2个工作日内到账，节假日顺延\n\
2. 微信或支付宝必须实名认证，否则会提现失败。微信实名认证请依次打开\"我—钱包—点击右上角—支付管理—实名认证\"\n\
3. 每天最多申请提现3次，如有其它问题，请联系官方QQ群：689444964";
    NSString* str_cuti  = @"提现须知：";
    NSString* str_one   = @"1~2个工作日";
    NSString* str_two   = @"微信或支付宝必须实名认证，否则会提现失败。";
    NSString* str_three = @"每天最多申请提现3次";
    NSString* str_four  = @"689444964";
    NSMutableAttributedString* att = [[NSMutableAttributedString alloc] initWithString:str];
    att = [LabelHelper GetMutableAttributedSting_color:att AndIndex:0 AndCount:str.length AndColor:RGBA(16, 0, 0, 1)];
    att = [LabelHelper GetMutableAttributedSting_font:att AndIndex:0 AndCount:str.length AndFontSize:kWidth(12)];
    //粗体字
    att = [LabelHelper GetMutableAttributedSting_bold_font:att AndIndex:0 AndCount:str_cuti.length AndFontSize:kWidth(14)];
    //红色 标注
    att = [LabelHelper GetMutableAttributedSting_color:att AndIndex:0 AndCount:str_cuti.length AndColor:RGBA(251, 84, 38, 1)];
    att = [LabelHelper GetMutableAttributedSting_color:att AndIndex:[str rangeOfString:str_one].location AndCount:str_one.length AndColor:RGBA(251, 84, 38, 1)];
    att = [LabelHelper GetMutableAttributedSting_color:att AndIndex:[str rangeOfString:str_two].location AndCount:str_two.length AndColor:RGBA(251, 84, 38, 1)];
    att = [LabelHelper GetMutableAttributedSting_color:att AndIndex:[str rangeOfString:str_three].location AndCount:str_three.length AndColor:RGBA(251, 84, 38, 1)];
    //行 间距
//    att = [LabelHelper GetMutableAttributedSting_lineSpaceing:att AndSpaceing:kWidth(10)];
    
    //
    [att setTextHighlightRange:[str rangeOfString:str_four]
                         color:RGBA(251, 84, 38, 1)
               backgroundColor:[UIColor whiteColor]
                     tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                         NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", @"689444964",@"159bb595195c65467dc5f9028b9fcef105ee080ee92178d3b1276e987047fa98"];
                         NSURL *url = [NSURL URLWithString:urlStr];
                         if([[UIApplication sharedApplication] canOpenURL:url]){
                             [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                         }else{
                             NSLog(@"不能跳转");
                             //提示信息
                             [MyMBProgressHUD ShowMessage:@"无法跳转到QQ" ToView:self.view AndTime:1];
                         }
                     }];
    
    YYLabel *tips = [YYLabel new];
    tips.attributedText = att;
    tips.textAlignment = NSTextAlignmentLeft;
    tips.textVerticalAlignment = YYTextVerticalAlignmentTop;
    tips.numberOfLines = 0;
//    tips.backgroundColor = [UIColor redColor];
    
    [m_moveView addSubview:tips];
    ZhiFuBtn* btn = (ZhiFuBtn*)[self.button_array lastObject];
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn.mas_bottom).with.offset(kWidth(20));
        make.bottom.equalTo(m_moveView.mas_bottom).with.offset(-kWidth(10));
        make.left.equalTo(m_moveView.mas_left).with.offset(kWidth(16));
        make.right.equalTo(m_moveView.mas_right).with.offset(-kWidth(16));
//        make.height.mas_offset([LabelHelper GetLabelHight:kFONT(12) AndText:str AndWidth:SCREEN_WIDTH-2*kWidth(16)]);
    }];
    
    //底部栏
    UIView* tabbar_view = [UIView new];
    tabbar_view.backgroundColor = RGBA(242, 242, 242, 1);
    [self.view addSubview:tabbar_view];
    [tabbar_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_offset(kWidth(48));
    }];
    
    UIView* info_view = [UIView new];
    info_view.backgroundColor = [UIColor whiteColor];
    [tabbar_view addSubview:info_view];
    [info_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tabbar_view.mas_left);
        make.right.equalTo(tabbar_view.mas_right).with.offset(-kWidth(128));
        make.top.equalTo(tabbar_view.mas_top).with.offset(kWidth(2));
        make.bottom.equalTo(tabbar_view.mas_bottom);
    }];
    
    UILabel* lable_Info = [UILabel new];
    m_sendTips = lable_Info;
    lable_Info.text           = @"北京鲜果";
    lable_Info.textColor      = RGBA(251, 84, 38, 1);
    lable_Info.textAlignment  = NSTextAlignmentRight;
    lable_Info.font           = kFONT(14);
    lable_Info.backgroundColor= [UIColor whiteColor];
    [info_view addSubview:lable_Info];
    [lable_Info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(info_view.mas_right).with.offset(-kWidth(20));
        make.left.equalTo(info_view.mas_left);
        make.height.mas_offset(kWidth(20));
        make.centerY.equalTo(info_view.mas_centerY);
    }];
    
    UIButton* sendInfo_btn = [UIButton new];
    m_sendBtn = sendInfo_btn;
    [sendInfo_btn setTitle:@"提交" forState:UIControlStateNormal];
    [sendInfo_btn setTitleColor:RGBA(167, 169, 169, 1) forState:UIControlStateNormal];
    [sendInfo_btn addTarget:self action:@selector(SendToServer) forControlEvents:UIControlEventTouchUpInside];
    [tabbar_view addSubview:sendInfo_btn];
    [sendInfo_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tabbar_view.mas_right);
        make.top.and.bottom.equalTo(tabbar_view);
        make.left.equalTo(tabbar_view.mas_right).with.offset(-kWidth(128));
    }];
    
}

-(void)setModel:(Mine_changeToMoney_model *)model{
    m_money_model = model;
}

-(void)showThreeButton:(CGFloat)orY{
    for(int i=0;i<3;i++){
        
        NSInteger money = i+1;
        if(orY > kWidth(14)){
            if(i==0){
                money = 50;
            }
            if(i==1){
                money = 100;
            }
            if(i==2){
                money = 200;
            }
        }
        else{
            if(i==0){
                money = 5;
            }
            if(i==1){
                money = 10;
            }
            if(i==2){
                money = 30;
            }
        }
        
        CGFloat sizeWidth = (SCREEN_WIDTH-kWidth(16)-kWidth(16)-kWidth(14)-kWidth(14))/3;
        ZhiFuBtn* button = [[ZhiFuBtn alloc] initWithFrame:CGRectMake(kWidth(16)+i*sizeWidth+i*kWidth(14), orY, sizeWidth, kWidth(40))];
        button.btn_text = [NSString stringWithFormat:@"%ld元",money];
        button.btn_IsSelected = NO;
        [button setTag:money];
        [button.m_btn addTarget:self action:@selector(moneyCount_changToMoney:) forControlEvents:UIControlEventTouchUpInside];
        
        [m_moveView addSubview:button];
        [self.button_array addObject:button];
    }
}

-(void)changeSendTips{
    //判断是否完成新手任务
    //判断账号是否设置完毕
    //判断是否是 首次1元
    if([[TaskCountHelper share] newUserTask_isOver]){
        if(m_type == wechat){
            m_sendTips.text = [NSString stringWithFormat:@"实付款：%ld元",m_btn_index];
            if(m_btn_index == 1){
                m_sendTips.text = @"实付款：1元";
            }
            if([Login_info share].userMoney_model.wechat_name.length > 0){
                [m_sendBtn setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
                [m_sendBtn setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
                [m_sendBtn setEnabled:YES];
            }
            else{
                if([Mine_zhifu_model share].wechat_name.length > 0){//手动进行支付信息填写
                    [m_sendBtn setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
                    [m_sendBtn setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
                    [m_sendBtn setEnabled:YES];
                }
                else{
                    [m_sendBtn setTitleColor:RGBA(167, 169, 169, 1) forState:UIControlStateNormal];
                    [m_sendBtn setBackgroundColor:RGBA(242, 242, 242, 1)];
                    [m_sendBtn setEnabled:NO];
                }
            }
        }
        else if(m_type == ali){
            m_sendTips.text = [NSString stringWithFormat:@"实付款：%ld元（含手续费1元）",m_btn_index];
            if([[Login_info share].userMoney_model.binding_alipay integerValue] == 1){
                [m_sendBtn setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
                [m_sendBtn setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
                [m_sendBtn setEnabled:YES];
            }
            else{
                if([Mine_zhifu_model share].ali_name.length > 0 &&
                   [Mine_zhifu_model share].ali_num.length > 0){//手动进行支付信息填写
                    [m_sendBtn setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
                    [m_sendBtn setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
                    [m_sendBtn setEnabled:YES];
                }
                else{
                    [m_sendBtn setTitleColor:RGBA(167, 169, 169, 1) forState:UIControlStateNormal];
                    [m_sendBtn setBackgroundColor:RGBA(242, 242, 242, 1)];
                    [m_sendBtn setEnabled:NO];
                }
                
            }
        }
        
        //当money 小于 提现 金额时
        if(m_btn_index > [[Login_info share].userMoney_model.cash integerValue]){
            [m_sendBtn setTitleColor:RGBA(167, 169, 169, 1) forState:UIControlStateNormal];
            [m_sendBtn setBackgroundColor:RGBA(242, 242, 242, 1)];
            [m_sendBtn setEnabled:NO];
        }
    }
    else{
        m_sendTips.text = @"未完成新手任务，不可提现";
        [m_sendBtn setTitleColor:RGBA(167, 169, 169, 1) forState:UIControlStateNormal];
        [m_sendBtn setBackgroundColor:RGBA(242, 242, 242, 1)];
        [m_sendBtn setEnabled:NO];
    }
}

-(void)changeButtonMoney{
    NSArray* array = nil;
    if(m_type == wechat){
        array   = m_array_money_wechat;
    }
    else if(m_type == ali){
        array   = m_array_money_ali;
    }
    
    for (int i = 0; i<self.button_array.count; i++) {
        if(i == 0 && self.button_array.count > 6){
            continue;
        }
        else{
            ZhiFuBtn* btn = self.button_array[i];
            if(self.button_array.count > 6){
                btn.btn_text = [NSString stringWithFormat:@"%@元",array[i-1]];
                btn.tag = [array[i-1] integerValue];
                if(btn.btn_IsSelected){
                    m_btn_index = btn.tag;
                }
            }
            else{
                btn.btn_text = [NSString stringWithFormat:@"%@元",array[i]];
                btn.tag = [array[i] integerValue];
                if(btn.btn_IsSelected){
                    m_btn_index = btn.tag;
                }
            }
            
        }
    }
}

#pragma mark - 按钮方法

-(void)wechatBtn_action{
    [self setType:wechat];
}

-(void)aliBtn_action{
    [self setType:ali];
}

-(void)goToZhifuInfo{
    Mine_zhifuInfo_ViewController* vc = [[Mine_zhifuInfo_ViewController alloc] init];
    vc.delegate = self;
    if(m_type == ali){
        NSLog(@"goTo 支付宝账号信息");
        vc.type = ali;
    }
    else if(m_type == wechat){
        NSLog(@"goTo 微信账号信息");
        vc.type = wechat;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)moneyCount_changToMoney:(UIButton*)bt{
    [self setBtnSelected:(ZhiFuBtn*)[bt superview]];
}

-(void)setBtnSelected:(ZhiFuBtn*)btn{
    for (ZhiFuBtn* item in self.button_array) {
        if(item == btn){
            item.btn_IsSelected = YES;
            m_btn_index = item.tag;
            
        }else{
            item.btn_IsSelected = NO;
        }
    }
    
    //判断是否可以提现
    NSLog(@"m_index:%ld",m_btn_index);
    [self changeSendTips];
}

//-(void)SenderToChangeMoney{
//    NSLog(@"申请提现");
//    Repply_ChangeToMoney_ViewController* vc = [[Repply_ChangeToMoney_ViewController alloc] init];
//    vc.moneyCout = m_btn_index;
//    [self.navigationController pushViewController:vc animated:YES];
//}

-(void)history_changeToMoney{
    NSLog(@"提现记录");
    Mine_Historty_cash_ViewController* vc = [[Mine_Historty_cash_ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 协议
-(void)refresh_zhifuInfo{
    [self setType:m_type];
}

#pragma mark - API
-(void)SendToServer{
    NSLog(@"提交");
    m_sendBtn.enabled = NO; //防止连续点击多次
    waiting = [[MBProgressHUD alloc] initWithView:self.view];
    waiting.labelText = @"正在提交..";
    waiting.progress = 0.4;
    waiting.mode = MBProgressHUDModeIndeterminate;
    waiting.dimBackground = YES;
    [waiting show:YES]; //显示进度框
    [self.view addSubview:waiting];
    [self.view bringSubviewToFront:waiting];
    
    [InternetHelp ReplyMoneyByType:m_type AndMoney:m_btn_index Sucess:^(NSDictionary *dic) {
        /*
         "list":
         {
         "user_id":"714B08C64ADD12284CA82BA39384B177",
         "cash":"20",     //当前余额
         "total_cashed":"20", //累计余额
         }
         */
        if([dic objectForKey:@"list"]){
            NSDictionary* list_dic = dic[@"list"];
            [Login_info share].userMoney_model.cash         = list_dic[@"cash"];
            [Login_info share].userMoney_model.total_cashed = list_dic[@"total_cashed"];
            if(m_btn_index == 1){ //是否完成 首次1元 提现
                [Login_info share].userMoney_model.is_wechat_withdraw = @"1";
            }
        }
        
        //更新信息
        m_money_now.text = [Login_info share].userMoney_model.cash;
        
        //进入下个子页面
        Mine_result_changToCash_ViewController* vc = [Mine_result_changToCash_ViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        m_sendBtn.enabled = YES;
        [waiting removeFromSuperview];
        
    } Fail:^(NSDictionary *dic) {
        if(dic == nil){
            [MyMBProgressHUD ShowMessage:@"网络错误" ToView:self.view AndTime:1.0f];
        }
        else{
            [MyMBProgressHUD ShowMessage:dic[@"info"] ToView:self.view AndTime:1.0f];
        }
        m_sendBtn.enabled = YES;
        [waiting removeFromSuperview];
    }];
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
