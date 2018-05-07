//
//  Video_detail_ViewController.h
//  新闻
//
//  Created by chenjinzhi on 2018/4/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "video_info_model.h"
#import "video_channel_model.h"

@interface Video_detail_ViewController : UIViewController

@property (nonatomic,strong)video_info_model* _Nonnull model;

@property (nonatomic,strong)NSArray* _Nullable reply_array;
@property (nonatomic)BOOL isFromHistory;//是否在浏览记录

@end
