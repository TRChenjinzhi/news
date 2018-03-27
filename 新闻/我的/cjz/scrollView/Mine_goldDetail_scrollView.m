//
//  Mine_goldDetail_scrollView.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_goldDetail_scrollView.h"
#import "Mine_goldDetail_TableViewController.h"

@implementation Mine_goldDetail_scrollView{
    Mine_goldDetail_TableViewController* m_gold_tableview;
    Mine_goldDetail_TableViewController* m_package_tableview;
    
    NSArray*        gold_array_array_model;
    NSArray*        m_section_array;
    Money_model*    m_money_model;
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
        [self initView];
    }
    return self;
}
-(void)initView{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    self.pagingEnabled = YES;
    self.contentInset = UIEdgeInsetsZero;
    NSLog(@"inset y:%f",self.contentInset.top);
//    self.backgroundColor = [UIColor greenColor];
    self.contentSize = CGSizeMake(2*SCREEN_WIDTH, self.frame.size.height);
//    self.contentSize = CGSizeMake(2*SCREEN_WIDTH, 0);
    
    UIView* gold_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height-300)];
    Mine_goldDetail_TableViewController* gold_tableview = [[Mine_goldDetail_TableViewController alloc] init];
    gold_tableview.tableName = @"金币";
    gold_tableview.array_cells = gold_array_array_model;
    m_gold_tableview = gold_tableview;
    [gold_view addSubview:m_gold_tableview.tableView];
    [self addSubview:gold_view];
    
    UIView* package_view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.frame.size.height-300)];
    Mine_goldDetail_TableViewController* package_tableview = [[Mine_goldDetail_TableViewController alloc] init];
    package_tableview.tableName = @"钱包";
    package_tableview.array_cells = gold_array_array_model;

    m_package_tableview = package_tableview;
    [package_view addSubview:package_tableview.tableView];
    [self addSubview:package_view];
}

-(void)setMoney_model:(Money_model *)money_model{
    m_money_model = money_model;
}

-(void)setArray_array_money_model:(NSArray *)array_array_money_model{
    gold_array_array_model = array_array_money_model;
    m_gold_tableview.array_cells = array_array_money_model;
    m_package_tableview.array_cells = array_array_money_model;
}

-(void)setSelectIndex:(NSInteger)selectIndex{
    if(selectIndex == 1){
        [self setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    }
}




@end
