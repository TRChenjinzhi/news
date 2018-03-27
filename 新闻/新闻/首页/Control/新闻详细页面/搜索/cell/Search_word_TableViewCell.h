//
//  Search_word_TableViewCell.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol RemoveSearchWordDelegete

@optional
-(void)RemoveSearchWord:(NSInteger)index;

@end

@interface Search_word_TableViewCell : UITableViewCell

+(instancetype)CellForTableView:(UITableView*)table;
+(CGFloat)HightForCell;

@property (nonatomic,strong)NSString* word;
@property (nonatomic,strong)UIButton* m_remove_word;

@property (nonatomic,weak)id delegate;

@end
