//
//  AppDelegate.m
//  新闻
//
//  Created by gyh on 15/9/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "TabbarViewController.h"


#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信sdk头文件
#import "WXApi.h"

//新浪微博
#import "WeiboSDK.h"


#import "StartManager.h"
#import "Channel_youLike_ViewController.h"
#import "AppConfig.h"
#import "JsonHelper.h"
#import "TimeHelper.h"

//友盟
//#import <UMCommon/UMCommon.h>
//#import <UMAnalytics/MobClick.h>
//#import <UMShare/UMShare.h>
//#import <UMPush/UMessage.h>
//#import <UMErrorCatch/UMErrorCatch.h>

@interface AppDelegate ()

@property (nonatomic , strong) NSArray *conversations;
@property (nonatomic , strong) TabbarViewController *tabbarMain;

@end

@implementation AppDelegate

- (NSArray *)conversations
{
    if (!_conversations) {
        _conversations = [NSArray array];
    }
    return _conversations;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [IdentifyingCode Register:@"6d5be2f468b82690296c4672bc8a37de"];//验证码注册
    [[MyDataBase shareManager] initialization];//数据库初始化
    //读取用户喜爱的频道
    NSInteger count = 0;
    NSArray* str_json = [[AppConfig sharedInstance] GetChannelNameYouLike];
    if(str_json != nil){
        count = str_json.count;
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    Channel_youLike_ViewController* vc = [[Channel_youLike_ViewController alloc] init];
    self.tabbarMain = [[TabbarViewController alloc]init];
    self.tabbarMain.selectedIndex = 0;
    
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:self.tabbarMain];
    
//    if(count != 0){
    if(YES){ //隐藏第一次的开屏选择界面
        self.window.rootViewController = navi;
    }else{
        self.window.rootViewController = vc;
    }

    [self.window makeKeyAndVisible];
    
    //设置全局状态栏字体颜色为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    

    // U-Share 平台设置
    [self initUM];
    
    //注册一个本地通知
    [self registLocalNoti:application];
    
    //获取未读的消息数
    [self loadConversations];
    
    [StartManager sharedInstance];
    [AppConfig sharedInstance];
    
    NSLog(@"width-->%f",[UIScreen mainScreen].bounds.size.width);
    NSLog(@"hight-->%f",[UIScreen mainScreen].bounds.size.height);
    
    return YES;
}

- (void)selectTabbarIndex11:(int)index
{
//    [self.tabbarMain selectIndex:index];
}

-(void)initUM{
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"5a6ef052f43e4815ed0001ca"];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
}

#pragma mark - 接收到消息
- (void)didReceiveMessages:(NSArray *)aMessages
{
//    [self loadConversations];
//
//    EMMessage *message = aMessages[0];
//    EMTextMessageBody *textBody = (EMTextMessageBody *)message.body;
//    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
//        //发送一个本地通知
//        UILocalNotification *localnoti = [[UILocalNotification alloc]init];
//        localnoti.alertBody = [NSString stringWithFormat:@"gaoyuhang:%@",textBody.text];
//        localnoti.fireDate = [NSDate date];
//        localnoti.soundName = @"default";
//        [[UIApplication sharedApplication]scheduleLocalNotification:localnoti];
//    }
}

#pragma mark - 注册一个本地通知
- (void)registLocalNoti:(UIApplication *)application
{
//    //注册应用接收通知
//    if ([[UIDevice currentDevice].systemVersion doubleValue] > 8.0){
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
//        [application registerUserNotificationSettings:settings];
//    }
}

-(void)loadConversations{

}

- (void)showTabBarBadge{

}

- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}
- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxe8553bf29d72d32d" appSecret:@"52d6aaa1552bbf84ef2d02d72d250223" redirectURL:@"http://mobile.umeng.com/social"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106652821"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
        
       
    }
    return result;
}


-(void)applicationDidEnterBackground:(UIApplication *)application{
    NSLog(@"app进入后台");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppDelegate_SocietyViewCtl" object:nil];
}

-(void)applicationWillEnterForeground:(UIApplication *)application{
    NSLog(@"app将要从后台显示");
}

@end
