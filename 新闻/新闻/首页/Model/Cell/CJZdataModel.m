//
//  CJZdataModel.m
//  新闻
//
//  Created by chenjinzhi on 2017/12/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CJZdataModel.h"

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

@implementation CJZdataModel

+(NSMutableArray*)jsonArrayToModelArray:(NSArray *)array{
//    NSArray* dic_array = [NSDictionary objectArrayWithKeyValuesArray:array];
    NSMutableArray* model_array = [NSMutableArray array];
    for (int i=0;i<array.count;i++) {
        NSDictionary* dic = array[i];
        CJZdataModel* model = [[CJZdataModel alloc]init];
        model.ID = dic[@"id"];
        model.title = dic[@"title"];
        model.channel = dic[@"channel"];
        model.images = dic[@"images"];
        
//        model.publish_time = dic[@"publish_time"];
        NSNumber* number = [[TimeHelper share] getCurrentTime_number];
        NSString* time = [NSString stringWithFormat:@"%ld",[number longValue]];
        model.publish_time = [[TimeHelper share] GetDateFromString_yyMMDD_HHMMSS:time];
        
        model.source = dic[@"source"];
        model.url = dic[@"url"];
        model.url = [model.url stringByAppendingString:@"&t=2"]; //加 &t=2 区别收到的新闻为ios端
        model.comment_num = dic[@"comment_num"];
        model.collect_count = dic[@"collect_count"];
        [model_array addObject:model];
    }
    
    return model_array;
    
}
/*
 @property (nonatomic,copy)NSString* ID;
 @property (nonatomic,copy)NSString* title;
 
 @property (nonatomic,copy)NSString* channel;
 
 @property (nonatomic,copy)NSArray* images;
 
 @property (nonatomic,copy)NSString* publish_time;
 @property (nonatomic,copy)NSString* comment_num;
 @property (nonatomic,copy)NSString* collect_count;
 @property (nonatomic,copy)NSString* source;
 
 @property (nonatomic,copy)NSString* url;
 
 
 @property (nonatomic,assign)NSInteger imgCount;
 
 @property (nonatomic)BOOL isRreading;//是否阅读过
 @property (nonatomic)BOOL isRreadHere;//是否阅读到这里
 */
+(NSArray *)ArrayModelToDic_top50:(NSArray *)array{
    NSMutableArray* array_model = [NSMutableArray array];
    //取前50条
    if(array.count > 48){
        for (int i=0; i<48; i++) {
            [array_model addObject:array[i]];
        }
        array = array_model;
    }
    
    NSMutableArray* array_dic = [NSMutableArray array];
    for (CJZdataModel* model in array) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setObject:model.ID forKey:@"id"];
        [dic setObject:model.title forKey:@"title"];
        [dic setObject:model.channel forKey:@"channel"];
        [dic setObject:model.images forKey:@"images"];
        [dic setObject:model.publish_time forKey:@"publish_time"];
        [dic setObject:model.comment_num forKey:@"comment_num"];
        [dic setObject:model.collect_count forKey:@"collect_count"];
        [dic setObject:model.source forKey:@"source"];
        [dic setObject:model.url forKey:@"url"];
        if(model.isRreading){
            [dic setObject:@"1" forKey:@"isRreading"];
        }else{
            [dic setObject:@"0" forKey:@"isRreading"];
        }
        
        [array_dic addObject:dic];
    }
    
    return array_dic;
}

+(NSArray *)DicToArrayModel_top50:(NSArray *)array{
    NSMutableArray* mutable_array =  [NSMutableArray array];
    
    for (NSDictionary* dic in array) {
        CJZdataModel* model = [[CJZdataModel alloc] init];
        model.ID = dic[@"id"];
        model.title = dic[@"title"];
        model.channel = dic[@"channel"];
        model.images = dic[@"images"];
        model.publish_time = dic[@"publish_time"];
        model.comment_num = dic[@"comment_num"];
        model.collect_count = dic[@"collect_count"];
        model.source = dic[@"source"];
        model.url = dic[@"url"];
        NSString* str_isReading = dic[@"isRreading"];
        if([str_isReading isEqualToString:@"1"]){
            model.isRreading = YES;
        }else{
            model.isRreading = NO;
        }
        
        [mutable_array addObject:model];
    }
    
    return mutable_array;
}

@end
