//
//  SaiIncome_createImageVew.m
//  橙子快报
//
//  Created by chenjinzhi on 2018/5/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SaiIncome_createImageVew.h"

@implementation SaiIncome_createImageVew

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
    }
    return self;
}

-(void)setUI:(void (^)(void))sucess fail:(void (^)(void))failed{
    //背景图片
    UIImageView* bg_imgV = [UIImageView new];
    [bg_imgV setImage:[UIImage imageNamed:@"show_bg"]];
    [self addSubview:bg_imgV];
    [bg_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIImageView* logo_imgV = [UIImageView new];
    [logo_imgV setImage:[UIImage imageNamed:@"show_icon"]];
    [bg_imgV addSubview:logo_imgV];
    [logo_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bg_imgV.mas_left).offset(kWidth(24));;
        make.top.equalTo(bg_imgV.mas_top).offset(kWidth(24));
    }];
    
    UIImageView* touxiang_imgV = [UIImageView new];
    //最后加载图片
    [touxiang_imgV.layer setBorderColor:RGBA(255, 174, 192, 1).CGColor];
    [touxiang_imgV.layer setBorderWidth:kWidth(3)];
    [touxiang_imgV.layer setCornerRadius:kWidth(50)/2];
    touxiang_imgV.layer.masksToBounds = YES;
    [bg_imgV addSubview:touxiang_imgV];
    [touxiang_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logo_imgV.mas_bottom).offset(kWidth(18));
        make.width.and.height.mas_offset(kWidth(50));
        make.centerX.equalTo(bg_imgV.mas_centerX);
    }];
    
    UILabel* name_label = [UILabel new];
    name_label.text                 = [Login_info share].userInfo_model.name;
    name_label.textColor            = RGBA(255, 255, 255, 1);
    name_label.textAlignment        = NSTextAlignmentCenter;
    name_label.font                 = kFONT(16);
    [bg_imgV addSubview:name_label];
    [name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(bg_imgV);
        make.top.equalTo(touxiang_imgV.mas_bottom).offset(kWidth(8));
    }];
    
    UILabel* title_label = [UILabel new];
    title_label.text                 = @"我在橙子快报赚了";
    title_label.textColor            = RGBA(255, 255, 255, 1);
    title_label.textAlignment        = NSTextAlignmentCenter;
    title_label.font                 = [UIFont boldSystemFontOfSize:kWidth(24)];
    [bg_imgV addSubview:title_label];
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(bg_imgV);
        make.top.equalTo(name_label.mas_bottom).offset(kWidth(24));
    }];
    
    UILabel* money_label = [UILabel new];
    money_label.text                 = [Login_info share].userMoney_model.total_income;
    money_label.textColor            = RGBA(253, 8, 31, 1);
    money_label.textAlignment        = NSTextAlignmentCenter;
    money_label.font                 = KBFONT(65);
    [bg_imgV addSubview:money_label];
    [money_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset([LabelHelper GetLabelWidth:KBFONT(65) AndText:[Login_info share].userMoney_model.total_income]);
        make.height.mas_offset(kWidth(65));
        make.top.equalTo(bg_imgV.mas_top).offset(kWidth(285));
        make.centerX.equalTo(bg_imgV.mas_centerX);
    }];
    
    UIImageView* money_imgV = [UIImageView new];
    [money_imgV setImage:[UIImage imageNamed:@"yuan"]];
    [bg_imgV addSubview:money_imgV];
    [money_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(money_label.mas_right).offset(kWidth(2));;
        make.top.equalTo(money_label.mas_top);
        make.width.and.height.mas_offset(kWidth(18));
    }];
    
    //二维码图片下边文字
    UILabel* img_tips = [UILabel new];
    NSString* appren = [Login_info share].userInfo_model.appren;
    NSString* img_str = [NSString stringWithFormat:@"长按可扫码下载\n输入邀请码 %@\n立即领红包",appren];
    NSMutableAttributedString* att_img_str = [[NSMutableAttributedString alloc] initWithString:img_str];
    NSRange range = [img_str rangeOfString:appren];
    att_img_str = [LabelHelper GetMutableAttributedSting_font:att_img_str AndIndex:0 AndCount:img_str.length AndFontSize:kWidth(16)];
    att_img_str = [LabelHelper GetMutableAttributedSting_color:att_img_str AndIndex:0 AndCount:img_str.length AndColor:RGBA(255, 255, 255, 1)];
    att_img_str = [LabelHelper GetMutableAttributedSting_color:att_img_str AndIndex:range.location AndCount:range.length AndColor:RGBA(255, 239, 152, 1)];
    att_img_str = [LabelHelper GetMutableAttributedSting_lineSpaceing:att_img_str AndSpaceing:kWidth(5)];
    img_tips.numberOfLines = 3;
    img_tips.attributedText = att_img_str;
    img_tips.textAlignment = NSTextAlignmentCenter;
    [bg_imgV addSubview:img_tips];
    [img_tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bg_imgV.mas_bottom).offset(-kWidth(44));
        make.left.and.right.equalTo(bg_imgV);
    }];
    
    //二维码图片
    UIImageView* erweima_img = [UIImageView new];
    NSString* str_url = [NSString stringWithFormat:@"http://younews.3gshow.cn/api/share?user_id=%@",[Login_info share].userInfo_model.user_id];
    [erweima_img setImage:[erWeiMa_Helper GetErWeiMa_string:str_url AndSize:kWidth(83)]];
    [bg_imgV addSubview:erweima_img];
    [erweima_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(img_tips.mas_top).offset(-kWidth(42));
        make.width.and.height.mas_offset(kWidth(83));
        make.centerX.equalTo(bg_imgV.mas_centerX);
    }];
    
    
    
    //加载头像
    if([Login_info share].userInfo_model.avatar.length > 0){
        [touxiang_imgV sd_setImageWithURL:[NSURL URLWithString:[Login_info share].userInfo_model.avatar] placeholderImage:[UIImage imageNamed:@"list_avatar"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(error){
                failed();
            }
            else{
                sucess();
            }
        }];
    }
    else{
        [touxiang_imgV sd_setImageWithURL:[NSURL URLWithString:[Login_info share].userInfo_model.wechat_icon] placeholderImage:[UIImage imageNamed:@"list_avatar"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(error){
                failed();
            }
            else{
                sucess();
            }
        }];
    }
}

@end
