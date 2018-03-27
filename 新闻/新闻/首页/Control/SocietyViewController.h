//
//  SocietyViewController.h
//  新闻
//
//  Created by gyh on 15/9/23.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"
#import "ChannelName.h"

@interface SocietyViewController : BaseViewController

@property (nonatomic,strong)NSString* channel_id;

@property (nonatomic)BOOL isNewChannel;//是否是新添加的频道
//搜索页面也使用这个视图
@property (nonatomic)BOOL isSearchVC;
@property (nonatomic,strong)NSString* keyWords;

@end
