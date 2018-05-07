//
//  DetailWeb_ViewController.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJZdataModel.h"
#import "RuleOfReading.h"

@interface DetailWeb_ViewController : UIViewController{
    Boolean isShoucang;
}

@property (nonnull,strong)CJZdataModel* CJZ_model;
@property (nonnull,strong)NSString* channel;

@property (nonatomic,strong)NSArray* _Nullable reply_array;

@property (nonatomic,strong)UIImageView* _Nullable shareImg;//用于分享时使用

@property (nonatomic)BOOL isFromHistory;

@end
