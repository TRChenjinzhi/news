//
//  Header_view.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Header_view.h"

#import "LabelHelper.h"
#import "Mine_userInfo_ViewController.h"
#import "Mine_ShowToFriend_ViewController.h"

@interface Header_view ()

@property (nonatomic,strong)UIView* goldView;

@property (nonatomic,strong)UILabel* gold_label;
@property (nonatomic,strong)UILabel* packge_label;
@property (nonatomic,strong)UILabel* apprentice_label;

@property (nonatomic,strong)UILabel* numberGold_label;
@property (nonatomic,strong)UILabel* numberPackage_label;
@property (nonatomic,strong)UILabel* numberApprentice_label;

@property (nonatomic,strong)UIView* login_view;//登陆界面
@property (nonatomic,strong)UIView* UnLogin_view;//没有登陆界面
@property (nonatomic,strong)UIView* logined_view;//已经登陆界面



@end

@implementation Header_view{
    UIView* headerBackView;
    
    NSInteger statusHight;
    BOOL m_IsLogin;
    
    UIImageView*            userInfo_img;
    UILabel*                userinfo_name;
    Mine_userInfo_model*    m_userInfo_model;
    


}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UITapGestureRecognizer *)m_tap_gold{
    if(!_m_tap_gold){
        _m_tap_gold = [[UITapGestureRecognizer alloc] init];
    }
    return _m_tap_gold;
}
-(UITapGestureRecognizer *)m_tap_moneyPackage{
    if(!_m_tap_moneyPackage){
        _m_tap_moneyPackage = [[UITapGestureRecognizer alloc] init];
    }
    return _m_tap_moneyPackage;
}
-(UITapGestureRecognizer *)m_tap_apprentice{
    if(!_m_tap_apprentice){
        _m_tap_apprentice = [[UITapGestureRecognizer alloc] init];
    }
    return _m_tap_apprentice;
}
-(UITapGestureRecognizer *)m_tap_guanggao{
    if(!_m_tap_guanggao){
        _m_tap_guanggao = [[UITapGestureRecognizer alloc] init];
    }
    return _m_tap_guanggao;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    statusHight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    //背景层
    UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 314)];
    backgroundView.backgroundColor = RGBA(242, 242, 242, 1);
    backgroundView.userInteractionEnabled = YES;
    
    //登陆状态层
    UIView* loginBackground_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    loginBackground_view.backgroundColor = [Color_Image_Helper ImageChangeToColor:[UIImage imageNamed:@"user_bg"] AndNewSize:CGSizeMake(SCREEN_WIDTH, 180)];
//    loginBackground_view.backgroundColor = RGBA(0, 0, 0, 0.0001);
    
    self.login_view = loginBackground_view;
    [backgroundView addSubview:self.login_view];
    
    //消息按钮
    BadgeButton* message_button = [[BadgeButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-kWidth(16)-25, 21, 25, 28)];
    [message_button setImage:[UIImage imageNamed:@"ic_nav_message"] forState:UIControlStateNormal];
    message_button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    message_button.isMessage = YES;
    [message_button setCount:0];//消息数
//    [message_button addTarget:self action:@selector(GoToMessage) forControlEvents:UIControlEventTouchUpInside];
    self.messageButton = message_button;
    [backgroundView addSubview:self.messageButton];
    
    //登陆界面
    [self initLoginView];
    
