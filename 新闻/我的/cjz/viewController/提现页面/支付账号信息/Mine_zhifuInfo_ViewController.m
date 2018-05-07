//
//  Mine_zhifuInfo_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/4/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_zhifuInfo_ViewController.h"
#import "Mine_zhifu_model.h"

@interface Mine_zhifuInfo_ViewController ()<UITextFieldDelegate>

@end

@implementation Mine_zhifuInfo_ViewController{
    UIView*             m_navibar_view;
    CGFloat             m_naviHight;
    
    UILabel*            m_title_label;
    UILabel*            m_subTitle_label;
    UITextField*        m_title_textField;
    UITextField*        m_subTitle_textField;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavibar];
    [self setUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechat_HaveLogined) name:@"微信已经绑定" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.delegate refresh_zhifuInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNavibar{
    UIView* navibar_view = [[UIView alloc] initWithFrame:CGRectMake(0, StaTusHight, SCREEN_WIDTH, 56)];
    m_naviHight = 56;
    
    //title
    UILabel* title_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, SCREEN_WIDTH, 20)];
    if(self.type == wechat){
        title_label.text = @"微信";
    }else if(self.type == ali){
        title_label.text = @"支付宝";
    }
    title_label.font = [UIFont boldSystemFontOfSize:18];
    title_label.textColor =[UIColor blackColor];
    title_label.textAlignment = NSTextAlignmentCenter;
    [navibar_view addSubview:title_label];
    
    //返回按钮
    UIButton* back_buuton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
    [back_buuton setImage:[UIImage imageNamed:@"ic_nav_back"] forState:UIControlStateNormal];
    [back_buuton setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [back_buuton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navibar_view addSubview:back_buuton];
    
    //line
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 56-1, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [navibar_view addSubview:line];
    
    
    m_navibar_view = navibar_view;
    [self.view addSubview:m_navibar_view];
}

-(void)setUI{
    //微信
    //支付宝
    
    //第一行
    m_title_label = [UILabel new];
    m_title_label.textColor     = RGBA(34, 39, 39, 1);
    m_title_label.textAlignment = NSTextAlignmentLeft;
    m_title_label.font          = kFONT(14);
    [self.view addSubview:m_title_label];
    [m_title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(kWidth(16));
        make.top.equalTo(m_navibar_view.mas_bottom).with.offset(kWidth(17));
        make.height.mas_offset(kWidth(14));
        make.width.mas_offset(kWidth(80));
    }];
    
    m_title_textField = [UITextField new];
    m_title_textField.textColor         = RGBA(34, 39, 39, 1);
    m_title_textField.textAlignment     = NSTextAlignmentRight;
    m_title_textField.font              = kFONT(14);
    m_title_textField.placeholder       = @"请输入";
    m_title_textField.returnKeyType     = UIReturnKeyDone;
    m_title_textField.keyboardType      = UIKeyboardTypeDefault;
    m_title_textField.delegate          = self;
    m_title_textField.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
