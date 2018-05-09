//
//  SectionHeader_ViewController.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/31.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJZdataModel.h"
#import "NoImageCell.h"
#import "OneImageCell.h"
#import "ThreeImageCell.h"
#import "DetailWeb_ViewController.h"

@protocol SectionHeader_DetailWeb_InterfaceDelegate <NSObject>
// 让协议方法带参传值
/**传递的值*/
- (void)initSectionFrame:(CGFloat)height;
- (void)showNews:(CJZdataModel*)model;
@end

@interface SectionHeader_ViewController : UIViewController

@property (nonatomic,strong)id delegate;
@property (nonatomic,strong)CJZdataModel* model;
@property (nonatomic,strong)NSString* channel_id;
@property (nonatomic,strong)UIView* m_ReadingWithOther_view;

-(void)GetDataWithReadingOther;

@end
