//
//  MyWindows.h
//  新闻
//
//  Created by chenjinzhi on 2018/4/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    Type_TextField,
    Type_Choose
} Windows_Type;

@protocol MyWindos_protocol
@optional
-(void)returnString:(NSString*)str;
@end

@interface MyWindows : UIView

@property (nonatomic,strong)NSString* title;
@property (nonatomic,strong)NSArray* array_choose;//选择的选项
@property (nonatomic)Windows_Type type;
@property (nonatomic,weak)id delegate;

-(void)setCenterViewFrame:(CGFloat)height;

@end
