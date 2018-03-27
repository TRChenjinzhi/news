//
//  Channel_guanli_ViewController.h
//  新闻
//
//  Created by chenjinzhi on 2018/3/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Channel_guanli_SCNavTabBar_Delegate <NSObject>
// 让协议方法带参传值
/**传递的值*/
- (void)initNavi;
- (void)naviSelectedIndex:(NSInteger)index;
@end

@interface Channel_guanli_ViewController : UIViewController

@property (nonatomic,strong)id delegate;

@end
