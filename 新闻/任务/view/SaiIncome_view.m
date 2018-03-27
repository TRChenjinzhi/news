//
//  SaiIncome_view.m
//  新闻
//
//  Created by chenjinzhi on 2018/2/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SaiIncome_view.h"
#import <QuartzCore/QuartzCore.h>

@implementation SaiIncome_view{
    UIImageView*        m_img;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6/1.0];
    
    //退出按钮
    UIButton* del_button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-45-30, 110, 30, 30)];
    [del_button setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [del_button addTarget:self action:@selector(del_action) forControlEvents:UIControlEventTouchUpInside];
    [del_button setImageEdgeInsets:UIEdgeInsetsMake(14, 14, 0, 0)];
    [self addSubview:del_button];
    
    //大图
    UIImageView* big_img = [[UIImageView alloc] initWithFrame:CGRectMake(45, CGRectGetMaxY(del_button.frame)+14.5, SCREEN_WIDTH-45-45, 360)];
    [big_img setImage:[UIImage imageNamed:@"share_bg"]];
    [self addSubview:big_img];
    m_img = big_img;
        //title
    UILabel* title_label = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, big_img.frame.size.width, 24)];
    NSMutableAttributedString* att_string = [[NSMutableAttributedString alloc] initWithString:@"我在有料里"];
    att_string = [LabelHelper GetMutableAttributedSting_bold_font:att_string AndIndex:0 AndCount:2 AndFontSize:16];
    att_string = [LabelHelper GetMutableAttributedSting_color:att_string AndIndex:0 AndCount:2 AndColor: [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0]];
    att_string = [LabelHelper GetMutableAttributedSting_bold_font:att_string AndIndex:2 AndCount:2 AndFontSize:26];
    att_string = [LabelHelper GetMutableAttributedSting_color:att_string AndIndex:2 AndCount:2 AndColor:[UIColor blackColor]];
    att_string = [LabelHelper GetMutableAttributedSting_bold_font:att_string AndIndex:4 AndCount:1 AndFontSize:16];
    att_string = [LabelHelper GetMutableAttributedSting_color:att_string AndIndex:4 AndCount:1 AndColor: [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0]];
    title_label.textAlignment = NSTextAlignmentCenter;
    title_label.attributedText = att_string;
    [big_img addSubview:title_label];
    
    //subTitle
    UILabel* subTitle_label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(title_label.frame)+24, big_img.frame.size.width, 40)];
    subTitle_label.textColor = [UIColor colorWithRed:251/255.0 green:84/255.0 blue:38/255.0 alpha:1/1.0];
    NSString* str = [NSString stringWithFormat:@"赚了%@元",[Login_info share].userMoney_model.total_income];
    NSMutableAttributedString* att1_string = [[NSMutableAttributedString alloc] initWithString:str];
    att1_string = [LabelHelper GetMutableAttributedSting_bold_font:att1_string AndIndex:0 AndCount:2 AndFontSize:16];
    att1_string = [LabelHelper GetMutableAttributedSting_bold_font:att1_string AndIndex:2 AndCount:str.length-3 AndFontSize:34];
    att1_string = [LabelHelper GetMutableAttributedSting_bold_font:att1_string AndIndex:str.length-1 AndCount:1 AndFontSize:16];

    subTitle_label.attributedText = att1_string;
    subTitle_label.textAlignment = NSTextAlignmentCenter;
    [big_img addSubview:subTitle_label];
    
    //二维码图片
    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(big_img.frame.size.width-48-40, big_img.frame.size.height-20-48, 48, 48)];
    NSString* str_url = [NSString stringWithFormat:@"http://younews.3gshow.cn/api/share?user_id=%@",[Login_info share].userInfo_model.user_id];
    [img setImage:[erWeiMa_Helper GetErWeiMa_string:str_url AndSize:48]];
    [big_img addSubview:img];
    
    //二维码图片左边文字
    UILabel* img_tips = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(img.frame)-8-130,
                                                                 CGRectGetMinY(img.frame),
                                                                 130, 48)];
    NSString* appren = [Login_info share].userInfo_model.appren;
    NSString* img_str = [NSString stringWithFormat:@"长按可扫码下载\n输入邀请码%@\n立即领红包",appren];
    NSMutableAttributedString* att_img_str = [[NSMutableAttributedString alloc] initWithString:img_str];
    NSRange range = [img_str rangeOfString:appren];
    att_img_str = [LabelHelper GetMutableAttributedSting_font:att_img_str AndIndex:0 AndCount:img_str.length AndFontSize:12];
    att_img_str = [LabelHelper GetMutableAttributedSting_color:att_img_str AndIndex:0 AndCount:img_str.length AndColor:RGBA(34, 39, 39, 1)];
    att_img_str = [LabelHelper GetMutableAttributedSting_color:att_img_str AndIndex:range.location AndCount:range.length AndColor:RGBA(251, 84, 38, 1)];
    
    img_tips.textAlignment = NSTextAlignmentRight;
    img_tips.numberOfLines = 3;
    img_tips.attributedText = att_img_str;
    [big_img addSubview:img_tips];
    
    //分享
    NSInteger width = 48;
    NSInteger hight = 48;
    NSInteger instance = (SCREEN_WIDTH-45-45-48*4)/3;
    
    UIButton* bt_friend = [[UIButton alloc]initWithFrame:CGRectMake(45, CGRectGetMaxY(big_img.frame)+24, width, hight)];
    [bt_friend setImage:[UIImage imageNamed:@"ic_friend"] forState:UIControlStateNormal];
    [bt_friend addTarget:self action:@selector(friend_action) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bt_friend];
    
    UIButton* bt_wechat = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bt_friend.frame)+instance, CGRectGetMaxY(big_img.frame)+24, width, hight)];
    [bt_wechat setImage:[UIImage imageNamed:@"ic_wechat"] forState:UIControlStateNormal];
    [bt_wechat addTarget:self action:@selector(wechat_action) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bt_wechat];
    
    UIButton* bt_qq = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bt_wechat.frame)+instance, CGRectGetMaxY(big_img.frame)+24, width, hight)];
    [bt_qq setImage:[UIImage imageNamed:@"ic_qq"] forState:UIControlStateNormal];
    [bt_qq addTarget:self action:@selector(qq_action) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bt_qq];
    
    UIButton* bt_zone = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bt_qq.frame)+instance, CGRectGetMaxY(big_img.frame)+24, width, hight)];
    [bt_zone setImage:[UIImage imageNamed:@"ic_zone"] forState:UIControlStateNormal];
    [bt_zone addTarget:self action:@selector(zone_action) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bt_zone];
}

#pragma mark - 按钮方法
-(void)del_action{
    [self removeFromSuperview];
}

-(void)friend_action{
    [UMShareHelper SharePNGByName:@"朋友圈" AndImg:[self imageWithView:(UIView*)m_img]];
    [self removeFromSuperview];
}
-(void)wechat_action{
    [UMShareHelper SharePNGByName:@"微信好友" AndImg:[self imageWithView:(UIView*)m_img]];
    [self removeFromSuperview];
}
-(void)qq_action{
    [UMShareHelper SharePNGByName:@"QQ好友" AndImg:[self imageWithView:(UIView*)m_img]];
    [self removeFromSuperview];
}
-(void)zone_action{
    [UMShareHelper SharePNGByName:@"QQ空间" AndImg:[self imageWithView:(UIView*)m_img]];
    [self removeFromSuperview];
}

- (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end
