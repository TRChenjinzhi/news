//
//  TaskCellHeaderTitleView.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TaskCellHeaderTitleView.h"
#import "DayDayTask_signIn_gold.h"
#import "DayDayTask_sign_gold_model.h"

@implementation TaskCellHeaderTitleView{
    UIView* m_markLine;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self InitView];
    }
    return self;
}

-(void)InitView{
    UIView* markLine = [[UIView alloc] initWithFrame:CGRectMake(16, 20, 4, 20)];
    markLine.backgroundColor = [UIColor colorWithRed:248/255.0 green:205/255.0 blue:4/255.0 alpha:1/1.0];
    [self addSubview:markLine];
    m_markLine = markLine;
}

-(void)setTitle:(NSString *)title{
    
    UILabel* headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(m_markLine.frame)+8, 21, 80, 18)];
    headerTitle.text = title;
    headerTitle.textColor = [[ThemeManager sharedInstance] TaskGetHeaderTitleColor];
    headerTitle.font = [UIFont systemFontOfSize:18];
    [self addSubview:headerTitle];
    
}

-(void)setSubHeaderVIew_model:(TaskCellHeader_model *)subHeaderVIew_model{
    
    //subview title
    UIView* subTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 48, SCREEN_WIDTH, 66)];
    subTitleView.backgroundColor = [[ThemeManager sharedInstance] TaskGetHeaderSubTitleVIewBackgroundColor];
    
    UILabel* Title = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 109, 18)];
    Title.text = subHeaderVIew_model.title;
    Title.textColor = [[ThemeManager sharedInstance] TaskGetSubHeaderTitleColor];
    Title.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:18];
    [subTitleView addSubview:Title];
    
    UILabel* subTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(Title.frame)+6, 110, 10)];
    subTitle.text = subHeaderVIew_model.subTitle;
    subTitle.textColor = [[ThemeManager sharedInstance] TaskGetSubHeaderSubTitleColor];
    subTitle.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:10];
    [subTitleView addSubview:subTitle];
    
    [self addSubview:subTitleView];
    
    //subview
    UIView* subHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 114, SCREEN_WIDTH, 74)];
    
    for(int i=0;i<7;i++){
        DayDayTask_sign_gold_model* model = [[DayDayTask_sign_gold_model alloc] init];
        if(i <= subHeaderVIew_model.DaysOfSignIn-1){
            model.HaveLeftLine = YES;
            model.HaveRightLine = YES;
            model.IsRedPackage = NO;
            model.IsToday = YES;
            model.numberOfGold = 10+i*5;
            model.daysCount = i+1;
            if(i==0){
                model.HaveLeftLine = NO;
            }
            if(i==6){
                model.HaveRightLine = NO;
                model.HaveLeftLine = YES;
                model.IsRedPackage = NO;//最后一个是否是红包： 本来是红包，现在不要红包
                model.numberOfGold = 40;
            }
        }else{//没有登陆的状态
            model.HaveRightLine = YES;
            model.HaveLeftLine = YES;
            model.IsRedPackage = NO;
            model.IsToday = NO;
            model.numberOfGold = 10+i*5;
            model.daysCount = i+1;
            if(i==0){
                model.HaveLeftLine = NO;
            }
            if(i==6){
                model.HaveRightLine = NO;
                model.HaveLeftLine = YES;
                model.IsRedPackage = NO;//最后一个是否是红包： 本来是红包，现在不要红包
                model.numberOfGold = 40;//最优金额本来90，改为40
            }
        }

        CGFloat lineWidth = (SCREEN_WIDTH-16-16-7*32)/12;//12:6*2
        DayDayTask_signIn_gold* item = [[DayDayTask_signIn_gold alloc] initWithFrame:CGRectMake(16+i*(32+2*lineWidth)-lineWidth, 0, 32+2*lineWidth, 74)];
        item.model = model;
        [subHeaderView addSubview:item];
    }
    
    [self addSubview:subHeaderView];
    
    //line
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(kWidth(16), self.frame.size.height-1, SCREEN_WIDTH-kWidth(16)-kWidth(16), 1)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [self addSubview:line];
    
}

@end
