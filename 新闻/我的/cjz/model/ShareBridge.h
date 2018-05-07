//
//  ShareBridge.h
//  新闻
//
//  Created by chenjinzhi on 2018/4/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <UIKit/UIKit.h>

// 声明与JS交互的协议
@protocol ShareBridgeProtocol <JSExport> // 遵守JSExport协议
// 调用系统分享
- (void)onShare:(NSInteger)index;

@end

// 声明与JS交互的协议
@protocol ShareBridge_PhoneMessate_Protocol

- (void)sendMessageWithPhoneNumber:(NSString*)phonenumber AndMessage:(NSString*)message;

@end

@interface ShareBridge : NSObject<ShareBridgeProtocol>

@property (nonatomic,strong)JSContext *jsContext; //跟js 回调时使用
@property (nonatomic,weak)id delegate;

@end