//    //曲线层
//    UIImageView* img_view = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(loginBackground_view.frame), SCREEN_WIDTH, 16)];
//    img_view.backgroundColor = [UIColor colorWithRed:248/255.0 green:205/255.0 blue:4/255.0 alpha:1/1.0];
////    img_view.contentMode = UIViewContentModeBottom;
////    img_view.backgroundColor = [UIColor blackColor];
//    [img_view setImage:[UIImage imageNamed:@"mine_bg"]];
//
//    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 1)];//为了覆盖 图片下面的一条黄线
//    line.backgroundColor = [UIColor whiteColor];
//    [img_view addSubview:line];
//
//    [backgroundView addSubview:img_view];
    
    
    //金币细节显示层
    UIView* gold_view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(loginBackground_view.frame), SCREEN_WIDTH, 44)];
    gold_view.backgroundColor = [UIColor whiteColor];
    gold_view.userInteractionEnabled = YES;
    
    UILabel* gold_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 12)];
    gold_label.text = @"金币";
    gold_label.textColor = [[ThemeManager sharedInstance] MineSmallTextColor];
    gold_label.textAlignment = NSTextAlignmentCenter;
    gold_label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:12];
    gold_label.userInteractionEnabled = YES;
    self.gold_label = gold_label;
    [gold_view addSubview:gold_label];
    
    UILabel* moneyPackge_label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(gold_label.frame), 0, SCREEN_WIDTH/3, 12)];
    moneyPackge_label.text = @"钱包";
    moneyPackge_label.textColor = [[ThemeManager sharedInstance] MineSmallTextColor];
    moneyPackge_label.textAlignment = NSTextAlignmentCenter;
    moneyPackge_label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:12];
    moneyPackge_label.userInteractionEnabled = YES;
    self.packge_label = moneyPackge_label;
    [gold_view addSubview:moneyPackge_label];
    
    UILabel* apprentice_label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(moneyPackge_label.frame), 0, SCREEN_WIDTH/3, 12)];
    apprentice_label.text = @"徒弟";
    apprentice_label.textColor = [[ThemeManager sharedInstance] MineSmallTextColor];
    apprentice_label.textAlignment = NSTextAlignmentCenter;
    apprentice_label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:12];
    apprentice_label.userInteractionEnabled = YES;
    self.apprentice_label = apprentice_label;
    [gold_view addSubview:apprentice_label];
    
    self.goldView = gold_view;
    [backgroundView addSubview:gold_view];
    
    //广告层
//    UIImageView* guanggao_img = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(gold_view.frame)+10, SCREEN_WIDTH, 70)];
//    [guanggao_img setImage:[UIImage imageNamed:@"invite_banner"]];
//
//    guanggao_img.userInteractionEnabled = YES;
//
//    UIView* guanggao_clickView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, guanggao_img.frame.size.width, guanggao_img.frame.size.height)];
//    guanggao_clickView.userInteractionEnabled = YES;
//    [guanggao_clickView addGestureRecognizer:self.m_tap_guanggao];
//    [guanggao_img addSubview:guanggao_clickView];
//    _m_guanggao_img = guanggao_img;
//    _m_guanggao_clickView = guanggao_clickView;
//
//    [backgroundView addSubview:guanggao_img];
    
    headerBackView = backgroundView;
    [self addSubview:headerBackView];
}

-(void)bannerView_bengain{
//    [_m_guanggao_img removeFromSuperview];
    NSMutableArray* tmp = [NSMutableArray array];
    for (Banner_model* item in [Banner_model share].array) {
        [tmp addObject:[NSURL URLWithString:item.ad_url]];
    }
    self.bannerView = [[BannerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.goldView.frame)+10, SCREEN_WIDTH, 70) ImageUrls:tmp IntervalTime:3.0];
    //    self.bannerView.delegate = self;
    [headerBackView addSubview:self.bannerView];
}

