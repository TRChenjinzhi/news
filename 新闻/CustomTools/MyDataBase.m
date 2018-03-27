//
//  MyDataBase.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyDataBase.h"

#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__); abort(); } }
#define DBname @"/QUDU.db"
#define ReadingNews @"ReadingNews"
#define ReadingNewsMaxCount 5
#define GetIncomeNews @"GetIncomeNews"
#define ChannelTable @"ChannelTable"
//SqliteManager
@implementation MyDataBase{
    FMDatabase*  database;
}

static id shareManager;
+(instancetype)shareManager{
    
    if(shareManager==nil) {
        
        shareManager = [[MyDataBase alloc]init];
    }
    
    return shareManager;
    
}
//初始化
-(void)initialization{
    [self openDb:DBname];
    [self CreateDianZanTabel];//点赞表
    [self CreateCollectTabel];//收藏表
    [self CreateReadingNewsTabel];//浏览记录表
    [self CreateIsGetIncomeNews_table];//阅读奖励表
}

-(void)openDb:(NSString*)daname{
    
    //先取得数据库的路径
    
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    
    NSString* databasePath = [path stringByAppendingString:daname];
    
    database = [FMDatabase databaseWithPath:databasePath];
    
    //再打开或者创建打开数据库
    [database open];
    if(![database open]) {
        NSLog(@"数据库打开失败");
    }
    
    else{
        
        NSLog(@"数据库打开成功");
        
    }
    
}
#pragma mark - 点赞表
//创建点赞表
-(void)CreateDianZanTabel{
    NSString* str_common = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT,replyId integer NOT NULL,IsDianZan integer NOT NULL)",@"DianZan"];
    
    if([database executeUpdate:str_common]){
        NSLog(@"点赞表 创建成功");
    }else{
        NSLog(@"点赞表 创建失败");
    }
}

-(void)DianZan_insertData:(NSInteger)reply_id AndIsDIanZan:(NSInteger)IsDianZan{
    [database beginTransaction];
    NSString* str_common = [NSString stringWithFormat:@"insert into %@ (replyId, IsDianZan) values (%ld, %ld)" ,@"DianZan",reply_id,IsDianZan];
    if([database executeUpdate:str_common]){
        NSLog(@"点赞表插入成功");
    }else{
        NSLog(@"点赞表插入失败");
    }
    [database commit];
}

-(void)DianZan_SelectData:(NSInteger)reply_id{
    NSString* str_common = [NSString stringWithFormat:@"select * from DianZan where replyId = %ld",reply_id];
    FMResultSet *rs = [database executeQuery:str_common];
    while ([rs next]) {
        // just print out what we've got in a number of formats.
        NSLog(@"-->replyId:%d ,IsDianZan:%d",
              [rs intForColumn:@"replyId"],
              [rs intForColumn:@"IsDianZan"]);
    }

    [rs close];
}

//修改表
-(void)DianZan_UpData:(NSInteger)reply_id AndIsDIanZan:(NSInteger)IsDianZan{
    [database beginTransaction];
    NSString* str_common = [NSString stringWithFormat:@"UPDATE %@ set IsDianZan=%ld where replyId=%ld" ,@"DianZan",IsDianZan,reply_id];
    if([database executeUpdate:str_common]){
        NSLog(@"点赞表修改成功");
    }else{
        NSLog(@"点赞表修改失败");
    }
    [database commit];
}

-(BOOL)DianZan_IsHaveId:(NSInteger)reply_id{
    //    if exists( select * from Hong_PageConfig where names='name' )
    NSString* str_common = [NSString stringWithFormat:@"select * from DianZan where replyId='%ld'",reply_id];
    NSInteger m_id = -1;
    FMResultSet *rs = [database executeQuery:str_common];
    while ([rs next]) {
        m_id = [rs intForColumn:@"IsDianZan"];
    }
    [rs close];
    if(m_id == -1){
        return NO;
    }
    return YES;
}

