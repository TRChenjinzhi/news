//
//  LabelHelper.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LabelHelper.h"

@implementation LabelHelper

+(CGFloat)GetLabelWidth:(UIFont *)font AndText:(NSString *)text{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = text;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}

+(CGFloat)GetLabelHight:(UIFont *)font AndText:(NSString *)text AndWidth:(CGFloat)width{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    
    label.text = text;
    label.font = font;
    label.numberOfLines = 0;
    
    [label sizeToFit];
    return label.frame.size.height;
}

+(NSMutableAttributedString*)GetMutableAttributedSting_bold_font:(NSMutableAttributedString*)text AndIndex:(NSInteger)index AndCount:(NSInteger)count AndFontSize:(NSInteger)fontSize{
    
    [text addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:fontSize] range:NSMakeRange(index,count)];
    return text;
}

+(NSMutableAttributedString*)GetMutableAttributedSting_font:(NSMutableAttributedString*)text AndIndex:(NSInteger)index AndCount:(NSInteger)count AndFontSize:(NSInteger)fontSize{
    
    [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:fontSize] range:NSMakeRange(index,count)];
    return text;
}

+(NSMutableAttributedString*)GetMutableAttributedSting_color:(NSMutableAttributedString*)text AndIndex:(NSInteger)index AndCount:(NSInteger)count AndColor:(UIColor*)color{
    [text addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(index,count)];
    return text;
}

+(NSMutableAttributedString*)GetMutableAttributedSting_lineSpaceing:(NSMutableAttributedString*)text AndSpaceing:(CGFloat)lineSpaceing{
    //设置缩进、行距
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpaceing;//行距
    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    return text;
}

+(NSMutableAttributedString*)GetMutableAttributedSting_wordSpaceing:(NSMutableAttributedString*)text AndSpaceing:(CGFloat)wordSpaceing{
    NSNumber* number = [NSNumber numberWithFloat:wordSpaceing];
    NSDictionary *dic = @{NSKernAttributeName:number};
    [text addAttributes:dic range:NSMakeRange(0, text.length)];
    return text;
}



@end
