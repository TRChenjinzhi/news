//
//  video_info_model.h
//  新闻
//
//  Created by chenjinzhi on 2018/3/28.
//  Copyright © 2018年 apple. All rights reserved.
//

/*
 "list": [{
 "id": "440",
 "channel": "23",
 "title": "戒烟老是半途而废？试试这个新方法，以后再也不想抽烟了",
 "cover": "http://publish-pic-cpu.baidu.com/dbf8e335-8ecd-4f0f-8f98-0674d3a5e6d6.jpeg@w_720,h_403",
 "url": "http://vd3.bdstatic.com/mda-ianyftfn5gdbktw9/mda-ianyftfn5gdbktw9.mp4?playlist=["hd ","sc "]",
 "source": "咕噜菇凉",
 "author": "咕噜菇凉",
 "duration": "70",
 "play_count": "36071",
 "time": "2018-01-28 12:45:59"
 }
 */

#import <Foundation/Foundation.h>

@interface video_info_model : NSObject

@property (nonatomic,strong)NSString* ID;
@property (nonatomic,strong)NSString* channel;
@property (nonatomic,strong)NSString* title;
@property (nonatomic,strong)NSString* avatar;
@property (nonatomic,strong)NSString* cover;
@property (nonatomic,strong)NSString* url;
@property (nonatomic,strong)NSString* source;
@property (nonatomic,strong)NSString* author;
@property (nonatomic,strong)NSString* duration;
@property (nonatomic,strong)NSString* play_count;
@property (nonatomic,strong)NSString* time;
@property (nonatomic,strong)NSString* readingTime;

@property (nonatomic)CGFloat video_playTime;//视频已播放时间
@property (nonatomic)BOOL isReading;
@property (nonatomic)BOOL isDragSlider;//是否拉动过slider

//阅读到这里
@property (nonatomic)BOOL isRreadHere;//是否添加 阅读到这里
@property (nonatomic,strong)NSString* getVideoTime;

+(NSArray*)dicToArray:(NSDictionary*)dic;

//CJZModel 和 video_info_model 混合解析
+(NSArray*)collectData_ToArray:(NSArray*)array;

+(NSMutableArray*)get50VideosFromArray:(NSMutableArray*)array;

@end
