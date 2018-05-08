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
    NSInteger   time_count;
}

-(BOOL)AddReadingCountType:(NSInteger)type
                 AndTaskId:(NSString*)taskId
                 AndNewsId:(NSString*)newsId
             AndScrollview:(UIScrollView*)scrollview
              AndTableview:(UITableView*)tableview
             AndHeaderSize:(CGSize)headerSize
              AndIsReadAll:(BOOL)isReadAll
            AndScrollCount:(NSInteger)count{
    if(isOver){
        return NO;
    }
    
    
            //判断阅读时间
            if(self.timer == nil){
                time_count = 0;
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(repeatShowTime) userInfo:nil repeats:YES];
            }
            else{
                NSLog(@"time_count-->%ld",time_count);
                if(time_count >= 2 + (headerSize.height/SCREEN_HEIGHT)){
                    if(scrollview.contentOffset.y + tableview.frame.size.height + 10 > headerSize.height){
                        if(count >= 5){ //滑动5次
                            if(isReadAll){ //点击全文阅读
                                isOver = YES;
                                [Task_DetailWeb_model share].isOver = YES;
                                [self.timer invalidate];
                                return YES;
                            }
                        }
                        
                    }
                }
            }
    
    
    if(count<7 && count >= 0){
        count++;
    }
            
        
    
    return NO;
}

-(void)repeatShowTime{
    time_count++;
}

@end
