//
//  ReplyAll_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/5/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ReplyAll_ViewController.h"
#import "reply_Cell.h"
#import "reply_NoDianZan_TableViewCell.h"

@interface ReplyAll_ViewController ()<UITableViewDelegate,UITableViewDataSource,reply_NoDianZan_cell_protocol,UITextViewDelegate>

@property (nonatomic,strong)NSMutableArray* array_data;
@property (nonatomic,strong)UIButton* SenderButton;
@property (nonatomic,strong)UIView* inputReply;
@end

@implementation ReplyAll_ViewController{
    UIView*             m_navibar_view;
    
    UIView*             m_titlte_view;
    UIButton*           m_dianzan;
    BOOL                IsDianZan;
    UILabel*            m_dianzan_number;
    UILabel*            m_content_label;
    UILabel*            m_time_lable;
    
    UIView*             m_tabBar_view;
    
    UITableView*        m_tableview;
    NSInteger           m_page;
    
    UIView*             m_inputTextView;
    UILabel*            m_textView_placeHolder;
    UITextView*         m_textField;
    CGFloat             m_inputTextView_maxY;

    reply_model*        m_otherReply_model;
    NSString*           m_pre_reply;
    
    //键盘弹出
    CGFloat                         _currentKeyboardH;
    CGFloat                         _transformY;
    
}

-(NSMutableArray *)array_data{
    if(!_array_data){
        _array_data = [NSMutableArray array];
    }
    return _array_data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavibar];
//    [self setTitleView];
    [self setTabBar];
    [self setTableview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    /* 增加监听（当键盘出现或改变时） */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transformDialog:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(self.delegate != nil){
        [self.delegate refreshCell:self.model];
    }
}

