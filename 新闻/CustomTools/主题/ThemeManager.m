//
//  ThemeManager.m
//  机器人
//
//  Created by gyh on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager

static ThemeManager * defaultManager;
+(ThemeManager*)sharedInstance
{
    if(defaultManager == nil)
    {
        defaultManager = [[ThemeManager alloc] init];
        [defaultManager initTheme];
    }
    return defaultManager;
    
}

-(void)initTheme
{
    self.themeName = [self currentTheme];
    self.themePath = [Bundle_Path_Of_ThemeResource stringByAppendingPathComponent:self.themeName];
    self.themeColor = [UIColor colorWithPatternImage:[self themedImageWithName:@"navigationBar"]];
    self.oldColor = [UIColor whiteColor];
}

//当前的主题
-(NSString *)currentTheme{
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"theme"] == nil){
        [[NSUserDefaults standardUserDefaults]setObject:@"系统默认" forKey:@"theme"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        return @"系统默认";
    }else
    {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"theme"];
    }
}

//改变主题
-(void)changeThemeWithName:(NSString*)themeName
{
    [[NSUserDefaults standardUserDefaults]setObject:themeName forKey:@"theme"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self initTheme];
    [[NSNotificationCenter defaultCenter]postNotificationName:Notice_Theme_Changed object:nil];
}


//主题背景图片
- (UIImage*)themedImageWithName:(NSString*)imgName
{
    
    NSString *newImagePath = [self.themePath stringByAppendingPathComponent:imgName];
    return [UIImage imageWithContentsOfFile:newImagePath];
}


-(NSArray *)listOfAllTheme
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *listArray = [manager contentsOfDirectoryAtPath:Bundle_Path_Of_ThemeResource error:nil];
    return listArray;
}

-(void)initState{
    self.state = @"day";
}

-(UIColor*)GetTitleColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor blackColor];
    }
    else{
        return [UIColor whiteColor];
    }
}

-(UIColor*)GetSmallTextColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:122/255.0 green:125/255.0 blue:125/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor whiteColor];
    }
}

-(UIColor*)GetBackgroundColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor whiteColor];
    }
    else{
        return [UIColor blackColor];
    }
}

-(UIColor *)GetDialogViewColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor blackColor];
    }
}

-(UIColor *)GetDialogTextColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:122/255.0 green:125/255.0 blue:125/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor whiteColor];
    }
}

#pragma mark - 任务窗口
-(UIColor *)TaskGetTitleSmallLableColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor whiteColor];
    }
}

-(UIColor *)TaskGetTitleBigLableColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor whiteColor];
    }
    else{
        return [UIColor whiteColor];
    }
}

-(UIColor*)TaskGetCellButtonTitleColor{
    if([_state isEqualToString:@"day"]){
        return RGBA(255, 255, 255, 1);
    }
    else{
        return [UIColor whiteColor];
    }
}

-(UIColor*)TaskGetCellButtonColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:248/255.0 green:205/255.0 blue:4/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor whiteColor];
    }
}

-(UIColor *)TaskGetCellMoneyColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:251/255.0 green:84/255.0 blue:38/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor whiteColor];
    }
}

-(UIColor *)TaskGetCellTitleColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor whiteColor];
    }
}

-(UIColor *)TaskGetCellSubTitleColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:122/255.0 green:125/255.0 blue:125/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor whiteColor];
    }
}

-(UIColor*)TaskGetHeaderTitleColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:122/255.0 green:125/255.0 blue:125/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor whiteColor];
    }
}

-(UIColor *)TaskGetHeaderSubTitleVIewBackgroundColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor whiteColor];
    }
}

-(UIColor *)TaskGetSubHeaderTitleColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor whiteColor];
    }
}

-(UIColor *)TaskGetSubHeaderSubTitleColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:122/255.0 green:125/255.0 blue:125/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor whiteColor];
    }
}

#pragma mark - 我的窗口
-(UIColor*)MineSmallTextColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    }
}

-(UIColor *)MineCellLabelColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor whiteColor];
    }
}

#pragma mark - 我的窗口--消息窗口
-(UIColor *)MineMessageBackgroundColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor whiteColor];
    }
    else{
        return [UIColor whiteColor];
    }
}

-(UIColor *)MineMessageEmptyTextColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor whiteColor];
    }
}

-(UIColor *)MineMessageCellTitleColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor whiteColor];
    }
}

-(UIColor *)MineMessageCellSubTileColr{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:135/255.0 green:138/255.0 blue:138/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor whiteColor];
    }
}

-(UIColor *)MinemessageCellTimeColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:167/255.0 green:169/255.0 blue:169/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor whiteColor];
    }
}

#pragma mark - 用户信息
-(UIColor *)MineUserInfoTitleColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor whiteColor];
    }
}

-(UIColor *)MineUserInfoBackgroundColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor whiteColor];
    }
    else{
        return [UIColor whiteColor];
    }
}

-(UIColor *)MineUserInfoCellTitleColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor whiteColor];
    }
}

-(UIColor *)MineUserInfoCellNameColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:122/255.0 green:125/255.0 blue:125/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor whiteColor];
    }
}

-(UIColor *)MineUserInfoCellBackgroundColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor whiteColor];
    }
    else{
        return [UIColor whiteColor];
    }
}

#pragma mark - 我要提现
-(UIColor *)MineChangeToMoneyHeaderBackgroundColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:248/255.0 green:205/255.0 blue:4/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor colorWithRed:248/255.0 green:205/255.0 blue:4/255.0 alpha:1/1.0];
    }
}

-(UIColor *)MineChangeToMoneySubHeaderBackgroundColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:0.08/1.0];
    }
    else{
        return [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:0.08/1.0];
    }
}

-(UIColor *)MineChangeToMoneyLabelColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:0.5/1.0];
    }
    else{
        return [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:0.5/1.0];
    }
}

-(UIColor *)MineChangeToMoneyNumberColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    }
}

#pragma mark - 申请提现
-(UIColor *)Repply_ChangeToMoney_titleColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor whiteColor];
    }
}
-(UIColor *)Repply_ChangeToMoney_subTitleColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor whiteColor];
    }
}
-(UIColor *)Repply_ChangeToMoney_ModelBackgroundColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor whiteColor];
    }
    else{
        return [UIColor blackColor];
    }
}

#pragma mark -  我的徒弟
-(UIColor *)Mine_MyApprentice_backgroundColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor whiteColor];
    }
    else{
        return [UIColor blackColor];
    }
}

-(UIColor *)Mine_MyApprentice_titleColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor whiteColor];
    }
}

-(UIColor *)Mine_MyApprentice_stateColor{
    if([_state isEqualToString:@"day"]){
        return RGBA(251, 84, 28, 1);
    }
    else{
        return [UIColor whiteColor];
    }
}

-(UIColor *)Mine_MyApprentice_timeColor{
    if([_state isEqualToString:@"day"]){
        return [UIColor colorWithRed:135/255.0 green:138/255.0 blue:138/255.0 alpha:1/1.0];
    }
    else{
        return [UIColor whiteColor];
    }
}


@end
