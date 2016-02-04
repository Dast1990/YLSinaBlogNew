//
//  AppDelegate.m
//  YLSinaBlog
//
//  Created by LongMa on 15/11/28.
//  Copyright © 2015年 LongMa. All rights reserved.
//

#import "AppDelegate.h"
#import "YLOAuthViewController.h"

#import "YLAccountTool.h"
#import <SDWebImageManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //    1见
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //    2.设 置根控制器：当前版本号与上次存储的版本号不一致时，显示新特性。
    //    doc中是否有account信息
    YLAccountModel *accountModel = [YLAccountTool account];
    
    if (accountModel) {
        [self.window newFeatureJudgeAndSetRootViewController];
    }else{
        self.window.rootViewController = [[YLOAuthViewController alloc] init];
    }
    
    //    3 显
    [self.window makeKeyAndVisible];
    
    /** 注册（register）iconBadgeNumber权限 */
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0) {
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
        [application registerUserNotificationSettings:setting];
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    /**
     *  app的状态
     *  1.死亡状态：没有打开app
     *  2.前台运行状态
     *  3.后台暂停状态：停止一切动画、定时器、多媒体、联网操作，很难再作其他操作
     *  4.后台运行状态
     */
    // 向操作系统申请后台运行的资格，能维持多久，是不确定的 */
    //???: __block,why
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:bgTask];
    }];
    
    // 在Info.plst中设置 后台模式 ：Required background modes == App plays audio or streams audio/video using AirPlay
    // 搞一个0kb的MP3文件，没有声音
    // 循环播放
    
    // 以前的 后台模式 只有3种
    // 保持网络连接
    // 多媒体应用
    // VOIP:网络电话
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    //    取消所有任务
    [mgr cancelAll];
    //    清理内存
    [mgr.imageCache clearMemory];
}

@end


//@implementation NSURLRequest(DataController)
//
//+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
//{
//    return YES;
//}
//@end

