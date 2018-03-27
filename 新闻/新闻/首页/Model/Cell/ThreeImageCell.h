//
//  ThreeImageCell.h
//  新闻
//
//  Created by chenjinzhi on 2017/12/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJZdataModel.h"

@protocol ThreeImage_DetailWeb_InterfaceDelegate <NSObject>
// 让协议方法带参传值
/**传递的值*/
- (void)ThreeImage_readHere_action;
@end

@interface ThreeImageCell : UITableViewCell{
    NSInteger space;
    NSInteger margin;
    NSInteger imgWidth;
    NSInteger imgHight;
    NSInteger titleToImg_space;
    NSInteger imgToLabel_space;
    
    NSInteger cellWidth;
    NSInteger cellHight;
}

@property (nonatomic,strong)CJZdataModel* model;

@property (nonatomic,strong)UILabel* title;

@property (nonatomic,strong)UILabel* resouce;

@property (nonatomic,strong)UILabel* time;

@property (nonatomic,strong)UILabel* lbReply;//回复数

@property (nonatomic,strong)UIImageView* imgReply;//回复图标

@property (nonatomic,strong)UIImageView* img1;
@property (nonatomic,strong)UIImageView* img2;
@property (nonatomic,strong)UIImageView* img3;

@property (nonatomic,strong)UIButton* NoInterest;//不感兴趣

@property (nonatomic,strong)UIButton* del;

@property (nonatomic,strong)UIView* line;

@property (nonatomic,strong)UIButton* delete_button;
@property (nonatomic)BOOL IsDelete;
@property (nonatomic)BOOL IsReading;//阅读后标题颜色变灰色
@property (nonatomic,strong)UIView* readingHere;//阅读到这里
@property (nonatomic,strong)UIButton* readingHere_btn;

@property (nonatomic)BOOL IsCollect;//是否是收藏cell
@property (nonatomic,strong)NSString* searchWord;//是否出入搜索状态

@property (nonatomic,strong)id delegate;

@property (nonatomic)NSInteger m_tag;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