-(void)initNavibar{
    UIView* navibar_view = [[UIView alloc] initWithFrame:CGRectMake(0, StaTusHight, SCREEN_WIDTH, 56)];
    
    //title
    UILabel* title_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 56)];
    title_label.text = @"全部回复";
    title_label.font = [UIFont boldSystemFontOfSize:18];
    title_label.textColor = [UIColor blackColor];
    title_label.textAlignment= NSTextAlignmentCenter;
    [navibar_view addSubview:title_label];
    
    //返回按钮
    UIButton* back_buuton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
    [back_buuton setImage:[UIImage imageNamed:@"ic_nav_back"] forState:UIControlStateNormal];
    [back_buuton setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [back_buuton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [navibar_view addSubview:back_buuton];
    
    //line
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 56-1, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [navibar_view addSubview:line];
    
    
    m_navibar_view = navibar_view;
    [self.view addSubview:m_navibar_view];
}

-(void)setTitleView{
    //回复内容title
    UIView* title_view = [UIView new];
    m_titlte_view = title_view;
    [self.view addSubview:title_view];
    [title_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(m_navibar_view.mas_bottom);
    }];
    
    UIImageView* title_icon = [UIImageView new];
    if(self.model.myUserModel.user_icon.length > 0){
        [title_icon sd_setImageWithURL:[NSURL URLWithString:self.model.myUserModel.user_icon]];
    }
    else{
        if(self.model.myUserModel.wechat_icon.length > 0){
            [title_icon sd_setImageWithURL:[NSURL URLWithString:self.model.myUserModel.wechat_icon]];
        }
        else{
            [title_icon setImage:[UIImage imageNamed:@"list_avatar"]];
        }
    }
    [title_icon.layer setCornerRadius:kWidth(24)/2];
    title_icon.clipsToBounds = YES;
    [title_view addSubview:title_icon];
    [title_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title_view.mas_left).offset(kWidth(16));
        make.top.equalTo(title_view.mas_top).offset(kWidth(16));
        make.width.and.height.mas_offset(kWidth(24));
    }];
    
    UILabel* title_name = [UILabel new];
    title_name.text             = self.model.myUserModel.user_name;
    title_name.textColor        = RGBA(122, 125, 125, 1);
    title_name.textAlignment    = NSTextAlignmentLeft;
    title_name.font             = kFONT(13);
    [title_view addSubview:title_name];
    [title_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title_icon.mas_right).offset(kWidth(8));
        make.top.equalTo(title_view.mas_top).offset(kWidth(22));
        make.height.mas_offset(kWidth(13));
    }];
    
    UIButton* title_dianzan = [UIButton new];
    [title_dianzan addTarget:self action:@selector(dianzan_SetState:) forControlEvents:UIControlEventTouchUpInside];
    m_dianzan = title_dianzan;
    [title_view addSubview:title_dianzan];
    [title_dianzan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(title_view.mas_right).with.offset(-kWidth(16));
        make.top.equalTo(title_view.mas_top).with.offset(kWidth(22));
        make.width.mas_offset(kWidth(14));
        make.height.mas_offset(kWidth(12));
    }];
    IsDianZan = [[MyDataBase shareManager] DianZan_IsDianZan:[self.model.ID integerValue]];//判断是否已经点赞
    [self dianzan_InitState:self.model];//设置点赞状态
    
    
    UILabel* dianZan_number = [UILabel new];
    //    dianZan_number.backgroundColor = [UIColor redColor];
    dianZan_number.textColor = [UIColor colorWithRed:78/255.0 green:82/255.0 blue:82/255.0 alpha:1/1.0];
    dianZan_number.textAlignment = NSTextAlignmentRight;
    dianZan_number.font = kFONT(12);
    [title_view addSubview:dianZan_number];
    m_dianzan_number = dianZan_number;
    [dianZan_number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(m_dianzan.mas_left).with.offset(-kWidth(5));
        make.top.equalTo(title_view.mas_top).with.offset(kWidth(22));
        make.height.mas_offset(kWidth(12));
    }];
    m_dianzan_number.text = self.model.thumbs_num;
    
    m_content_label = [UILabel new];
    m_content_label.numberOfLines = 0;
    m_content_label.text = self.model.comment;
    m_content_label.textColor = [UIColor colorWithRed:78/255.0 green:82/255.0 blue:82/255.0 alpha:1/1.0];
    m_content_label.textAlignment = NSTextAlignmentLeft;
    m_content_label.font = kFONT(14);
    [title_view addSubview:m_content_label];
    [m_content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title_name.mas_left);
        make.right.equalTo(title_view.mas_right).with.offset(-kWidth(16));
        make.top.equalTo(title_name.mas_bottom).with.offset(kWidth(15));
    }];
    
    UILabel* time_lable = [UILabel new];
    m_time_lable = time_lable;
    NSString* str_time = [[TimeHelper share] GetDateFromString_yyMMDD_HHMMSS:self.model.ctime];
    m_time_lable.text = [TimeHelper showTime:str_time];
    m_time_lable.textColor = [UIColor colorWithRed:122/255.0 green:125/255.0 blue:125/255.0 alpha:1/1.0];
    m_time_lable.textAlignment = NSTextAlignmentLeft;
    m_time_lable.font = kFONT(11);
    [title_view addSubview:m_time_lable];
    [m_time_lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(m_content_label.mas_left);
        make.top.equalTo(m_content_label.mas_bottom).with.offset(kWidth(10));
        make.height.mas_offset(kWidth(11));
    }];
    
    UIView* line = [UIView new];
    line.backgroundColor = RGBA(242, 242, 242, 1);
    [title_view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(m_time_lable.mas_left);
        make.right.equalTo(title_view.mas_right).with.offset(-kWidth(16));
        make.top.equalTo(m_time_lable.mas_bottom).with.offset(kWidth(16));
        make.height.mas_offset(kWidth(1));
        make.bottom.equalTo(title_view.mas_bottom).offset(-kWidth(1));
    }];
}