-(BOOL)DianZan_IsDianZan:(NSInteger)reply_id{
    if([self DianZan_IsHaveId:reply_id]){
        NSString* str_common = [NSString stringWithFormat:@"select * from DianZan where replyId='%ld'",reply_id];
        NSInteger m_id = -1;
        FMResultSet *rs = [database executeQuery:str_common];
        while ([rs next]) {
            m_id = [rs intForColumn:@"IsDianZan"];
        }
        if(m_id == 1){
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

-(void)clearTable_DianZan{
    [database beginTransaction];
    NSString* str_common = [NSString stringWithFormat:@"DELETE from %@" ,@"DianZan"];
    if([database executeUpdate:str_common]){
        NSLog(@"点赞表删除成功");
    }else{
        NSLog(@"点赞表删除失败");
    }
    [database commit];
}

#pragma mark - 收藏表
//创建点赞表
-(void)CreateCollectTabel{
    NSString* str_common = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT,newsId integer NOT NULL,IsCollected integer NOT NULL,time text NOT NULL)",@"Collect"];
    
    if([database executeUpdate:str_common]){
        NSLog(@"收藏表 创建成功");
    }else{
        NSLog(@"收藏表 创建失败");
    }
}

-(void)Collect_insertData:(NSInteger)news_id AndIsDIanZan:(NSInteger)isCollected AndTime:(NSString*)time{
    [database beginTransaction];
    NSString* str_common = [NSString stringWithFormat:@"insert into %@ (newsId,IsCollected,time) values (%ld,%ld,'%@')" ,@"Collect",news_id,isCollected,time];
    if([database executeUpdate:str_common]){
        NSLog(@"收藏表插入成功");
    }else{
        NSLog(@"收藏表插入失败");
    }
    [database commit];
}

-(void)Collect_SelectData:(NSInteger)news_id{
    NSString* str_common = [NSString stringWithFormat:@"select * from Collect where newsId = %ld",news_id];
    FMResultSet *rs = [database executeQuery:str_common];
    while ([rs next]) {
        // just print out what we've got in a number of formats.
        NSLog(@"-->news_id:%d ,IsCollected:%d ,time:%@",
              [rs intForColumn:@"newsId"],
              [rs intForColumn:@"IsCollected"],
              [rs stringForColumn:@"time"]);
    }
    
    [rs close];
}

-(NSString*)Collect_GetTime:(NSInteger)news_id{
    NSString* str_common = [NSString stringWithFormat:@"select * from Collect where newsId = %ld",news_id];
    NSString* time = @"";
    FMResultSet *rs = [database executeQuery:str_common];
    while ([rs next]) {
        // just print out what we've got in a number of formats.
        NSLog(@"-->news_id:%d ,IsCollected:%d ,time:%@",
              [rs intForColumn:@"newsId"],
              [rs intForColumn:@"IsCollected"],
              [rs stringForColumn:@"time"]);
        time = [rs stringForColumn:@"time"];
    }
    
    [rs close];
    return time;
}

//修改表
-(void)Collect_UpData:(NSInteger)news_id AndIsDIanZan:(NSInteger)IsCollected{
    [database beginTransaction];
    NSString* str_common = [NSString stringWithFormat:@"UPDATE %@ set IsCollected=%ld where newsId=%ld" ,@"Collect",IsCollected,news_id];
    if([database executeUpdate:str_common]){
        NSLog(@"收藏表修改成功");
    }else{
        NSLog(@"收藏表修改失败");
    }
    [database commit];
}

-(BOOL)Collect_IsCollected:(NSInteger)news_id{
    if([self Collect_IsHaveId:news_id]){
        NSString* str_common = [NSString stringWithFormat:@"select * from Collect where newsId='%ld'",news_id];
        NSInteger m_id = -1;
        FMResultSet *rs = [database executeQuery:str_common];
        while ([rs next]) {
            m_id = [rs intForColumn:@"IsCollected"];
        }
        if(m_id == 1){
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

-(BOOL)Collect_IsHaveId:(NSInteger)news_id{
//    if exists( select * from Hong_PageConfig where names='name' )
    NSString* str_common = [NSString stringWithFormat:@"select * from Collect where newsId='%ld'",news_id];
    NSInteger m_id = -1;
    FMResultSet *rs = [database executeQuery:str_common];
    while ([rs next]) {
        m_id = [rs intForColumn:@"IsCollected"];
    }
    [rs close];
    if(m_id == -1){
        return NO;
    }
    return YES;
}

-(void)clearTable_Collect{
    [database beginTransaction];
    NSString* str_common = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@" ,@"Collect"];
    if([database executeUpdate:str_common]){
        NSLog(@"收藏表删除成功");
    }else{
        NSLog(@"收藏表删除失败");
    }
    [database commit];
}

#pragma mark - 浏览记录
/*
 {
 "id":"29",                                          //咨询id
 "title":"同是一部电视剧出来的，现在发展差别这么大!",    //标题
 "description":"",            //描述
 "channel":"1",               //频道
 "source":"Fashion大师",      //来源
 "images":[
 "http://02.imgmini.eastday.com/mobile/20180116/20180116143747_694a8508faa74d3d267579ba3db12e75_1_mwpm_03200403.jpg",
 "http://02.imgmini.eastday.com/mobile/20180116/20180116143747_694a8508faa74d3d267579ba3db12e75_2_mwpm_03200403.jpg",
 "http://02.imgmini.eastday.com/mobile/20180116/20180116143747_694a8508faa74d3d267579ba3db12e75_6_mwpm_03200403.jpg"
 ],
 
 "publish_time":"2018-01-16 14:37:00",   //发布时间
 "view_count":"",
 "comment_num":"",    //评论数
 "collect_count":"",  //收藏数
 "url":"http://39.104.13.61:3389/kl.php?id=29",   //详情页地址
 },
 */
-(void)CreateReadingNewsTabel{
    NSString* str_common = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT,newsId text NOT NULL,title text NOT NULL,description text,channel text NOT NULL,source text NOT NULL,images_one text,images_two text,images_three text,publish_time text,view_count text,comment_num text,collect_count text,url text,isReading text)",ReadingNews];
    
    if([database executeUpdate:str_common]){
        NSLog(@"浏览记录表 创建成功");
    }else{
        NSLog(@"浏览记录表 创建失败");
    }
}

-(void)ReadingNews_insertData:(CJZdataModel*)model{
    [database beginTransaction];
    NSString* str_common = [NSString stringWithFormat:@"insert into %@ (newsId,title,description,channel,source,images_one,images_two,images_three,publish_time,view_count,comment_num,collect_count,url) values ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')" ,ReadingNews,
                            model.ID,
                            model.title,
                            @"description",
                            model.channel,
                            model.source,
                            model.images[0],
                            model.images[1],
                            model.images[2],
                            [[TimeHelper share] getCurrentTime_YYYYMMDD], //这是保存浏览新闻的时间,所以保存当前流浪新闻的时间
                            @"view_count",
                            model.comment_num,
                            model.collect_count,
                            model.url];
    if([database executeUpdate:str_common]){
        NSLog(@"浏览记录表插入成功");
    }else{
        NSLog(@"浏览记录表插入失败");
    }
    [database commit];
}

//增加数据：做多保留100条数据
-(void)AddReadingNews:(CJZdataModel*)model{
    
    if([self ReadingNews_GetCount] == 2*ReadingNewsMaxCount){
        //拿出最后100条数据
        NSArray* array_model = [self ReadingNews_GetLastMaxCountData];
        //清空表 id=1，重新把100条数据放入表中
        [self ReadingNews_clearTable];
        [self ReadingNews_initId];
        for (CJZdataModel* model in array_model) {
            [self ReadingNews_insertData:model];
        }
    }else{
        if(![self ReadingNews_IsAgainData:model]){//是否和最后一条数据重复
            [self ReadingNews_insertData:model];
        }
    }
}

-(NSInteger)ReadingNews_GetCount{
    NSInteger count = 0;
    NSString* str_common = [NSString stringWithFormat:@"select count(*) from %@",ReadingNews];
    FMResultSet *rs = [database executeQuery:str_common];
    count = rs.columnCount;
    [rs close];
    
    return count;
}

-(NSArray*)ReadingNews_GetLastMaxCountData{
    //(newsId,title,description,channel,source,images_one,images_two,images_three ,publish_time text,view_count text,comment_num ,collect_count ,url )
    NSString* str_common = [NSString stringWithFormat:@"select * from %@",ReadingNews];
    FMResultSet *rs = [database executeQuery:str_common];
    if(rs == nil){
        NSLog(@"浏览记录读取最后几条数据失败");
    }
    NSMutableArray* array_model = [[NSMutableArray alloc] init];
    while ([rs next]) {
        // just print out what we've got in a number of formats.
        CJZdataModel* model = [[CJZdataModel alloc]init];
        model.ID = [rs stringForColumn:@"newsId"];
        model.title = [rs stringForColumn:@"title"];
        model.channel = [rs stringForColumn:@"channel"];
        model.source = [rs stringForColumn:@"source"];
        NSMutableArray* img_array = [[NSMutableArray alloc]init];
        NSString* image_one = [rs stringForColumn:@"images_one"];
        [img_array addObject:image_one];
        NSString* image_two = [rs stringForColumn:@"images_two"];
        [img_array addObject:image_two];
        NSString* image_three = [rs stringForColumn:@"images_three"];
        [img_array addObject:image_three];
        model.images = img_array;
        model.publish_time = [rs stringForColumn:@"publish_time"];
        model.comment_num = [rs stringForColumn:@"comment_num"];
        model.collect_count = [rs stringForColumn:@"collect_count"];
        model.url = [rs stringForColumn:@"url"];
        
        [array_model addObject:model];
    }
    [rs close];
    
    //读取最后max条数据
    NSMutableArray* array_tmp = [[NSMutableArray alloc] initWithCapacity:100];
    int count = 1;
    for(int i = (int)(array_model.count-1);i>=0;i--){
        if(count == ReadingNewsMaxCount+1){
            break;
        }
        count++;
        [array_tmp addObject:array_model[i]];
    }
    
    return array_tmp;
}

//去重，不能和最后一条数据重复
-(BOOL)ReadingNews_IsAgainData:(CJZdataModel*)add_model{
    NSString* str_common = [NSString stringWithFormat:@"select * from %@",ReadingNews];
    FMResultSet *rs = [database executeQuery:str_common];
    CJZdataModel* model = [[CJZdataModel alloc]init];
    while ([rs next]) {
        // just print out what we've got in a number of formats.
        model.ID = [rs stringForColumn:@"newsId"];
        model.title = [rs stringForColumn:@"title"];
        model.channel = [rs stringForColumn:@"channel"];
        model.source = [rs stringForColumn:@"source"];
        NSMutableArray* img_array = [[NSMutableArray alloc]init];
        NSString* image_one = [rs stringForColumn:@"images_one"];
        [img_array addObject:image_one];
        NSString* image_two = [rs stringForColumn:@"images_two"];
        [img_array addObject:image_two];
        NSString* image_three = [rs stringForColumn:@"images_three"];
        [img_array addObject:image_three];
        model.images = img_array;
        model.publish_time = [rs stringForColumn:@"publish_time"];
        model.comment_num = [rs stringForColumn:@"comment_num"];
        model.collect_count = [rs stringForColumn:@"collect_count"];
        model.url = [rs stringForColumn:@"url"];
    }
    [rs close];
    
    if([model.ID isEqualToString:add_model.ID]){
        return YES;
    }else{
        return NO;
    }
}

-(void)ReadingNews_clearTable{
    [database beginTransaction];
    NSString* str_common = [NSString stringWithFormat:@"DELETE from %@" ,ReadingNews];
    if([database executeUpdate:str_common]){
        NSLog(@"浏览记录删除成功");
    }else{
        NSLog(@"浏览记录删除失败");
    }
    [database commit];
}

-(void)ReadingNews_initId{
    [database beginTransaction];
    NSString* str_common = [NSString stringWithFormat:@"ALTER TABLE %@ auto_increment='1'" ,ReadingNews];
    if([database executeUpdate:str_common]){
        NSLog(@"浏览记录id设置成功");
    }else{
        NSLog(@"浏览记录id设置失败");
    }
    [database commit];
}

-(void)clearTable_ReadingNews{
    [database beginTransaction];
    NSString* str_common = [NSString stringWithFormat:@"DELETE from %@" ,ReadingNews];
    if([database executeUpdate:str_common]){
        NSLog(@"收藏表删除成功");
    }else{
        NSLog(@"收藏表删除失败");
    }
    [database commit];
}

//
-(void)CreateIsGetIncomeNews_table{
    NSString* str_common = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT,newsId integer NOT NULL,IsGetIncome integer NOT NULL)",GetIncomeNews];
    
    if([database executeUpdate:str_common]){
        NSLog(@"阅读奖励 创建成功");
    }else{
        NSLog(@"阅读奖励 创建失败");
    }
}
-(void)AddGetIncomeNews:(NSString*)newId{
    [database beginTransaction];
    NSString* str_common = [NSString stringWithFormat:@"insert into %@ (newsId, IsGetIncome) values (%ld, %d)" ,GetIncomeNews,[newId integerValue],1];
    if([database executeUpdate:str_common]){
        NSLog(@"阅读奖励插入成功");
    }else{
        NSLog(@"阅读奖励插入失败");
    }
    [database commit];
}
-(BOOL)IsGetIncomeNews:(NSString*)newId{
    NSString* str_common = [NSString stringWithFormat:@"select * from %@ where newsId='%ld'",GetIncomeNews,[newId integerValue]];
    NSInteger m_id = -1;
    FMResultSet *rs = [database executeQuery:str_common];
    while ([rs next]) {
        m_id = [rs intForColumn:@"IsGetIncome"];
    }
    [rs close];
    if(m_id == -1){
        return NO;
    }
    return YES;
}
-(void)clearTable_GetIncomeNews{
    [database beginTransaction];
    NSString* str_common = [NSString stringWithFormat:@"DELETE from %@" ,GetIncomeNews];
    if([database executeUpdate:str_common]){
        NSLog(@"阅读奖励删除成功");
    }else{
        NSLog(@"阅读奖励删除失败");
    }
    [database commit];
}

#pragma mark - 添加频道
-(void)createChannelTable{
    NSString* str_common = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT,title text NOT NULL,ID text NOT NULL)",ChannelTable];
    
    if([database executeUpdate:str_common]){
        NSLog(@"频道表 创建成功");
    }else{
        NSLog(@"频道表 创建失败");
    }
}
-(void)ChannelTable_insetData:(ChannelName*)channelName{
    [database beginTransaction];
    NSString* str_common = [NSString stringWithFormat:@"insert into %@ (title, ID) values ('%@', '%@')" ,ChannelTable,channelName.title,channelName.ID];
    if([database executeUpdate:str_common]){
        NSLog(@"频道表插入成功");
    }else{
        NSLog(@"频道表插入失败");
    }
    [database commit];
}
-(void)ChannelTable_upData:(ChannelName*)channelName{
    [database beginTransaction];
    NSString* str_common = [NSString stringWithFormat:@"UPDATE %@ set ID='%@' where title='%@'" ,ChannelTable,channelName.title,channelName.ID];
    if([database executeUpdate:str_common]){
        NSLog(@"频道表修改成功");
    }else{
        NSLog(@"频道表修改失败");
    }
    [database commit];
}
-(void)ChannelTable_SelecteData:(ChannelName*)channelName{
    NSString* str_common = [NSString stringWithFormat:@"select * from %@ where title = '%@'",ChannelTable,channelName.title];
    FMResultSet *rs = [database executeQuery:str_common];
    while ([rs next]) {
        // just print out what we've got in a number of formats.
        NSLog(@"-->title:%@ ,ID:%@",
              [rs stringForColumn:@"title"],
              [rs stringForColumn:@"ID"]);
    }
    
    [rs close];
}
-(BOOL)ChannelTable_IsHaveTitle:(NSString*)title{
    NSString* str_common = [NSString stringWithFormat:@"select * from %@ where title = '%@'",ChannelTable,title];
    NSString* str_ID = @"";
    FMResultSet *rs = [database executeQuery:str_common];
    while ([rs next]) {
        // just print out what we've got in a number of formats.
        NSLog(@"-->title:%@ ,ID:%@",
              [rs stringForColumn:@"title"],
              [rs stringForColumn:@"ID"]);
        str_ID = [rs stringForColumn:@"ID"];
    }
    [rs close];
    if([str_ID isEqualToString:@""]){
        return NO;
    }
    return YES;
}
-(void)clearTable_Channel{
    [database beginTransaction];
    NSString* str_common = [NSString stringWithFormat:@"DELETE from %@" ,ChannelTable];
    if([database executeUpdate:str_common]){
        NSLog(@"频道删除成功");
    }else{
        NSLog(@"频道删除失败");
    }
    [database commit];
}

@end




