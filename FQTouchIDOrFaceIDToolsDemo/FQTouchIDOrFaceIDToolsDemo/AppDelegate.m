//
//  AppDelegate.m
//  FQTouchIDOrFaceIDToolsDemo
//
//  Created by owen on 2019/10/17.
//  Copyright © 2019 owen. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    ViewController *mainVC = [[ViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = navVC;
    
    [self.window makeKeyAndVisible];

    return YES;
}




@end
