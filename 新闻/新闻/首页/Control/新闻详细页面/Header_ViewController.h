//
//  Header_ViewController.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJZdataModel.h"
#import "NoImageCell.h"
#import "OneImageCell.h"
#import "ThreeImageCell.h"
#import "DetailWeb_ViewController.h"

@protocol ClickWebImageInterfaceDelegate <NSObject>
// 让协议方法带参传值
/**传递的值*/
- (void)showWebImages:(NSArray*)array AndIndex:(NSInteger)index;
- (void)setHeaderFrame;
- (void)webViewDidLoad:(NSString*)text;
- (void)webViewLoadFailed;
- (void)showGuangGao:(NSURLRequest*)request;
@end

@interface Header_ViewController : UIViewController

@property (nonatomic,weak)id delegate;

@property (nonatomic,strong)NSString* url;
@property (nonatomic,strong)WKWebView* webview;
@property (nonatomic,strong)UIView* footView;
@property (nonatomic,strong)CJZdataModel* model;
@property (nonatomic,strong)DetailWeb_ViewController* self_parent;//父界面的self
@property (nonatomic,strong)NSMutableArray* mUrlArray;

@property (nonatomic, strong) UIProgressView *progressView;//网页进度条

-(CGSize)getSize;

@property (nonatomic)NSInteger fontState;
@property (nonatomic)NSInteger font;

@end
