//
//  TabbarViewController.h
//  新闻
//
//  Created by gyh on 15/9/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabbarViewController : UITabBarController

@property (nonatomic,strong)NSArray* array_model;
- (void)selectIndex:(int)index;
@end
