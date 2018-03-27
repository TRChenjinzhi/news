//
//  ThemeManager.h
//  机器人
//
//  Created by gyh on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#define Bundle_Of_ThemeResource @"ThemeResource"
#define Bundle_Path_Of_ThemeResource [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:Bundle_Of_ThemeResource]


#define Notice_Theme_Changed @"Notice_Theme_Changed"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ThemeManager : NSObject

@property(nonatomic,copy)NSString *themeName;
@property(nonatomic,copy)NSString *themePath;
@property(nonatomic,strong)UIColor *themeColor;
@property (nonatomic , strong) UIColor *oldColor;

@property (nonatomic,copy)NSString* state;


+ (ThemeManager*)sharedInstance;

-(void)changeThemeWithName:(NSString*)themeName;

- (UIImage*)themedImageWithName:(NSString*)imgName;

-(NSArray *)listOfAllTheme;

-(void)initState;

-(UIColor*)GetTitleColor;
-(UIColor*)GetSmallTextColor;

-(UIColor*)GetBackgroundColor;

-(UIColor*)GetDialogViewColor;//弹窗背景颜色

-(UIColor*)GetDialogTextColor;//弹窗文字颜色

//任务窗口
-(UIColor*)TaskGetTitleSmallLableColor;
-(UIColor*)TaskGetTitleBigLableColor;

-(UIColor*)TaskGetCellButtonColor;
-(UIColor*)TaskGetCellButtonTitleColor;
-(UIColor*)TaskGetCellMoneyColor;
-(UIColor*)TaskGetCellTitleColor;
-(UIColor*)TaskGetCellSubTitleColor;

-(UIColor*)TaskGetHeaderTitleColor;
-(UIColor*)TaskGetHeaderSubTitleVIewBackgroundColor;
-(UIColor*)TaskGetSubHeaderTitleColor;
-(UIColor*)TaskGetSubHeaderSubTitleColor;

//我的窗口
-(UIColor*)MineSmallTextColor;
-(UIColor*)MineCellLabelColor;

//我的窗口--消息窗口
-(UIColor*)MineMessageBackgroundColor;
-(UIColor*)MineMessageEmptyTextColor;

-(UIColor*)MineMessageCellTitleColor;
-(UIColor*)MineMessageCellSubTileColr;
-(UIColor*)MinemessageCellTimeColor;

//我的窗口--用户信息
-(UIColor*)MineUserInfoBackgroundColor;
-(UIColor*)MineUserInfoTitleColor;
-(UIColor*)MineUserInfoCellBackgroundColor;
-(UIColor*)MineUserInfoCellTitleColor;
-(UIColor*)MineUserInfoCellNameColor;

//我要提现
-(UIColor*)MineChangeToMoneyHeaderBackgroundColor;
-(UIColor*)MineChangeToMoneySubHeaderBackgroundColor;
-(UIColor*)MineChangeToMoneyLabelColor;
-(UIColor*)MineChangeToMoneyNumberColor;

//提现申请
-(UIColor*)Repply_ChangeToMoney_titleColor;
-(UIColor*)Repply_ChangeToMoney_subTitleColor;
-(UIColor*)Repply_ChangeToMoney_ModelBackgroundColor;

//我的徒弟
-(UIColor*)Mine_MyApprentice_backgroundColor;
-(UIColor*)Mine_MyApprentice_titleColor;
-(UIColor*)Mine_MyApprentice_stateColor;
-(UIColor*)Mine_MyApprentice_timeColor;

@end
