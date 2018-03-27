//
//  LabelHelper.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LabelHelper : NSObject

+(CGFloat)GetLabelWidth:(UIFont*)font AndText:(NSString*)text;
+(CGFloat)GetLabelHight:(UIFont *)font AndText:(NSString *)text AndWidth:(CGFloat)width;

+(NSMutableAttributedString*)GetMutableAttributedSting_bold_font:(NSMutableAttributedString*)text AndIndex:(NSInteger)index AndCount:(NSInteger)count AndFontSize:(NSInteger)fontSize;
+(NSMutableAttributedString*)GetMutableAttributedSting_font:(NSMutableAttributedString*)text AndIndex:(NSInteger)index AndCount:(NSInteger)count AndFontSize:(NSInteger)fontSize;
+(NSMutableAttributedString*)GetMutableAttributedSting_color:(NSMutableAttributedString*)text AndIndex:(NSInteger)index AndCount:(NSInteger)count AndColor:(UIColor*)color;
+(NSMutableAttributedString*)GetMutableAttributedSting_lineSpaceing:(NSMutableAttributedString*)text AndSpaceing:(CGFloat)lineSpaceing;
+(NSMutableAttributedString*)GetMutableAttributedSting_wordSpaceing:(NSMutableAttributedString*)text AndSpaceing:(CGFloat)wordSpaceing;

@end

