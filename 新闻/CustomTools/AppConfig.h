//
//  AppConfig.h
//  新闻
//
//  Created by 范英强 on 16/9/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Login_info.h"
#import "Mine_zhifu_model.h"

@interface AppConfig : NSObject

+ (instancetype)sharedInstance;

+ (void)saveProAndCityInfoWithPro:(NSString *)pro city:(NSString *)city;
+ (NSString *)getProInfo;
+ (NSString *)getCityInfo;


-(void)saveChannelName_youLike:(NSArray*)json;
-(NSArray*)GetChannelNameYouLike;

-(void)saveUrlNews:(id)array;
-(id)getUrlNews;

-(void)saveUrlVideo:(NSDictionary*)str;
-(NSDictionary*)getUrlVideo;

-(void)saveSearchWord:(NSArray*)array AndType:(NSString*)type;
-(NSArray*)GetSearchWordAndType:(NSString*)type;
-(void)addSearchWord:(NSString*)searchWord AndType:(NSString*)type;
-(void)removeSearchWord:(NSString*)searchWord AndType:(NSString*)type;
-(void)removeSearchWordByIndex:(NSInteger)index AndType:(NSString*)type;
-(void)removeSearchWordAllAndType:(NSString*)type;

-(void)saveFontSize:(NSInteger)size;
-(NSInteger)GetFontSize;

-(void)saveUserInfo:(NSDictionary*)dic;
-(NSDictionary*)GetUserInfo;
-(void)clearUserInfo;
-(void)saveUserAcount:(NSString*)acount;
-(NSString*)getUserAcount;

-(void)saveTaskType:(NSInteger)type;
-(NSInteger)getTaskType:(NSInteger)type;

-(void)saveBoxTime:(NSInteger)int_time;
-(NSInteger)getBoxTime;

-(void)saveUserIcon:(UIImage*)img;
-(UIImage*)getUserIcon;

-(void)saveTheTime_lastRefresh:(NSString*)channel_id;
-(NSNumber*)getTheTime_lastRefresh:(NSString*)channel_id;

-(void)saveNews:(NSArray*)array channel_id:(NSString*)channel_id;
-(NSArray*)getNewsByChannel_id:(NSString*)channel_id;

-(void)saveChannel:(NSArray*)array;
-(NSArray*)getChannel;

-(void)saveDate:(NSString*)date;
-(NSString*)getDate;

-(void)saveMessageDate:(NSString*)date;
-(NSString*)getMessageDate;

-(void)saveRedPackage:(NSString*)date;
-(NSString*)getRedPackage;

-(void)saveUserId:(NSString*)userId;
-(NSString*)getUserId:(NSString*)userId;

-(void)saveIdifyCode:(NSNumber*)time;
-(NSNumber*)getIdefyCode;

-(void)saveVideo:(NSString*)channelId AndArray:(NSArray*)array;
-(NSArray*)getVideo:(NSString*)channelId;

-(void)saveNewUserTaskInfo;
-(void)getNewUserTaskInfo;
-(void)clearNewUserTaskInfo;

-(void)saveShowWinForFirstDone_newUserTask:(BOOL)isDone;
-(BOOL)getShowWinForFirstDone_newUserTask;

-(void)saveGuideOfNewUser:(BOOL)isGuide;
-(BOOL)getGuideOfNewUser;

-(void)saveZhifuInfo:(Mine_zhifu_model*)model;
-(NSDictionary*)getZhifuInfo;

-(void)saveChoujiangTips:(BOOL)isShow;
-(BOOL)getChoujiangTips_isShow;

@end
