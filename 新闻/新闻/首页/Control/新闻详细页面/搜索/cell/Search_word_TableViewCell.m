//
//  Search_word_TableViewCell.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Search_word_TableViewCell.h"

@implementation Search_word_TableViewCell{
    UILabel*        m_search_word;
    
}

+(instancetype)CellForTableView:(UITableView *)table{
    NSString* str_id = @"search_word_cell";
    Search_word_TableViewCell* cell = [table dequeueReusableCellWithIdentifier:str_id];
    if(!cell){
        cell = [[Search_word_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str_id];
    }
    return cell;
}

+(CGFloat)HightForCell{
    return 48.0;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    m_search_word = [[UILabel alloc] initWithFrame:CGRectMake(16, 17, 200, 21)];
    m_search_word.textColor = [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    m_search_word.textAlignment= NSTextAlignmentLeft;
    m_search_word.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:14];
    [self addSubview:m_search_word];
    
    _m_remove_word = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16-48, 0, 48, 48)];
    [_m_remove_word setImageEdgeInsets:UIEdgeInsetsMake(19, 19, 19, 19)];
    [_m_remove_word setImage:[UIImage imageNamed:@"ic_del"] forState:UIControlStateNormal];
    [_m_remove_word addTarget:self action:@selector(removeObject:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_m_remove_word];
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(16, 48-1, SCREEN_WIDTH-16-16, 1)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [self addSubview:line];
}

-(void)setWord:(NSString *)word{
    m_search_word.text = word;
}

#pragma mark 按钮方法
-(void)removeObject:(UIButton*)bt{
    NSLog(@"移除关键字");
    [self.delegate RemoveSearchWord:bt.tag];
}

@end
