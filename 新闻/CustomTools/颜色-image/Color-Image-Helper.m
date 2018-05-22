//
//  Color-Image-Helper.m
//  新闻
//
//  Created by chenjinzhi on 2018/5/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Color-Image-Helper.h"

@implementation Color_Image_Helper
+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(UIColor*)ImageChangeToColor:(UIImage*)img AndNewSize:(CGSize)size{
    UIImage* newImg = [self imageResize:img andResizeTo:size];
    return [UIColor colorWithPatternImage:newImg];
}

+(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen]scale];
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
