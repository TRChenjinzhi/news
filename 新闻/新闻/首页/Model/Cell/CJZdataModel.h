//
//  CJZdataModel.h
//  新闻
//
//  Created by chenjinzhi on 2017/12/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJZdataModel : NSObject
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
 "origin_channel":"4", //新增:channel为推荐[1] origin_channel标识原频道 默认空  相关推荐接口需要传此参数
 },
 */
@property (nonatomic,copy)NSString* ID;
@property (nonatomic,copy)NSString* title;

@property (nonatomic,copy)NSString* channel;// 一般channel he channe_main 相同，但是推荐频道 是各种频道混合的，所以在推荐频道 这两个不同
@property (nonatomic,copy)NSString* origin_channel;

@property (nonatomic,copy)NSArray* images;

@property (nonatomic,copy)NSString* publish_time;
@property (nonatomic,copy)NSNumber* comment_num;
@property (nonatomic,copy)NSString* collect_count;
@property (nonatomic,copy)NSString* source;

@property (nonatomic,copy)NSString* url;

@property (nonatomic,strong)NSString* decr;


@property (nonatomic,assign)NSInteger imgCount;

@property (nonatomic)BOOL isRreading;//是否阅读过
@property (nonatomic)BOOL isRreadHere;//是否阅读到这里


//将json转换为模型数组
+(NSMutableArray*)jsonArrayToModelArray:(NSArray*)array;

+(NSArray*)ArrayModelToDic_top50:(NSArray*)array;
+(NSArray*)DicToArrayModel_top50:(NSArray*)array;

@end
