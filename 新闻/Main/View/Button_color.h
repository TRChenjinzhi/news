//
//  Button_color.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Button_color : UIView

@property (nonatomic,strong)UILabel* title;
@property (nonatomic,strong)UITapGestureRecognizer* tap;

@property (nonatomic,strong)UIColor*   borderColor;
@property (nonatomic)CGFloat    cornerRadius;
@property (nonatomic)CGFloat    cornerWidth;

@property (nonatomic)BOOL       isSelected;

-(void)GetColorLayer:(CGRect)frame;
-(void)SetNormalButton:(NSString*)name;
-(void)SetSelectedButton:(NSString*)name;

-(void)ChangeToSelectedState;
@end
