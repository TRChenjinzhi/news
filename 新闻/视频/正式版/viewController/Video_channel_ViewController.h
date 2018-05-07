//
//  Video_channel_ViewController.h
//  新闻
//
//  Created by chenjinzhi on 2018/3/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "video_channel_model.h"
#import "video_info_model.h"

@protocol video_channel_VCL_To_video_VCL
@optional
-(void)goToFullScreen:(video_info_model*)model;
-(void)video_channel_GoToDetail:(video_info_model*)model AndChannel:(video_channel_model*)channel_model;
-(void)shareMore:(video_info_model*)model;
@end

@interface Video_channel_ViewController : UIViewController

@property (nonatomic,strong)video_channel_model* model;

@property (nonatomic,weak)id delegate;

@property (nonatomic,strong)NSString* searchWord;
@property (nonatomic)BOOL isSearchVC;

@end
