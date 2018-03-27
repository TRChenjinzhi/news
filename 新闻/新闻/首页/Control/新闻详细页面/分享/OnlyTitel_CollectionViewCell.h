//
//  OnlyTitel_CollectionViewCell.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlyTitel_CollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)NSString* name;

@property (nonatomic,strong)UILabel* m_title;

@property (nonatomic)BOOL isSelected;//是否已选择

@end
