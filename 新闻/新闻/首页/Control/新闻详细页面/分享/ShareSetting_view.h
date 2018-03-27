//
//  ShareSetting_view.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareSetting_view : UIView

@property (nonatomic,strong)UIView* dimView;

@property (nonatomic,strong)UIView* moveView;

@property (nonatomic)NSInteger moveView_hight;

-(void)Show;
-(void)Hide;

+(ShareSetting_view*)GetDialogView:(CGRect)frame withCusomView:(UIView*)cunstomView;

@end
