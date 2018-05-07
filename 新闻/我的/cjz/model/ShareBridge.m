//
//  ShareBridge.m
//  新闻
//
//  Created by chenjinzhi on 2018/4/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShareBridge.h"

@implementation ShareBridge

-(void)onShare:(NSInteger)index{
    NSLog(@"ShareBridge.share(%ld)",index);
    //1.微信好友 2.朋友圈 3.qq好友 4.qq空间 5.短信
    switch (index) {
        case 1:
            [UMShareHelper ShareName:WeChat_haoyou];
            break;
        case 2:
            [UMShareHelper ShareName:WeChat_pengyoujuan];
            break;
        case 3:
            [UMShareHelper ShareName:QQ_haoyou];
            break;
        case 4:
            [UMShareHelper ShareName:QQ_kongjian];
            break;
        case 5:
            [self.delegate sendMessageWithPhoneNumber:@"" AndMessage:[Login_info share].shareInfo_model.desc];
            break;
            
        default:
            break;
    }
}

@end
