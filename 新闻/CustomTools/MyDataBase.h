//
//  MyDataBase.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "FMDatabase.h"
#import "CJZdataModel.h"
#import "ChannelName.h"

@interface MyDataBase : NSObject

+(instancetype)shareManager;
-(void)initialization;

//点赞表
-(void)CreateDianZanTabel;
-(void)DianZan_insertData:(NSInteger)reply_id AndIsDIanZan:(NSInteger)IsDianZan;
-(void)DianZan_SelectData:(NSInteger)reply_id;
-(void)DianZan_UpData:(NSInteger)reply_id AndIsDIanZan:(NSInteger)IsDianZan;
-(BOOL)DianZan_IsHaveId:(NSInteger)reply_id;
-(BOOL)DianZan_IsDianZan:(NSInteger)reply_id;
-(void)clearTable_DianZan;

//收藏表
-(void)CreateCollectTabel;
-(void)Collect_insertData:(NSInteger)news_id AndIsDIanZan:(NSInteger)isCollected AndTime:(NSString*)time;
-(void)Collect_SelectData:(NSInteger)news_id;
-(NSString*)Collect_GetTime:(NSInteger)news_id;
-(void)Collect_UpData:(NSInteger)news_id AndIsDIanZan:(NSInteger)IsCollected;
-(BOOL)Collect_IsHaveId:(NSInteger)news_id;
-(BOOL)Collect_IsCollected:(NSInteger)news_id;
-(void)clearTable_Collect;

//浏览记录表  1.存储model数据 2.不能超过100条
-(void)CreateReadingNewsTabel;
-(void)AddReadingNews:(CJZdataModel*)model;
-(NSArray*)ReadingNews_GetLastMaxCountData;
-(void)clearTable_ReadingNews;

//已经获得阅读奖励表
-(void)CreateIsGetIncomeNews_table;
-(void)AddGetIncomeNews:(NSString*)newId;
-(BOOL)IsGetIncomeNews:(NSString*)newId;
-(void)clearTable_GetIncomeNews;

//添加频道
-(void)createChannelTable;
-(void)ChannelTable_insetData:(ChannelName*)channelName;
-(void)ChannelTable_upData:(ChannelName*)channelName;
-(void)ChannelTable_SelecteData:(ChannelName*)channelName;
-(BOOL)ChannelTable_IsHaveTitle:(NSString*)title;
-(void)clearTable_Channel;
@end
