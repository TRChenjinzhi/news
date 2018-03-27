//
//  TabbarView.h
//  新闻
//
//  Created by gyh on 15/9/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabbarView : UIView

@property (nonatomic , copy) void (^btnSelectBlock)(int to);

- (void)selectIndex:(int)index;
- (void)addTabBarButtonWithItem:(UITabBarItem *)item;
-(void)changeTitle:(NSInteger)index AndNewTitle:(NSString*)name;

@end