-(void)setTabBar{
    m_tabBar_view = [UIView new];
    m_tabBar_view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:m_tabBar_view];
    [m_tabBar_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_offset(kWidth(48));
    }];
    
    UIButton* text_button = [UIButton new];
    [text_button.layer setCornerRadius:kWidth(32)/2];
    [text_button.layer setMasksToBounds:YES];
    [text_button setTitle:@"说两句..." forState:UIControlStateNormal];
    [text_button setTitleColor:[UIColor colorWithRed:167/255.0 green:169/255.0 blue:169/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    text_button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [text_button setContentEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
    text_button.titleLabel.font = kFONT(14);
    text_button.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [text_button addTarget:self action:@selector(InputTextAction) forControlEvents:UIControlEventTouchUpInside];
    [m_tabBar_view addSubview:text_button];
    [text_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(m_tabBar_view.mas_left).offset(kWidth(16));
        make.right.equalTo(m_tabBar_view.mas_right).offset(-kWidth(16));
        make.height.mas_offset(kWidth(32));
        make.centerY.equalTo(m_tabBar_view.mas_centerY);
    }];
}

-(void)setTableview{
    
    m_tableview = [UITableView new];
    m_tableview.backgroundColor = RGBA(247, 247, 247, 1);
    m_tableview.separatorStyle  = UITableViewCellSeparatorStyleNone;
    m_tableview.delegate        = self;
    m_tableview.dataSource      = self;
    [m_tableview registerClass:[reply_NoDianZan_TableViewCell class] forCellReuseIdentifier:@"reply_NoDianZan"];
    IMP_BLOCK_SELF(ReplyAll_ViewController);
    GYHHeadeRefreshController *header = [GYHHeadeRefreshController headerWithRefreshingBlock:^{
        m_page = 0;
        [block_self getData];
    }];
    //头部刷新视图设置
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    m_tableview.header = header;
    
    [header beginRefreshing];
    
    m_tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [block_self getData];
    }];
    
    [self.view addSubview:m_tableview];
    [m_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(m_navibar_view.mas_bottom);
        make.bottom.equalTo(m_tabBar_view.mas_top);
    }];
}

-(void)dianzan_InitState:(reply_model*)model{
    NSInteger reply_id = [model.ID integerValue];
    if([[MyDataBase shareManager] DianZan_IsHaveId:reply_id]){//是否存在该ID的记录
        //存在
        if([[MyDataBase shareManager] DianZan_IsDianZan:reply_id]){ //是否已经点赞
            [m_dianzan setImage:[UIImage imageNamed:@"ic_liked"] forState:UIControlStateNormal];
        }else{
            //没有点赞
            [m_dianzan setImage:[UIImage imageNamed:@"ic_like"] forState:UIControlStateNormal];
        }
    }else{
        //不存在
        [m_dianzan setImage:[UIImage imageNamed:@"ic_like"] forState:UIControlStateNormal];
    }
}

-(void)setDianZanNum_type:(NSInteger)type{
    NSInteger num = [self.model.thumbs_num integerValue];
    if(type == 0){//取消点赞
        if(IsDianZan){//起始点赞的状态
            num -= 1;
        }
        if(num > 0){
            m_dianzan_number.text = [NSString stringWithFormat:@"%ld",num];
        }else{
            m_dianzan_number.text = [NSString stringWithFormat:@"0"];
        }
    }else{//点赞
        if(!IsDianZan){//起始点赞的状态
            num += 1;
        }
        m_dianzan_number.text = [NSString stringWithFormat:@"%ld",num];
    }
}

#pragma mark - tableview协议
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.array_data.count == 0){
        return 0;
    }
    else{
        return self.array_data.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.array_data.count == 0){
        return nil;
    }
    reply_NoDianZan_TableViewCell* cell = [reply_NoDianZan_TableViewCell cellWithTableView:tableView];
    cell.main_model = self.model;
    cell.model = self.array_data[indexPath.row];
    cell.delegate = self;
    if(cell.model.array_reply.count > 0){
       cell.del_dianzan = NO;
    }
    else{
        cell.del_dianzan = YES;
    }
    
    cell.tag = indexPath.row;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    reply_model* model = self.array_data[indexPath.row];
    CGFloat hight = [LabelHelper GetLabelHight:kFONT(14) AndText:model.comment AndWidth:SCREEN_WIDTH-kWidth(38)-kWidth(16)];//评论高度
    
    return kWidth(100)+hight;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    reply_model* model = self.array_data[indexPath.row];
    [self InputTextAction];
    if(self.model == model){
        m_textView_placeHolder.text = @"";
        m_pre_reply = [NSString stringWithFormat:@"回复 %@:\n",model.myUserModel.user_name];
        m_textField.text = m_pre_reply;
        m_otherReply_model = model;
    }
}

