//
//  DayDayTask_signIn_gold.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DayDayTask_signIn_gold.h" //签到获得金币 的模版

@implementation DayDayTask_signIn_gold

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setModel:(DayDayTask_sign_gold_model *)model{
    
    NSInteger imgWidth = 32;
    CGFloat lineWidth = (SCREEN_WIDTH-16-16-7*imgWidth)/12;//12:6*2
    
    if(model.IsRedPackage){
        //左边横线
        UIView* leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 20, lineWidth, 2)];
        //红包
        UIImageView* redPackage_img = [[UIImageView alloc] initWithFrame:CGRectMake(lineWidth-3, 0, imgWidth+3, 42)];
        //金币数量
        UILabel* goldNumber = [[UILabel alloc] initWithFrame:CGRectMake(4, 23, 24, 14)];
        goldNumber.text = [NSString stringWithFormat:@"+%ld",model.numberOfGold];
        NSLog(@"goldNumber --> %ld",model.numberOfGold);
        goldNumber.font = [UIFont systemFontOfSize:10];
        
        if(model.IsToday){
            leftLine.backgroundColor = [UIColor colorWithRed:255/255.0 green:129/255.0 blue:3/255.0 alpha:1/1.0];
            [redPackage_img setImage:[UIImage imageNamed:@"task_seven_checked"]];
            goldNumber.textColor = [UIColor whiteColor];
        }else{
            leftLine.backgroundColor = [UIColor colorWithRed:255/255.0 green:192/255.0 blue:129/255.0 alpha:1/1.0];
            [redPackage_img setImage:[UIImage imageNamed:@"task_seven"]];
            goldNumber.textColor = [UIColor colorWithRed:254/255.0 green:234/255.0 blue:190/255.0 alpha:1/1.0];
        }
        
        [self addSubview:redPackage_img];
        [self addSubview:leftLine];
//        [self addSubview:goldNumber];//图片上有数字
    }
    else{
        if(model.HaveLeftLine){
            //左边横线
            UIView* leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 20, lineWidth, 2)];
            if(model.IsToday){
                leftLine.backgroundColor = [UIColor colorWithRed:255/255.0 green:129/255.0 blue:3/255.0 alpha:1/1.0];
            }else{
                leftLine.backgroundColor = [UIColor colorWithRed:255/255.0 green:192/255.0 blue:129/255.0 alpha:1/1.0];
            }
            [self addSubview:leftLine];
        }
        
        if(model.HaveRightLine){
            //右边横线
            UIView* rightLine = [[UIView alloc] initWithFrame:CGRectMake(lineWidth+imgWidth, 20, lineWidth, 2)];
            if(model.IsToday){
                rightLine.backgroundColor = [UIColor colorWithRed:255/255.0 green:129/255.0 blue:3/255.0 alpha:1/1.0];
            }else{
                rightLine.backgroundColor = [UIColor colorWithRed:255/255.0 green:192/255.0 blue:129/255.0 alpha:1/1.0];
            }
            [self addSubview:rightLine];
        }
        
        //红包
        UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(lineWidth, 5, imgWidth, 32)];
        //金币数量
        UILabel* goldNumber = [[UILabel alloc] initWithFrame:CGRectMake(lineWidth+4, 14, 24, 14)];
        goldNumber.text = [NSString stringWithFormat:@"+%ld",model.numberOfGold];
        goldNumber.font = [UIFont systemFontOfSize:11];
        
        if(model.IsToday){
            [img setImage:[UIImage imageNamed:@"task_checked"]];
            goldNumber.textColor = [UIColor colorWithRed:255/255.0 green:129/255.0 blue:3/255.0 alpha:1/1.0];
        }else{
            [img setImage:[UIImage imageNamed:@"task_check"]];
            goldNumber.textColor = [UIColor colorWithRed:255/255.0 green:192/255.0 blue:129/255.0 alpha:1/1.0];
        }
        
        [self addSubview:img];
        [self addSubview:goldNumber];
    }
    
    //天数
    UILabel* DayCount = [[UILabel alloc] initWithFrame:CGRectMake(16+1, self.frame.size.height-28, 16, 10)];
    DayCount.text = [NSString stringWithFormat:@"%ld天",model.daysCount];
    DayCount.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:10];
    
    if(model.IsToday){
        DayCount.textColor = [UIColor colorWithRed:255/255.0 green:129/255.0 blue:3/255.0 alpha:1/1.0];
    }else{
        DayCount.textColor = [UIColor colorWithRed:255/255.0 green:192/255.0 blue:129/255.0 alpha:1/1.0];
    }
    [self addSubview:DayCount];
}

@end