//    m_title_textField.delegate          = self;
    [self.view addSubview:m_title_textField];
    [m_title_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(m_navibar_view.mas_bottom).with.offset(kWidth(17));
        make.right.equalTo(self.view.mas_right).with.offset(-kWidth(16));
        make.left.equalTo(m_title_label.mas_right);
        make.height.mas_offset(kWidth(14));
    }];
    
    UIView* line_one = [UIView new];
    line_one.backgroundColor = RGBA(242, 242, 242, 1);
    [self.view addSubview:line_one];
    [line_one mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(m_title_label.mas_bottom).with.offset(kWidth(16));
        make.left.equalTo(self.view.mas_left).with.offset(kWidth(16));
        make.right.equalTo(self.view.mas_right).with.offset(-kWidth(16));
        make.height.mas_offset(kWidth(1));
    }];
    
    //第二行
    m_subTitle_label = [UILabel new];
    m_subTitle_label.textColor     = RGBA(34, 39, 39, 1);
    m_subTitle_label.textAlignment = NSTextAlignmentLeft;
    m_subTitle_label.font          = kFONT(14);
    [self.view addSubview:m_subTitle_label];
    [m_subTitle_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(kWidth(16));
        make.top.equalTo(line_one.mas_bottom).with.offset(kWidth(17));
        make.height.mas_offset(kWidth(14));
        make.width.mas_offset(kWidth(80));
    }];
    
    if(self.type == wechat){
        UIImageView* imgV_next = [UIImageView new];
        [imgV_next setImage:[UIImage imageNamed:@"ic_list_next_black"]];
        [self.view addSubview:imgV_next];
        [imgV_next mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line_one.mas_bottom).with.offset(kWidth(16));
            make.right.equalTo(self.view.mas_right).with.offset(-kWidth(16));
            make.width.and.height.mas_offset(kWidth(16));
        }];
        if([[Login_info share].userMoney_model.binding_wechat integerValue] == 1){
            
            UILabel* name_tmp = [UILabel new];
            name_tmp.text            = [Login_info share].userInfo_model.name;
            name_tmp.textColor       = RGBA(34, 39, 39, 1);
            name_tmp.textAlignment   = NSTextAlignmentRight;
            name_tmp.font            = kFONT(14);
            [self.view addSubview:name_tmp];
            [name_tmp mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(line_one.mas_bottom).with.offset(kWidth(17));
                make.right.equalTo(imgV_next.mas_left);
                make.height.mas_offset(kWidth(14));
            }];
            
            UIImageView* img_icon = [UIImageView new];
            [img_icon sd_setImageWithURL:[NSURL URLWithString:[Login_info share].userInfo_model.avatar] placeholderImage:[UIImage imageNamed:@"user_default"]];
            [img_icon.layer setCornerRadius:kWidth(32)/2];
            img_icon.layer.masksToBounds = YES;
            [self.view addSubview:img_icon];
            [img_icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.and.height.mas_offset(kWidth(32));
                make.centerY.equalTo(imgV_next.mas_centerY);
                make.right.equalTo(name_tmp.mas_left).with.offset(-kWidth(10));;
            }];
        }
        else{
            UILabel* tmp = [UILabel new];
            tmp.text            = @"去授权";
            tmp.textColor       = RGBA(167, 169, 169, 1);
            tmp.textAlignment   = NSTextAlignmentRight;
            tmp.font            = kFONT(14);
            [self.view addSubview:tmp];
            [tmp mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(line_one.mas_bottom).with.offset(kWidth(17));
                make.right.equalTo(imgV_next.mas_left);
                make.left.equalTo(m_subTitle_label.mas_right);
                make.height.mas_offset(kWidth(14));
            }];
            
            tmp.userInteractionEnabled = YES;
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wechat_login)];
            [tmp addGestureRecognizer:tap];
        }
    }
    else{ //支付宝
        m_subTitle_textField = [UITextField new];
        m_subTitle_textField.textColor         = RGBA(34, 39, 39, 1);
        m_subTitle_textField.textAlignment     = NSTextAlignmentRight;
        m_subTitle_textField.font              = kFONT(14);
        m_subTitle_textField.placeholder       = @"请输入";
        m_subTitle_textField.keyboardType      = UIKeyboardTypeDefault;
        m_subTitle_textField.returnKeyType     = UIReturnKeyDone;
        m_subTitle_textField.delegate          = self;
        m_subTitle_textField.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
        [self.view addSubview:m_subTitle_textField];
        [m_subTitle_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line_one.mas_bottom).with.offset(kWidth(17));
            make.right.equalTo(self.view.mas_right).with.offset(-kWidth(16));
            make.left.equalTo(m_subTitle_label.mas_right);
            make.height.mas_offset(kWidth(14));
        }];
    }
    
    UIView* line_two = [UIView new];
    line_two.backgroundColor = RGBA(242, 242, 242, 1);
    [self.view addSubview:line_two];
    [line_two mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(m_subTitle_label.mas_bottom).with.offset(kWidth(16));
        make.left.equalTo(self.view.mas_left).with.offset(kWidth(16));
        make.right.equalTo(self.view.mas_right).with.offset(-kWidth(16));
        make.height.mas_offset(kWidth(1));
    }];
    
    if(self.type == wechat){
        m_title_label.text              = @"真实姓名";
        m_subTitle_label.text           = @"微信授权";
        if([[Login_info share].userMoney_model.total_cashed integerValue] > 0){ //是否提过现
            m_title_textField.text      = [Login_info share].userMoney_model.wechat_name;
            [m_title_textField setEnabled:NO];
        }
        else{
            m_title_textField.text      = [Mine_zhifu_model share].wechat_name;
            
            UIButton* saveButton = [UIButton new];
            if([Mine_zhifu_model share].wechat_name.length > 0){
                [saveButton setTitle:@"修改" forState:UIControlStateNormal];
                [m_title_textField setEnabled:NO];
            }
            else{
                [saveButton setTitle:@"保存" forState:UIControlStateNormal];
            }
            [saveButton setTitleColor:RGBA(34, 39, 39, 1) forState:UIControlStateNormal];
            [saveButton setBackgroundColor:RGBA(248, 205, 4, 1)];
            [saveButton.layer setCornerRadius:kWidth(3)];
            [saveButton addTarget:self action:@selector(wechat_save:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:saveButton];
            [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(line_two.mas_bottom).with.offset(kWidth(20));
                make.left.equalTo(self.view).with.offset(kWidth(16));
                make.right.equalTo(self.view).with.offset(-kWidth(16));
                make.height.mas_offset(kWidth(40));
            }];
            
            UILabel* wechat_tips = [UILabel new];
            wechat_tips.text            = @"温馨提示：\n真实姓名，请填写微信绑定的银行卡的真实姓名";
            wechat_tips.textColor       = RGBA(16, 0, 0, 1);
            wechat_tips.textAlignment   = NSTextAlignmentLeft;
            wechat_tips.numberOfLines   = 0;
            
            NSString* str_all   = @"温馨提示：\n真实姓名，请填写微信绑定的银行卡的真实姓名";
            NSString* str       = @"温馨提示：";
            NSMutableAttributedString* att = [[NSMutableAttributedString alloc] initWithString:str_all];
            att = [LabelHelper GetMutableAttributedSting_color:att AndIndex:0 AndCount:str_all.length AndColor:RGBA(16, 0, 0, 1)];
            att = [LabelHelper GetMutableAttributedSting_font:att AndIndex:0 AndCount:str_all.length AndFontSize:kWidth(12)];
            //红色 标注
            att = [LabelHelper GetMutableAttributedSting_color:att AndIndex:0 AndCount:str.length AndColor:RGBA(251, 84, 38, 1)];
            //行 间距
            att = [LabelHelper GetMutableAttributedSting_lineSpaceing:att AndSpaceing:kWidth(10)];
            
            wechat_tips.attributedText  = att;
            [self.view addSubview:wechat_tips];
            [wechat_tips mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(saveButton.mas_bottom).with.offset(kWidth(20));
                make.left.equalTo(self.view).with.offset(kWidth(16));
                make.height.mas_offset(kWidth(35));
            }];
        }
    }
    else if(self.type == ali){
        m_title_label.text              = @"支付宝账号";
        m_subTitle_label.text           = @"支付宝姓名";
        if([[Login_info share].userMoney_model.binding_alipay integerValue] == 1){
            m_title_textField.text      = [Login_info share].userMoney_model.alipay_num;
            m_subTitle_textField.text   = [Login_info share].userMoney_model.alipay_name;
            
            [m_title_textField setEnabled:NO];
            [m_subTitle_textField setEnabled:NO];
        }
        else{
            m_title_textField.text      = [Mine_zhifu_model share].ali_num;
            m_subTitle_textField.text   = [Mine_zhifu_model share].ali_name;
            
            UIButton* saveButton = [UIButton new];
            if([Mine_zhifu_model share].ali_num.length > 0 || [Mine_zhifu_model share].ali_num.length > 0){
                [saveButton setTitle:@"修改" forState:UIControlStateNormal];
                [m_title_textField setEnabled:NO];
                [m_subTitle_textField setEnabled:NO];
            }
            else{
                [saveButton setTitle:@"保存" forState:UIControlStateNormal];
            }
            [saveButton setTitleColor:RGBA(34, 39, 39, 1) forState:UIControlStateNormal];
            [saveButton setBackgroundColor:RGBA(248, 205, 4, 1)];
            [saveButton.layer setCornerRadius:kWidth(3)];
            [saveButton addTarget:self action:@selector(ali_save:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:saveButton];
            [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(line_two.mas_bottom).with.offset(kWidth(20));
                make.left.equalTo(self.view).with.offset(kWidth(16));
                make.right.equalTo(self.view).with.offset(-kWidth(16));
                make.height.mas_offset(kWidth(40));
            }];
        }
    }
    
    
}