#pragma mark - 协议
-(void)reply_NoDianZan_ByName:(reply_model *)model{
    [self InputTextAction];
    
}

#pragma mark - textField代理
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text]; //得到输入框的内容
    NSInteger MaxLenth = 140;
    
    if (textView)  //判断是否时我们想要限定的那个输入框
    {
        //判断发送按钮 的状态
        if([toBeString length] > 0){
            m_textView_placeHolder.text = @"";
            self.SenderButton.enabled = YES;
            self.SenderButton.backgroundColor = [UIColor colorWithRed:248/255.0 green:205/255.0 blue:4/255.0 alpha:1/1.0];
        }else{
            m_textView_placeHolder.text = @"说两句...";
            self.SenderButton.enabled = NO;
            self.SenderButton.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1/1.0];
        }
        
        if ([toBeString length] > MaxLenth) { //如果输入框内容大于MaxLenth则弹出警告
            textView.text = [toBeString substringToIndex:MaxLenth];
            
            UIAlertController* alert_VC = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"不能超过%ld个字符",MaxLenth] preferredStyle:UIAlertControllerStyleAlert];
            //弹出视图,使用UIViewController的方法
            [self presentViewController:alert_VC animated:YES completion:^{
                
                //隔一会就消失
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }];
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}

#pragma mark - 按钮方法
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dianzan_SetState:(UIButton*)bt{
    if(![Login_info share].isLogined){
        [MyMBProgressHUD ShowMessage:@"未登录!" ToView:self.view AndTime:1.0f];
        return;
    }
    NSInteger reply_id = [self.model.ID integerValue];
    if([[MyDataBase shareManager] DianZan_IsHaveId:reply_id]){//是否存在该ID的记录
        //存在
        if([[MyDataBase shareManager] DianZan_IsDianZan:reply_id]){ //是否已经点赞
            //点赞
            [[MyDataBase shareManager] DianZan_UpData:reply_id AndIsDIanZan:0];
            [bt setImage:[UIImage imageNamed:@"ic_like"] forState:UIControlStateNormal];
            [self setDianZanNum_type:0];
            self.model.DianZan_type = 0;
//            [InternetHelp DianzanById:self.model.ID andUser_id:[Login_info share].userInfo_model.user_id AndActionType:self.model.DianZan_type];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"点赞" object:self.model];
        }else{
            //没有点赞
            [[MyDataBase shareManager] DianZan_UpData:reply_id AndIsDIanZan:1];
            [bt setImage:[UIImage imageNamed:@"ic_liked"] forState:UIControlStateNormal];
            [self setDianZanNum_type:1];
            self.model.DianZan_type = 1;
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"点赞" object:self.model];
        }
    }else{
        //不存在
        [[MyDataBase shareManager] DianZan_insertData:reply_id AndIsDIanZan:1];
        [bt setImage:[UIImage imageNamed:@"ic_liked"] forState:UIControlStateNormal];
        [self setDianZanNum_type:1];
        self.model.DianZan_type = 1;
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"点赞" object:self.model];
    }
    
    NSInteger action = self.model.DianZan_type;
    action = action == 1 ? 1 : 2;//1：点赞    2：取消点赞
    [InternetHelp DianzanById:self.model.ID andUser_id:[Login_info share].userInfo_model.user_id AndActionType:action];
}

