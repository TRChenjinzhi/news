//
//  Mine_choujiang_ViewController.h
//  新闻
//
//  Created by chenjinzhi on 2018/4/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol choujiang_protocol
@optional
-(void)choujiang_result:(BOOL)isDone AndTaskId:(NSString*)taskId;
@end

@interface Mine_choujiang_ViewController : UIViewController

@property (nonatomic,weak)id delegate;

@end
