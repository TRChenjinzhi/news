//
//  RuleOfReading.m
//  新闻
//
//  Created by chenjinzhi on 2018/2/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RuleOfReading.h"

@implementation RuleOfReading{
    BOOL        isOver;
}

-(void)AddReadingCountType:(NSInteger)type AndTaskId:(NSString*)taskId AndNewsId:(NSString*)newsId AndScrollview:(UIScrollView*)scrollview AndTableview:(UITableView*)tableview AndHeaderSize:(CGSize)headerSize  AndIsReadAll:(BOOL)isReadAll AndScrollCount:(NSInteger)count{
    if(isOver){
        return;
    }
    if(count >= 5){ //滑动5次
        if(isReadAll){ //点击全文阅读
            if(scrollview.contentOffset.y + tableview.frame.size.height + 10 > headerSize.height){
                [InternetHelp SendTaskId:taskId AndType:type];
                [[MyDataBase shareManager] AddGetIncomeNews:newsId];
                isOver = YES;
                [Task_DetailWeb_model share].isOver = YES;
            }
        }
    }
    if(count<7 && count >= 0){
        count++;
    }
}

@end