#pragma mark - 点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSLog(@"touchesBegan");
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}


#pragma mark - 按钮方法
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)wechat_save:(UIButton*)btn{
    NSString* str = btn.titleLabel.text;
    if([str isEqualToString:@"修改"]){
        [m_title_textField setEnabled:YES];
        [btn setTitle:@"保存" forState:UIControlStateNormal];
        [m_title_textField becomeFirstResponder];
        return;
    }
    
    NSString* tmp = [m_title_textField.text stringByReplacingOccurrencesOfString:@" " withString:@""]; //防止全部是空格
    if(m_title_textField.text.length <= 0 || tmp.length <= 0){
        [MyMBProgressHUD ShowMessage:@"姓名不能为空" ToView:self.view AndTime:1.0f];
        return;
    }
    [Mine_zhifu_model share].wechat_name = m_title_textField.text;
    [MyMBProgressHUD ShowMessage:@"保存成功" ToView:self.view AndTime:1.0f];
    [[AppConfig sharedInstance] saveZhifuInfo:[Mine_zhifu_model share]];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)ali_save:(UIButton*)btn{
    NSString* str = btn.titleLabel.text;
    if([str isEqualToString:@"修改"]){
        [m_title_textField setEnabled:YES];
        [m_subTitle_textField setEnabled:YES];
        [btn setTitle:@"保存" forState:UIControlStateNormal];
        [m_title_textField becomeFirstResponder];
        return;
    }
    if(m_title_textField.text.length <= 0 || m_subTitle_textField.text.length <= 0){
        [MyMBProgressHUD ShowMessage:@"姓名或账号不能为空" ToView:self.view AndTime:1.0f];
        return;
    }
    [Mine_zhifu_model share].ali_num = m_title_textField.text;
    [Mine_zhifu_model share].ali_name= m_subTitle_textField.text;
    [MyMBProgressHUD ShowMessage:@"保存成功" ToView:self.view AndTime:1.0f];
    [[AppConfig sharedInstance] saveZhifuInfo:[Mine_zhifu_model share]];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)wechat_login{
    NSLog(@"微信授权");
    [UMShareHelper LoginWechat:Login_wechat];
}

#pragma mark - 通知
-(void)wechat_HaveLogined{
    [MyMBProgressHUD ShowMessage:@"微信绑定成功" ToView:self.view AndTime:1.0f];
}

#pragma mark - textfield协议
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"点击了搜索");
    return [textField resignFirstResponder];
}


@end
