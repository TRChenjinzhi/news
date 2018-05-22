//
//  Header_view.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BadgeButton.h"
#import "Mine_userInfo_model.h"

@interface Header_view : UIView

@property (nonatomic)BOOL IsLognin;//是否已登陆

@property (nonatomic)NSInteger number_gold;//金币数量
@property (nonatomic)CGFloat number_package;//钱包金额
@property (nonatomic)NSInteger number_apprentice;//徒弟数量

@property (nonatomic,strong)BadgeButton* messageButton;

@property (nonatomic,strong)Mine_userInfo_model* userInfo_model;

@property (nonatomic,strong)UIView* loginToDetailLogin;//登陆点击层
@property (nonatomic,strong)UIView* gold_click_view;//金币点击层
@property (nonatomic,strong)UIView* package_click_view;//钱包点击层
@property (nonatomic,strong)UIView* apprentice_click_view;//收徒点击层

@property (nonatomic,strong)BannerView* bannerView;

@property (nonatomic,strong)UIImageView*            m_guanggao_img;
@property (nonatomic,strong)UIView*                 m_guanggao_clickView;
@property (nonatomic,strong)UITapGestureRecognizer* m_tap_gold;
@property (nonatomic,strong)UITapGestureRecognizer* m_tap_moneyPackage;
@property (nonatomic,strong)UITapGestureRecognizer* m_tap_apprentice;
@property (nonatomic,strong)UITapGestureRecognizer* m_tap_guanggao;

-(void)bannerView_bengain;

@end
