//
//  Color-Image-Helper.h
//  新闻
//
//  Created by chenjinzhi on 2018/5/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Color_Image_Helper : NSObject

+ (UIImage*) createImageWithColor: (UIColor*) color;
+(UIColor*)ImageChangeToColor:(UIImage*)img AndNewSize:(CGSize)size;
+(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize;

@end
