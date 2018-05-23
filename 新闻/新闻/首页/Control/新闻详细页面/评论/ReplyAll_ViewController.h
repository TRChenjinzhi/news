//
//  ReplyAll_ViewController.h
//  新闻
//
//  Created by chenjinzhi on 2018/5/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "reply_model.h"

@protocol ReplyAll_VCL_protocol
@optional
-(void)refreshCell:(reply_model*)model;
@end

@interface ReplyAll_ViewController : UIViewController

@property (nonatomic,weak)id delegate;
@property (nonatomic,strong)reply_model* model;
@property (nonatomic,strong)NSString* newsId;

@end

