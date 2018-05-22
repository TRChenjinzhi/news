//
//  BadgeButton.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeButton : UIButton{
    
}

@property (nonatomic) NSInteger count;
@property (nonatomic,strong)UILabel* badgeLabel;
@property (nonatomic)BOOL isMessage;

-(void)showText;

@end
