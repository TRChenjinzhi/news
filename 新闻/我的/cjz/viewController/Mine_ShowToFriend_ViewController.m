//
//  Mine_ShowToFriend_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_ShowToFriend_ViewController.h"

@interface Mine_ShowToFriend_ViewController ()

@end

@implementation Mine_ShowToFriend_ViewController{
    UIView*         m_navibar_view;
    UIScrollView*   m_scrollView;
    UIView*         m_footView;
    
    NSArray*        m_title;
    NSArray*        m_img;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavi];
    [self initView];
    [self initFootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
    [[ NSNotificationCenter defaultCenter ] addObserver : self selector : @selector (layoutControllerSubViews:) name : UIApplicationDidChangeStatusBarFrameNotification object : nil ];
    
    
    //热点变化
    CGRect tabbarview_frame = m_footView.frame;
    if(STATUS_BAR_BIGGER_THAN_20){
        tabbarview_frame = CGRectMake(tabbarview_frame.origin.x, tabbarview_frame.origin.y-20, tabbarview_frame.size.width, tabbarview_frame.size.height);
    }
    m_footView.frame = tabbarview_frame;
}

-(void)layoutControllerSubViews:(NSNotification*)noti{
    CGRect tabbarview_frame = m_footView.frame;
    if(STATUS_BAR_BIGGER_THAN_20){
        tabbarview_frame = CGRectMake(tabbarview_frame.origin.x, tabbarview_frame.origin.y-20, tabbarview_frame.size.width, tabbarview_frame.size.height);
    }else{
        tabbarview_frame = CGRectMake(tabbarview_frame.origin.x, tabbarview_frame.origin.y+20, tabbarview_frame.size.width, tabbarview_frame.size.height);
    }
    m_footView.frame = tabbarview_frame;
}

-(void)initNavi{
    UIView* navibar_view = [[UIView alloc] initWithFrame:CGRectMake(0, StaTusHight, SCREEN_WIDTH, 56)];
    
    UIButton* back_button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
    [back_button setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [back_button setImage:[UIImage imageNamed:@"ic_nav_back"] forState:UIControlStateNormal];
    [back_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navibar_view addSubview:back_button];
    
    //    UIButton* history_button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-56-14, 21, 56, 14)];
    //    [history_button setTitle:@"提现记录" forState:UIControlStateNormal];
    //    [history_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [history_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
    //    [history_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    //    [navibar_view addSubview:history_button];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-150/2, 18, 150, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"邀请收徒";
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
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                              CGRectGetMaxY(m_navibar_view.frame),
                                                                              SCREEN_WIDTH,
                                                                              SCREEN_HEIGHT-CGRectGetMaxY(m_navibar_view.frame)-100)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 311+10+139+17);
    m_scrollView = scrollView;
    
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 311)];
    
    UIImageView* one_img = [[UIImageView alloc] initWithFrame:CGRectMake(42, 21, SCREEN_WIDTH-42-42, 100)];
    [one_img setImage:[UIImage imageNamed:@"invite_text"]];
    
    UIImageView* two_img = [[UIImageView alloc] initWithFrame:CGRectMake(42, CGRectGetMaxY(one_img.frame)+20, SCREEN_WIDTH-42-42, 146)];
    [two_img setImage:[UIImage imageNamed:@"invite_copy_bg"]];
    
    UILabel* number_lable = [[UILabel alloc] initWithFrame:CGRectMake(two_img.frame.size.width/2-150/2, 35, 150, 32)];
    number_lable.text = [NSString stringWithFormat:@"%ld",self.number];
    number_lable.textColor = [UIColor whiteColor];
    number_lable.font = [UIFont boldSystemFontOfSize:32];
    number_lable.textAlignment = NSTextAlignmentCenter;
    [two_img addSubview:number_lable];
    
    [headerView addSubview:one_img];
    [headerView addSubview:two_img];
    
    UIButton* getNumber_button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-102/2, CGRectGetMinY(two_img.frame)+75, 102, 26)];
    [getNumber_button setTitle:@"点击复制邀请码" forState:UIControlStateNormal];
    [getNumber_button setBackgroundColor:[UIColor colorWithRed:255/255.0 green:238/255.0 blue:221/255.0 alpha:1/1.0]];
    [getNumber_button setTitleColor: [UIColor colorWithRed:247/255.0 green:103/255.0 blue:25/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    [getNumber_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:12]];
    [getNumber_button.layer setCornerRadius:10];
    [getNumber_button addTarget:self action:@selector(copyNumber) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:getNumber_button];
    
    
    [m_scrollView addSubview:headerView];
    
    //间隔区
    UIView* boldLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame), SCREEN_WIDTH, 10)];
    boldLine.backgroundColor =  [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [m_scrollView addSubview:boldLine];
    
    //下半部分
    UIView* footView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(boldLine.frame), SCREEN_WIDTH,
                                                                SCREEN_HEIGHT-CGRectGetMaxY(boldLine.frame))];
    
    UILabel* title_lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 16)];
    title_lable.numberOfLines = 0;
    title_lable.text = @"收徒须知";
    title_lable.textColor = [UIColor colorWithRed:255/255.0 green:126/255.0 blue:95/255.0 alpha:1/1.0];
    title_lable.textAlignment = NSTextAlignmentCenter;
    title_lable.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:16];
    [footView addSubview:title_lable];
    
    NSString* str1 = @"1. 分享邀请链接，好友通过你的链接输入手机号即可注册成功";
    CGFloat hight1 = [LabelHelper GetLabelHight:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14] AndText:str1 AndWidth:SCREEN_WIDTH-42-42];
    UILabel* first_lable = [[UILabel alloc] initWithFrame:CGRectMake(42, CGRectGetMaxY(title_lable.frame)+10, SCREEN_WIDTH-42-42, hight1)];
    first_lable.numberOfLines = 0;
    first_lable.text = str1;
    first_lable.textColor = [UIColor colorWithRed:122/255.0 green:125/255.0 blue:125/255.0 alpha:1/1.0];
    first_lable.textAlignment = NSTextAlignmentLeft;
    first_lable.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:14];
    [footView addSubview:first_lable];
    
    NSString* str2 = @"2. 好友通过你的链接注册成功后登录有料APP可领取现金红包";
    CGFloat hight2 = [LabelHelper GetLabelHight:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14] AndText:str2 AndWidth:SCREEN_WIDTH-42-42];
    UILabel* second_lable = [[UILabel alloc] initWithFrame:CGRectMake(42, CGRectGetMaxY(first_lable.frame)+10, SCREEN_WIDTH-42-42, hight2)];
    second_lable.numberOfLines = 0;
    second_lable.text = str2;
    second_lable.textColor = [UIColor colorWithRed:122/255.0 green:125/255.0 blue:125/255.0 alpha:1/1.0];
    second_lable.textAlignment = NSTextAlignmentLeft;
    second_lable.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:14];
    [footView addSubview:second_lable];
    
    NSString* str3 = @"3.好友连续3天打开有料APP，你将获得邀请奖励，首次额外1元";
    CGFloat hight3 = [LabelHelper GetLabelHight:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14] AndText:str3 AndWidth:SCREEN_WIDTH-42-42];
    UILabel* three_lable = [[UILabel alloc] initWithFrame:CGRectMake(42, CGRectGetMaxY(second_lable.frame)+10, SCREEN_WIDTH-42-42, hight3)];
    three_lable.numberOfLines = 0;
    three_lable.text = str3;
    three_lable.textColor = [UIColor colorWithRed:122/255.0 green:125/255.0 blue:125/255.0 alpha:1/1.0];
    three_lable.textAlignment = NSTextAlignmentLeft;
    three_lable.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:14];
    [footView addSubview:three_lable];
    
    NSString* str4 = @"4.徒弟完成任务，师傅可获得平台额外提成，不影响徒弟收益";
    CGFloat hight4 = [LabelHelper GetLabelHight:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14] AndText:str4 AndWidth:SCREEN_WIDTH-42-42];
    UILabel* four_lable = [[UILabel alloc] initWithFrame:CGRectMake(42, CGRectGetMaxY(three_lable.frame)+10, SCREEN_WIDTH-42-42, hight4)];
    four_lable.numberOfLines = 0;
    four_lable.text = str4;
    four_lable.textColor = [UIColor colorWithRed:122/255.0 green:125/255.0 blue:125/255.0 alpha:1/1.0];
    four_lable.textAlignment = NSTextAlignmentLeft;
    four_lable.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:14];
    [footView addSubview:four_lable];
    
    [m_scrollView addSubview:footView];
    footView.frame = CGRectMake(0, CGRectGetMaxY(boldLine.frame),
                                SCREEN_WIDTH,
                                hight1+hight2+hight3+hight4+40);
    m_scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 311+10+36+footView.frame.size.height);
    [self.view addSubview:m_scrollView];
}