-(void)InputTextAction{
    NSLog(@"准备评论");
    if(![Login_info share].isLogined){
        [MyMBProgressHUD ShowMessage:@"未登陆!" ToView:self.view AndTime:1.0f];
        return;
    }
    
    //整个窗口（评论输入）
    UIView* inputTextView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    m_inputTextView = inputTextView;
    //全屏灰色透明
    UIView* inputTextBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    inputTextBackgroundView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4/1.0];
    //给遮罩添加手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [inputTextBackgroundView addGestureRecognizer:tap];
    inputTextBackgroundView.alpha = 0.6;
    [inputTextView addSubview:inputTextBackgroundView];
    
    //输入框视图
    UIView* inputText = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-150, SCREEN_WIDTH, 150)];
    inputText.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    [inputText addGestureRecognizer:tap1];
    
    UITextView* textField = [[UITextView alloc] initWithFrame:CGRectMake(16, 10, SCREEN_WIDTH-16-16, 90)];
    m_textField = textField;
    textField.backgroundColor = [[ThemeManager sharedInstance] GetDialogViewColor];
    //    textField.te = @"我来说两句...";
    textField.delegate = self;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.keyboardType = UIKeyboardTypeDefault;
    //    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.returnKeyType = UIReturnKeyNext;
    textField.keyboardAppearance = UIKeyboardAppearanceDefault;
    [textField becomeFirstResponder];
    textField.textColor = [[ThemeManager sharedInstance] GetDialogTextColor];
    textField.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:14];
    [inputText addSubview:textField];
    
    //textView中添加 placeHolder
    m_textView_placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, 100, 14)];
    m_textView_placeHolder.text = @"说两句...";
    m_textView_placeHolder.textColor = RGBA(167, 169, 169, 1);
    m_textView_placeHolder.textAlignment = NSTextAlignmentLeft;
    m_textView_placeHolder.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:14];
    [textField addSubview:m_textView_placeHolder];
    
    //取消
    UIButton* inputText_cancel = [[UIButton alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(textField.frame)+10, 60, 30)];
    [inputText_cancel setTitle:@"取消" forState:UIControlStateNormal];
    [inputText_cancel setTitleColor:[[ThemeManager sharedInstance] GetDialogTextColor] forState:UIControlStateNormal];
    [inputText_cancel.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
    [inputText_cancel addTarget:self action:@selector(DialogCancel) forControlEvents:UIControlEventTouchUpInside];
    inputText_cancel.backgroundColor = [[ThemeManager sharedInstance] GetDialogViewColor];
    [inputText_cancel.layer setCornerRadius:15.0f];
    inputText_cancel.layer.masksToBounds = YES;
    [inputText addSubview:inputText_cancel];
    
    //发送
    UIButton* inputText_true = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16-60, CGRectGetMaxY(textField.frame)+10, 60, 30)];
    [inputText_true setTitle:@"发送" forState:UIControlStateNormal];
    [inputText_true setTitleColor:[[ThemeManager sharedInstance] GetDialogTextColor] forState:UIControlStateNormal];
    [inputText_true.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
    [inputText_true addTarget:self action:@selector(DialogTure) forControlEvents:UIControlEventTouchUpInside];
    [inputText_true setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    [inputText_true.layer setCornerRadius:15.0f];
    inputText_true.layer.masksToBounds = YES;
    inputText_true.enabled = NO;
    [inputText addSubview:inputText_true];
    self.SenderButton = inputText_true;
    
    [inputTextView addSubview: inputText];
    self.inputReply = inputTextView;
    [self.view addSubview:inputTextView];
    
    //    [self.view layoutIfNeeded];
}

-(void)DialogCancel{
    NSLog(@"DialogCancel");
    [self.inputReply removeFromSuperview];
    m_pre_reply = nil;
}

-(void)DialogTure{
    NSLog(@"DialogTure");
    NSString* str_comment = m_textField.text;
    if(m_pre_reply != nil){
        str_comment = [str_comment stringByReplacingOccurrencesOfString:m_pre_reply withString:@""];
    }
    m_pre_reply = nil;
    [self SendReply:str_comment];
    [self.inputReply removeFromSuperview];
    m_otherReply_model = nil;
}

-(void)tapClick:(UITapGestureRecognizer*)tap{
    [self DialogCancel];
    m_otherReply_model = nil;
    m_pre_reply = nil;
}

//键盘回收
-(void)keyboardHide
{
    [m_textField resignFirstResponder];
}

#pragma mark -键盘监听
//移动UIView(随着键盘移动)
-(void)transformDialog:(NSNotification *)aNSNotification
{
    NSLog(@"全部回复移动");
    //键盘最后的frame
    CGRect keyboardFrame = [aNSNotification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    NSLog(@"全部回复看看这个变化的Y值:%f",height);
    //需要移动的距离
    if (height > 0) {
        _transformY = height-_currentKeyboardH;
        _currentKeyboardH = height;
        //移动
        [UIView animateWithDuration:0.25f animations:^{
            CGRect frame = self.inputReply.frame;
            frame.origin.y -= _transformY;
            self.inputReply.frame = frame;
        }];
    }
}
-(void)keyboardWillHide:(NSNotification *)aNSNotification{
    /* 输入框下移 */
    [UIView animateWithDuration:0.25f animations:^ {
        
        CGRect frame = self.inputReply.frame;
        frame.origin.y = 0;
        self.inputReply.frame = frame;
    }];
    //记得再收键盘后 初始化键盘参数
    _transformY = 0;
    _currentKeyboardH = 0;
}

#pragma mark - API
-(void)getData{
    [InternetHelp replyAllByUserId:self.model.myUserModel.user_id
                         AndNewsId:self.newsId
                            AndPid:[self.model.ID integerValue]
                           AndPage:m_page
                           AndSize:10
                            Sucess:^(NSDictionary *dic) {
                                if([dic containsObjectForKey:@"list"]){
                                    NSArray* array = dic[@"list"];
                                    
                                    if(m_page == 0){
                                        [self.array_data removeAllObjects];
                                        [self.array_data addObject:self.model];
                                        if(array.count < 10){
                                            for (NSDictionary* item in array) {
                                                [self.array_data addObject:[reply_model getModelByDic:item]];
                                            }
                                            [m_tableview.footer removeFromSuperview];
                                            [m_tableview.header endRefreshing];
                                        }
                                        m_page++;
                                    }
                                    else{
                                        if(array.count == 0){
                                            [m_tableview.footer endRefreshing];
                                            [m_tableview.footer noticeNoMoreData];
                                        }
                                        else{
                                            for (NSDictionary* item in array) {
                                                [self.array_data addObject:[reply_model getModelByDic:item]];
                                            }
                                            m_page++;
                                        }
                                    }
                                    
                                    [m_tableview reloadData];
                                }
    } Fail:^(NSDictionary *dic) {
        if(dic == nil){
            [MyMBProgressHUD ShowMessage:@"网络失败" ToView:self.view AndTime:1.0f];
        }
        else{
            [MyMBProgressHUD ShowMessage:dic[@"msg"] ToView:self.view AndTime:1.0f];
        }
    }];
}

-(void)SendReply:(NSString*)str_comment{
    NSString* To_userId = @"";
    if(m_otherReply_model != nil){ //当直接评论新闻时，没有userid
        To_userId = m_otherReply_model.myUserModel.user_id;
    }
    NSInteger pid = 0;
    if([m_otherReply_model.pid integerValue] == 0){
        pid = [m_otherReply_model.ID integerValue];
    }
    else{
        pid = [m_otherReply_model.pid integerValue];
    }
    [InternetHelp replyToOterReplyByUserId:[Login_info share].userInfo_model.user_id
                               andToUserId:To_userId
                                 andNewsId:self.newsId
                                    AndPid:pid
                                AndComment:str_comment Sucess:^(NSDictionary *dic) {
                                    [MyMBProgressHUD ShowMessage:@"评论成功" ToView:self.view AndTime:1.0f];
                                    m_page = 0;
                                    [self getData];//刷新
                                } Fail:^(NSDictionary *dic) {
                                    [MyMBProgressHUD ShowMessage:@"网络失败" ToView:self.view AndTime:1.0f];
                                }];
}

@end