-(void)initLoginView{
    self.UnLogin_view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-104/2, 86, 104, 32)];
    
    //登陆按钮
    UIButton* login_button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 104, 32)];
    login_button.backgroundColor = [UIColor colorWithRed:251/255.0 green:84/255.0 blue:38/255.0 alpha:1/1.0];
    [login_button setTitle:@"登录" forState:UIControlStateNormal];
    [login_button setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    [login_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
    [login_button.layer setCornerRadius:16];
    [login_button addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.UnLogin_view addSubview:login_button];
    
    
    self.logined_view = [[UIView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 48)];
    
    //头像
    UIView* touxiang_view = [[UIView alloc] initWithFrame:CGRectMake(16, 0, 48, 48)];
    touxiang_view.backgroundColor = [UIColor whiteColor];
    [touxiang_view.layer setCornerRadius:touxiang_view.frame.size.width/2];
    
    UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 44, 44)];
    [imgV.layer setCornerRadius:imgV.frame.size.width/2];
    [imgV setImage:[UIImage imageNamed:@""]];
    [imgV setContentMode:UIViewContentModeScaleAspectFill];
    imgV.clipsToBounds = YES;
    
    [touxiang_view addSubview:imgV];
    userInfo_img = imgV;
    [self.logined_view addSubview:touxiang_view];
    
    //名称
    UILabel* name_label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(touxiang_view.frame)+16, 48/2-25/2, 242, 25)];
    name_label.textAlignment = NSTextAlignmentLeft;
    name_label.text = @"123";
    name_label.font = [UIFont boldSystemFontOfSize:18];
    name_label.textColor = RGBA(255, 255, 255, 1);
    
    userinfo_name = name_label;
    [self.logined_view addSubview:name_label];
    
    //img（右箭头）
    UIImageView* img_jiantou = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-kWidth(16)-16, 15, 16, 16)];
    [img_jiantou setImage:[UIImage imageNamed:@"ic_list_next_white"]];
    [self.logined_view addSubview:img_jiantou];
    
    //点击层
    UIView* tap_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
    [self.logined_view addSubview:tap_view];
    _loginToDetailLogin = tap_view;
}

-(void)setNumber_gold:(NSInteger)number_gold{

    if(self.numberGold_label){
        [self.numberGold_label removeFromSuperview];
    }
    UILabel* numberGold_label = [[UILabel alloc] init];
    NSString* str_int = [NSString stringWithFormat:@"%ld",number_gold];
    UIFont* font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:16];
    NSInteger width = [LabelHelper GetLabelWidth:font AndText:str_int];
    NSLog(@"str_int:%@",str_int);
    numberGold_label.frame = CGRectMake(CGRectGetMinX(self.gold_label.frame)+self.gold_label.frame.size.width/2-width/2,
                                        CGRectGetMaxY(self.gold_label.frame)+8,
                                        width+10,
                                        16);
    NSLog(@"x:%f,y:%f,width:%f,hight:%f",numberGold_label.frame.origin.x,
          numberGold_label.frame.origin.y,
          numberGold_label.frame.size.width,
          numberGold_label.frame.size.height);
    numberGold_label.text = str_int;
    numberGold_label.textColor = [UIColor colorWithRed:255/255.0 green:129/255.0 blue:3/255.0 alpha:1/1.0];
    
    [self.goldView addSubview:numberGold_label];
    self.numberGold_label = numberGold_label;
    
    //添加点击层
    UIView* click_view = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                                 CGRectGetMidY(self.gold_label.frame),
                                                                 SCREEN_WIDTH/3,
                                                                 28)];
    [self.goldView addSubview:click_view];
    self.gold_click_view = click_view;
    [click_view addGestureRecognizer:self.m_tap_gold];
    
    [headerBackView addSubview:self.goldView];
    [self addSubview:headerBackView];
}

-(void)setNumber_package:(CGFloat)number_package{

    if(self.numberPackage_label){
        [self.numberPackage_label removeFromSuperview];
    }
    UILabel* numberPackage_label = [[UILabel alloc] init];
    NSString* str_int = [NSString stringWithFormat:@"%.2f",number_package];
    NSLog(@"str_int:%@",str_int);
    UIFont* font = [UIFont systemFontOfSize:16];
    NSInteger width = [LabelHelper GetLabelWidth:font AndText:str_int];
    NSLog(@"width:%ld",width);
    numberPackage_label.frame = CGRectMake(CGRectGetMinX(self.packge_label.frame)+self.packge_label.frame.size.width/2-width/2,
                                           CGRectGetMaxY(self.packge_label.frame)+8,
                                           width+10,
                                           16);
    numberPackage_label.text = str_int;
    numberPackage_label.textColor = [UIColor colorWithRed:255/255.0 green:129/255.0 blue:3/255.0 alpha:1/1.0];
    
    [self.goldView addSubview:numberPackage_label];
    self.numberPackage_label = numberPackage_label;
    
    //添加点击层
    UIView* click_view = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3,
                                                                 CGRectGetMidY(self.packge_label.frame),
                                                                 SCREEN_WIDTH/3,
                                                                 28)];
    [self.goldView addSubview:click_view];
    self.package_click_view = click_view;
    [click_view addGestureRecognizer:self.m_tap_moneyPackage];
    
    [headerBackView addSubview:self.goldView];
    [self addSubview:headerBackView];
    
}