-(void)initFootView{
    UIView* blackgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-100, SCREEN_WIDTH, 100)];
    m_footView = blackgroudView;
    blackgroudView.backgroundColor = [UIColor whiteColor];
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    [blackgroudView addSubview:line];
    
    [self getData];
    
    for(int i=0;i<m_title.count;i++){
        NSInteger jianGe = (SCREEN_WIDTH-28-28-m_title.count*48)/(m_title.count-1);
        UIView* view = [self buttonView:i AndJianGe:jianGe];
        view.tag = i;
        [blackgroudView addSubview:view];
    }
    
    
    [self.view addSubview:blackgroudView];
    
}

-(UIView*)buttonView:(NSInteger)index AndJianGe:(NSInteger)jianGe{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(28+index*48+index*jianGe, 16, 48, 68)];
    
    UIImageView* img  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
    [img setImage:[UIImage imageNamed:m_img[index]]];
    [view addSubview:img];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame)+8, 48, 12)];
    title.text = m_title[index];
    title.textColor = [UIColor colorWithRed:122/255.0 green:125/255.0 blue:125/255.0 alpha:1/1.0];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:12];
    [view addSubview:title];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowOthers:)];
    [view addGestureRecognizer:tap];
    
    return view;
}

#pragma mark - 按钮方法
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)copyNumber{
    NSLog(@"复制");
    [self copylinkBtnClick];
}

/**
 * 复制链接
 */
- (void)copylinkBtnClick {
    
    [MBProgressHUD showSuccess:@"复制成功!"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%ld",self.number];
}

-(void)ShowOthers:(UITapGestureRecognizer*)tap{
    UIView* view = tap.view;
    NSInteger tag = view.tag;
    switch (tag) {
        case 0://朋友圈
        {
            NSLog(@"朋友圈");
            [UMShareHelper ShareName:@"朋友圈"];
            break;
        }
        case 1://微信好友
        {
            NSLog(@"微信好友");
            [UMShareHelper ShareName:@"微信好友"];
            break;
        }
        case 2://QQ好友
        {
            NSLog(@"QQ好友");
            [UMShareHelper ShareName:@"QQ好友"];
            break;
        }
        case 3://QQ空间
        {
            NSLog(@"QQ空间");
            [UMShareHelper ShareName:@"QQ空间"];
            break;
        }
        default:
            break;
    }
}

-(void)getData{
    NSArray* img = @[@"ic_friend",@"ic_wechat",@"ic_qq",@"ic_zone"];
    NSArray* title = @[@"朋友圈",@"微信好友",@"QQ好友",@"QQ空间"];
    m_title = title;
    m_img = img;
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
