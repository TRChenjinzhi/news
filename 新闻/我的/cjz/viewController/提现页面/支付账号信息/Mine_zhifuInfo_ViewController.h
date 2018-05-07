//
//  Mine_zhifuInfo_ViewController.h
//  新闻
//
//  Created by chenjinzhi on 2018/4/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Mine_zhifuInfoVCL_protocol
@optional
-(void)refresh_zhifuInfo;
@end

@interface Mine_zhifuInfo_ViewController : UIViewController

@property (nonatomic)zhifu_Type type;
@property (nonatomic,weak)id delegate;

@end