-(void)setNumber_apprentice:(NSInteger)number_apprentice{

    if(self.numberApprentice_label){
        [self.numberApprentice_label removeFromSuperview];
    }
    UILabel* numberApprentice_label = [[UILabel alloc] init];
    NSString* str_int = [NSString stringWithFormat:@"%ld",number_apprentice];
    UIFont* font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:16];
    NSInteger width = [LabelHelper GetLabelWidth:font AndText:str_int];
    numberApprentice_label.frame = CGRectMake(CGRectGetMinX(self.apprentice_label.frame)+self.apprentice_label.frame.size.width/2-width/2,
                                              CGRectGetMaxY(self.apprentice_label.frame)+8,
                                              width+10,
                                              16);
    numberApprentice_label.text = str_int;
    numberApprentice_label.textColor = [UIColor colorWithRed:255/255.0 green:129/255.0 blue:3/255.0 alpha:1/1.0];
    [self.goldView addSubview:numberApprentice_label];
    self.numberApprentice_label = numberApprentice_label;
    
    //添加点击层
    UIView* click_view = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2,
                                                                 CGRectGetMidY(self.apprentice_label.frame),
                                                                 SCREEN_WIDTH/3,
                                                                 28)];
    [self.goldView addSubview:click_view];
    self.apprentice_click_view = click_view;
    
    [click_view addGestureRecognizer:self.m_tap_apprentice];
    
    [headerBackView addSubview:self.goldView];
    [self addSubview:headerBackView];
}

-(void)setIsLognin:(BOOL)IsLognin{
    
    if(!m_IsLogin){
        m_IsLogin = IsLognin;//第一次执行时
    }else{
        if(m_IsLogin == IsLognin){ //当登陆状态没有改变时
            return;
        }
        else{
            m_IsLogin = IsLognin;
        }
    }
    
    if(!IsLognin){
        //没有登陆
        if(self.logined_view){
            [self.logined_view removeFromSuperview];
        }
        
        [self.login_view addSubview:self.UnLogin_view];
    }else{
        //登陆
        if(self.UnLogin_view){
            [self.UnLogin_view removeFromSuperview];
        }
        
        [self.login_view addSubview:self.logined_view];
    }
        
}

-(void)setUserInfo_model:(Mine_userInfo_model *)userInfo_model{
    m_userInfo_model = userInfo_model;
    if([userInfo_model.icon isEqualToString:@""]){
        [userInfo_img setImage:[UIImage imageNamed:@"list_avatar"]];
    }else{
        UIImage* img = [[AppConfig sharedInstance] getUserIcon];
        if(img){
            [userInfo_img setImage:img];
        }else{
            [userInfo_img sd_setImageWithURL:[NSURL URLWithString:userInfo_model.icon] placeholderImage:nil options:SDWebImageRefreshCached];
        }
    }

    userinfo_name.text = userInfo_model.name;
    self.IsLognin = userInfo_model.IsLogin;
    self.number_gold = userInfo_model.gold;
    self.number_package = userInfo_model.package;
    self.number_apprentice = userInfo_model.apprentice;

}

-(void)loginAction{
    NSLog(@"进入登陆界面");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"登陆" object:nil];
}


@end
