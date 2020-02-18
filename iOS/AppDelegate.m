//
//  AppDelegate.m
//  iOS
//
//  Created by keisme on 2018/4/8.
//  Copyright © 2018年 RaoBin. All rights reserved.
//

#import "AppDelegate.h"
#import "MyListViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark 在应用程序加载完毕之后调用
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:1.5];
    
    MyListViewController *myTabBar= [[MyListViewController alloc] init];
    UINavigationController *na=[[UINavigationController alloc] initWithRootViewController:myTabBar];
    na.interactivePopGestureRecognizer.enabled = NO;
    na.navigationBar.barStyle = UIBarStyleBlack;
    na.navigationBarHidden=YES;
    self.window.rootViewController=na;
//    [Bugly startWithAppId:@"8254a07d8f"];
    return YES;
}

#pragma mark 程序失去焦点的时候调用（不能跟用户进行交互了，类似接电话）
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

#pragma mark 当应用程序进入后台的时候调用（点击HOME键）
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

#pragma mark 当应用程序进入前台的时候调用
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

#pragma mark 当应用程序获取焦点的时候调用
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

#pragma mark 程序在某些情况下被终结时会调用这个方法
- (void)applicationWillTerminate:(UIApplication *)application {
}


@end
